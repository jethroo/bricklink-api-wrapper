# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
SimpleCov.add_filter 'spec/'
SimpleCov.minimum_coverage 100

require 'bundler/setup'
require 'bricklink_api_wrapper'
require 'byebug'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data('<OAUTH_SETTINGS>') do |interaction|
    auths = interaction.request.headers['Authorization'].first
    auths if auths.match(/^OAuth.*/)
  end

  config.filter_sensitive_data('<COOKIE_1>') do |interaction|
    cookie = interaction.response.headers['Set-Cookie'].first
    cookie
  end

  config.filter_sensitive_data('<COOKIE_2>') do |interaction|
    cookie = interaction.response.headers['Set-Cookie'].last
    cookie
  end

  config.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
end
