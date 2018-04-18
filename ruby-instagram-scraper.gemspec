#!/usr/bin/env ruby
# encoding: utf-8
Gem::Specification.new do |s|
  s.name = 'ruby-instagram-scraper'
  s.version = '0.2.0'
  s.date = '2018-04-17'
  s.summary = "A simple module for requests to Instagram without an API key."
  s.description = "A simple module for requests to Instagram without an API key."
  s.authors = ["Bruce Krysiak", "Sergey Borodanov  <s.borodanov@gmail.com>"]
  s.email = "brucek@alum.mit.edu"
  s.files = ["lib/ruby-instagram-scraper.rb"]
  s.test_files = ["test/ruby_instagram_scraper_test.rb"]
  s.homepage = 'https://github.com/brucek/ruby-instagram-scraper'
  s.license = 'MIT'

  s.add_development_dependency "bundler", "~> 1.16"
  s.add_development_dependency "minitest", "~> 5.10"
  s.add_development_dependency "m", "~> 1.5.1"
  s.add_development_dependency "webmock", "~> 3.3.0"
  s.add_development_dependency "vcr", "~> 4.0.0"
end