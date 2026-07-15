-- ==============================================================================
-- PROJECT ZENITH: FRONTEND UI MODULE (ZenithUI.lua)
-- ==============================================================================
return function(Loader, Config)
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    
    -- Load Utils (Assume injected or required)
    local AnimationUtil = loadstring(game:HttpGet("URL_TO_ANIMATION_UTIL"))()

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZenithLauncherGateway"
    ScreenGui.Parent = (CoreGui:FindFirstChild("RobloxGui") and CoreGui) or Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local function CreateCorner(parent, radius)
        local uic = Instance.new("UICorner")
        uic.CornerRadius = UDim.new(0, radius)
        uic.Parent = parent
        return uic
    end

    local function CreateStroke(parent, color, thickness, trans)
        local uis = Instance.new("UIStroke")
        uis.Color = color
        uis.Thickness = thickness
        uis.Transparency = trans or 0
        uis.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uis.Parent = parent
        return uis
    end

    local function CreateShadow(parent)
        local glow = Instance.new("UIStroke")
        glow.Color = Config.Theme.AccentBlue
        glow.Thickness = 1.2
        glow.Transparency = 0.85
        glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        glow.Parent = parent
        return glow
    end

    -- Base Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = Config.Window.Size
    MainFrame.Position = Config.Window.Offset
    MainFrame.BackgroundColor3 = Config.Theme.Bg
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    CreateCorner(MainFrame, 12)
    CreateStroke(MainFrame, Config.Theme.Border, 1.5)
    CreateShadow(MainFrame)

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 0, 25)
    TitleLabel.Position = UDim2.new(0, 20, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Project.Name
    TitleLabel.TextColor3 = Config.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = TitleBar

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0, 250, 0, 15)
    SubtitleLabel.Position = UDim2.new(0, 20, 0, 28)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = Config.Project.Subtitle
    SubtitleLabel.TextColor3 = Config.Theme.TextSec
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.TextSize = 10
    SubtitleLabel.Font = Enum.Font.GothamMedium
    SubtitleLabel.Parent = TitleBar

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(0, 40, 0, 20)
    VersionLabel.Position = UDim2.new(1, -95, 0, 15)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = Config.Project.Version
    VersionLabel.TextColor3 = Config.Theme.AccentBlue
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
    VersionLabel.TextSize = 12
    VersionLabel.Font = Enum.Font.GothamBold
    VersionLabel.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -45, 0, 10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Config.Theme.TextSec
    CloseBtn.TextSize = 22
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.Parent = TitleBar

    CloseBtn.MouseButton1Click:Connect(function()
        local tOut = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = Config.Window.ClosedSize,
            Position = Config.Window.ClosedOffset,
            BackgroundTransparency = 1
        })
        tOut:Play()
        tOut.Completed:Wait()
        ScreenGui:Destroy()
    end)

    AnimationUtil.BindHover(CloseBtn, {TextColor3 = Config.Theme.Red}, {TextColor3 = Config.Theme.TextSec})

    -- Key Input
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -40, 0, 42)
    KeyBox.Position = UDim2.new(0, 20, 0, 60)
    KeyBox.BackgroundColor3 = Config.Theme.Input
    KeyBox.TextColor3 = Config.Theme.Text
    KeyBox.PlaceholderText = "Enter your secure key..."
    KeyBox.PlaceholderColor3 = Config.Theme.TextSec
    KeyBox.Text = ""
    KeyBox.TextSize = 12
    KeyBox.Font = Enum.Font.GothamMedium
    KeyBox.Parent = MainFrame

    CreateCorner(KeyBox, 8)
    local KeyStroke = CreateStroke(KeyBox, Config.Theme.Border, 1)

    KeyBox.Focused:Connect(function()
        TweenService:Create(KeyStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Config.Theme.AccentBlue, Thickness = 1.5}):Play()
    end)
    KeyBox.FocusLost:Connect(function()
        TweenService:Create(KeyStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Config.Theme.Border, Thickness = 1}):Play()
    end)

    -- Gateway Selection Deck
    local GatewayFrame = Instance.new("Frame")
    GatewayFrame.Size = UDim2.new(1, -40, 0, 65)
    GatewayFrame.Position = UDim2.new(0, 20, 0, 115)
    GatewayFrame.BackgroundTransparency = 1
    GatewayFrame.Parent = MainFrame

    local activeGateway = Config.Network.DefaultProvider
    local gatewayCards = {}

    local function CreateGatewayCard(name, pos, xSize)
        local card = Instance.new("TextButton")
        card.Size = UDim2.new(xSize, -6, 1, 0)
        card.Position = pos
        card.BackgroundColor3 = Config.Theme.Panel
        card.Text = ""
        card.AutoButtonColor = false
        card.Parent = GatewayFrame

        CreateCorner(card, 8)
        local stroke = CreateStroke(card, Config.Theme.Border, 1)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = Config.Theme.TextSec
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamBold
        lbl.Parent = card

        gatewayCards[name] = {Card = card, Stroke = stroke, Label = lbl}

        card.MouseButton1Down:Connect(function()
            activeGateway = name
            AnimationUtil.Flash(card, {Size = UDim2.new(xSize, -10, 1, -4)}, {Size = UDim2.new(xSize, -6, 1, 0)})

            for gName, elements in pairs(gatewayCards) do
                if gName == activeGateway then
                    TweenService:Create(elements.Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Config.Theme.AccentBlue, Thickness = 1.5}):Play()
                    TweenService:Create(elements.Label, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Config.Theme.Text}):Play()
                else
                    TweenService:Create(elements.Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Config.Theme.Border, Thickness = 1}):Play()
                    TweenService:Create(elements.Label, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Config.Theme.TextSec}):Play()
                end
            end
            
            -- API CALL: Delegate entirely to Backend Controller
            Loader:Generate(activeGateway)
        end)

        AnimationUtil.BindHover(card, {BackgroundColor3 = Config.Theme.Input}, {BackgroundColor3 = Config.Theme.Panel})
    end

    CreateGatewayCard("LootLabs", UDim2.new(0, 0, 0, 0), 0.33)
    CreateGatewayCard("Work.ink", UDim2.new(0.33, 3, 0, 0), 0.33)
    CreateGatewayCard("Linkvertise", UDim2.new(0.66, 6, 0, 0), 0.34)

    TweenService:Create(gatewayCards[activeGateway].Stroke, TweenInfo.new(0.1), {Color = Config.Theme.AccentBlue, Thickness = 1.5}):Play()
    TweenService:Create(gatewayCards[activeGateway].Label, TweenInfo.new(0.1), {TextColor3 = Config.Theme.Text}):Play()

    -- Bottom Actions
    local ActionFrame = Instance.new("Frame")
    ActionFrame.Size = UDim2.new(1, -40, 0, 45)
    ActionFrame.Position = UDim2.new(0, 20, 0, 195)
    ActionFrame.BackgroundTransparency = 1
    ActionFrame.Parent = MainFrame

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Size = UDim2.new(0.4, -5, 1, 0)
    DiscordBtn.Position = UDim2.new(0, 0, 0, 0)
    DiscordBtn.BackgroundColor3 = Config.Theme.Panel
    DiscordBtn.Text = "Discord Server"
    DiscordBtn.TextColor3 = Config.Theme.TextSec
    DiscordBtn.TextSize = 12
    DiscordBtn.Font = Enum.Font.GothamBold
    DiscordBtn.Parent = ActionFrame

    CreateCorner(DiscordBtn, 8)
    CreateStroke(DiscordBtn, Config.Theme.Border, 1)

    DiscordBtn.MouseButton1Click:Connect(function()
        local fSetClipboard = setclipboard or toclipboard
        fSetClipboard(Config.Project.DiscordUrl)
        Loader:SetState("Discord Copied!")
    end)

    AnimationUtil.BindHover(DiscordBtn, {BackgroundColor3 = Config.Theme.Input, TextColor3 = Config.Theme.Text}, {BackgroundColor3 = Config.Theme.Panel, TextColor3 = Config.Theme.TextSec})

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0, 220, 0, 45)
    VerifyBtn.Position = UDim2.new(1, -220, 0, 195)
    VerifyBtn.BackgroundColor3 = Config.Theme.AccentBlue
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.TextColor3 = Config.Theme.Text
    VerifyBtn.TextSize = 13
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.Parent = MainFrame

    CreateCorner(VerifyBtn, 8)
    CreateStroke(VerifyBtn, Config.Theme.AccentBlueHover, 1.5, 0.7)

    AnimationUtil.BindHover(VerifyBtn, {BackgroundColor3 = Config.Theme.AccentBlueHover}, {BackgroundColor3 = Config.Theme.AccentBlue})

    -- Status Bar Engine
    local StatusPanel = Instance.new("Frame")
    StatusPanel.Size = UDim2.new(1, -40, 0, 25)
    StatusPanel.Position = UDim2.new(0, 20, 0, 250)
    StatusPanel.BackgroundColor3 = Config.Theme.Panel
    StatusPanel.Parent = MainFrame

    CreateCorner(StatusPanel, 6)
    CreateStroke(StatusPanel, Config.Theme.Border, 1)

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.Position = UDim2.new(0, 12, 0.5, -4)
    StatusDot.BackgroundColor3 = Config.Theme.TextSec
    StatusDot.Parent = StatusPanel

    CreateCorner(StatusDot, 4)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -35, 1, 0)
    StatusLabel.Position = UDim2.new(0, 28, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = Loader.CurrentState
    StatusLabel.TextColor3 = Config.Theme.TextSec
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Parent = StatusPanel

    -- STATE BINDING: UI strictly listens to Loader
    Loader:BindUIState(function(message)
        if not StatusLabel then return end
        StatusLabel.Text = message
        
        local dColor = Config.Theme.TextSec
        local lowerMsg = string.lower(message)
        
        if string.find(lowerMsg, "success") or string.find(lowerMsg, "granted") or string.find(lowerMsg, "copied") then
            dColor = Config.Theme.Green
        elseif string.find(lowerMsg, "failed") or string.find(lowerMsg, "invalid") or string.find(lowerMsg, "error") or string.find(lowerMsg, "denied") then
            dColor = Config.Theme.Red
        elseif string.find(lowerMsg, "generating") or string.find(lowerMsg, "authenticating") then
            dColor = Config.Theme.AccentBlue
        end

        TweenService:Create(StatusDot, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = dColor}):Play()
        TweenService:Create(StatusLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = dColor}):Play()
        
        -- Handle success transition visually
        if dColor == Config.Theme.Green and string.find(lowerMsg, "granted") then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Config.Theme.Green}):Play()
            task.wait(0.5)
            ScreenGui:Destroy()
        end
    end)

    -- API CALL: Key Verification
    VerifyBtn.MouseButton1Click:Connect(function()
        local userKey = string.gsub(KeyBox.Text, "^%s*(.-)%s*$", "%1")
        if userKey == "" then
            Loader:SetState("Enter secure key first!")
            return
        end
        Loader:Verify(userKey)
    end)

    -- Boot Animation
    MainFrame.Size = Config.Window.ClosedSize
    MainFrame.Position = Config.Window.ClosedOffset
    MainFrame.BackgroundTransparency = 1

    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = Config.Window.Size,
        Position = Config.Window.Offset,
        BackgroundTransparency = 0
    }):Play()
end
