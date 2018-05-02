require 'open-uri'
require 'json'

module RubyInstagramScraper

  BASE_URL = "https://www.instagram.com"
  DATA_REGEX = /window._sharedData=({.*});\s+window/


  FILENAME_REGEX = /([^"]*ProfilePageContainer.js[^"]+)/
  QUERY_ID_REGEX = /e\.profilePosts\.byUserId\.get[^{]+queryId:"([^&"]+)"/

  def self.search (query, proxy = nil)
    # return false unless query

    url = add_params("https://www.instagram.com/web/search/topsearch/", { query: query })

    JSON.parse(open_with_proxy(url, proxy).read)
  end

  def self.get_feed (username, proxy = nil)
    url = "#{BASE_URL}/#{ username }/"
    page = open_with_proxy(url, proxy).read
    match = DATA_REGEX.match(page)[1]
    json = JSON.parse(match)
    res = json["entry_data"]["ProfilePage"]
    res = res[0] if res.is_a?(Array)
    res
  end

  def self.get_user_media_nodes (username, proxy = nil)
    self.get_user(username, proxy)["edge_owner_to_timeline_media"]["edges"]
  end

  def self.get_user (username, proxy = nil)
    self.get_feed(username, proxy)["graphql"]["user"]
  end

  def self.get_query_id (username, proxy = nil)
    url = "#{BASE_URL}/#{ username }/"
    base_page = open_with_proxy(url, proxy).read

    js_filename = FILENAME_REGEX.match(base_page)[1]

    js_url = "#{BASE_URL}#{ js_filename }"
    js_page = open_with_proxy(js_url, proxy).read
    query_id = QUERY_ID_REGEX.match(js_page)[1]

    # final_url = "#{BASE_URL}/graphql/query/?query_hash=#{query_id}&variables=%7B%22id%22%3A%221388064697%22%2C%22first%22%3A12%7D"
    #
    # JSON.parse(open_with_proxy(final_url, proxy).read)

    query_id
  end

  def self.get_tag_media_nodes (tag, max_id = nil, proxy = nil)
    url = add_params("#{BASE_URL}/explore/tags/#{ tag }/", { __a: 1, max_id: max_id })
    JSON.parse(open_with_proxy(url, proxy).read)["graphql"]["hashtag"]["edge_hashtag_to_media"]["edges"]
  end

  def self.get_media (code, proxy = nil)
    url = add_params("#{BASE_URL}/p/#{ code }/", { __a: 1 })
    JSON.parse(open_with_proxy(url, proxy).read)["graphql"]["shortcode_media"]
  end

  def self.get_media_comments (code, count = 40, proxy = nil)
    url = add_params("#{BASE_URL}/p/#{ code }/", { __a: 1 })
    JSON.parse(open_with_proxy(url, proxy).read)["graphql"]["shortcode_media"]["edge_media_to_comment"]
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