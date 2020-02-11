--Watermark
local kills  = {}
local deaths = {};

local frametimes = {}
local fps_prev = 0

local font1 = draw.CreateFont('KaushanScript-Regular', 29)
local font2 = draw.CreateFont('calibri', 15)

local m_iPing = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex())

local function accumulate_fps()
    local ft = globals.AbsoluteFrameTime()
    if ft > 0 then
        table.insert(frametimes, 1, ft)
    end

    local count = #frametimes
    if count == 0 then
        return 0
    end

    local i, accum = 0, 0
    while accum < 0.5 do
        i = i + 1
        accum = accum + frametimes[i]
        if i >= count then
            break
        end
    end
    accum = accum / i
    while i < count do
        i = i + 1
        table.remove(frametimes)
    end
    
    local fps = 1 / accum
    local rt = globals.RealTime()
    if math.abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
        fps_prev = fps
        last_update_time = rt
    else
        fps = fps_prev
    end
    
    return math.floor(fps + 0.5)
end


local function events_stuff( event )
       if event:GetName( ) == "client_disconnect" then
		   kills = {}
           deaths = {}
       

end
   if event:GetName( ) == "player_death" then
   local local_player = client.GetLocalPlayerIndex( );
   local INDEX_Attacker = client.GetPlayerIndexByUserID( event:GetInt( 'attacker' ) );
   local INDEX_Victim = client.GetPlayerIndexByUserID( event:GetInt( 'userid' ) );

   if INDEX_Attacker == local_player then
      kills[#kills + 1] = {}
   end
   if (INDEX_Victim == local_player) then
       deaths[#deaths + 1] = {};
       end
   end
end

local function drawing_stuff( )

   if not entities.GetLocalPlayer() then
       return 
   end
   local delay_shot = gui.GetValue( "rbot_delayshot" )
    if accumulate_fps() > 80 then
        r, g, b = 0, 255, 70
        end
    if accumulate_fps() < 80 then
        r, g, b = 150, 255, 00
        end
    if accumulate_fps() < 60 then
		r, g, b = 255, 200, 0
		end
	if accumulate_fps() < 40 then
		r, g, b = 255, 50, 0
		end
	if accumulate_fps() < 20 then
	r, g, b = 255, 255, 0
    end

--Draw watermark

    draw.Color(25, 25, 25, 230)
    draw.RoundedRectFill( 1545, 8, 1897, 41 )

    draw.Color(128, 0, 0, 100)
    draw.OutlinedRect( 1545, 8, 1898, 42 )

    draw.SetFont(font1)
    draw.Color(128, 0, 0, 255)
    draw.Text(1555, 9, "Aimware.net")
    draw.TextShadow(1555, 9, "Aimware.net")   

    draw.SetFont(font2)

    draw.Color(0, 255, 0, 255)
    draw.Text(1698, 18, m_iPing)
    draw.TextShadow(1698, 18, m_iPing)
    draw.Text(1668, 18, "PING: ")
    draw.TextShadow(1668, 18, "PING: ")

    draw.Color(r,g,b,255)
    draw.Text(1745, 18, accumulate_fps())
    draw.TextShadow(1745, 18, accumulate_fps())
    draw.Text(1722, 18, "FPS:")
    draw.TextShadow(1722, 18, "FPS:")

    draw.Color(255, 255, 255, 255)
    draw.Text(1769, 18, " ✜ ")
    draw.TextShadow(1769, 18, " ✜ ")
    
    draw.Color(255, 255, 255, 255)
    draw.Text(1785, 18, #kills) 
    draw.Text(1798, 18, "Kills")
    draw.TextShadow(1798, 18, "Kills")

    draw.Color(255, 255, 255, 255)
    draw.Text(1824, 18, " ☠ ")
    draw.TextShadow(1824, 18, " ☠ ")

    draw.Color(255, 255, 255, 255)
    draw.Text(1844, 18, #deaths)
    draw.Text(1853, 18, " Deaths")
    draw.TextShadow(1853, 18, " Deaths")
   
end

client.AllowListener( "round_start" );
client.AllowListener( "game_end" );
client.AllowListener( "player_death" );
callbacks.Register( "FireGameEvent", "events_stuff", events_stuff);
callbacks.Register( "Draw", "drawing_stuff", drawing_stuff );
