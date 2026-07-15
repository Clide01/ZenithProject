-- ==============================================================================
-- PROJECT ZENITH: PROVIDER INTERFACE (IProvider.lua)
-- ==============================================================================
-- All providers MUST implement these methods.
local IProvider = {}
IProvider.__index = IProvider

function IProvider.new()
    return setmetatable({}, IProvider)
end

function IProvider:Initialize(config, httpModule) error("Not implemented") end
function IProvider:GenerateLink(gatewayName) error("Not implemented") end
function IProvider:VerifyKey(userKey) error("Not implemented") end
function IProvider:Shutdown() error("Not implemented") end

return IProvider

