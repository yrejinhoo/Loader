
-------------------------------------------------------------
-- VIP LOADER SYSTEM - RULLZSYHUB (FIXED VERSION)
-- Created by RullzsyHUB
-- Enhanced: Mobile Friendly, GitHub VIP List, Modern UI
-------------------------------------------------------------

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local userId = player.UserId

-------------------------------------------------------------
-- CONFIGURATION
-------------------------------------------------------------
local CONFIG = {
    -- VIP Users GitHub URL (raw link to JSON file)
    VIP_URL = "https://raw.githubusercontent.com/RullzsyHUB/vip-users/main/vip.json",
    
    -- Key System
    KEY_URL = "https://raw.githubusercontent.com/RullzsyHUB/keys/main/keys.json",
    KEY_STORAGE_FOLDER = "RullzsyHUB",
    KEY_STORAGE_FILE = "saved_key.json",
    KEY_DURATION = 86400, -- 1 day in seconds (24 hours)
    
    -- Maps Configuration
    MAPS = {
        {
            name = "Mount Yahayuk",
            description = "Auto Walk Script",
            icon = "🏔️",
            url = "https://raw.githubusercontent.com/rebelscodeee-max/Loader-Auto-Walk/refs/heads/main/Loader"
        },
        {
            name = "Map Example 2",
            description = "Coming Soon",
            icon = "🗺️",
            url = ""
        },
        {
            name = "Map Example 3",
            description = "Coming Soon",
            icon = "🌋",
            url = ""
        },
    },
    
    -- UI Colors (Modern Theme)
    COLORS = {
        Primary = Color3.fromRGB(138, 43, 226), -- Purple
        Secondary = Color3.fromRGB(255, 215, 0), -- Gold
        Background = Color3.fromRGB(15, 20, 30),
        CardBg = Color3.fromRGB(25, 30, 40),
        ButtonBg = Color3.fromRGB(35, 40, 50),
        Success = Color3.fromRGB(40, 200, 80),
        Error = Color3.fromRGB(220, 50, 50),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180)
    }
}

-------------------------------------------------------------
-- STORAGE FUNCTIONS
-------------------------------------------------------------
if not isfolder(CONFIG.KEY_STORAGE_FOLDER) then
    makefolder(CONFIG.KEY_STORAGE_FOLDER)
end

local function saveKeyData(key, timestamp)
    local data = {
        key = key,
        timestamp = timestamp,
        userId = userId
    }
    writefile(CONFIG.KEY_STORAGE_FOLDER .. "/" .. CONFIG.KEY_STORAGE_FILE, HttpService:JSONEncode(data))
end

local function loadKeyData()
    local filePath = CONFIG.KEY_STORAGE_FOLDER .. "/" .. CONFIG.KEY_STORAGE_FILE
    if isfile(filePath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(filePath))
        end)
        if success and data then
            return data
        end
    end
    return nil
end

local function deleteKeyData()
    local filePath = CONFIG.KEY_STORAGE_FOLDER .. "/" .. CONFIG.KEY_STORAGE_FILE
    if isfile(filePath) then
        delfile(filePath)
    end
end

-------------------------------------------------------------
-- VIP CHECK FUNCTION (FROM GITHUB)
-------------------------------------------------------------
local function isVIPUser()
    local success, response = pcall(function()
        return game:HttpGet(CONFIG.VIP_URL)
    end)
    
    if not success then
        warn("Failed to fetch VIP list from GitHub")
        return false
    end
    
    local vipData
    success, vipData = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if not success or not vipData then
        warn("Failed to parse VIP data")
        return false
    end
    
    -- Check if user ID is in VIP list
    for _, vipId in ipairs(vipData.vip_users or {}) do
        if userId == vipId then
            return true
        end
    end
    
    return false
end

-------------------------------------------------------------
-- KEY VALIDATION FUNCTION
-------------------------------------------------------------
local function validateKey(inputKey)
    local success, response = pcall(function()
        return game:HttpGet(CONFIG.KEY_URL)
    end)
    
    if not success then
        return false, "Failed to connect to key server"
    end
    
    local validKeys
    success, validKeys = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if not success or not validKeys then
        return false, "Failed to parse keys"
    end
    
    for _, key in ipairs(validKeys.keys or {}) do
        if key == inputKey then
            return true, "Key valid!"
        end
    end
    
    return false, "Invalid key!"
end

