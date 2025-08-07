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
local running = false

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
    running = false
    for _, conn in pairs(conns) do
        if conn then conn:Disconnect() end
    end
    conns = {}
end

local function onChar(char)
    cleanup()
    
    local hum = char:WaitForChild("Humanoid")
    local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
    if not hand then return end
    
    local punch
    repeat
        punch = char:FindFirstChild("Punch")
        if not punch then
            local tool = plr.Backpack:FindFirstChild("Punch")
            if tool then
                hum:EquipTool(tool)
            end
            rs.Heartbeat:Wait()
        end
    until punch
    
    running = true
    conns.main = rs.Heartbeat:Connect(function()
        punch.attackTime.Value = 0
        
        local tool = hum:FindFirstChildOfClass("Tool")
        if not tool or tool.Name ~= "Punch" then
            local punchTool = plr.Backpack:FindFirstChild("Punch")
            if punchTool then
                hum:EquipTool(punchTool)
            end
        end
        
        for _, p in pairs(plrs:GetPlayers()) do
            if p ~= plr and p.Character then
                local h = p.Character:FindFirstChild("Humanoid")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if h and h.Health > 0 and hrp then
                    punch:Activate()
                    firetouchinterest(hrp, hand, 0)
                    firetouchinterest(hrp, hand, 1)
                end
            end
        end
        
        stopAnims(hum)
    end)
    
    conns.playerAdded = plrs.PlayerAdded:Connect(function(newPlr)
        if newPlr.Character then
            local h = newPlr.Character:FindFirstChild("Humanoid")
            local hrp = newPlr.Character:FindFirstChild("HumanoidRootPart")
            if h and h.Health > 0 and hrp then
                punch:Activate()
                firetouchinterest(hrp, hand, 0)
                firetouchinterest(hrp, hand, 1)
            end
        end
        
        newPlr.CharacterAdded:Connect(function(newChar)
            rs.Heartbeat:Wait()
            local h = newChar:FindFirstChild("Humanoid")
            local hrp = newChar:FindFirstChild("HumanoidRootPart")
            if h and h.Health > 0 and hrp then
                punch:Activate()
                firetouchinterest(hrp, hand, 0)
                firetouchinterest(hrp, hand, 1)
            end
        end)
    end)
    
    for _, p in pairs(plrs:GetPlayers()) do
        if p ~= plr and p.Character then
            p.CharacterAdded:Connect(function(newChar)
                rs.Heartbeat:Wait()
                local h = newChar:FindFirstChild("Humanoid")
                local hrp = newChar:FindFirstChild("HumanoidRootPart")
                if h and h.Health > 0 and hrp then
                    punch:Activate()
                    firetouchinterest(hrp, hand, 0)
                    firetouchinterest(hrp, hand, 1)
                end
            end)
        end
    end
end

if plr.Character then 
    onChar(plr.Character) 
end

plr.CharacterAdded:Connect(onChar)

spawn(function()
    while true do
        rs.Heartbeat:Wait()
        if not running and plr.Character and plr.Character:FindFirstChild("Punch") then
            onChar(plr.Character)
        end
    end
end)
