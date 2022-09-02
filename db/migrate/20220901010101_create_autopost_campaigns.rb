# frozen_string_literal: true

class CreateAutopostCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :autpost_campaigns do |t|
      t.integer "provider_id", null: false
      t.integer "source_id", null: false
      t.integer "topic_id", default: null
      t.integer "category_id", default: null
      t.string "key", null: false
      t.string "channel_name", null: false
      t.integer "polling_interval", default: 1000
      t.boolean "include_description", default: false
      t.string "title_keyword_filter", default: null
      t.string "default_tags", default: null
      t.boolean "tag_channel", default: false
      t.string "owner_username", null: false
      t.string "default_tags", null: false
      t.datetime "subscription_requested", default: null
      t.datetime "subscription_request_acknowledged", default: null
      t.datetime "subscription_last_received", default: null
      t.string "last_video_id", default: null
      t.datetime "last_polled_at", default: null
      t.string "last_poll_outcome", default: null
      t.integer "last_poll_count", default: 0

      t.timestamps
    end
  end
end
