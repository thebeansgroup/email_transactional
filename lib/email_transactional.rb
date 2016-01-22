
require 'ERB'
require 'yaml'
require 'dalli'


require_relative './email_transactional/version'
require_relative './email_transactional/key'
require_relative './email_transactional/middleman'
require_relative './email_transactional/store'
require_relative './email_transactional/template'
require_relative './email_transactional/reader'
require_relative './email_transactional/transactional'

module EmailTransactional
end
