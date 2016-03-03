module MailPipes
  module DirectoryIndex
    def self.build
      html = '<html><body><ul>'
      Dir.glob('build/emails/*/').each do |folder|
        html += "<li><a href='#{folder.sub('build/', '')}index.html'>\
                #{folder.sub('build/emails', '')}</a></li>"

        subhtml = '<html><body><ul>'
        Dir.glob(folder + '/*.html').each do |file|
          rel_path = file.split('/')[-1]
          subhtml += "<li><a href='#{rel_path}'>#{rel_path}</a></li>"
        end
        subhtml += '</ul></body></html>'
        puts folder + 'index.html'
        File.open(folder + 'index.html', 'w+') do |content|
          content.puts(subhtml)
        end
      end
      html += '</ul></body></html>'
      File.open('build/index.html', 'w+') do |content|
        content.puts(html)
      end
    end
  end
end
