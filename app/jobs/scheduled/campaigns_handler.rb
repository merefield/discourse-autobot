module Jobs
  class CampaignsHandler < ::Jobs::Scheduled
    every 12.hours

    sidekiq_options retry: false

    def execute(args)
      campaigns = ::Autopost::Campaign.all

      campaigns.each do |c|
        if c("subscription_expiration_time").present?
          refresh_from = c["subscription_expiration_time"] - 24.hours
          if Time.now > refresh_from
            event = Autopost::SubscriptionEvent.create!(
              event_type: EVENT_TYPE[:subscribe],
              data: c["key"]
            )
            ::Jobs.enqueue(:youtube_event_handler, event_id: event.id)
          end
        end
      end
      
    end
  end
end