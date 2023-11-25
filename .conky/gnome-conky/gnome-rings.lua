settings_table = {
	{
		name='time',
		arg='%I.%M',
		max=12,
		bg_colour=0xffffff,
		bg_alpha=0.1,
		fg_colour=0x0027EB,
		fg_alpha=0.5,
		x=160, y=155,
		radius=50,
		thickness=5,
		start_angle=0,
		end_angle=360
	},
	{
		name='time',
		arg='%M.%S',
		max=60,
		bg_colour=0xFF0000,
		bg_alpha=0.3,
		fg_colour=0xFF0000,
		fg_alpha=0.7,
		x=160, y=155,
		radius=56,
		thickness=5,
		start_angle=0,
		end_angle=360
	},
	{
		name='time',
		arg='%S',
		max=60,
		bg_colour=0x00ffff,
		bg_alpha=0.5,
		fg_colour=0x00ffff,
		fg_alpha=0.8,
		x=160, y=155,
		radius=62,
		thickness=5,
		start_angle=0,
		end_angle=360
	},
	{
		name='cpu',
		arg='cpu',
		max=60,
		bg_colour=0x00FF00,
		bg_alpha=0.7,
		fg_colour=0xFF0000,
		fg_alpha=0.9,
		x=160, y=155,
		radius=75,
		thickness=10,
		start_angle=93,
		end_angle=208
	},
	{
		name='freq_g',
		arg='',
		max=5,
		bg_colour=0x0000F6,
		bg_alpha=0.2,
		fg_colour=0x0000FF,
		fg_alpha=0.9,
		x=160, y=155,
		radius=75,
		thickness=10,
		start_angle=212,
		end_angle=329
	},
	{
		name='downspeedf',
		arg='wlo1',
		max=1600,
		bg_colour=0xff00ff,
		bg_alpha=0.2,
		fg_colour=0xffFF00,
		fg_alpha=0.8,
		x=160, y=155,
		radius=75,
		thickness=10,
		start_angle=-27,
		end_angle=85
	},
	{
		name='cpu',
		arg='cpu0',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0x0000ff,
		fg_alpha=0.9,
		x=160, y=155,
		radius=120,
		thickness=3,
		start_angle=54,
		end_angle=126
	}, 
	{
		name='cpu',
		arg='cpu1',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0x0087ff,
		fg_alpha=0.9,
		x=160, y=155,
		radius=150,
		thickness=3,
		start_angle=62,
		end_angle=118
	},
	{
		name='cpu',
		arg='cpu2',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0xffff00,
		fg_alpha=0.8,
		x=160, y=155,
		radius=180,
		thickness=3,
		start_angle=66.5,
		end_angle=113.5
	},
	{
		name='cpu',
		arg='cpu3',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0x00baff,
		fg_alpha=0.8,
		x=160, y=155,
		radius=210,
		thickness=3,
		start_angle=70,
		end_angle=110
	},
	{
		name='cpu',
		arg='cpu4',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0x00e1ad,
		fg_alpha=0.9,
		x=160, y=155,
		radius=240,
		thickness=3,
		start_angle=72.5,
		end_angle=107.5
	}, 
	{
		name='cpu',
		arg='cpu5',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0x00e992,
		fg_alpha=0.9,
		x=160, y=155,
		radius=270,
		thickness=3,
		start_angle=74.5,
		end_angle=105.5
	},
	{
		name='cpu',
		arg='cpu6',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0x00ff00,
		fg_alpha=0.8,
		x=160, y=155,
		radius=300,
		thickness=3,
		start_angle=76,
		end_angle=104
	},
	{
		name='cpu',
		arg='cpu7',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0x91df00,
		fg_alpha=0.8,
		x=160, y=155,
		radius=330,
		thickness=3,
		start_angle=77.5,
		end_angle=102.5
	},
	{
		name='cpu',
		arg='cpu8',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0xc4ba00,
		fg_alpha=0.9,
		x=160, y=155,
		radius=360,
		thickness=3,
		start_angle=78.5,
		end_angle=101.5
	}, 
	{
		name='cpu',
		arg='cpu9',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0xe59100,
		fg_alpha=0.9,
		x=160, y=155,
		radius=390,
		thickness=3,
		start_angle=79.5,
		end_angle=100.5
	},
	{
		name='cpu',
		arg='cpu10',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0xf96000,
		fg_alpha=0.8,
		x=160, y=155,
		radius=420,
		thickness=3,
		start_angle=80,
		end_angle=100
	},
	{
		name='cpu',
		arg='cpu11',
		max=60,
		bg_colour=0xd5dcde,
		bg_alpha=1,
		fg_colour=0xff0000,
		fg_alpha=0.8,
		x=160, y=155,
		radius=450,
		thickness=3,
		start_angle=80.5,
		end_angle=99.5
	},
	{
		name='fs_used_perc',
		arg='/',
		max=100,
		bg_colour=0x00ff00,
		bg_alpha=0.6,
		fg_colour=0x0000ff,
		fg_alpha=1.0,
		x=160, y=155,
		radius=105,
		thickness=3,
		start_angle=241,
		end_angle=359
	},
	{
		name='fs_used_perc',
		arg='/home',
		max=100,
		bg_colour=0x00ff00,
		bg_alpha=0.6,
		fg_colour=0xff0000,
		fg_alpha=0.9,
		x=160, y=155,
		radius=105,
		thickness=3,
		start_angle=1,
		end_angle=119
	},
	{
		name='battery_percent',
		arg='BAT0',
		max=100,
		bg_colour=0xff0000,
		bg_alpha=0.8,
		fg_colour=0x00ff00,
		fg_alpha=0.9,
		x=160, y=155,
		radius=105,
		thickness=3,
		start_angle=121,
		end_angle=239
	}
}



