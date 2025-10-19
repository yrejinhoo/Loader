local Loader = {}

--==== Detect Platform & Screen Ratio =======================================--
local UserInputService = game:GetService("UserInputService")
local function isMobile()
    local success, result = pcall(function()
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    end)
    return success and result
end

local isOnMobile = isMobile()

local function isWideScreen()
    local success, viewport = pcall(function()
        return game.Workspace.CurrentCamera.ViewportSize
    end)
    if not success or not viewport or viewport.X == 0 or viewport.Y == 0 then
        return false
    end
    local aspectRatio = viewport.X / viewport.Y
    return aspectRatio >= 1.77
end

local isWide = isWideScreen()

local function scaleSize(mobile, desktop)
    return isOnMobile and mobile or desktop
end

--==== Configuration =========================================================--
local Config = {
    KeySystem = {
        enabled = true,
        keyLink = "https://astrion-keycrate.vercel.app/", -- 🔴 URL ANDA
    },
    
    Profile = {
        displayName = "ASTRION",
        subtitle = "Loader Script",
        avatarUserId = game.Players.LocalPlayer and game.Players.LocalPlayer.UserId or 1,
    },

    Scripts = {
        {
            name = "Auto Walk All Mout",
            url = "URL DI SINI",
            icon = "🚶",
            iconColor = Color3.fromRGB(100, 150, 255),
            enabled = false,
        },
        {
            name = "Check Admin Detector",
            url = "URL DI SINI",
            icon = "🛡️",
            iconColor = Color3.fromRGB(255, 100, 100),
            enabled = false,
        },
        {
            name = "Server HOP",
            url = "URL DI SINI",
            icon = "🌐",
            iconColor = Color3.fromRGB(100, 200, 255),
            enabled = false,
        },
        {
            name = "Fly GUI",
            url = "URL DI SINI",
            icon = "✈️",
            iconColor = Color3.fromRGB(150, 200, 255),
            enabled = false,
        },
        {
            name = "Super Ring Script Rusuh",
            url = "URL DI SINI",
            icon = "💍",
            iconColor = Color3.fromRGB(255, 215, 0),
            enabled = false,
        },
        {
            name = "Teleport",
            url = "URL DI SINI",
            icon = "⚡",
            iconColor = Color3.fromRGB(255, 200, 50),
            enabled = false,
        },
    },

    Features = {
        {
            name = "Auto Click",
            description = "Auto clicking feature",
            icon = "👆",
            iconColor = Color3.fromRGB(255, 150, 200),
            enabled = false,
        },
    },
}

--==== Utilities =============================================================--
local function safeParent(gui)
    local cg = game:GetService("CoreGui")
    local ok = pcall(function()
        gui.Parent = cg
    end)
    if not ok then
        gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

local function tween(obj, ti, props)
    local TS = game:GetService("TweenService")
    TS:Create(obj, ti, props):Play()
end

local function addCorner(instance, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 16)
    c.Parent = instance
    return c
end

