module autopost
  module Youtube
    class PostCreator < autopost::PostCreator

      def initialize(campaign, yt_video)
        super(campaign)
        @video = yt_video
      end

      def title
        @video[:title]
      end

      def content
        if campaign[:include_description] == "true"
          %{https://www.youtube.com/watch?v=#{@video[:id]}\n\n"#{@video[:description]}"}
        else
          %{https://www.youtube.com/watch?v=#{@video[:id]}}
        end
      end

      def source_url
        "https://www.youtube.com/watch?v=#{@video[:id]}"
      end

    end
  end
end
