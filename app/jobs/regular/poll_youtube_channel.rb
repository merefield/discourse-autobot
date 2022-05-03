# frozen_string_literal: true

require_dependency 'yt'

module Jobs
  class PollYoutubeChannel < Autobot::Jobs::Base

    sidekiq_options retry: false

    def poll(campaign)
      Autobot::Youtube::Provider.configure
      last_polled_at = campaign["last_polled_at"]


      begin
        channel = ::Yt::Channel.new id: campaign["key"]
        @campaign = Autobot::Campaign.find(campaign["id"])
        @campaign["channel_name"] = channel.title

        if @campaign["tag_channel"] == "true"
          tagified = channel.title.downcase.gsub(" ", "-")
          if @campaign["default_tags"].blank?
            @campaign["default_tags"] = tagified
          elsif !@campaign["default_tags"].split(",").include?(tagified)
            @campaign["default_tags"] = @campaign["default_tags"] + "," + tagified
          end
        end
        Autobot::Campaign.update(@campaign)

        video_array = []
        videos = channel.videos

        if SiteSetting.autobot_max_history_in_days && SiteSetting.autobot_max_history_in_days > 0
          if last_polled_at
            if Time.now - SiteSetting.autobot_max_history_in_days.days > Time.parse(last_polled_at)
              last_polled_at = (Time.now - SiteSetting.autobot_max_history_in_days.days).to_s
            end
          else
            last_polled_at = (Time.now - SiteSetting.autobot_max_history_in_days.days).to_s
          end
        end

        videos = videos.where(publishedAfter: Time.parse(last_polled_at).iso8601) if last_polled_at.present?

        videos.each do |yt_video|
          next if !campaign["title_keyword_filter"].blank? && (!CGI.unescapeHTML(yt_video.snippet.title).downcase.include? campaign["title_keyword_filter"].downcase)
          video_array.push({
            :id => yt_video.id,
            :title => CGI.unescapeHTML(yt_video.snippet.title),
            :description =>  CGI.unescapeHTML(yt_video.snippet.description),
            :published_at => yt_video.published_at
          })
        end

        video_array.sort! { |a,b| b[:published_at] <=> a[:published_at] }

        video_array.each do |video|
          creator = Autobot::Youtube::PostCreator.new(campaign, video)
          creator.create!
        end

        return true
      rescue => e
        Rails.logger.error "ERROR: a problem occurred in the YouTube retrieve job: #{e}"
        return false
      end
    end
  end
end
