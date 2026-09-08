-- SweetDuels • Candy UI
-- Interactive UI/configuration mockup based on the supplied reference screens.
-- Game-manipulation/exploit functionality is intentionally not implemented.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

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
-- STATE & CONFIG SYSTEM
--==================================================

local State = {
    NormalSpeed = 61,
    CarrySpeed = 30,
    LaggerSpeed = 14,
    LaggerCarrySpeed = 25,

    CurrentMode = "Carry",

    SpeedKey = "Q",
    LaggerKey = "R",

    AutoSteal = false,
    Radius = 62,
    RagdollSteal = false,

    InfiniteJump = false,
    AntiRagdoll = false,

    BatAimbot = false,
    BatAimbotKey = "F",
    TPBat = false,
    TPBatKey = "E",

    DropBrainrot = false,
    DropBrainrotKey = "X",
    TPDownKey = "R",
    InstaReset = "None",
    AutoTPDown = false,

    MedusaCounter = false,
    BatCounter = false,
    BodyLock = false,
    AntiDie = "None",
    AntiFling = false,
    SafeMode = false,

    AutoLeft = "Equals",
    AutoRight = "Minus",
    AutoPlayMode = "Normal",

    CustomSky = "OFF",

    Display = "FOV",
    NormalFOV = 90,
    NoCamCollision = false,

    AntiLag = false,
    PotatoGraphics = false,
    ShinyMode = false,
    DarkMode = false,

    Background = "None",
    LockUI = false,
    IntroSong = "SONG 2",
    SkipIntro = false,
    UIToggleKey = "LeftControl",

    UISize = 1.10,
    StealBarScale = 0.95,
    MobileBtnSize = 1.05,
    HideMobileButtons = false,
    CircleButtons = false,
}

local configs = {}
local currentConfigName = ""
local controls = {}
local order = 0

local function register(obj)
    order += 1
    obj.LayoutOrder = order
    return obj
end

local function saveConfig(name)
    if name == "" then return end
    configs[name] = {}
    for key, value in pairs(State) do
        configs[name][key] = value
    end
    print("Config saved: " .. name)
end

local function loadConfig(name)
    if not configs[name] then return end
    for key, value in pairs(configs[name]) do
        State[key] = value
    end
    currentConfigName = name
    print("Config loaded: " .. name)
end

local function resetAllConfig()
    State = {
        NormalSpeed = 61,
        CarrySpeed = 30,
        LaggerSpeed = 14,
        LaggerCarrySpeed = 25,
        CurrentMode = "Carry",
        SpeedKey = "Q",
        LaggerKey = "R",
        AutoSteal = false,
        Radius = 62,
        RagdollSteal = false,
        InfiniteJump = false,
        AntiRagdoll = false,
        BatAimbot = false,
        BatAimbotKey = "F",
        TPBat = false,
        TPBatKey = "E",
        DropBrainrot = false,
        DropBrainrotKey = "X",
        TPDownKey = "R",
        InstaReset = "None",
        AutoTPDown = false,
        MedusaCounter = false,
        BatCounter = false,
        BodyLock = false,
        AntiDie = "None",
        AntiFling = false,
        SafeMode = false,
        AutoLeft = "Equals",
        AutoRight = "Minus",
        AutoPlayMode = "Normal",
        CustomSky = "OFF",
        Display = "FOV",
        NormalFOV = 90,
        NoCamCollision = false,
        AntiLag = false,
        PotatoGraphics = false,
        ShinyMode = false,
        DarkMode = false,
        Background = "None",
        LockUI = false,
        IntroSong = "SONG 2",
        SkipIntro = false,
        UIToggleKey = "LeftControl",
        UISize = 1.10,
        StealBarScale = 0.95,
        MobileBtnSize = 1.05,
        HideMobileButtons = false,
        CircleButtons = false,
    }
    print("All configs reset to default")
end

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
    return label
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
    return label
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

local function toggle(text, initial)
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

    local state = initial == true

    local function render()
        t.BackgroundColor3 = state and C.blue2 or C.off
        knob.Position = state
            and UDim2.new(1, -21, 0.5, -9)
            or UDim2.fromOffset(3, 4)
    end

    t.MouseButton1Click:Connect(function()
        state = not state
        render()
    end)

    render()
    controls[text] = {get = function() return state end}
    return row, t
end

local function dropdown(text, initial, options)
    local row = rowBase()
    labelFor(row, text)

    local b = valueBox(row, initial, 37)
    b.Text = "▼"

    local value = Instance.new("TextLabel")
    value.BackgroundTransparency = 1
    value.Position = UDim2.new(1, -140, 0, 0)
    value.Size = UDim2.fromOffset(95, 44)
    value.Font = Enum.Font.GothamBold
    value.Text = initial
    value.TextColor3 = C.white
    value.TextSize = 11
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Parent = row

    local index = 1
    for i, v in ipairs(options or {initial}) do
        if v == initial then index = i end
    end

    b.MouseButton1Click:Connect(function()
        index = index % #options + 1
        value.Text = options[index]
    end)

    return row
end

local function numberControl(text, initial, step)
    local row = rowBase()
    labelFor(row, text)

    local minus = valueBox(row, "-", 34)
    minus.Position = UDim2.new(1, -151, 0.5, -15)

    local val = valueBox(row, tostring(initial), 58)
    val.Position = UDim2.new(1, -85, 0.5, -15)

    local plus = valueBox(row, "+", 34)
    plus.Position = UDim2.new(1, -43, 0.5, -15)

    local n = initial

    local function refresh()
        if math.floor(n) == n then
            val.Text = tostring(n)
        else
            val.Text = string.format("%.2f", n)
        end
    end

    minus.MouseButton1Click:Connect(function()
        n -= step
        refresh()
    end)

    plus.MouseButton1Click:Connect(function()
        n += step
        refresh()
    end)

    refresh()
    return row
