-- ==============================================================================
-- PROJECT ZENITH: CONFIGURATION (Config.lua)
-- ==============================================================================
return {
    Project = {
        Name = "PROJECT ZENITH",
        Subtitle = "Secure Multi-Network Gateway",
        Version = "v2.0",
        DiscordUrl = "https://discord.gg/zenithhub",
    },
    
    Window = {
        Size = UDim2.new(0, 430, 0, 290),
        Offset = UDim2.new(0.5, -215, 0.5, -145),
        ClosedSize = UDim2.new(0, 380, 0, 240),
        ClosedOffset = UDim2.new(0.5, -190, 0.5, -120),
    },

    Theme = {
        Bg = Color3.fromRGB(13, 16, 23),
        Panel = Color3.fromRGB(23, 27, 37),
        Input = Color3.fromRGB(36, 42, 54),
        Border = Color3.fromRGB(48, 56, 74),
        AccentBlue = Color3.fromRGB(74, 140, 255),
        AccentBlueHover = Color3.fromRGB(107, 165, 255),
        Green = Color3.fromRGB(54, 214, 122),
        Red = Color3.fromRGB(255, 93, 93),
        Text = Color3.fromRGB(255, 255, 255),
        TextSec = Color3.fromRGB(140, 145, 160)
    },

    Network = {
        DefaultProvider = "LootLabs",
        -- RAW GitHub URL containing the daily access key
        KeyServerUrl = "https://raw.githubusercontent.com/Clide01/zenithHub-sniper-arena/refs/heads/main/current_key.txt",
        -- Obfuscated Core Engine URL
        Stage2Url = "https://raw.githubusercontent.com/Clide01/zenithHub-sniper-arena/refs/heads/main/ZenithEngine_obf.lua",
        -- Gateway Routing
        Gateways = {
            ["LootLabs"] = "https://loot-link.com/YOUR_LOOTLABS_LINK",
            ["Work.ink"] = "https://work.ink/YOUR_WORKINK_LINK",
            ["Linkvertise"] = "https://linkvertise.com/YOUR_LINKVERTISE_LINK"
        }
    }
}
