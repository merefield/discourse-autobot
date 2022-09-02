# frozen_string_literal: true

class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.integer "provider_id", null: false
      t.integer "source_id", null: false
      t.integer "topic_id",
      t.integer "category_id", 
      t.integer "polling_interval", default: 1000
      t.string "channel_name", null: false
      t.string "key", null: false
      t.boolean "include_description", default: false
      t.string "title_keyword_filter",
      t.string "default_tags",
      t.boolean "tag_channel", default: false
      t.string "owner_username", null: false
      t.string "default_tags", null: false
      t.datetime "last_polled_at",
      t.string "last_poll_outcome",
      t.integer "last_poll_count", default: 0

      t.timestamps
    end
  end
end
