module Tumblargh
  module Resource

    class Page < Base
      def initialize(attrs, blog)
        @blog = blog
        super(attrs)
      end

      def label
        @attributes[:link_title] || "Page Title Missing"
      end

      def url
        @attributes[:url]
      end
    end

  end
end
