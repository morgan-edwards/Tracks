require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    app.call(env)
  rescue Exception => e
    render_exception(e)
  end

  private

  def render_exception(e)
    dir_path = File.dirname(__FILE__)
    template_name = File.join(dir_path, "..", "views", "templates", "rescue.html.erb")
    template = File.read(template_name)
    @error = e
    body = ERB.new(template).result(binding)
    ['500', {'Content-type' => 'text/html'}, [body]]
  end

end
