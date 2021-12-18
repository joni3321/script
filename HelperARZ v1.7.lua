script_name('Helper')
script_author('Tomato.')
script_description('Helper ARZ')
script_version("1.8")

local use = false
local close = false
local use1 = false
local close1 = false

require 'lib.moonloader'


local key = require 'vkeys'
local color = 0x348cb2
local dlstatus = require('moonloader').download_status
local encoding = require 'encoding'
local font = renderCreateFont("Arial", 8, 5)
local samp = require 'samp.events'
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local ia = require 'imgui_addons'
local sampevcheck, sampev = pcall(require, "lib.samp.events")
local event = require ('lib.samp.events')
local events = require ('lib.samp.events')
local ev = require('lib.samp.events')
encoding.default = 'CP1251'
u8 = encoding.UTF8
local tag = "Helper:"
local blacklistedWords = {u8'mq', 'Маму ебал', 'rnq', 'Эмкью' , 'Rnq', 'MQ', 'Mq', 'mQ', 'Мкью', 'Мать шлюха', 'сын бляди', 'mamy ebal', 'эмкью', 'RNQ', 'Сын бляди', 'Mamy ebal', 'MAMY EBAL', 'сын даунихи', ' Сын даунихи', 'СЫН ШЛЮХИ', 'У тебя мать шлюха', 'у тебя мать шлюха', 'мать далбаеба', 'МАТЬ далбаеба', 'mq', 'mqmq', 'mqmq', 'mqmqmq', 'mqmqmq', 'mqmqmqmq', 'mqmqmqmqmq', 'mqmqmqmqmqmq', 'MQMQ', 'MQMQMQ', 'MQMQMQMQ','кусок конченой шлюхи', 'У тебя мать шлюхааа', 'Мать уебка',}
local selected = 1

local mainIni = inicfg.load({
    config = {
    antiban = false,
    sendprem = false,
    sendvip = false,
    sendpremtext = "",
    sendviptext = "",
    sendpayday = false,
    sendpaydaytext = "",
    sendlovlya = false,
    sendlovlyatext = "",
	antirvanka = false,
	bunnyhop = false,
	dmg = false,
	autokushat = false,
	kushatprocent = tonumber(1),
	eatmetod = 0,
	autopass = false,
	password = '',
	emulator = false,
	lavka = false,
 }
 }, "HelperARZ")
 
local binds = {
	{0, "Ничего", 60}
}

local buf = {}
local floats = {}
local timer = {}

lua_thread.create(function()
	for i=1, #binds do
		buf[i] = imgui.ImBuffer(128)
		floats[i] = imgui.ImFloat(binds[i][3])
	end
end)

local main_window_state = imgui.ImBool(false)
local main_window_state = imgui.ImBool(false)
local sw, sh = getScreenResolution()

local antiban = imgui.ImBool(mainIni.config.antiban)
local bunnyhop = imgui.ImBool(mainIni.config.bunnyhop)
local dmg = imgui.ImBool(mainIni.config.dmg)
local antirvanka = imgui.ImBool(mainIni.config.antirvanka)
local sendprem = imgui.ImBool(mainIni.config.sendprem)
local sendvip = imgui.ImBool(mainIni.config.sendvip)
local sendpremtext = imgui.ImBuffer(tostring(mainIni.config.sendpremtext), 270)
local sendviptext = imgui.ImBuffer(tostring(mainIni.config.sendviptext), 270)
local sendpayday = imgui.ImBool(mainIni.config.sendpayday)
local sendpaydaytext = imgui.ImBuffer(tostring(mainIni.config.sendpaydaytext), 270)
local sendlovlya = imgui.ImBool(mainIni.config.sendlovlya)
local sendlovlyatext = imgui.ImBuffer(tostring(mainIni.config.sendlovlyatext), 270)
local eatmetod = imgui.ImInt(mainIni.config.eatmetod)
local kushatprocent = imgui.ImInt(mainIni.config.kushatprocent)
local autokushat = imgui.ImBool(mainIni.config.autokushat)
local autopass = imgui.ImBool(mainIni.config.autopass)
local pass = imgui.ImBuffer(''..mainIni.config.password, 256)
local emulator = imgui.ImBool(mainIni.config.emulator)
local lavka = imgui.ImBool(mainIni.config.lavka)
-- vars for config

