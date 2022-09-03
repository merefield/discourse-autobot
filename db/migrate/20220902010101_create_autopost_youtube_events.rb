# frozen_string_literal: true

class CreateAutopostYoutubeEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :autopost_youtube_events do |t|
      t.integer "event_type", null: false
      t.integer "state", default: 0
      t.text "data"

      t.timestamps
    end
  end
end