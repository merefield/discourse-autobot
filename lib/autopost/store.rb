module Autopost
  class Store
    def self.set(key, value)
      ::PluginStore.set(Autopost::PLUGIN_NAME, key, value)
    end

    def self.get(key)
      ::PluginStore.get(Autopost::PLUGIN_NAME, key)
    end

    def self.remove(key)
      ::PluginStore.remove(Autopost::PLUGIN_NAME, key)
    end
  end
end
