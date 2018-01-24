require 'byebug'

class Static
  attr_reader :app, :root, :file_server

  MIME_TYPES = {
    '.txt' => 'text/plain',
    '.jpg' => 'image/jpeg',
    '.zip' => 'application/zip',
    '.gif' => 'image/gif',
    '.pdf' => 'application/pdf',
    '.mpeg' => 'video/mpeg'
  }

  def initialize(app)
    @app = app
    @root = :public
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path

    if static_asset?(path)
      serve_file(path)
    else
      app.call(env)
    end
  end

  private

  def static_asset?(path)
    path.index("/#{root}")
  end

  def file_name(path)
    debugger
    dir = File.dirname(__FILE__)
    File.join(dir, '..', path)
  end

  def serve_file(path)
    res = Rack::Response.new
    file_name = file_name(path)
    if File.exist?(file_name)
      res["Content-type"] = MIME_TYPES[File.extname(file_name)]
      file = File.read(file_name)
      res.write(file)
      return res
    else
      dir_path = File.dirname(__FILE__)[0..-11]
      template_name = File.join(dir_path, "views", "templates", "404.html.erb")
      template = File.read(template_name)
      body = ERB.new(template).result(binding)
      ['404', {'Content-type' => 'text/html'}, [body]]
    end
  end
end
