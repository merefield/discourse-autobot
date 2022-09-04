require_dependency 'yt'

module Autopost
  module Youtube
    module Subscriber

      def self.subscribe(key)
        uri = URI('https://pubsubhubbub.appspot.com/subscribe')
        
        data = {
          "hub.callback" => "https://#{Discourse.current_hostname}/autopost/youtube_webhook",
          "hub.topic" => "https://www.youtube.com/xml/feeds/videos.xml?channel_id=#{key}",
          "hub.verify" => "sync",
          "hub.mode" => "subscribe",
          "hub.verify_token" => "",
          "hub.secret" => "",
          "hub.lease_seconds" => ""
        }
        res = Net::HTTP.post_form(uri, data)

       # request = Net::HTTP::Get.new(uri)
       # request.add_field 'Authorization', "Bearer #{bearer_token}"
       # response = http(uri).request(request)

       # Net::HTTP.post_form
       # puts res.body
       # puts res.code
      end

      def self.unsubscribe(key)
        uri = URI('https://pubsubhubbub.appspot.com/subscribe')
        data = {
          "hub.callback" => "https://#{Discourse.current_hostname}/autopost/youtube_webhook",
          "hub.topic" => "https://www.youtube.com/xml/feeds/videos.xml?channel_id=#{key}",
          "hub.verify" => "sync",
          "hub.mode" => "unsubscribe",
          "hub.verify_token" => "",
          "hub.secret" => "",
          "hub.lease_seconds" => ""
        }
        res = Net::HTTP.post_form(uri, data)
        #ßputs res.body
      end

      def self.refresh_status(key)
        uri = URI('https://pubsubhubbub.appspot.com/subscription-details')
        params = {
          "hub.callback" => "https://#{Discourse.current_hostname}/autopost/youtube_webhook",
          "hub.topic" => "https://www.youtube.com/xml/feeds/videos.xml?channel_id=#{key}"
        }
        uri.query = URI.encode_www_form(params)
        res = Net::HTTP.get(uri)
        state = "Unknowwn"
        expiration_time = nil
        campaign = Autopost::Campaign.find_by(key: key)
        #if res.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(res)
        doc.css('dt').each do |dt|
          case dt.text
          when "State"
            state = dt.next_element.text
            campaign.subscription_state = state
          when "Expiration time"
            expiration_time = dt.next_element.text
            campaign.subscription_expiration_time = expiration_time
          end
        end
        campaign.save
        pp '=========='
        pp campaign.subscription_state
        pp campaign.subscription_expiration_time
        pp '=========='
        #end
      end
    end
  end
end

require_relative "subscriber.rb"