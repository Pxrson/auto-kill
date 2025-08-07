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
    for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
        local a = track.Animation
        if a and table.find(punchAnims, a.AnimationId) then
            track:Stop(0)
            track:Destroy()
        end
    end
end

local function onCharAdded(char)
    local bp = plr:WaitForChild("Backpack")
    local hum = char:WaitForChild("Humanoid")
    local punchTool
    repeat
        task.wait(0.1)
        punchTool = bp:FindFirstChild("Punch")
        if punchTool then hum:EquipTool(punchTool) end
    until punchTool

    local punch = char:FindFirstChild("Punch") or punchTool
    if not punch then return end

    rs.Stepped:Connect(function()
        punch.attackTime.Value = 0
        stopPunchAnims(hum)
        
        for _, other in ipairs(plrs:GetPlayers()) do
            if other ~= plr and other.Character then
                local oh = other.Character:FindFirstChild("Humanoid")
                if oh and oh.Health > 0 then
                    punch:Activate()
                    oh.Health = 0
                end
            end
        end
    end)
end

plrs.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(onCharAdded) end)
plr.CharacterAdded:Connect(onCharAdded)
if plr.Character then onCharAdded(plr.Character) end
