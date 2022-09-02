# frozen_string_literal: true
class Autopost::Campaign < ActiveRecord::Base
  self.table_name = 'autopost_youtube_events'

  validates :type  presence: true
end
