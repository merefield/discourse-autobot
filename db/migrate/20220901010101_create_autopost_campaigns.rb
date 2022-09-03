# frozen_string_literal: true

class CreateAutopostCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :autopost_campaigns do |t|
      t.integer "provider_id", null: false
      t.integer "source_id", null: false
      t.integer "topic_id", default: nil
      t.integer "category_id", default: nil
      t.string "key", null: false
      t.string "channel_name", default: nil
      t.integer "polling_interval", default: 1000
      t.boolean "include_description", default: false
      t.string "title_keyword_filter", default: nil
      t.string "default_tags", default: nil
      t.boolean "tag_channel", default: false
      t.string "owner_username", null: false
      t.datetime "subscription_requested", default: nil
      t.datetime "subscription_request_acknowledged", default: nil
      t.datetime "subscription_last_received", default: nil
      t.string "last_video_id", default: nil
      t.datetime "last_polled_at", default: nil
      t.string "last_poll_outcome", default: nil
      t.integer "last_poll_count", default: 0

      t.timestamps
    end
  end
end
