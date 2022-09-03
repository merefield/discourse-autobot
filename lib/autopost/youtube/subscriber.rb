require_dependency 'yt'

module Autopost
  module Youtube
    module Subscriber

      def self.subscribe(campaign)
        uri = URI('https://pubsubhubbub.appspot.com/subscribe')
       
        data = {
          "hub.callback" => "https://#{Discourse.current_hostname}/autopost/youtube",
          "hub.topic" => "https://www.youtube.com/xml/feeds/videos.xml?channel_id=#{campaign.key}",
          "hub.verify" => "sync",
          "hub.mode" => "subscribe",
          "hub.verify_token" => "",
          "hub.secret" => "",
          "hub.lease_seconds" => ""
        }
        byebug
        #res = Net::HTTP.post_form(uri, data)
        puts res.body
      end

      def self.unsubscribe(campaign)

      end

    end
  end
end

require_relative "subscriber.rb"