local metod = {
u8'Чипсы',
u8'Оленина',
u8'Мешок с мясом'
}

function imgui.TextQuestion(text)
    imgui.SameLine()
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function imgui.Link(link,name,myfunc)
    myfunc = type(name) == 'boolean' and name or myfunc or false
    name = type(name) == 'string' and name or type(name) == 'boolean' and link or link
    local size = imgui.CalcTextSize(name)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local resultBtn = imgui.InvisibleButton('##'..link..name, size)
    if resultBtn then
        if not myfunc then
            os.execute('explorer '..link)
        end
    end
    imgui.SetCursorPos(p2)
    if imgui.IsItemHovered() then
        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ButtonHovered], name)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]))
    else
        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.Button], name)
    end
    return resultBtn
end
-------------------------------------------
local lower, sub, char, upper = string.lower, string.sub, string.char, string.upper
local concat = table.concat

local lu_rus, ul_rus = {}, {}
for i = 192, 223 do
    local A, a = char(i), char(i + 32)
    ul_rus[A] = a
    lu_rus[a] = A
end
local E, e = char(168), char(184)
ul_rus[E] = e
lu_rus[e] = E


function string.nupper(s)
    s = upper(s)
    local len, res = #s, {}
    for i = 1, len do
        local ch = sub(s, i, i)
        res[i] = lu_rus[ch] or ch
    end
    return concat(res)
end
---------------------------------------------

if not doesFileExist('moonloader/config/HelperARZ.ini') then inicfg.save(mainIni, 'HelperARZ.ini') end
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
    sampAddChatMessage("[ARZHelper] {D5DEDD}Был загружен! Автор: {01A0E9} Joni_Bradley.", 0x01A0E9)
    sampAddChatMessage("[ARZHelper] {D5DEDD}Команда: /arzhelper ", 0x01A0E9)
	sampRegisterChatCommand("arzhelper", function()
        main_window_state.v = not main_window_state.v

        imgui.Process = main_window_state.v
    end)

    imgui.Process = false
	
	while true do
        wait(0)
        if main_window_state.v == false then
            imgui.Process = false
        end
                if sampTextdrawIsExists(2061) then
	            _, _, eat, _ = sampTextdrawGetBoxEnabledColorAndSize(2061)
	            eat = (eat - imgui.ImVec2(sampTextdrawGetPos(2061)).x) * 1.83
	            if math.floor(eat) < kushatprocent.v then
		            if autokushat.v then
			            if eatmetod.v == 0 then
				        sampSendChat('/cheeps')
			            end
			            if eatmetod.v == 1 then
				        sampSendChat('/jmeat')
			            end
			            if eatmetod.v == 2 then
				        sampSendChat('/meatbag')
			            end
		            end
	            end
	end
	
end
end
			
	if sampevcheck == false then
		print("Внимание, отсутствует библиотека SAMP.lua, скрипт завершил работу.", -1)
		print("Скачать её можно в гугле, нужно закинуть в папку moonloader/lib", -1)
		thisScript():unload()
	end
	
