require 'erb'
require 'yaml'
require 'dalli'
require 'kramdown'
require 'action_view'
require 'action_dispatch'
require 'pathname'
require 'dalli'
require 'premailer'

module MailPipes
end

require_relative './mail_pipes/version'
require_relative './mail_pipes/globals'
require_relative './mail_pipes/helpers'
require_relative './mail_pipes/config'
require_relative './mail_pipes/stylesheets'
require_relative './mail_pipes/directory_index'
require_relative './mail_pipes/stores'
require_relative './mail_pipes/stages'
require_relative './mail_pipes/transactional'
require_relative './mail_pipes/email'
require_relative './mail_pipes/locales'
require_relative './mail_pipes/source'
require_relative './mail_pipes/layouts'
require_relative './mail_pipes/pipeline'
require_relative './mail_pipes/pipeline_builder'

I18n.load_path << Dir[MailPipes::Locales.path + '/*.yml']
