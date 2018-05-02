require "minitest/autorun"
require File.expand_path '../test_helper.rb', __FILE__

describe RubyInstagramScraper do

  before do
    @proxy_ip_addr = "35.161.133.86"
    @proxy_port = "8080"
  end

  describe "calls with a user" do

    before do
      @username = "gisele"
    end

    describe "#get_feed" do
      it "feed.user must be an array" do
        VCR.use_cassette(@username) do
          res = RubyInstagramScraper.get_feed(@username)
          res["graphql"]["user"]["username"].must_equal @username
          res["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"].must_be_instance_of Array
        end
      end

      it "also works via proxy" do
        VCR.use_cassette("#{@username}_proxy") do
          proxy = RubyInstagramScraper.make_proxy("http://#{@proxy_ip_addr}:#{@proxy_port}")
          res = RubyInstagramScraper.get_feed(@username, proxy)
          res["graphql"]["user"]["username"].must_equal @username
          res["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"].must_be_instance_of Array
        end
      end
    end

    describe "when search" do
      it "users must be an array" do
        VCR.use_cassette("search") do
          RubyInstagramScraper.search(@username)["users"].must_be_instance_of Array
        end
      end
    end

    describe "#get_user" do
      it "must have the correct username" do
        VCR.use_cassette(@username) do
          RubyInstagramScraper.get_user(@username)["username"].must_equal @username
        end
      end
    end

    describe "when request user media nodes" do
      it "must be an array" do
        VCR.use_cassette(@username) do
          RubyInstagramScraper.get_user_media_nodes(@username).must_be_instance_of Array
        end
      end
    end

    describe 'when request query id' do
      it "must return the correct id" do
        VCR.use_cassette("#{@username}_queryid") do
          RubyInstagramScraper.get_query_id(@username).must_equal "42323d64886122307be10013ad2dcc44"
        end
      end
    end

  end

  describe "when request tag media nodes" do
    before do
      @tag = "academgorodok"
    end

    it "must be an array" do
      VCR.use_cassette(@tag) do
        RubyInstagramScraper.get_tag_media_nodes(@tag).must_be_instance_of Array
      end
    end
  end

  describe "when request a media" do
    before do
      @code = "vKQeMNu7H1"
    end

    it "must has equal shortcode in field" do
      VCR.use_cassette(@code) do
        RubyInstagramScraper.get_media(@code)["shortcode"].must_equal @code
      end
    end
  end

  describe "when request user media comments" do
    before do
      @code = "6zVfmqAMkD"
    end

    it "must be an array" do
      VCR.use_cassette(@code) do
        RubyInstagramScraper.get_media_comments(@code, 2)["edges"].must_be_instance_of Array
      end
    end

    # describe "when request user media comments before specified comment_id value" do
    #   it "must be an array" do
    #     before = "17851999804000050"
    #     VCR.use_cassette("#{@code}_#{before}") do
    #       RubyInstagramScraper.get_media_comments(@code, 2, before)['nodes'].must_be_instance_of Array
    #     end
    #   end
    # end

  end

  describe '#open_with_proxy' do
    it 'uses a basic proxy correctly' do
      VCR.use_cassette(@proxy_ip_addr) do
        proxy = RubyInstagramScraper.make_proxy("http://#{@proxy_ip_addr}:#{@proxy_port}")
        RubyInstagramScraper.open_with_proxy("http://ipv4.icanhazip.com/", proxy).read.chop.must_equal @proxy_ip_addr
      end
    end

    it 'uses an auth proxy correctly' do
      skip "You need to have a private proxy set up here"
      ip_addr = "1.1.1.1"
      port = "80"
      user = "user"
      password = "password"
      VCR.use_cassette(ip_addr) do
        proxy = RubyInstagramScraper.make_proxy("http://#{ip_addr}:#{port}", user, password)
        RubyInstagramScraper.open_with_proxy("http://ipv4.icanhazip.com/", proxy).read.chop.must_equal ip_addr
      end
    end
  end

end