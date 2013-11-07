require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/to_query'
require 'active_support/json'

require 'api_cache'
require 'open-uri'

module Tumblargh
  module API
    module V1

      @enabled = true

      class << self

        def fetch(path, query={})
          raise "API is disabled" unless enabled?

          url = "http://#{path}"
          resp = APICache.get(url, period: 0, timeout: 15) { open(url).read }
          self.dash_to_underscore(ActiveSupport::XmlMini_REXML.parse(resp))
        end

        def pages(domain)
          pages = fetch("#{domain}/api/pages")['tumblr']['pages']['page'] || []
          pages.is_a?(Hash) ? [pages] : pages
        end

        def enable!
          @enabled = true
        end

        def disable!
          @enabled = false
        end

        def enabled?
          @enabled
        end

        def dash_to_underscore(hash)
          Hash[hash.map do |key, value|
            if value.is_a?(Array)
              value.map! { |item| dash_to_underscore(item) } if value.is_a?(Array)
            elsif value.is_a?(Hash)
              dash_to_underscore(value)
            end

            [key.underscore, value]
          end]
        end

      end
    end
  end
end
