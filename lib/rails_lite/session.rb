require 'json'
require 'webrick'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @session = {}
    req.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app"
        sesh = JSON.parse(cookie.value)
        @session = sesh
      end
    end
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    @res = res
    new_cookie = WEBrick::Cookie.new("_rails_lite_app", @session.to_json)
    @res.cookies << new_cookie
  end
  
end
