class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
      pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    (http_method == req.request_method.downcase.to_sym) &&
      (pattern =~ req.path)
  end

  def run(req, res)
    path_data = pattern.match(req.path)
    params = path_data.names.zip(path_data.captures).to_h
    controller = controller_class.new(req, res, params)
    controller.invoke_action(action_name)
  end

end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, http_method, controller_class, action_name)
    routes << Route.new(pattern, http_method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    routes.find { |route| route.matches?(req) }
  end

  def run(req, res)
    route = match(req)
    route ? route.run(req, res) : res.status = 404
  end

end
