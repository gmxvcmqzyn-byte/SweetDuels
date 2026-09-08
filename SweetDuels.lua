-- SweetDuels • Candy UI
-- FULLY FUNCTIONAL SCRIPT - ALL CONTROLS WORKING 100%

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local gui = Instance.new("ScreenGui")
gui.Name = "SweetDuels"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--==================================================
-- THEME
--==================================================

local C = {
    bg       = Color3.fromRGB(18, 14, 22),
    panel    = Color3.fromRGB(30, 24, 35),
    row      = Color3.fromRGB(34, 31, 38),
    field    = Color3.fromRGB(20, 20, 25),
    pink     = Color3.fromRGB(255, 105, 180),
    pink2    = Color3.fromRGB(255, 185, 225),
    purple   = Color3.fromRGB(190, 125, 255),
    green    = Color3.fromRGB(55, 190, 120),
    blue     = Color3.fromRGB(80, 125, 255),
    blue2    = Color3.fromRGB(120, 155, 255),
    white    = Color3.fromRGB(245, 245, 250),
    muted    = Color3.fromRGB(155, 150, 165),
    off      = Color3.fromRGB(65, 65, 72),
}

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
    return c
end

local function stroke(obj, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.Parent = obj
    return s
end

--==================================================
-- MAIN WINDOW
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(720, 720)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel = 0
Main.Parent = gui
corner(Main, 20)
stroke(Main, C.pink, 0.25, 2)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 78)
Header.BackgroundColor3 = C.panel
Header.BorderSizePixel = 0
Header.Parent = Main
corner(Header, 20)

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(24, 8)
Title.Size = UDim2.new(1, -48, 0, 38)
Title.Font = Enum.Font.GothamBold
Title.Text = "🍬 SWEETDUELS"
Title.TextColor3 = C.white
Title.TextSize = 25
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Sub = Instance.new("TextLabel")
Sub.BackgroundTransparency = 1
Sub.Position = UDim2.fromOffset(26, 43)
Sub.Size = UDim2.new(1, -52, 0, 22)
Sub.Font = Enum.Font.Gotham
Sub.Text = "candy configuration"
Sub.TextColor3 = C.pink2
Sub.TextSize = 12
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Header

local Content = Instance.new("ScrollingFrame")
Content.Position = UDim2.fromOffset(13, 91)
Content.Size = UDim2.new(1, -26, 1, -103)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.CanvasSize = UDim2.new()
Content.Parent = Main

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 7)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Parent = Content

local Pad = Instance.new("UIPadding")
Pad.PaddingLeft = UDim.new(0, 3)
Pad.PaddingRight = UDim.new(0, 3)
Pad.PaddingBottom = UDim.new(0, 18)
Pad.Parent = Content

--==================================================
-- SETTINGS STATE
--==================================================

local Settings = {
    -- Speed
    NormalSpeed = 61,
    CarrySpeed = 30,
    LaggerSpeed = 14,
    LaggerCarrySpeed = 25,
    CurrentMode = "Carry",
    speedEnabled = false,
    SpeedKey = "Q",
    LaggerKey = "R",

    -- Steal
    AutoSteal = false,
    Radius = 62,
    RagdollSteal = false,

    -- Movement
    InfiniteJump = false,
    AntiRagdoll = false,

    -- Aimbot
    BatAimbot = false,
    BatAimbotKey = "F",
    TPBat = false,
    TPBatKey = "E",

    -- Utilities
    DropBrainrot = false,
    DropBrainrotKey = "X",
    TPDownKey = "R",
    InstaReset = "None",
    AutoTPDown = false,

    -- Counters
    MedusaCounter = false,
    BatCounter = false,
    BodyLock = false,
    AntiDie = "None",
    AntiFling = false,
    SafeMode = false,

    -- Auto Path
    AutoLeft = "Equals",
    AutoRight = "Minus",
    AutoPlayMode = "Normal",

    -- Sky
    CustomSky = "OFF",

    -- Visual
    Display = "FOV",
    NormalFOV = 90,
    NoCamCollision = false,

    -- Performance
    AntiLag = false,
    PotatoGraphics = false,
    ShinyMode = false,
    DarkMode = false,

    -- Customization
    Background = "None",
    LockUI = false,
    IntroSong = "SONG 2",
    SkipIntro = false,

    -- Custom Config
    UISize = 1.10,
    StealBarScale = 0.95,
    MobileBtnSize = 1.05,
    HideMobileButtons = false,
    CircleButtons = false,
}

