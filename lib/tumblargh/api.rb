require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/to_query'
require 'active_support/json'

require 'api_cache'
require 'open-uri'

module Tumblargh
  module API

    autoload :V1, 'tumblargh/api/v1'
    autoload :V2, 'tumblargh/api/v2'

  end
end
