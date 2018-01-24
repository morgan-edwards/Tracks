require 'rack'
require_relative '../controllers/default_controller'
require_relative '../config/routes'
require_relative '../middleware/static'
require_relative '../middleware/show_exceptions'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  DefaultRouter.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use ShowExceptions
  use Static
  run app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)