local function checkSavedKey()
    local savedData = loadKeyData()
    if not savedData then
        return false, "No saved key"
    end
    
    local currentTime = os.time()
    local timeElapsed = currentTime - savedData.timestamp
    
    if timeElapsed >= CONFIG.KEY_DURATION then
        deleteKeyData()
        return false, "Key expired"
    end
    
    local timeRemaining = CONFIG.KEY_DURATION - timeElapsed
    local hoursRemaining = math.floor(timeRemaining / 3600)
    local minutesRemaining = math.floor((timeRemaining % 3600) / 60)
    
    return true, string.format("Key valid for %dh %dm", hoursRemaining, minutesRemaining)
end

-------------------------------------------------------------
-- NOTIFICATION FUNCTION
-------------------------------------------------------------
local function notify(title, message, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration or 5
    })
end

-------------------------------------------------------------
-- MODERN UI COMPONENTS
-------------------------------------------------------------
local function createGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 2
    stroke.Transparency = 0.3
    stroke.Parent = parent
    return stroke
end

local function addGlowEffect(frame)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Image = "rbxasset://textures/ui/Glow.png"
    glow.ImageColor3 = CONFIG.COLORS.Primary
    glow.ImageTransparency = 0.7
    glow.ZIndex = frame.ZIndex - 1
    glow.Parent = frame
    return glow
end

