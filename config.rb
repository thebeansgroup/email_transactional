###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

page "/partials/*", layout: false

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
  activate :i18n
end

# Methods defined in the helpers block are available in templates
helpers do
  def image_url(source)
    "http://cdn.ymaservices.com/email_transactional/#{source}"
  end
end
sprockets.append_path "http://cdn.ymaservices.com/email_transactional/"

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'


#
# Inline the CSS
#

require 'premailer'  
require 'nokogiri'

def parse(doc)
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


# Build-specific configuration
configure :build do
  # activate :minify_html, remove_http_protocol: false
  activate :inline_css
  activate :i18n
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
