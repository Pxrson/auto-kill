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
local char, hum, hand, punch, anim
local players = {}

local function updateCache()
    char = lp.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        punch = char:FindFirstChild("Punch")
        anim = hum and char:FindFirstChildOfClass("Animator") or hum and hum:FindFirstChildOfClass("Animator")
    end
end

updateCache()

for _, p in ipairs(plrs:GetPlayers()) do
    if p ~= lp then players[#players+1] = p end
end

plrs.PlayerAdded:Connect(function(p) 
    players[#players+1] = p
end)
plrs.PlayerRemoving:Connect(function(p)
    for i = #players, 1, -1 do
        if players[i] == p then
            table.remove(players, i)
            break
        end
    end
end)

lp.CharacterAdded:Connect(updateCache)

rs.Heartbeat:Connect(function()
    if not hum or not hand then 
        updateCache() 
        return 
    end
    
    if not punch then
        local tool = lp.Backpack:FindFirstChild("Punch")
        if tool then 
            hum:EquipTool(tool)
            punch = tool
        else
            return
        end
    end
    
    punch.attackTime.Value = 0
    punch:Activate()
    
    for i = 1, #players do
        local plr = players[i]
        if plr.Character then
            local target = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso")
            if target then
                firetouchinterest(target, hand, 0)
                firetouchinterest(target, hand, 1)
            end
        end
    end
    
    if anim then
        local tracks = anim:GetPlayingAnimationTracks()
        for i = 1, #tracks do
            local track = tracks[i]
            if track.Animation and animIds[track.Animation.AnimationId] then 
                track:Stop() 
            end
        end
    end
end)
