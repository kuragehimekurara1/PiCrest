local Color_new = Color.new
local Graphics_drawImage = Graphics.drawImage
local Graphics_drawImageExtended = Graphics.drawImageExtended
local Graphics_drawRotateImage = Graphics.drawRotateImage
local Graphics_drawScaleImage = Graphics.drawScaleImage

local function getHSV(color)
	local r,g,b = Color.getR(color)/255,Color.getG(color)/255,Color.getB(color)/255
	local min, max = math.min(r,g,b), math.max(r,g,b)
	local v,s = max
	if max==min then
		return 0,0,v
	end
	if max==r then 
		if g>=b then
			h = 60*(g-b)/(max-min)
			else
			h = 60*(g-b)/(max-min)+360
		end
	elseif max==g then
		h = 60*(b-r)/(max-min) + 120
	elseif max==b then
		h = 60*(r-g)/(max-min) + 240
	end
	if max==0 then
	s = 0
	else
	s = 1-min/max
	end
	return h,s,v
end
function mod(x,a)
	return x-math.floor(x/a)*a
end
local function setHSV(h,s,v)
	local r, g, b;
	h = h/360
	local i = math.floor(h * 6);
	local f = h * 6 - i;
	local p = v * (1 - s);
	local q = v * (1 - f * s);
	local t = v * (1 - (1 - f) * s);
	local i = mod(i,6)
    if i==0 then r = v g = t b = p; end;
    if i==1 then r = q g = v b = p; end;
    if i==2 then r = p g = v b = t; end;
    if i==3 then r = p g = q b = v; end;
    if i==4 then r = t g = p b = v; end;
    if i==5 then r = v g = p b = q; end;
	return r*255,g*255, b*255
end

local function execQuery(cmd)
	local d, r = Database.open(dbDir)
	r = Database.execQuery(d, cmd)
	Database.close(d)
	return r
end
local LOCALIZATION = {
	OPTIONS = {
		BUTTONS = {
			{"Theme","Miss","Animation","Language: English","Reset saves","Back"},
			{"Tema","Owibki","Animaci[","{zyk: Russki`","Sbros","Nazad"},
			{"Thema","Error","Multiplicatio ","Lingua: Latina (by overmind98)","Reconstitere memoriam","Cessim"}
			},
		DOWN_BUTTONS = {
			{
				{"Back","Change option"},
				{"Nazad","Izmenit'"},
				{"Cessim","Succedere instrumentum"}
			},
			{
				{"Select","Back"},
				{"Vybrat'","Nazad"},
				{"Seligere","Cessim"}
			}
		}
	},
	THEMES = {
		DOWN_BUTTONS = {
			{
				{"Change color","Back","Scroll"},
				{"Izmenit' cvet", "Nazad","Smenit' cvet"},
				{"Succedere colorem","Cessim","Circumagere"}
			},
				{{"Accept","Cancel","Change color"},
				{"Primenit'","Otmena","Izmenit' cvet"},
				{"Approbare","Cancell|re","Succedere colorem"}
			}
		}
	},
	MENU = {
		BUTTONS =  {
		{"Play", "Create", "Options", "Exit"},
		{"Igrat'", "Sozdat'", "Nastro`ki", "Vyhod"},
		{"Ludere", "Cre|tus", "Instrumenti", "Exitus"}
		},
		DOWN_BUTTONS = {
		{"Select"},
		{"Vybrat'"},
		{"Seligere"}
		}
	},
	PAUSE = {
		BUTTONS = {
		{"Continue", "Options", "Main menu"},
		{"Prodoljit'", "Nastro`ki", "Glavnoe menq"},
		{"Continuare", "instrumenti", "Primus catalogus"}
		},
		DOWN_BUTTONS = {
		{"Select","Back to game"},
		{"Vybrat'","Nazad k igre"},
		{"Seligere","In ludo redire"}
		}
	},
	SELECTION = {
		DOWN_BUTTONS = {
		{
			{"Close folder","Go to Standart levels folder","Back"},
			{"Zakryt' papku","V standartnye urovni","Nazad"},
			{"Claudere categoriam","@re categori| cum typicae tabulae","Cessim"}
		},
		{
			{"Open folder","Go to Standart levels folder","Back"},
			{"Otkryt' papku","V standartnye urovni","Nazad"},
			{"Aper@re categoriam","@re categori| cum typicae tabulae","Cessim"}
		},
		{
			{"Play level","Go to Standart levels folder","Back"},
			{"Igrat' uroven'","V standartnye urovni","Nazad"},
			{"Ludere tabulam","@re categori| cum typicae tabulae","Cessim"}
		},
		{
			{"Go to Standart levels folder","Back"},
			{"V standartnye urovni","Nazad"},
			{"@re categori| cum typicae tabulae","Cessim"}
		},
		{
			{"Close folder","Go to Custom levels folder","Back"},
			{"Zakryt' papku","V kastomnye urovni","Nazad"},
			{"Claudere categoriam","@re categori| cum factae tabulae","Cessim"}
		},
		{
			{"Open folder","Go to Custom levels folder","Back"},
			{"Otkryt' papku","V kastomnye urovni","Nazad"},
			{"Aper@re categoriam","@re categori| cum factae tabulae","Cessim"}
		},
		{
			{"Play level","Go to Custom levels folder","Back"},
			{"Igrat' uroven'","V kastomnye urovni","Nazad"},
			{"Aper@re categoriam","@re categori| cum factae tabulae","Cessim"}
		},
		{
			{"Go to Custom levels folder","Back"},
			{"V kastomnye urovni","Nazad"},
			{"@re categori| cum factae tabulae","Cessim"}
		}
}
	},
	HEAD = {
		HEAD = {
		"PiCrest",
		"PiKrest",
		"PiCrux"
		},
		TEXT = {
		"the nonogram game",
		"nonogram igra",
		"nonogramma Ludus"
		}
	},
	CREATE = {
		BUTTONS = {
			{"Name","Width","Height","Create"},
			{"Im[","Wirina","Vysota","Sozdat'"},
			{"Nomen","Latitudo","Altitudo","Cre|tus"}
		},
		DOWN_BUTTONS = {
		{
			{"Change","Back"},
			{"Izmenit'","Nazad"},
			{"Succedere","Cessim"}
		},
		{
			{"Change","Back"},
			{"Izmenit'","Nazad"},
			{"Succedere","Cessim"}
		},
		{
			{"Select","Back"},
			{"Vybrat'","Nazad"},
			{"Seligere","Cessim"}
		},
		},
		DOWN_BUTTONS2 = {
			{
				{"Show/Hide palette","Paint square","Go to map mode","Save"},
				{"Otkryt'/Zakryt' palitru","Zakrasit' kvadrat","Rejim karty","Sohranit'"},
				{"Spect|re/Abscondere pal|tum","Colōr|re quadratum","@re tabula modus","Memoria"}
			},
			{{"Add/Delete square","Go to paint mode","Save"},{"Postavit'/Ubrat' kvadrat","Rejim Raskraski","Sohranit'"},{"Addere/^r|dere quadratum","@re pictura modus","Memoria"}}
		}
	},
	YESORNO = {
		BUTTONS = {
		{"Yes", "No"},
		{"Da", "Net"},
		{"Sic", "Non"}
		},
		TEXT = {
		"Are you sure?",
		"Vy uvereny?",
		"Certus es tu?"
		},
		DOWN_BUTTONS = {
			{{"Select","Cancel"},{"Vybrat'","Otmena"},{"Seligere","Cancell|re"}},
			{{"Cancel"},{"Otmena"},{"Cancell|re"}}
		}
	},
	ANIMATION = {
		{"rescale", "fade", "rotating", "off"}, {"uvelixenie","skrytie","vrawenie", "net"},{"Resc|lere", "Marc^scere", "Rotatio", "Nihil"}
	}
}
local Libs = {"fnt", "pcl", "cfg", "thm"}
local Colors = {
	Text = Color_new(255, 255, 255),
	Pen = Color_new(100,100,100),
	Tile = Color_new(255, 255, 255),
	Cross = Color_new(0, 148, 255),
	Square = Color_new(0, 148, 255),
	Background = Color_new(160, 0, 28),
	SecondBack = Color_new(200, 0, 64),
	X5Lines = Color_new(200,0,0),
	Grid = Color_new(0,0,0),
	Frame = Color_new(200, 0, 200),
	FrameOutline = Color_new(0,0,0),
	SideNumbers = Color_new (255,255,255)
}
ColorsTable = {"Text","Pen","Background","SecondBack","SideNumbers","Grid","X5Lines","Tile","Square","Cross","Frame","FrameOutline",}
color_size = 476/#ColorsTable
Animations = LOCALIZATION.ANIMATION
Animations.now = 1
Options = {["nowtheme"] = "default",	["animation"] = "rotating",	["fps"] = "off", ["language"] = 1, ["mistakes"] = 1}
if System.getLanguage() == 08 then Options["language"] = 2 end
appDir = "app0:/"
datDir = appDir.."data/"
libDir = datDir.."lib/"
lvlDir = datDir.."lvl/"
thmDir = datDir.."thm/"
txrDir = datDir.."txr/"
dir = "ux0:data/PiCrest/"
cnfgDir = dir.."config.ini"
clvlDir = dir.."levels/"
dbDir = dir.."save.db"

for i = 1, #Libs do dofile(libDir..Libs[i]..".lua") end

local openPCL, updatePCL, createPCL, getRNPCL = PCL_Lib.open, PCL_Lib.update, PCL_Lib.create, PCL_Lib.getRN

if not System.doesDirExist  (dir)				then System.createDirectory (dir)									end
if not System.doesDirExist  (clvlDir)			then System.createDirectory (clvlDir)								end
if not System.doesFileExist (dir.."custom.thm")	then MakeTheme(dir.."custom.thm", Colors)							end
if not System.doesFileExist (dbDir) 			then execQuery("CREATE TABLE REC(path varchar(255),ms Bigint);")	end

local database_p = execQuery("SELECT path FROM [REC];")
local database_m = execQuery("SELECT ms FROM [REC];")

