module Autopost

  EVENT_TYPE = {
    verify: 0,
    create: 1
  }

  class YoutubeWebhookController < ::ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      byebug
      # handle atom notification from pubsubhubbub
      event = YoutubeEvent.create!(
        type: EVENT_TYPE[:create],
        data: request.body.read
      )
      ::Jobs.enqueue(:youtube_event_handler, event)
      render json: { status: 'ok' }
    end

    def index
      # verify pubsubhubbub check
      event = YoutubeEvent.create!(
        type: EVENT_TYPE[:verify],
        data: request.body.read
      )
      #::Jobs.enqueue(:youtube_event_handler, event)
      if params['hub.challenge']
        render plain: params['hub.challenge']
      end
    end
  end
end
