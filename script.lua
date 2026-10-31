-- ============================================================
-- ⚡ ARCANIX v21.0 (Key System + Main Core)
-- ============================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- ==========================================
-- 1. СИСТЕМА СОХРАНЕНИЯ БАНА (ФАЙЛЫ)
-- ==========================================
local banFile = "ArcanixBan.txt"
local isBanned = false
local banEndTime = 0
local hasFileSystem = writefile and readfile and isfile

if hasFileSystem and isfile(banFile) then
    local success, savedTime = pcall(function() return tonumber(readfile(banFile)) end)
    if success and savedTime and savedTime > os.time() then
        isBanned = true
        banEndTime = savedTime
    end
end

if not isBanned and getgenv().ArcanixBanEndTime and getgenv().ArcanixBanEndTime > os.time() then
    isBanned = true
    banEndTime = getgenv().ArcanixBanEndTime
end

-- ==========================================
-- 2. ИНТЕРФЕЙС КЛЮЧА (ДИНАМИТ)
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "ArcanixKeySystem"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = CoreGui

local flash = Instance.new("Frame")
flash.Size = UDim2.new(1, 0, 1, 0)
flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flash.BackgroundTransparency = 1
flash.ZIndex = 10
flash.Parent = gui

local tnt = Instance.new("ImageLabel")
tnt.Size = UDim2.new(0, 100, 0, 100)
tnt.AnchorPoint = Vector2.new(0.5, 0.5)
tnt.Position = UDim2.new(0.5, 0, -0.2, 0)
tnt.BackgroundTransparency = 1
tnt.Image = "rbxassetid://1007305922" 
tnt.ZIndex = 9
tnt.Parent = gui

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BackgroundTransparency = 1
frame.Visible = false
frame.ZIndex = 5
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 150, 255)
stroke.Thickness = 2
stroke.Transparency = 1
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "⚡ ARCANIX KEY"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextTransparency = 1
title.TextSize = 20
title.Font = Enum.Font.Arcade
title.ZIndex = 6
title.Parent = frame

local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1, 0, 0, 20)
timerLabel.Position = UDim2.new(0, 0, 0, 35)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = ""
timerLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
timerLabel.TextTransparency = 1
timerLabel.TextSize = 16
timerLabel.Font = Enum.Font.Arcade
timerLabel.ZIndex = 6
timerLabel.Parent = frame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 240, 0, 40)
keyInput.Position = UDim2.new(0.5, -120, 0, 60)
keyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
keyInput.BackgroundTransparency = 1
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.Text = ""
keyInput.TextTransparency = 1
keyInput.PlaceholderText = "" 
keyInput.TextSize = 16
keyInput.Font = Enum.Font.Arcade
keyInput.ClearTextOnFocus = false
keyInput.ZIndex = 6
keyInput.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = keyInput

local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0, 240, 0, 40)
checkBtn.Position = UDim2.new(0.5, -120, 0, 110)
checkBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
checkBtn.BackgroundTransparency = 1
checkBtn.Text = "ПРОВЕРИТЬ"
checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
checkBtn.TextTransparency = 1
checkBtn.TextSize = 16
checkBtn.Font = Enum.Font.Arcade
checkBtn.ZIndex = 6
checkBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = checkBtn

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(1, 0, 0, 20)
errorLabel.Position = UDim2.new(0, 0, 1, -25)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
errorLabel.TextTransparency = 1
errorLabel.TextSize = 14
errorLabel.Font = Enum.Font.Arcade
errorLabel.ZIndex = 6
errorLabel.Parent = frame

