# frozen_string_literal: true
class Autopost::YoutubeEvents < ActiveRecord::Base
  self.table_name = 'autopost_youtube_events'

  validates :type, presence: true
end
