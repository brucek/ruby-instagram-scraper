require 'bundler'
Bundler.require :default, :test

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "ruby-instagram-scraper"

require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = {
    re_record_interval: 3600 * 24  # 3600 seconds = 1 hour
  }
end