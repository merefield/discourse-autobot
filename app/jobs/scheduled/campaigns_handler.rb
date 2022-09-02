module Jobs
  class CampaignsHandler < ::Jobs::Scheduled
    every 10.minutes

    sidekiq_options retry: false

    def execute(args)
      campaigns = ::autopost::Campaign.list

      campaigns.each do |c|
        if c["last_polled_at"].present?
          polling_interval = Integer(c["polling_interval"].presence || "60").minutes
          last_polled_at = c["last_polled_at"]

          next if Time.parse(last_polled_at) + polling_interval > Time.now
        end

        case c["source_id"]
          when "1" # YouTube Channel
            ::Jobs.enqueue(:poll_youtube_channel, campaign_id: c["id"])
          when "2" # Website Feed
            ::Jobs.enqueue(:poll_website_feed, campaign_id: c["id"])
          when "3" # Twitter User Timeline
            ::Jobs.enqueue(:poll_twitter_user, campaign_id: c["id"])
        end
      end
    end
  end
end