# frozen_string_literal: true

require_dependency 'yt'

module Jobs

  STATE = {
    pending: 0,
    started: 1,
    succeeded: 2,
    failed: 3
  }

  class YoutubeEventHandler < ::Jobs::Base

    sidekiq_options retry: false

    def execute(event)
      event.update(state: STATE[:started])

      data_hash = Hash.from_xml(event.data)

      @campaign = Autopost::Campaign.find(key: data_hash[:feed][:entry][:channelId])

      video_id = data_hash[:feed][:entry][:videoId]

      Autopost::Youtube::Provider.configure

      begin
        channel = ::Yt::Channel.new id: @campaign["key"]
        @campaign["channel_name"] = channel.title

        if @campaign["tag_channel"] == "true"
          tagified = channel.title.downcase.gsub(" ", "-")
          if @campaign["default_tags"].blank?
            @campaign["default_tags"] = tagified
          elsif !@campaign["default_tags"].split(",").include?(tagified)
            @campaign["default_tags"] = @campaign["default_tags"] + "," + tagified
          end
        end

        Autopost::Campaign.update(@campaign)

        videos = channel.videos

        yt_video = videos.where(id: video_id).first

        unless !campaign["title_keyword_filter"].blank? && (!CGI.unescapeHTML(yt_video.snippet.title).downcase.include? campaign["title_keyword_filter"].downcase)
          video_hash = {
            :id => yt_video.id,
            :title => CGI.unescapeHTML(yt_video.snippet.title),
            :description =>  CGI.unescapeHTML(yt_video.snippet.description),
            :published_at => yt_video.published_at
          }

          creator = Autopost::Youtube::PostCreator.new(campaign, video_hash)
          creator.create!
        end

        event.update(state: STATE[:succeeded])
      rescue => e
        Rails.logger.error "ERROR: a problem occurred in the YouTube even handler job: #{e}"
        event.update(state: STATE[:failed])
      end
    end
  end
end
