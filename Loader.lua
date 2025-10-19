local Loader = {}

--==== Configuration =========================================================--
local Config = {
    -- Key System Settings
    KeySystem = {
        enabled = true,
        correctKey = "change", -- Change this to your key
        keyLink = "xxx", -- Where to get key
    },
    
    Profile = {
        displayName = "ISI AJA",
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

--==== Device Detection ======================================================--
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local isTablet = UserInputService.TouchEnabled and UserInputService.KeyboardEnabled

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

-- Get responsive size based on device
local function getResponsiveSize()
    local viewport = workspace.CurrentCamera.ViewportSize
    if isMobile then
        -- Mobile: use most of the screen
        return {
            width = math.min(viewport.X * 0.95, 420),
            height = math.min(viewport.Y * 0.85, 650),
            padding = 12,
            headerHeight = 70,
            itemHeight = 56,
            fontSize = {
                title = 20,
                subtitle = 13,
                button = 16,
                item = 16,
            }
        }
    elseif isTablet then
        -- Tablet: medium size
        return {
            width = 480,
            height = 680,
            padding = 16,
            headerHeight = 90,
            itemHeight = 64,
            fontSize = {
                title = 24,
                subtitle = 15,
                button = 18,
                item = 18,
            }
        }
    else
        -- Desktop: original size
        return {
            width = 560,
            height = 680,
            padding = 20,
            headerHeight = 100,
            itemHeight = 68,
            fontSize = {
                title = 26,
                subtitle = 15,
                button = 20,
                item = 19,
            }
        }
    end
end

-- Get current time and date
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

-- Create animated clock widget (mobile optimized)
local function createClockWidget(parent, size)
    if isMobile then
        -- On mobile, create smaller clock
        local clockFrame = Instance.new("Frame")
        clockFrame.Size = UDim2.new(0, 100, 0, 45)
        clockFrame.Position = UDim2.new(1, -110, 0, 10)
        clockFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        clockFrame.BackgroundTransparency = 0.3
        clockFrame.ZIndex = 2
        clockFrame.Parent = parent
        addCorner(clockFrame, 10)
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Size = UDim2.new(1, -12, 0, 22)
        timeLabel.Position = UDim2.new(0, 6, 0, 4)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Font = Enum.Font.GothamBold
        timeLabel.TextSize = 15
        timeLabel.TextColor3 = Color3.fromRGB(40, 40, 50)
        timeLabel.ZIndex = 2
        timeLabel.Parent = clockFrame
        
        local dateLabel = Instance.new("TextLabel")
        dateLabel.Size = UDim2.new(1, -12, 0, 14)
        dateLabel.Position = UDim2.new(0, 6, 0, 26)
        dateLabel.BackgroundTransparency = 1
        dateLabel.Font = Enum.Font.Gotham
        dateLabel.TextSize = 9
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
    else
        -- Desktop/tablet version
        local clockFrame = Instance.new("Frame")
        clockFrame.Size = UDim2.new(0, 140, 0, 60)
        clockFrame.Position = UDim2.new(1, -160, 0, 20)
        clockFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        clockFrame.BackgroundTransparency = 0.3
        clockFrame.ZIndex = 2
        clockFrame.Parent = parent
        addCorner(clockFrame, 14)
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Size = UDim2.new(1, -16, 0, 28)
        timeLabel.Position = UDim2.new(0, 8, 0, 6)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Font = Enum.Font.GothamBold
        timeLabel.TextSize = 20
        timeLabel.TextColor3 = Color3.fromRGB(40, 40, 50)
        timeLabel.ZIndex = 2
        timeLabel.Parent = clockFrame
        
        local dateLabel = Instance.new("TextLabel")
        dateLabel.Size = UDim2.new(1, -16, 0, 18)
        dateLabel.Position = UDim2.new(0, 8, 0, 34)
        dateLabel.BackgroundTransparency = 1
        dateLabel.Font = Enum.Font.Gotham
        dateLabel.TextSize = 11
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
end

local function ensureBlur()
    local Lighting = game:GetService("Lighting")
    local blur = Lighting:FindFirstChild("_LoaderGlassBlur")
    if not blur then
        blur = Instance.new("BlurEffect")
        blur.Name = "_LoaderGlassBlur"
        blur.Size = 24
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
    
    local bubbleCount = isMobile and 3 or 4
    local bubbleSize = isMobile and {150, 250} or {200, 350}
    
    for i = 1, bubbleCount do
        local bubble = Instance.new("Frame")
        bubble.Size = UDim2.new(0, math.random(bubbleSize[1], bubbleSize[2]), 0, math.random(bubbleSize[1], bubbleSize[2]))
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
    local size = getResponsiveSize()
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "LoadingScreen"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 1
    overlay.Parent = gui
    
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, size.width, 0, math.min(size.height * 0.5, 300))
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    panel.BackgroundTransparency = 0.1
    panel.ZIndex = 1
    panel.Parent = overlay
    addCorner(panel, isMobile and 20 or 32)
    panel.ClipsDescendants = true
    
    createBubbles(panel)
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.ZIndex = 2
    content.Parent = panel
    
    local logoSize = isMobile and 70 or 100
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, logoSize, 0, logoSize)
    logo.Position = UDim2.new(0.5, 0, 0, isMobile and 25 or 40)
    logo.AnchorPoint = Vector2.new(0.5, 0)
    logo.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    logo.BackgroundTransparency = 0.2
    logo.Text = "🚀"
    logo.TextSize = isMobile and 35 or 50
    logo.Font = Enum.Font.GothamBold
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.ZIndex = 2
    logo.Parent = content
    addCorner(logo, isMobile and 16 or 24)
    addGradient(logo, {Color3.fromRGB(100, 150, 255), Color3.fromRGB(150, 100, 255)}, 135)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -size.padding*2, 0, 35)
    title.Position = UDim2.new(0, size.padding, 0, logoSize + (isMobile and 35 or 55))
    title.BackgroundTransparency = 1
    title.Text = "Loading Rebels Loader"
    title.TextSize = size.fontSize.title
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(40, 40, 50)
    title.ZIndex = 2
    title.Parent = content
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -size.padding*2, 0, 25)
    status.Position = UDim2.new(0, size.padding, 0, logoSize + (isMobile and 65 or 90))
    status.BackgroundTransparency = 1
    status.Text = "Initializing..."
    status.TextSize = size.fontSize.subtitle
    status.Font = Enum.Font.Gotham
    status.TextColor3 = Color3.fromRGB(100, 100, 120)
    status.ZIndex = 2
    status.Parent = content
    
    local progBg = Instance.new("Frame")
    progBg.Size = UDim2.new(1, -size.padding*4, 0, 6)
    progBg.Position = UDim2.new(0, size.padding*2, 1, isMobile and -35 or -50)
    progBg.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    progBg.BackgroundTransparency = 0.5
    progBg.ZIndex = 2
    progBg.Parent = content
    addCorner(progBg, 3)
    
    local progFill = Instance.new("Frame")
    progFill.Size = UDim2.new(0, 0, 1, 0)
    progFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    progFill.ZIndex = 3
    progFill.Parent = progBg
    addCorner(progFill, 3)
    addGradient(progFill, {Color3.fromRGB(100, 150, 255), Color3.fromRGB(150, 100, 255)}, 90)
    
    ensureBlur()
    safeParent(gui)
    
    local steps = {
        {text = "Initializing...", progress = 0.2},
        {text = "Loading UI...", progress = 0.4},
        {text = "Connecting...", progress = 0.6},
        {text = "Verifying...", progress = 0.8},
        {text = "Ready...", progress = 1.0},
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
    local size = getResponsiveSize()
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystem"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 1
    overlay.Parent = gui
    
    local panelHeight = isMobile and math.min(size.height * 0.9, 500) or 520
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, size.width, 0, panelHeight)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    panel.BackgroundTransparency = 0.1
    panel.ZIndex = 1
    panel.Parent = overlay
    addCorner(panel, isMobile and 20 or 32)
    panel.ClipsDescendants = true
    
    createBubbles(panel)
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.ZIndex = 2
    content.Parent = panel
    
    local profileSection = Instance.new("Frame")
    profileSection.Size = UDim2.new(1, -size.padding*2, 0, isMobile and 70 or 100)
    profileSection.Position = UDim2.new(0, size.padding, 0, size.padding)
    profileSection.BackgroundTransparency = 1
    profileSection.ZIndex = 2
    profileSection.Parent = content
    
    createClockWidget(content, size)
    
    local avatarSize = isMobile and 60 or 80
    local userAvatar = Instance.new("ImageLabel")
    userAvatar.Size = UDim2.new(0, avatarSize, 0, avatarSize)
    userAvatar.Position = UDim2.new(0, 0, 0, isMobile and 5 or 10)
    userAvatar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    userAvatar.BackgroundTransparency = 0.3
    userAvatar.ZIndex = 2
    userAvatar.Parent = profileSection
    addCorner(userAvatar, isMobile and 14 or 20)
    
    pcall(function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local thumb = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        userAvatar.Image = thumb
    end)
    
    local welcomeContainer = Instance.new("Frame")
    welcomeContainer.Size = UDim2.new(1, -(avatarSize + 15), 1, 0)
    welcomeContainer.Position = UDim2.new(0, avatarSize + 10, 0, 0)
    welcomeContainer.BackgroundTransparency = 1
    welcomeContainer.ZIndex = 2
    welcomeContainer.Parent = profileSection
    
    local welcomeText = Instance.new("TextLabel")
    welcomeText.Size = UDim2.new(1, 0, 0, 25)
    welcomeText.Position = UDim2.new(0, 0, 0, isMobile and 10 or 15)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Text = "Welcome back!"
    welcomeText.TextSize = size.fontSize.subtitle
    welcomeText.Font = Enum.Font.Gotham
    welcomeText.TextColor3 = Color3.fromRGB(100, 100, 120)
    welcomeText.TextXAlignment = Enum.TextXAlignment.Left
    welcomeText.ZIndex = 2
    welcomeText.Parent = welcomeContainer
    
    local usernameText = Instance.new("TextLabel")
    usernameText.Size = UDim2.new(1, -110, 0, 30)
    usernameText.Position = UDim2.new(0, 0, 0, isMobile and 30 or 40)
    usernameText.BackgroundTransparency = 1
    usernameText.Text = game.Players.LocalPlayer.Name
    usernameText.TextSize = size.fontSize.title
    usernameText.Font = Enum.Font.GothamBold
    usernameText.TextColor3 = Color3.fromRGB(40, 40, 50)
    usernameText.TextXAlignment = Enum.TextXAlignment.Left
    usernameText.TextTruncate = Enum.TextTruncate.AtEnd
    usernameText.ZIndex = 2
    usernameText.Parent = welcomeContainer
    
    local lockSize = isMobile and 75 or 100
    local lockContainer = Instance.new("Frame")
    lockContainer.Size = UDim2.new(0, lockSize, 0, lockSize)
    lockContainer.Position = UDim2.new(0.5, 0, 0, isMobile and 100 or 150)
    lockContainer.AnchorPoint = Vector2.new(0.5, 0)
    lockContainer.BackgroundColor3 = Color3.fromRGB(255, 120, 100)
    lockContainer.BackgroundTransparency = 0.2
    lockContainer.ZIndex = 2
    lockContainer.Parent = content
    addCorner(lockContainer, isMobile and 18 or 24)
    addGradient(lockContainer, {Color3.fromRGB(255, 120, 100), Color3.fromRGB(255, 100, 150)}, 135)
    
    local lockIcon = Instance.new("TextLabel")
    lockIcon.Size = UDim2.new(1, 0, 1, 0)
    lockIcon.BackgroundTransparency = 1
    lockIcon.Text = "🔐"
    lockIcon.TextSize = isMobile and 40 or 50
    lockIcon.Font = Enum.Font.GothamBold
    lockIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockIcon.ZIndex = 3
    lockIcon.Parent = lockContainer
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -size.padding*2, 0, 30)
    title.Position = UDim2.new(0, size.padding, 0, isMobile and 190 or 270)
    title.BackgroundTransparency = 1
    title.Text = "Key Verification"
    title.TextSize = size.fontSize.title
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(40, 40, 50)
    title.ZIndex = 2
    title.Parent = content
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -size.padding*2, 0, 25)
    subtitle.Position = UDim2.new(0, size.padding, 0, isMobile and 220 or 305)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Enter your access key to continue"
    subtitle.TextSize = size.fontSize.subtitle
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextColor3 = Color3.fromRGB(100, 100, 120)
    subtitle.ZIndex = 2
    subtitle.Parent = content
    
    local inputBg = Instance.new("Frame")
    inputBg.Size = UDim2.new(1, -size.padding*2, 0, isMobile and 48 or 54)
    inputBg.Position = UDim2.new(0, size.padding, 0, isMobile and 260 or 350)
    inputBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    inputBg.BackgroundTransparency = 0.3
    inputBg.ZIndex = 2
    inputBg.Parent = content
    addCorner(inputBg, isMobile and 12 or 16)
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -24, 1, 0)
    keyInput.Position = UDim2.new(0, 12, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = "Enter Key Here..."
    keyInput.Text = ""
    keyInput.TextSize = size.fontSize.button
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextColor3 = Color3.fromRGB(40, 40, 50)
    keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.ClearTextOnFocus = false
    keyInput.ZIndex = 3
    keyInput.Parent = inputBg
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(1, -size.padding*2, 0, isMobile and 48 or 54)
    submitBtn.Position = UDim2.new(0, size.padding, 0, isMobile and 320 or 420)
    submitBtn.Text = "Verify Key"
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = size.fontSize.button
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.BackgroundColor3 = Color3.fromRGB(110, 140, 255)
    submitBtn.BackgroundTransparency = 0
    submitBtn.ZIndex = 2
    submitBtn.Parent = content
    addCorner(submitBtn, isMobile and 12 or 16)
    
    local btnGradient = addGradient(submitBtn, {
        Color3.fromRGB(140, 160, 255), 
        Color3.fromRGB(100, 130, 255)
    }, 90)
    
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(1, -size.padding*2, 0, 30)
    getKeyBtn.Position = UDim2.new(0, size.padding, 1, isMobile and -38 or -45)
    getKeyBtn.Text = "📋 Get Key: " .. Config.KeySystem.keyLink
    getKeyBtn.Font = Enum.Font.Gotham
    getKeyBtn.TextSize = isMobile and 12 or 14
    getKeyBtn.TextColor3 = Color3.fromRGB(100, 100, 120)
    getKeyBtn.BackgroundTransparency = 1
    getKeyBtn.ZIndex = 2
    getKeyBtn.Parent = content
    
    local errorMsg = Instance.new("TextLabel")
    errorMsg.Size = UDim2.new(1, -size.padding*2, 0, 20)
    errorMsg.Position = UDim2.new(0, size.padding, 0, isMobile and 375 or 478)
    errorMsg.BackgroundTransparency = 1
    errorMsg.Text = ""
    errorMsg.TextSize = size.fontSize.subtitle
    errorMsg.Font = Enum.Font.Gotham
    errorMsg.TextColor3 = Color3.fromRGB(255, 100, 100)
    errorMsg.ZIndex = 2
    errorMsg.Visible = false
    errorMsg.Parent = content
    
    ensureBlur()
    safeParent(gui)
    
    getKeyBtn.MouseButton1Click:Connect(function()
        setclipboard(Config.KeySystem.keyLink)
        getKeyBtn.Text = "✅ Link Copied to Clipboard!"
        wait(2)
        getKeyBtn.Text = "📋 Get Key: " .. Config.KeySystem.keyLink
    end)
    
    local function verifyKey()
        local enteredKey = keyInput.Text
        if enteredKey == Config.KeySystem.correctKey then
            errorMsg.Visible = false
            submitBtn.Text = "✅ Verified!"
            submitBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 120)
            submitBtn.BackgroundTransparency = 0
            if btnGradient then btnGradient:Destroy() end
            wait(0.5)
            disableBlur()
            gui:Destroy()
            if callback then callback() end
        else
            errorMsg.Text = "❌ Invalid key! Please try again."
            errorMsg.Visible = true
            tween(inputBg, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true), {Position = UDim2.new(0, size.padding + 10, 0, isMobile and 260 or 350)})
            wait(0.3)
            inputBg.Position = UDim2.new(0, size.padding, 0, isMobile and 260 or 350)
        end
    end
    
    submitBtn.MouseButton1Click:Connect(verifyKey)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then verifyKey() end
    end)
