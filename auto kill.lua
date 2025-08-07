-- discord: .pxrson
local rs = game:GetService("RunService")
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer

local punchAnims = {
    "rbxassetid://3638729053",
    "rbxassetid://3638749874",
    "rbxassetid://3638767427",
    "rbxassetid://102357151005774",
}

local function stopPunchAnims(hum)
    if not hum then return end
    local anim = hum:FindFirstChildOfClass("Animator")
    if not anim then return end
    local tracks = anim:GetPlayingAnimationTracks()
    for i = #tracks, 1, -1 do
        local track = tracks[i]
        local anim = track.Animation
        if anim and table.find(punchAnims, anim.AnimationId) then
            track:Stop(0)
            track:Destroy()
        end
    end
end

local function onCharAdded(char)
    local bp = plr:WaitForChild("Backpack")
    local hum = char:WaitForChild("Humanoid")
    local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
    local punchTool

    repeat
        task.wait(0.05)
        punchTool = bp:FindFirstChild("Punch")
        if punchTool then
            hum:EquipTool(punchTool)
        end
    until punchTool

    local punch = char:FindFirstChild("Punch") or punchTool
    if not punch or not hand then return end
    
    punch.attackTime.Value = 0

    rs.Heartbeat:Connect(function()       
        local curTool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")

        if curTool and curTool.Name ~= "Punch" and punchTool then
            curTool.Parent = bp
            hum:EquipTool(punchTool)
        elseif not curTool and punchTool then
            hum:EquipTool(punchTool)
        end
        
        punch.attackTime.Value = 0
    end)

    rs.Stepped:Connect(function()
        punch.attackTime.Value = 0
        stopPunchAnims(hum)
        for _, otherPlr in ipairs(plrs:GetPlayers()) do
            if otherPlr ~= plr and otherPlr.Character then
                local targetHum = otherPlr.Character:FindFirstChild("Humanoid")
                if targetHum and targetHum.Health > 0 then
                    punch:Activate()
                    targetHum.Health = 0
                end
            end
        end
    end)
end

plrs.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(onCharAdded)
end)

plr.CharacterAdded:Connect(onCharAdded)

if plr.Character then
    onCharAdded(plr.Character)
end
