module Autopost
  module Jobs
    class Base < ::Jobs::Base

      def execute(args)
        @campaign = Autopost::Campaign.find(args[:campaign_id])

        result = poll(@campaign)
        
        if result[:success]
          @campaign["last_poll_outcome"] = I18n.t("autopost.jobs.status.success")
          @campaign["last_polled_at"] = Time.now.to_s
          @campaign["last_poll_count"] = result[:count]
        else
          @campaign["last_poll_outcome"] = I18n.t("autopost.jobs.status.failure")
          @campaign["last_poll_count"] = result[:count]
        end

        Autopost::Campaign.update(@campaign)
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