-------------------------------------------------------------
-- ANIMATED BACKGROUND
-------------------------------------------------------------
local function createAnimatedBackground(parent)
    local ParticleContainer = Instance.new("Frame")
    ParticleContainer.Name = "ParticleContainer"
    ParticleContainer.BackgroundTransparency = 1
    ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
    ParticleContainer.Parent = parent
    
    -- Floating particles with modern glow
    for i = 1, 20 do
        local particle = Instance.new("Frame")
        particle.Name = "Particle" .. i
        particle.BackgroundTransparency = 0.5
        particle.BorderSizePixel = 0
        particle.Size = UDim2.new(0, math.random(10, 25), 0, math.random(10, 25))
        particle.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
        particle.Parent = ParticleContainer
        
        local particleColors = {
            CONFIG.COLORS.Primary,
            CONFIG.COLORS.Secondary,
            Color3.fromRGB(100, 150, 255)
        }
        particle.BackgroundColor3 = particleColors[math.random(1, #particleColors)]
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = particle
        
        addGlowEffect(particle)
        
        -- Smooth floating animation
        task.spawn(function()
            while particle.Parent do
                local randomTime = math.random(4, 8)
                local randomX = math.random(-100, 100)
                local randomY = math.random(-100, 100)
                local randomRotation = math.random(-180, 180)
                
                TweenService:Create(particle, TweenInfo.new(
                    randomTime,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut
                ), {
                    Position = particle.Position + UDim2.new(0, randomX, 0, randomY),
                    Rotation = randomRotation
                }):Play()
                
                task.wait(randomTime)
            end
        end)
    end
end

-------------------------------------------------------------
-- MAIN LOADER GUI (CENTERED & PROFILE ON SIDE)
-------------------------------------------------------------
local function createLoaderGUI()
    -- Remove existing GUI
    if CoreGui:FindFirstChild("RullzsyLoaderGUI") then
        CoreGui:FindFirstChild("RullzsyLoaderGUI"):Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RullzsyLoaderGUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    
    -- Main Background
    local MainBG = Instance.new("Frame")
    MainBG.Name = "MainBG"
    MainBG.BackgroundColor3 = CONFIG.COLORS.Background
    MainBG.BorderSizePixel = 0
    MainBG.Size = UDim2.new(1, 0, 1, 0)
    MainBG.Parent = ScreenGui
    
    -- Animated background
    createAnimatedBackground(MainBG)
    
    -- Mobile detection
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isMobile = screenSize.X < 600
    
    -- Center Container (CENTERED PROPERLY)
    local CenterFrame = Instance.new("Frame")
    CenterFrame.Name = "CenterFrame"
    CenterFrame.BackgroundTransparency = 1
    CenterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    CenterFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    if isMobile then
        CenterFrame.Size = UDim2.new(0.95, 0, 0, 450)
    else
        CenterFrame.Size = UDim2.new(0, 500, 0, 400)
    end
    
    CenterFrame.Parent = MainBG
    
    -- Close Button (Top Right)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.BackgroundColor3 = CONFIG.COLORS.Error
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AnchorPoint = Vector2.new(1, 0)
    CloseBtn.Position = UDim2.new(1, 0, 0, 0)
    CloseBtn.Size = UDim2.new(0, 45, 0, 45)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = CONFIG.COLORS.TextPrimary
    CloseBtn.TextSize = 22
    CloseBtn.Parent = CenterFrame
    
    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 12)
    CloseBtnCorner.Parent = CloseBtn
    
    addGlowEffect(CloseBtn)
    
    -- Close button animation
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 50, 0, 50),
            Rotation = 90
        }):Play()
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 45, 0, 45),
            Rotation = 0
        }):Play()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(CenterFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        task.wait(0.5)
        ScreenGui:Destroy()
        notify("Closed", "Loader closed successfully", 3)
    end)
    
    -- Left Side: Profile Card
    local ProfileCard = Instance.new("Frame")
    ProfileCard.Name = "ProfileCard"
    ProfileCard.BackgroundColor3 = CONFIG.COLORS.CardBg
    ProfileCard.BorderSizePixel = 0
    ProfileCard.Position = UDim2.new(0, 0, 0, 0)
    
    if isMobile then
        ProfileCard.Size = UDim2.new(1, 0, 0, 140)
    else
        ProfileCard.Size = UDim2.new(0, 180, 1, 0)
    end
    
    ProfileCard.Parent = CenterFrame
    
    local ProfileCardCorner = Instance.new("UICorner")
    ProfileCardCorner.CornerRadius = UDim.new(0, 20)
    ProfileCardCorner.Parent = ProfileCard
    
    createStroke(ProfileCard, CONFIG.COLORS.Primary, 2)
    
    -- Avatar Frame (Inside Profile Card)
    local AvatarFrame = Instance.new("Frame")
    AvatarFrame.Name = "AvatarFrame"
    AvatarFrame.BackgroundColor3 = CONFIG.COLORS.ButtonBg
    AvatarFrame.BorderSizePixel = 0
    AvatarFrame.AnchorPoint = Vector2.new(0.5, 0)
    
    if isMobile then
        AvatarFrame.Position = UDim2.new(0.5, 0, 0, 15)
        AvatarFrame.Size = UDim2.new(0, 80, 0, 80)
    else
        AvatarFrame.Position = UDim2.new(0.5, 0, 0, 30)
        AvatarFrame.Size = UDim2.new(0, 120, 0, 120)
    end
    
    AvatarFrame.Parent = ProfileCard
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0.3, 0)
    AvatarCorner.Parent = AvatarFrame
    
    createStroke(AvatarFrame, CONFIG.COLORS.Primary, 3)
    createGradient(AvatarFrame, {
        CONFIG.COLORS.Primary,
        CONFIG.COLORS.Secondary
    }, 45)
    
    addGlowEffect(AvatarFrame)
    
    -- Avatar Image
    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.BackgroundTransparency = 1
    Avatar.Size = UDim2.new(1, -10, 1, -10)
    Avatar.Position = UDim2.new(0, 5, 0, 5)
    Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
    Avatar.Parent = AvatarFrame
    
    local AvatarImgCorner = Instance.new("UICorner")
    AvatarImgCorner.CornerRadius = UDim.new(0.25, 0)
    AvatarImgCorner.Parent = Avatar
    
    -- Rotate animation for avatar frame border
    task.spawn(function()
        while AvatarFrame.Parent do
            TweenService:Create(AvatarFrame:FindFirstChildOfClass("UIGradient"), TweenInfo.new(3, Enum.EasingStyle.Linear), {
                Rotation = 360
            }):Play()
            task.wait(3)
            AvatarFrame:FindFirstChildOfClass("UIGradient").Rotation = 0
        end
    end)
    
    -- Username Text
    local UsernameText = Instance.new("TextLabel")
    UsernameText.Name = "UsernameText"
    UsernameText.BackgroundTransparency = 1
    
    if isMobile then
        UsernameText.Position = UDim2.new(0, 0, 0, 100)
        UsernameText.Size = UDim2.new(1, 0, 0, 30)
        UsernameText.TextSize = 14
    else
        UsernameText.Position = UDim2.new(0, 0, 0, 160)
        UsernameText.Size = UDim2.new(1, 0, 0, 40)
        UsernameText.TextSize = 16
    end
    
    UsernameText.Font = Enum.Font.GothamBold
    UsernameText.Text = "@" .. player.Name
    UsernameText.TextColor3 = CONFIG.COLORS.TextPrimary
    UsernameText.TextWrapped = true
    UsernameText.Parent = ProfileCard
    
    -- Status Badge
    local StatusBadge = Instance.new("Frame")
    StatusBadge.Name = "StatusBadge"
    StatusBadge.BackgroundColor3 = CONFIG.COLORS.Success
    StatusBadge.BorderSizePixel = 0
    
    if isMobile then
        StatusBadge.Position = UDim2.new(0.5, 30, 0, 75)
    else
        StatusBadge.Position = UDim2.new(0.5, 45, 0, 120)
    end
    
    StatusBadge.Size = UDim2.new(0, 12, 0, 12)
    StatusBadge.Parent = ProfileCard
    
    local StatusBadgeCorner = Instance.new("UICorner")
    StatusBadgeCorner.CornerRadius = UDim.new(1, 0)
    StatusBadgeCorner.Parent = StatusBadge
    
    -- Pulse animation for status badge
    task.spawn(function()
        while StatusBadge.Parent do
            TweenService:Create(StatusBadge, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 15, 0, 15),
                BackgroundTransparency = 0.3
            }):Play()
            task.wait(1)
            TweenService:Create(StatusBadge, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 12, 0, 12),
                BackgroundTransparency = 0
            }):Play()
            task.wait(1)
        end
    end)
    
    -- Right Side: Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.BackgroundTransparency = 1
    
    if isMobile then
        ContentFrame.Position = UDim2.new(0, 0, 0, 150)
        ContentFrame.Size = UDim2.new(1, 0, 1, -150)
    else
        ContentFrame.Position = UDim2.new(0, 190, 0, 0)
        ContentFrame.Size = UDim2.new(1, -190, 1, 0)
    end
    
    ContentFrame.Parent = CenterFrame
    
    -- Welcome Text (In Content Area)
    local WelcomeText = Instance.new("TextLabel")
    WelcomeText.Name = "WelcomeText"
    WelcomeText.BackgroundTransparency = 1
    WelcomeText.Position = UDim2.new(0, 0, 0, 10)
    WelcomeText.Size = UDim2.new(1, 0, 0, 40)
    WelcomeText.Font = Enum.Font.GothamBold
    WelcomeText.Text = "WELCOME"
    WelcomeText.TextColor3 = CONFIG.COLORS.TextPrimary
    WelcomeText.TextSize = isMobile and 20 or 24
    WelcomeText.Parent = ContentFrame
    
    createGradient(WelcomeText, {
        CONFIG.COLORS.Primary,
        CONFIG.COLORS.Secondary,
        CONFIG.COLORS.Primary
    }, 0)
    
    -- Entry animation
    CenterFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(CenterFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = isMobile and UDim2.new(0.95, 0, 0, 450) or UDim2.new(0, 500, 0, 400)
    }):Play()
    
    return ScreenGui, ContentFrame, WelcomeText, isMobile, CenterFrame
