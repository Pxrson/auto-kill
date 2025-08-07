-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

spawn(function()
    while true do
        rs.Heartbeat:Wait()
        if lp.Character then
            if not lp.Character:FindFirstChild("Punch") then
                local tool = lp.Backpack:FindFirstChild("Punch")
                if tool then
                    lp.Character.Humanoid:EquipTool(tool)
                end
            else
                local punch = lp.Character.Punch
                local hand = lp.Character:FindFirstChild("LeftHand") or lp.Character:FindFirstChild("Left Arm")
                
                punch.attackTime.Value = 0
                
                for _, p in pairs(plrs:GetPlayers()) do
                    if p ~= lp and p.Character and p.Character.Humanoid.Health > 0 then
                        punch:Activate()
                        firetouchinterest(p.Character.HumanoidRootPart, hand, 0)
                        firetouchinterest(p.Character.HumanoidRootPart, hand, 1)
                    end
                end
                
                for _, track in pairs(lp.Character.Humanoid.Animator:GetPlayingAnimationTracks()) do
                    if track.Animation then
                        local id = track.Animation.AnimationId
                        if id == "rbxassetid://3638729053" or id == "rbxassetid://3638749874" or id == "rbxassetid://3638767427" or id == "rbxassetid://102357151005774" then
                            track:Stop()
                        end
                    end
                end
            end
        end
    end
end)