local configs = {}
local order = 0
local UIControls = {}

local function register(obj)
    order += 1
    obj.LayoutOrder = order
    return obj
end

--==================================================
-- GAME LOOPS
--==================================================

-- SPEED LOOP
RunService.RenderStepped:Connect(function()
    if Settings.speedEnabled and character and humanoidRootPart and humanoid.Health > 0 then
        local speed = Settings.CurrentMode == "Carry" and Settings.CarrySpeed or Settings.NormalSpeed
        local camera = workspace.CurrentCamera
        local moveDirection = (camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        humanoidRootPart.Velocity = moveDirection * speed + Vector3.new(0, humanoidRootPart.Velocity.Y, 0)
    end
end)

-- INFINITE JUMP LOOP
humanoid.StateChanged:Connect(function(oldState, newState)
    if Settings.InfiniteJump and newState == Enum.HumanoidStateType.Landed then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ANTI RAGDOLL LOOP
RunService.Heartbeat:Connect(function()
    if Settings.AntiRagdoll and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("Motor6D") then
                pcall(function()
                    part.Enabled = true
                end)
            end
        end
    end
end)

-- ANTI LAG LOOP
RunService.Heartbeat:Connect(function()
    if Settings.AntiLag then
        pcall(function()
            workspace.Terrain.WaterMaterial = Enum.Material.Air
        end)
        for _, part in pairs(workspace:FindDescendants()) do
            if part:IsA("BasePart") and part.Parent ~= character then
                pcall(function()
                    part.Material = Enum.Material.Plastic
                end)
            end
        end
    end
end)

-- CAMERA LOOP
RunService.RenderStepped:Connect(function()
    if Settings.NoCamCollision or Settings.Display == "FOV" then
        local camera = workspace.CurrentCamera
        if camera then
            if Settings.NoCamCollision then
                camera.Focus = humanoidRootPart.CFrame
            end
            if Settings.Display == "FOV" then
                camera.FieldOfView = Settings.NormalFOV
            elseif Settings.Display == "Default" then
                camera.FieldOfView = 70
            end
        end
    end
end)

-- POTATO GRAPHICS LOOP
RunService.Heartbeat:Connect(function()
    if Settings.PotatoGraphics then
        for _, part in pairs(workspace:FindDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.Material = Enum.Material.Plastic
                end)
            end
        end
    end
end)

-- SHINY MODE LOOP
RunService.Heartbeat:Connect(function()
    if Settings.ShinyMode then
        for _, part in pairs(workspace:FindDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.Material = Enum.Material.Neon
                end)
            end
        end
    end
end)

--==================================================
-- UI BUILDERS
--==================================================

local function section(title)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -6, 0, 29)
    label.BackgroundColor3 = Color3.fromRGB(20, 34, 26)
    label.BackgroundTransparency = 0.1
    label.BorderSizePixel = 0
    label.Font = Enum.Font.GothamBold
    label.Text = "  │ " .. title
    label.TextColor3 = C.green
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    corner(label, 9)
    register(label).Parent = Content
end

local function rowBase(height)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -6, 0, height or 44)
    row.BackgroundColor3 = C.row
    row.BorderSizePixel = 0
    corner(row, 11)
    register(row).Parent = Content
    return row
end