end

local function keyButton(text, key)
    local row = rowBase()
    labelFor(row, text)

    local b = valueBox(row, key, 46)
    b.BackgroundColor3 = C.green

    b.MouseButton1Click:Connect(function()
        b.Text = "..."
        local connection
        connection = UIS.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                b.Text = input.KeyCode.Name
                connection:Disconnect()
            end
        end)
    end)

    return row
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
    b.MouseButton1Click:Connect(callback or function() end)
    return row, b
end

--==================================================
-- SPEED
--==================================================

section("SPEED VALUES")
numberControl("Normal Speed", State.NormalSpeed, 1)
numberControl("Carry Speed", State.CarrySpeed, 1)
numberControl("Lagger Speed", State.LaggerSpeed, 1)
numberControl("Lagger Carry Speed", State.LaggerCarrySpeed, 1)

dropdown("Current Mode", State.CurrentMode, {"Carry", "Normal", "Lagger"})

section("SPEED KEYBINDS")
keyButton("Speed Key (toggles)", State.SpeedKey)
keyButton("Lagger Key (toggles)", State.LaggerKey)

--==================================================
-- STEAL
--==================================================

section("STEAL CONFIGURATION")
dropdown("Auto Steal", "OFF", {"OFF", "ON"})
numberControl("Radius", State.Radius, 1)
toggle("Ragdoll Steal", State.RagdollSteal)

--==================================================
-- MOVEMENT
--==================================================

section("MOVEMENT CONFIGURATION")
dropdown("Infinite Jump", "OFF", {"OFF", "ON"})
toggle("Anti Ragdoll", State.AntiRagdoll)

--==================================================
-- AIMBOT
--==================================================

section("AIMBOT CONFIGURATION")
keyButton("Bat Aimbot", State.BatAimbotKey)
keyButton("TP Bat", State.TPBatKey)

--==================================================
-- UTILITIES
--==================================================

section("UTILITIES CONFIGURATION")
keyButton("Drop Brainrot", State.DropBrainrotKey)
keyButton("TP Down", State.TPDownKey)
dropdown("Insta Reset", State.InstaReset, {"None", "Enabled"})
dropdown("Auto TP Down", "OFF", {"OFF", "ON"})

--==================================================
-- COUNTERS
--==================================================

section("COUNTERS CONFIGURATION")
toggle("Medusa Counter", State.MedusaCounter)
toggle("Bat Counter", State.BatCounter)
dropdown("Body Lock", "OFF", {"OFF", "ON"})
dropdown("Anti Die", State.AntiDie, {"None", "Enabled"})
toggle("Anti Fling", State.AntiFling)
toggle("Safe Mode", State.SafeMode)

--==================================================
-- AUTO PATH
--==================================================

section("AUTO PATH CONFIGURATION")
dropdown("Auto Left", State.AutoLeft, {"Equals", "Minus"})
dropdown("Auto Right", State.AutoRight, {"Minus", "Equals"})
dropdown("Auto Play Mode", State.AutoPlayMode, {"Normal", "Auto Play"})

--==================================================
-- SKY
--==================================================

section("SKY THEME")
dropdown("Custom Sky", State.CustomSky, {"OFF", "ON"})

--==================================================
-- VISUAL
--==================================================

section("VISUAL")
dropdown("Display", State.Display, {"Default", "FOV", "Stretch"})
numberControl("Normal FOV", State.NormalFOV, 1)
toggle("No Cam Collision", State.NoCamCollision)

--==================================================
-- PERFORMANCE
--==================================================

section("PERFORMANCE CONFIGURATION")
toggle("Anti Lag", State.AntiLag)
toggle("Potato Graphics", State.PotatoGraphics)
toggle("Shiny Mode", State.ShinyMode)
dropdown("Dark Mode", "OFF", {"OFF", "ON"})

--==================================================
-- CUSTOMIZATION
--==================================================

section("CUSTOMIZATION")

dropdown("Background Image", State.Background,
    {"None", "Purple Candy", "Blue Candy", "Green Candy"})

dropdown("Lock UI", "OFF", {"OFF", "ON"})
dropdown("Intro Song", State.IntroSong, {"SONG 1", "SONG 2", "SONG 3"})
dropdown("Skip Intro", "OFF", {"OFF", "ON"})
keyButton("UI Toggle Key", State.UIToggleKey)

--==================================================
-- CUSTOM CONFIGURATION
--==================================================

section("CUSTOM CONFIGURATION")

numberControl("UI Size", State.UISize, 0.05)
numberControl("Steal Bar Scale", State.StealBarScale, 0.05)
numberControl("Mobile Btn Size", State.MobileBtnSize, 0.05)
dropdown("Hide Mobile Buttons", "OFF", {"OFF", "ON"})
toggle("Circle Buttons", State.CircleButtons)

actionButton("RESET MOBILE BUTTONS", function()
    print("Mobile buttons reset")
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
        saveConfig(configName)
        save.Text = "SAVED"
        task.delay(1, function()
            if save.Parent then save.Text = "SAVE" end
        end)
    end
end)

actionButton("RESET ALL CONFIG", function()
    resetAllConfig()
    configBox.Text = ""
    print("All settings reset to default")
end)

--==================================================
-- UI TOGGLE
--==================================================

local uiVisible = true

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        uiVisible = not uiVisible
        Main.Visible = uiVisible
    end
end)

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
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

print("SweetDuels candy UI loaded.")
