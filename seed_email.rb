#
# Seed and email with `./example_data`
#
# Simply run this file with the name of the email:
#
# `$ ruby seed_email.rb sign_up_completion`
#
# This will create a file called email.html.
#
# `$ ruby seed_email.rb sign_up_completion; open email.html`
#

require 'ERB'
require 'yaml'

file = ARGV[0]
hash = YAML.load_file('./example_data/' + file + '.yml')

b = binding
hash.each do |key, value|
  b.local_variable_set( key.to_sym, value)
end
html = File.read( './build/emails/en-GB/' + file + '--inline.html' )
html = html.gsub('[EMV DYN]','<%= ')
html = html.gsub('[EMV /DYN]',' %>')
erb = ERB.new(html)

File.open( "email.html", 'w+') {|f| f.write( erb.result(b) ) }
