require_dependency 'yt'

module Autopost
  module Youtube
    module Subscriber

      def self.subscribe(key)
        uri = URI('https://pubsubhubbub.appspot.com/subscribe')
        byebug
        data = {
          "hub.callback" => "https://#{Discourse.current_hostname}/autopost/youtube",
          "hub.topic" => "https://www.youtube.com/xml/feeds/videos.xml?channel_id=#{key}",
          "hub.verify" => "sync",
          "hub.mode" => "subscribe",
          "hub.verify_token" => "",
          "hub.secret" => "",
          "hub.lease_seconds" => ""
        }
        byebug
        #res = Net::HTTP.post_form(uri, data)

       # request = Net::HTTP::Get.new(uri)
       # request.add_field 'Authorization', "Bearer #{bearer_token}"
       # response = http(uri).request(request)

       # Net::HTTP.post_form
       # puts res.body
       # puts res.code
      end

      def self.unsubscribe(key)
        uri = URI('https://pubsubhubbub.appspot.com/subscribe')
        byebug
        data = {
          "hub.callback" => "https://#{Discourse.current_hostname}/autopost/youtube",
          "hub.topic" => "https://www.youtube.com/xml/feeds/videos.xml?channel_id=#{key}",
          "hub.verify" => "sync",
          "hub.mode" => "unsubscribe",
          "hub.verify_token" => "",
          "hub.secret" => "",
          "hub.lease_seconds" => ""
        }
        byebug
        #res = Net::HTTP.post_form(uri, data)
        #ßputs res.body
      end

    end
  end
end

require_relative "subscriber.rb"