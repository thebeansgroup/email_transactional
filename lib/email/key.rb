class Email::Key
  def initialize(name, locale)
    @name = name
    @locale = locale
  end

  def build
    "#{@name}-#{@locale}"
  end
end
