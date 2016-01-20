# move these to gemspec
require 'ERB'
require 'yaml'

class Email::Template
  def initialize(html)
    @html = html
    @erb = ERB.new(html)
  end

  def populate(params = {})
    @erb.result(bindings_from(params))
  end

  private

  def bindings_from(params)
    bindings = binding
    params.each do |key, value|
      bindings.local_variable_set(key.to_sym, value)
    end
    bindings
  end
end