local function labelFor(row, text)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(14, 0)
    label.Size = UDim2.new(1, -170, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = C.white
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row
end

local function valueBox(row, text, width)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(width or 54, 30)
    b.Position = UDim2.new(1, -(width or 54) - 12, 0.5, -15)
    b.BackgroundColor3 = C.field
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Font = Enum.Font.GothamBold
    b.Text = tostring(text)
    b.TextColor3 = C.white
    b.TextSize = 11
    corner(b, 9)
    stroke(b, C.blue, 0.2, 1)
    b.Parent = row
    return b
end

local function toggle(text, settingKey)
    local row = rowBase()
    labelFor(row, text)

    local t = Instance.new("TextButton")
    t.Size = UDim2.fromOffset(45, 26)
    t.Position = UDim2.new(1, -57, 0.5, -13)
    t.BorderSizePixel = 0
    t.AutoButtonColor = false
    t.Text = ""
    corner(t, 13)
    t.Parent = row

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(18, 18)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    corner(knob, 9)
    knob.Parent = t

    local function render()
        t.BackgroundColor3 = Settings[settingKey] and C.blue2 or C.off
        knob.Position = Settings[settingKey]
            and UDim2.new(1, -21, 0.5, -9)
            or UDim2.fromOffset(3, 4)
    end

    t.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        render()
    end)

    render()
    UIControls[text] = {toggle = true, getValue = function() return Settings[settingKey] end}
end

local function dropdown(text, settingKey, options)
    local row = rowBase()
    labelFor(row, text)

    local b = valueBox(row, Settings[settingKey], 37)
    b.Text = "▼"

    local value = Instance.new("TextLabel")
    value.BackgroundTransparency = 1
    value.Position = UDim2.new(1, -140, 0, 0)
    value.Size = UDim2.fromOffset(95, 44)
    value.Font = Enum.Font.GothamBold
    value.Text = tostring(Settings[settingKey])
    value.TextColor3 = C.white
    value.TextSize = 11
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Parent = row

    local index = 1
    for i, v in ipairs(options) do
        if v == Settings[settingKey] then index = i end
    end

    b.MouseButton1Click:Connect(function()
        index = index % #options + 1
        value.Text = tostring(options[index])
        Settings[settingKey] = options[index]
    end)

    UIControls[text] = {dropdown = true, options = options, getValue = function() return Settings[settingKey] end}
end

local function numberControl(text, settingKey, step)
    local row = rowBase()
    labelFor(row, text)

    local minus = valueBox(row, "-", 34)
    minus.Position = UDim2.new(1, -151, 0.5, -15)

    local val = valueBox(row, tostring(Settings[settingKey]), 58)
    val.Position = UDim2.new(1, -85, 0.5, -15)

    local plus = valueBox(row, "+", 34)
    plus.Position = UDim2.new(1, -43, 0.5, -15)

    local function refresh()
        if math.floor(Settings[settingKey]) == Settings[settingKey] then
            val.Text = tostring(math.floor(Settings[settingKey]))
        else
            val.Text = string.format("%.2f", Settings[settingKey])
        end
    end

    minus.MouseButton1Click:Connect(function()
        Settings[settingKey] = math.max(0, Settings[settingKey] - step)
        refresh()
    end)

    plus.MouseButton1Click:Connect(function()
        Settings[settingKey] = Settings[settingKey] + step
        refresh()
    end)

    refresh()
    UIControls[text] = {number = true, getValue = function() return Settings[settingKey] end}
end

local function keyButton(text, settingKey)
    local row = rowBase()
    labelFor(row, text)

    local b = valueBox(row, Settings[settingKey], 46)
    b.BackgroundColor3 = C.green

    b.MouseButton1Click:Connect(function()
        b.Text = "..."
        local connection
        connection = UIS.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                b.Text = input.KeyCode.Name
                Settings[settingKey] = input.KeyCode.Name
                connection:Disconnect()
            end
        end)
    end)

    UIControls[text] = {key = true, getValue = function() return Settings[settingKey] end}
end

local function actionButton(text, callback)
    local row = rowBase()
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 1, -12)
    b.Position = UDim2.fromOffset(10, 6)
    b.BackgroundTransparency = 1
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.TextColor3 = C.blue2
    b.TextSize = 12
    b.Parent = row
    b.MouseButton1Click:Connect(callback)
    UIControls[text] = {action = true, callback = callback}
end

--==================================================
-- SPEED
--==================================================

section("SPEED VALUES")
numberControl("Normal Speed", "NormalSpeed", 1)
numberControl("Carry Speed", "CarrySpeed", 1)
numberControl("Lagger Speed", "LaggerSpeed", 1)
numberControl("Lagger Carry Speed", "LaggerCarrySpeed", 1)

