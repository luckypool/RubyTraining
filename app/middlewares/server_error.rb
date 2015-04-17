module Rack
  class ServerError
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue
      json = '{"message":"unexpected error"}'
      header = { 'Content-Type' => 'application/json' }
      response = Rack::Response.new(json, 500, header)
      response.finish
    end
  end
end
