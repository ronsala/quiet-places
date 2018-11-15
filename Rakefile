ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

# []? Is this the right place for these lines? See https://github.com/bkeepers/dotenv
require 'dotenv/tasks'

task mytask: :dotenv do
    # things that require .env
    # []? What things?
end