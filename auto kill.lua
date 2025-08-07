-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

local function autokill()
    if lp.Character and lp.Character:FindFirstChild("Punch") then
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
            track:Stop()
        end
    elseif lp.Character and lp.Backpack:FindFirstChild("Punch") then
        lp.Character.Humanoid:EquipTool(lp.Backpack.Punch)
    end
end

rs.Heartbeat:Connect(autokill)
rs.Stepped:Connect(autokill)
rs.RenderStepped:Connect(autokill)

spawn(function()
    while true do
        autokill()
    end
end)
