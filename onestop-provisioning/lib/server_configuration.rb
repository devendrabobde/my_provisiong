class ServerConfiguration
  CONFIG = YAML.load(File.read("#{Rails.root}/config/server.yml"))[Rails.env].freeze
end
