class Email::Reader
  EMAIL_REGEX = /(.*)--inline.html/
  PATH_TO_EMAILS = '/emails'

  # this will need to change, when used as a gem the local dir will be different
  def self.default
    new('./build')
  end

  def initialize(build_path)
    @path = build_path
  end

  def read_all
    locales.each do |locale_path|
      Dir["./#{locale_path}/*.html"].each do |file_path|
        filename = File.basename(file_path)
        if is_email?(filename)
          name = extract_name(filename)
          locale = extract_locale(locale_path)
          html = File.read(file_path)
          yield name, locale, html
        end
      end
    end
  end

  private

  def locales
    Dir.glob("#{@path}#{PATH_TO_EMAILS}/*").select do |file|
      File.directory?(file)
    end
  end

  def match_email(filename)
    EMAIL_REGEX.match(filename)
  end

  def is_email?(filename)
    !match_email(filename).nil?
  end

  def extract_name(filename)
    match_email(filename)[1]
  end

  def extract_locale(dir_path)
    File.basename(dir_path)
  end
end
