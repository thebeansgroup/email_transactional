module EmailTransactional::Middleman
  def self.build
    `bundle exec middleman build`
  end
end
