--[[
Bekonchiki UI Library
Первая часть: Заставка + Окно + Вкладки + Секции + Элементы
Автор: beconchikitim
]]

local Library = {}
Library.__index = Library

-- Сервисы
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- 1. Заставка
-- =========================
local function ShowLoadingScreen(assetId, duration)
    local gui = Instance.new("ScreenGui")
    gui.Name = "BekonchikiLoading"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local bg = Instance.new("Frame", gui)
    bg.Size = UDim2.new(1,0,1,0)
    bg.Position = UDim2.new(0,0,0,0)
    bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    bg.BackgroundTransparency = 0.5

    local image = Instance.new("ImageLabel", gui)
    image.Size = UDim2.new(0,400,0,100)
    image.Position = UDim2.new(0.5,0,0.5,0)
    image.AnchorPoint = Vector2.new(0.5,0.5)
    image.BackgroundTransparency = 1
    image.Image = "rbxassetid://"..assetId
    image.ScaleType = Enum.ScaleType.Fit

    task.delay(duration, function()
        gui:Destroy()
    end)
end

-- Показываем заставку на 2 секунды
ShowLoadingScreen("81525974663680", 2)

-- =========================
-- 2. Создание окна
-- =========================
function Library:CreateWindow(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = title:gsub("%s","").."GUI"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 350, 0, 500)
    main.Position = UDim2.new(0.3,0,0.2,0)
    main.BackgroundColor3 = Color3.fromRGB(25,25,25)
    main.Active = true
    main.Draggable = true
    main.Name = "MainWindow"
    main.Visible = false -- скроем пока идёт заставка

    -- Заголовок
    local titleBar = Instance.new("TextLabel", main)
    titleBar.Size = UDim2.new(1,0,0,40)
    titleBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
    titleBar.Text = title
    titleBar.TextColor3 = Color3.fromRGB(255,255,255)
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 18
    titleBar.TextXAlignment = Enum.TextXAlignment.Left
    titleBar.Position = UDim2.new(0,10,0,0)

    -- Контейнер вкладок
    local tabContainer = Instance.new("Frame", main)
    tabContainer.Size = UDim2.new(1,0,1,-40)
    tabContainer.Position = UDim2.new(0,0,0,40)
    tabContainer.BackgroundTransparency = 1

    local tabs = {}
    local window = setmetatable({
        Gui = gui,
        Main = main,
        TitleBar = titleBar,
        TabContainer = tabContainer,
        Tabs = tabs
    }, Library)

    -- Показываем окно после заставки
    task.delay(2, function()
        main.Visible = true
    end)

    return window
end

