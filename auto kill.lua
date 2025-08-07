-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

spawn(function()
    while true do
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
                trk:Stop()
            end
        elseif lp.Character and lp.Backpack:FindFirstChild("Punch") then
            lp.Character.Humanoid:EquipTool(lp.Backpack.Punch)
        end
    end
end)

spawn(function() -- backup so ts bih dont stop
    while true do
        if lp.Character and lp.Character:FindFirstChild("Punch") then
            local punch = lp.Character.Punch
            local hand = lp.Character:FindFirstChild("LeftHand") or lp.Character["Left Arm"]
            
            for _, plr in pairs(plrs:GetPlayers()) do
                if plr ~= lp and plr.Character and plr.Character.Humanoid.Health > 0 then
                    punch:Activate()
                    firetouchinterest(plr.Character.HumanoidRootPart, hand, 0)
                    firetouchinterest(plr.Character.HumanoidRootPart, hand, 1)
                end
            end
        end
    end
end)
