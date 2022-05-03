module Autobot
  module Jobs
    class Base < ::Jobs::Base

      def execute(args)
        @campaign = Autobot::Campaign.find(args[:campaign_id])

        success = poll(@campaign)
        
        if success
          @campaign["last_polled_at"] = Time.now.to_s
          Autobot::Campaign.update(@campaign)
        end
      end

      def poll(campaign)
        raise "Overwrite me!"
      end

    end
  end
end


require_relative "scheduled/campaigns_handler.rb"

require_relative "regular/poll_twitter_user.rb"
require_relative "regular/poll_website_feed.rb"
require_relative "regular/poll_youtube_channel.rb"