-- =========================
-- 3. Вкладки и секции
-- =========================
function Library:CreateTab(name)
    local tabFrame = Instance.new("Frame", self.TabContainer)
    tabFrame.Size = UDim2.new(1,0,1,0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false

    local sectionList = Instance.new("UIListLayout", tabFrame)
    sectionList.SortOrder = Enum.SortOrder.LayoutOrder
    sectionList.Padding = UDim.new(0,10)

    local tab = {Frame=tabFrame, Sections={}}
    function tab:AddSection(sectionName)
        local sectionFrame = Instance.new("Frame", tabFrame)
        sectionFrame.Size = UDim2.new(1,-20,0,150)
        sectionFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
        sectionFrame.LayoutOrder = #tab.Sections + 1
        sectionFrame.Name = sectionName

        local uiList = Instance.new("UIListLayout", sectionFrame)
        uiList.SortOrder = Enum.SortOrder.LayoutOrder
        uiList.Padding = UDim.new(0,5)

        local sectionLabel = Instance.new("TextLabel", sectionFrame)
        sectionLabel.Size = UDim2.new(1,0,0,25)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = sectionName
        sectionLabel.TextColor3 = Color3.fromRGB(255,255,255)
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.TextSize = 16
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Position = UDim2.new(0,10,0,0)
        sectionLabel.LayoutOrder = 0

        local section = {Frame = sectionFrame}

        -- ===== Элементы =====
        function section:CreateButton(text, callback)
            local btn = Instance.new("TextButton", sectionFrame)
            btn.Size = UDim2.new(1,-20,0,35)
            btn.Position = UDim2.new(0,10,0,0)
            btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Text = text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 16
            btn.LayoutOrder = #sectionFrame:GetChildren()
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        function section:CreateToggle(text, default, callback)
            local toggleFrame = Instance.new("Frame", sectionFrame)
            toggleFrame.Size = UDim2.new(1,-20,0,35)
            toggleFrame.Position = UDim2.new(0,10,0,0)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
            toggleFrame.LayoutOrder = #sectionFrame:GetChildren()

            local label = Instance.new("TextLabel", toggleFrame)
            label.Size = UDim2.new(0.7,0,1,0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.Font = Enum.Font.Gotham
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left

            local button = Instance.new("TextButton", toggleFrame)
            button.Size = UDim2.new(0.25,0,0.8,0)
            button.Position = UDim2.new(0.7,0,0.1,0)
            button.BackgroundColor3 = default and Color3.fromRGB(0,170,255) or Color3.fromRGB(70,70,70)
            button.Text = ""

            button.MouseButton1Click:Connect(function()
                default = not default
                button.BackgroundColor3 = default and Color3.fromRGB(0,170,255) or Color3.fromRGB(70,70,70)
                if callback then callback(default) end
            end)
        end

        function section:CreateSlider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame", sectionFrame)
            sliderFrame.Size = UDim2.new(1,-20,0,35)
            sliderFrame.Position = UDim2.new(0,10,0,0)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
            sliderFrame.LayoutOrder = #sectionFrame:GetChildren()

            local label = Instance.new("TextLabel", sliderFrame)
            label.Size = UDim2.new(0.5,0,1,0)
            label.BackgroundTransparency = 1
            label.Text = text.." "..tostring(default)
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.Font = Enum.Font.Gotham
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left

            local bar = Instance.new("Frame", sliderFrame)
            bar.Size = UDim2.new(0.45,0,0.3,0)
            bar.Position = UDim2.new(0.5,0,0.35,0)
            bar.BackgroundColor3 = Color3.fromRGB(70,70,70)

            local handle = Instance.new("Frame", bar)
            handle.Size = UDim2.new((default-min)/(max-min),1,1,0)
            handle.BackgroundColor3 = Color3.fromRGB(0,170,255)

            handle.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    local conn
                    conn = UserInputService.InputChanged:Connect(function(i)
                        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
                            local pos = i.Position.X - bar.AbsolutePosition.X
                            local frac = math.clamp(pos / bar.AbsoluteSize.X,0,1)
                            handle.Size = UDim2.new(frac,0,1,0)
                            local value = min + frac * (max-min)
                            label.Text = text.." "..math.floor(value)
                            if callback then callback(value) end
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(i2)
                        if i2.UserInputType==Enum.UserInputType.MouseButton1 or i2.UserInputType==Enum.UserInputType.Touch then
                            conn:Disconnect()
                        end
                    end)
                end
            end)
        end

        -- Добавляем секцию в вкладку
        tab.Sections[#tab.Sections+1] = section
        return section
    end

    -- Добавляем вкладку в окно
    self.Tabs[#self.Tabs+1] = tab
    return tab
end

return Library


-- Часть 2: Dropdown, TextBox, Notifications, Tween-анимации
-- вставляем сюда код из второй части, который мы делали ранее
-- функция CreateDropdown, CreateTextBox, Notify, ShowLoading, TweenObject и SwitchTab
-- внутри section
function section:CreateDropdown(text,options,callback)
    local frame = Instance.new("Frame", sectionFrame)
    frame.Size = UDim2.new(1,-20,0,35)
    frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
    frame.LayoutOrder = #sectionFrame:GetChildren()
    frame.Position = UDim2.new(0,10,0,0)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.45,0,1,0)
    button.Position = UDim2.new(0.5,0,0,0)
    button.BackgroundColor3 = Color3.fromRGB(70,70,70)
    button.Text = options[1] or ""
    button.Font = Enum.Font.Gotham
    button.TextSize = 16

    local dropdownFrame = Instance.new("Frame", frame)
    dropdownFrame.Size = UDim2.new(1,0,0,0)
    dropdownFrame.Position = UDim2.new(0,0,1,0)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    dropdownFrame.ClipsDescendants = true

    for i,opt in pairs(options) do
        local optBtn = Instance.new("TextButton", dropdownFrame)
        optBtn.Size = UDim2.new(1,0,0,30)
        optBtn.Position = UDim2.new(0,0,(i-1)*30,0)
        optBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        optBtn.Text = opt
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 16
        optBtn.TextColor3 = Color3.fromRGB(255,255,255)
        optBtn.MouseButton1Click:Connect(function()
            button.Text = opt
            if callback then callback(opt) end
            TweenService:Create(dropdownFrame,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,0)}):Play()
        end)
    end

    button.MouseButton1Click:Connect(function()
        local targetSize = dropdownFrame.Size.Y.Scale>0 or #options*30
        TweenService:Create(dropdownFrame,TweenInfo.new(0.2),{Size=UDim2.new(1,0,targetSize,0)}):Play()
    end)
