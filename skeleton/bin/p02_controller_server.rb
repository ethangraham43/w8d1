require 'rack'
require_relative '../lib/controller_base'
require "byebug"

class MyController < ControllerBase
  def initialize(req, res)
    @req = req
    @res = res

  end

  def render_content(content, content_type = 'text/html')
    @already_built_response ||= true
    # debugger
    if @already_built_response
      @already_built_response = false
      @res.write(content)
      @res['Content-Type'] = content_type
      debugger
    end
  end

  def redirect_to(url)
    debugger
    @already_built_response ||= true
    if @already_built_response
      debugger
      @already_built_response = false
      @res.status = 302
      @res['Location'] = url
      nil
    end
  end

  def go
    # debugger
    if req.path == "/cats"
      render_content("hello cats!", "text/html")
    else
      redirect_to("/cats")
    end
  end
end
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)