end

-------------------------------------------------------------
-- KEY SYSTEM GUI
-------------------------------------------------------------
local function createKeySystemGUI(contentFrame, isMobile)
    -- Key Input Frame
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = "KeyFrame"
    KeyFrame.BackgroundColor3 = CONFIG.COLORS.CardBg
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Position = UDim2.new(0, 0, 0, 60)
    KeyFrame.Size = UDim2.new(1, 0, 0, 200)
    KeyFrame.Parent = contentFrame
    
    local KeyFrameCorner = Instance.new("UICorner")
    KeyFrameCorner.CornerRadius = UDim.new(0, 20)
    KeyFrameCorner.Parent = KeyFrame
    
    createStroke(KeyFrame, CONFIG.COLORS.Primary, 2)
    
    -- Key Title
    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.Position = UDim2.new(0, 0, 0, 15)
    KeyTitle.Size = UDim2.new(1, 0, 0, 25)
    KeyTitle.Font = Enum.Font.GothamBold
    KeyTitle.Text = "🔑 Enter Access Key"
    KeyTitle.TextColor3 = CONFIG.COLORS.TextPrimary
    KeyTitle.TextSize = isMobile and 16 or 18
    KeyTitle.Parent = KeyFrame
    
    -- Key Input Box
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.BackgroundColor3 = CONFIG.COLORS.ButtonBg
    KeyInput.BorderSizePixel = 0
    KeyInput.Position = UDim2.new(0.05, 0, 0, 50)
    KeyInput.Size = UDim2.new(0.9, 0, 0, 40)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.PlaceholderText = "Paste your key here..."
    KeyInput.PlaceholderColor3 = CONFIG.COLORS.TextSecondary
    KeyInput.Text = ""
    KeyInput.TextColor3 = CONFIG.COLORS.TextPrimary
    KeyInput.TextSize = isMobile and 13 or 15
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = KeyFrame
    
    local KeyInputCorner = Instance.new("UICorner")
    KeyInputCorner.CornerRadius = UDim.new(0, 10)
    KeyInputCorner.Parent = KeyInput
    
    createStroke(KeyInput, CONFIG.COLORS.Primary, 1)
    
    -- Focus animation
    KeyInput.Focused:Connect(function()
        TweenService:Create(KeyInput:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.3), {
            Thickness = 3,
            Transparency = 0
        }):Play()
    end)
    
    KeyInput.FocusLost:Connect(function()
        TweenService:Create(KeyInput:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.3), {
            Thickness = 1,
            Transparency = 0.3
        }):Play()
    end)
    
    -- Submit Button
    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Name = "SubmitBtn"
    SubmitBtn.BackgroundColor3 = CONFIG.COLORS.Success
    SubmitBtn.BorderSizePixel = 0
    SubmitBtn.Position = UDim2.new(0.05, 0, 0, 100)
    SubmitBtn.Size = UDim2.new(0.9, 0, 0, 40)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Text = "✓ SUBMIT KEY"
    SubmitBtn.TextColor3 = CONFIG.COLORS.TextPrimary
    SubmitBtn.TextSize = isMobile and 14 or 16
    SubmitBtn.Parent = KeyFrame
    
    local SubmitBtnCorner = Instance.new("UICorner")
    SubmitBtnCorner.CornerRadius = UDim.new(0, 10)
    SubmitBtnCorner.Parent = SubmitBtn
    
    createGradient(SubmitBtn, {
        Color3.fromRGB(40, 200, 80),
        Color3.fromRGB(60, 220, 100)
    }, 90)
    
    addGlowEffect(SubmitBtn)
    
    -- Get Key Button
    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Name = "GetKeyBtn"
    GetKeyBtn.BackgroundColor3 = CONFIG.COLORS.Primary
    GetKeyBtn.BorderSizePixel = 0
    GetKeyBtn.Position = UDim2.new(0.05, 0, 0, 150)
    GetKeyBtn.Size = UDim2.new(0.9, 0, 0, 35)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Text = "🔗 GET KEY FROM DISCORD"
    GetKeyBtn.TextColor3 = CONFIG.COLORS.TextPrimary
    GetKeyBtn.TextSize = isMobile and 12 or 14
    GetKeyBtn.Parent = KeyFrame
    
    local GetKeyBtnCorner = Instance.new("UICorner")
    GetKeyBtnCorner.CornerRadius = UDim.new(0, 10)
    GetKeyBtnCorner.Parent = GetKeyBtn
    
    createGradient(GetKeyBtn, {
        CONFIG.COLORS.Primary,
        Color3.fromRGB(100, 50, 200)
    }, 90)
    
    -- Button hover animations
    local function addButtonAnimation(btn)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = btn.Size + UDim2.new(0, 0, 0, 5)
            }):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = btn.Size - UDim2.new(0, 0, 0, 5)
            }):Play()
        end)
    end
    
    addButtonAnimation(SubmitBtn)
    addButtonAnimation(GetKeyBtn)
    
    return KeyInput, SubmitBtn, GetKeyBtn
