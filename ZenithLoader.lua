-- ==============================================================================
-- PROJECT ZENITH: CONTROLLER & API (ZenithLoader.lua)
-- ==============================================================================
repeat task.wait(0.1) until game:IsLoaded()

-- 1. Load Modules (Assuming these are loaded via a module manager or HTTP in production)
local Config    = loadstring(game:HttpGet("URL_TO_CONFIG"))()
local Constants = loadstring(game:HttpGet("URL_TO_CONSTANTS"))()
local Logger    = loadstring(game:HttpGet("URL_TO_LOGGER"))()
local Provider  = loadstring(game:HttpGet("URL_TO_DEFAULTPROVIDER"))()

-- 2. State Management Controller
local Loader = {
    CurrentState = Constants.States.Ready,
    ActiveProvider = nil,
    UIHook = nil
}

-- 3. Core API
function Loader:SetState(newState)
    self.CurrentState = newState
    Logger.Info("State Changed: " .. newState)
    if self.UIHook then
        self.UIHook(newState)
    end
end

function Loader:SetProvider(providerName)
    -- In a multi-provider setup, ProviderManager would switch logic here.
    -- For now, we utilize our direct daily key implementation.
    self.ActiveProvider = Provider.new()
    self.ActiveProvider:Initialize(Config)
    Logger.Info("Provider set to: " .. providerName)
end

function Loader:Generate(gatewayName)
    if not self.ActiveProvider then return end
    self:SetState(Constants.States.Generating)
    
    local link = self.ActiveProvider:GenerateLink(gatewayName)
    if link then
        local fSetClipboard = setclipboard or toclipboard
        fSetClipboard(link)
        self:SetState("Copied " .. gatewayName .. " link!")
    else
        self:SetState(Constants.States.Error)
    end
end

function Loader:Verify(key)
    if not self.ActiveProvider then return end
    self:SetState(Constants.States.Verifying)
    
    local success = self.ActiveProvider:VerifyKey(key)
    
    if success then
        self:SetState(Constants.States.Authenticated)
        task.wait(0.5)
        
        -- Execute Security Handshake & Stage 2 Load
        getgenv().Zenith_Secure_Auth = Constants.Security.HandshakeToken
        loadstring(game:HttpGet(Config.Network.Stage2Url))()
    else
        self:SetState(Constants.States.Failed)
    end
end

function Loader:BindUIState(callback)
    self.UIHook = callback
end

-- 4. Initialization Pipeline
Loader:SetProvider(Config.Network.DefaultProvider)

local BuildUI = loadstring(game:HttpGet("URL_TO_ZENITHUI"))()
BuildUI(Loader, Config) -- Pass Controller and Config strictly
