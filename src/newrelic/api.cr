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
    JSON.mapping({
      "servers": Array(Server),
    })
  end

  class Server
    JSON.mapping({
      "id":            Int32,
      "name":          String,
      "health_status": String,
    })
  end

  class ApplicationListResponse
    JSON.mapping({
      "applications": Array(Application),
    })
  end

  class Application
    JSON.mapping({
      "id":            Int32,
      "name":          String,
      "health_status": String,
    })
  end
end
