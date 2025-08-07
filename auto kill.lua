-- discord: .pxrson
-- used a bit of ai for help DONT KILL ME OK IM SORRY
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local plr = plrs.LocalPlayer

local animIds = {
    "rbxassetid://3638729053",
    "rbxassetid://3638749874", 
    "rbxassetid://3638767427",
    "rbxassetid://102357151005774",
}

local conns = {}

local function stopAnims(hum)
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        local id = track.Animation.AnimationId
        for _, animId in pairs(animIds) do
            if id == animId then
                track:Stop()
                break
            end
        end
    end
end

local function cleanup()
    for _, conn in pairs(conns) do
        if conn then 
            pcall(function() conn:Disconnect() end)
        end
    end
    conns = {}
end

local function killPlayer(p, punch, hand)
    if not p or not p.Character then return end
    local h = p.Character:FindFirstChild("Humanoid")
    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    if h and h.Health > 0 and hrp then
        pcall(function()
            punch:Activate()
            firetouchinterest(hrp, hand, 0)
            firetouchinterest(hrp, hand, 1)
        end)
    end
end

local function onChar(char)
    if not char then return end
    
    cleanup()
    
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
    if not hand then return end
    
    local punch = char:FindFirstChild("Punch")
    if not punch then
        local tool = plr.Backpack:FindFirstChild("Punch")
        if tool then
            pcall(function() hum:EquipTool(tool) end)
        end
        return
    end
    
    conns.main = rs.Heartbeat:Connect(function()
        pcall(function()
            punch.attackTime.Value = 0
            
            local tool = hum:FindFirstChildOfClass("Tool")
            if not tool or tool.Name ~= "Punch" then
                local punchTool = plr.Backpack:FindFirstChild("Punch")
                if punchTool then
                    hum:EquipTool(punchTool)
                end
            end
            
            for _, p in pairs(plrs:GetPlayers()) do
                if p ~= plr then
                    killPlayer(p, punch, hand)
                end
            end
            
            stopAnims(hum)
        end)
    end)
    
    conns.playerAdded = plrs.PlayerAdded:Connect(function(newPlr)
        pcall(function()
            killPlayer(newPlr, punch, hand)
            
            newPlr.CharacterAdded:Connect(function(newChar)
                pcall(function()
                    killPlayer(newPlr, punch, hand)
                end)
            end)
        end)
    end)
    
    for _, p in pairs(plrs:GetPlayers()) do
        if p ~= plr then
            pcall(function()
                p.CharacterAdded:Connect(function(newChar)
                    pcall(function()
                        killPlayer(p, punch, hand)
                    end)
                end)
            end)
        end
    end
end

if plr.Character then 
    onChar(plr.Character) 
end

plr.CharacterAdded:Connect(onChar)

conns.checker = rs.Heartbeat:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Punch") and not conns.main then
        onChar(plr.Character)
    end
end)
