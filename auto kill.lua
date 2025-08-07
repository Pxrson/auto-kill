-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer
local animIds = {"rbxassetid://3638729053","rbxassetid://3638749874","rbxassetid://3638767427","rbxassetid://102357151005774"}

local char, hum, hand, punch, anim
local targets = {}
local lastUpdate = 0

local function updateCache()
    char = lp.Character
    if char then
        hum = char:FindFirstChild("Humanoid")
        hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        punch = char:FindFirstChild("Punch")
        anim = hum and hum:FindFirstChild("Animator")
    end
end

local function updateTargets()
    targets = {}
    for _, plr in pairs(plrs:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local tgtHum = plr.Character:FindFirstChild("Humanoid")
            local tgtRp = plr.Character:FindFirstChild("HumanoidRootPart")
            if tgtHum and tgtHum.Health > 0 and tgtRp then
                targets[#targets + 1] = {plr = plr, rp = tgtRp}
            end
        end
    end
end

local function autokill()
    local tick = os.clock()
    
    if tick - lastUpdate > 0.1 then
        updateCache()
        updateTargets()
        lastUpdate = tick
    end
    
    if not punch then
        local tool = lp.Backpack:FindFirstChild("Punch")
        if tool and hum then
            hum:EquipTool(tool)
        end
        return
    end
    
    punch.attackTime.Value = 0
    
    for i = 1, #targets do
        local target = targets[i]
        punch:Activate()
        firetouchinterest(target.rp, hand, 0)
        firetouchinterest(target.rp, hand, 1)
    end
    
    if anim then
        for _, trk in pairs(anim:GetPlayingAnimationTracks()) do
            for _, id in pairs(animIds) do
                if trk.Animation and trk.Animation.AnimationId == id then
                    trk:Stop()
                    break
                end
            end
        end
    end
end

updateCache()
rs.Heartbeat:Connect(autokill)

lp.CharacterAdded:Connect(function()
    wait(0.1)
    updateCache()
end)
