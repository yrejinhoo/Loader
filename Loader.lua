-- VIP Loader System with Auto Detection
-- Created with modern UI design

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local userId = LocalPlayer.UserId

-- GitHub URLs
local GITHUB_VIP_URL = "https://raw.githubusercontent.com/yrejinhoo/Loader/refs/heads/main/vip.txt"
local GITHUB_KEY_URL = "https://raw.githubusercontent.com/yrejinhoo/Loader/refs/heads/main/key.txt"

-- Map Scripts
local MAP_SCRIPTS = {
    Arunika = "https://raw.githubusercontent.com/yrejinhoo/AstrionHUB/refs/heads/main/arunika.lua",
    Yahayuk = "https://raw.githubusercontent.com/yrejinhoo/AstrionHUB/refs/heads/main/main.lua"
}

-- Detect device type
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Fetch Keys from GitHub
local function fetchKeys()
    local success, response = pcall(function()
        return game:HttpGet(GITHUB_KEY_URL)
    end)
    
    if success then
        local keys = {}
        for line in response:gmatch("[^\r\n]+") do
            local key = line:match("^%s*(.-)%s*$")
            if key ~= "" then
                keys[key] = true
            end
        end
        return keys
    end
    return {}
end

-- Fetch VIP User IDs from GitHub
local function fetchVIPIds()
    local success, response = pcall(function()
        return game:HttpGet(GITHUB_VIP_URL)
    end)
    
    if success then
        local vipIds = {}
        for line in response:gmatch("[^\r\n]+") do
            local id = line:match("^%s*(.-)%s*$")
            if id ~= "" and tonumber(id) then
                table.insert(vipIds, tonumber(id))
            end
        end
        return vipIds
    end
    return {}
end

-- Check if User is VIP
local function isUserVIP(userId, vipIds)
    for _, vipId in ipairs(vipIds) do
        if userId == vipId then
            return true
        end
    end
    return false
end

