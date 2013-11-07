module Tumblargh
  module Renderer
    module Blocks

      class Pages < Base

        def url
          context.url
        end

        def label
          puts context
          context.label
        end

        def render
          puts "pages #{context}"
          if context.is_a? Resource::Page
            super
          else
            pages =  context.pages

            pages.map do |page|
              page.context = self
              self.class.new(node, page).render
            end.flatten.join('')
          end
        end
      end

    end
  end
end