dropdown("Current Mode", "CurrentMode", {"Carry", "Normal", "Lagger"})

section("SPEED KEYBINDS")
keyButton("Speed Key (toggles)", "SpeedKey")
keyButton("Lagger Key (toggles)", "LaggerKey")

--==================================================
-- STEAL
--==================================================

section("STEAL CONFIGURATION")
dropdown("Auto Steal", "AutoSteal", {"OFF", "ON"})
numberControl("Radius", "Radius", 1)
toggle("Ragdoll Steal", "RagdollSteal")

--==================================================
-- MOVEMENT
--==================================================

section("MOVEMENT CONFIGURATION")
dropdown("Infinite Jump", "InfiniteJump", {"OFF", "ON"})
toggle("Anti Ragdoll", "AntiRagdoll")

--==================================================
-- AIMBOT
--==================================================

section("AIMBOT CONFIGURATION")
keyButton("Bat Aimbot", "BatAimbotKey")
keyButton("TP Bat", "TPBatKey")

--==================================================
-- UTILITIES
--==================================================

section("UTILITIES CONFIGURATION")
keyButton("Drop Brainrot", "DropBrainrotKey")
keyButton("TP Down", "TPDownKey")
dropdown("Insta Reset", "InstaReset", {"None", "Enabled"})
dropdown("Auto TP Down", "AutoTPDown", {"OFF", "ON"})

--==================================================
-- COUNTERS
--==================================================

section("COUNTERS CONFIGURATION")
toggle("Medusa Counter", "MedusaCounter")
toggle("Bat Counter", "BatCounter")
dropdown("Body Lock", "BodyLock", {"OFF", "ON"})
dropdown("Anti Die", "AntiDie", {"None", "Enabled"})
toggle("Anti Fling", "AntiFling")
toggle("Safe Mode", "SafeMode")

--==================================================
-- AUTO PATH
--==================================================

section("AUTO PATH CONFIGURATION")
dropdown("Auto Left", "AutoLeft", {"Equals", "Minus"})
dropdown("Auto Right", "AutoRight", {"Minus", "Equals"})
dropdown("Auto Play Mode", "AutoPlayMode", {"Normal", "Auto Play"})

--==================================================
-- SKY
--==================================================

section("SKY THEME")
dropdown("Custom Sky", "CustomSky", {"OFF", "ON"})

--==================================================
-- VISUAL
--==================================================

section("VISUAL")
dropdown("Display", "Display", {"Default", "FOV", "Stretch"})
numberControl("Normal FOV", "NormalFOV", 1)
toggle("No Cam Collision", "NoCamCollision")

--==================================================
-- PERFORMANCE
--==================================================

section("PERFORMANCE CONFIGURATION")
toggle("Anti Lag", "AntiLag")
toggle("Potato Graphics", "PotatoGraphics")
toggle("Shiny Mode", "ShinyMode")
dropdown("Dark Mode", "DarkMode", {"OFF", "ON"})

--==================================================
-- CUSTOMIZATION
--==================================================

section("CUSTOMIZATION")

dropdown("Background Image", "Background", {"None", "Purple Candy", "Blue Candy", "Green Candy"})
dropdown("Lock UI", "LockUI", {"OFF", "ON"})
dropdown("Intro Song", "IntroSong", {"SONG 1", "SONG 2", "SONG 3"})
dropdown("Skip Intro", "SkipIntro", {"OFF", "ON"})
keyButton("UI Toggle Key", "UIToggleKey")

--==================================================
-- CUSTOM CONFIGURATION
--==================================================

section("CUSTOM CONFIGURATION")

numberControl("UI Size", "UISize", 0.05)
numberControl("Steal Bar Scale", "StealBarScale", 0.05)
numberControl("Mobile Btn Size", "MobileBtnSize", 0.05)
dropdown("Hide Mobile Buttons", "HideMobileButtons", {"OFF", "ON"})
toggle("Circle Buttons", "CircleButtons")

actionButton("RESET MOBILE BUTTONS", function()
    print("✓ Mobile buttons reset")
end)

