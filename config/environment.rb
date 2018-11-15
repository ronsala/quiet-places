ENV['SINATRA_ENV'] ||= "development"
ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

# []? Is this the right place for these lines? See https://github.com/bkeepers/dotenv
require 'dotenv'
Dotenv.load

require './app/controllers/application_controller'
require_all 'app'
require 'sysrandom/securerandom'