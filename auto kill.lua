-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

local animIds = {"rbxassetid://3638729053","rbxassetid://3638749874","rbxassetid://3638767427","rbxassetid://102357151005774"}
local conn

local function run()
    local char = lp.Character
    if not char then return end
    
    local punch = char:FindFirstChild("Punch")
    if not punch then
        local bp = lp.Backpack:FindFirstChild("Punch")
        if bp then char.Humanoid:EquipTool(bp) end
        return
    end
    
    punch.attackTime.Value = 0
    
    for _, plr in pairs(plrs:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character.Humanoid.Health > 0 then
            punch:Activate()
            pcall(firetouchinterest, plr.Character.HumanoidRootPart, char.LeftHand or char["Left Arm"], 0)
            pcall(firetouchinterest, plr.Character.HumanoidRootPart, char.LeftHand or char["Left Arm"], 1)
        end
    end
    
    local anim = char.Humanoid.Animator
    if anim then
        for _, trk in pairs(anim:GetPlayingAnimationTracks()) do
            trk:Stop()
        end
    end
end

if conn then conn:Disconnect() end
conn = rs.Stepped:Connect(run)

lp.CharacterAdded:Connect(function()
    if conn then conn:Disconnect() end
    conn = rs.Stepped:Connect(run)
end)
