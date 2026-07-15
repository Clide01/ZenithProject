-- ==============================================================================
-- PROJECT ZENITH: HTTP WRAPPER (Http.lua)
-- ==============================================================================
return {
    -- Safely executes GET requests without crashing executors on blocked connections
    SafeGet = function(url)
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success and type(result) == "string" then
            return true, result
        end
        return false, "Connection Failed"
    end
}