-- АНИМАЦИЯ ПОЯВЛЕНИЯ
task.spawn(function()
    task.wait(0.5)
    local dropInfo = TweenInfo.new(0.6, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
    TweenService:Create(tnt, dropInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.8)
    
    local explodeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(flash, explodeInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(tnt, explodeInfo, {Size = UDim2.new(0, 300, 0, 300), ImageTransparency = 1}):Play()
    task.wait(0.3)
    
    local fadeFlashInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(flash, fadeFlashInfo, {BackgroundTransparency = 1}):Play()
    
    frame.Visible = true
    local menuFadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(frame, menuFadeInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(stroke, menuFadeInfo, {Transparency = 0}):Play()
    TweenService:Create(title, menuFadeInfo, {TextTransparency = 0}):Play()
    TweenService:Create(keyInput, menuFadeInfo, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    TweenService:Create(checkBtn, menuFadeInfo, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    TweenService:Create(errorLabel, menuFadeInfo, {TextTransparency = 0}):Play()
    tnt:Destroy()
end)

-- ==========================================
-- 3. ЛОГИКА БЛОКИРОВКИ
-- ==========================================
local attempts = 0

local function updateBanUI()
    keyInput.Text = "🔒"
    keyInput.TextEditable = false
    keyInput.BackgroundTransparency = 0.5
    checkBtn.Active = false
    checkBtn.Text = "ЗАБЛОКИРОВАНО"
    checkBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    timerLabel.TextTransparency = 0
    errorLabel.Text = "ВЫ ЗАБЛОКИРОВАНЫ НА 24 ЧАСА"
    errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    
    task.spawn(function()
        while isBanned do
            local timeLeft = banEndTime - os.time()
            if timeLeft <= 0 then
                isBanned = false
                if hasFileSystem and isfile(banFile) then
                    pcall(function() delfile(banFile) end)
                end
                getgenv().ArcanixBanEndTime = nil
                keyInput.Text = ""
                keyInput.TextEditable = true
                keyInput.BackgroundTransparency = 0
                checkBtn.Active = true
                checkBtn.Text = "ПРОВЕРИТЬ"
                checkBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
                timerLabel.Text = ""
                errorLabel.Text = ""
                attempts = 0
                break
            end
            local hours = math.floor(timeLeft / 3600)
            local minutes = math.floor((timeLeft % 3600) / 60)
            local seconds = timeLeft % 60
            timerLabel.Text = string.format("⏳ %02d:%02d:%02d", hours, minutes, seconds)
            task.wait(1)
        end
    end)
end

if isBanned then
    task.wait(2.2)
    updateBanUI()
end

-- ==========================================
-- 4. ОСНОВНОЙ СКРИПТ (ЗАПУСКАЕТСЯ ПОСЛЕ КЛЮЧА)
-- ==========================================
local function LoadArcanix()
    if getgenv().ArcanixLoaded then return end
    getgenv().ArcanixLoaded = true
    
    gui:Destroy()

    -- СПЛЕШ-СКРИН (ЧЕРНЫЙ ЭКРАН)
    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "ArcanixSplash"
    splashGui.ResetOnSpawn = false
    splashGui.IgnoreGuiInset = true
    splashGui.DisplayOrder = 99999
    splashGui.Parent = CoreGui

    local splashBg = Instance.new("Frame")
    splashBg.Size = UDim2.new(1, 0, 1, 0)
    splashBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    splashBg.BorderSizePixel = 0
    splashBg.ZIndex = 1
    splashBg.Parent = splashGui

    local splashText = Instance.new("TextLabel")
    splashText.Size = UDim2.new(1, 0, 0, 50)
    splashText.Position = UDim2.new(0, 0, 0.5, -50)
    splashText.BackgroundTransparency = 1
    splashText.Text = "ARCANIX"
    splashText.TextColor3 = Color3.fromRGB(255, 255, 255)
    splashText.TextSize = 40
    splashText.Font = Enum.Font.Arcade
    splashText.ZIndex = 2
    splashText.Parent = splashGui

    local splashVersion = Instance.new("TextLabel")
    splashVersion.Size = UDim2.new(1, 0, 0, 30)
    splashVersion.Position = UDim2.new(0, 0, 0.5, 10)
    splashVersion.BackgroundTransparency = 1
    splashVersion.Text = "V 1.2"
    splashVersion.TextColor3 = Color3.fromRGB(255, 255, 255)
    splashVersion.TextSize = 20
    splashVersion.Font = Enum.Font.Arcade
    splashVersion.ZIndex = 2
    splashVersion.Parent = splashGui

    task.spawn(function()
        task.wait(2)
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(splashBg, tweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(splashText, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(splashVersion, tweenInfo, {TextTransparency = 1}):Play()
        task.wait(0.5)
        splashGui:Destroy()
    end)

    local State = {
        ESP_Enabled = false, ESP_Nicknames = false, ESP_TeamCheck = false,
        ESP_Color = Color3.fromRGB(255, 0, 0), ESP_MaxDistance = 1000,
        Aim_Enabled = false, Aim_Mode = "ShiftLock", Aim_FOV = 150,
        Aim_Smooth = 50, Aim_WallCheck = true, CurrentTarget = nil,
        Fly_Enabled = false, Fly_Speed = 50,
        FPS_Boost = false,
        MenuSize = 1, Theme = "Light"
    }

    local FillColors = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 150, 255),
        Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 255)
    }
    local currentColorIndex = 1
    local TP = { Phase = "Idle", TargetPart = nil, Timer = 0 }

    local Themes = {
        Light = { Background = Color3.fromRGB(250, 250, 255), Text = Color3.fromRGB(40, 40, 50), Secondary = Color3.fromRGB(240, 242, 248), Accent = Color3.fromRGB(80, 150, 255) },
        Dark = { Background = Color3.fromRGB(30, 30, 40), Text = Color3.fromRGB(255, 255, 255), Secondary = Color3.fromRGB(40, 40, 55), Accent = Color3.fromRGB(80, 150, 255) }
    }

    local ThemeElements = { Background = {}, Text = {}, Secondary = {} }

    local function RegisterElement(element, type)
        table.insert(ThemeElements[type], element)
    end

    local function ApplyTheme(themeName)
        local theme = Themes[themeName]
        State.Theme = themeName
        for _, el in ipairs(ThemeElements.Background) do if el and el.Parent then el.BackgroundColor3 = theme.Background end end
        for _, el in ipairs(ThemeElements.Text) do if el and el.Parent then el.TextColor3 = theme.Text end end
        for _, el in ipairs(ThemeElements.Secondary) do if el and el.Parent then el.BackgroundColor3 = theme.Secondary end end
    end

    local function corner(obj, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = obj; return c end
    local function stroke(obj, color, thickness) local s = Instance.new("UIStroke"); s.Color = color or Color3.fromRGB(200, 200, 210); s.Thickness = thickness or 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = obj; return s end
    local function isTeammate(plr) if not State.ESP_TeamCheck then return false end; if not plr or not lp then return false end; if not plr.Team or not lp.Team then return false end; return plr.Team == lp.Team end

    local fovGui = Instance.new("ScreenGui")
    fovGui.Name = "FovGui"
    fovGui.ResetOnSpawn = false
    fovGui.IgnoreGuiInset = true
    fovGui.DisplayOrder = 1
    fovGui.Parent = CoreGui

    local fovCircle = Instance.new("Frame")
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    fovCircle.Size = UDim2.new(0, State.Aim_FOV * 2, 0, State.Aim_FOV * 2)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Visible = false
    fovCircle.Parent = fovGui
    corner(fovCircle, 9999)
    local fovStroke = stroke(fovCircle, Color3.fromRGB(80, 150, 255), 1.5)
    fovStroke.Transparency = 0.3

    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "ArcanixLight"
    mainGui.ResetOnSpawn = false
    mainGui.IgnoreGuiInset = true
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.DisplayOrder = 999
    mainGui.Parent = CoreGui

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 60)
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -30)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Text = "🦅\nArcanix"
    toggleBtn.TextSize = 14
    toggleBtn.TextColor3 = Color3.fromRGB(40, 40, 50)
    toggleBtn.Font = Enum.Font.Arcade
    toggleBtn.TextWrapped = true
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = mainGui
    corner(toggleBtn, 12)
    stroke(toggleBtn, Color3.fromRGB(80, 150, 255), 1.5)

    local window = Instance.new("CanvasGroup")
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    window.Size = UDim2.new(0, 400, 0, 340)
    window.Position = UDim2.new(0.5, 0, 0.5, 0)
    window.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
    window.GroupTransparency = 1
    window.Visible = false
    window.Parent = mainGui
    corner(window, 16)
    stroke(window, Color3.fromRGB(220, 225, 240), 1.5)
    RegisterElement(window, "Background")

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 1
    uiScale.Parent = window

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = window

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "⚡ ARCANIX"
    titleLabel.TextColor3 = Color3.fromRGB(40, 40, 50)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.Arcade
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    RegisterElement(titleLabel, "Text")

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -36, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    closeBtn.Text = "X"
    closeBtn.TextSize = 16
    closeBtn.TextColor3 = Color3.fromRGB(100, 100, 110)
    closeBtn.Font = Enum.Font.Arcade
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = titleBar
    corner(closeBtn, 8)
    RegisterElement(closeBtn, "Secondary")

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -24, 0, 36)
    tabBar.Position = UDim2.new(0, 12, 0, 42)
    tabBar.BackgroundColor3 = Color3.fromRGB(240, 242, 248)
    tabBar.Parent = window
    corner(tabBar, 10)
    RegisterElement(tabBar, "Secondary")

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabBar

    local contentHolder = Instance.new("Frame")
    contentHolder.Size = UDim2.new(1, -24, 1, -90)
    contentHolder.Position = UDim2.new(0, 12, 0, 84)
    contentHolder.BackgroundTransparency = 1
    contentHolder.Parent = window

    local tabs = {}
    local function makeTab(name, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 85, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(120, 120, 130)
        btn.TextSize = 14
        btn.Font = Enum.Font.Arcade
        btn.AutoButtonColor = false
        btn.LayoutOrder = order
        btn.Parent = tabBar
        corner(btn, 8)
        RegisterElement(btn, "Background")

        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, 0, 1, 0)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 3
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 150, 255)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollFrame.Visible = false
        scrollFrame.Parent = contentHolder

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scrollFrame

        tabs[name] = { button = btn, frame = scrollFrame }
        return scrollFrame
    end

    local espTab = makeTab("ESP", 1)
    local aimTab = makeTab("AimBot", 2)
    local miscTab = makeTab("Misc", 3)
    local setTab = makeTab("Settings", 4)

    local function switchTab(name)
        for tabName, data in pairs(tabs) do
            local active = (tabName == name)
            data.frame.Visible = active
            TweenService:Create(data.button, TweenInfo.new(0.2), { BackgroundColor3 = active and Color3.fromRGB(80, 150, 255) or Color3.fromRGB(250, 250, 255) }):Play()
            TweenService:Create(data.button, TweenInfo.new(0.2), { TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 130) }):Play()
        end
    end
    for name, data in pairs(tabs) do data.button.MouseButton1Click:Connect(function() switchTab(name) end) end
    switchTab("ESP")

    local function createToggle(parent, text, default, callback)
        local holder = Instance.new("Frame")
        holder.Size = UDim2.new(1, -6, 0, 34)
        holder.BackgroundColor3 = Color3.fromRGB(242, 244, 250)
        holder.Parent = parent
        corner(holder, 8)
        RegisterElement(holder, "Secondary")

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -70, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(60, 60, 70)
        label.TextSize = 14
        label.Font = Enum.Font.Arcade
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = holder
        RegisterElement(label, "Text")

        local switch = Instance.new("Frame")
        switch.Size = UDim2.new(0, 42, 0, 22)
        switch.Position = UDim2.new(1, -52, 0.5, -11)
        switch.BackgroundColor3 = Color3.fromRGB(200, 205, 215)
        switch.Parent = holder
        corner(switch, 11)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, 2, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = switch
        corner(knob, 9)
        stroke(knob, Color3.fromRGB(180, 185, 195), 1)

        local isOn = default
        local function update(animate)
            local targetPos = isOn and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            local targetCol = isOn and Color3.fromRGB(80, 150, 255) or Color3.fromRGB(200, 205, 215)
      local function checkKey()
    if isBanned then return end
    
    if keyInput.Text == "free" then
        checkBtn.Text = "УСПЕШНО!"
        checkBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        errorLabel.Text = ""
        
        local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(frame, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, fadeInfo, {Transparency = 1}):Play()
        TweenService:Create(title, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(timerLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(keyInput, fadeInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        TweenService:Create(checkBtn, fadeInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        TweenService:Create(errorLabel, fadeInfo, {TextTransparency = 1}):Play()
        
        task.wait(0.5)
        LoadArcanix()
        
    else
        attempts = attempts + 1
        errorLabel.Text = "Неверный ключ! Попытка " .. attempts .. "/10"
        keyInput.Text = ""
        
        if attempts >= 10 then
            isBanned = true
            banEndTime = os.time() + (24 * 60 * 60)
            
            if hasFileSystem then
                pcall(function() writefile(banFile, tostring(banEndTime)) end)
            else
                getenv().ArcanixBanEndTime = banEndTime
            end
            
            updateBanUI()
        else
            checkBtn.Text = "НЕВЕРНЫЙ КЛЮЧ!"
            checkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            
            local origPos = frame.Position
            local shakeInfo = TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            for i = 1, 4 do
                TweenService:Create(frame, shakeInfo, {Position = origPos + UDim2.new(0, 12, 0, 0)}):Play()
                task.wait(0.05)
                TweenService:Create(frame, shakeInfo, {Position = origPos - UDim2.new(0, 12, 0, 0)}):Play()
                task.wait(0.05)
            end
            TweenService:Create(frame, shakeInfo, {Position = origPos}):Play()
            
            task.delay(1.5, function()
                if not isBanned then
                    checkBtn.Text = "ПРОВЕРИТЬ"
                    checkBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
                end
            end)
        end
    end
end

checkBtn.MouseButton1Click:Connect(checkKey)
          local ActiveESP = {}
    local function applyESP(plr)
        if plr == lp then return end
        local char = plr.Character
        if not char then return end
        if ActiveESP[plr] then
            if ActiveESP[plr].hl then ActiveESP[plr].hl:Destroy() end
            if ActiveESP[plr].bb then ActiveESP[plr].bb:Destroy() end
            ActiveESP[plr] = nil
        end
        local highlight = Instance.new("Highlight")
        highlight.Adornee = char
        highlight.FillColor = State.ESP_Color
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = CoreGui 
        
        local bb = Instance.new("BillboardGui")
        bb.Name = "ESP_Nick"
        bb.Size = UDim2.new(0, 200, 0, 50)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = char:FindFirstChild("Head") or char
        bb.Parent = CoreGui

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = plr.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.Arcade
        nameLabel.Parent = bb
        ActiveESP[plr] = { hl = highlight, bb = bb }
    end

    local function setupPlayer(plr)
        if plr == lp then return end
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if State.ESP_Enabled then applyESP(plr) end
        end)
    end

    for _, plr in ipairs(Players:GetPlayers()) do setupPlayer(plr) end
    Players.PlayerAdded:Connect(setupPlayer)
    Players.PlayerRemoving:Connect(function(plr)
        if ActiveESP[plr] then
            if ActiveESP[plr].hl then ActiveESP[plr].hl:Destroy() end
            if ActiveESP[plr].bb then ActiveESP[plr].bb:Destroy() end
            ActiveESP[plr] = nil
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not State.ESP_Enabled then
            for _, data in pairs(ActiveESP) do
                if data.hl then data.hl.Enabled = false end
                if data.bb then data.bb.Enabled = false end
            end
            return
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local data = ActiveESP[plr]
                    if not data or not data.hl or data.hl.Adornee ~= char then
                        applyESP(plr)
                    else
                        local dist = 999
                        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                            dist = (lp.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                        end
                        local sameTeam = isTeammate(plr)
                        local shouldShow = (dist <= State.ESP_MaxDistance) and not sameTeam
                        data.hl.Enabled = shouldShow
                        data.hl.FillColor = State.ESP_Color
                        data.hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        if data.bb then data.bb.Enabled = shouldShow and State.ESP_Nicknames end
                    end
                end
            end
        end
    end)

    local flyVel = nil
    RunService.RenderStepped:Connect(function()
        if State.Fly_Enabled then
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = lp.Character.HumanoidRootPart
                if not flyVel then
                    flyVel = Instance.new("BodyVelocity")
                    flyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    flyVel.Velocity = Vector3.zero
                    flyVel.Parent = hrp
                end
                local moveDir = Vector3.zero
                local camLook = camera.CFrame.LookVector
                local camRight = camera.CFrame.RightVector
                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += camLook end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= camLook end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= camRight end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += camRight end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
                local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0.1 then
                    local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
                    local flatRight = Vector3.new(camRight.X, 0, camRight.Z).Unit
                    local joystickX = hum.MoveDirection:Dot(flatRight)
                    local joystickZ = hum.MoveDirection:Dot(flatLook)
                    moveDir += (camLook * joystickZ) + (camRight * joystickX)
                end
                if moveDir.Magnitude > 0 then flyVel.Velocity = moveDir.Unit * State.Fly_Speed
                else flyVel.Velocity = Vector3.zero end
            end
        else
            if flyVel then flyVel:Destroy(); flyVel = nil end
        end
    end)

    local function startSmoothTP(targetPlayer)
        if not targetPlayer or not targetPlayer.Character then return end
        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP then
            TP.TargetPart = targetHRP
            TP.Phase = "Glide"
            TP.Timer = tick()
        end
    end

    RunService.RenderStepped:Connect(function(dt)
        if TP.Phase == "Idle" or not TP.TargetPart or not lp.Character then return end
        local myHRP = lp.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP or not TP.TargetPart.Parent then TP.Phase = "Idle"; return end
        if TP.Phase == "Glide" then
            local dist = (TP.TargetPart.Position - myHRP.Position).Magnitude
            if dist < 4 then TP.Phase = "Lock"; TP.Timer = tick()
            else
                local speed = math.clamp(dist * 0.5, 5, 25) 
                local goal = CFrame.new(TP.TargetPart.Position - TP.TargetPart.CFrame.LookVector * 3, TP.TargetPart.Position)
                myHRP.CFrame = myHRP.CFrame:Lerp(goal, dt * speed)
            end
        elseif TP.Phase == "Lock" then
            local goal = CFrame.new(TP.TargetPart.Position - TP.TargetPart.CFrame.LookVector * 3, TP.TargetPart.Position)
            myHRP.CFrame = myHRP.CFrame:Lerp(goal, dt * 15)
            if tick() - TP.Timer > 1.5 then TP.Phase = "Release"; TP.Timer = tick() end
        elseif TP.Phase == "Release" then
            if tick() - TP.Timer > 0.5 then TP.Phase = "Idle"; TP.TargetPart = nil end
        end
    end)

    local tpMenu = Instance.new("CanvasGroup")
    tpMenu.AnchorPoint = Vector2.new(0.5, 0.5)
    tpMenu.Size = UDim2.new(0, 250, 0, 300)
    tpMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
    tpMenu.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
    tpMenu.GroupTransparency = 1
    tpMenu.Visible = false
    tpMenu.Parent = mainGui
    corner(tpMenu, 12)
    stroke(tpMenu, Color3.fromRGB(220, 225, 240), 1.5)
    RegisterElement(tpMenu, "Background")

    local tpTitle = Instance.new("Frame")
    tpTitle.Name = "TitleBar"
    tpTitle.Size = UDim2.new(1, 0, 0, 35)
    tpTitle.BackgroundTransparency = 1
    tpTitle.Parent = tpMenu

    local tpTitleLabel = Instance.new("TextLabel")
    tpTitleLabel.Size = UDim2.new(1, -40, 1, 0)
    tpTitleLabel.Position = UDim2.new(0, 12, 0, 0)
    tpTitleLabel.BackgroundTransparency = 1
    tpTitleLabel.Text = "ТЕЛЕПОРТ"
    tpTitleLabel.TextColor3 = Color3.fromRGB(40, 40, 50)
    tpTitleLabel.TextSize = 14
    tpTitleLabel.Font = Enum.Font.Arcade
    tpTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    tpTitleLabel.Parent = tpTitle
    RegisterElement(tpTitleLabel, "Text")

    local tpCloseBtn = Instance.new("TextButton")
    tpCloseBtn.Size = UDim2.new(0, 24, 0, 24)
    tpCloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
    tpCloseBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    tpCloseBtn.Text = "X"
    tpCloseBtn.TextSize = 14
    tpCloseBtn.TextColor3 = Color3.fromRGB(100, 100, 110)
    tpCloseBtn.Font = Enum.Font.Arcade
    tpCloseBtn.AutoButtonColor = false
    tpCloseBtn.Parent = tpTitle
    corner(tpCloseBtn, 6)
    RegisterElement(tpCloseBtn, "Secondary")

    local tpScroll = Instance.new("ScrollingFrame")
    tpScroll.Size = UDim2.new(1, -20, 1, -50)
    tpScroll.Position = UDim2.new(0, 10, 0, 40)
    tpScroll.BackgroundTransparency = 1
    tpScroll.ScrollBarThickness = 4
    tpScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 150, 255)
    tpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tpScroll.Parent = tpMenu

    local tpLayout = Instance.new("UIListLayout")
    tpLayout.Padding = UDim.new(0, 6)
    tpLayout.SortOrder = Enum.SortOrder.Name
    tpLayout.Parent = tpScroll

    local function refreshTPList()
        for _, child in ipairs(tpScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -6, 0, 34)
                btn.BackgroundColor3 = Color3.fromRGB(242, 244, 250)
                btn.Text = plr.Name
                btn.TextColor3 = Color3.fromRGB(60, 60, 70)
                btn.TextSize = 14
                btn.Font = Enum.Font.Arcade
                btn.AutoButtonColor = false
                btn.Parent = tpScroll
                corner(btn, 8)
                RegisterElement(btn, "Secondary")
                btn.MouseButton1Click:Connect(function()
                    startSmoothTP(plr)
                    tpMenu.Visible = false
                    TweenService:Create(tpMenu, TweenInfo.new(0.2), {GroupTransparency = 1}):Play()
                end)
            end
        end
        tpScroll.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y)
    end

    tpCloseBtn.MouseButton1Click:Connect(function()
        tpMenu.Visible = false
        TweenService:Create(tpMenu, TweenInfo.new(0.2), {GroupTransparency = 1}):Play()
    end)

    local isAiming = false
    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if State.Aim_Enabled and State.Aim_Mode == "RMB" and input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end
    end)

    local function hasLineOfSight(targetPart)
        if not State.Aim_WallCheck then return true end
        local origin = camera.CFrame.Position
        local direction = (targetPart.Position - origin)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {lp.Character, camera}
        local rayResult = Workspace:Raycast(origin, direction, raycastParams)
        if not rayResult then return true end
        if rayResult.Instance:IsDescendantOf(targetPart.Parent) then return true end
        return false
    end

    local function isTargetValid(targetPart)
        if not targetPart or not targetPart.Parent then return false end
        local hum = targetPart.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        return true
    end

    local function getTarget()
        if State.CurrentTarget and isTargetValid(State.CurrentTarget) then
            if hasLineOfSight(State.CurrentTarget) then return State.CurrentTarget end
        end
        State.CurrentTarget = nil
        local closest, shortest = nil, State.Aim_FOV
        local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and not isTeammate(plr) then
                local char = plr.Character
                if char then
                    local targetPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if targetPart and hum and hum.Health > 0 then
                        local pos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if d < shortest then
                                if hasLineOfSight(targetPart) then
                                    shortest = d
                                    closest = targetPart
                                end
                            end
                        end
                    end
                end
            end
        end
        State.CurrentTarget = closest
        return State.CurrentTarget
    end

    RunService.RenderStepped:Connect(function(dt)
        if not State.Aim_Enabled then State.CurrentTarget = nil; return end
        local active = false
        if State.Aim_Mode == "Always" then active = true
        elseif State.Aim_Mode == "RMB" then active = isAiming
        elseif State.Aim_Mode == "ShiftLock" then active = (UIS.MouseBehavior == Enum.MouseBehavior.LockCenter) end
        if not active then State.CurrentTarget = nil; return end
        local target = getTarget()
        if target then
            local current = camera.CFrame
            local desired = CFrame.new(current.Position, target.Position)
            if State.Aim_Smooth >= 99 then camera.CFrame = desired
            else
                local smoothFactor = State.Aim_Smooth / 100
                local alpha = 1 - math.pow(1 - smoothFactor, dt * 60)
                camera.CFrame = current:Lerp(desired, alpha)
            end
        end
    end)

    RunService.Stepped:Connect(function()
        local char = lp.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            if hrp.Velocity.Magnitude > 1000 then
                hrp.Velocity = Vector3.zero
                hrp.RotVelocity = Vector3.zero
            end
        end
    end)

    createToggle(espTab, "Включить ESP", false, function(v) 
        State.ESP_Enabled = v 
        if not v then
            for _, data in pairs(ActiveESP) do
                if data.hl then data.hl.Enabled = false end
                if data.bb then data.bb.Enabled = false end
            end
        else
            for _, plr in ipairs(Players:GetPlayers()) do applyESP(plr) end
        end
    end)
    createToggle(espTab, "Показывать Ники", false, function(v) State.ESP_Nicknames = v end)
    createToggle(espTab, "Игнорировать союзников", false, function(v) State.ESP_TeamCheck = v end)
    createColorButton(espTab)

    createToggle(aimTab, "Включить AimBot", false, function(v) State.Aim_Enabled = v; fovCircle.Visible = v end)
    createToggle(aimTab, "Wall-Check", true, function(v) State.Aim_WallCheck = v end)
    createAimModeSelector(aimTab)
    createSlider(aimTab, "FOV (Радиус)", 50, 400, 150, function(v) State.Aim_FOV = v; fovCircle.Size = UDim2.new(0, v*2, 0, v*2) end)
    createSlider(aimTab, "Сила лока (100 = СНАП)", 1, 100, 50, function(v) State.Aim_Smooth = v end)

    local tpOpenBtn = Instance.new("TextButton")
    tpOpenBtn.Size = UDim2.new(1, -6, 0, 34)
    tpOpenBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
    tpOpenBtn.Text = "МЕНЮ ТЕЛЕПОРТА"
    tpOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpOpenBtn.TextSize = 14
    tpOpenBtn.Font = Enum.Font.Arcade
    tpOpenBtn.Parent = miscTab
    corner(tpOpenBtn, 8)
    tpOpenBtn.MouseButton1Click:Connect(function()
        refreshTPList()
        tpMenu.Visible = true
        TweenService:Create(tpMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {GroupTransparency = 0}):Play()
    end)

    local flySlider
    local flyToggle = createToggle(miscTab, "Fly", false, function(v) State.Fly_Enabled = v; if flySlider then flySlider.Visible = v end end)
    flySlider = createSlider(miscTab, "Скорость полета", 10, 200, 50, function(v) State.Fly_Speed = v end)
    flySlider.Visible = false 

    createToggle(miscTab, "FPS Boost", false, function(v)
        if v then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.Brightness = 2
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
        else
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 10000
            Lighting.Brightness = 3
            Lighting.EnvironmentDiffuseScale = 0.5
            Lighting.EnvironmentSpecularScale = 0.5
        end
    end)

    createSlider(setTab, "Размер меню", 50, 150, 100, function(v)
        State.MenuSize = v / 100
        if uiScale then uiScale.Scale = State.MenuSize end
    end)

    local themeBtn = Instance.new("TextButton")
    themeBtn.Size = UDim2.new(1, -6, 0, 34)
    themeBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
    themeBtn.Text = "Тема: Светлая"
    themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    themeBtn.TextSize = 14
    themeBtn.Font = Enum.Font.Arcade
    themeBtn.Parent = setTab
    corner(themeBtn, 8)

    themeBtn.MouseButton1Click:Connect(function()
        if State.Theme == "Light" then
            ApplyTheme("Dark")
            themeBtn.Text = "Тема: Темная"
        else
            ApplyTheme("Light")
            themeBtn.Text = "Тема: Светлая"
        end
    end)

    local function makeDraggable(frame, dragTarget)
        local dragging, dragStart, startPos
        dragTarget.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    makeDraggable(window, titleBar)
    makeDraggable(toggleBtn, toggleBtn)
    makeDraggable(tpMenu, tpMenu:FindFirstChild("TitleBar"))

    local isOpen = false
    local function openMenu()
        if isOpen then return end
        isOpen = true
        window.Visible = true
        window.GroupTransparency = 1
        uiScale.Scale = 0.3
        TweenService:Create(window, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()
        TweenService:Create(uiScale, TweenInfo.new(0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Scale = State.MenuSize }):Play()
    end
    local function closeMenu()
        if not isOpen then return end
        isOpen = false
        local t1 = TweenService:Create(window, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { GroupTransparency = 1 })
        ew(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.3 })
    t1:Play(); t2:Play()
    t1.Completed:Connect(function() if not isOpen then window.Visible = false end end)
end

toggleBtn.MouseButton1Click:Connect(function() if isOpen then closeMenu() else openMenu() end end)
closeBtn.MouseButton1Click:Connect(closeMenu)

print("Arcanix Core Loaded")
end

local function checkKey()
    if isBanned then return end
    
    if keyInput.Text == "free" then
        checkBtn.Text = "УСПЕШНО!"
        checkBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        errorLabel.Text = ""
        
        local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(frame, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, fadeInfo, {Transparency = 1}):Play()
        TweenService:Create(title, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(timerLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(keyInput, fadeInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        TweenService:Create(checkBtn, fadeInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        TweenService:Create(errorLabel, fadeInfo, {TextTransparency = 1}):Play()
        
        task.wait(0.5)
        LoadArcanix()
        
    else
        attempts = attempts + 1
        errorLabel.Text = "Неверный ключ! Попытка " .. attempts .. "/10"
        keyInput.Text = ""
        
        if attempts >= 10 then
            isBanned = true
            banEndTime = os.time() + (24 * 60 * 60)
            
            if hasFileSystem then
                pcall(function() writefile(banFile, tostring(banEndTime)) end)
            else
                getenv().ArcanixBanEndTime = banEndTime
            end
            
            updateBanUI()
        else
            checkBtn.Text = "НЕВЕРНЫЙ КЛЮЧ!"
            checkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            
            local origPos = frame.Position
            local shakeInfo = TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            for i = 1, 4 do
                TweenService:Create(frame, shakeInfo, {Position = origPos + UDim2.new(0, 12, 0, 0)}):Play()
                task.wait(0.05)
                TweenService:Create(frame, shakeInfo, {Position = origPos - UDim2.new(0, 12, 0, 0)}):Play()
                task.wait(0.05)
            end
            TweenService:Create(frame, shakeInfo, {Position = origPos}):Play()
            
            task.delay(1.5, function()
                if not isBanned then
                    checkBtn.Text = "ПРОВЕРИТЬ"
                    checkBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
                end
            end)
        end
    end
end

checkBtn.MouseButton1Click:Connect(checkKey)
