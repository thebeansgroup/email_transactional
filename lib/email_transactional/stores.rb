module EmailTransactional
  module Stores
  end
end

require_relative './stores/memcached'
require_relative './stores/disk'
