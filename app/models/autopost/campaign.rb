# frozen_string_literal: true

EVENT_TYPE = {
  verify: 0,
  create: 1,
  subscribe: 2,
  unsubscribe: 3,
}

class Autopost::Campaign < ActiveRecord::Base
  self.table_name = 'autopost_campaigns'

  validates :provider_id, :source_id, :key, :owner_username, presence: true

  after_save :subscribe_to_notifications
  before_destroy :unsubscribe_to_notifications

  def subscribe_to_notifications
    event = Autopost::YoutubeEvent.create!(
      event_type: EVENT_TYPE[:subscribe],
      data: self.key
    )
    ::Jobs.enqueue(:youtube_event_handler, event_id: event.id)
  end

  def unsubscribe_to_notifications
    event = Autopost::YoutubeEvent.create!(
      event_type: EVENT_TYPE[:unsubscribe],
      data: self.key
    )
    ::Jobs.enqueue(:youtube_event_handler, event_id: event.id)
  end
end
