require 'ERB'
require 'yaml'
require 'dalli'
require 'kramdown'
require 'action_view'
require 'pathname'
require 'dalli'
require 'premailer'

module EmailTransactional
end

require_relative './email_transactional/version'
require_relative './email_transactional/globals'
require_relative './email_transactional/helpers'
require_relative './email_transactional/config'
require_relative './email_transactional/stylesheets'
require_relative './email_transactional/directory_index'
require_relative './email_transactional/stores'
require_relative './email_transactional/stages'
require_relative './email_transactional/template'
require_relative './email_transactional/reader'
require_relative './email_transactional/transactional'
require_relative './email_transactional/email'
require_relative './email_transactional/locales'
require_relative './email_transactional/source'
require_relative './email_transactional/pipeline'
require_relative './email_transactional/pipeline_builder'

I18n.load_path << Dir[EmailTransactional::Locales.path + '/*.yml']
