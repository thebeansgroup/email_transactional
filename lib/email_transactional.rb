require 'ERB'
require 'yaml'
require 'dalli'
require 'kramdown'

require_relative './email_transactional/version'
require_relative './email_transactional/globals'
require_relative './email_transactional/helpers'
require_relative './email_transactional/config'
require_relative './email_transactional/key'
require_relative './email_transactional/store'
require_relative './email_transactional/template'
require_relative './email_transactional/reader'
require_relative './email_transactional/transactional'
require_relative './email_transactional/locales'
require_relative './email_transactional/source'

module EmailTransactional
end
