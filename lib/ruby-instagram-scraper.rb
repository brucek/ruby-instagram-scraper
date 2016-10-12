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
    JSON.parse( open( url ).read )["media"]
  end

  def self.get_media_comments ( shortcode, count = 40, before = nil )
    params = before.nil?? "comments.last(#{ count })" : "comments.before( #{ before } , #{count})"
    url = "#{BASE_URL}/query/?q=ig_shortcode(#{ shortcode }){#{ params }\
      {count,nodes{id,created_at,text,user{id,profile_pic_url,username,\
      follows{count},followed_by{count},biography,full_name,media{count},\
      is_private,external_url,is_verified}},page_info}}"

    JSON.parse( open( url ).read )["comments"]
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