end

function section:CreateTextBox(text,placeholder,callback)
    local frame = Instance.new("Frame", sectionFrame)
    frame.Size = UDim2.new(1,-20,0,35)
    frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
    frame.LayoutOrder = #sectionFrame:GetChildren()
    frame.Position = UDim2.new(0,10,0,0)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.4,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local textbox = Instance.new("TextBox", frame)
    textbox.Size = UDim2.new(0.55,0,1,0)
    textbox.Position = UDim2.new(0.45,0,0,0)
    textbox.BackgroundColor3 = Color3.fromRGB(70,70,70)
    textbox.TextColor3 = Color3.fromRGB(255,255,255)
    textbox.PlaceholderText = placeholder or ""
    textbox.Font = Enum.Font.Gotham
    textbox.TextSize = 16
    textbox.FocusLost:Connect(function(enterPressed)
        if callback then callback(textbox.Text) end
    end)
end

function Library:Notify(title,msg,duration)
    local gui = Instance.new("ScreenGui",CoreGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,300,0,60)
    frame.Position = UDim2.new(0.5,-150,0.1,0)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.AnchorPoint = Vector2.new(0.5,0)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = title.."\n"..msg
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextWrapped = true

    frame.Position = UDim2.new(0.5,-150,0,0)
    TweenService:Create(frame,TweenInfo.new(0.3),{Position=UDim2.new(0.5,-150,0.15,0)}):Play()
    task.delay(duration or 3,function()
        TweenService:Create(frame,TweenInfo.new(0.3),{Position=UDim2.new(0.5,-150,0,0)}):Play()
        task.delay(0.3,function() gui:Destroy() end)
    end)
end

