require_dependency 'application_controller'

module Autopost
  class CampaignsController < ::ApplicationController

    def list
      render json: Autopost::Campaign.all
    end

    def create
      Autopost::Campaign.create(campaign_params.except(:id))

      render json: success_json
    end

    def update
      @campaign = Autopost::Campaign.find(params[:id])
      @campaign.update(campaign_params)

      render json: success_json
    end

    def delete
      params.permit(:id, :format)
      Autopost::Campaign.destroy(params[:id].to_i)
      
      render json: success_json
    end

    private

      def campaign_params
        params.permit(:id, :provider_id, :source_id, :topic_id, :category_id, :key, :channel_name, :channel_id, :include_description, :title_keyword_filter, :default_tags, :tag_channel, :owner_username)
      end

  end
end