local newVar = true
local tex_but, tile_tex, cross_tex, padlr_tex, padud_tex, squarebut_tex, crossbut_tex,trianglebut_tex, circlebut_tex = Graphics.loadImage(txrDir.."button.png"), Graphics.loadImage(txrDir.."tile.png"), Graphics.loadImage(txrDir.."cross.png"), Graphics.loadImage(txrDir.."padlr.png"),Graphics.loadImage(txrDir.."padud.png"), Graphics.loadImage(txrDir.."squarebut.png"), Graphics.loadImage(txrDir.."crossbut.png"), Graphics.loadImage(txrDir.."trianglebut.png"), Graphics.loadImage(txrDir.."circlebut.png")
local pen_tex = Graphics.loadImage(txrDir.."pen.png")
local rainbow,light = Graphics.loadImage(txrDir.."rainbow.png"),Graphics.loadImage(txrDir.."light.png")
local star = Graphics.loadImage(txrDir.."star.png")
local DeltaTimer, newTime, actionTimer, gameTimer = Timer.new(), 0, Timer.new(), Timer.new()
local tile_size = 24
local half_size, square_size, frame_size = tile_size / 2, tile_size - 2, tile_size + 2
local pie, ceil, max, len, floor, sub, sin, cos,upper = math.pi, math.ceil, math.max, string.len, math.floor, string.sub, math.sin, math.cos,string.upper
local lock_time, def_pause, lil_pause = 800, 200, 60
local pause = def_pause
local oldpad, newpad, pad = SCE_CTRL_CROSS, SCE_CTRL_CROSS
local scan_themes, themes = System.listDirectory(thmDir),{now = 1}
local white,black,lowshadow, shadow, highshadow, antishadow = Color_new(255, 255, 255), Color_new(0, 0, 0),Color_new (0, 0, 0, 20),Color_new (0, 0, 0, 100), Color_new(0,0,0,170),Color_new (255, 255, 255, 100)
local mh_rot = pie
local level = {}
local rot_pause = 0
local all_max = 16*pie
local uScreen = 2
local LINE_VERTICAL, LINE_HORIZONTAL = true, false
local now_path = lvlDir
local fileFormat = function (name, format)	return sub(name,len(name)-3,len(name)) == format end

