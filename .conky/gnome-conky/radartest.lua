--[[
call 
lua_load ~/lua/radartest.lua
lua_draw_hook_pre radar
]]

--settings 08-Sep-2011 16:59

--file directory, if this directory is permanent then you will only have to download the background images once
--a sub directory will be created within the directory for the radar images
directory="/home/poomit/Downloads/radar/"

--do you want Short or Long distance radar images? (capital first letter)
distance="Long"

--enter your weather station... find at the bottom of this page...  http://forecast.weather.gov/jetstream/doppler/ridge_download.htm
station="FTG"

--update interval, the site itself updates from around 6 to 10 minutes
interval=300

--positions and image scale set lower down


require 'cairo'
require 'imlib2'
------------------------------------------------------------------------------
function string:split(delimiter)
local result = { }
local from  = 1
local delim_from, delim_to = string.find( self, delimiter, from  )
while delim_from do
table.insert( result, string.sub( self, from , delim_from-1 ) )
from  = delim_to + 1
delim_from, delim_to = string.find( self, delimiter, from  )
end
table.insert( result, string.sub( self, from  ) )
return result
end
--------------------------------------------------------------------------------

function conky_radar()
if conky_window == nil then return end
local cs = cairo_xlib_surface_create(conky_window.display,  conky_window.drawable, conky_window.visual, conky_window.width,  conky_window.height)
cr = cairo_create(cs)
local updates=tonumber(conky_parse('${updates}'))
if updates==3 then
os.execute("wget -nc --directory-prefix=" .. directory .. "  http://radar.weather.gov/ridge/Overlays/Topo/" .. distance .. "/" ..  station .. "_Topo_" .. distance .. ".jpg")
os.execute("wget -nc --directory-prefix=" .. directory .. "  http://radar.weather.gov/ridge/Overlays/County/" .. distance .. "/" ..  station .. "_County_" .. distance .. ".gif")
os.execute("wget -nc --directory-prefix=" .. directory .. "  http://radar.weather.gov/ridge/Overlays/Highways/" .. distance .. "/" ..  station .. "_Highways_" .. distance .. ".gif")
os.execute("wget -nc --directory-prefix=" .. directory .. "  http://radar.weather.gov/ridge/Overlays/Cities/" .. distance .. "/" ..  station .. "_City_" .. distance .. ".gif")
end
if updates>5 then
--#########################################################################################################
--#########################################################################################################
--positioning
pos_x=200
pos_y=150
--original images are 600 wide by 550 tall
--you can resize the images here
scale_x=600
scale_y=550

file=directory .. station .. "_Topo_" .. distance .. ".jpg"
image(pos_x,pos_y,scale_x,scale_y,file)

if distance=="Short" then
pic="N0R"
elseif distance=="Long" then
pic="N0Z"
end

timer=(updates % interval)+1
if timer==1 or updates==10 then
os.execute("rm " .. directory .. "radar/" .. station .. "_" .. pic .. "_0.gif")
os.execute("rm " .. directory .. "radar/" .. station .. "_" .. pic .. "_Legend_0.gif")
os.execute("rm " .. directory .. "radar/" .. station .. "_Warnings_0.gif")

os.execute("wget --directory-prefix=" .. directory .. "radar/  http://radar.weather.gov/ridge/RadarImg/" .. pic .. "/" .. station ..  "_" .. pic .. "_0.gif")
os.execute("wget --directory-prefix=" .. directory .. "radar/  http://radar.weather.gov/ridge/Legend/" .. pic .."/" .. station .. "_"  .. pic .. "_Legend_0.gif")
os.execute("wget --directory-prefix=" .. directory .. "radar/  http://radar.weather.gov/ridge/Warnings/" .. distance .. "/" .. station  .. "_Warnings_0.gif")
end
file=directory .. "/radar/" .. station .. "_" .. pic .. "_0.gif"
image(pos_x,pos_y,scale_x,scale_y,file)

file=directory .. station .. "_County_" .. distance .. ".gif"
image(pos_x,pos_y,scale_x,scale_y,file)

file=directory .. station .. "_Highways_" .. distance .. ".gif"
image(pos_x,pos_y,scale_x,scale_y,file)

file=directory .. station .. "_City_" .. distance .. ".gif"
image(pos_x,pos_y,scale_x,scale_y,file)

file=directory .. "/radar/" .. station .. "_Warnings_0.gif"
image(pos_x,pos_y,scale_x,scale_y,file)

file=directory .. "/radar/" .. station .. "_" .. pic .. "_Legend_0.gif"
image(pos_x,pos_y,scale_x,scale_y,file)
--#########################################################################################################
--#########################################################################################################
end-- if updates>5
cairo_destroy(cr)
cairo_surface_destroy(cs)
cr=nil
end-- end main function

function image(center_x,center_y,w,h,file)
show = imlib_load_image(file)
if show == nil then return end
imlib_context_set_image(show)
if tonumber(w)==0 then 
width=imlib_image_get_width() 
else
width=tonumber(w)
end
if tonumber(h)==0 then 
height=imlib_image_get_height() 
else
height=tonumber(h)
end
iacross=center_x-(width/2)
idown=center_y-(height/2)
imlib_context_set_image(show)
scaled=imlib_create_cropped_scaled_image(0, 0, imlib_image_get_width(), imlib_image_get_height(), width, height)
imlib_free_image()
imlib_context_set_image(scaled)
imlib_render_image_on_drawable(iacross, idown)
imlib_free_image()
show=nil
end

