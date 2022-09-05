module Autopost
  module Youtube
    class PostVideo

      def self.post_video(data)

        data_hash = Hash.from_xml(data)
        entry = data_hash["feed"]["entry"]

        @campaign = Autopost::Campaign.find_by(key: entry["channelId"])
  
        video_id = entry["videoId"]
  
        Autopost::Youtube::Provider.configure
        channel = ::Yt::Channel.new id: @campaign["key"]

        @campaign["channel_name"] = channel.title

        if @campaign["tag_channel"] == "true"
          tagified = channel.title.downcase.gsub(" ", "-")
          if @campaign["default_tags"].blank?
            @campaign["default_tags"] = tagified
          elsif !@campaign["default_tags"].split(",").include?(tagified)
            @campaign["default_tags"] = @campaign["default_tags"] + "," + tagified
          end
        end

        @campaign.save!

        yt_video = ::Yt::Video.new id: video_id

        unless !@campaign["title_keyword_filter"].blank? && (!CGI.unescapeHTML(yt_video.snippet.title).downcase.include? campaign["title_keyword_filter"].downcase)
          video_hash = {
            :id => yt_video.id,
            :title => CGI.unescapeHTML(yt_video.snippet.title),
            :description =>  CGI.unescapeHTML(yt_video.snippet.description),
            :published_at => yt_video.published_at
          }

          creator = Autopost::Youtube::PostCreator.new(@campaign, video_hash)
          creator.create!
        end
      end
    end
  end
end