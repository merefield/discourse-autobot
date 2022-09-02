# frozen_string_literal: true

require 'open-uri'

module Jobs
  class PollWebsiteFeed < ::Jobs::Base

    sidekiq_options retry: false

    def poll(campaign)
      @feed_url = campaign[:key]
      last_polled_at = campaign[:last_polled_at]

      rss = fetch_rss

      if rss.present?
        if last_polled_at.present?
          build_date = rss.channel.lastBuildDate || rss.channel.pubDate
          return if build_date.present? && build_date < last_polled_at
        end

        rss.items.reverse_each do |i|
          creator = Autopost::Website::PostCreator.new(campaign, i)
          creator.create!
        end
      end
    end

    private

      def fetch_rss
        SimpleRSS.parse open(@feed_url, allow_redirections: :all)
      rescue OpenURI::HTTPError, SimpleRSSError
        nil
      end

  end
end