end

--==== Main Loader UI =======================================================--
function Loader:CreateMainUI()
    local size = getResponsiveSize()
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "ModernGlassLoader"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Parent = gui

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.new(0, size.width, 0, size.height)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    panel.BackgroundTransparency = 0.1
    panel.ZIndex = 1
    panel.Parent = overlay
    addCorner(panel, isMobile and 20 or 32)
    panel.ClipsDescendants = true
    
    createBubbles(panel)

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2
    contentFrame.Parent = panel

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, -size.padding*2, 0, size.headerHeight)
    header.Position = UDim2.new(0, size.padding, 0, size.padding)
    header.ZIndex = 2
    header.Parent = contentFrame

    local avatarSize = isMobile and 50 or 64
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, avatarSize, 0, avatarSize)
    avatar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    avatar.BackgroundTransparency = 0.3
    avatar.ZIndex = 2
    avatar.Parent = header
    addCorner(avatar, isMobile and 12 or 16)

    pcall(function()
        local Players = game:GetService("Players")
        local thumb = Players:GetUserThumbnailAsync(Config.Profile.avatarUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        avatar.Image = thumb
    end)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, avatarSize + 10, 0, isMobile and 4 or 8)
    nameLabel.Size = UDim2.new(0, 200, 0, isMobile and 26 or 32)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = size.fontSize.title
    nameLabel.TextColor3 = Color3.fromRGB(40, 40, 50)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Text = Config.Profile.displayName
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex = 2
    nameLabel.Parent = header

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Position = UDim2.new(0, avatarSize + 10, 0, isMobile and 28 or 40)
    sub.Size = UDim2.new(0, 200, 0, 20)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = size.fontSize.subtitle
    sub.TextColor3 = Color3.fromRGB(100, 100, 120)
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Text = Config.Profile.subtitle
    sub.TextTruncate = Enum.TextTruncate.AtEnd
    sub.ZIndex = 2
    sub.Parent = header
    
    -- Clock widget in header (responsive positioning)
    if not isMobile then
        local headerClock = Instance.new("Frame")
        headerClock.Size = UDim2.new(0, 140, 0, 60)
        headerClock.Position = UDim2.new(1, -188, 0, 2)
        headerClock.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        headerClock.BackgroundTransparency = 0.3
        headerClock.ZIndex = 2
        headerClock.Parent = header
        addCorner(headerClock, 14)
        
        local headerTimeLabel = Instance.new("TextLabel")
        headerTimeLabel.Size = UDim2.new(1, -16, 0, 28)
        headerTimeLabel.Position = UDim2.new(0, 8, 0, 6)
        headerTimeLabel.BackgroundTransparency = 1
        headerTimeLabel.Font = Enum.Font.GothamBold
        headerTimeLabel.TextSize = 20
        headerTimeLabel.TextColor3 = Color3.fromRGB(40, 40, 50)
        headerTimeLabel.ZIndex = 2
        headerTimeLabel.Parent = headerClock
        
        local headerDateLabel = Instance.new("TextLabel")
        headerDateLabel.Size = UDim2.new(1, -16, 0, 18)
        headerDateLabel.Position = UDim2.new(0, 8, 0, 34)
        headerDateLabel.BackgroundTransparency = 1
        headerDateLabel.Font = Enum.Font.Gotham
        headerDateLabel.TextSize = 11
        headerDateLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
        headerDateLabel.ZIndex = 2
        headerDateLabel.Parent = headerClock
        
        local function updateHeaderClock()
            local timeStr, dateStr = getCurrentDateTime()
            headerTimeLabel.Text = timeStr
            headerDateLabel.Text = dateStr
        end
        
        updateHeaderClock()
        spawn(function()
            while headerClock and headerClock.Parent do
                wait(1)
                updateHeaderClock()
            end
        end)
    end

    local buttonSize = isMobile and 36 or 40
    local help = Instance.new("TextButton")
    help.Name = "Help"
    help.Text = "?"
    help.Font = Enum.Font.GothamBold
    help.TextSize = isMobile and 20 or 24
    help.TextColor3 = Color3.fromRGB(50, 50, 70)
    help.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    help.BackgroundTransparency = 0.3
    help.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    help.Position = UDim2.new(1, -(buttonSize * 2 + 8), 0, isMobile and 7 or 12)
    help.ZIndex = 2
    help.Parent = header
    addCorner(help, isMobile and 10 or 12)

    local close = help:Clone()
    close.Name = "Close"
    close.Text = "×"
    close.Position = UDim2.new(1, -buttonSize, 0, isMobile and 7 or 12)
    close.Parent = header

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll"
    scroll.BackgroundTransparency = 1
    scroll.Position = UDim2.new(0, size.padding, 0, size.headerHeight + size.padding * 2)
    scroll.Size = UDim2.new(1, -size.padding*2, 1, -(size.headerHeight + size.padding*4 + (isMobile and 52 or 58)))
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = isMobile and 4 or 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    scroll.ZIndex = 2
    scroll.Parent = contentFrame

    local list = Instance.new("UIListLayout")
    list.Parent = scroll
    list.Padding = UDim.new(0, isMobile and 10 or 12)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    local function addSectionTitle(text)
        local t = Instance.new("TextLabel")
        t.BackgroundTransparency = 1
        t.Size = UDim2.new(1, 0, 0, isMobile and 30 or 36)
        t.TextXAlignment = Enum.TextXAlignment.Center
        t.Text = string.upper(text)
        t.TextColor3 = Color3.fromRGB(100, 100, 120)
        t.Font = Enum.Font.GothamMedium
        t.TextSize = size.fontSize.button
        t.ZIndex = 2
        t.Parent = scroll
        return t
    end

    local toggles = {}
    local function createToggleRow(iconEmoji, iconColor, title)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, size.itemHeight)
        row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        row.BackgroundTransparency = 0.25
        row.ZIndex = 2
        row.Parent = scroll
        addCorner(row, isMobile and 14 or 18)

        local iconSize = isMobile and 40 or 48
        local iconBg = Instance.new("Frame")
        iconBg.Size = UDim2.new(0, iconSize, 0, iconSize)
        iconBg.Position = UDim2.new(0, isMobile and 10 or 14, 0, (size.itemHeight - iconSize) / 2)
        iconBg.BackgroundColor3 = iconColor
        iconBg.BackgroundTransparency = 0.3
        iconBg.ZIndex = 2
        iconBg.Parent = row
        addCorner(iconBg, isMobile and 10 or 12)
        
        addGradient(iconBg, {Color3.fromRGB(255, 255, 255), iconColor}, 135)

        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Text = iconEmoji or "📦"
        icon.TextSize = isMobile and 24 or 28
        icon.Font = Enum.Font.GothamBold
        icon.TextColor3 = Color3.fromRGB(255, 255, 255)
        icon.ZIndex = 3
        icon.Parent = iconBg

        local titleL = Instance.new("TextLabel")
        titleL.BackgroundTransparency = 1
        titleL.Position = UDim2.new(0, iconSize + (isMobile and 18 or 22), 0, 0)
        titleL.Size = UDim2.new(1, -(iconSize + (isMobile and 88 or 110)), 1, 0)
        titleL.Font = Enum.Font.GothamMedium
        titleL.TextSize = size.fontSize.item
        titleL.TextXAlignment = Enum.TextXAlignment.Left
        titleL.TextYAlignment = Enum.TextYAlignment.Center
        titleL.TextColor3 = Color3.fromRGB(30, 30, 40)
        titleL.Text = title
        titleL.TextTruncate = Enum.TextTruncate.AtEnd
        titleL.ZIndex = 2
        titleL.Parent = row

        local switchW = isMobile and 48 or 52
        local switchH = isMobile and 28 or 32
        local switchBg = Instance.new("Frame")
        switchBg.Name = "Switch"
        switchBg.Size = UDim2.new(0, switchW, 0, switchH)
        switchBg.Position = UDim2.new(1, -(switchW + (isMobile and 10 or 14)), 0.5, -switchH/2)
        switchBg.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
        switchBg.ZIndex = 2
        switchBg.Parent = row
        addCorner(switchBg, switchH / 2)

        local knobSize = switchH - 4
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, knobSize, 0, knobSize)
        knob.Position = UDim2.new(0, 2, 0, 2)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.ZIndex = 3
        knob.Parent = switchBg
        addCorner(knob, knobSize / 2)

        local state = false
        local function setState(v)
            state = v and true or false
            if state then
                tween(switchBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(52, 120, 246)})
                tween(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -(knobSize + 2), 0, 2)})
            else
                tween(switchBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(200, 200, 210)})
                tween(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 2, 0, 2)})
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
        scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + (isMobile and 15 or 20))
    end
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)
    refreshCanvas()

    local startBtnH = isMobile and 52 or 58
    local startBtn = Instance.new("TextButton")
    startBtn.Name = "Start"
    startBtn.Size = UDim2.new(1, -size.padding*2, 0, startBtnH)
    startBtn.Position = UDim2.new(0, size.padding, 1, -(startBtnH + size.padding))
    startBtn.Text = "Start load script"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = size.fontSize.button
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 100)
    startBtn.BackgroundTransparency = 0.15
    startBtn.ZIndex = 2
    startBtn.Parent = contentFrame
    addCorner(startBtn, isMobile and 16 or 20)
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
                if gui.Name == "ModernGlassLoader" or gui.Name == "LoadingScreen" or gui.Name == "KeySystem" then
                    gui:Destroy()
                end
            end
            
            for _, gui in ipairs(pg:GetChildren()) do
                if gui.Name == "ModernGlassLoader" or gui.Name == "LoadingScreen" or gui.Name == "KeySystem" then
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

Loader:Init()

return Loader
