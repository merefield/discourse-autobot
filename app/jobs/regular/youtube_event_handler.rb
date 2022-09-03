# frozen_string_literal: true

require_dependency 'yt'

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
    succeeded: 2,
    failed: 3
  }

  class YoutubeEventHandler < ::Jobs::Base

    sidekiq_options retry: false

    def execute(event)
      byebug
      begin
        event.update(state: STATE[:in_progress])

        case event.type
        when EVENT_TYPE[:create]
          ::Autopost::Youtube::PostVideo.post_video(data)
        when EVENT_TYPE[:subscribe]
          ::Autopost::Youtube::Subscriber.subscribe(data)
        when EVENT_TYPE[:unsubscribe]
          ::Autopost::Youtube::Subscriber.unsubscribe(data)
        end

        event.update(state: STATE[:succeeded])
      rescue => e
        Rails.logger.error "ERROR: a problem occurred in the YouTube event handler job: #{e}"
        event.update(state: STATE[:failed])
      end
    end
  end
end
