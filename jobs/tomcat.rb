
url = "http://192.168.66.167:8015/manager/status?XML=true"
instance  = "wombat-01"
username  = ""
password  = ""
connector = "http-8015"

t = Tomcat.new(url,instance,username, password,connector)


SCHEDULER.every '1s', :first_in => 0 do |job|
  t.refresh

  send_event('tomcat',  {  threadready:     t.get_points,
                           threadservice:   t.get_service_points,
                           threadprepare:   t.get_prepare_points,
                           threadfinishing: t.get_finishing_points,
                           threadkeepalive: t.get_keepalive_points,
                           title: instance
                     } )

end