# frozen_string_literal: true

require_dependency 'yt'

module Jobs
  class PollYoutubeChannel < ::Jobs::Base

    def execute(campaign)
      Autobot::Youtube::Provider.configure
      last_polled_at = campaign[:last_polled_at]

      channel = ::Yt::Channel.new id: campaign[:key]

      video_array = []
      videos = channel.videos

      if SiteSetting.autobot_max_history_in_days > 0
        if Time.now - SiteSetting.autobot_max_history_in_days.days > last_polled_at
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
