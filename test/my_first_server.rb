require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8080
dir = '/'
server.mount_proc(dir) do |request, response|
  response.content_type = 'text/text'
  response.body = request.path
end

trap('INT') { server.stop } 
server.start