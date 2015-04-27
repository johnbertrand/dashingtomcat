#require_relative 'tomcat'
require 'nokogiri'
require 'net/http'
require 'uri'
require 'pp'



uri = URI.parse("http://192.168.66.167:8015/manager/status?XML=true")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("username", "password")

response = http.request(request)

doc = Nokogiri::XML(response.body)

workers=doc.xpath("//connector[@name='http-8015']/workers")

#"Parse and Prepare Request" : The request headers are being parsed or the necessary preparation to read the request body (if a transfer encoding has been specified) is taking place.
#"Service" : The thread is processing a request and generating the response. This stage follows the "Parse and Prepare Request" stage and precedes the "Finishing" stage. There is always at least one thread in this stage (the server-status page).
#"Finishing" : The end of the request processing. Any remainder of the response still in the output buffers is sent to the client. This stage is followed by "Keep-Alive" if it is appropriate to keep the connection alive or "Ready" if "Keep-Alive" is not appropriate.
#"Keep-Alive" : The thread keeps the connection open to the client in case the client sends another request. If another request is received, the next stage will be "Parse and Prepare Request". If no request is received before the keep alive times out, the connection will be closed and the next stage will be "Ready".
#"Ready" : The thread is at rest and ready to be used.

r = workers.xpath("worker[@stage='R']").size
s = workers.xpath("worker[@stage='S']").size
p = workers.xpath("worker[@stage='P']").size
f = workers.xpath("worker[@stage='F']").size
k = workers.xpath("worker[@stage='K']").size


puts r
puts s
puts p
puts f
puts k


memory = doc.xpath("/status/jvm/memory")
free   = memory.xpath("@free")
total  = memory.xpath("@total")
max    = memory.xpath("@max")


puts "free #{free}"
puts "total #{total}"
puts "max #{max}"