-- Create ScreenGui
local function createLoader(isVIP, playerName)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VIPLoader"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    
    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Overlay Background
    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.Position = UDim2.new(0, 0, 0, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.3
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 1
    Overlay.Parent = ScreenGui

    -- Blur effect
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 10
    BlurEffect.Parent = game.Lighting

    -- Calculate size based on device
    local frameWidth = isMobile() and 350 or 600
    local frameHeight = isMobile() and math.floor(frameWidth / 16 * 9) or math.floor(600 / 16 * 9)

    -- Main Frame (16:9 aspect ratio)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 45)
    MainFrame.BorderSizePixel = 0
    MainFrame.ZIndex = 2
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 215, 0)
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0.7
    MainStroke.Parent = MainFrame

    -- Left Panel (Avatar & Info)
    local LeftPanel = Instance.new("Frame")
    LeftPanel.Name = "LeftPanel"
    LeftPanel.Size = UDim2.new(0.35, 0, 1, 0)
    LeftPanel.Position = UDim2.new(0, 0, 0, 0)
    LeftPanel.BackgroundColor3 = Color3.fromRGB(10, 15, 35)
    LeftPanel.BorderSizePixel = 0
    LeftPanel.Parent = MainFrame

    local LeftCorner = Instance.new("UICorner")
    LeftCorner.CornerRadius = UDim.new(0, 15)
    LeftCorner.Parent = LeftPanel

    -- Avatar Frame
    local AvatarFrame = Instance.new("Frame")
    AvatarFrame.Name = "AvatarFrame"
    AvatarFrame.Size = UDim2.new(0, isMobile() and 80 or 120, 0, isMobile() and 80 or 120)
    AvatarFrame.Position = UDim2.new(0.5, 0, 0, isMobile() and 25 or 40)
    AvatarFrame.AnchorPoint = Vector2.new(0.5, 0)
    AvatarFrame.BackgroundColor3 = Color3.fromRGB(93, 173, 226)
    AvatarFrame.BorderSizePixel = 0
    AvatarFrame.Parent = LeftPanel

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0.25, 0)
    AvatarCorner.Parent = AvatarFrame

    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Color = Color3.fromRGB(255, 215, 0)
    AvatarStroke.Thickness = 3
    AvatarStroke.Parent = AvatarFrame

    -- Avatar Image
    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.BackgroundTransparency = 1
    Avatar.Size = UDim2.new(1, -6, 1, -6)
    Avatar.Position = UDim2.new(0, 3, 0, 3)
    Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
    Avatar.Parent = AvatarFrame

    local AvatarImgCorner = Instance.new("UICorner")
    AvatarImgCorner.CornerRadius = UDim.new(0.25, 0)
    AvatarImgCorner.Parent = Avatar

    -- Username (Roblox Username)
    local Username = Instance.new("TextLabel")
    Username.Name = "Username"
    Username.Size = UDim2.new(1, -20, 0, isMobile() and 25 or 30)
    Username.Position = UDim2.new(0.5, 0, 0, isMobile() and 115 or 175)
    Username.AnchorPoint = Vector2.new(0.5, 0)
    Username.BackgroundTransparency = 1
    Username.Text = "@" .. playerName
    Username.TextColor3 = Color3.fromRGB(255, 255, 255)
    Username.TextSize = isMobile() and 12 or 16
    Username.Font = Enum.Font.GothamBold
    Username.TextWrapped = true
    Username.Parent = LeftPanel

    -- Display Name
    local DisplayName = Instance.new("TextLabel")
    DisplayName.Name = "DisplayName"
    DisplayName.Size = UDim2.new(1, -20, 0, isMobile() and 20 or 25)
    DisplayName.Position = UDim2.new(0.5, 0, 0, isMobile() and 140 or 205)
    DisplayName.AnchorPoint = Vector2.new(0.5, 0)
    DisplayName.BackgroundTransparency = 1
    DisplayName.Text = LocalPlayer.DisplayName
    DisplayName.TextColor3 = Color3.fromRGB(160, 174, 192)
    DisplayName.TextSize = isMobile() and 10 or 14
    DisplayName.Font = Enum.Font.Gotham
    DisplayName.TextWrapped = true
    DisplayName.Parent = LeftPanel

    -- Right Panel (Auth & Maps)
    local RightPanel = Instance.new("Frame")
    RightPanel.Name = "RightPanel"
    RightPanel.Size = UDim2.new(0.65, 0, 1, 0)
    RightPanel.Position = UDim2.new(0.35, 0, 0, 0)
    RightPanel.BackgroundTransparency = 1
    RightPanel.BorderSizePixel = 0
    RightPanel.Parent = MainFrame

    -- Welcome Text
    local WelcomeText = Instance.new("TextLabel")
    WelcomeText.Name = "WelcomeText"
    WelcomeText.Size = UDim2.new(1, -40, 0, isMobile() and 30 or 40)
    WelcomeText.Position = UDim2.new(0.5, 0, 0, isMobile() and 15 or 25)
    WelcomeText.AnchorPoint = Vector2.new(0.5, 0)
    WelcomeText.BackgroundTransparency = 1
    WelcomeText.Text = isVIP and "WELCOME VIP" or "WELCOME FREE"
    WelcomeText.TextColor3 = Color3.fromRGB(255, 215, 0)
    WelcomeText.TextSize = isMobile() and 20 or 28
    WelcomeText.Font = Enum.Font.GothamBold
    WelcomeText.Parent = RightPanel

    local WelcomeGlow = Instance.new("UIStroke")
    WelcomeGlow.Color = Color3.fromRGB(255, 215, 0)
    WelcomeGlow.Thickness = 1
    WelcomeGlow.Transparency = 0.5
    WelcomeGlow.Parent = WelcomeText

    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -40, 0, isMobile() and 15 or 20)
    Subtitle.Position = UDim2.new(0.5, 0, 0, isMobile() and 45 or 65)
    Subtitle.AnchorPoint = Vector2.new(0.5, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Premium Access System"
    Subtitle.TextColor3 = Color3.fromRGB(160, 174, 192)
    Subtitle.TextSize = isMobile() and 9 or 12
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Parent = RightPanel

    -- Auth Container (Only for FREE users)
    local AuthContainer = Instance.new("Frame")
    AuthContainer.Name = "AuthContainer"
    AuthContainer.Size = UDim2.new(1, -40, 0, isMobile() and 170 or 220)
    AuthContainer.Position = UDim2.new(0.5, 0, 0, isMobile() and 75 or 100)
    AuthContainer.AnchorPoint = Vector2.new(0.5, 0)
    AuthContainer.BackgroundTransparency = 1
    AuthContainer.Visible = not isVIP
    AuthContainer.Parent = RightPanel

    -- Key Input Label
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Size = UDim2.new(1, 0, 0, isMobile() and 15 or 20)
    KeyLabel.Position = UDim2.new(0, 0, 0, 0)
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Text = "🔑 Enter Your Key"
    KeyLabel.TextColor3 = Color3.fromRGB(203, 213, 224)
    KeyLabel.TextSize = isMobile() and 10 or 12
    KeyLabel.Font = Enum.Font.Gotham
    KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeyLabel.Parent = AuthContainer

    -- Key Input Box
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.Size = UDim2.new(1, 0, 0, isMobile() and 35 or 45)
    KeyInput.Position = UDim2.new(0, 0, 0, isMobile() and 20 or 25)
    KeyInput.BackgroundColor3 = Color3.fromRGB(26, 32, 58)
    KeyInput.BorderSizePixel = 0
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter 1-day key..."
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.PlaceholderColor3 = Color3.fromRGB(113, 128, 150)
    KeyInput.TextSize = isMobile() and 11 or 14
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = AuthContainer

    local KeyInputCorner = Instance.new("UICorner")
    KeyInputCorner.CornerRadius = UDim.new(0, 8)
    KeyInputCorner.Parent = KeyInput

    local KeyInputStroke = Instance.new("UIStroke")
    KeyInputStroke.Color = Color3.fromRGB(93, 173, 226)
    KeyInputStroke.Thickness = 2
    KeyInputStroke.Transparency = 0.7
    KeyInputStroke.Parent = KeyInput

    -- Verify Key Button (Only for FREE users)
    local VerifyButton = Instance.new("TextButton")
    VerifyButton.Name = "VerifyButton"
    VerifyButton.Size = UDim2.new(1, 0, 0, isMobile() and 35 or 45)
    VerifyButton.Position = UDim2.new(0, 0, 0, isMobile() and 65 or 80)
    VerifyButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    VerifyButton.BorderSizePixel = 0
    VerifyButton.Text = "VERIFY KEY"
    VerifyButton.TextColor3 = Color3.fromRGB(10, 14, 39)
    VerifyButton.TextSize = isMobile() and 11 or 14
    VerifyButton.Font = Enum.Font.GothamBold
    VerifyButton.Parent = AuthContainer

    local VerifyCorner = Instance.new("UICorner")
    VerifyCorner.CornerRadius = UDim.new(0, 8)
    VerifyCorner.Parent = VerifyButton

    -- Status Message
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(1, 0, 0, isMobile() and 20 or 25)
    StatusText.Position = UDim2.new(0, 0, 0, isMobile() and 110 or 135)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = ""
    StatusText.TextColor3 = Color3.fromRGB(231, 76, 60)
    StatusText.TextSize = isMobile() and 9 or 11
    StatusText.Font = Enum.Font.Gotham
    StatusText.Visible = false
    StatusText.Parent = AuthContainer

    -- Map Selection Container
    local MapContainer = Instance.new("Frame")
    MapContainer.Name = "MapContainer"
    MapContainer.Size = UDim2.new(1, -40, 1, isMobile() and -120 or -150)
    MapContainer.Position = UDim2.new(0.5, 0, 0, isMobile() and 75 or 100)
    MapContainer.AnchorPoint = Vector2.new(0.5, 0)
    MapContainer.BackgroundTransparency = 1
    MapContainer.Visible = false
    MapContainer.Parent = RightPanel

    -- Map Selection Header (Fixed)
    local MapHeader = Instance.new("Frame")
    MapHeader.Size = UDim2.new(1, 0, 0, isMobile() and 40 or 50)
    MapHeader.BackgroundTransparency = 1
    MapHeader.Parent = MapContainer

    -- Map Selection Title (Single)
    local MapTitle = Instance.new("TextLabel")
    MapTitle.Size = UDim2.new(1, 0, 0, isMobile() and 20 or 25)
    MapTitle.BackgroundTransparency = 1
    MapTitle.Text = "SELECT MAP"
    MapTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    MapTitle.TextSize = isMobile() and 14 or 18
    MapTitle.Font = Enum.Font.GothamBold
    MapTitle.Parent = MapHeader

    local MapSubtitle = Instance.new("TextLabel")
    MapSubtitle.Size = UDim2.new(1, 0, 0, isMobile() and 12 or 15)
    MapSubtitle.Position = UDim2.new(0, 0, 0, isMobile() and 22 or 28)
    MapSubtitle.BackgroundTransparency = 1
    MapSubtitle.Text = "Choose your destination"
    MapSubtitle.TextColor3 = Color3.fromRGB(160, 174, 192)
    MapSubtitle.TextSize = isMobile() and 8 or 10
    MapSubtitle.Font = Enum.Font.Gotham
    MapSubtitle.Parent = MapHeader

    -- Scrollable Map Buttons Container
    local MapsScrollFrame = Instance.new("ScrollingFrame")
    MapsScrollFrame.Name = "MapsScrollFrame"
    MapsScrollFrame.Size = UDim2.new(1, 0, 1, isMobile() and -40 or -50)
    MapsScrollFrame.Position = UDim2.new(0, 0, 0, isMobile() and 40 or 50)
    MapsScrollFrame.BackgroundTransparency = 1
    MapsScrollFrame.ScrollBarThickness = 0
    MapsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    MapsScrollFrame.Parent = MapContainer

    local MapsFrame = Instance.new("Frame")
    MapsFrame.Size = UDim2.new(1, 0, 1, 0)
    MapsFrame.BackgroundTransparency = 1
    MapsFrame.Parent = MapsScrollFrame

    local MapsLayout = Instance.new("UIGridLayout")
    MapsLayout.CellSize = UDim2.new(0.48, 0, 0, isMobile() and 90 or 120)
    MapsLayout.CellPadding = UDim2.new(0.04, 0, 0, isMobile() and 10 or 15)
    MapsLayout.Parent = MapsFrame

    -- Update canvas size berdasarkan jumlah items
    MapsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        MapsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, MapsLayout.AbsoluteContentSize.Y)
    end)

    -- Arunika Map Button
    local ArunikaButton = Instance.new("TextButton")
    ArunikaButton.Name = "ArunikaButton"
    ArunikaButton.BackgroundColor3 = Color3.fromRGB(93, 173, 226)
    ArunikaButton.BackgroundTransparency = 0.8
    ArunikaButton.BorderSizePixel = 0
    ArunikaButton.Text = ""
    ArunikaButton.Parent = MapsFrame

    local ArunikaCorner = Instance.new("UICorner")
    ArunikaCorner.CornerRadius = UDim.new(0, 12)
    ArunikaCorner.Parent = ArunikaButton

    local ArunikaStroke = Instance.new("UIStroke")
    ArunikaStroke.Color = Color3.fromRGB(93, 173, 226)
    ArunikaStroke.Thickness = 2
    ArunikaStroke.Transparency = 0.7
    ArunikaStroke.Parent = ArunikaButton

    local ArunikaIcon = Instance.new("TextLabel")
    ArunikaIcon.Size = UDim2.new(1, 0, 0, isMobile() and 35 or 50)
    ArunikaIcon.Position = UDim2.new(0, 0, 0, isMobile() and 15 or 20)
    ArunikaIcon.BackgroundTransparency = 1
    ArunikaIcon.Text = "🗺️"
    ArunikaIcon.TextSize = isMobile() and 25 or 35
    ArunikaIcon.Font = Enum.Font.GothamBold
    ArunikaIcon.Parent = ArunikaButton

    local ArunikaText = Instance.new("TextLabel")
    ArunikaText.Size = UDim2.new(1, 0, 0, isMobile() and 25 or 30)
    ArunikaText.Position = UDim2.new(0, 0, 1, isMobile() and -30 or -35)
    ArunikaText.BackgroundTransparency = 1
    ArunikaText.Text = "ARUNIKA"
    ArunikaText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ArunikaText.TextSize = isMobile() and 12 or 16
    ArunikaText.Font = Enum.Font.GothamBold
    ArunikaText.Parent = ArunikaButton

    -- Yahayuk Map Button
    local YahayukButton = Instance.new("TextButton")
    YahayukButton.Name = "YahayukButton"
    YahayukButton.BackgroundColor3 = Color3.fromRGB(93, 173, 226)
    YahayukButton.BackgroundTransparency = 0.8
    YahayukButton.BorderSizePixel = 0
    YahayukButton.Text = ""
    YahayukButton.Parent = MapsFrame

    local YahayukCorner = Instance.new("UICorner")
    YahayukCorner.CornerRadius = UDim.new(0, 12)
    YahayukCorner.Parent = YahayukButton

    local YahayukStroke = Instance.new("UIStroke")
    YahayukStroke.Color = Color3.fromRGB(93, 173, 226)
    YahayukStroke.Thickness = 2
    YahayukStroke.Transparency = 0.7
    YahayukStroke.Parent = YahayukButton

    local YahayukIcon = Instance.new("TextLabel")
    YahayukIcon.Size = UDim2.new(1, 0, 0, isMobile() and 35 or 50)
    YahayukIcon.Position = UDim2.new(0, 0, 0, isMobile() and 15 or 20)
    YahayukIcon.BackgroundTransparency = 1
    YahayukIcon.Text = "🌍"
    YahayukIcon.TextSize = isMobile() and 25 or 35
    YahayukIcon.Font = Enum.Font.GothamBold
    YahayukIcon.Parent = YahayukButton

    local YahayukText = Instance.new("TextLabel")
    YahayukText.Size = UDim2.new(1, 0, 0, isMobile() and 25 or 30)
    YahayukText.Position = UDim2.new(0, 0, 1, isMobile() and -30 or -35)
    YahayukText.BackgroundTransparency = 1
    YahayukText.Text = "YAHAYUK"
    YahayukText.TextColor3 = Color3.fromRGB(255, 255, 255)
    YahayukText.TextSize = isMobile() and 12 or 16
    YahayukText.Font = Enum.Font.GothamBold
    YahayukText.Parent = YahayukButton

    return ScreenGui, MainFrame, Overlay, BlurEffect, AuthContainer, MapContainer, KeyInput, VerifyButton, StatusText, ArunikaButton, YahayukButton, WelcomeText, Subtitle
