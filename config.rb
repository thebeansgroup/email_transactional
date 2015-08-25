# ====================================================
# Development
# ====================================================

page "/partials/*", layout: false

configure :development do
  activate :livereload
  activate :i18n,:langs => ["en-GB"]
end

# CONSTANTS
TMPL_OPEN_TAG  = "[[["
TMPL_CLOSE_TAG = "]]]"

# Methods defined in the helpers block are available in templates
helpers do
  def image_url(source)
    "http://cdn.ymaservices.com/email_transactional/#{source}"
  end

  def tagify(name)
    TMPL_OPEN_TAG + "%= " + name + " %" + TMPL_CLOSE_TAG.html_safe
  end

  def markdown(text)
    Kramdown::Document.new(text).to_html
  end

  def twitter_href
    "https://twitter.com/studentbeans"
  end

  def facebook_href
    "https://www.facebook.com/studentbeans"
  end

  def appstore_href
    ""
  end

  def googleplay_href
    ""
  end

end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :markdown



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
  html_str = html.to_html
  html_str = html_str.sub(TMPL_OPEN_TAG, '<')
  html_str = html_str.sub(TMPL_CLOSE_TAG, '>')
  html_str
end

def directoryBuilder
  html = "<html><body><ul>"; 
  Dir.glob(build_dir + "/emails/*/" ).each do |folder|
    html += "<li><a href='#{folder.sub('build/', '')}'>#{folder.sub('build/emails', '')}</a></li>"

    # sub
    subhtml = "<html><body><ul>"
    Dir.glob(folder + "/*.html" ).each do |file|
      relPath = file.split('/')[-1]
      subhtml += "<li><a href='#{relPath}'>#{relPath}</a></li>"
    end
    subhtml += "</ul></body></html>"
    puts folder + "index.html"
    File.open( folder + "index.html"  , "w+") do |content|
      content.puts subhtml
    end
    # /sub

  end
  html += "</ul></body></html>"
  File.open( "build/index.html"  , "w+") do |content|
    content.puts html
  end
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
        destination_txt_file = source_file.gsub('.html', '.txt')

        puts "Inlining file: #{source_file} to #{destination_file}"

        File.open(destination_txt_file, "w") do |content|
          content.puts  premailer.to_plain_text
        end

        File.open(destination_file, "w") do |content|
          content.puts  parse(premailer.to_inline_css)
        end

        File.delete( Dir.getwd + File::SEPARATOR + source_file)
      end

      directoryBuilder

    end
  end
end  
::Middleman::Extensions.register(:inline_css, InlineCSS)

# ====================================================
# Build
# ====================================================

configure :build do
  activate :inline_css
  activate :i18n, :path => "emails/:locale/", :mount_at_root => false
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
