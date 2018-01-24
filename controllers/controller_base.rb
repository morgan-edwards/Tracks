require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative '../config/session'
require_relative '../config/flash'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = route_params.merge(req.params)
    @already_built_response = false
    @@protect_from_forgery ||= false
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "Error: Cannot render twice" if already_built_response?
    @res.location = url
    @res.status = 302
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end

  def render_content(content, content_type)
    raise "Error: Cannot render view twice" if already_built_response?

    @res.write(content)
    @res['Content-Type'] = content_type

    @already_built_response = true

    session.store_session(@res)
    flash.store_flash(@res)
    nil
  end

  def render(template_name)
    current_path = File.dirname(__FILE__)
    view = File.join(current_path, "..", "views", self.class.name.underscore,
      "#{template_name}.html.erb")

    erb_code = File.read(view)
    content = ERB.new(erb_code).result(binding)

    render_content(content, "text/html")
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  def invoke_action(name)
    self.send(name)
    already_built_response? ? nil : render(name)
  end

end
