-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

local animIds = {
    ["rbxassetid://3638729053"] = true,
    ["rbxassetid://3638749874"] = true,
    ["rbxassetid://3638767427"] = true,
    ["rbxassetid://102357151005774"] = true
}

local char, hum, hand, punch, anim, hrp
local lastAttack, lastCache = 0, 0
local targets = {}

local function updateCache()
    char = lp.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        punch = char:FindFirstChild("Punch")
        anim = hum and char:FindFirstChildOfClass("Animator") or hum and hum:FindFirstChildOfClass("Animator")
        hrp = char:FindFirstChild("HumanoidRootPart")
    end
end

local function updateTargets()
    local count = 0
    for _, plr in ipairs(plrs:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if head and h and h.Health > 0 then
                count = count + 1
                targets[count] = {head, h}
            end
        end
    end
    for i = count + 1, #targets do
        targets[i] = nil
    end
end

updateCache()
updateTargets()

lp.CharacterAdded:Connect(function()
    task.wait(0.05)
    updateCache()
end)

plrs.PlayerAdded:Connect(updateTargets)
plrs.PlayerRemoving:Connect(updateTargets)

rs.Heartbeat:Connect(function()
    local t = os.clock()
    
    if t - lastCache >= 5 then
        updateTargets()
        lastCache = t
    end
    
    if t - lastAttack >= 0.01 then
        if not hrp or not hum or not hand then 
            updateCache() 
            return 
        end
        
        if not punch then
            local tool = lp.Backpack:FindFirstChild("Punch")
            if tool then hum:EquipTool(tool) end
            punch = char and char:FindFirstChild("Punch")
            if not punch then return end
        end
        
        punch.attackTime.Value = 0
        punch:Activate()
        
        for i = 1, #targets do
            local target = targets[i]
            if target[2].Health > 0 then
                firetouchinterest(target[1], hand, 0)
                firetouchinterest(target[1], hand, 1)
            end
        end
        
        if anim then
            local tracks = anim:GetPlayingAnimationTracks()
            for i = 1, #tracks do
                local trk = tracks[i]
                local id = trk.Animation and trk.Animation.AnimationId
                if id and animIds[id] then 
                    trk:Stop() 
                end
            end
        end
        
        lastAttack = t
    end
end)
