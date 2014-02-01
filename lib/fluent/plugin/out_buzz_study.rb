require "mongo"
require "httpclient"
require "nokogiri"

module Fluent
  class BuzzStudy < Fluent::Output
    Fluent::Plugin.register_output('buzz_study', self)

    def configure(conf)
      super
    end

    def start
      super
    end

    def shutdown
      super
    end

    def emit(tag, es, chain)
      # id, uri, tweet_id
      chain.next
      es.each do |time, record|
        uri = record["original_url"]
        title = get_page_title(uri)
        record = {}
        record["uri"] = uri
        record["title"] = title
        Fluent::Engine.emit("uri.#{tag}", time, record)
      end
    end

    private

    def get_page_title(uri)
      con = Mongo::Connection.new("localhost", 27017)
      col = con.db("buzz_study").collection("uri_map")
      result = col.find(uri: uri).first
      if result
        title = result["title"]
      else
        response = try_redirection_uri(uri)
        page = Nokogiri(response.body)
        title = page.title.gsub("\n", "")
        doc = {"uri" => uri, "title" => title}
        col.insert(doc)
      end
      title
    end

    def try_redirection_uri(uri)
      hc = HTTPClient.new
      response = hc.get(uri)
      if response.code == 301
        redirected_uri = response.http_header["location"].first
        response = try_redirection_uri(redirected_uri)
      end
      response
    end
  end
end
