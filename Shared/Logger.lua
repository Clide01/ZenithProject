-- ==============================================================================
-- PROJECT ZENITH: LOGGER (Logger.lua)
-- ==============================================================================
return {
    Info = function(msg) print("[ZENITH - INFO] " .. tostring(msg)) end,
    Warn = function(msg) warn("[ZENITH - WARN] " .. tostring(msg)) end,
    Error = function(msg) error("[ZENITH - ERROR] " .. tostring(msg)) end
}

