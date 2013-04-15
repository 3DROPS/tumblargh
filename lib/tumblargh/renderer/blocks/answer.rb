module Tumblargh
  module Renderer
    module Blocks
      class Answer < Post
        contextual_tag :question
        contextual_tag :answer

        def asker
          if asking_name == 'anonymous'
            'Anonymous'
          else
            "<a href='#{asking_url}'>#{asking_name}</a>"
          end
        end

        def asker_portrait_url(size)
          "http://assets.tumblr.com/images/default_avatar_#{size}.gif"
        end
      end
    end
  end
end

