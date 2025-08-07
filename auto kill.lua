-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

rs.Heartbeat:Connect(function()
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("Punch") then
            local punch = lp.Character.Punch
            local hand = lp.Character:FindFirstChild("LeftHand") or lp.Character["Left Arm"]
            punch.attackTime.Value = 0
            
            for _, plr in pairs(plrs:GetPlayers()) do
                if plr ~= lp and plr.Character and plr.Character.Humanoid.Health > 0 then
                    punch:Activate()
                    firetouchinterest(plr.Character.HumanoidRootPart, hand, 0)
                    firetouchinterest(plr.Character.HumanoidRootPart, hand, 1)
                end
            end
            
            for _, trk in pairs(lp.Character.Humanoid.Animator:GetPlayingAnimationTracks()) do
                if trk.Animation then
                    local id = trk.Animation.AnimationId
                    if id:find("3638729053") or id:find("3638749874") or id:find("3638767427") or id:find("102357151005774") then
                        trk:Stop()
                    end
                end
            end
        elseif lp.Character and lp.Backpack:FindFirstChild("Punch") then
            lp.Character.Humanoid:EquipTool(lp.Backpack.Punch)
        end
    end)
end)

rs.Stepped:Connect(function() -- second one so this bitch doesnt stop
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("Punch") then
            local punch = lp.Character.Punch
            local hand = lp.Character:FindFirstChild("LeftHand") or lp.Character["Left Arm"]
            punch.attackTime.Value = 0
            
            for _, plr in pairs(plrs:GetPlayers()) do
                if plr ~= lp and plr.Character and plr.Character.Humanoid.Health > 0 then
                    punch:Activate()
                    firetouchinterest(plr.Character.HumanoidRootPart, hand, 0)
                    firetouchinterest(plr.Character.HumanoidRootPart, hand, 1)
                end
            end
        end
    end)
end)
