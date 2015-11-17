$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
support = File.expand_path("../support", __FILE__)

Dir["#{support}/**/*.rb"].each { |file| require(file) }

ENV['EVENTFUL_ENV'] = 'test'

# SimpleCov needs to be required and kicked off *prior* to the invocation of
# the core gem itself.
#
require 'simplecov'

SimpleCov.start do
  add_filter '.gem'
  add_filter 'bin'
end

require 'rack/test'
require 'search_kit'

SearchKit.configure do |config|
  config.app_env = 'test'
  config.verbose = false
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :api
end
