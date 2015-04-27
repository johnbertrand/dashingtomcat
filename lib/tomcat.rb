require 'open-uri'
require 'nokogiri'
require 'net/http'
require 'uri'
require 'pp'



#"Parse and Prepare Request" : The request headers are being parsed or the necessary preparation to read the request body (if a transfer encoding has been specified) is taking place.
#"Service" : The thread is processing a request and generating the response. This stage follows the "Parse and Prepare Request" stage and precedes the "Finishing" stage. There is always at least one thread in this stage (the server-status page).
#"Finishing" : The end of the request processing. Any remainder of the response still in the output buffers is sent to the client. This stage is followed by "Keep-Alive" if it is appropriate to keep the connection alive or "Ready" if "Keep-Alive" is not appropriate.
#"Keep-Alive" : The thread keeps the connection open to the client in case the client sends another request. If another request is received, the next stage will be "Parse and Prepare Request". If no request is received before the keep alive times out, the connection will be closed and the next stage will be "Ready".
#"Ready" : The thread is at rest and ready to be used.

class Tomcat

  attr_accessor :common_name
  attr_accessor :url
  attr_accessor :connector

  def initialize(url,common_name,user_name,password,connector)
    @common_name = common_name
    @url=url
    @uri=URI.parse(@url)
    @user_name=user_name
    @password=password
    @connector=connector
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @request = Net::HTTP::Get.new(@uri.request_uri)
    @request.basic_auth(@user_name, @password)

    #graph stuff
    @last_x=1

    @stats = {}
    @ready_points = []
    (1..10).each do |i|
      @ready_points << { x: i, y: 0 }
    end


    @service_points = []
    (1..10).each do |i|
      @service_points << { x: i, y: 0 }
    end


    @prepare_points = []
    (1..10).each do |i|
      @prepare_points << { x: i, y: 0 }
    end

    @finishing_points = []
    (1..10).each do |i|
      @finishing_points << { x: i, y:0 }
    end

    @keepalive_points = []
    (1..10).each do |i|
      @keepalive_points << { x: i, y:0 }
    end


    @last_x = @ready_points.last[:x]

  end



  def refresh()
    response = @http.request(@request)
    doc = Nokogiri::XML(response.body)
    workers=doc.xpath("//connector[@name='"+@connector+"']/workers")

    @ready      = workers.xpath("worker[@stage='R']").size
    @service    = workers.xpath("worker[@stage='S']").size
    @prepare    = workers.xpath("worker[@stage='P']").size
    @finishing  = workers.xpath("worker[@stage='F']").size
    @keepalive = workers.xpath("worker[@stage='K']").size

    memory  = doc.xpath("/status/jvm/memory")
    @free   = memory.xpath("@free")
    @total  = memory.xpath("@total")
    @max    = memory.xpath("@max")

    @last_x += 1
    @ready_points.shift
    @ready_points << { x: @last_x, y:  @ready.to_i  }


    @service_points.shift
    @service_points<< { x: @last_x, y:  @service.to_i  }

    @prepare_points.shift
    @prepare_points<< { x: @last_x, y:  @prepare.to_i  }

    @finishing_points.shift
    @finishing_points<< { x: @last_x, y:  @finishing.to_i  }

    @keepalive_points.shift
    @keepalive_points<< { x: @last_x, y:  @keepalive.to_i  }
  end

  def get_ready_points
    return @ready_points
  end

  def get_service_points
    return @service_points
  end

  def get_prepare_points
    return @prepare_points
  end

  def get_finishing_points
    return @finishing_points
  end

  def get_keepalive_points
    return @keepalive_points
  end
end


