module Email::Transactional
  def self.get(name, locale)
    html = Email::Store.instance.get_email(name, locale)
    Template.new(html)
  end
end
