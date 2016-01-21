module Email::Middleman
  def self.build
    `bundle exec middleman build`
  end
end