function imgui.OnDrawFrame()
    imgui.SetNextWindowSize(imgui.ImVec2(780, 300), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

    imgui.Begin(u8"ARZHelper | V: 1.7 Release | Автор: Tomato", main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove)
	imgui.BeginChild("functii", imgui.ImVec2(-1, 23)) 
        if imgui.Button(u8"Функции", imgui.ImVec2(125, -1)) then selected = 1 end
	imgui.SameLine()
	    if imgui.Button(u8"О скрипте", imgui.ImVec2(120, -1)) then selected = 2 end
    imgui.SameLine()
	    if imgui.Button(u8"Автоеда/Автопароль", imgui.ImVec2(150, -1)) then selected = 3 end
	imgui.SameLine()
	    if imgui.Button(u8"Читы", imgui.ImVec2(110, -1)) then selected = 4 end
	imgui.SameLine()
	    if imgui.Button(u8"Биндер", imgui.ImVec2(100, -1)) then selected = 5 end
	imgui.SameLine()
    imgui.EndChild()
    imgui.BeginChild("main", imgui.ImVec2(-1, -1))
    if selected == 1 then
        imgui.Separator()
        imgui.Checkbox(u8 "АнтиБан", antiban) imgui.SameLine() imgui.TextQuestion(u8"Когда вы заходите написать нехорошие слова,то система не даст вам это сделать")
        save2()
        imgui.Checkbox(u8 "Перевод секунд в минуты", dmg) imgui.SameLine() imgui.TextQuestion(u8"Переводит секунды в минуты(деморган)")
        save2()
		imgui.Checkbox(u8 "Антирванка", antirvanka) imgui.SameLine() imgui.TextQuestion(u8"Защищает вас от рванок")
        save2()
		imgui.Separator() imgui.CenterText(u8"Отправка сообщений при действии:") imgui.Text("") ia.ToggleButton("#sendprem", sendprem) imgui.SameLine() imgui.Text(u8"Фраза при покупке PREMIUM VIP") imgui.SameLine() imgui.TextQuestion(u8"Когда игрок купил премиум, то это высвечивается в чат, и при включении функции, в вип-чат будет отправляться сообщение, которое вы напишите ниже") save2()
        imgui.PushItemWidth(210)
        imgui.InputText(u8"##lol", sendpremtext)
        imgui.PopItemWidth()
        save2()
        imgui.Text("")
        ia.ToggleButton("#sendvip", sendvip) imgui.SameLine() imgui.Text(u8"Фраза при покупке TITAN VIP") imgui.SameLine() imgui.TextQuestion(u8"Когда игрок купил титан вип, то это высвечивается в чат, и при включении функции, в вип-чат будет отправляться сообщение, которое вы напишите ниже") save2()
        imgui.PushItemWidth(210)
        imgui.InputText(u8"", sendviptext)
        imgui.PopItemWidth()
        save2()
		imgui.Text("")
        ia.ToggleButton("#sendlovlya1", sendlovlya) imgui.SameLine() imgui.Text(u8"Фраза при ловле дома") imgui.SameLine() imgui.TextQuestion(u8"Когда вы словили дом, то в вип-чат отправится сообщение, которое вы напишите ниже") save2()
        imgui.PushItemWidth(210)
        imgui.InputText(u8"##abobusneamogus", sendlovlyatext)
        imgui.PopItemWidth()
        save2()
        imgui.Text("")
        ia.ToggleButton("#sendpaydaylol", sendpayday) imgui.SameLine() imgui.Text(u8"Фраза при PayDay") imgui.SameLine() imgui.TextQuestion(u8"Когда на сервере произошел PayDay, то в вип-чат выводится текст, который вы напишите ниже") save2() save2()
        imgui.PushItemWidth(210)
        imgui.InputText(u8"##flds", sendpaydaytext)
        imgui.PopItemWidth()
        save2()
    elseif selected == 2 then
        imgui.Separator()

        imgui.CenterText(u8"Информация об скрипте:")
		imgui.CenterText(u8"Универсальный хелпер имеющий много функций")
		imgui.CenterText(u8'Если есть какие либо вопросы,писать в вк')
        imgui.Text("")
		imgui.Text("") imgui.SameLine(120) imgui.Text(u8"ВК Автора:") imgui.SameLine() imgui.Link("https://vk.com/jonibradley", "VK.")
        imgui.Text("") imgui.SameLine(120) imgui.Text(u8"Автор скрипта:") imgui.SameLine() imgui.Link("https://www.blast.hk/members/449591/", "Tomato.")
		imgui.Text("") imgui.SameLine(120) imgui.Text(u8"Тема на BlastHack") imgui.SameLine() imgui.Link("https://www.blast.hk/threads/105099/", "BlackHack")
	elseif selected == 3 then
	    imgui.Checkbox(u8'Автоеда ', autokushat)
		if autokushat.v then
		imgui.Combo(u8'Выбор способа еды',eatmetod,metod, -1)
		imgui.Text(u8'Процент голода, при котором персонаж будет есть:')
		imgui.SliderInt(u8'',kushatprocent, 1, 99)
		save2()
		end
		imgui.Checkbox(u8'Автоввод пароля', autopass)
		if autopass.v then
		imgui.InputText(u8'Введите пароль от аккаунта', pass)
		end
	elseif selected == 4 then
        imgui.Separator()
		imgui.Checkbox(u8 "Анти Банни-Хоп", bunnyhop) imgui.SameLine() imgui.TextQuestion(u8"Анти банни хоп(думаю все понятно)")
        save2()
		imgui.Checkbox(u8 "Эмулятор Лаунчера(PC)", emulator) imgui.SameLine() imgui.TextQuestion(u8"Дает право получать бонусы и открывать сундуки")
        save2()
		imgui.Checkbox(u8 "Ловец лавок", lavka) imgui.SameLine() imgui.TextQuestion(u8"Эта фукция сама ловит за тебя лавку на ЦР")
        save2()
	elseif selected == 5 then
	    for i=1, #binds do
			imgui.BeginChild("##"..i, imgui.ImVec2(720, 150))
				local enable
				imgui.InputText(u8"Текст бинда #"..i, buf[i])
				imgui.Text(u8"###"..i..u8" Текст:  "..binds[i][2])
				imgui.SliderFloat(u8"Задержка бинда(В секундах) #"..i, floats[i], 5, 600, 0, 1)
				binds[i][3] = floats[i].v
				if binds[i][1] == 0 then if imgui.Button(u8"Начать пиар") then binds[i][1] = 1 piarStart(i) end else if imgui.Button(u8"Закончить пиар") then binds[i][1] = 0 end end
				imgui.SetCursorPosX(600)
				if imgui.Button(u8"Удалить бинд #"..i) then deleteBind(i) end
			imgui.EndChild()
		end
		imgui.SetCursorPosX(287)
		if imgui.Button(u8"Сохранить все настройки", imgui.ImVec2(175, 75)) then save() print(binds[1][3]) end
		imgui.SetCursorPosX(300)
		if imgui.Button(u8"Новый бинд", imgui.ImVec2(150, 75)) then createNewBind() end	
	end
    imgui.EndChild()
    imgui.End()
end

function style() -- стиль имгуи
    imgui.SwitchContext()
    local style  = imgui.GetStyle()
    local colors = style.Colors
    local clr    = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding       = ImVec2(10, 10)
    style.WindowRounding      = 10
    style.ChildWindowRounding = 2
    style.FramePadding        = ImVec2(5, 4)
    style.FrameRounding       = 11
    style.ItemSpacing         = ImVec2(4, 4)
    style.TouchExtraPadding   = ImVec2(0, 0)
    style.IndentSpacing       = 21
    style.ScrollbarSize       = 16
    style.ScrollbarRounding   = 16
    style.GrabMinSize         = 11
    style.GrabRounding        = 16
    style.WindowTitleAlign    = ImVec2(0.5, 0.5)
    style.ButtonTextAlign     = ImVec2(0.5, 0.5)

    colors[clr.Text]                 = ImVec4(0.86, 0.93, 0.89, 0.78)
            colors[clr.TextDisabled]         = ImVec4(0.36, 0.42, 0.47, 1.00)
            colors[clr.WindowBg]             = ImVec4(0.11, 0.15, 0.17, 1.00)
            colors[clr.ChildWindowBg]        = ImVec4(0.15, 0.18, 0.22, 1.00)
            colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94)
            colors[clr.Border]               = ImVec4(0.43, 0.43, 0.50, 0.50)
            colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.FrameBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
            colors[clr.FrameBgHovered]       = ImVec4(0.19, 0.12, 0.28, 1.00)
            colors[clr.FrameBgActive]        = ImVec4(0.09, 0.12, 0.14, 1.00)
            colors[clr.TitleBg]              = ImVec4(0.04, 0.04, 0.04, 1.00)
            colors[clr.TitleBgActive]        = ImVec4(0.41, 0.19, 0.63, 1.00)
            colors[clr.TitleBgCollapsed]     = ImVec4(0.00, 0.00, 0.00, 0.51)
            colors[clr.MenuBarBg]            = ImVec4(0.15, 0.18, 0.22, 1.00)
            colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.39)
            colors[clr.ScrollbarGrab]        = ImVec4(0.20, 0.25, 0.29, 1.00)
            colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
            colors[clr.ScrollbarGrabActive]  = ImVec4(0.20, 0.09, 0.31, 1.00)
            colors[clr.ComboBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
            colors[clr.CheckMark]            = ImVec4(0.59, 0.28, 1.00, 1.00)
            colors[clr.SliderGrab]           = ImVec4(0.41, 0.19, 0.63, 1.00)
            colors[clr.SliderGrabActive]     = ImVec4(0.41, 0.19, 0.63, 1.00)
            colors[clr.Button]               = ImVec4(0.41, 0.19, 0.63, 0.44)
            colors[clr.ButtonHovered]        = ImVec4(0.41, 0.19, 0.63, 0.86)
            colors[clr.ButtonActive]         = ImVec4(0.64, 0.33, 0.94, 1.00)
            colors[clr.Header]               = ImVec4(0.20, 0.25, 0.29, 0.55)
            colors[clr.HeaderHovered]        = ImVec4(0.51, 0.26, 0.98, 0.80)
            colors[clr.HeaderActive]         = ImVec4(0.53, 0.26, 0.98, 1.00)
            colors[clr.Separator]            = ImVec4(0.50, 0.50, 0.50, 1.00)
            colors[clr.SeparatorHovered]     = ImVec4(0.60, 0.60, 0.70, 1.00)
            colors[clr.SeparatorActive]      = ImVec4(0.70, 0.70, 0.90, 1.00)
            colors[clr.ResizeGrip]           = ImVec4(0.59, 0.26, 0.98, 0.25)
            colors[clr.ResizeGripHovered]    = ImVec4(0.61, 0.26, 0.98, 0.67)
            colors[clr.ResizeGripActive]     = ImVec4(0.06, 0.05, 0.07, 1.00)
            colors[clr.CloseButton]          = ImVec4(0.40, 0.39, 0.38, 0.16)
            colors[clr.CloseButtonHovered]   = ImVec4(0.40, 0.39, 0.38, 0.39)
            colors[clr.CloseButtonActive]    = ImVec4(0.40, 0.39, 0.38, 1.00)
            colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
            colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
            colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
            colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
            colors[clr.TextSelectedBg]       = ImVec4(0.25, 1.00, 0.00, 0.43)
            colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
style()

function save2()
    mainIni.config.antiban = antiban.v
    mainIni.config.sendprem = sendprem.v
    mainIni.config.sendvip = sendvip.v
    mainIni.config.sendpremtext = sendpremtext.v
    mainIni.config.sendviptext = sendviptext.v
    mainIni.config.sendpayday = sendpayday.v
    mainIni.config.sendpaydaytext = sendpaydaytext.v
    mainIni.config.sendlovlya = sendlovlya.v
    mainIni.config.sendlovlyatext = sendlovlyatext.v
	mainIni.config.antirvanka = antirvanka.v
	mainIni.config.bunnyhop = bunnyhop.v
	mainIni.config.dmg = dmg.v
	mainIni.config.autokushat = autokushat.v
	mainIni.config.kushatprocent = kushatprocent.v
	mainIni.config.eatmetod = eatmetod.v
	mainIni.config.password = pass.v 
	mainIni.config.autopass = autopass.v
	mainIni.config.emulator = emulator.v
	mainIni.config.lavka = lavka.v
    inicfg.save(mainIni, "HelperARZ.ini")
end

function sampev.onServerMessage(color, text)
    if sendprem.v then
        if text:find("Игрок (.-) приобрел PREMIUM VIP") then
            sampSendChat("/vr " .. u8:decode(mainIni.config.sendpremtext))
        end
    end
    if sendvip.v then
        if text:find("Игрок (.-) приобрел Titan VIP") then
            sampSendChat("/vr " .. u8:decode(mainIni.config.sendviptext))
        end
    end
    if sendpayday.v then
        if text:find("__________Банковский чек__________") then
            sampSendChat("/vr " .. u8:decode(mainIni.config.sendpaydaytext))
        end
    end
    if sendlovlya.v then
        if text:find("Поздравляю! Теперь этот дом ваш!") then
            sampSendChat("/vr " .. u8:decode(mainIni.config.sendlovlyatext))
        end
    end  
end

function sampev.onSendCommand(text)
    if antiban.v then
        for i = 1, #blacklistedWords do
            if text:find('/vr') and text:find(blacklistedWords[i]) then
                sampAddChatMessage("{FF0000}Не ругайся!", -1)
                return false
            end
        end
    end
end

--Антирванка Автор: MrCreepTon
function ev.onPlayerSync(id, data)
	if antirvanka.v then
		local x, y, z = getCharCoordinates(PLAYER_PED)
		if x - data.position.x > -1.5 and x - data.position.x < 1.5 then
			if (data.moveSpeed.x >= 1.5 or data.moveSpeed.x <= -1.5) or (data.moveSpeed.y >= 1.5 or data.moveSpeed.y <= -1.5) or (data.moveSpeed.z >= 0.5 or data.moveSpeed.z <= -0.5) then
				data.moveSpeed.x, data.moveSpeed.y, data.moveSpeed.z = 0, 0, 0
			end
		end
	end
	return {id, data}
end

function ev.onVehicleSync(id, vehid, data)
	if antirvanka.v then
		local x, y, z = getCharCoordinates(PLAYER_PED)
		if x - data.position.x > -1.5 and x - data.position.x < 1.5 then
			if (data.moveSpeed.x >= 1.5 or data.moveSpeed.x <= -1.5) or (data.moveSpeed.y >= 1.5 or data.moveSpeed.y <= -1.5) or (data.moveSpeed.z >= 0.5 or data.moveSpeed.z <= -0.5) then
				data.moveSpeed.x, data.moveSpeed.y, data.moveSpeed.z = 0, 0, 0
				data.position.x = data.position.x - 5
			end
		end
	end
	return {id, vehid, data}
end

function ev.onDisplayGameText(style, time, text)
	if dmg.v then
	    if style == 3 and time == 1000 and text:find("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %d+ Sec%.") then
		  local c, _ = math.modf(tonumber(text:match("Jailed (%d+)")) / 60)
		  return {style, time, string.format("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %s Sec = %s Min.", text:match("Jailed (%d+)"), c)}
		end
	end
end

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function separator(text)
	if text:find("$") then
	    for S in string.gmatch(text, "%$%d+") do
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	    for S in string.gmatch(text, "%d+%$") do
	    	S = string.sub(S, 0, #S-1)
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	end
	return text
end

function ev.onShowDialog(dialogId, style, title, button1, button2, text)
	text = separator(text)
	title = separator(title)
	return {dialogId, style, title, button1, button2, text}
end

function ev.onServerMessage(color, text)
	text = separator(text)
	return {color, text}
end

function ev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
	text = separator(text)
	return {id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text}
end

function ev.onTextDrawSetString(id, text)
	text = separator(text)
	return {id, text}
end

function event.onSendPlayerSync(data)
    if bunnyhop.v then
	  if bit.band(data.keysData, 0x28) == 0x28 then
		  data.keysData = bit.bxor(data.keysData, 0x20)
	  end
    end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if mainIni.config.autopass then
	    if dialogId == 2 and text:find('Введите свой пароль') and Password ~= '' and not text:find('Неверный пароль') then
		sampSendDialogResponse(dialogId, 1, nil, mainIni.config.password)
		return false
	    end
	end
	if dialogId == 3010 and lavka.v then
		sampSendDialogResponse(dialogId, 1, 0, 0)
		sampAddChatMessage("{FF0000}[AC]{FFFFFF} Вы поймали {ffb400}лавку!", -1)
	end
end

function samp.onSendClientJoin(Ver, mod, nick, response, authKey, clientver, unk)
    if emulator.v then
	    clientver = 'Arizona PC'
	    return {Ver, mod, nick, response, authKey, clientver, unk}
	end
end

function events.onSetObjectMaterialText(ev, data)
	local Object = sampGetObjectHandleBySampId(ev)
	if doesObjectExist(Object) and getObjectModel(Object) == 18663 and string.find(data.text, "(.-) {30A332}Свободная!") then
		if get_distance(Object) and lavka.v then
			lua_thread.create(press_key)
		end
	end
end

function press_key()
	setGameKeyState(21, 256)
end

function get_distance(Object)
	local result, posX, posY, posZ = getObjectCoordinates(Object)
	if result then
		if doesObjectExist(Object) then
			local pPosX, pPosY, pPosZ = getCharCoordinates(PLAYER_PED)
			local distance = (math.abs(posX - pPosX)^2 + math.abs(posY - pPosY)^2)^0.5
			local posX, posY = convert3DCoordsToScreen(posX, posY, posZ)
			if round(distance, 2) <= 0.9 then
				return true
			end
		end
	end
	return false
end

function round(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

function save()
	lua_thread.create(function()
		for i=1, #binds do
			binds[i][2] = buf[i].v
		end
	end)
	inicfg.save(binds, "HelperARZ")
end

function load()
	inicfg.load(binds, "HelperARZ")
end

load()

local wh, wy = getScreenResolution()

local cx = wh / 2
local cy = wy / 2

function createNewBind()
	table.insert(binds, {0, "Ничего", 60})
	local n = #binds
	buf[n] = imgui.ImBuffer(128)
	floats[n] = imgui.ImFloat(binds[n][3])
	save()
end

function deleteBind(number)
	table.remove(binds, number)
	table.remove(floats, number)
	table.remove(buf, number)
	save()
end

function piarStart(number)
	lua_thread.create(function()
		if binds[number][1] == 1 then
			while binds[number][1] == 1 do
				sampSendChat(u8:decode(binds[number][2]))
				wait(binds[number][3] * 1000)
			end
		end
	end)
end

function update()
    local updatePath = os.getenv('TEMP')..'\\Update.json'
    -- Проверка новой версии
    downloadUrlToFile("https://www.dropbox.com/s/jrbdc1q88gq9z2q/Update.json?dl=1", updatePath, function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local file = io.open(updatePath, 'r')
            if file and doesFileExist(updatePath) then
                local info = decodeJson(file:read("*a"))
                file:close(); os.remove(updatePath)
                if info.version ~= thisScript().version then
                    lua_thread.create(function()
                        wait(2000)
                        -- Загрузка скрипта, если версия изменилась
                        downloadUrlToFile("https://www.dropbox.com/s/zftchr0rh84glw0/HelperARZ%20v1.7.lua?dl=1", thisScript().path, function(id, status, p1, p2)
                            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                                -- Обновление успешно загружено, новая версия: info.version
                                thisScript():reload()
                            end
                        end)
                    end)
                else
                    -- Обновлений нет
                end
            end
        end
    end)
end