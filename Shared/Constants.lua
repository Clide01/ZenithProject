-- ==============================================================================
-- PROJECT ZENITH: SHARED CONSTANTS (Constants.lua)
-- ==============================================================================
return {
    States = {
        Ready = "Ready",
        Generating = "Generating gateway...",
        Waiting = "Waiting for key...",
        Verifying = "Authenticating...",
        Authenticated = "Access granted. Initializing...",
        Failed = "Access denied. Invalid signature.",
        Error = "System Error. Check console."
    },
    Security = {
        HandshakeToken = "Z3N1TH_M4ST3R_C0D3_9982"
    }
}
