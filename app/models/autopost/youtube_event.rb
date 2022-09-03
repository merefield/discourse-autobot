# frozen_string_literal: true
class Autopost::YoutubeEvent < ActiveRecord::Base
  self.table_name = 'autopost_youtube_events'

  validates :event_type, presence: true
end
