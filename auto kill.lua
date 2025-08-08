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
local lastAttack = 0
local lastTargetUpdate = 0
local validTargets = {}

local function updateCache()
    char = lp.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        punch = char:FindFirstChild("Punch")
        anim = hum and (char:FindFirstChildOfClass("Animator") or hum:FindFirstChildOfClass("Animator"))
        hrp = char:FindFirstChild("HumanoidRootPart")
    end
end

local function updateTargets()
    validTargets = {}
    for _, plr in ipairs(plrs:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if head and h and h.Health > 0 then
                table.insert(validTargets, {head, h})
            end
        end
    end
end

local function attack()
    local t = os.clock()
    if t - lastAttack < 0.1 then return end
    
    if not (hrp and hum and hand) then 
        updateCache()
        return 
    end
    
    if not punch then
        local tool = lp.Backpack:FindFirstChild("Punch")
        if tool then hum:EquipTool(tool) end
        punch = char and char:FindFirstChild("Punch")
        if not punch then return end
    end
    
    if t - lastTargetUpdate > 0.5 then
        updateTargets()
        lastTargetUpdate = t
    end
    
    if punch.attackTime then punch.attackTime.Value = 0 end
    punch:Activate()
    
    for _, target in ipairs(validTargets) do
        if target[1] and target[2].Health > 0 then
            firetouchinterest(target[1], hand, 0)
            firetouchinterest(target[1], hand, 1)
        end
    end
    
    if anim then
        for _, trk in ipairs(anim:GetPlayingAnimationTracks()) do
            local id = trk.Animation and trk.Animation.AnimationId
            if id and animIds[id] then trk:Stop() end
        end
    end
    
    lastAttack = t
end

updateCache()

lp.CharacterAdded:Connect(function()
    task.wait(0.1)
    updateCache()
    validTargets = {}
    lastTargetUpdate = 0
end)

rs.Heartbeat:Connect(attack)