clock_r=125



clock_x=160
clock_y=155



clock_colour=0x00ffff
clock_alpha=0.5



show_seconds=true

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
	local w,h=conky_window.width,conky_window.height

	local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
	local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

	local angle_0=sa*(2*math.pi/360)-math.pi/2
	local angle_f=ea*(2*math.pi/360)-math.pi/2
	local t_arc=t*(angle_f-angle_0)

	

	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
	cairo_set_line_width(cr,ring_w)
	cairo_stroke(cr)

	

	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
	cairo_stroke(cr)
end

function draw_clock_hands(cr,xc,yc)
	local secs,mins,hours,secs_arc,mins_arc,hours_arc
	local xh,yh,xm,ym,xs,ys

	secs=os.date("%S")
	mins=os.date("%M")
	hours=os.date("%I")

	secs_arc=(2*math.pi/60)*secs
	mins_arc=(2*math.pi/60)*mins+secs_arc/60
	hours_arc=(2*math.pi/12)*hours+mins_arc/12

	

	xh=xc+0.7*clock_r*math.sin(hours_arc)
	yh=yc-0.7*clock_r*math.cos(hours_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xh,yh)

	cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
	cairo_set_line_width(cr,5)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(clock_colour,clock_alpha))
	cairo_stroke(cr)

	

	xm=xc+clock_r*math.sin(mins_arc)
	ym=yc-clock_r*math.cos(mins_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xm,ym)

	cairo_set_line_width(cr,3)
	cairo_stroke(cr)

	

	if show_seconds then
		xs=xc+clock_r*math.sin(secs_arc)
		ys=yc-clock_r*math.cos(secs_arc)
		cairo_move_to(cr,xc,yc)
		cairo_line_to(cr,xs,ys)

		cairo_set_line_width(cr,1)
		cairo_stroke(cr)
	end
end

function conky_clock_rings()
	local function setup_rings(cr,pt)
		local str=''
		local value=0

		str=string.format('${%s %s}',pt['name'],pt['arg'])
		str=conky_parse(str)

		value=tonumber(str)
		if value == nil then value = 0 end
		pct=value/pt['max']

		draw_ring(cr,pct,pt)
	end

	

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)

	local cr=cairo_create(cs)	

	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	if update_num>5 then
		for i in pairs(settings_table) do
			setup_rings(cr,settings_table[i])
		end
	end

	draw_clock_hands(cr,clock_x,clock_y)
end
