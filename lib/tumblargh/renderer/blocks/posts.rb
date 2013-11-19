module Tumblargh
  module Renderer
    module Blocks
      # Posts Loop
      #
      # {block:Posts} is executed once for each post. Some post related tags can
      # exist outside of a `type` block, such as {Title} or {Permalink}, so
      # they should be defined here
      class Posts < Base

        contextual_tag :post_id, :id
        contextual_tag :post_type, :type
        contextual_tag :title
        contextual_tag :tags_as_classes
        contextual_tag :caption

        def permalink
          url_path(context.post_url)
        end

        def perma
          url_path(context.url)
        end

        def permalink?
          context.permalink?
        end

        def post_notes_url
          # http://bikiniatoll.tumblr.com/notes/1377511430/vqS0xw8sm
          "/notes/#{context.id}/"
        end

        def reblog_url
          "/reblog/#{context.reblog_key}"
        end

        # An HTML class-attribute friendly list of the post's tags.
        # Example: "humor office new_york_city"
        #
        # By default, an HTML friendly version of the source domain of imported
        # posts will be included. This may not behave as expected with feeds
        # like Del.icio.us that send their content URLs as their permalinks.
        # Example: "twitter_com", "digg_com", etc.
        #
        # The class-attribute "reblog" will be included automatically if the
        # post was reblogged from another post.
        def tags_as_classes
          context.tags.map do |tag|
            tag.name.titlecase.gsub(/\s+/, '').underscore.downcase
          end.join " "
        end

        def post_for_permalink
          link = perma
          context.posts.detect { |post| post.post_url.include?(link) }
        end

        def post_author_portrait_url(size)
          "http://placekitten.com/#{size}/#{size}"
        end

        def post_author_name
          "Daniel Day-Lewis"
        end

        def post_author_url
          "http://fban.tumblr.com"
        end

        def reblog_button
          '<a href="http://www.tumblr.com/reblog/64239114145/8jhxyfBJ" class="reblog_button" style="display: block;width:20px;height: 20px;display: block;"><svg width="100%" height="100%" viewBox="0 0 537 512" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" fill="#ccc"><path d="M 98.893,177.139c0.00-7.462, 4.826-12.275, 12.288-12.275L 405.12,164.864 l0.00,83.469 l 118.72-120.947L 405.12,8.678l0.00,81.51 L 49.382,90.189 c-15.206,0.00-27.648,12.429-27.648,27.648l0.00,171.814 l 77.146-71.603L 98.88,177.139 z M 438.874,332.646c0.00,7.45-4.826,12.275-12.275,12.275L 123.75,344.922 l0.00-83.469 l-116.506,120.922l 116.506,120.947l0.00-81.498 l 356.864,0.00 c 15.206,0.00, 27.648-12.454, 27.648-27.648L 508.262,220.134 l-69.402,71.59L 438.861,332.646 z"></path></svg></a>'
        end

        def like_button
          '<div class="like_button" data-post-id="64239114145" id="like_button_64239114145"><iframe id="like_iframe_64239114145" src="http://assets.tumblr.com/assets/html/like_iframe.html?_v=f55b209dcbe59a18a8171512f8af09d1#name=threedrops&amp;post_id=64239114145&amp;rk=8jhxyfBJ" scrolling="no" width="20" height="20" frameborder="0" class="like_toggle" allowtransparency="true"></iframe></div>'
        end

        def render
          if context.is_a? Resource::Post
            super
          else
            posts = permalink? ? [post_for_permalink || content.posts.first] : context.posts

            posts.map do |post|
              post.context = self
              self.class.new(node, post).render
            end.flatten.join('')
          end
        end

        private

          def url_path(url="")
            url.gsub(/^http:\/\/[^\/]+/, '')
          end

      end
    end
  end
end
