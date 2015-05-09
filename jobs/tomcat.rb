
url = "http://192.168.0.1:8015/manager/status?XML=true"
instance  = "tomcat-01"
username  = ""
password  = ""
connector = "http-8015"

t = Tomcat.new(url,instance,username, password,connector)


SCHEDULER.every '1s', :first_in => 0 do |job|
  t.refresh

  send_event('tomcat',  {  threadready:     t.get_ready_points,
                           threadservice:   t.get_service_points,
                           threadprepare:   t.get_prepare_points,
                           threadfinishing: t.get_finishing_points,
                           threadkeepalive: t.get_keepalive_points,
                           title: instance
                     } )

end
