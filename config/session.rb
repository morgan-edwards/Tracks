require 'json'

class Session

  def initialize(req)
    cookie = req.cookies['_rails_lite_app']
    @data = cookie ? JSON.parse(cookie) : {}
  end

  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  def store_session(res)
    res.set_cookie('_rails_lite_app',
      { path: '/', value: @data.to_json })
  end

end
