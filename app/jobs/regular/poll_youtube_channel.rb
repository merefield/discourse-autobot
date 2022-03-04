# frozen_string_literal: true

require_dependency 'yt'

module Jobs
  class PollYoutubeChannel < Autobot::Jobs::Base

    sidekiq_options retry: false

    def poll(campaign)
      Autobot::Youtube::Provider.configure
      last_polled_at = campaign["last_polled_at"]

      channel = ::Yt::Channel.new id: campaign["key"]
      @campaign = Autobot::Campaign.find(campaign["id"])
      @campaign["channel_name"] = channel.title
      Autobot::Campaign.update(@campaign)

      video_array = []
      videos = channel.videos

      if SiteSetting.autobot_max_history_in_days && SiteSetting.autobot_max_history_in_days > 0
        if last_polled_at
          if Time.now - SiteSetting.autobot_max_history_in_days.days > last_polled_at
            last_polled_at = Time.now - SiteSetting.autobot_max_history_in_days.days
          end
        else
          last_polled_at = Time.now - SiteSetting.autobot_max_history_in_days.days
        end
      end

      videos = videos.where(publishedAfter: last_polled_at.iso8601) if last_polled_at.present?

      videos.each do |yt_video|
        video_array.push({
          :id => yt_video.id,
          :title => yt_video.snippet.title,
          :description =>  yt_video.snippet.description,
          :published_at => yt_video.published_at
        })
      end

      video_array.sort! { |a,b| b[:published_at] <=> a[:published_at] }

      video_array.each do |video|
        creator = Autobot::Youtube::PostCreator.new(campaign, video)
        creator.create!
      end
    end
  end
end
