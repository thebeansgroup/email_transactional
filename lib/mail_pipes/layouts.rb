module MailPipes
  class Layouts
    LAYOUTS_PATH = Source::SOURCE_PATH + 'layouts/'.freeze
    LAYOUTS_EXTENSION = '.erb'.freeze
    LAYOUTS_CONFIG = 'layouts.yml'.freeze
    DEFAULT = 'default'

    def initialize(default, map)
      @default = default
      @map = map
    end

    def get(key)
      @map[key] || @default
    end

    def self.instance
      @instance ||= load_from_config
    end

    def self.load_from_config
      default, map = parse(load_config)
      new(default, map)
    end

    def self.load_config
      YAML.load_file(
        File.expand_path("#{Source::SOURCE_PATH}#{LAYOUTS_CONFIG}", __FILE__)
      )
    end

    def self.parse(config)
      default = config.delete(DEFAULT)
      map = {}
      config.each do |key, value|
        map[key] = path_to_layout(value)
      end
      [path_to_layout(default), map]
    end

    def self.path_to_layout(name)
      relative_path = "#{LAYOUTS_PATH}#{name}#{LAYOUTS_EXTENSION}"
      File.expand_path(relative_path, __FILE__)
    end
  end
end