local function addGradient(instance, colors, rotation)
    local g = Instance.new("UIGradient")
    g.Rotation = rotation or 45
    if colors then
        local keypoints = {}
        for i, color in ipairs(colors) do
            table.insert(keypoints, ColorSequenceKeypoint.new((i-1)/(#colors-1), color))
        end
        g.Color = ColorSequence.new(keypoints)
    end
    g.Parent = instance
    return g
end

local function getCurrentDateTime()
    local time = os.date("*t")
    local hour = time.hour
    local min = time.min
    local ampm = hour >= 12 and "PM" or "AM"
    hour = hour > 12 and hour - 12 or (hour == 0 and 12 or hour)
    local timeStr = string.format("%02d:%02d %s", hour, min, ampm)
    local dateStr = os.date("%B %d, %Y")
    return timeStr, dateStr
end

local function createClockWidget(parent, isHeader)
    local width = isHeader and scaleSize(120, 140) or scaleSize(130, 140)
    local height = scaleSize(50, 60)
    local textSizeTime = scaleSize(18, 20)
    local textSizeDate = scaleSize(10, 11)

    local clockFrame = Instance.new("Frame")
    clockFrame.Size = UDim2.new(0, width, 0, height)
    clockFrame.Position = isHeader and UDim2.new(0, scaleSize(270, 290), 0, 2) or UDim2.new(1, -width - 10, 0, scaleSize(15, 20))
    clockFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    clockFrame.BackgroundTransparency = 0.3
    clockFrame.ZIndex = 2
    clockFrame.Parent = parent
    addCorner(clockFrame, scaleSize(12, 14))
    
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, -16, 0, scaleSize(24, 28))
    timeLabel.Position = UDim2.new(0, 8, 0, scaleSize(4, 6))
    timeLabel.BackgroundTransparency = 1
    timeLabel.Font = Enum.Font.GothamBold
    timeLabel.TextSize = textSizeTime
    timeLabel.TextColor3 = Color3.fromRGB(40, 40, 50)
    timeLabel.ZIndex = 2
    timeLabel.Parent = clockFrame
    
    local dateLabel = Instance.new("TextLabel")
    dateLabel.Size = UDim2.new(1, -16, 0, scaleSize(16, 18))
    dateLabel.Position = UDim2.new(0, 8, 0, scaleSize(28, 34))
    dateLabel.BackgroundTransparency = 1
    dateLabel.Font = Enum.Font.Gotham
    dateLabel.TextSize = textSizeDate
    dateLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
    dateLabel.ZIndex = 2
    dateLabel.Parent = clockFrame
    
    local function updateClock()
        local timeStr, dateStr = getCurrentDateTime()
        timeLabel.Text = timeStr
        dateLabel.Text = dateStr
    end
    
    updateClock()
    spawn(function()
        while clockFrame and clockFrame.Parent do
            wait(1)
            updateClock()
        end
    end)
    
    return clockFrame
end

local function ensureBlur()
    local Lighting = game:GetService("Lighting")
    local blur = Lighting:FindFirstChild("_LoaderGlassBlur")
    if not blur then
        blur = Instance.new("BlurEffect")
        blur.Name = "_LoaderGlassBlur"
        blur.Size = isOnMobile and 16 or 24
        blur.Enabled = true
        blur.Parent = Lighting
    else
        blur.Enabled = true
    end
    return blur
end

local function disableBlur()
    local Lighting = game:GetService("Lighting")
    local blur = Lighting:FindFirstChild("_LoaderGlassBlur")
    if blur then blur.Enabled = false end
end

local function createBubbles(parent)
    local bubbles = Instance.new("Frame")
    bubbles.Name = "Bubbles"
    bubbles.Size = UDim2.new(1, 0, 1, 0)
    bubbles.BackgroundTransparency = 1
    bubbles.ZIndex = 0
    bubbles.Parent = parent
    
    local colors = {
        Color3.fromRGB(180, 190, 254),
        Color3.fromRGB(255, 200, 220),
        Color3.fromRGB(200, 255, 180),
        Color3.fromRGB(255, 220, 150),
    }
    
    for i = 1, 4 do
        local size = scaleSize(math.random(120, 220), math.random(200, 350))
        local bubble = Instance.new("Frame")
        bubble.Size = UDim2.new(0, size, 0, size)
        bubble.Position = UDim2.new(math.random(), 0, math.random(), 0)
        bubble.BackgroundColor3 = colors[i]
        bubble.BackgroundTransparency = 0.5
        bubble.BorderSizePixel = 0
        bubble.ZIndex = 0
        bubble.Parent = bubbles
        addCorner(bubble, 999)
        
        spawn(function()
            while bubble and bubble.Parent do
                local newPos = UDim2.new(math.random(), 0, math.random(), 0)
                tween(bubble, TweenInfo.new(math.random(8, 15), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = newPos})
                wait(math.random(8, 15))
            end
        end)
    end
end

--==== Loading Screen =======================================================--
function Loader:CreateLoadingScreen()
    local gui = Instance.new("ScreenGui")
    gui.Name = "LoadingScreen"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 1
    overlay.Parent = gui
    
    local panelWidth = scaleSize(320, 400)
    local panelHeight = scaleSize(260, 300)
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, panelWidth, 0, panelHeight)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    panel.BackgroundTransparency = 0.1
    panel.ZIndex = 1
    panel.Parent = overlay
    addCorner(panel, scaleSize(24, 32))
    panel.ClipsDescendants = true
    
    createBubbles(panel)
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.ZIndex = 2
    content.Parent = panel
    
    local logoSize = scaleSize(80, 100)
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, logoSize, 0, logoSize)
    logo.Position = UDim2.new(0.5, 0, 0, scaleSize(30, 40))
    logo.AnchorPoint = Vector2.new(0.5, 0)
    logo.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    logo.BackgroundTransparency = 0.2
    logo.Text = "🚀"
    logo.TextSize = scaleSize(40, 50)
    logo.Font = Enum.Font.GothamBold
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.ZIndex = 2
    logo.Parent = content
    addCorner(logo, scaleSize(20, 24))
    addGradient(logo, {Color3.fromRGB(100, 150, 255), Color3.fromRGB(150, 100, 255)}, 135)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -scaleSize(30, 40), 0, scaleSize(32, 40))
    title.Position = UDim2.new(0, scaleSize(15, 20), 0, scaleSize(120, 155))
    title.BackgroundTransparency = 1
    title.Text = "Loading Astrion Loader"
    title.TextSize = scaleSize(20, 24)
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(40, 40, 50)
    title.ZIndex = 2
    title.Parent = content
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -scaleSize(30, 40), 0, scaleSize(24, 30))
    status.Position = UDim2.new(0, scaleSize(15, 20), 0, scaleSize(150, 195))
    status.BackgroundTransparency = 1
    status.Text = "Initializing..."
    status.TextSize = scaleSize(14, 16)
    status.Font = Enum.Font.Gotham
    status.TextColor3 = Color3.fromRGB(100, 100, 120)
    status.ZIndex = 2
    status.Parent = content
    
    local progBg = Instance.new("Frame")
    progBg.Size = UDim2.new(1, -scaleSize(60, 80), 0, scaleSize(6, 8))
    progBg.Position = UDim2.new(0, scaleSize(30, 40), 1, -scaleSize(40, 50))
    progBg.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    progBg.BackgroundTransparency = 0.5
    progBg.ZIndex = 2
    progBg.Parent = content
    addCorner(progBg, scaleSize(3, 4))
    
    local progFill = Instance.new("Frame")
    progFill.Size = UDim2.new(0, 0, 1, 0)
    progFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    progFill.ZIndex = 3
    progFill.Parent = progBg
    addCorner(progFill, scaleSize(3, 4))
    addGradient(progFill, {Color3.fromRGB(100, 150, 255), Color3.fromRGB(150, 100, 255)}, 90)
    
    ensureBlur()
    safeParent(gui)
    
    local steps = {
        {text = "Initializing...", progress = 0.2},
        {text = "Loading UI components...", progress = 0.4},
        {text = "Connecting to server...", progress = 0.6},
        {text = "Verifying assets...", progress = 0.8},
        {text = "Almost ready...", progress = 1.0},
    }
    
    for _, step in ipairs(steps) do
        status.Text = step.text
        tween(progFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(step.progress, 0, 1, 0)})
        wait(0.6)
    end
    
    wait(0.3)
    gui:Destroy()
    disableBlur()