end

-- Show Status Message
local function showStatus(statusText, message, isSuccess)
    statusText.Visible = true
    statusText.Text = message
    statusText.TextColor3 = isSuccess and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
end

-- Load Map Script
local function loadMap(mapName, screenGui, blurEffect)
    local scriptUrl = MAP_SCRIPTS[mapName]
    
    if scriptUrl then
        -- Animate out
        local mainFrame = screenGui:FindFirstChild("MainFrame")
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.5)
        
        -- Load script
        local success, err = pcall(function()
            loadstring(game:HttpGet(scriptUrl))()
        end)
        
        if blurEffect then
            blurEffect:Destroy()
        end
        screenGui:Destroy()
        
        if not success then
            warn("Failed to load map:", err)
        end
    end
end

-- Main Function
local function main()
    -- Fetch VIP User IDs dari GitHub
    local vipIds = fetchVIPIds()
    
    -- Auto-detect user type using User ID
    local isVIP = isUserVIP(userId, vipIds)
    
    print("User: " .. LocalPlayer.Name)
    print("User ID: " .. userId)
    print("Status: " .. (isVIP and "VIP" or "FREE"))
    
    local ScreenGui, MainFrame, Overlay, BlurEffect, AuthContainer, MapContainer, KeyInput, VerifyButton, StatusText, ArunikaButton, YahayukButton, WelcomeText, Subtitle = createLoader(isVIP, LocalPlayer.Name)
    
    -- Entrance Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, isMobile() and 350 or 600, 0, isMobile() and math.floor(350 / 16 * 9) or math.floor(600 / 16 * 9)),
        BackgroundTransparency = 0
    }):Play()
    
    -- If VIP: Show maps immediately
    if isVIP then
        task.wait(0.5)
        WelcomeText.Text = "SELECT MAP"
        Subtitle.Text = "Choose your destination"
        MapContainer.Visible = true
        MapContainer.Position = UDim2.new(0.5, 0, 0, isMobile() and 75 or 100)
    end
    
    -- Verify Key Button (FREE users only)
    VerifyButton.MouseButton1Click:Connect(function()
        local key = KeyInput.Text
        
        if key == "" then
            showStatus(StatusText, "✗ Please enter a key", false)
            return
        end
        
        showStatus(StatusText, "⏳ Verifying key...", true)
        StatusText.TextColor3 = Color3.fromRGB(255, 215, 0)
        
        task.wait(1)
        
        local keys = fetchKeys()
        
        if keys[key] then
            showStatus(StatusText, "✓ Key verified! Access granted", true)
            task.wait(1.5)
            
            -- Hide auth, show maps
            WelcomeText.Text = "SELECT MAP"
            Subtitle.Text = "Choose your destination"
            
            TweenService:Create(AuthContainer, TweenInfo.new(0.3), {
                Position = UDim2.new(0.5, 0, 0, -300)
            }):Play()
            
            task.wait(0.3)
            AuthContainer.Visible = false
            MapContainer.Visible = true
            MapContainer.Position = UDim2.new(0.5, 0, 0, 400)
            
            TweenService:Create(MapContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0.5, 0, 0, isMobile() and 75 or 100)
            }):Play()
        else
            showStatus(StatusText, "✗ Invalid or expired key", false)
        end
    end)
    
    -- Map Buttons
    ArunikaButton.MouseButton1Click:Connect(function()
        loadMap("Arunika", ScreenGui, BlurEffect)
    end)
    
    YahayukButton.MouseButton1Click:Connect(function()
        loadMap("Yahayuk", ScreenGui, BlurEffect)
    end)
    
    -- Hover Effects
    local function addHoverEffect(button)
        local originalSize = button.Size
        local originalTransparency = button.BackgroundTransparency
        
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.5,
                Size = originalSize + UDim2.new(0, 0, 0, 5)
            }):Play()
            
            local stroke = button:FindFirstChildOfClass("UIStroke")
            if stroke then
                TweenService:Create(stroke, TweenInfo.new(0.2), {
                    Transparency = 0.3,
                    Thickness = 3
                }):Play()
            end
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = originalTransparency,
                Size = originalSize
            }):Play()
            
            local stroke = button:FindFirstChildOfClass("UIStroke")
            if stroke then
                TweenService:Create(stroke, TweenInfo.new(0.2), {
                    Transparency = 0.7,
                    Thickness = 2
                }):Play()
            end
        end)
    end
    
    addHoverEffect(VerifyButton)
    addHoverEffect(ArunikaButton)
    addHoverEffect(YahayukButton)
    
    -- Focus animation for KeyInput
    KeyInput.Focused:Connect(function()
        local stroke = KeyInput:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.2), {
                Transparency = 0.3,
                Thickness = 3,
                Color = Color3.fromRGB(93, 173, 226)
            }):Play()
        end
    end)
    
    KeyInput.FocusLost:Connect(function()
        local stroke = KeyInput:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.2), {
                Transparency = 0.7,
                Thickness = 2,
                Color = Color3.fromRGB(93, 173, 226)
            }):Play()
        end
    end)
    
    -- Glow effect for welcome text
    spawn(function()
        local glow = WelcomeText:FindFirstChildOfClass("UIStroke")
        if glow then
            while glow and glow.Parent do
                TweenService:Create(glow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    Transparency = 0.2
                }):Play()
                task.wait(1.5)
            end
        end
    end)
end

-- Run the loader
main()

print("VIP Loader initialized successfully!")
print("Device: " .. (isMobile() and "Mobile" or "Desktop"))
