-- discord: .pxrson
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local punchIds = {
    "rbxassetid://3638729053",
    "rbxassetid://3638749874",
    "rbxassetid://3638767427",
    "rbxassetid://102357151005774",
}

local function stopPunchAnims(hum)
    local anim = hum:FindFirstChildOfClass("Animator")
    if anim then
        for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
            local id = track.Animation and track.Animation.AnimationId
            if id and table.find(punchIds, id) then
                track:Stop()
                track:Destroy()
            end
        end
    end

    local tool = hum.Parent:FindFirstChild("Punch")
    if tool then
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("Animation") and table.find(punchIds, obj.AnimationId) then
                obj:Destroy()
            end
        end
    end
end

local function killLoop(punch, hand)
    RunService.Heartbeat:Connect(function()
        punch.attackTime.Value = 0
    end)

    RunService.Stepped:Connect(function()
        punch.attackTime.Value = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Character then
                local hum = plr.Character:FindFirstChild("Humanoid")
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    punch:Activate()
                    firetouchinterest(hrp, hand, 0)
                    firetouchinterest(hrp, hand, 1)
                end
            end
        end
    end)
end

local function onCharAdded(char)
    local bp = lp:WaitForChild("Backpack")
    local hum = char:WaitForChild("Humanoid")
    local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")

    local function equip()
        local tool = bp:FindFirstChild("Punch")
        if tool then
            hum:EquipTool(tool)
        end
    end

    repeat
        task.wait(0.1)
        equip()
    until char:FindFirstChild("Punch")

    local punch = char:FindFirstChild("Punch") or bp:FindFirstChild("Punch")
    if not punch or not hand then return end
    punch.attackTime.Value = 0

    RunService.Heartbeat:Connect(function()
        stopPunchAnims(hum)
        local current = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
        local tool = bp:FindFirstChild("Punch") or lp.Character:FindFirstChild("Punch")
        if current and current.Name ~= "Punch" and tool then
            hum:EquipTool(tool)
        end
    end)

    killLoop(punch, hand)
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(onCharAdded)
end)

lp.CharacterAdded:Connect(onCharAdded)
if lp.Character then onCharAdded(lp.Character) end
