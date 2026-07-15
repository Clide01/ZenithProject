-- ==============================================================================
-- PROJECT ZENITH: DIRECT GATEWAY PROVIDER (DefaultProvider.lua)
-- ==============================================================================
local IProvider = loadstring(game:HttpGet("URL_TO_IPROVIDER"))() -- Replace with actual loader
local Http = loadstring(game:HttpGet("URL_TO_HTTP"))()           -- Replace with actual loader

local DefaultProvider = setmetatable({}, {__index = IProvider})
DefaultProvider.__index = DefaultProvider

function DefaultProvider.new()
    local self = setmetatable(IProvider.new(), DefaultProvider)
    return self
end

function DefaultProvider:Initialize(config)
    self.Config = config
    self.IsInitialized = true
end

function DefaultProvider:GenerateLink(gatewayName)
    if not self.IsInitialized then return nil end
    return self.Config.Network.Gateways[gatewayName]
end

function DefaultProvider:VerifyKey(userKey)
    if not self.IsInitialized then return false end
    
    local success, realKey = Http.SafeGet(self.Config.Network.KeyServerUrl)
    if not success then return false end

    -- Sanitize both strings (remove spaces, newlines)
    realKey = string.gsub(realKey, "%s+", "")
    userKey = string.gsub(userKey, "%s+", "")

    return (userKey == realKey)
end

function DefaultProvider:Shutdown()
    self.IsInitialized = false
end

return DefaultProvider

