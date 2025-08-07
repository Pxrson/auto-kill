-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

local animIds = {"rbxassetid://3638729053","rbxassetid://3638749874","rbxassetid://3638767427","rbxassetid://102357151005774"}
local conn

local function run()
    if not lp.Character then return end
    local hum = lp.Character:FindFirstChild("Humanoid")
    local hand = lp.Character:FindFirstChild("LeftHand") or lp.Character:FindFirstChild("Left Arm")
    local punch = lp.Character:FindFirstChild("Punch") or lp.Backpack:FindFirstChild("Punch")
    
    if not hum or not hand then return end
    
    if punch and punch.Parent == lp.Backpack then
        hum:EquipTool(punch)
        punch = lp.Character:WaitForChild("Punch")
    end
    
    if not punch then return end
    
    if punch.attackTime then punch.attackTime.Value = 0 end
    
    for _, plr in pairs(plrs:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local tgtHum = plr.Character:FindFirstChild("Humanoid")
            local tgtRp = plr.Character:FindFirstChild("HumanoidRootPart")
            if tgtHum and tgtHum.Health > 0 and tgtRp then
                punch:Activate()
                pcall(firetouchinterest, tgtRp, hand, 0)
                pcall(firetouchinterest, tgtRp, hand, 1)
            end
        end
    end
    
    local anim = hum:FindFirstChild("Animator")
    if anim then
        for _, trk in pairs(anim:GetPlayingAnimationTracks()) do
            for _, id in pairs(animIds) do
                if trk.Animation and trk.Animation.AnimationId == id then
                    trk:Stop()
                end
            end
        end
    end
end

if conn then conn:Disconnect() end
conn = rs.Stepped:Connect(run)

lp.CharacterAdded:Connect(function()
    if conn then conn:Disconnect() end
    conn = rs.Stepped:Connect(run)
end)