end

--==== Key System ===========================================================--
function Loader:CreateKeySystem(callback)
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystem"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 1
    overlay.Parent = gui
    
    local panelWidth = scaleSize(340, 480)
    local panelHeight = isWide and 420 or scaleSize(460, 520)
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, panelWidth, 0, panelHeight)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    panel.BackgroundTransparency = 0.1
    panel.ZIndex = 1
    panel.Parent = overlay
    addCorner(panel, scaleSize(24, 32))
    panel.ClipsDescendants = true
    
    createBubbles(panel)
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.ZIndex = 2
    content.Parent = panel
    
    local profileSection = Instance.new("Frame")
    profileSection.Size = UDim2.new(1, -scaleSize(40, 60), 0, scaleSize(80, 100))
    profileSection.Position = UDim2.new(0, scaleSize(20, 30), 0, scaleSize(20, 30))
    profileSection.BackgroundTransparency = 1
    profileSection.ZIndex = 2
    profileSection.Parent = content
    
    createClockWidget(content, false)
    
    local avatarSize = scaleSize(64, 80)
    local userAvatar = Instance.new("ImageLabel")
    userAvatar.Size = UDim2.new(0, avatarSize, 0, avatarSize)
    userAvatar.Position = UDim2.new(0, 0, 0, scaleSize(5, 10))
    userAvatar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    userAvatar.BackgroundTransparency = 0.3
    userAvatar.ZIndex = 2
    userAvatar.Parent = profileSection
    addCorner(userAvatar, scaleSize(16, 20))
    
    pcall(function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local thumb = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        userAvatar.Image = thumb
    end)
    
    local welcomeContainer = Instance.new("Frame")
    welcomeContainer.Size = UDim2.new(1, -avatarSize - scaleSize(10, 15), 1, 0)
    welcomeContainer.Position = UDim2.new(0, avatarSize + scaleSize(10, 15), 0, 0)
    welcomeContainer.BackgroundTransparency = 1
    welcomeContainer.ZIndex = 2
    welcomeContainer.Parent = profileSection
    
    local welcomeText = Instance.new("TextLabel")
    welcomeText.Size = UDim2.new(1, 0, 0, scaleSize(24, 30))
    welcomeText.Position = UDim2.new(0, 0, 0, scaleSize(8, 15))
    welcomeText.BackgroundTransparency = 1
    welcomeText.Text = "Welcome back!"
    welcomeText.TextSize = scaleSize(14, 16)
    welcomeText.Font = Enum.Font.Gotham
    welcomeText.TextColor3 = Color3.fromRGB(100, 100, 120)
    welcomeText.TextXAlignment = Enum.TextXAlignment.Left
    welcomeText.ZIndex = 2
    welcomeText.Parent = welcomeContainer
    
    local usernameText = Instance.new("TextLabel")
    usernameText.Size = UDim2.new(1, 0, 0, scaleSize(28, 35))
    usernameText.Position = UDim2.new(0, 0, 0, scaleSize(30, 40))
    usernameText.BackgroundTransparency = 1
    usernameText.Text = game.Players.LocalPlayer.Name
    usernameText.TextSize = scaleSize(20, 24)
    usernameText.Font = Enum.Font.GothamBold
    usernameText.TextColor3 = Color3.fromRGB(40, 40, 50)
    usernameText.TextXAlignment = Enum.TextXAlignment.Left
    usernameText.TextTruncate = Enum.TextTruncate.AtEnd
    usernameText.ZIndex = 2
    usernameText.Parent = welcomeContainer
    
    local lockSize = scaleSize(80, 100)
    local lockContainer = Instance.new("Frame")
    lockContainer.Size = UDim2.new(0, lockSize, 0, lockSize)
    lockContainer.Position = UDim2.new(0.5, 0, 0, scaleSize(100, 150))
    lockContainer.AnchorPoint = Vector2.new(0.5, 0)
    lockContainer.BackgroundColor3 = Color3.fromRGB(255, 120, 100)
    lockContainer.BackgroundTransparency = 0.2
    lockContainer.ZIndex = 2
    lockContainer.Parent = content
    addCorner(lockContainer, scaleSize(20, 24))
    addGradient(lockContainer, {Color3.fromRGB(255, 120, 100), Color3.fromRGB(255, 100, 150)}, 135)
    
    local lockIcon = Instance.new("TextLabel")
    lockIcon.Size = UDim2.new(1, 0, 1, 0)
    lockIcon.BackgroundTransparency = 1
    lockIcon.Text = "🔐"
    lockIcon.TextSize = scaleSize(40, 50)
    lockIcon.Font = Enum.Font.GothamBold
    lockIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockIcon.ZIndex = 3
    lockIcon.Parent = lockContainer
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -scaleSize(40, 60), 0, scaleSize(30, 35))
    title.Position = UDim2.new(0, scaleSize(20, 30), 0, scaleSize(200, 270))
    title.BackgroundTransparency = 1
    title.Text = "Key Verification"
    title.TextSize = scaleSize(22, 26)
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(40, 40, 50)
    title.ZIndex = 2
    title.Parent = content
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -scaleSize(40, 60), 0, scaleSize(24, 30))
    subtitle.Position = UDim2.new(0, scaleSize(20, 30), 0, scaleSize(230, 305))
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Enter your Astrion key to continue"
    subtitle.TextSize = scaleSize(13, 15)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextColor3 = Color3.fromRGB(100, 100, 120)
    subtitle.ZIndex = 2
    subtitle.Parent = content
    
    local inputHeight = scaleSize(44, 54)
    local inputBg = Instance.new("Frame")
    inputBg.Size = UDim2.new(1, -scaleSize(40, 60), 0, inputHeight)
    inputBg.Position = UDim2.new(0, scaleSize(20, 30), 0, scaleSize(250, 350))
    inputBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    inputBg.BackgroundTransparency = 0.3
    inputBg.ZIndex = 2
    inputBg.Parent = content
    addCorner(inputBg, scaleSize(12, 16))
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -scaleSize(20, 30), 1, 0)
    keyInput.Position = UDim2.new(0, scaleSize(10, 15), 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = "Astrion_keyhabwubwva_XXXXXX"
    keyInput.Text = ""
    keyInput.TextSize = scaleSize(16, 18)
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextColor3 = Color3.fromRGB(40, 40, 50)
    keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.ClearTextOnFocus = false
    keyInput.ZIndex = 3
    keyInput.Parent = inputBg
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(1, -scaleSize(40, 60), 0, inputHeight)
    submitBtn.Position = UDim2.new(0, scaleSize(20, 30), 0, scaleSize(300, 420))
    submitBtn.Text = "Verify Key"
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = scaleSize(16, 18)
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.BackgroundColor3 = Color3.fromRGB(110, 140, 255)
    submitBtn.BackgroundTransparency = 0
    submitBtn.ZIndex = 2
    submitBtn.Parent = content
    addCorner(submitBtn, scaleSize(12, 16))
    addGradient(submitBtn, {Color3.fromRGB(140, 160, 255), Color3.fromRGB(100, 130, 255)}, 90)
    
    -- Get Key Button
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Text = "📋 Get Key"
    getKeyBtn.Font = Enum.Font.Gotham
    getKeyBtn.TextSize = scaleSize(12, 14)
    getKeyBtn.TextColor3 = Color3.fromRGB(100, 100, 120)
    getKeyBtn.BackgroundTransparency = 1
    getKeyBtn.ZIndex = 2
    getKeyBtn.Parent = content

    local btnWidth = scaleSize(200, 240)
    if isWide then
        getKeyBtn.Size = UDim2.new(0, btnWidth, 0, scaleSize(30, 35))
        getKeyBtn.Position = UDim2.new(0.5, -btnWidth/2, 1, -scaleSize(45, 45))
    else
        getKeyBtn.Size = UDim2.new(1, -scaleSize(40, 60), 0, scaleSize(30, 35))
        getKeyBtn.Position = UDim2.new(0, scaleSize(20, 30), 1, -scaleSize(45, 45))
    end

    local errorMsg = Instance.new("TextLabel")
    errorMsg.Size = UDim2.new(1, -scaleSize(40, 60), 0, scaleSize(20, 25))
    errorMsg.Position = UDim2.new(0, scaleSize(20, 30), 0, scaleSize(350, 478))
    errorMsg.BackgroundTransparency = 1
    errorMsg.Text = ""
    errorMsg.TextSize = scaleSize(12, 14)
    errorMsg.Font = Enum.Font.Gotham
    errorMsg.TextColor3 = Color3.fromRGB(255, 100, 100)
    errorMsg.ZIndex = 2
    errorMsg.Visible = false
    errorMsg.Parent = content
    
    ensureBlur()
    safeParent(gui)
    
    getKeyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(Config.KeySystem.keyLink)
            getKeyBtn.Text = "✅ Link Copied!"
            wait(2)
            getKeyBtn.Text = "📋 Get Key"
        end)
    end)
    
    -- 🔑 VERIFIKASI VIA WEB 🔑
    local function verifyKey()
        local rawKey = keyInput.Text
        if not rawKey or rawKey == "" then
            errorMsg.Text = "❌ Please enter a key"
            errorMsg.Visible = true
            return
        end

        local key = rawKey:gsub("%s+", ""):upper()
        if not key:match("^ASTRION_KEYHABWUBWVA_") then
            errorMsg.Text = "❌ Invalid key format"
            errorMsg.Visible = true
            return
        end

        errorMsg.Visible = false
        submitBtn.Text = "Checking..."
        submitBtn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

        local validateUrl = "https://astrion-keycrate.vercel.app/validate?key=" .. key

        local success, response = pcall(function()
            return game:HttpGet(validateUrl)
        end)

        if not success or not response then
            errorMsg.Text = "❌ Network error. Try again."
            errorMsg.Visible = true
            submitBtn.Text = "Verify Key"
            submitBtn.BackgroundColor3 = Color3.fromRGB(110, 140, 255)
            return
        end

        if response:find('"success":%s*true') then
            submitBtn.Text = "✅ Verified!"
            submitBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 120)
            wait(0.5)
            disableBlur()
            gui:Destroy()
            if callback then callback() end
        else
            errorMsg.Text = "❌ Invalid or used key!"
            errorMsg.Visible = true
            submitBtn.Text = "Verify Key"
            submitBtn.BackgroundColor3 = Color3.fromRGB(110, 140, 255)
        end
    end
    
    submitBtn.MouseButton1Click:Connect(verifyKey)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then verifyKey() end
    end)
