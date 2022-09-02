# name: autopost
# about: Automatic content creator bot for Discourse
# version: 0.3
# authors: Vinoth Kannan (@vinothkannans), Robert Barrow (@merefield)
# url: https://github.com/merefield/discourse-autopost

gem 'yt-support', '0.1.3', { require: false }
gem 'yt', '0.33.4', { require: false }
gem 'simple-rss', '1.3.3', { require: false }

enabled_site_setting :autopost_enabled

register_asset "stylesheets/admin/autopost.scss", :admin

after_initialize do
  register_seedfu_fixtures(Rails.root.join("plugins", "discourse-autopost", "db", "fixtures").to_s)

  [
    '../lib/twitter_api.rb',
    '../lib/autopost/store.rb',
    '../lib/autopost/campaign.rb',
    '../lib/autopost/post_creator.rb',
    '../lib/autopost/provider.rb',
    '../app/controllers/campaigns.rb',
    '../app/controllers/youtube_webhook.rb',
    '../app/jobs/base.rb',
    '../app/jobs/regular/youtube_event_handler.rb'
  ].each { |path| load File.expand_path(path, __FILE__) }

  module ::Autopost
    PLUGIN_NAME = "autopost".freeze

    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace Autopost
    end

    USER_ID ||= -3

    def self.user
      @user ||= User.find_by(id: USER_ID)
    end
  end

  require_dependency 'staff_constraint'

  Autopost::Engine.routes.draw do
    get "/youtube" => "youtube_webhook#index"
    post "/youtube" => "youtube_webhook#create"
    get "/campaigns" => "campaigns#list", constraints: StaffConstraint.new
    post "/campaigns" => "campaigns#create", constraints: StaffConstraint.new
    put "/campaigns" => "campaigns#update", constraints: StaffConstraint.new
    delete "/campaigns" => "campaigns#delete", constraints: StaffConstraint.new
  end

  Discourse::Application.routes.prepend do
    mount Autopost::Engine, at: "/autopost"
  end

  add_admin_route "autopost.title", "autopost"

  Discourse::Application.routes.append do
    get "/admin/plugins/autopost" => "admin/plugins#index", constraints: StaffConstraint.new
    get "/admin/plugins/autopost/:page" => "admin/plugins#index", constraints: StaffConstraint.new
  end
end
