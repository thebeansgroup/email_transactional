# ====================================================
# Development
# ====================================================

page "/partials/*", layout: false

configure :development do
  activate :livereload
  activate :i18n
end

# Methods defined in the helpers block are available in templates
helpers do
  def image_url(source)
    "http://cdn.ymaservices.com/email_transactional/#{source}"
  end

  def tagify(name)
    "<%= " + name + " %>".html_safe
  end
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'


# ====================================================
# Build Helpers
# ====================================================

require 'premailer'  
require 'nokogiri'

def parse(doc)
  puts "parse"
  html = Nokogiri::HTML  doc
  head  = html.search("head")
  html.search("style").each do |el|
    head.children.last.add_previous_sibling el
    # el.remove
  end
  html.search("img").each do |el|
    alt = el.get_attribute('alt')
    if !alt
      el.set_attribute('alt', '')
    end
  end
  html.search("[align='none']").each do |el|
    el.attributes["align"].remove
  end
  html.to_html
end

class InlineCSS < Middleman::Extension  
  def initialize(app, options_hash={}, &block)
    super
    app.after_build do |builder|
      
      Dir.glob(build_dir + File::SEPARATOR + '**/*.html').each do |source_file|
        
        if source_file.start_with? 'build/partials'
          premailer = Premailer.new(source_file, verbose: true, css: 'http://localhost:4567/stylesheets/all.css', remove_classes: false, adapter: 'nokogiri')
        else
          premailer = Premailer.new(source_file, verbose: true, remove_classes: false, adapter: 'nokogiri')
        end
        destination_file = source_file.gsub('.html', '--inline-css.html')

        puts "Inlining file: #{source_file} to #{destination_file}"

        File.open(destination_file, "w") do |content|
          content.puts  parse(premailer.to_inline_css)
        end

        File.delete( Dir.getwd + File::SEPARATOR + source_file)
      end
    end
  end
end  
::Middleman::Extensions.register(:inline_css, InlineCSS)

# ====================================================
# Build
# ====================================================

configure :build do
  activate :inline_css
  activate :i18n, :path => "emails/:locale/"
  # Enable cache buster
  activate :asset_hash
  # Use relative URLs
  activate :relative_assets
end

# ====================================================
# Deploy
# ====================================================

activate :deploy do |deploy|
  deploy.method = :git
end
