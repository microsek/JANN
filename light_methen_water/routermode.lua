wifi.setmode(wifi.SOFTAP)
cfg={}
require("routerpass")
cfg.ssid=ssid
cfg.pwd=password
cfg.ip="192.168.0.10"
cfg.netmask="255.255.255.0"
cfg.gateway="192.168.0.1"
wifi.ap.setip(cfg)
wifi.ap.config(cfg)
k=0
if cfg.pwd==nil then
cfg.pwd=""
end
print(cfg.ssid,cfg.pwd,wifi.ap.getip())

displayrouter(cfg.ssid,cfg.pwd,wifi.ap.getip()) 

--  http server
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
conn:on("receive",function(conn,payload)
		setstate="..."
		k=string.find(payload,"ssid")
		if k then
			str=string.sub(payload,k)
			m=string.find(str,"&")
			strssid='ssid='..'"'..string.sub(str,6,(m-1))..'"'
			strpass='password="'..string.sub(str,(m+10))..'"'
			file.open("routerpass.lua","w+")
			file.writeline(strssid)
            file.writeline(strpass)
			file.close()
			setstate="OK"
			require("routerpass")
			displayrouter(ssid,password,wifi.ap.getip()) 
           -- html-output
        conn:send("HTTP/1.0 200 OK\r\nContent-type: text/html\r\nServer: ESP8266\r\n\n")
        conn:send("<html><head></head><body>")
        conn:send("<font color=\"red\">")                      
        conn:send("<h1>Meajo config SSID and PASSWORD </h1>")
        conn:send("<h1>Finished to config SSID</h1></font>")   --"..setstate.."
        conn:send("</body>")
        conn:send("</html>")
        
		else
        
		-- html-output
		conn:send("HTTP/1.0 200 OK\r\nContent-type: text/html\r\nServer: ESP8266\r\n\n")
		conn:send("<html><head></head><body>")
        conn:send("<font color=\"red\">")                      
        conn:send("<h1>Meajo config SSID and PASSWORD </h1>")
        conn:send("<h1> Connecting ESP8266 router "..setstate.."</h1></font>")   --"..setstate.."
		conn:send("<FORM action=\"\" method=\"POST\">")
		conn:send("SSID:<input type=\"test\" name=\"ssid\">")
		conn:send("<br></br>")
		conn:send("Password<input type=\"text\" name=\"password\">")
		conn:send("<br></br>")
		conn:send("<input type=\"submit\" value=\"Submit\">")
		conn:send("</form>")
		conn:send("</body>")
		conn:send("</html>")
        end
	end)
end)
