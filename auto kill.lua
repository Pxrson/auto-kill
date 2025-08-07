-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

local punchAnims = {
    "rbxassetid://3638729053",
    "rbxassetid://3638749874",
    "rbxassetid://3638767427",
    "rbxassetid://102357151005774",
}

local hum, punch, hand, bp

local function stopAnims(humanoid)
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track.Animation and table.find(punchAnims, track.Animation.AnimationId) then
                track:Stop()
                track:Destroy()
            end
        end
    end
    local tool = humanoid.Parent:FindFirstChild("Punch")
    if tool then
        for _, anim in ipairs(tool:GetDescendants()) do
            if anim:IsA("Animation") and table.find(punchAnims, anim.AnimationId) then
                anim:Destroy()
            end
        end
    end
end

local function equipPunch()
    if bp and hum then
        local tool = bp:FindFirstChild("Punch")
        if tool and not hum:IsEquipped(tool) then
            hum:EquipTool(tool)
        end
    end
end

local function initChar(char)
    hum = char:WaitForChild("Humanoid")
    bp = lp:WaitForChild("Backpack")
    hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
    punch = char:FindFirstChild("Punch") or bp:FindFirstChild("Punch")
    if punch and punch:FindFirstChild("attackTime") then
        punch.attackTime.Value = 0
    end
    equipPunch()
end

lp.CharacterAdded:Connect(initChar)
if lp.Character then
    initChar(lp.Character)
end

rs.Heartbeat:Connect(function()
    if hum then
        stopAnims(hum)
        equipPunch()
        if punch and punch:FindFirstChild("attackTime") then
            punch.attackTime.Value = 0
        end
    end
end)

rs.Stepped:Connect(function()
    if punch and punch.Parent and hand then
        punch.attackTime.Value = 0
        for _, plr in ipairs(plrs:GetPlayers()) do
            if plr ~= lp and plr.Character then
                local th = plr.Character:FindFirstChild("HumanoidRootPart")
                if th then
                    punch:Activate()
                    firetouchinterest(th, hand, 0)
                    firetouchinterest(th, hand, 1)
                end
            end
        end
    end
end)
