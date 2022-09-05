# frozen_string_literal: true

module Jobs

  EVENT_TYPE = {
    verify: 0,
    create: 1,
    subscribe: 2,
    unsubscribe: 3,
  }
  
  STATE = {
    pending: 0,
    in_progress: 1,
    failed: 2,
    succeeded: 3
  }

  class SubscriptionEventHandler < ::Jobs::Base

    sidekiq_options retry: false

    def execute(args)
      begin
        event_id = args[:event_id]

        event = ::Autopost::SubscriptionEvent.find_by(id: event_id)

        event.update(state: STATE[:in_progress])

        case event.event_type
        when EVENT_TYPE[:create]
          ::Autopost::Youtube::PostVideo.post_video(event.data)
        when EVENT_TYPE[:verify]
          ::Autopost::Youtube::Subscriber.refresh_status(event.data)
        when EVENT_TYPE[:subscribe]
          ::Autopost::Youtube::Subscriber.subscribe(event.data)
        when EVENT_TYPE[:unsubscribe]
          ::Autopost::Youtube::Subscriber.unsubscribe(event.data)
        end

        event.update(state: STATE[:succeeded])
      rescue => e
        Rails.logger.error "ERROR: a problem occurred in the YouTube event handler job: #{e}"
        event.update(state: STATE[:failed])
      end
    end
  end
end
