require 'open-uri'
require 'json'

module RubyInstagramScraper

  BASE_URL = "https://www.instagram.com"

  def self.search ( query, proxy = nil )
    # return false unless query

    url = add_params("https://www.instagram.com/web/search/topsearch/", {query: query})

    JSON.parse( open_with_proxy( url, proxy ).read )
  end

  def self.get_feed ( username, max_id = nil, proxy = nil )
    url = add_params("#{BASE_URL}/#{ username }/", {__a: 1, max_id: max_id})

    JSON.parse( open_with_proxy( url, proxy ).read )
  end

  def self.get_user_media_nodes ( username, max_id = nil, proxy = nil )
    url = add_params("#{BASE_URL}/#{ username }/", {__a: 1, max_id: max_id})

    JSON.parse( open_with_proxy( url, proxy ).read )["user"]["media"]["nodes"]
  end

  def self.get_user ( username, max_id = nil, proxy = nil )
    url = add_params("#{BASE_URL}/#{ username }/", {__a: 1, max_id: max_id})

    JSON.parse( open_with_proxy( url, proxy ).read )["user"]
  end

  def self.get_tag_media_nodes ( tag, max_id = nil, proxy = nil )
    url = add_params("#{BASE_URL}/explore/tags/#{ tag }/", {__a: 1, max_id: max_id})

    JSON.parse( open_with_proxy( url, proxy ).read )["tag"]["media"]["nodes"]
  end

  def self.get_media ( code, proxy = nil )
    url = add_params("#{BASE_URL}/p/#{ code }/", {__a: 1})
    JSON.parse( open_with_proxy( url, proxy ).read )["graphql"]["shortcode_media"]
  end

  def self.get_media_comments ( code, count = 40, proxy = nil )
    url = add_params("#{BASE_URL}/p/#{ code }/", {__a: 1})
    JSON.parse(open_with_proxy( url, proxy ).read)["graphql"]["shortcode_media"]["edge_media_to_comment"]
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

  def self.open_with_proxy(url, proxy = nil)
    if proxy && proxy.is_a?(Array) && proxy.count >= 3
      open(url, proxy_http_basic_authentication: proxy[0..2])
    elsif proxy
      open(url, proxy: proxy)
    else
      open(url)
    end
  end

  def self.make_proxy(url, user = nil, password = nil)
    return nil unless url
    proxy_uri = URI.parse(url)
    if user && password
      return [proxy_uri, user, password]
    else
      return proxy_uri
    end
  end
  
end