end

--==== Main Loader UI =======================================================--
function Loader:CreateMainUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ModernGlassLoader"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Parent = gui

    local panelWidth = scaleSize(340, 560)
    local panelHeight = isWide and 540 or scaleSize(580, 680)
    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.new(0, panelWidth, 0, panelHeight)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    panel.BackgroundTransparency = 0.1
    panel.ZIndex = 1
    panel.Parent = overlay
    addCorner(panel, scaleSize(24, 32))
    panel.ClipsDescendants = true
    
    createBubbles(panel)

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2
    contentFrame.Parent = panel

    local headerHeight = isWide and 70 or scaleSize(80, 100)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, -scaleSize(30, 40), 0, headerHeight)
    header.Position = UDim2.new(0, scaleSize(15, 20), 0, scaleSize(15, 20))
    header.ZIndex = 2
    header.Parent = contentFrame

    local avatarSize = scaleSize(50, 64)
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, avatarSize, 0, avatarSize)
    avatar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    avatar.BackgroundTransparency = 0.3
    avatar.ZIndex = 2
    avatar.Parent = header
    addCorner(avatar, scaleSize(12, 16))

    pcall(function()
        local Players = game:GetService("Players")
        local thumb = Players:GetUserThumbnailAsync(Config.Profile.avatarUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        avatar.Image = thumb
    end)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, avatarSize + scaleSize(8, 12), 0, scaleSize(4, 8))
    nameLabel.Size = UDim2.new(0, scaleSize(160, 200), 0, scaleSize(26, 32))
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = scaleSize(20, 26)
    nameLabel.TextColor3 = Color3.fromRGB(40, 40, 50)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Text = Config.Profile.displayName
    nameLabel.ZIndex = 2
    nameLabel.Parent = header

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Position = UDim2.new(0, avatarSize + scaleSize(8, 12), 0, scaleSize(28, 40))
    sub.Size = UDim2.new(0, scaleSize(160, 200), 0, scaleSize(20, 24))
    sub.Font = Enum.Font.Gotham
    sub.TextSize = scaleSize(13, 15)
    sub.TextColor3 = Color3.fromRGB(100, 100, 120)
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Text = Config.Profile.subtitle
    sub.ZIndex = 2
    sub.Parent = header
    
    createClockWidget(header, true)

    local helpSize = scaleSize(32, 40)
    local help = Instance.new("TextButton")
    help.Name = "Help"
    help.Text = "?"
    help.Font = Enum.Font.GothamBold
    help.TextSize = scaleSize(20, 24)
    help.TextColor3 = Color3.fromRGB(50, 50, 70)
    help.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    help.BackgroundTransparency = 0.3
    help.Size = UDim2.new(0, helpSize, 0, helpSize)
    help.Position = UDim2.new(1, -helpSize * 2 - scaleSize(8, 12), 0, scaleSize(8, 12))
    help.ZIndex = 2
    help.Parent = header
    addCorner(help, scaleSize(10, 12))

    local close = help:Clone()
    close.Name = "Close"
    close.Text = "x"
    close.Position = UDim2.new(1, -helpSize - scaleSize(8, 12), 0, scaleSize(8, 12))
    close.Parent = header

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll"
    scroll.BackgroundTransparency = 1
    scroll.Position = UDim2.new(0, scaleSize(15, 20), 0, headerHeight + scaleSize(15, 30))
    scroll.Size = UDim2.new(1, -scaleSize(30, 40), 1, -scaleSize(120, 220))
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 0
    scroll.ZIndex = 2
    scroll.Parent = contentFrame

    local list = Instance.new("UIListLayout")
    list.Parent = scroll
    list.Padding = UDim.new(0, scaleSize(8, 12))
    list.SortOrder = Enum.SortOrder.LayoutOrder

    local function addSectionTitle(text)
        local t = Instance.new("TextLabel")
        t.BackgroundTransparency = 1
        t.Size = UDim2.new(1, 0, 0, scaleSize(30, 36))
        t.TextXAlignment = Enum.TextXAlignment.Center
        t.Text = string.upper(text)
        t.TextColor3 = Color3.fromRGB(100, 100, 120)
        t.Font = Enum.Font.GothamMedium
        t.TextSize = scaleSize(16, 18)
        t.ZIndex = 2
        t.Parent = scroll
        return t
    end

    local toggles = {}
    local function createToggleRow(iconEmoji, iconColor, title)
        local rowHeight = scaleSize(58, 68)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, rowHeight)
        row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        row.BackgroundTransparency = 0.25
        row.ZIndex = 2
        row.Parent = scroll
        addCorner(row, scaleSize(14, 18))

        local iconSize = scaleSize(40, 48)
        local iconBg = Instance.new("Frame")
        iconBg.Size = UDim2.new(0, iconSize, 0, iconSize)
        iconBg.Position = UDim2.new(0, scaleSize(10, 14), 0, scaleSize(6, 10))
        iconBg.BackgroundColor3 = iconColor
        iconBg.BackgroundTransparency = 0.3
        iconBg.ZIndex = 2
        iconBg.Parent = row
        addCorner(iconBg, scaleSize(10, 12))
        addGradient(iconBg, {Color3.fromRGB(255, 255, 255), iconColor}, 135)

        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Text = iconEmoji or "📦"
        icon.TextSize = scaleSize(24, 28)
        icon.Font = Enum.Font.GothamBold
        icon.TextColor3 = Color3.fromRGB(255, 255, 255)
        icon.ZIndex = 3
        icon.Parent = iconBg

        local titleL = Instance.new("TextLabel")
        titleL.BackgroundTransparency = 1
        titleL.Position = UDim2.new(0, iconSize + scaleSize(10, 14), 0, 0)
        titleL.Size = UDim2.new(1, -scaleSize(160, 200), 1, 0)
        titleL.Font = Enum.Font.GothamMedium
        titleL.TextSize = scaleSize(17, 19)
        titleL.TextXAlignment = Enum.TextXAlignment.Left
        titleL.TextYAlignment = Enum.TextYAlignment.Center
        titleL.TextColor3 = Color3.fromRGB(30, 30, 40)
        titleL.Text = title
        titleL.ZIndex = 2
        titleL.Parent = row

        local switchSize = scaleSize(44, 52)
        local switchBg = Instance.new("Frame")
        switchBg.Name = "Switch"
        switchBg.Size = UDim2.new(0, switchSize, 0, scaleSize(26, 32))
        switchBg.Position = UDim2.new(1, -switchSize - scaleSize(8, 12), 0.5, -scaleSize(13, 16))
        switchBg.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
        switchBg.ZIndex = 2
        switchBg.Parent = row
        addCorner(switchBg, scaleSize(13, 16))

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, scaleSize(24, 28), 0, scaleSize(24, 28))
        knob.Position = UDim2.new(0, scaleSize(1, 2), 0, scaleSize(1, 2))
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.ZIndex = 3
        knob.Parent = switchBg
        addCorner(knob, scaleSize(12, 14))

        local state = false
        local function setState(v)
            state = v and true or false
            if state then
                tween(switchBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(52, 120, 246)})
                tween(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -scaleSize(25, 30), 0, scaleSize(1, 2))})
            else
                tween(switchBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(200, 200, 210)})
                tween(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, scaleSize(1, 2), 0, scaleSize(1, 2))})
            end
        end

        local hit = Instance.new("TextButton")
        hit.BackgroundTransparency = 1
        hit.Text = ""
        hit.Size = UDim2.new(1, 0, 1, 0)
        hit.ZIndex = 4
        hit.Parent = row
        hit.MouseButton1Click:Connect(function()
            setState(not state)
        end)

        setState(false)
        return {
            container = row,
            get = function() return state end,
            set = setState,
        }
    end

    addSectionTitle("SCRIPTS")
    local scriptToggles = {}
    for _, s in ipairs(Config.Scripts) do
        local t = createToggleRow(s.icon, s.iconColor, s.name)
        t.set(s.enabled)
        table.insert(scriptToggles, {toggle=t, script=s})
    end

    if Config.Features and #Config.Features > 0 then
        addSectionTitle("FEATURES")
        for _, f in ipairs(Config.Features) do
            local t = createToggleRow(f.icon, f.iconColor, f.name)
            t.set(f.enabled)
        end
    end

    local function refreshCanvas()
        scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + scaleSize(15, 20))
    end
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)
    refreshCanvas()

    local startBtn = Instance.new("TextButton")
    startBtn.Name = "Start"
    startBtn.Size = UDim2.new(1, -scaleSize(30, 40), 0, scaleSize(48, 58))
    startBtn.Position = UDim2.new(0, scaleSize(15, 20), 1, -scaleSize(68, 78))
    startBtn.Text = "Start load script"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = scaleSize(18, 20)
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 100)
    startBtn.BackgroundTransparency = 0.15
    startBtn.ZIndex = 2
    startBtn.Parent = contentFrame
    addCorner(startBtn, scaleSize(16, 20))
    addGradient(startBtn, {Color3.fromRGB(80, 150, 100), Color3.fromRGB(100, 180, 120)}, 90)

    help.MouseButton1Click:Connect(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Loader Help",
            Text = "Toggle scripts and press Start to load.",
            Duration = 4
        })
    end)

    close.MouseButton1Click:Connect(function()
        pcall(function()
            disableBlur()
        end)
        pcall(function()
            gui:Destroy()
        end)
    end)

    ensureBlur()
    safeParent(gui)

    startBtn.MouseButton1Click:Connect(function()
        startBtn.Active = false
        startBtn.AutoButtonColor = false
        startBtn.Text = "Loading..."
        
        spawn(function()
            for _, pair in ipairs(scriptToggles) do
                if pair.toggle.get() then
                    local s = pair.script
                    local success, err = pcall(function()
                        local content = game:HttpGet(s.url)
                        if content then
                            local fn = loadstring(content)
                            if fn then 
                                spawn(function()
                                    fn()
                                end)
                            end
                        end
                    end)
                    if not success then
                        warn("[Loader] Failed to load " .. s.name .. ": " .. tostring(err))
                    end
                    wait(0.3)
                end
            end

            startBtn.Text = "Done!"
            wait(0.5)
            disableBlur()
            pcall(function()
                gui:Destroy()
            end)
        end)
    end)

    return gui
end

--==== Initialize ===========================================================--
function Loader:Init()
    local function cleanupOldGuis()
        pcall(function()
            local cg = game:GetService("CoreGui")
            local pg = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            for _, gui in ipairs(cg:GetChildren()) do
                if gui.Name:find("Loader") or gui.Name:find("KeySystem") or gui.Name:find("LoadingScreen") then
                    gui:Destroy()
                end
            end
            for _, gui in ipairs(pg:GetChildren()) do
                if gui.Name:find("Loader") or gui.Name:find("KeySystem") or gui.Name:find("LoadingScreen") then
                    gui:Destroy()
                end
            end
        end)
    end
    
    cleanupOldGuis()
    disableBlur()
    wait(0.2)
    self:CreateLoadingScreen()
    
    if Config.KeySystem.enabled then
        self:CreateKeySystem(function()
            wait(0.1)
            self:CreateMainUI()
        end)
    else
        self:CreateMainUI()
    end
end

-- Auto-start
Loader:Init()

return Loader
