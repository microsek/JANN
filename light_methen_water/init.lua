local mode_pin= 2 -- pin pin for select mode
local sda_pin = 5 -- GPIO14
local scl_pin = 6 -- GPIO12
local oled_addr = 0x3c

gpio.mode(mode_pin,gpio.INPUT) 

i2c.setup(0, sda_pin, scl_pin, i2c.SLOW)
local disp = nil
local disp = u8g.ssd1306_128x64_i2c(oled_addr)

function display(ipa,light,co,water)

  disp:firstPage()
  disp:setFont(u8g.font_6x10)
  disp:setFontRefHeightExtendedText()
  disp:setDefaultForegroundColor()
  disp:setFontPosTop()
  
  repeat
    local x=0
    local y=0
    disp:drawRFrame(0, 0, 128, 64, 1)
    disp:drawStr(2, 2, 'Maejo Smart Farm') 
    disp:drawStr(2, 12, "IP: "..ipa) 
    disp:drawStr(2, 22, "Light       = "..light)
    disp:drawStr(2, 32, "GAS Methane = "..co.."ppm")
    disp:drawStr(2, 42, "Water flow  = "..water.."L/h")
  until disp:nextPage() == false

end

function displayrouter(ssid,password,ipa)

  disp:firstPage()
  disp:setFont(u8g.font_6x10)
  disp:setFontRefHeightExtendedText()
  disp:setDefaultForegroundColor()
  disp:setFontPosTop()
  
  repeat
    local x=0
    local y=0
    disp:drawRFrame(0, 0, 128, 64, 1)
    disp:drawStr(2, 2, 'Maejo Smart Farm') 
    disp:drawStr(2, 12, "MODE Config SSID") 
    disp:drawStr(2, 22, "Goto web and accress IP")
    disp:drawStr(2, 32, "IP = "..ipa)
    disp:drawStr(2, 42, "SSID = "..ssid)
    disp:drawStr(2, 52, "password = "..password)
  until disp:nextPage() == false
end

function scan_ip()

 -- specify the SSID and PASSWORD for your AP 
  -- specify the SSID and PASSWORD for your AP 
--ssid   = "AndroidAP" 
--passwd = "phonphirom" 

--ssid   = "microsekasus" 
--passwd = "qwertyuiop"
--ssid   = "Peterkwifi" 
--passwd = "0859796651"
require("routerpass") 
display( "set up wifi mode.",'??','??','??')
 wifi.setmode(wifi.STATION)
 wifi.sta.config(ssid,password)
 wifi.sta.connect()
 cnt = 0
 tmr.alarm(1, 1000, 1, function() 
    if(wifi.sta.getip() == nil) then
      display( "Waiting....",'??','??','??','??')
      cnt = cnt + 1
     else 
       if (cnt < 20) then 
       display(wifi.sta.getip(),'??','??','??','??') 
       dofile("smartfarm.lua")
      else 
       display("Can't get IP",'??','??','??','??') 
      end 
     
      
     end 
  end)

end
if gpio.read(mode_pin)==1 then 
    dofile("routermode.lua") 
else 
    scan_ip()
end
--tmr.alarm( 1, 1000, 1, scan_ip )
