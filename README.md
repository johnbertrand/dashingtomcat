This is a dsahing.io widget that will graph your tomcat threads

1) copy the widgets/tomcat folder to your wigets folder.

2) copy lib/tomcat.rb to your lib folder

3)copy jobs/tomcat.rb to your jobs folder

4) edit the jobs/tomcat.rb file.  Add the url to your tomcat manager, make sure you are pulling XML, ie ?XML=true.  
Add the username/password, the instance name of your tomcat, and the name of the connector you wish to monitor.  

5) add gem 'nokogiri' to your gemfile, then bundle

6) that should be all

Please feel free to contact me if you need help getting this working.
