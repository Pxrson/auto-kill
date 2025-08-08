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
local attackCooldown = 0.01
local cachedPlayers = {}
local lastPlayerUpdate = 0
local playerUpdateInterval = 0.01

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

local function updatePlayerCache()
    cachedPlayers = {}
    for _, plr in ipairs(plrs:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if head and h and h.Health > 0 then
                table.insert(cachedPlayers, {head = head, humanoid = h})
            end
        end
    end
end

updateCache()
updatePlayerCache()

lp.CharacterAdded:Connect(function()
    task.wait(0.01)
    updateCache()
end)

plrs.PlayerAdded:Connect(function()
    task.wait(0.01)
    updatePlayerCache()
end)
plrs.PlayerRemoving:Connect(function()
    updatePlayerCache()
end)

rs.Heartbeat:Connect(function()
    local t = os.clock()
    if t - lastPlayerUpdate >= playerUpdateInterval then
        updatePlayerCache()
        lastPlayerUpdate = t
    end
    if t - lastAttack >= attackCooldown then
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
        for i = #cachedPlayers, 1, -1 do
            local playerData = cachedPlayers[i]
            if playerData.head and playerData.head.Parent and playerData.humanoid.Health > 0 then
                firetouchinterest(playerData.head, hand, 0)
                firetouchinterest(playerData.head, hand, 1)
            else
                table.remove(cachedPlayers, i)
            end
        end
        if anim then
            for _, trk in ipairs(anim:GetPlayingAnimationTracks()) do
                local id = trk.Animation and trk.Animation.AnimationId
                if id and animIds[id] then 
                    trk:Stop() 
                end
            end
        end
        lastAttack = t
    end
end)