-- Для централизованного загрузочного текста
function Library:ShowLoading(title)
    local gui = Instance.new("ScreenGui",CoreGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,400,0,100)
    frame.Position = UDim2.new(0.5,-200,0.5,-50)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.AnchorPoint = Vector2.new(0.5,0.5)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(0,170,255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 32
    label.TextScaled = true

    TweenService:Create(label,TweenInfo.new(1.5,{EasingStyle=Enum.EasingStyle.Quad,RepeatCount=math.huge,Reverses=true}),
        {TextTransparency=0.5}):Play()
    return gui,frame,label
end


-- Часть 3: ColorPicker, сохранение настроек, анимации, финальные улучшения
-- вставляем сюда код из третьей части, который мы только что написали
-- функция CreateColorPicker, SaveConfig, LoadConfig, ShowCenterLoading, Init
-- Часть 3: ColorPicker, сохранение, анимации, финальные улучшения

-- функция ColorPicker
function section:CreateColorPicker(text,default,callback)
    local frame = Instance.new("Frame", sectionFrame)
    frame.Size = UDim2.new(1,-20,0,40)
    frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
    frame.LayoutOrder = #sectionFrame:GetChildren()
    frame.Position = UDim2.new(0,10,0,0)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local colorFrame = Instance.new("Frame", frame)
    colorFrame.Size = UDim2.new(0.45,0,0.8,0)
    colorFrame.Position = UDim2.new(0.5,0,0.1,0)
    colorFrame.BackgroundColor3 = default or Color3.fromRGB(0,170,255)

    colorFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local colorGui = Instance.new("ScreenGui",CoreGui)
            local picker = Instance.new("Frame", colorGui)
            picker.Size = UDim2.new(0,250,0,250)
            picker.Position = UDim2.new(0.5,-125,0.5,-125)
            picker.BackgroundColor3 = Color3.fromRGB(30,30,30)
            local closeBtn = Instance.new("TextButton", picker)
            closeBtn.Size = UDim2.new(0,30,0,30)
            closeBtn.Position = UDim2.new(1,-35,0,5)
            closeBtn.Text = "X"
            closeBtn.MouseButton1Click:Connect(function()
                colorGui:Destroy()
            end)
            local rSlider = Instance.new("TextButton", picker)
            rSlider.Size = UDim2.new(0.8,0,0,20)
            rSlider.Position = UDim2.new(0.1,0,0.2,0)
            rSlider.BackgroundColor3 = Color3.fromRGB(255,0,0)
            local gSlider = rSlider:Clone()
            gSlider.Position = UDim2.new(0.1,0,0.4,0)
            gSlider.BackgroundColor3 = Color3.fromRGB(0,255,0)
            gSlider.Parent = picker
            local bSlider = rSlider:Clone()
            bSlider.Position = UDim2.new(0.1,0,0.6,0)
            bSlider.BackgroundColor3 = Color3.fromRGB(0,0,255)
            bSlider.Parent = picker
            local function updateColor()
                local c = Color3.fromRGB(rSlider.BackgroundTransparency*0, gSlider.BackgroundTransparency*0, bSlider.BackgroundTransparency*0)
                colorFrame.BackgroundColor3 = c
                if callback then callback(c) end
            end
        end
    end)
end

-- сохранение и загрузка настроек
Library.Config = {}
function Library:SaveConfig(fileName)
    if not isfolder("CustomUI") then makefolder("CustomUI") end
    writefile("CustomUI/"..(fileName or "config")..".txt", game:GetService("HttpService"):JSONEncode(self.Config))
end

function Library:LoadConfig(fileName)
    if isfile("CustomUI/"..(fileName or "config")..".txt") then
        local data = game:GetService("HttpService"):JSONDecode(readfile("CustomUI/"..(fileName or "config")..".txt"))
        for k,v in pairs(data) do
            self.Config[k] = v
        end
    end
end

-- плавные анимации для кнопок и вкладок
function Library:TweenObject(obj,props,time,style,dir)
    TweenService:Create(obj,TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),props):Play()
end

-- центр загрузки с Tween-эффектом (можно вставить картинку как декаль)
function Library:ShowCenterLoading(title)
    local gui = Instance.new("ScreenGui",CoreGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,400,0,100)
    frame.Position = UDim2.new(0.5,-200,0.5,-50)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = title or "bekonchiki"
    label.TextColor3 = Color3.fromRGB(0,170,255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 32
    label.TextScaled = true
    TweenService:Create(label,TweenInfo.new(1.5,{EasingStyle=Enum.EasingStyle.Quad,RepeatCount=math.huge,Reverses=true}),
        {TextTransparency=0.5}):Play()
    return gui,frame,label
end

-- плавное появление/скрытие вкладок
function Library:SwitchTab(tabToShow)
    for _,tab in pairs(self.Tabs) do
        if tab==tabToShow then
            tab.Frame.Visible = true
            self:TweenObject(tab.Frame,{BackgroundTransparency=0},0.3)
        else
            tab.Frame.Visible = false
        end
    end
end

-- финальная настройка элементов UI
function Library:Init()
    if self.Tabs[1] then self:SwitchTab(self.Tabs[1]) end
end

-- конец части 3, дальше вставляем return Library


return Library