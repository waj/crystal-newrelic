require "http"
require "json"

class NewRelic::Api
  def initialize(key)
    @client = HTTP::Client.new("api.newrelic.com", ssl: true)
    @client.before_request do |request|
      request.headers["X-Api-Key"] = key
    end
  end

  def list_servers
    @client.get("/v2/servers.json") do |response|
      ServerListResponse.from_json(response.body_io).servers
    end
  end

  def list_applications
    @client.get("/v2/applications.json") do |response|
      ApplicationListResponse.from_json(response.body_io).applications
    end
  end

  class ServerListResponse
    json_mapping({
      "servers": Array(Server),
    })
  end

  class Server
    json_mapping({
      "id":            Int32,
      "name":          String,
      "health_status": String,
    })
  end

  class ApplicationListResponse
    json_mapping({
      "applications": Array(Application),
    })
  end

  class Application
    json_mapping({
      "id":            Int32,
      "name":          String,
      "health_status": String,
    })
  end
end
