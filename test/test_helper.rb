require "bundler/gem_tasks"
Bundler.require(:default, :development)

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "ruby-instagram-scraper"

require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = {
    re_record_interval: 3600 * 24 # 3600 seconds = 1 hour
  }
  c.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
end