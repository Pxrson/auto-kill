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

local char, hum, hand, punch, anim, hrp, cached = nil,nil,nil,nil,nil,nil,{}
local lastAtk, lastCache, lastToolCheck = 0, 0, 0
local cachedPlayers = {}

local function cachePlayers()
    table.clear(cachedPlayers)
    for _, p in ipairs(plrs:GetPlayers()) do
        if p ~= lp and p.Character then
            cachedPlayers[p] = p.Character
        end
    end
end

local function cacheChar()
    char = lp.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        punch = char:FindFirstChild("Punch")
        anim = hum and (char:FindFirstChildOfClass("Animator") or hum:FindFirstChildOfClass("Animator"))
        hrp = char:FindFirstChild("HumanoidRootPart")
    else
        hum, hand, punch, anim, hrp = nil, nil, nil, nil, nil
    end
end

cacheChar()
cachePlayers()

lp.CharacterAdded:Connect(function() 
    task.wait(0.1) 
    cacheChar() 
    cachePlayers()
end)

plrs.PlayerAdded:Connect(cachePlayers)
plrs.PlayerRemoving:Connect(cachePlayers)

rs.Heartbeat:Connect(function()
    local t = os.clock()
    
    if t - lastCache > 5 then 
        cachePlayers() 
        lastCache = t 
    end
    
    if t - lastAtk >= 0.05 then
        if not char or not hum or not hand or not hrp then 
            cacheChar() 
            return 
        end
        
        if not punch and t - lastToolCheck > 0.5 then
            local tool = lp.Backpack:FindFirstChild("Punch")
            if tool then 
                hum:EquipTool(tool) 
                task.wait(0.1)
                punch = char:FindFirstChild("Punch")
            end
            lastToolCheck = t
        end
        
        if not punch then return end
        
        punch.attackTime.Value = 0
        punch:Activate()
        
        for player, character in pairs(cachedPlayers) do
            if player.Parent and character.Parent then
                local head = character:FindFirstChild("Head")
                local h = character:FindFirstChildOfClass("Humanoid")
                
                if head and h and h.Health > 0 then
                    firetouchinterest(head, hand, 0)
                    firetouchinterest(head, hand, 1)
                end
            else
                cachedPlayers[player] = nil
            end
        end
        
        if anim then
            local tracks = anim:GetPlayingAnimationTracks()
            for i = 1, #tracks do
                local trk = tracks[i]
                local animation = trk.Animation
                if animation then
                    local id = animation.AnimationId
                    if animIds[id] then 
                        trk:Stop() 
                    end
                end
            end
        end
        
        lastAtk = t
    end
end)
