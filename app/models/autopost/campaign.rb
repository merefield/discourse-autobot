# frozen_string_literal: true
class Autopost::Campaign < ActiveRecord::Base
  self.table_name = 'autopost_campaigns'

  validates :provider_id, :source_id, :key, :owner_username presence: true
  
  validate :campaign_id_if_youtube
  validate :campaign_name_if_youtube

  def campaign_id_if_youtube
    if provide_id = 1 && channel_id.blank?
      errors.add(channel_id, "new campaign must include channel id")
    end
  end

  def campaign_name_if_youtube
    if provide_id = 1 && channel_name.blank?
      errors.add(channel_name, "new campaign must include channel name")
    end
  end

end