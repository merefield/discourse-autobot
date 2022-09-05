module Jobs
  class CampaignsHandler < ::Jobs::Scheduled
    every 12.hours

    sidekiq_options retry: false

    def execute(args)
      campaigns = ::Autopost::Campaign.all

      campaigns.each do |c|
          
        if ["2","3"].include?(c["source_id"]) && c["last_polled_at"].present?
          polling_interval = Integer(c["polling_interval"].presence || "60").minutes
          last_polled_at = c["last_polled_at"]

          next if Time.parse(last_polled_at) + polling_interval > Time.now
        end

        case c["source_id"]
          when "1" # YouTube Channel
            if c("subscription_expiration_time").present?
              refresh_from = c["subscription_expiration_time"] - 24.hours
              if Time.now > refresh_from
                event = Autopost::YoutubeEvent.create!(
                  event_type: EVENT_TYPE[:subscribe],
                  data: c["key"]
                )
                ::Jobs.enqueue(:youtube_event_handler, event_id: event.id)
              end
            end
          when "2" # Website Feed
            ::Jobs.enqueue(:poll_website_feed, campaign_id: c["id"])
          when "3" # Twitter User Timeline
            ::Jobs.enqueue(:poll_twitter_user, campaign_id: c["id"])
        end
      end
    end
  end
end