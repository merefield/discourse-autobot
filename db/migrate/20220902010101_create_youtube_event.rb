# frozen_string_literal: true

class CreateYoutubeEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :youtube_events do |t|
      t.integer "type", null: false
      t.integer "state", default: 0
      t.integer "topic_id",
      t.text "data"

      t.timestamps
    end
  end
end