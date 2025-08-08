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

local char, hum, hand, punch, anim, hrp, target, targetHum
local lastAttack = 0

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

local function setTarget(plr)
    if plr ~= lp and plr.Character then
        local rp = plr.Character:FindFirstChild("HumanoidRootPart")
        local h = plr.Character:FindFirstChildOfClass("Humanoid")
        if rp and h and h.Health > 0 then
            target = rp
            targetHum = h
        end
    end
end

local function clearTarget()
    target, targetHum = nil, nil
end

updateCache()
lp.CharacterAdded:Connect(function()
    task.wait(0.05)
    updateCache()
end)

plrs.PlayerAdded:Connect(setTarget)
plrs.PlayerRemoving:Connect(function(plr)
    if target and target.Parent == plr.Character then clearTarget() end
end)

rs.Heartbeat:Connect(function()
    local t = os.clock()
    if t - lastAttack >= 0.05 then
        if not hrp or not hum then updateCache() return end
        if not target or not target.Parent or not targetHum or targetHum.Health <= 0 then
            local closest, dist = nil, math.huge
            for _, plr in ipairs(plrs:GetPlayers()) do
                if plr ~= lp and plr.Character then
                    local rp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local h = plr.Character:FindFirstChildOfClass("Humanoid")
                    if rp and h and h.Health > 0 then
                        local d = (rp.Position - hrp.Position).Magnitude
                        if d < dist then
                            closest, dist = rp, d
                            targetHum = h
                        end
                    end
                end
            end
            target = closest
        end
        if target then
            if not punch then
                local tool = lp.Backpack:FindFirstChild("Punch")
                if tool then hum:EquipTool(tool) end
                punch = char:FindFirstChild("Punch")
            end
            if punch then
                punch.attackTime.Value = 0
                punch:Activate()
                firetouchinterest(target, hand, 0)
                firetouchinterest(target, hand, 1)
                if anim then
                    for _, trk in ipairs(anim:GetPlayingAnimationTracks()) do
                        local id = trk.Animation and trk.Animation.AnimationId
                        if id and animIds[id] then trk:Stop() end
                    end
                end
            end
        end
        lastAttack = t
    end
end)
