-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

local conn

local function run()
    if not lp.Character then return end
    
    local equippedTool = lp.Character:FindFirstChildOfClass("Tool")
    if not equippedTool or equippedTool.Name ~= "Punch" then
        local punch = lp.Backpack:FindFirstChild("Punch")
        if punch then
            lp.Character.Humanoid:EquipTool(punch)
        end
        return
    end
    
    local punch = equippedTool
    punch.attackTime.Value = 0
    
    local hand = lp.Character:FindFirstChild("LeftHand") or lp.Character:FindFirstChild("Left Arm")
    
    for _, plr in pairs(plrs:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            if plr.Character.Humanoid.Health > 0 then
                punch:Activate()
                pcall(firetouchinterest, plr.Character.HumanoidRootPart, hand, 0)
                pcall(firetouchinterest, plr.Character.HumanoidRootPart, hand, 1)
            end
        end
    end
    
    pcall(function()
        for _, trk in pairs(lp.Character.Humanoid.Animator:GetPlayingAnimationTracks()) do
            for _, id in pairs({"rbxassetid://3638729053","rbxassetid://3638749874","rbxassetid://3638767427","rbxassetid://102357151005774"}) do
                if trk.Animation and trk.Animation.AnimationId == id then
                    trk:Stop()
                end
            end
        end
    end)
end

if conn then conn:Disconnect() end
conn = rs.Heartbeat:Connect(run)

lp.CharacterAdded:Connect(function()
    wait()
    if conn then conn:Disconnect() end
    conn = rs.Heartbeat:Connect(run)
end)
