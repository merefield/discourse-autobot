# frozen_string_literal: true
class Autopost::Campaign < ActiveRecord::Base
  self.table_name = 'autopost_campaigns'

  validates :provider_id, :source_id, :key, :owner_username, presence: true
  
  validate :campaign_name_if_youtube

  after_save :subscribe_to_notifications

  def campaign_name_if_youtube
    if provide_id = 1 && channel_name.blank?
      errors.add(channel_name, "new campaign must include channel name")
    end
  end

  def subscribe_to_notifications
    ::Jobs.enqueue(:youtube_subscribe, self)
  end
end