-- ==============================================================================
-- PROJECT ZENITH: ANIMATION HELPER (Animation.lua)
-- ==============================================================================
local TweenService = game:GetService("TweenService")

return {
    -- Generic hover event binder for UI elements
    BindHover = function(instance, enterProps, leaveProps, duration)
        duration = duration or 0.2
        instance.MouseEnter:Connect(function()
            TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), enterProps):Play()
        end)
        instance.MouseLeave:Connect(function()
            TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), leaveProps):Play()
        end)
    end,
    
    -- Generic pulse/flash animation
    Flash = function(instance, propsOut, propsIn)
        TweenService:Create(instance, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), propsOut):Play()
        task.wait(0.05)
        TweenService:Create(instance, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), propsIn):Play()
    end
}