end

-------------------------------------------------------------
-- MAP SELECTION GUI
-------------------------------------------------------------
local function createMapSelectionGUI(contentFrame, isMobile)
    -- Clear previous content except WelcomeText
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child.Name ~= "WelcomeText" then
            child:Destroy()
        end
    end
    
    -- Maps Container
    local MapsScrollFrame = Instance.new("ScrollingFrame")
    MapsScrollFrame.Name = "MapsScrollFrame"
    MapsScrollFrame.BackgroundColor3 = CONFIG.COLORS.CardBg
    MapsScrollFrame.BorderSizePixel = 0
    MapsScrollFrame.Position = UDim2.new(0, 0, 0, 60)
    MapsScrollFrame.Size = UDim2.new(1, 0, 1, -70)
    MapsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #CONFIG.MAPS * 85)
    MapsScrollFrame.ScrollBarThickness = 4
    MapsScrollFrame.ScrollBarImageColor3 = CONFIG.COLORS.Primary
    MapsScrollFrame.Parent = contentFrame
    
    local MapsCorner = Instance.new("UICorner")
    MapsCorner.CornerRadius = UDim.new(0, 20)
    MapsCorner.Parent = MapsScrollFrame
    
    createStroke(MapsScrollFrame, CONFIG.COLORS.Primary, 2)
    
    local MapsList = Instance.new("UIListLayout")
    MapsList.SortOrder = Enum.SortOrder.LayoutOrder
    MapsList.Padding = UDim.new(0, 10)
    MapsList.Parent = MapsScrollFrame
    
    local MapsPadding = Instance.new("UIPadding")    
    MapsPadding.PaddingTop = UDim.new(0, 10)
    MapsPadding.PaddingBottom = UDim.new(0, 10)
    MapsPadding.PaddingLeft = UDim.new(0, 10)
    MapsPadding.PaddingRight = UDim.new(0, 10)
    MapsPadding.Parent = MapsScrollFrame
    
    -- Create map buttons
    for i, map in ipairs(CONFIG.MAPS) do
        local MapBtn = Instance.new("TextButton")
        MapBtn.Name = "MapBtn" .. i
        MapBtn.BackgroundColor3 = CONFIG.COLORS.ButtonBg
        MapBtn.BorderSizePixel = 0
        MapBtn.Size = UDim2.new(1, -20, 0, 65)
        MapBtn.Font = Enum.Font.GothamBold
        MapBtn.Text = ""
        MapBtn.TextColor3 = CONFIG.COLORS.TextPrimary
        MapBtn.TextSize = isMobile and 14 or 16
        MapBtn.Parent = MapsScrollFrame
        
        local MapBtnCorner = Instance.new("UICorner")
        MapBtnCorner.CornerRadius = UDim.new(0, 12)
        MapBtnCorner.Parent = MapBtn
        
        createStroke(MapBtn, CONFIG.COLORS.Primary, 2)
        createGradient(MapBtn, {
            CONFIG.COLORS.ButtonBg,
            Color3.fromRGB(45, 50, 65)
        }, 45)
        
        -- Icon Container
        local IconFrame = Instance.new("Frame")
        IconFrame.BackgroundColor3 = CONFIG.COLORS.Primary
        IconFrame.BorderSizePixel = 0
        IconFrame.Position = UDim2.new(0, 8, 0.5, 0)
        IconFrame.AnchorPoint = Vector2.new(0, 0.5)
        IconFrame.Size = UDim2.new(0, 45, 0, 45)
        IconFrame.Parent = MapBtn
        
        local IconFrameCorner = Instance.new("UICorner")
        IconFrameCorner.CornerRadius = UDim.new(0, 10)
        IconFrameCorner.Parent = IconFrame
        
        addGlowEffect(IconFrame)
        
        -- Icon
        local Icon = Instance.new("TextLabel")
        Icon.BackgroundTransparency = 1
        Icon.Size = UDim2.new(1, 0, 1, 0)
        Icon.Font = Enum.Font.GothamBold
        Icon.Text = map.icon
        Icon.TextSize = 24
        Icon.Parent = IconFrame
        
        -- Map Name
        local MapName = Instance.new("TextLabel")
        MapName.BackgroundTransparency = 1
        MapName.Position = UDim2.new(0, 60, 0, 8)
        MapName.Size = UDim2.new(1, -70, 0, 22)
        MapName.Font = Enum.Font.GothamBold
        MapName.Text = map.name
        MapName.TextColor3 = CONFIG.COLORS.TextPrimary
        MapName.TextSize = isMobile and 13 or 15
        MapName.TextXAlignment = Enum.TextXAlignment.Left
        MapName.Parent = MapBtn
        
        -- Description
        local Desc = Instance.new("TextLabel")
        Desc.BackgroundTransparency = 1
        Desc.Position = UDim2.new(0, 60, 0, 32)
        Desc.Size = UDim2.new(1, -70, 0, 20)
        Desc.Font = Enum.Font.Gotham
        Desc.Text = map.description
        Desc.TextColor3 = CONFIG.COLORS.TextSecondary
        Desc.TextSize = isMobile and 11 or 12
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        Desc.Parent = MapBtn
        
        -- Status Badge
        local StatusBadge = Instance.new("Frame")
        StatusBadge.BackgroundColor3 = map.url == "" and CONFIG.COLORS.Error or CONFIG.COLORS.Success
        StatusBadge.BorderSizePixel = 0
        StatusBadge.AnchorPoint = Vector2.new(1, 0)
        StatusBadge.Position = UDim2.new(1, -8, 0, 8)
        StatusBadge.Size = UDim2.new(0, 8, 0, 8)
        StatusBadge.Parent = MapBtn
        
        local StatusBadgeCorner = Instance.new("UICorner")
        StatusBadgeCorner.CornerRadius = UDim.new(1, 0)
        StatusBadgeCorner.Parent = StatusBadge
        
        -- Button functionality
        MapBtn.MouseButton1Click:Connect(function()
            if map.url == "" then
                notify("Coming Soon", map.name .. " is not available yet! 🚧", 3)
                
                -- Shake animation
                local originalPos = MapBtn.Position
                for j = 1, 2 do
                    TweenService:Create(MapBtn, TweenInfo.new(0.1), {Position = originalPos + UDim2.new(0, 5, 0, 0)}):Play()
                    task.wait(0.1)
                    TweenService:Create(MapBtn, TweenInfo.new(0.1), {Position = originalPos - UDim2.new(0, 5, 0, 0)}):Play()
                    task.wait(0.1)
                end
                TweenService:Create(MapBtn, TweenInfo.new(0.1), {Position = originalPos}):Play()
            else
                notify("Loading...", "Loading " .. map.name .. "... ⏳", 3)
                
                -- Loading animation
                local originalText = MapName.Text
                MapName.Text = "Loading..."
                
                task.spawn(function()
                    for j = 1, 3 do
                        MapName.Text = "Loading" .. string.rep(".", j)
                        task.wait(0.3)
                    end
                end)
                
                task.wait(0.5)
                
                local success, err = pcall(function()
                    loadstring(game:HttpGet(map.url))()
                end)
                
                if success then
                    notify("Success! ✓", map.name .. " loaded successfully!", 5)
                    
                    -- Success animation
                    TweenService:Create(MapBtn, TweenInfo.new(0.3), {
                        BackgroundColor3 = CONFIG.COLORS.Success
                    }):Play()
                    
                    task.wait(1)
                    
                    -- Close GUI
                    local mainGui = MapBtn:FindFirstAncestorOfClass("ScreenGui")
                    if mainGui then
                        local centerFrame = mainGui.MainBG.CenterFrame
                        TweenService:Create(centerFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                            Size = UDim2.new(0, 0, 0, 0)
                        }):Play()
                        
                        task.wait(0.5)
                        mainGui:Destroy()
                    end
                else
                    notify("Error! ✕", "Failed to load " .. map.name, 5)
                    MapName.Text = originalText
                    
                    -- Error animation
                    TweenService:Create(MapBtn, TweenInfo.new(0.3), {
                        BackgroundColor3 = CONFIG.COLORS.Error
                    }):Play()
                    
                    task.wait(1)
                    
                    TweenService:Create(MapBtn, TweenInfo.new(0.3), {
                        BackgroundColor3 = CONFIG.COLORS.ButtonBg
                    }):Play()
                end
            end
        end)
        
        -- Modern hover effect
        MapBtn.MouseEnter:Connect(function()
            TweenService:Create(MapBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(1, -16, 0, 70)
            }):Play()
            
            TweenService:Create(MapBtn:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.3), {
                Thickness = 3,
                Transparency = 0
            }):Play()
            
            if MapBtn:FindFirstChild("IconFrame") then
                TweenService:Create(MapBtn.IconFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                    Rotation = 15,
                    Size = UDim2.new(0, 50, 0, 50)
                }):Play()
            end
        end)
        
        MapBtn.MouseLeave:Connect(function()
            TweenService:Create(MapBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(1, -20, 0, 65)
            }):Play()
            
            TweenService:Create(MapBtn:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.3), {
                Thickness = 2,
                Transparency = 0.3
            }):Play()
            
            if MapBtn:FindFirstChild("IconFrame") then
                TweenService:Create(MapBtn.IconFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                    Rotation = 0,
                    Size = UDim2.new(0, 45, 0, 45)
                }):Play()
            end
        end)
        
        -- Entry animation (staggered)
        MapBtn.Size = UDim2.new(0, 0, 0, 65)
        MapBtn.BackgroundTransparency = 1
        
        task.wait(i * 0.1)
        
        TweenService:Create(MapBtn, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -20, 0, 65),
            BackgroundTransparency = 0
        }):Play()
    end
