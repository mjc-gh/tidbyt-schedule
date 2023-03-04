require 'active_support'
require 'active_support/core_ext'
require 'command_line_reporter'
require 'yaml'

require_relative 'lib/output.rb'
require_relative 'lib/tidbyt_app.rb'

# Parse the config
config = YAML.load_file('config.yml') rescue nil

if config.nil?
  warn '[!] Please create a config.yml file to begin!'
  exit 1
elsif config[:device_id].blank?
  warn '[!] Please add your :device_id to config.yml!'
  exit 1
elsif config[:apps].blank?
  warn '[!] Please add one or more Tidbyt apps to the :apps section of config.yml'
end

output = Output.new
apps = config[:apps].map { |app| TidbytApp.new(config, app) }

loop do
  apps.each do |app|
    next unless app.needs_update?

    app.render
    app.install
  end

  output.run(apps)

  sleep 1
end
