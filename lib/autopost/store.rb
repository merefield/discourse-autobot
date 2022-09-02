module autopost
  class Store
    def self.set(key, value)
      ::PluginStore.set(autopost::PLUGIN_NAME, key, value)
    end

    def self.get(key)
      ::PluginStore.get(autopost::PLUGIN_NAME, key)
    end

    def self.remove(key)
      ::PluginStore.remove(autopost::PLUGIN_NAME, key)
    end
  end
end
