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

local char, hum, hand, punch, anim, hrp, cached, lastAtk, lastCache = nil,nil,nil,nil,nil,nil,{},0,0

local function cacheChar()
    char = lp.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        punch = char:FindFirstChild("Punch")
        anim = hum and (char:FindFirstChildOfClass("Animator") or hum:FindFirstChildOfClass("Animator"))
        hrp = char:FindFirstChild("HumanoidRootPart")
    end
end

local function cachePlayers()
    cached = {}
    for _, p in ipairs(plrs:GetPlayers()) do
        if p ~= lp then table.insert(cached, p) end
    end
end

cacheChar()
cachePlayers()

lp.CharacterAdded:Connect(function() task.wait(0.1) cacheChar() end)
plrs.PlayerAdded:Connect(cachePlayers)
plrs.PlayerRemoving:Connect(cachePlayers)

rs.Heartbeat:Connect(function()
    local t = os.clock()
    if t - lastCache > 3 then cachePlayers() lastCache = t end
    if t - lastAtk >= 0.05 then
        if not hrp or not hum or not hand then cacheChar() return end
        if not punch then
            local tool = lp.Backpack:FindFirstChild("Punch")
            if tool then hum:EquipTool(tool) end
            punch = char and char:FindFirstChild("Punch")
            if not punch then return end
        end
        punch.attackTime.Value = 0
        punch:Activate()
        for _, p in ipairs(cached) do
            local pc = p.Character
            if pc then
                local head = pc:FindFirstChild("Head")
                local h = pc:FindFirstChildOfClass("Humanoid")
                if head and h and h.Health > 0 then
                    firetouchinterest(head, hand, 0)
                    firetouchinterest(head, hand, 1)
                end
            end
        end
        if anim then
            for _, trk in ipairs(anim:GetPlayingAnimationTracks()) do
                local id = trk.Animation and trk.Animation.AnimationId
                if id and animIds[id] then trk:Stop() end
            end
        end
        lastAtk = t
    end
end)
