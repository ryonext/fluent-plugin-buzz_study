require "mongo"
require "httpclient"
require "nokogiri"

module Fluent
  class BuzzStudy < Fluent::Output
    Fluent::Plugin.register_output('buzz_study', self)

    config_param :mongo_host, :string
    config_param :mongo_port, :integer
    config_param :mongo_db, :string
    config_param :mongo_collection, :string
    config_param :mongo_user, :string
    config_param :mongo_pass, :string
    config_param :tag, :string

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
        doc = add_record(uri)
        record = {}
        record["uri"] = doc["uri"]
        record["title"] = doc["title"]
        record["count"] = doc["count"]
        Fluent::Engine.emit("#{@tag}.#{tag}", time, record)
      end
    end

    private

    def add_record(uri)
      db = Mongo::Connection.new(@mongo_host, @mongo_port).db(@mongo_db)
      db.authenticate(@mongo_user, @mongo_pass)
      col = db.collection(@mongo_collection)
      doc = col.find(uri: uri).first
      if doc
        doc["count"] = (doc["count"] || 0) + 1
        col.save(doc)
      else
        response = try_redirection_uri(uri)
        page = Nokogiri(response.body)
        title = page.title.gsub("\n", "")
        doc = {"uri" => uri, "title" => title, "count" => 1}
        col.insert(doc)
      end
      doc
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
