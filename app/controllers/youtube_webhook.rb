module Autopost

  EVENT_TYPE = {
    verify: 0,
    create: 1,
    subscribe: 2,
    unsubscribe: 3,
  }

  class YoutubeWebhookController < ::ApplicationController
    # skip_before_action :verify_authenticity_token
    skip_before_action :check_xhr

    def create
      # handle atom notification from pubsubhubbub
      event = Autopost::YoutubeEvent.create!(
        event_type: EVENT_TYPE[:create],
        data: request.body.read
      )
      ::Jobs.enqueue(:youtube_event_handler,  event_id: event.id)
      render json: { status: 'ok' }
    end

    def index
      # verify pubsubhubbub check
      event = Autopost::YoutubeEvent.create!(
        event_type: EVENT_TYPE[:verify],
        data: params["hub.topic"].partition('channel_id=').last
      )
      ::Jobs.enqueue(:youtube_event_handler, event_id: event.id)
      if params['hub.challenge']
        render plain: params['hub.challenge'], :status => 200 
      end
    end
  end
end
