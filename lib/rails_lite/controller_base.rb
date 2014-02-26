require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'session'


class ControllerBase
  attr_reader :params, :req, :res


  # setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    # @params = Params.new(@req)
    @already_built_response = false
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    if already_rendered? 
      raise "Already built response"
    else
      @res.body = content
      @res.content_type = type
      @already_built_response = true
    end
    
    session.store_session(@res)
  end

  # helper method to alias @already_rendered
  def already_rendered?
    @already_built_response
  end

  # set the response status code and header
  def redirect_to(url)
    if already_rendered? 
      raise "Already built response"
    else
      @res.status = 302
      #need to set response header for redirect
      @res["location"] = url
      @already_built_response = true
    end
    
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    bind = binding
    path = "views/#{self.class.name.underscore}/#{template_name}.html.erb"
    #pass binding into this template as ERB evaluates
    template = ERB.new( File.read(path) ).result bind
    render_content(template, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  
  #no idea if this is right
  def invoke_action(action_name)
    Router.new.send(action_name.to_sym)
  end
end
