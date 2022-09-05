# frozen_string_literal: true
class Autopost::SubscriptionEvent < ActiveRecord::Base
  self.table_name = 'autopost_subscription_events'

  validates :event_type, presence: true
end