local function scan_folder(_path)
	local tableA = System.listDirectory(_path)
	local final = {}
	local k = 1
	if _path ~= lvlDir and _path ~= clvlDir then final[1] = {name="...", dir = true} k = 2 end
	for i=1, #tableA do
		if fileFormat(tableA[i].name,".pcl") then
			final[#final+1] = {name = sub(tableA[i].name,1,len(tableA[i].name) - 4), dir = false}
			final[#final].realname, final[#final].size = PCL_Lib.getToSize(_path..tableA[i].name)
			elseif tableA[i].directory then
			table.insert(final, k,{name = tableA[i].name.."/", dir = true})
			k = k + 1
		end
	end
	table.sort(final, function(a,b) return a.name<b.name and a.dir==b.dir end)
	return final
end

local function ZEWARDO ()

	Timer.reset(actionTimer)
	Timer.reset(gameTimer)
	Timer.pause(actionTimer)
	Timer.pause(gameTimer)

end

local function Controls_click (BUTTON) return Controls.check(pad, BUTTON) and not Controls.check(oldpad, BUTTON) end

local function changeCLR(color,f)
	local gr,gg,gb,ga=Color.getR(color),Color.getG(color),Color.getB(color),Color.getA(color)
	if f==0 then return color end
	local L = 0.3*gr + 0.6*gg + 0.1*gb 
	return Color_new(gr+f*(L-gr),gg+f*(L-gg),gb+f*(L-gb),ga)
end

local function newAlpha(color, a)
	if a==255 then return color end
	return Color_new(Color.getR(color), Color.getG(color), Color.getB(color), a)
end

local function updateAllData ()

	for i = 1, #scan_themes do
		if fileFormat(scan_themes[i].name, ".thm") then
			themes[#themes+1] = sub(scan_themes[i].name,1,len(scan_themes[i].name) - 4)
		end
	end
	themes[#themes + 1] = "custom"
	readCfg (cnfgDir, Options)
	local def_theme = thmDir.."default.thm"
	if Options["nowtheme"] == "custom" then
		if System.doesFileExist(dir.."custom.thm") then
			def_theme = dir.."custom.thm"
			else
			Options["nowtheme"] = "default"
		end
		else
		if System.doesFileExist(thmDir..Options["nowtheme"]..".thm") then
			def_theme = thmDir..Options["nowtheme"]..".thm"
			else
			Options["nowtheme"] = "default"
		end
	end
	AcceptTheme(def_theme, Colors)
	for i=1, #themes 		do if themes[i] 	   == Options["nowtheme"]  then themes.now	   = i break end end
	for i=1, #Animations[1] do if Animations[1][i] == Options["animation"] then	Animations.now = i break end end
	updateCfg (cnfgDir, Options)

end

local function getRecord (_path)
	local record = 0
	for i=1, #database_p do	if database_p[i].path == _path then	record = database_m[i].ms break	end	end
	return record
end

local function updateRecord (_path, record)
	local id = #database_p + 1
	local create = true
	for i=1, #database_p do
		if database_p[i].path == _path then
			id = i
			create = false
			break
		end
	end
	database_m[id] = {ms = record}
	database_p[id] = {path = _path}
	db = Database.open(dbDir)
	if create then
		Database.execQuery(db, "INSERT INTO REC VALUES ('".._path.."',"..record..");")
		else
		Database.execQuery(db, "UPDATE [REC] SET ms = "..record.." WHERE path = '".._path.."';")
	end
	Database.close(db)
end

local function toDigits (x)
	local mt1000 = floor(x / 1000)
	local mt60 = floor(mt1000 / 60)
	local h = floor(mt60 / 60)
	if h > 99 then return "99:59:59" end
	local m = mt60 - h * 60
	local s = mt1000 - mt60 * 60
	if h/10<1 then	h = "0"..h	end
	if m/10<1 then	m = "0"..m	end
	if s/10<1 then	s = "0"..s	end
	return h..":"..m..":"..s
end

local function ResetData ()
	System.deleteFile(dbDir)
	execQuery("CREATE TABLE REC(path varchar(255),ms Bigint);")
	database_p = execQuery("SELECT path FROM [REC];")
	database_m = execQuery("SELECT ms FROM [REC];")
	level.recInms = 0
	level.record = toDigits(level.recInms)
end

local function drawRect (x, y, w, h, c) c = c or white	Graphics.fillRect(x, x + w, y, y + h, c) end

local function drawEmptyRect (x, y, w, h, t, c)
	local p = w - 2 * t
	drawRect(x, y, t, h, c)
	drawRect(x + t, y, p, t, c)
	drawRect(x + w - t, y, t, h, c)
	drawRect(x + t, y + h - t, p, t, c)

end

local function minus ()

	Timer.reset(actionTimer)
	pause = lock_time
	tile_oldAdd = tile_nowAdd
	local time = nowGameTimer + tile_nowAdd * 60000
	Timer.setTime(gameTimer,-time)
	if tile_nowAdd~=8 then tile_nowAdd = tile_nowAdd*2 end
	mh_rot = 0

end

local function updateStacks ()
	tile_stackU={}
	tile_stackL={}
	for i = 0, max(level.width,level.height) - 1 do
		if i < level.width then		tile_stackU[i] = {[0]=0}	end
		if i < level.height then	tile_stackL[i] = {[0]=0}	end
	end
	local tmp = 0
	for i = 0, level.width-1 do
		local now, tmp = 0, 0
		for j=0, level.height-1 do
			if level.map[tmp+i+1] then
				tile_stackU[i][now] = tile_stackU[i][now] + 1
				else
				if tile_stackU[i][now] and tile_stackU[i][now] > 0 then
					now = now + 1
					tile_stackU[i][now] = 0
				end
			end
			tmp = tmp + level.width
		end
		if tile_stackU[i][now] == 0 and tile_stackU[i][0] ~= 0 then tile_stackU[i][now]=nil end
	end
	tmp = 0
	for i = 0, level.height-1 do
		local now = 0
		for j=0, level.width-1 do
			tmp = tmp + 1
			if level.map[tmp] then
				tile_stackL[i][now] = tile_stackL[i][now] + 1
				else
				if tile_stackL[i][now] and tile_stackL[i][now] > 0 then
					now = now + 1
					tile_stackL[i][now] = 0
				end
			end
		end
		if tile_stackL[i][now] == 0 and tile_stackL[i][0]~=0 then tile_stackL[i][now]=nil end
	end

end

local function Update ()
	newVar = true
	start_x = (960 - level.width * tile_size)/2
	start_y = floor((544 - (level.height) * tile_size + 19*ceil(level.height / 2))/2)
	newStart_y = (544 - level.height*tile_size)/2
	square_start_x = start_x + 1
	square_start_y = start_y + 1
	level_width, level_height = level.width * tile_size, level.height * tile_size
	frame_x = 0
	frame_y = 0
	frame_old_x,frame_old_y = 0, 0
	level.empty = {}
	level.recInms = getRecord(level.path)
	level.record = toDigits(level.recInms)
	level.cross = {}
	level.square = {}
	level.pen = {}
	level.nowBlocks = 0
	level.allBlocks = 0
	tile_oldAdd, tile_nowAdd = 1, 1
	isRecord = nil
	local tmp = 0

	for i = 1, level.height do

		for j = 1, level.width do

			tmp = tmp + 1
			level.empty[tmp] = 0
			level.square[tmp] = 0
			level.cross[tmp] = 0
			level.pen[tmp] = false
			if level.map[tmp] then

				level.allBlocks = level.allBlocks + 1

			end

		end

	end
	updateStacks()
	ZEWARDO ()
	if not options_status then
		Timer.resume(actionTimer)
		Timer.resume(gameTimer)
	end
end

local function UpdateCreate()
	start_x = (960 - level.width * tile_size)/2
	start_y = floor((544 - level.height * tile_size)/2)
	newStart_y = (544 - level.width*tile_size)/2
	square_start_x = start_x + 1
	square_start_y = start_y + 1
	level_width, level_height = level.width * tile_size, level.height * tile_size
	frame_x = 0
	frame_y = 0
	frame_old_x,frame_old_y = 0, 0
	level.empty = {}
	level.recInms = getRecord(level.path)
	level.record = toDigits(level.recInms)
	level.cross = {}
	level.square = {}
	level.pen = {}
	level.pmap = {}
	tile_oldAdd, tile_nowAdd = 1, 1

	local tmp = 0

	for i = 1, level.height do

		for j = 1, level.width do

			tmp = tmp + 1
			level.empty[tmp] = 0
			level.square[tmp] = 0
			level.cross[tmp] = 0
			level.pen[tmp] = false
			level.pmap[tmp] = white
		end

	end
end

local menu_status, menu_delta, menu_gravity, menu_buttons, menu_now = true, 0, 0, LOCALIZATION.MENU.BUTTONS, 0
local pause_delta, pause_status, pause_gravity, pause_buttons, pause_now = 0, false, 0, LOCALIZATION.PAUSE.BUTTONS, 0
local yes_or_no_delta, yes_or_no_status, yes_or_no_gravity, yes_or_no_now, yes_or_no_buttons = 0, false, 0, 0,LOCALIZATION.YESORNO.BUTTONS
local theme_delta, theme_status, theme_gravity, theme_now, theme_name_y, theme_name_gravity = 0, false, 0, 0, 0, 0
local lselection_delta, lselection_status, lselection_gravity, lselection_now = 0, false, 0, 0
local options_delta, options_status, options_gravity, options_buttons, options_now = 0, false, 0, LOCALIZATION.OPTIONS.BUTTONS , 0
create_delta, create_status, create_gravity, create_buttons, create_now = 0,false,0,LOCALIZATION.CREATE.BUTTONS
create_table_def = {name ="", width = 5, height = 5, map = {}, pmap = {} }
create_table = {name = create_table_def.name, width = create_table_def.width, height = create_table_def.height, map = {}, pmap = {} }
palette_delta, palette_gravity = 0, 0
exit_delta, exit_status, exit_gravity = 0, false, 0
local now_number, number_p_delta, old_color = 0, 0
local lselection_startI, lselection_oldStartI = 1, 1
local systemLevelFolder = scan_folder(now_path)
local holdpath = clvlDir
local head_delta, head_status, head_gravity = 0, true, 0
local Colors_creater = {
	black,Color_new(29,43,82), Color_new(126,37,83),Color_new(0,134,81),
	Color_new(171,81,54),Color_new(95,86,79),Color_new(194,195,199),white,
	Color_new(255,0,76),Color_new(255,163,0),Color_new(255,240,35),Color_new(0,232,81),
	Color_new(36,176,255),Color_new(130,118,156),Color_new(255,118,170),Color_new(255,204,167),
	white,white,white,white
}
local Color_pick = Color_new(0,0,0)
local color_now, color_r, color_g, color_b, color_h, color_s, color_v = 1, 0, 0, 0, 0, 0, 0
local cleared,cleared_gravity = 0, 0

local function return_delta_gravity(status, gravity, delta, rot, add)
	if status then
		if delta+gravity < 1 then
			return delta + gravity, gravity + 0.002*dt,0
			else
			return 1, 0,rot
		end
		else
		if delta - gravity > 0 then
			return delta - gravity, gravity + 0.002*dt,rot
			else
			return 0, 0,rot
		end
	end
end

local function return_key_list(now, up_key, down_key, up_limit, down_limit)
	if not (up_key or down_key) then return now end
	if up_key then
		if now + 1 > up_limit then
			return down_limit
			else
			return now + 1
		end
		elseif down_key then
		if now - 1 < down_limit then
			return up_limit
			else
			return now - 1
		end
	end
end

local function if_now_change(now, i, table, iSize, add, min,max)
	table[iSize] = table[iSize] or min
	if now == i then
		if table[iSize] + add < max then
			table[iSize] = table[iSize] + add
			else
			table[iSize] = max
		end
		else
		if table[iSize] - add > min then
			table[iSize] = table[iSize] - add
			else
			table[iSize] = min
		end
	end
end

local function down_screen (now, delta, table, lock, ...)
	if delta > 0 then
		local nt, t, m = {...}, 1, 272 * delta
		local y = 700 - m - 20 * #table[lng]
		drawRect(0,544 - m, 960, m, black)
		for i=1 ,#table[lng] do
			text = table[lng][i]
			if nt[t] and i==nt[t] then text = text..nt[t + 1] t = t + 2 end
			if lock[i] then
				FontLib_printExtended (480, y, text,3,3,0,  Color_new(255,255,255,40*delta),lng)
			else
				FontLib_printExtended (480, y, text,3,3,0,  Color_new(255,255,255,100*delta),lng)
			end
			if now == i then
				if number_p_delta ~= 1 then
					FontLib_printExtended (480+3*number_p_delta, y-3*number_p_delta, text,3,3,0, Color_new(255,255,255,delta*(100+155*number_p_delta)),lng)
					else
					FontLib_printExtended (480+3, y-3, text,3,3,0, Color_new(255,255,255,255*delta),lng)
				end
			end
			y = y + 40
		end
		return m
	end
end

local function down_buttons (delta, tableNames, tableTex)
	if delta==1 then
		local x, y = 20, 796 - 272*delta
		for i=1, #tableNames[lng] do
			Graphics_drawRotateImage(x, y, tableTex[#tableNames[lng]-i+1], 0)
			FontLib_print(x + 20, y - 6,"- "..tableNames[lng][#tableNames[lng]-i+1], white, lng)
			y = y - 36
		end
	end
end

local function head_screen ()
	if head_status or head_delta>0 then
		head_delta, head_gravity, rot_pause = return_delta_gravity(head_status, head_gravity , head_delta, rot_pause)
		local inv, rot, y = 255 * head_delta, pie / 90 * sin(rot_pause / 2), 272 * head_delta
		drawRect(0, 0, 960, y, black)
		local c1,c2 = Color_new(100, 100, 100, inv), Color_new(255, 255, 255, inv)
		FontLib_printExtended(480, y - 136, LOCALIZATION.HEAD.HEAD[lng], 5, 5, rot, c2,lng)
		FontLib_printExtended(480, y - 100, LOCALIZATION.HEAD.TEXT[lng],3, 1, 0,	 c2,lng)
		if head_delta==1 then
			drawRect(0, y, 960, 2, black)
		end
	end
end

local function menu_screen()
	if (menu_status or menu_delta>0) and options_delta~=1 and create_delta~=1 then
		menu_delta, menu_gravity = return_delta_gravity (menu_status, menu_gravity, menu_delta)
		if menu_delta == 1 and menu_status and not options_status and not lselection_status and not exit_status then
			if PAD_DOWN or PAD_UP then number_p_delta = 0 end
			menu_now = return_key_list(menu_now, PAD_DOWN, PAD_UP, #menu_buttons[lng], 1)
			if pause_status then pause_status = false end
			if PAD_CROSS then
				if menu_now == 1 then
					lselection_status = true
					launch = false
					elseif menu_now == 3 then
					options_status = true
					elseif menu_now == 2 then
					create_status = true
					create_table = {name = create_table_def.name, width = create_table_def.width, height = create_table_def.height, map = {}, pmap = {} }
					elseif menu_now==4 then
					exit_status = true
				end
			end
			elseif menu_delta == 0 then menu_now = 0 uScreen = -1
		end
		if not launch then
			down_screen (menu_now, menu_delta, menu_buttons,{})
			down_buttons (menu_delta,LOCALIZATION.MENU.DOWN_BUTTONS,{ crossbut_tex})
			FontLib_print(726, 800 - 272*menu_delta,"PiCrest v1.01 by @creckeryop",white)
		end
		return true
	end
end

local function pause_screen ()
	if (pause_status or pause_delta>0) and options_delta~=1 then
		pause_delta,pause_gravity = return_delta_gravity (pause_status, pause_gravity, pause_delta)
		if pause_delta==1 and pause_status and not options_status then
			pause_now = return_key_list(pause_now, PAD_DOWN, PAD_UP, #pause_buttons[lng], 1)
			if PAD_UP or PAD_DOWN then number_p_delta = 0 end
			if PAD_CROSS then
				if pause_now==1 then
					pause_status = false
					dontPress = true
					elseif pause_now==2 then
					options_status = true
					elseif pause_now==3 then
					menu_status = true
					else
					pause_now = 1
					number_p_delta = 0
				end
			end
			if (PAD_CIRCLE or PAD_START) and theme_delta==0 then
				pause_status = false
				dontPress = true
			end
			elseif
			pause_delta==0 then pause_now = 0 uScreen = -1
		end
		down_screen (pause_now, pause_delta, pause_buttons,{})
		down_buttons (pause_delta,LOCALIZATION.PAUSE.DOWN_BUTTONS,{crossbut_tex, circlebut_tex})
		return true
	end
end

local function options_screen ()
	if (options_status or options_delta>0) and theme_delta~=1  then
		options_delta,options_gravity = return_delta_gravity (options_status, options_gravity, options_delta)
		if options_status and not theme_status and options_delta==1 then
			if not yes_or_no_status then
				options_now = return_key_list(options_now, PAD_DOWN, PAD_UP, #options_buttons[lng], 1)
				if PAD_UP or PAD_DOWN then 
					number_p_delta = 0 
					if not menu_status then
						if PAD_DOWN and (options_now==2 or options_now==5) then
							options_now = options_now + 1
						elseif PAD_UP and (options_now==2 or options_now==5) then
							options_now = options_now - 1
						end
					end
				end
				if PAD_CIRCLE or options_now==#options_buttons[lng] and PAD_CROSS then options_status=false end
			end
			if (PAD_LEFT or PAD_RIGHT) then
				if options_now == 4 then
					if PAD_LEFT then
					Options["language"] = lng - 1
					else
					Options["language"] = lng + 1
					end
					if Options["language"]<1 then Options["language"] = #FontLib end
					if Options["language"]>#FontLib then Options["language"] = 1 end
					updateCfg(cnfgDir, Options)
					elseif options_now == 3 then
					Animations.now = return_key_list(Animations.now, PAD_RIGHT, PAD_LEFT, #Animations[1], 1)
					Options["animation"] = Animations[1][Animations.now]
					updateCfg(cnfgDir, Options)
					elseif options_now == 2 then
					Options["mistakes"] = 1 - Options["mistakes"]
					updateCfg(cnfgDir, Options)
				end
			end
			if PAD_CROSS then
				if options_now==2 then
					Options["mistakes"] = 1 - Options["mistakes"]
					updateCfg(cnfgDir, Options)
				elseif options_now==1 then
					theme_status = true
					theme_now = 1

					elseif options_now==4 then
					Options["language"] = lng + 1
					if Options["language"]>#FontLib then Options["language"] = 1 end
					updateCfg(cnfgDir, Options)
					elseif options_now==5 then
					if not yes_or_no_status then
						yes_or_no_status = true
						yes_or_no_now = 0
						elseif yes_or_no_now==0 then
						yes_or_no_now = 1
						number_p_delta = 0
						elseif yes_or_no_now==1 then
						local tmpDt = dt
						ResetData ()
						dt = tmpDt
						yes_or_no_status = false
						elseif yes_or_no_now==2 then
						yes_or_no_status = false
					end
				end
			end
			elseif options_delta==0 then options_now = 0
		end
		if menu_status then
		down_screen(options_now, options_delta, options_buttons,{},2," <"..yes_or_no_buttons[lng][2-Options["mistakes"]]..">",3," <"..Animations[lng][Animations.now]..">")
		else
		down_screen(options_now, options_delta, options_buttons,{[2]=true,[5]=true},2," <"..yes_or_no_buttons[lng][2-Options["mistakes"]]..">",3," <"..Animations[lng][Animations.now]..">")
		end
		if options_now==2 then
			down_buttons (options_delta,LOCALIZATION.OPTIONS.DOWN_BUTTONS[1],{circlebut_tex, padlr_tex})
		else
			down_buttons (options_delta,LOCALIZATION.OPTIONS.DOWN_BUTTONS[2],{crossbut_tex, circlebut_tex})
		end

	end
end

local function theme_screen()
	if theme_delta>0 or theme_status then
		theme_delta,theme_gravity = return_delta_gravity (theme_status, theme_gravity, theme_delta)
		theme_name_y,theme_name_gravity = return_delta_gravity (false, theme_name_gravity, theme_name_y)
		if theme_delta == 1 then
			if now_number==0 then
				if PAD_LTRIGGER or PAD_RTRIGGER then
					themes.now = return_key_list(themes.now, PAD_RTRIGGER, PAD_LTRIGGER, #themes, 1)
					local text = thmDir..themes[themes.now]..".thm"
					if themes.now == #themes then
						text = dir.."custom.thm"
					end
					AcceptTheme(text, Colors)
					Options["nowtheme"] = themes[themes.now]
					updateCfg(cnfgDir, Options)
					theme_name_y = 1
					elseif PAD_LEFT or PAD_RIGHT then theme_now = return_key_list(theme_now, PAD_RIGHT, PAD_LEFT, #ColorsTable, 1)
					elseif PAD_CIRCLE then	theme_status = false
					elseif PAD_CROSS then	now_number = 1	old_color = Colors[ColorsTable[theme_now]]
				end
				else
				now_number = return_key_list(now_number,PAD_RIGHT,PAD_LEFT,6,1)
				if PAD_CROSS then
					if  Colors[ColorsTable[theme_now]] ~= old_color then
						MakeTheme(dir.."custom.thm", Colors)
						themes.now = #themes
						Options["nowtheme"] = "custom"
						updateCfg(cnfgDir, Options)
					end
					now_number = 0
					elseif PAD_CIRCLE then	Colors[ColorsTable[theme_now]] = old_color	now_number = 0
					elseif PAD_UP  or PAD_DOWN then
					local hex = rgb2hex(Colors[ColorsTable[theme_now]])
					local next = tonumber(sub(hex,now_number,now_number),16)
					if PAD_UP then
						next = next + 1
						if next>15 then next = 0 end
						number_p_delta = 0
						elseif PAD_DOWN then
						next = next -1
						if next<0 then next = 15 end
						number_p_delta = 2
					end
					Colors[ColorsTable[theme_now]] = Color_new(hex2rgb(sub(hex,0,now_number-1)..string.format("%X",next)..sub(hex,now_number+1,6)))
				end
			end
		end
		local start_x = 240
		local start_y = 544-(544-32)*theme_delta
		local y = start_y+122
		local inv = 255*theme_delta
		local x = start_x
		drawRect(0,0,960,544,Color_new(0, 0, 0, inv))
		Graphics_drawImage(start_x,start_y,tex_but,Color_new(255,255,255,inv))
		FontLib_printExtended(start_x+240,start_y + 16*theme_name_y + 18, upper(Options["nowtheme"]),2,2, 0, newAlpha(Colors.Text,inv-255*theme_name_y))
		drawRect(start_x,start_y+32,480,416,newAlpha(Colors.Background,inv))
		drawRect(start_x + 119, y-1,242,242,newAlpha(Colors.Tile,inv))
		drawRect(start_x + 121, y + 119,238,2,newAlpha(Colors.X5Lines,inv))
		drawRect(start_x + 239, y + 1,2,238,newAlpha(Colors.X5Lines,inv))
		do
			local size = ColorsTable[theme_now+16] or 16
			local key = ColorsTable[theme_now]
			local hex = rgb2hex(Colors[key])
			local inv = 255*(size/16-2+theme_delta)
			local _max = max(8,len(key))*10
			local text_color = newAlpha(Colors.Text,inv)
			drawRect(start_x+240-_max,start_y+400-size,2*_max,70, Color_new(0,0,0,inv))
			FontLib_printExtended(480,start_y+420-size,upper(key),2,2,0,text_color)
			FontLib_printExtended(480,start_y+452-size,"0x"..hex,2,2,0,text_color)
			if now_number>0 then
				drawRect(430+now_number*16,start_y+436-size,16,30, Color_new(0,148,255))
			end
			local text = "  "
			for i=1, 6 do
				if i == now_number then text = text..sub(hex,i,i) else text = text.." " end
			end
			FontLib_printExtended(480+cos(2*rot_pause),start_y+447-size+number_p_delta*5+sin(2*rot_pause),text,2,2,0,text_color)
		end
		for i=1, #ColorsTable do
			local y = i + 16
			if_now_change(theme_now, i, ColorsTable, y, dt, 16, 32)
			drawRect(x + 3, start_y + 448, color_size - 2, ColorsTable[y], Colors[ColorsTable[i]])
			drawRect(x + 3, start_y + 444 + ColorsTable[y], color_size - 2, 4, antishadow)
			x = x + color_size
		end
		for i=0, 9 do
			local x = start_x + 120
			if floor(i/2) == i/2 then drawRect(start_x, y + 1, 111, 22, newAlpha(Colors.SecondBack,inv)) end
			FontLib_print(x - 23, y + 4, "1", newAlpha(Colors.SideNumbers,inv), 0)
			drawRect(x-1,y-1,242,2,newAlpha(Colors.Grid,inv))
			for j=0, 9 do
				if i==0 then
					drawRect(x-1,y-1,2,242,newAlpha(Colors.Grid,inv))
					if floor(j/2)==j/2 then drawRect(x+1,start_y+32,22,81,newAlpha(Colors.SecondBack,inv)) end
					FontLib_print(x + 7 , y - 27,"1",newAlpha(Colors.SideNumbers,inv),0)
				end
				if i==j then Graphics_drawImage(x + 1, y + 1, tile_tex, newAlpha(Colors.Square,inv)) end
				if i>0 and j==0 then Graphics_drawImage(x + 1, y + 1, cross_tex, newAlpha(Colors.Cross,inv)) end
				if j==5 and i<5 then Graphics_drawImage(x + 1, y + 1, pen_tex, newAlpha(Colors.Pen,inv)) end
					x = x + 24
				if i==0 and j==9 then
					drawRect(x-1,y-1,2,242,newAlpha(Colors.Grid,inv))
				end
			end
			y = y + 24
		end
		y = start_y + 122
		drawRect(start_x + 120, y + 119, 240,2,Colors.X5Lines)
		drawRect(start_x + 239, y, 2, 240,Colors.X5Lines)
		drawRect(start_x + 119, y - 1, 242, 2, newAlpha(Colors.Grid,inv))
		drawRect(start_x + 119, y + 239, 242, 2, newAlpha(Colors.Grid,inv))
		drawEmptyRect(start_x, start_y + 32, 480, 416, 2, Color_new(48,48,48,inv))
		drawEmptyRect(start_x, start_y + 32, 480, 420, 6, Color_new(0,0,0,100*theme_delta))
		drawEmptyRect(start_x + 335, y -1,26,26,6,newAlpha(Colors.FrameOutline,inv))
		drawEmptyRect(start_x + 336, y , 24, 24, 4, newAlpha(Colors.Frame,inv))
		if now_number==0 then
			down_buttons (theme_delta,LOCALIZATION.THEMES.DOWN_BUTTONS[1],{ crossbut_tex, circlebut_tex, padlr_tex})
			else
			down_buttons (theme_delta,LOCALIZATION.THEMES.DOWN_BUTTONS[2],{ crossbut_tex, circlebut_tex, padud_tex})

		end
	end
end

local function create_screen()
	if (create_status or create_delta>0) then
		create_delta,create_gravity = return_delta_gravity (create_status, create_gravity, create_delta)

		if create_delta==1 then
			create_now = return_key_list(create_now, PAD_DOWN, PAD_UP, #create_buttons[lng], 1)
			if PAD_UP or PAD_DOWN then number_p_delta = 0 end
			if PAD_LEFT or PAD_RIGHT then
				if create_now == 2 then
					create_table.width = return_key_list(create_table.width, PAD_RIGHT, PAD_LEFT, 15, 5)
					elseif create_now==3 then
					create_table.height = return_key_list(create_table.height, PAD_RIGHT, PAD_LEFT, 15, 5)
				end
			end
				local status = Keyboard.getState()
			if edit_name then
				if status ~= RUNNING then
					if status ~= CANCELED then
						create_table.name = Keyboard.getInput()
						if string.find(create_table.name, "/")~=nil then
							create_table.name = ""
						end
					end
					Keyboard.clear()
					edit_name = false
				end
			end
			if PAD_CIRCLE and status~=RUNNING then create_status = false end
			if PAD_CROSS and status~=RUNNING then
				if create_now==1 then
					Keyboard.show("Input name", create_table.name)
					edit_name = true
					elseif create_now==4 and create_table.name~="" then
					level = create_table
					UpdateCreate()
					isCreate = true
					create_status = false
					menu_status = false
				end
			end
			elseif create_delta==0 then create_now = 0
		end

		local m = down_screen (create_now, create_delta, create_buttons,{},2," <"..create_table.width..">", 3," <"..create_table.height..">")
		if m then
			FontLib_printRotated(480,544-m+40,"<"..create_table.name..">",0,white)
		end
		if create_now==2 or create_now==3 then
			down_buttons (create_delta,LOCALIZATION.CREATE.DOWN_BUTTONS[1],{padlr_tex,circlebut_tex})
		else
			if create_now==1 then
				down_buttons (create_delta,LOCALIZATION.CREATE.DOWN_BUTTONS[2],{crossbut_tex,circlebut_tex})
				else
				down_buttons (create_delta,LOCALIZATION.CREATE.DOWN_BUTTONS[3],{crossbut_tex,circlebut_tex})
			end
		end
		return true
	end
end

local function lselection_screen()

	if lselection_status or lselection_delta>0 then
		lselection_delta,lselection_gravity = return_delta_gravity(lselection_status,lselection_gravity,lselection_delta)
		if lselection_delta==1 then
			if PAD_DOWN then
				if lselection_now <#systemLevelFolder then
					lselection_now = lselection_now + 1
					number_p_delta = 0
				end
				lselection_oldStartI = lselection_startI
				if lselection_now>lselection_startI+4 then lselection_startI = lselection_startI + 1 end
			end
			if PAD_UP then
				if lselection_now==0 then
					lselection_now = 1
					elseif lselection_now>1 then
					lselection_now = lselection_now - 1
					number_p_delta = 0
				end
				lselection_oldStartI = lselection_startI
				if lselection_now<lselection_startI then lselection_startI = lselection_startI - 1 end
			end
			if PAD_CIRCLE then lselection_status = false end
			if PAD_TRIANGLE then
			isCustom = not isCustom
			local tmp = holdpath
			holdpath = now_path
			now_path = tmp
			systemLevelFolder = scan_folder(now_path)
			lselection_now, lselection_startI, lselection_oldStartI = 1, 1, 1

			end
			if lselection_now~=0 and #systemLevelFolder~=0 then
				if PAD_CROSS and systemLevelFolder[lselection_now].dir then
					if systemLevelFolder[lselection_now].name == "..." then
						now_path = sub(now_path,1,len(now_path)-1)
						while (sub(now_path,len(now_path),len(now_path))~="/") do
							now_path = sub(now_path,1,len(now_path)-1)
						end
						else
						now_path = now_path..systemLevelFolder[lselection_now].name
					end
					systemLevelFolder = scan_folder(now_path)
					lselection_now, lselection_startI, lselection_oldStartI = 1, 1, 1
					elseif PAD_CROSS then
					local tempDt = Timer.getTime (DeltaTimer)
					now_level_path = now_path..systemLevelFolder[lselection_now].name..".pcl"
					level = openPCL (now_level_path)
					lselection_status = false
					menu_status = false
					Update ()
					Timer.setTime(DeltaTimer, tempDt)
					launch = true
					isCreate = false
				end
			end
			elseif lselection_delta==0 then
			lselection_now, lselection_startI, lselection_oldStartI = 0, 1, 1 systemLevelFolder = scan_folder(now_path)
		end
		local m = 272 * lselection_delta
		local y = 600 - m
		drawRect(0,544 - m, 960, m, black)
		local add = 0
		local add_x = 40
		if lselection_oldStartI>lselection_startI then add = (number_p_delta-1)*40 elseif lselection_oldStartI<lselection_startI then add = (1-number_p_delta)*40 end
		if not launch and lselection_oldStartI<lselection_startI then
			local text = systemLevelFolder[lselection_oldStartI].name
			FontLib_printScaled (340+add_x, y + add - 40, text , 3, 3, Color_new(255,255,255,100*(1-number_p_delta)))
		end
		local downer = lselection_startI+4
		if not systemLevelFolder[downer] then downer = #systemLevelFolder end
		if not launch and #systemLevelFolder > 5 then
			local size = 200/(#systemLevelFolder)
			local color = Color_new(255,255,255,255*lselection_delta)
			local add = size*(lselection_startI-1)
			if lselection_oldStartI>lselection_startI then
				add = add-size*(number_p_delta-1)
				elseif lselection_oldStartI<lselection_startI then
				add = add+size*(number_p_delta-1)
			end
			drawEmptyRect(300+add_x,y-5,20,210, 2, color)
			drawRect(305+add_x,y+add,10,size*5, color)
		end
		local od = true
		for i=lselection_startI, lselection_startI+4 do
			if systemLevelFolder[i] then
				local text = systemLevelFolder[i].name
				local color1 = Color_new(255,255,255,100*lselection_delta)
				FontLib_printRotated(150, 610 - m, "Info:",0,white)
				if lselection_now == i then
					if not systemLevelFolder[i].dir then
						local rec, name = getRecord(now_path..text..".pcl")
 						if rec == 0 then
							name = "???"
							rec = "No record"
							else
							name = systemLevelFolder[i].realname
							rec=  toDigits(rec)
						end
						local clr, dt = newAlpha(white,255*number_p_delta), 680-m -40*number_p_delta
						FontLib_printRotated(150, dt, name,0, clr)
						FontLib_printRotated(150, dt + 20, systemLevelFolder[i].size,0, clr)
						FontLib_printRotated(150, dt + 40, rec,0, clr)
					else
						local text = "Folder"
						if systemLevelFolder[i].name == "..." then text = "Go back" end
						FontLib_printRotated(150, 700-m-40*number_p_delta, text,0, newAlpha(white,255*number_p_delta))
					end
					local color2 = Color_new(255,255,255,255*number_p_delta)
					FontLib_printScaled (340+add_x, y + add, text,3,3, color1)
					if number_p_delta ~= 1 then
						local d = 3*number_p_delta
						FontLib_printScaled (340+add_x + d, y - d + add, text, 3, 3, color2)
						else
						FontLib_printScaled (343+add_x, y-3, text,3,3, color2)
					end
					else
					if not launch then
						FontLib_printScaled (340+add_x, y + add, text,3,3, color1)
					end
				end
				y = y + 40
				od = false
				elseif od then
				FontLib_printScaled (340+add_x, y + add, "--EMPTY--",3,3,	  Color_new(255,255,255,100*lselection_delta))
				break
			end
		end
		if not launch and lselection_oldStartI>lselection_startI then
			local text = systemLevelFolder[lselection_oldStartI+4].name
			FontLib_printScaled (340+add_x, y + add, text , 3, 3, Color_new(255,255,255,100*(1-number_p_delta)))

		end
		if not launch then
			local tabKeys
			if isCustom then
				if systemLevelFolder[lselection_now] then
				if systemLevelFolder[lselection_now].dir then
					if systemLevelFolder[lselection_now].name == "..." then
						down_buttons (lselection_delta,LOCALIZATION.SELECTION.DOWN_BUTTONS[1],{ crossbut_tex,trianglebut_tex,circlebut_tex})
						else
						down_buttons (lselection_delta,LOCALIZATION.SELECTION.DOWN_BUTTONS[2],{ crossbut_tex,trianglebut_tex,circlebut_tex})
					end
					else
					down_buttons (lselection_delta,LOCALIZATION.SELECTION.DOWN_BUTTONS[3],{ crossbut_tex,trianglebut_tex,circlebut_tex})
				end
				else
					down_buttons (lselection_delta,LOCALIZATION.SELECTION.DOWN_BUTTONS[4],{ trianglebut_tex,circlebut_tex})
				end
				else
				if systemLevelFolder[lselection_now] then
				if systemLevelFolder[lselection_now].dir then
					if systemLevelFolder[lselection_now].name == "..." then
						down_buttons (lselection_delta,LOCALIZATION.SELECTION.DOWN_BUTTONS[5],{ crossbut_tex,trianglebut_tex,circlebut_tex})
						else
						down_buttons (lselection_delta,LOCALIZATION.SELECTION.DOWN_BUTTONS[6],{ crossbut_tex,trianglebut_tex,circlebut_tex})
					end
					else
					down_buttons (lselection_delta,LOCALIZATION.SELECTION.DOWN_BUTTONS[7],{ crossbut_tex,trianglebut_tex,circlebut_tex})
				end
				else
					down_buttons (lselection_delta,LOCALIZATION.SELECTION.DOWN_BUTTONS[8],{ trianglebut_tex,circlebut_tex})
			end
			end
			
			end
		end
end

local function yes_or_no_screen()
	if yes_or_no_status or yes_or_no_delta>0 then
		yes_or_no_delta,yes_or_no_gravity = return_delta_gravity (yes_or_no_status, yes_or_no_gravity, yes_or_no_delta)
		if yes_or_no_delta == 1 and yes_or_no_status then
			if PAD_CIRCLE then yes_or_no_status = false end
			if PAD_UP 	and yes_or_no_now~=1 then yes_or_no_now = 1 number_p_delta = 0 end
			if PAD_DOWN and yes_or_no_now~=2 then yes_or_no_now = 2 number_p_delta = 0 end
			elseif yes_or_no_delta==0 then
			yes_or_no_now = 0
		end
		local m = down_screen (yes_or_no_now, yes_or_no_delta, yes_or_no_buttons, {})
		if m then
			local text
			if lng == 2 then text = "Vy uvereny?" else text = "Are you sure?" end
			local inv = 255*yes_or_no_delta
			FontLib_printExtended(480,584-m,LOCALIZATION.YESORNO.TEXT[lng],3,3,0,Color_new(100,100,100,inv),lng)
			FontLib_printExtended(483,581-m,LOCALIZATION.YESORNO.TEXT[lng],3,3,0,Color_new(255,255,255,inv),lng)
			if yes_or_no_now~=0 then
			down_buttons (yes_or_no_delta,LOCALIZATION.YESORNO.DOWN_BUTTONS[1],{ crossbut_tex, circlebut_tex})
			else
			down_buttons (yes_or_no_delta,LOCALIZATION.YESORNO.DOWN_BUTTONS[2],{  circlebut_tex})
			end
		end
	end
end

local function checkStacks(x,y)
	if Options["mistakes"]==1 then
		local done = 0
		for i = 0, #tile_stackU[x] do
			if tile_stackU[x][i] < 0 then tile_stackU[x][i] = -tile_stackU[x][i] end
			done = done + tile_stackU[x][i]
		end
		local tmp = 0 + x + 1
		for j = 0, level.height-1 do
			if level.empty[tmp]==1 then
				done = done - 1
			end
			tmp = tmp+level.width
		end
		if done==0 then
			for i=0, #tile_stackU[x] do
				tile_stackU[x][i] = -tile_stackU[x][i]
			end
		end
		done = 0
		for i=0, #tile_stackL[y] do
			if tile_stackL[y][i] < 0 then tile_stackL[y][i] = -tile_stackL[y][i] end
			done = done + tile_stackL[y][i]
		end
		tmp = y*level.width
		for j = 0, level.width-1 do
			if level.empty[tmp+j+1]==1 then
				done = done - 1
			end
		end
		if done==0 then
		for i=0, #tile_stackL[y] do
			tile_stackL[y][i] = -tile_stackL[y][i]
		end
	end
	end
end

local function drawLevel ()
	drawRect(start_x - 7 , start_y - 7, level_width + 16, level_height + 16, Colors.Background)
	local dop_x = 4*(1 - mh_rot/pie)*sin(8*mh_rot)
	local dop_y = 3*(1 - mh_rot/pie)*sin(16*mh_rot)- cleared*(start_y-newStart_y)
	drawRect(start_x + dop_x, start_y + dop_y, level_width, level_height, Colors.Tile)
	local y = square_start_y + dop_y 
	local tmp = 0

	for i = 0, level.height-1 do
		local x = square_start_x + dop_x
		if not isColorize and (isCreate or not cleared_status) then
		drawRect(x-2,y-2,level_width,2,Colors.Grid)
		end
		for j = 0, level.width - 1 do

			if not isColorize and (isCreate or not cleared_status) and i == 0 then
				drawRect(x-2,start_y-1+ dop_y,2,level_height+2,Colors.Grid)
			end
			tmp = tmp + 1
			local tmp1,tmp2,tmp3,tmp4 = level.empty[tmp],level.square[tmp],level.cross[tmp],level.pen[tmp]
			if not isCreate and cleared_status or isColorize then
				if isColorize then
					local c = level.pmap[tmp]
					drawRect(x-1, y-1, 24, 24,c)
				else
					local c = white
					if nowGameTimer >= 3600000 then
						if level.map[tmp] then c = black end
					else
						c = changeCLR(level.pmap[tmp],1-cleared)
					end
					drawRect(x-1, y-1, 24, 24,newAlpha(c,255*cleared))
				end
			else
				if Options["animation"] == "off" then

					if tmp1 == 1 then
						Graphics_drawImage(x, y, tile_tex, Colors.Square)
						elseif tmp1 == -1 then
						Graphics_drawImage(x, y, cross_tex, Colors.Cross)
					end
					else
					if tmp2>0 or tmp3>0 then
						local image = cross_tex
						local color = Colors.Cross
						local temp = tmp3
						if tmp2 > 0 then image = tile_tex color = Colors.Square temp = tmp2 end
						if temp > 0 then
							if temp < 1 then
								if Options["animation"]=="rescale" then
									Graphics_drawScaleImage(x + (half_size - 1) * (1 - temp), y + (half_size - 1) * (1 - temp), image, temp, temp, color)
									elseif Options["animation"]=="rotating" then
									Graphics_drawImageExtended(x - 1 + half_size, y - 1 + half_size, image, 0, 0, 22, 22, 2 * pie * temp, temp, temp, color)
									elseif Options["animation"]=="fade" then
									Graphics_drawImage(x, y, image, newAlpha(color,temp*255))
								end
								else
								Graphics_drawImage(x, y, image, color)
							end
						end
					end
				end
				
				if tmp4 then
					Graphics_drawImage(x, y, pen_tex, Colors.Pen)
				end
			end
			x = x + tile_size
			if not isColorize and (isCreate or not cleared_status) and i == 0 and j==level.width - 1 then
				drawRect(x-2,start_y+ dop_y-1,2,level_height+2,Colors.Grid)
			end
			level.square[tmp.."gr"] = level.square[tmp.."gr"] or 0
			level.cross[tmp.."gr"] = level.cross[tmp.."gr"] or 0
			local add
			if Options["animation"] == "fade" then
				add = dt*0.003
				elseif Options["animation"] == "rescale" then
				add = dt*0.005
				elseif Options["animation"] == "rotating" then
				add = dt*0.003
			end
			if add then
				if	tmp2 > 1 and tmp1 == 1 then	
					level.square[tmp] = 1 level.cross[tmp] = 0
					level.square[tmp.."gr"] = 0
				elseif	tmp2 < 0 and tmp1 == 0 then	
					level.square[tmp]	= 0	
					level.square[tmp.."gr"] = 0
				end
				
				if	tmp3 > 1 and tmp1 == -1	then 
					level.cross[tmp]	= 1 level.square[tmp]	= 0
				elseif	tmp3 < 0 and tmp1 == 0	then	
					level.cross[tmp]	= 0				
				end
				
				if	tmp1 == 1	and tmp2 < 1 then
					level.square[tmp.."gr"] = level.square[tmp.."gr"] + add
					level.square[tmp]	= tmp2 + level.square[tmp.."gr"]
				elseif	tmp1 == 0	and tmp2 > 0 then	
					level.square[tmp.."gr"] = level.square[tmp.."gr"] + add
					level.square[tmp]	= tmp2 - level.square[tmp.."gr"]
				end
				
				if	tmp1 == -1	and tmp3 < 1 then 
					level.cross[tmp.."gr"] = level.cross[tmp.."gr"] + add
					level.cross[tmp]	= tmp3 + level.cross[tmp.."gr"]
				elseif	tmp1 == 0	and tmp3 > 0 then	
					level.cross[tmp.."gr"] = level.cross[tmp.."gr"] + add
					level.cross[tmp]	= tmp3 - level.cross[tmp.."gr"]	
				end
			end
		end
		y = y + tile_size
		if not isColorize and (isCreate or not cleared_status) and i == level.height - 1 then
			drawRect(square_start_x-1+ dop_x,y-2,level_width+1,2,Colors.Grid)
			y = square_start_y + dop_y
		end
	end
	if (isCreate or not cleared_status) then
		if  not isColorize then
			for i = 0, level.height-1 do
				if level.height==10 and i==5 or level.height==15 and (i==5 or i==10) then
					drawRect(square_start_x,y-2,level_width-2,2,Colors.X5Lines)
				end
				if i==0 then
					local x = square_start_x + dop_x
					for j = 0, level.width-1 do
						if level.width==10 and j==5 or level.width==15 and (j==5 or j==10) then
							drawRect(x-2,start_y+1+dop_y,2,level_height-2,Colors.X5Lines)
						end
						x = x + tile_size
					end
				end
				y = y + tile_size
			end
		end
		if not palette_status then
			local x, y, inv = start_x + frame_x * tile_size + dop_x, start_y + frame_y * tile_size + dop_y
			drawEmptyRect(x - 1, y - 1, frame_size, frame_size, 6, Colors.FrameOutline)
			drawEmptyRect(x, y, frame_size-2, frame_size-2, 4, Colors.Frame)
		end
	end
end

local function drawUpper ()
	if head_delta==0 then
		local add = -100*cleared
		drawRect(0,add,150,100,Colors.Background)
		drawRect(0,add,150,20,Color_new(255,255,255,50))
		drawRect(0,20+add,170,35,Colors.Background)
		drawRect(0,20+add,170,35,Color_new(0,0,0,200))
		if lng==0 then
			FontLib_printRotated(75,10+add,"Rekord: "..level.record,0,Colors.Text,lng)
			else
			FontLib_printRotated(75,10+add,"Record: "..level.record,0,Colors.Text)
		end
		FontLib_printExtended(85,38+add,toDigits(nowGameTimer),2,2,0,Colors.Text)
		if mh_rot < pie then
			mh_rot = mh_rot + dt*pie/120
			local TwoTwoFive = 255*(1-sin(mh_rot/2))
			FontLib_printExtended(85,38+40*sin(mh_rot/2),"+00:0"..(tile_oldAdd)..":00 ",2,2,0,newAlpha(Colors.Text,TwoTwoFive))
			elseif mh_rot > pie then
			mh_rot = pie
		end
	end
end

local function drawNumbers ()
	local xU, yL = start_x + half_size - 5, start_y + half_size - 8
	local x_U, y_L = xU - 11, yL - 14
	local maximum = max(level.width,level.height)
	for i = 0, maximum do
		local yU, xL = y_L, x_U
		for j = maximum, 0, -1 do
			if tile_stackU[i] and j<=#tile_stackU[i] then
				local textU = tile_stackU[i][j]
				local c = Colors.SideNumbers
				local x = 0
				yU = yU - 19
				if textU<=0 then
					c = newAlpha(c, 150)
					textU = -textU
				end
				if textU/9>1 then x = 5 end
				FontLib_print(xU - x, yU, textU, c, 0)
			end
			if tile_stackL[i] and j<=#tile_stackL[i] then
				local textL = tile_stackL[i][j]
				local c = Colors.SideNumbers
				local x = 0
				xL = xL - 19
				if textL<=0 then
					c = newAlpha(c, 150)
					textL = -textL
				end
				if textL/9>1 then x = 5 end
				FontLib_print(xL - x, yL,textL, c	, 0)
			end
		end
		xU = xU + tile_size
		yL = yL + tile_size
	end
end

local function Controls_frame ()
	if not yes_or_no_status then
	local time = Timer.getTime(actionTimer)
	if pause ~= lock_time then
		local _cross, _circle, _square = Controls.check(pad, SCE_CTRL_CROSS), Controls.check(pad, SCE_CTRL_CIRCLE), Controls.check(pad, SCE_CTRL_SQUARE)
		if not isCreate then
			if not dontPress then
				if _cross or _circle or _square then
					local tmp = frame_y*level.width+frame_x+1
					if tile_storeNum and tile_storePen~=nil then
						if _square then
							if tile_storePen or tile_storeNum~=0 then
								level.pen[tmp] = false
							else
								if level.empty[tmp]==0 then
									level.pen[tmp] = true
								end
							end
						else
						if level.pen[tmp] then level.pen[tmp] = false end
						if  tile_storeNum ~= 0 and level.empty[tmp] ~= 0 then
							if level.empty[tmp] == 1 then
								level.nowBlocks = level.nowBlocks - 1
								newVar = true
							end
							level.empty[tmp] = 0
							checkStacks(frame_x, frame_y)
						end
						end
						if tile_storeNum == 0 and level.empty[tmp] == 0 then
							if _cross then
								if level.map[tmp] then
									level.empty[tmp] = 1
									level.nowBlocks = level.nowBlocks + 1
									newVar = true
									checkStacks(frame_x, frame_y)
									else
									if Options["mistakes"]==1 then
										dontPress = true
										level.empty[tmp] = -1
										minus()
									else
										level.empty[tmp] = 1
										checkStacks(frame_x, frame_y)
										level.nowBlocks = level.nowBlocks + 1
										newVar = true
									end
								end
								level.pen[tmp] = false
								elseif _circle then
								level.empty[tmp] = -1
								level.pen[tmp] = false
							end
						end
						else
						tile_storeNum = level.empty[tmp]
						tile_storePen = level.pen[tmp]
					end
					else
					tile_storeNum = nil
					tile_storePen = nil
				end
				elseif not (_circle or _cross or _square) then
				dontPress = false
			end
		else
			if isColorize then
				if not dontPress then
					if _cross then
						local tmp = frame_y*level.width+frame_x+1
						level.pmap[tmp] = Color_pick
					end
				elseif not _cross then
					dontPress = false
				end
			else
				if not dontPress then
					if _cross then
						local tmp = frame_y*level.width+frame_x+1
						if tile_storeNum then
							if  tile_storeNum ~= 0 and level.empty[tmp] ~= 0 then
								level.empty[tmp] = 0
								if palette_status==nil then
									level.pmap[tmp] = white
								end
							end
							if tile_storeNum == 0 and level.empty[tmp] == 0 then
								if _cross then
									level.empty[tmp] = 1
									if palette_status==nil then
										level.pmap[tmp] = black
									end
								end

							end
							else
							tile_storeNum = level.empty[tmp]
						end
						else
						tile_storeNum = nil
					end
				elseif not _cross then
					dontPress = false
				end
			end
		end
		local pressed = false
		local _up, _down, _left, _right = Controls.check(pad, SCE_CTRL_UP), Controls.check(pad, SCE_CTRL_DOWN), Controls.check(pad, SCE_CTRL_LEFT), Controls.check(pad, SCE_CTRL_RIGHT)
		if _up or _down or _left or _right then
			pressed = true
			if _up ~= Controls.check(newpad, SCE_CTRL_UP) or _down ~= Controls.check(newpad, SCE_CTRL_DOWN) or _left ~= Controls.check(newpad, SCE_CTRL_LEFT) or _right ~= Controls.check(newpad, SCE_CTRL_RIGHT) then
				pause = def_pause
			end
			newpad = pad
		end
		if pause == def_pause or time > pause then
			Timer.reset(actionTimer)
			local changed_y,changed_x = frame_y,frame_x
			if _up then
				if frame_y - 1 < 0 then if not tile_storeNum then frame_y = level.height - 1 end else frame_y = frame_y - 1 end
				elseif _down then
				if frame_y + 1 > level.height - 1 then if not tile_storeNum then frame_y = 0 end else frame_y = frame_y + 1 end
			end
			if _left then
				if frame_x - 1 < 0 then	if not tile_storeNum then frame_x = level.width - 1 end else frame_x = frame_x - 1 end
				elseif _right then
				if frame_x + 1 > level.width - 1 then if not tile_storeNum then frame_x = 0 end else frame_x = frame_x + 1	end
			end
			if pressed then
				if pause == def_pause then
					pause = def_pause + 1
					else
					pause = lil_pause
				end
			end
			if changed_y~=frame_y or changed_x~=frame_x then frame_old_x,frame_old_y = changed_x,changed_y end
		end
		if not pressed and pause~=lock_time then
			pause = def_pause
		end
		else
		if pause < time then
			Timer.reset(actionTimer)
			pause = def_pause
		end
	end
	end
end

local function drawLineU(mode,i)
	local iTile_size = tile_size * i
	local x, y = start_x + half_size,start_y + half_size
	local t = tile_stackL[i]
	local c = Colors.Background
	local w, h = square_start_x - 8, tile_size
	local s_x, s_y = 0, square_start_y + iTile_size - 1
	if mode then
		x, y = x + iTile_size - 5, y - 22
		t = tile_stackU[i]
		w, h = tile_size, square_start_y - 8
		s_x, s_y = square_start_x + iTile_size - 1, 0
		else
		x, y = x - 16, y + iTile_size - 8
	end
	if floor(i/2)==i/2 then c = Colors.SecondBack end
	drawRect(s_x, s_y, w, h, c)
	for k = #t, 0, -1 do
		local n = t[k]
		local c = Colors.SideNumbers
		local add = 0
		if mode then y = y - 19 else x = x - 19 end
		if n<=0 then
			c = newAlpha(c, 150)
			n = -n
		end
		if n/9>1 then add = 5 end
		FontLib_print(x - add, y, n, c, 0)
	end
end

local function SideBackgrounds()
	local y = square_start_y - cleared*(start_y-newStart_y)
	local color_secondback = Colors.SecondBack
	local color_backround = Colors.Background
	for i=0, level.height-1 do
		local x = square_start_x
		local i_len = i/2
		if floor(i_len) == i_len then
			drawRect(0, y - 1, x - 8, tile_size, color_secondback)
			else
			drawRect(0, y - 1, x - 8, tile_size, color_backround)
		end
		if i==0 then
			for j=0, level.width-1 do
				local j_tmp = j/2
				if floor(j_tmp) == j_tmp then
					drawRect(x - 1, 0, tile_size, y - 8, color_secondback)
					else
					drawRect(x - 1, 0, tile_size, y - 8, color_backround)
				end
				x = x + tile_size
			end
		end
		y = y + tile_size
	end
end

function convertToPCL ()
	for i=1, #level.empty do
		if level.empty[i]==1 then
			create_table.map[i] = true 
		else
			create_table.map[i] = false
		end
		create_table.pmap[i] = level.pmap[i]
	end
	createPCL(clvlDir..create_table.name..".pcl",create_table)
end

function checkLevel()
	local tmp, st = 1, true
	for i=1, level.height do
		for j=1, level.width do
			if level.empty[tmp]==1 and not level.map[tmp] then
				st = false break
			end
			tmp = tmp + 1
		end
		if not st then break end
	end
	return st
end

updateAllData ()

local function padUpdate()
	PAD_LEFT, PAD_RIGHT, PAD_UP, PAD_DOWN, PAD_CROSS, PAD_CIRCLE, PAD_TRIANGLE, PAD_LTRIGGER, PAD_RTRIGGER, PAD_START, PAD_SELECT, PAD_SQUARE = Controls_click(SCE_CTRL_LEFT), Controls_click(SCE_CTRL_RIGHT),Controls_click(SCE_CTRL_UP),Controls_click(SCE_CTRL_DOWN),Controls_click(SCE_CTRL_CROSS),Controls_click(SCE_CTRL_CIRCLE),Controls_click(SCE_CTRL_TRIANGLE),Controls_click(SCE_CTRL_LTRIGGER),Controls_click(SCE_CTRL_RTRIGGER),Controls_click(SCE_CTRL_START),Controls_click(SCE_CTRL_SELECT),Controls_click(SCE_CTRL_SQUARE)
end

local start_scene = true
local hide,hide_g = 0,0
while true do
	if not (head_status or cleared_status or isCreate) then
		nowGameTimer = Timer.getTime(gameTimer)
	end
	if hide_status or hide>0 then
		hide, hide_g = return_delta_gravity(hide_status,hide_g,hide,0,0.001)
	end
	lng = Options["language"]
	pad = Controls.read ()
	if head_delta == 1 and isColorize~=nil and menu_status then isColorize = nil palette_status = nil end
	padUpdate()
	dt = newTime / 8
	Timer.reset (DeltaTimer)
	Graphics.initBlend ()
	if menu_status==true and menu_delta==1 then cleared = 0 cleared_status = nil end
	if pause_delta~=0 then dontPress = true end
	if start_scene and menu_delta==1 then start_scene = false end
	if uScreen~=2 or pause_delta>0 or menu_delta>0 or cleared>0 then
		if not start_scene 	then 
			Screen.clear (Colors.Background) 
			if square_start_y~=nil and not isCreate then SideBackgrounds ()	end
		end
	end
	if yes_or_no_status or menu_status or pause_status or theme_status or lselection_status or create_status or options_status then
		head_status = true
		else
		head_status = false
	end
	if isCreate and head_delta==1 and yes_or_no_status then
		if PAD_CROSS and yes_or_no_now==1 then
			local dtTime = Timer.getTime(DeltaTimer)
			local make = false
			for i=1, #create_table.empty do
				if create_table.empty[i]==1 then make = true break end
			end
			if make then
			convertToPCL()
			yes_or_no_status = false
			menu_status = true
			menu_delta = 1
			Timer.setTime(DeltaTimer, dtTime)
			else
			yes_or_no_status = false
			
			end
			elseif PAD_CROSS then
			yes_or_no_status = false
		end
	end
	if isCreate and head_delta~=1 then 
		SideBackgrounds ()	
		if head_delta==0 then if not palette_status then Controls_frame () end end
		drawLevel ()
		if head_delta==0 then
			if isColorize then
				down_buttons (1,LOCALIZATION.CREATE.DOWN_BUTTONS2[1],{ circlebut_tex, crossbut_tex, squarebut_tex, trianglebut_tex})
			else
				down_buttons (1,LOCALIZATION.CREATE.DOWN_BUTTONS2[2],{ crossbut_tex, squarebut_tex, trianglebut_tex})
			end
		end
		if PAD_TRIANGLE and not yes_or_no_status then
			yes_or_no_status = true
		end
		if PAD_CIRCLE and isColorize and not yes_or_no_status then
			palette_status = not palette_status
			if not palette_status then
				if (Colors_creater[20]~=Color_pick and Colors_creater[19]~=Color_pick and Colors_creater[18]~=Color_pick and Colors_creater[17]~=Color_pick) then
					Colors_creater[17] = Colors_creater[18]
					Colors_creater[18] = Colors_creater[19]
					Colors_creater[19] = Colors_creater[20]
					Colors_creater[20] = Color_pick
				end
			end
		end
		if palette_status then
			dontPress = true
			if color_now<=#Colors_creater then
				if PAD_UP then
					color_now = color_now - 4
					if color_now<0 then	color_now = #Colors_creater+6	end
				end
				if PAD_LEFT then
					color_now = color_now - 1
					if color_now/4==floor(color_now/4) then
						color_now = color_now + 4
					end
				end
				if PAD_RIGHT then
					if color_now/4==floor(color_now/4) then
						color_now = color_now - 3
						else
						color_now = color_now + 1
					end
				end
				if PAD_DOWN then
					color_now = color_now + 4
					if color_now>#Colors_creater then color_now = #Colors_creater+1 end
				end
				else
				if PAD_UP then
					color_now = color_now - 1
				end
				if PAD_DOWN then
					color_now = color_now + 1
					if color_now>#Colors_creater+6 then
						color_now = 1
					end
				end
				
				local time = Timer.getTime(actionTimer)
				local pressed = false
				local _left, _right = Controls.check(pad, SCE_CTRL_LEFT), Controls.check(pad, SCE_CTRL_RIGHT)
				if _left or _right then	pressed = true	end
				if pause == def_pause or time > pause then
					Timer.reset(actionTimer)
					if _left then
						if color_now==#Colors_creater+1 then
							if color_r-1>0 then
								color_r = color_r - 1
							else
								color_r = 0
							end
							elseif color_now==#Colors_creater+2 then
							if color_g-1>0 then
								color_g = color_g - 1
							else
								color_g = 0
							end
							elseif color_now==#Colors_creater+3 then
							if color_b - 1>0 then
								color_b = color_b - 1
							else
								color_b  = 0
							end
							elseif color_now==#Colors_creater+4 then
								if color_h-1>0 then
									color_h = color_h - 1
								else
									color_h = 0
								end
							elseif color_now==#Colors_creater+5 then
								if color_s-0.01>0 then
									color_s = color_s - 0.01
								else
									color_s = 0
								end
							elseif color_now==#Colors_creater+6 then
								if color_v-0.01>0 then
									color_v = color_v - 0.01
								else
									color_v = 0
								end
						end
						elseif _right then
						if color_now==#Colors_creater+1 then
							if color_r+1<255 then
								color_r = color_r + 1
							else
								color_r = 255
							end
							elseif color_now==#Colors_creater+2 then
							if color_g+1<255 then
								color_g = color_g + 1
							else
								color_g = 255
							end
							elseif color_now==#Colors_creater+3 then
							if color_b + 1<255 then
								color_b = color_b + 1
							else
								color_b  = 255
							end
							elseif color_now==#Colors_creater+4 then
								if color_h+1<360 then
									color_h = color_h + 1
								else
									color_h = 360
								end
							elseif color_now==#Colors_creater+5 then
								if color_s+0.01<1 then
									color_s = color_s + 0.01
								else
									color_s = 1
								end
							elseif color_now==#Colors_creater+6 then
								if color_v+0.01<1 then
									color_v = color_v + 0.01
								else
									color_v = 1
								end
						end
					end
					if pressed then
						if color_now<#Colors_creater+4 then
						Color_pick = Color_new(color_r,color_g,color_b)
						color_h,color_s,color_v = getHSV(Color_pick)
						else
						Color_pick = Color_new(setHSV(color_h,color_s,color_v))
						color_r,color_g,color_b = setHSV(color_h,color_s,color_v)
						end
						if pause==def_pause then
							pause = def_pause + 1
						else
							pause = pause/2
						end
					end

				end
				if not pressed and pause~=lock_time then
					pause = def_pause
				end
			end
			if PAD_CROSS and color_now>0 and color_now<=#Colors_creater then
				Color_pick = Colors_creater[color_now]
				color_r = Color.getR(Color_pick)
				color_g = Color.getG(Color_pick)
				color_b = Color.getB(Color_pick)
				color_h,color_s,color_v = getHSV(Color_pick)
			end
		end
		if PAD_SQUARE then
			isColorize = not isColorize
			palette_status = false
			uScreen = -2
		end
		if palette_delta~=1 or palette_delta~=0 then
			uScreen = -2
		end
		palette_delta,palette_gravity = return_delta_gravity (palette_status, palette_gravity, palette_delta)
		if palette_delta>0 then
			local x = 896-start_x/2
			local y = 544-454*palette_delta
			local t = 1
			drawRect(x-4,y-4,136,364,black)
			drawRect(x-3,y-3,134,362,white)
			for i=1, #Colors_creater/4 do
				for j=1, 4 do
					drawRect(x+2,y+2,28,28,black)
					drawRect(x+3,y+3,26,26,Colors_creater[t])
					if color_now==t then
						drawEmptyRect(x+1,y+1,30,30,5,Colors.FrameOutline)
						drawEmptyRect(x+2,y+2,28,28,3,Colors.Frame)
					end
					x = x + 32
					t = t + 1
				end
				y = y + 32
				x = x - 128
			end
			y = y + 5
			drawRect(x+3,y,26,92,Color_pick)
			drawEmptyRect(x+3,y,26,92,1,black)
			x = x + 34
			for i=1, 6 do
				if i==4 then
				Graphics.drawImage(x,y+10,rainbow)
				elseif i==5 then
				drawRect(x,y+10,90,4,Color.new(setHSV(color_h,1,1)))
				Graphics.drawImage(x,y+10,light)
				drawRect(x,y+10,90,4,Color.new(0,0,0,255*(1-color_v)))
				elseif i==6 then
				drawRect(x,y+10,90,4,Color.new(setHSV(color_h,color_s,1)))
				Graphics.drawImage(x,y+10,light,black)
				else
				drawRect(x,y+10,90,4,black)
				end
				if i==4 then
				FontLib_print(x-24,y+4,"H",black)
				elseif i==5 then
				FontLib_print(x-24,y+4,"S",black)
				elseif i==6 then
				FontLib_print(x-24,y+4,"V",black)
				end
				local add = color_r
				if i==2 then
					add = color_g
					elseif i==3 then
					add = color_b
					elseif i==4 then
					add = color_h
					elseif i==5 then
					add = color_s
					elseif i==6 then
					add = color_v
				end
				local tmp = add
				if i<4 then
				tmp = math.floor(tmp)
				add = 83/255*add
				elseif i>4 then
				if i==5 then
					tmp = math.floor(tmp*100)
					add = 83*add
					else
					tmp = math.floor(tmp*100)
					add = 83*add
				end
				else
				tmp = math.floor(tmp)
				add = 83/360*add
				end
				FontLib_printRotated(floor(x+add+3),y-2,tmp,0,black)
				drawRect(x+add-4,y+5,14,14,black)
				if i==1 then
					drawRect(x+add-3,y+6,12,12,Color_new(255,0,0))
					elseif i==2 then
					drawRect(x+add-3,y+6,12,12,Color_new(0,255,0))
					elseif i==3 then
					drawRect(x+add-3,y+6,12,12,Color_new(0,0,255))
					elseif i==4 then
					drawRect(x+add-3,y+6,12,12,Color_new(setHSV(color_h,1,1)))
					elseif i==5 then
					drawRect(x+add-3,y+6,12,12,Color_new(255,255,255))
					elseif i==6 then
					drawRect(x+add-3,y+6,12,12,Color_new(255,255,255))
				end
				if color_now == t then
					drawEmptyRect(x-5+add,y+4,16,16,4,Colors.FrameOutline)
					drawEmptyRect(x-4+add,y+5,14,14,2,Colors.Frame)
				end
				y = y + 32
				t = t + 1
			end
		end
		if uScreen~=2 then
			if not menu_status and menu_delta==0 and pause_delta==0 then
				if isColorize then
					FontLib_printExtended(476,544-floor(start_y/2),"Color level",4,4,0,shadow)
					FontLib_printExtended(480,540-floor(start_y/2),"Color level",4,4,0,Colors.Text)
				else
					FontLib_printExtended(476,544-floor(start_y/2),"Make level",4,4,0,shadow)
					FontLib_printExtended(480,540-floor(start_y/2),"Make level",4,4,0,Colors.Text)
				end
				uScreen = uScreen + 1
			end
		end
	end
	if not (start_scene or hide==1 or head_delta==1) and not isCreate then
		if head_delta==0 then Controls_frame () end
		drawLevel ()
		if not isCreate then if cleared~=1 then drawUpper () end end
	end
	if not isCreate and not cleared_status then
		if uScreen~=2 then
			if not menu_status and menu_delta==0 and pause_delta==0 then
				drawNumbers ()
				uScreen = uScreen + 1
			end
			elseif pause_delta==0 and not menu_status then
			drawLineU(LINE_VERTICAL, frame_x)
			drawLineU(LINE_HORIZONTAL, frame_y)
			if frame_old_x~=frame_x then drawLineU(LINE_VERTICAL,frame_old_x) end
			if frame_old_y~=frame_y then drawLineU(LINE_HORIZONTAL, frame_old_y) end
		end
	end
	rot_pause = rot_pause + pie/60 * dt
	if rot_pause > all_max then rot_pause = rot_pause - all_max end
	if number_p_delta<1 then number_p_delta = number_p_delta + 0.1 end
	if number_p_delta>1 then number_p_delta = number_p_delta - 0.1 end
	if not (head_status or pause_status)  and PAD_START and not cleared_status then pause_status = true end
	if pause_delta == 1 and menu_delta==1 and menu_status then pause_status 	= false	end
	if head_delta  == 0 and launch then launch = false	end
	if cleared_status or cleared>0 then
		cleared, cleared_gravity = return_delta_gravity(cleared_status,cleared_gravity,cleared,0,0.001)
		
		drawRect(960-start_x+32,0,40,544,newAlpha(black,255*cleared))
		FontLib_printExtended(480,100*cleared-50,level.name,3,3,0,newAlpha(Colors.Text,255*cleared))
		
		if nowGameTimer>3600000 then
		FontLib_printExtended(960-start_x+50,272*cleared,"TIME OVER",3,3,pie/2,newAlpha(Colors.Text,255*cleared))
		else
		FontLib_printExtended(960-start_x+50,272*cleared,"CLEARED",3,3,pie/2,newAlpha(Colors.Text,255*cleared))
		if cleared~=1 and cleared~=0 then
			local x, y, r, s, m = (level_width)*cleared,(level_height)*cleared,2*pie*cleared,4*cleared,255*(1-cleared)
			local ty = start_y+level_height/2-(start_y-newStart_y)*cleared
			Graphics_drawImageExtended(480+x,ty+y,star,0,0,16,16,r,s,s,newAlpha(Color.new(255,0,0),m))
			Graphics_drawImageExtended(480+x,ty-y,star,0,0,16,16,r,s,s,newAlpha(Color.new(0,255,0),m))
			Graphics_drawImageExtended(480-x,ty+y,star,0,0,16,16,r,s,s,newAlpha(Color.new(0,0,255),m))
			Graphics_drawImageExtended(480-x,ty-y,star,0,0,16,16,r,s,s,newAlpha(Color.new(255,148,0),m))
		end
		end
		if isRecord then 
			FontLib_printExtended(480,594-100*cleared,"NEW RECORD",3,3,0,Colors.Text)
			else
			FontLib_printExtended(480,594-100*cleared,"RECORD:"..level.record,3,3,0,Colors.Text)
		end
		local time = nowGameTimer
		local text = "Time:"..toDigits(time)
		FontLib_printExtended(490,624-100*cleared,text,2,2,0,Colors.Text)
		if PAD_CROSS then
			hide_status = true
		end
		if hide==1 then
			if isRecord then
				Timer.pause(DeltaTimer)
				updateRecord(now_level_path, time)
				Timer.resume(DeltaTimer)
			end
			menu_delta = 1
			head_delta = 1
			cleared_status = false
			menu_status = true
			hide_status = false
		end
		
	end
	head_screen ()
	pause_screen ()
	menu_screen ()
	create_screen ()
	options_screen ()
	yes_or_no_screen ()
	theme_screen ()
	lselection_screen ()
	if pause_status and Timer.isPlaying(gameTimer) then
		Timer.pause(gameTimer)
		elseif not (pause_status or Timer.isPlaying(gameTimer)) and pause_delta==0 and not cleared_status then
		Timer.resume(gameTimer)
	end
	if not menu_status and not isCreate and level.nowBlocks == level.allBlocks and newVar then
		newVar = false
		if checkLevel() then
			dontPress = true
			Timer.pause(gameTimer)
			if not cleared_status then cleared_status = true end
			if isRecord == nil then
				local time = nowGameTimer
				if tonumber(level.recInms) == 0 or tonumber(level.recInms) > time then
					level.recInms = time
					isRecord = true
					else
					isRecord = false
				end
			end
		end
	end
	if exit_delta>0 or exit_status then
		exit_delta, exit_gravity = return_delta_gravity(exit_status, exit_gravity, exit_delta)
		drawRect(0,0,960,544,newAlpha(black,exit_delta*255))
	end
	drawRect(0,0,960,544,Color_new(0,0,0,255*hide))
	if hide>0 and isRecord then FontLib_printExtended(480,272,"Saving",3,3,0,Color_new(255,255,255,255*hide)) end
	Graphics.termBlend()
	--if PAD_SELECT then FontLib_close () FTP = FTP + 1	end
	Screen.waitVblankStart ()
	Screen.flip ()
	newTime = Timer.getTime (DeltaTimer)
	oldpad = pad
	if exit_delta==1 then
		Graphics.termBlend()
		FontLib_close ()
		System.exit()
	end
end			