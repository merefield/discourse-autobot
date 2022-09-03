module Autopost
  class Campaign_deprecated
    KEY = 'campaign'.freeze
    LIST_SORT = 'channel_name'.freeze

    def self.list
      Autopost::Store.get(KEY).sort_by! { |k| k[LIST_SORT] } || []
    end

    def self.set(value)
      Autopost::Store.set(KEY, value)
    end

    def self.create(value)
      data = list
      value["id"] = SecureRandom.uuid
      value["last_polled_at"] = nil

      data.push(value)
      set(data)

      value["id"]
    end

    def self.update(value)
      data = list

      index = data.index do |i|
        i["id"] == value["id"]
      end

      return unless index

      data[index].merge!(value.except(:id))
      set(data)

      value["id"]
    end

    def self.delete(id)
      data = list

      data.delete_if do |i|
        i['id'] == id
      end

      set(data)
    end

    def self.find(id)
      data = list

      index = data.index do |i|
        i["id"] == id
      end

      return unless index

      data[index]
    end
  end
end
