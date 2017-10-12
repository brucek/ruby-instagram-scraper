require 'open-uri'
require 'json'

module RubyInstagramScraper

  BASE_URL = "https://www.instagram.com"

  def self.search ( query )
    # return false unless query

    url = add_params("https://www.instagram.com/web/search/topsearch/", {query: query})

    JSON.parse( open( url ).read )
  end

  def self.get_feed ( username, max_id = nil )
    url = add_params("#{BASE_URL}/#{ username }/", {__a: 1, max_id: max_id})

    JSON.parse( open( url ).read )
  end

  def self.get_user_media_nodes ( username, max_id = nil )
    url = add_params("#{BASE_URL}/#{ username }/", {__a: 1, max_id: max_id})

    JSON.parse( open( url ).read )["user"]["media"]["nodes"]
  end

  def self.get_user ( username, max_id = nil )
    url = add_params("#{BASE_URL}/#{ username }/", {__a: 1, max_id: max_id})

    JSON.parse( open( url ).read )["user"]
  end

  def self.get_tag_media_nodes ( tag, max_id = nil )
    url = add_params("#{BASE_URL}/explore/tags/#{ tag }/", {__a: 1, max_id: max_id})

    JSON.parse( open( url ).read )["tag"]["media"]["nodes"]
  end

  def self.get_media ( code )
    url = add_params("#{BASE_URL}/p/#{ code }/", {__a: 1})
    JSON.parse( open( url ).read )["graphql"]["shortcode_media"]
  end

  def self.get_media_comments ( code, count = 40 )
    url = add_params("#{BASE_URL}/p/#{ code }/", {__a: 1})
    JSON.parse(open( url ).read)["graphql"]["shortcode_media"]["edge_media_to_comment"]
  end

  def self.add_params(url, params = {})
    q = ""
    query = ""
    params.each do |key, val|
      q = "?"
      query += "&#{key}=#{val}"
    end
    url + q + query
  end
  
end