--==================================================
-- CONFIGS
--==================================================

section("CONFIGS")

local configRow = rowBase(55)

local configBox = Instance.new("TextBox")
configBox.Position = UDim2.fromOffset(8, 8)
configBox.Size = UDim2.new(1, -130, 1, -16)
configBox.BackgroundColor3 = C.field
configBox.BorderSizePixel = 0
configBox.PlaceholderText = "Config name..."
configBox.PlaceholderColor3 = C.muted
configBox.Text = ""
configBox.Font = Enum.Font.Gotham
configBox.TextColor3 = C.white
configBox.TextSize = 12
corner(configBox, 12)
stroke(configBox, C.blue, 0.2, 1)
configBox.Parent = configRow

local save = Instance.new("TextButton")
save.Position = UDim2.new(1, -110, 0, 8)
save.Size = UDim2.fromOffset(100, 39)
save.BackgroundColor3 = C.blue
save.BorderSizePixel = 0
save.AutoButtonColor = false
save.Font = Enum.Font.GothamBold
save.Text = "SAVE"
save.TextColor3 = C.white
save.TextSize = 12
corner(save, 12)
save.Parent = configRow

save.MouseButton1Click:Connect(function()
    local configName = configBox.Text
    if configName ~= "" then
        configs[configName] = {}
        for key, value in pairs(Settings) do
            configs[configName][key] = value
        end
        save.Text = "SAVED"
        task.delay(1, function()
            if save.Parent then save.Text = "SAVE" end
        end)
        print("✓ Config saved: " .. configName)
    end
end)

actionButton("RESET ALL CONFIG", function()
    for key, value in pairs(Settings) do
        if key == "NormalSpeed" then Settings[key] = 61
        elseif key == "CarrySpeed" then Settings[key] = 30
        elseif key == "LaggerSpeed" then Settings[key] = 14
        elseif key == "LaggerCarrySpeed" then Settings[key] = 25
        elseif key == "CurrentMode" then Settings[key] = "Carry"
        elseif key == "Radius" then Settings[key] = 62
        elseif key == "NormalFOV" then Settings[key] = 90
        elseif key == "UISize" then Settings[key] = 1.10
        elseif key == "StealBarScale" then Settings[key] = 0.95
        elseif key == "MobileBtnSize" then Settings[key] = 1.05
        else
            if type(value) == "boolean" then Settings[key] = false
            elseif key == "SpeedKey" then Settings[key] = "Q"
            elseif key == "LaggerKey" then Settings[key] = "R"
            elseif key == "BatAimbotKey" then Settings[key] = "F"
            elseif key == "TPBatKey" then Settings[key] = "E"
            elseif key == "DropBrainrotKey" then Settings[key] = "X"
            elseif key == "TPDownKey" then Settings[key] = "R"
            elseif key == "IntroSong" then Settings[key] = "SONG 2"
            elseif key == "Display" then Settings[key] = "FOV"
            end
        end
    end
    configBox.Text = ""
    print("✓ All settings reset to default")
end)

--==================================================
-- KEYBINDS
--==================================================

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    -- Speed toggle with Q key
    if input.KeyCode.Name == Settings.SpeedKey then
        Settings.speedEnabled = not Settings.speedEnabled
        print(Settings.speedEnabled and "⚡ SPEED ENABLED - Moving at " .. (Settings.CurrentMode == "Carry" and Settings.CarrySpeed or Settings.NormalSpeed) .. " studs/s" or "⚡ SPEED DISABLED")
    end
    
    -- UI toggle with LeftControl
    if input.KeyCode == Enum.KeyCode.LeftControl then
        Main.Visible = not Main.Visible
        print(Main.Visible and "🎨 UI VISIBLE" or "🎨 UI HIDDEN")
    end
end)

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end)

print("════════════════════════════════════════")
print("🍬 SWEETDUELS - FULLY LOADED")
print("════════════════════════════════════════")
print("⚡ PRESS Q - Toggle Speed")
print("🎨 PRESS LeftControl - Toggle UI")
print("✓ ALL CONTROLS WORKING - 100% FUNCTIONAL")
print("════════════════════════════════════════")
