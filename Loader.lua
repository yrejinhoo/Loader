
-- VIP Loader System
-- Created with modern UI design

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local userId = LocalPlayer.UserId

-- GitHub URLs (Ganti dengan URL raw GitHub Anda)
local GITHUB_KEY_URL = "https://raw.githubusercontent.com/yourusername/keys/main/keys.txt"
local GITHUB_VIP_URL = "https://raw.githubusercontent.com/yourusername/vip/main/vip.txt"

-- Map Scripts
local MAP_SCRIPTS = {
    Arunika = "https://raw.githubusercontent.com/yourusername/maps/main/arunika.lua",
    Yahayuk = "https://raw.githubusercontent.com/yrejinhoo/Loader/refs/heads/main/Loader.lua"
}

-- Detect device type
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Create ScreenGui
local function createLoader()
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

    -- Blur effect (if supported)
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
    AvatarFrame.Position = UDim2.new(0.5, 0, 0, isMobile() and 25 : 40)
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

    -- Username
    local Username = Instance.new("TextLabel")
    Username.Name = "Username"
    Username.Size = UDim2.new(1, -20, 0, isMobile() and 25 : 30)
    Username.Position = UDim2.new(0.5, 0, 0, isMobile() and 115 : 175)
    Username.AnchorPoint = Vector2.new(0.5, 0)
    Username.BackgroundTransparency = 1
    Username.Text = "@" .. LocalPlayer.Name
    Username.TextColor3 = Color3.fromRGB(255, 255, 255)
    Username.TextSize = isMobile() and 12 : 16
    Username.Font = Enum.Font.GothamBold
    Username.TextWrapped = true
    Username.Parent = LeftPanel

    -- Display Name
    local DisplayName = Instance.new("TextLabel")
    DisplayName.Name = "DisplayName"
    DisplayName.Size = UDim2.new(1, -20, 0, isMobile() and 20 : 25)
    DisplayName.Position = UDim2.new(0.5, 0, 0, isMobile() and 140 : 205)
    DisplayName.AnchorPoint = Vector2.new(0.5, 0)
    DisplayName.BackgroundTransparency = 1
    DisplayName.Text = LocalPlayer.DisplayName
    DisplayName.TextColor3 = Color3.fromRGB(160, 174, 192)
    DisplayName.TextSize = isMobile() and 10 : 14
    DisplayName.Font = Enum.Font.Gotham
    DisplayName.TextWrapped = true
    DisplayName.Parent = LeftPanel

    -- Logo Icon (Bottom)
    local LogoIcon = Instance.new("TextLabel")
    LogoIcon.Size = UDim2.new(1, 0, 0, isMobile() and 40 : 60)
    LogoIcon.Position = UDim2.new(0.5, 0, 1, isMobile() and -50 : -70)
    LogoIcon.AnchorPoint = Vector2.new(0.5, 0)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Text = "🛡️"
    LogoIcon.TextSize = isMobile() and 30 : 40
    LogoIcon.Font = Enum.Font.GothamBold
    LogoIcon.Parent = LeftPanel

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
    WelcomeText.Size = UDim2.new(1, -40, 0, isMobile() and 30 : 40)
    WelcomeText.Position = UDim2.new(0.5, 0, 0, isMobile() and 15 : 25)
    WelcomeText.AnchorPoint = Vector2.new(0.5, 0)
    WelcomeText.BackgroundTransparency = 1
    WelcomeText.Text = "WELCOME VIP"
    WelcomeText.TextColor3 = Color3.fromRGB(255, 215, 0)
    WelcomeText.TextSize = isMobile() and 20 : 28
    WelcomeText.Font = Enum.Font.GothamBold
    WelcomeText.Parent = RightPanel

    local WelcomeGlow = Instance.new("UIStroke")
    WelcomeGlow.Color = Color3.fromRGB(255, 215, 0)
    WelcomeGlow.Thickness = 1
    WelcomeGlow.Transparency = 0.5
    WelcomeGlow.Parent = WelcomeText

    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -40, 0, isMobile() and 15 : 20)
    Subtitle.Position = UDim2.new(0.5, 0, 0, isMobile() and 45 : 65)
    Subtitle.AnchorPoint = Vector2.new(0.5, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Premium Access System"
    Subtitle.TextColor3 = Color3.fromRGB(160, 174, 192)
    Subtitle.TextSize = isMobile() and 9 : 12
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Parent = RightPanel

    -- Auth Container
    local AuthContainer = Instance.new("Frame")
    AuthContainer.Name = "AuthContainer"
    AuthContainer.Size = UDim2.new(1, -40, 0, isMobile() and 170 : 220)
    AuthContainer.Position = UDim2.new(0.5, 0, 0, isMobile() and 75 : 100)
    AuthContainer.AnchorPoint = Vector2.new(0.5, 0)
    AuthContainer.BackgroundTransparency = 1
    AuthContainer.Parent = RightPanel

    -- Key Input Label
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Size = UDim2.new(1, 0, 0, isMobile() and 15 : 20)
    KeyLabel.Position = UDim2.new(0, 0, 0, 0)
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Text = "🔑 Enter Your Key"
    KeyLabel.TextColor3 = Color3.fromRGB(203, 213, 224)
    KeyLabel.TextSize = isMobile() and 10 : 12
    KeyLabel.Font = Enum.Font.Gotham
    KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeyLabel.Parent = AuthContainer

    -- Key Input Box
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.Size = UDim2.new(1, 0, 0, isMobile() and 35 : 45)
    KeyInput.Position = UDim2.new(0, 0, 0, isMobile() and 20 : 25)
    KeyInput.BackgroundColor3 = Color3.fromRGB(26, 32, 58)
    KeyInput.BorderSizePixel = 0
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter 1-day key..."
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.PlaceholderColor3 = Color3.fromRGB(113, 128, 150)
    KeyInput.TextSize = isMobile() and 11 : 14
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

    -- Verify Key Button
    local VerifyButton = Instance.new("TextButton")
    VerifyButton.Name = "VerifyButton"
    VerifyButton.Size = UDim2.new(1, 0, 0, isMobile() and 35 : 45)
    VerifyButton.Position = UDim2.new(0, 0, 0, isMobile() and 65 : 80)
    VerifyButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    VerifyButton.BorderSizePixel = 0
    VerifyButton.Text = "VERIFY KEY"
    VerifyButton.TextColor3 = Color3.fromRGB(10, 14, 39)
    VerifyButton.TextSize = isMobile() and 11 : 14
    VerifyButton.Font = Enum.Font.GothamBold
    VerifyButton.Parent = AuthContainer

    local VerifyCorner = Instance.new("UICorner")
    VerifyCorner.CornerRadius = UDim.new(0, 8)
    VerifyCorner.Parent = VerifyButton

    -- VIP Access Button
    local VIPButton = Instance.new("TextButton")
    VIPButton.Name = "VIPButton"
    VIPButton.Size = UDim2.new(1, 0, 0, isMobile() and 35 : 45)
    VIPButton.Position = UDim2.new(0, 0, 0, isMobile() and 110 : 135)
    VIPButton.BackgroundColor3 = Color3.fromRGB(93, 173, 226)
    VIPButton.BorderSizePixel = 0
    VIPButton.Text = "VIP ACCESS"
    VIPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    VIPButton.TextSize = isMobile() and 11 : 14
    VIPButton.Font = Enum.Font.GothamBold
    VIPButton.Parent = AuthContainer

    local VIPCorner = Instance.new("UICorner")
    VIPCorner.CornerRadius = UDim.new(0, 8)
    VIPCorner.Parent = VIPButton

    -- Status Message
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(1, 0, 0, isMobile() and 20 : 25)
    StatusText.Position = UDim2.new(0, 0, 0, isMobile() and 155 : 190)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = ""
    StatusText.TextColor3 = Color3.fromRGB(231, 76, 60)
    StatusText.TextSize = isMobile() and 9 : 11
    StatusText.Font = Enum.Font.Gotham
    StatusText.Visible = false
    StatusText.Parent = AuthContainer

    -- VIP Welcome Screen
    local VIPWelcome = Instance.new("Frame")
    VIPWelcome.Name = "VIPWelcome"
    VIPWelcome.Size = UDim2.new(1, -40, 0, isMobile() and 150 : 200)
    VIPWelcome.Position = UDim2.new(0.5, 0, 0.5, 0)
    VIPWelcome.AnchorPoint = Vector2.new(0.5, 0.5)
    VIPWelcome.BackgroundTransparency = 1
    VIPWelcome.Visible = false
    VIPWelcome.Parent = RightPanel

    local VIPWelcomeText = Instance.new("TextLabel")
    VIPWelcomeText.Size = UDim2.new(1, 0, 0, isMobile() and 50 : 70)
    VIPWelcomeText.Position = UDim2.new(0.5, 0, 0.5, 0)
    VIPWelcomeText.AnchorPoint = Vector2.new(0.5, 0.5)
    VIPWelcomeText.BackgroundTransparency = 1
    VIPWelcomeText.Text = "WELCOME\nVIP USER"
    VIPWelcomeText.TextColor3 = Color3.fromRGB(255, 215, 0)
    VIPWelcomeText.TextSize = isMobile() and 18 : 24
    VIPWelcomeText.Font = Enum.Font.Code
    VIPWelcomeText.Parent = VIPWelcome

    local VIPWelcomeGlow = Instance.new("UIStroke")
    VIPWelcomeGlow.Color = Color3.fromRGB(255, 215, 0)
    VIPWelcomeGlow.Thickness = 2
    VIPWelcomeGlow.Transparency = 0.3
    VIPWelcomeGlow.Parent = VIPWelcomeText

    -- Map Selection Container
    local MapContainer = Instance.new("Frame")
    MapContainer.Name = "MapContainer"
    MapContainer.Size = UDim2.new(1, -40, 0, isMobile() and 170 : 220)
    MapContainer.Position = UDim2.new(0.5, 0, 0, isMobile() and 75 : 100)
    MapContainer.AnchorPoint = Vector2.new(0.5, 0)
    MapContainer.BackgroundTransparency = 1
    MapContainer.Visible = false
    MapContainer.Parent = RightPanel

    -- Map Selection Title
    local MapTitle = Instance.new("TextLabel")
    MapTitle.Size = UDim2.new(1, 0, 0, isMobile() and 25 : 35)
    MapTitle.BackgroundTransparency = 1
    MapTitle.Text = "SELECT MAP"
    MapTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    MapTitle.TextSize = isMobile() and 16 : 22
    MapTitle.Font = Enum.Font.GothamBold
    MapTitle.Parent = MapContainer

    local MapSubtitle = Instance.new("TextLabel")
    MapSubtitle.Size = UDim2.new(1, 0, 0, isMobile() and 15 : 20)
    MapSubtitle.Position = UDim2.new(0, 0, 0, isMobile() and 25 : 35)
    MapSubtitle.BackgroundTransparency = 1
    MapSubtitle.Text = "Choose your destination"
    MapSubtitle.TextColor3 = Color3.fromRGB(160, 174, 192)
    MapSubtitle.TextSize = isMobile() and 9 : 11
    MapSubtitle.Font = Enum.Font.Gotham
    MapSubtitle.Parent = MapContainer

    -- Map Buttons Container
    local MapsFrame = Instance.new("Frame")
    MapsFrame.Size = UDim2.new(1, 0, 1, isMobile() and -45 : -60)
    MapsFrame.Position = UDim2.new(0, 0, 0, isMobile() and 45 : 60)
    MapsFrame.BackgroundTransparency = 1
    MapsFrame.Parent = MapContainer

    local MapsLayout = Instance.new("UIGridLayout")
    MapsLayout.CellSize = UDim2.new(0.48, 0, 0, isMobile() and 90 : 120)
    MapsLayout.CellPadding = UDim2.new(0.04, 0, 0, isMobile() and 10 : 15)
    MapsLayout.Parent = MapsFrame

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
    ArunikaIcon.Size = UDim2.new(1, 0, 0, isMobile() and 35 : 50)
    ArunikaIcon.Position = UDim2.new(0, 0, 0, isMobile() and 15 : 20)
    ArunikaIcon.BackgroundTransparency = 1
    ArunikaIcon.Text = "🗺️"
    ArunikaIcon.TextSize = isMobile() and 25 : 35
    ArunikaIcon.Font = Enum.Font.GothamBold
    ArunikaIcon.Parent = ArunikaButton

    local ArunikaText = Instance.new("TextLabel")
    ArunikaText.Size = UDim2.new(1, 0, 0, isMobile() and 25 : 30)
    ArunikaText.Position = UDim2.new(0, 0, 1, isMobile() and -30 : -35)
    ArunikaText.BackgroundTransparency = 1
    ArunikaText.Text = "ARUNIKA"
    ArunikaText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ArunikaText.TextSize = isMobile() and 12 : 16
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
    YahayukIcon.Size = UDim2.new(1, 0, 0, isMobile() and 35 : 50)
    YahayukIcon.Position = UDim2.new(0, 0, 0, isMobile() and 15 : 20)
    YahayukIcon.BackgroundTransparency = 1
    YahayukIcon.Text = "🌍"
    YahayukIcon.TextSize = isMobile() and 25 : 35
    YahayukIcon.Font = Enum.Font.GothamBold
    YahayukIcon.Parent = YahayukButton

    local YahayukText = Instance.new("TextLabel")
    YahayukText.Size = UDim2.new(1, 0, 0, isMobile() and 25 : 30)
    YahayukText.Position = UDim2.new(0, 0, 1, isMobile() and -30 : -35)
    YahayukText.BackgroundTransparency = 1
    YahayukText.Text = "YAHAYUK"
    YahayukText.TextColor3 = Color3.fromRGB(255, 255, 255)
    YahayukText.TextSize = isMobile() and 12 : 16
    YahayukText.Font = Enum.Font.GothamBold
    YahayukText.Parent = YahayukButton

    return ScreenGui, MainFrame, Overlay, BlurEffect, AuthContainer, MapContainer, KeyInput, VerifyButton, VIPButton, StatusText, ArunikaButton, YahayukButton, VIPWelcome, WelcomeText, Subtitle
end

-- Fetch Keys from GitHub
local function fetchKeys()
    local success, response = pcall(function()
        return game:HttpGet(GITHUB_KEY_URL)
    end)
    
    if success then
        local keys = {}
        for line in response:gmatch("[^\r\n]+") do
            local key, expiry = line:match("([^|]+)|([^|]+)")
            if key and expiry then
                keys[key] = expiry
            end
        end
        return keys
    end
    return {}
end

-- Fetch VIP Users from GitHub
local function fetchVIPs()
    local success, response = pcall(function()
        return game:HttpGet(GITHUB_VIP_URL)
    end)
    
    if success then
        local vips = {}
        for line in response:gmatch("[^\r\n]+") do
            local username = line:match("^%s*(.-)%s*$")
            if username ~= "" then
                vips[username:lower()] = true
            end
        end
        return vips
    end
    return {}
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
    local ScreenGui, MainFrame, Overlay, BlurEffect, AuthContainer, MapContainer, KeyInput, VerifyButton, VIPButton, StatusText, ArunikaButton, YahayukButton, VIPWelcome, WelcomeText, Subtitle = createLoader()
    
    -- Entrance Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, isMobile() and 350 : 600, 0, isMobile() and math.floor(350 / 16 * 9) : math.floor(600 / 16 * 9)),
        BackgroundTransparency = 0
    }):Play()
    
    -- Verify Key Button
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
                Position = UDim2.new(0.5, 0, 0, isMobile() and 75 : 100)
            }):Play()
        else
            showStatus(StatusText, "✗ Invalid or expired key", false)
        end
    end)
    
    -- VIP Access Button
    VIPButton.MouseButton1Click:Connect(function()
        showStatus(StatusText, "⏳ Checking VIP status...", true)
        StatusText.TextColor3 = Color3.fromRGB(255, 215, 0)
        
        task.wait(1)
        
        local vips = fetchVIPs()
        local playerName = LocalPlayer.Name:lower()
        
        if vips[playerName] then
            -- Hide auth container
            TweenService:Create(AuthContainer, TweenInfo.new(0.3), {
                Position = UDim2.new(0.5, 0, 0, -300)
            }):Play()
            
            task.wait(0.3)
            AuthContainer.Visible = false
            
            -- Show VIP Welcome with Minecraft font
            VIPWelcome.Visible = true
            VIPWelcome.Position = UDim2.new(0.5, 0, 0.5, -100)
            
            -- Pulse animation for VIP Welcome
            local function pulseText()
                for i = 1, 3 do
                    TweenService:Create(VIPWelcome:FindFirstChild("TextLabel"), TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                        TextSize = (isMobile() and 22 : 28)
                    }):Play()
                    task.wait(0.5)
                    TweenService:Create(VIPWelcome:FindFirstChild("TextLabel"), TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                        TextSize = (isMobile() and 18 : 24)
                    }):Play()
                    task.wait(0.5)
                end
            end
            
            pulseText()
            
            task.wait(1.5)
            
            -- Fade out VIP Welcome
            TweenService:Create(VIPWelcome:FindFirstChild("TextLabel"), TweenInfo.new(0.3), {
                TextTransparency = 1
            }):Play()
            
            task.wait(0.3)
            VIPWelcome.Visible = false
            
            -- Update title
            WelcomeText.Text = "SELECT MAP"
            Subtitle.Text = "Choose your destination"
            
            -- Show map selection
            MapContainer.Visible = true
            MapContainer.Position = UDim2.new(0.5, 0, 0, 400)
            
            TweenService:Create(MapContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0.5, 0, 0, isMobile() and 75 : 100)
            }):Play()
        else
            showStatus(StatusText, "✗ VIP access denied", false)
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
    addHoverEffect(VIPButton)
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
    
    -- Avatar rotation animation
    local avatar = MainFrame:FindFirstChild("LeftPanel"):FindFirstChild("AvatarFrame")
    if avatar then
        spawn(function()
            while avatar and avatar.Parent do
                TweenService:Create(avatar:FindFirstChildOfClass("UIStroke"), TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
                    Transparency = 0.3
                }):Play()
                task.wait(2)
            end
        end)
    end
    
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
print("Device: " .. (isMobile() and "Mobile" : "Desktop"))
print("User: " .. LocalPlayer.Name)
print("UserID: " .. userId)
 
