module Email
end

require 'ERB'
require 'yaml'

require_relative './email/version'
require_relative './email/key'
require_relative './email/middleman'
require_relative './email/store'
require_relative './email/template'
require_relative './email/reader'
require_relative './email/transactional'
