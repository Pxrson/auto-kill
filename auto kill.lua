-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

local anims = {
    "rbxassetid://3638729053",
    "rbxassetid://3638749874",
    "rbxassetid://3638767427",
    "rbxassetid://102357151005774",
}

local hum, punch, hand, bp

local function setupChar(c)
    hum = c:WaitForChild("Humanoid")
    bp = lp:WaitForChild("Backpack")
    hand = c:FindFirstChild("LeftHand") or c:FindFirstChild("Left Arm")
    punch = c:FindFirstChild("Punch") or bp:FindFirstChild("Punch")
    if punch and punch:FindFirstChild("attackTime") then
        punch.attackTime.Value = 0
    end
    if punch and hum and not hum:IsEquipped(punch) then
        hum:EquipTool(punch)
    end
end

lp.CharacterAdded:Connect(setupChar)
if lp.Character then setupChar(lp.Character) end

rs.Heartbeat:Connect(function()
    if not hum or not bp then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track.Animation and table.find(anims, track.Animation.AnimationId) then
                track:Stop()
                track:Destroy()
            end
        end
    end
    local tool = hum.Parent and hum.Parent:FindFirstChild("Punch")
    if tool then
        for _, anim in ipairs(tool:GetDescendants()) do
            if anim:IsA("Animation") and table.find(anims, anim.AnimationId) then
                anim:Destroy()
            end
        end
    end
    local toolInBp = bp:FindFirstChild("Punch")
    if toolInBp and not hum:IsEquipped(toolInBp) then
        hum:EquipTool(toolInBp)
        punch = toolInBp
    end
    if punch and punch:FindFirstChild("attackTime") then
        punch.attackTime.Value = 0
    end
end)

rs.Stepped:Connect(function()
    if punch and punch.Parent and hand then
        punch.attackTime.Value = 0
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    punch:Activate()
                    firetouchinterest(hrp, hand, 0)
                    firetouchinterest(hrp, hand, 1)
                end
            end
        end
    end
end)