end

-------------------------------------------------------------
-- MAIN LOADER LOGIC
-------------------------------------------------------------
local function startLoader()
    notify("RullzsyHUB", "Initializing loader... 🚀", 3)
    
    local ScreenGui, ContentFrame, WelcomeText, isMobile, CenterFrame = createLoaderGUI()
    
    -- Check VIP status from GitHub
    task.wait(1)
    
    local isVIP = isVIPUser()
    
    if isVIP then
        notify("VIP Access! 👑", "Welcome back, " .. player.Name .. "!", 5)
        WelcomeText.Text = "VIP ACCESS GRANTED"
        
        -- VIP gradient animation
        local gradient = createGradient(WelcomeText, {
            Color3.fromRGB(255, 215, 0),
            Color3.fromRGB(255, 165, 0),
            Color3.fromRGB(255, 215, 0)
        }, 0)
        
        -- Animate gradient rotation
        task.spawn(function()
            while gradient.Parent do
                TweenService:Create(gradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {
                    Rotation = 360
                }):Play()
                task.wait(2)
                gradient.Rotation = 0
            end
        end)
        
        task.wait(2)
        createMapSelectionGUI(ContentFrame, isMobile)
    else
        -- Check for saved key first
        local hasValidKey, message = checkSavedKey()
        
        if hasValidKey then
            notify("Key Valid ✓", message, 5)
            WelcomeText.Text = "ACCESS GRANTED"
            
            local gradient = createGradient(WelcomeText, {
                Color3.fromRGB(40, 200, 80),
                Color3.fromRGB(60, 220, 100)
            }, 0)
            
            task.wait(2)
            createMapSelectionGUI(ContentFrame, isMobile)
        else
            -- Show key system
            WelcomeText.Text = "KEY REQUIRED"
            
            local gradient = createGradient(WelcomeText, {
                CONFIG.COLORS.Error,
                Color3.fromRGB(255, 100, 100)
            }, 0)
            
            local KeyInput, SubmitBtn, GetKeyBtn = createKeySystemGUI(ContentFrame, isMobile)
            
            -- Submit button logic
            SubmitBtn.MouseButton1Click:Connect(function()
                local inputKey = KeyInput.Text
                
                if inputKey == "" then
                    notify("Error! ✕", "Please enter a key!", 3)
                    
                    -- Shake animation for input
                    local originalPos = KeyInput.Position
                    for j = 1, 2 do
                        TweenService:Create(KeyInput, TweenInfo.new(0.1), {Position = originalPos + UDim2.new(0, 5, 0, 0)}):Play()
                        task.wait(0.1)
                        TweenService:Create(KeyInput, TweenInfo.new(0.1), {Position = originalPos - UDim2.new(0, 5, 0, 0)}):Play()
                        task.wait(0.1)
                    end
                    TweenService:Create(KeyInput, TweenInfo.new(0.1), {Position = originalPos}):Play()
                    return
                end
                
                -- Loading state
                SubmitBtn.Text = "⏳ VALIDATING..."
                SubmitBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                
                -- Disable button
                SubmitBtn.Active = false
                
                -- Rotate animation while validating
                task.spawn(function()
                    local rotation = 0
                    while SubmitBtn.Text == "⏳ VALIDATING..." do
                        rotation = rotation + 10
                        SubmitBtn.Rotation = rotation
                        task.wait(0.05)
                    end
                    SubmitBtn.Rotation = 0
                end)
                
                task.wait(1)
                
                local valid, msg = validateKey(inputKey)
                
                if valid then
                    saveKeyData(inputKey, os.time())
                    notify("Success! ✓", "Key validated! Access granted for 24 hours. 🎉", 5)
                    
                    SubmitBtn.Text = "✓ SUCCESS!"
                    SubmitBtn.BackgroundColor3 = CONFIG.COLORS.Success
                    
                    -- Success animation
                    TweenService:Create(SubmitBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                        Size = SubmitBtn.Size + UDim2.new(0, 0, 0, 8)
                    }):Play()
                    
                    task.wait(1)
                    
                    -- Transition to maps
                    createMapSelectionGUI(ContentFrame, isMobile)
                else
                    notify("Error! ✕", msg, 5)
                    
                    SubmitBtn.Text = "✕ INVALID KEY"
                    SubmitBtn.BackgroundColor3 = CONFIG.COLORS.Error
                    
                    -- Error shake
                    local originalPos = SubmitBtn.Position
                    for j = 1, 3 do
                        TweenService:Create(SubmitBtn, TweenInfo.new(0.1), {Position = originalPos + UDim2.new(0, 5, 0, 0)}):Play()
                        task.wait(0.1)
                        TweenService:Create(SubmitBtn, TweenInfo.new(0.1), {Position = originalPos - UDim2.new(0, 5, 0, 0)}):Play()
                        task.wait(0.1)
                    end
                    TweenService:Create(SubmitBtn, TweenInfo.new(0.1), {Position = originalPos}):Play()
                    
                    task.wait(2)
                    
                    -- Reset button
                    SubmitBtn.Text = "✓ SUBMIT KEY"
                    SubmitBtn.BackgroundColor3 = CONFIG.COLORS.Success
                    SubmitBtn.Active = true
                end
            end)
            
            -- Get key button logic
            GetKeyBtn.MouseButton1Click:Connect(function()
                local discordLink = "https://discord.gg/rullzsyhub"
                
                if setclipboard then
                    setclipboard(discordLink)
                    notify("Copied! 📋", "Discord link copied to clipboard!", 5)
                    
                    -- Flash animation
                    local originalColor = GetKeyBtn.BackgroundColor3
                    TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(100, 255, 100)
                    }):Play()
                    
                    task.wait(0.5)
                    
                    TweenService:Create(GetKeyBtn, TweenInfo.new(0.3), {
                        BackgroundColor3 = originalColor
                    }):Play()
                else
                    notify("Get Key 🔗", "Join Discord: discord.gg/rullzsyhub", 5)
                end
            end)
        end
    end
end

-------------------------------------------------------------
-- START LOADER WITH ERROR HANDLING
-------------------------------------------------------------
local success, err = pcall(startLoader)

if not success then
    warn("Loader Error: " .. tostring(err))
    notify("Error!", "Failed to load RullzsyHUB Loader: " .. tostring(err), 10)
end

-------------------------------------------------------------
-- RETURN MODULE
-------------------------------------------------------------
return {
    isVIP = isVIPUser,
    validateKey = validateKey,
    checkSavedKey = checkSavedKey,
    config = CONFIG
}
