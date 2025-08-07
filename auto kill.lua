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

    if bp and hum then
        local tool = bp:FindFirstChild("Punch")
        if tool and not hum:IsEquipped(tool) then
            hum:EquipTool(tool)
            punch = tool
        end
    end
end

lp.CharacterAdded:Connect(setupChar)
if lp.Character then
    setupChar(lp.Character)
end

rs.Heartbeat:Connect(function()
    if hum then
        local a = hum:FindFirstChildOfClass("Animator")
        if a then
            for _, t in ipairs(a:GetPlayingAnimationTracks()) do
                if t.Animation and table.find(anims, t.Animation.AnimationId) then
                    t:Stop()
                    t:Destroy()
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

        if bp and hum then
            local tool = bp:FindFirstChild("Punch")
            if tool and not hum:IsEquipped(tool) then
                hum:EquipTool(tool)
                punch = tool
            end
        end

        if punch and punch:FindFirstChild("attackTime") then
            punch.attackTime.Value = 0
        end
    end
end)

rs.Stepped:Connect(function()
    if punch and punch.Parent and hand then
        punch.attackTime.Value = 0
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and p.Character then
                local thp = p.Character:FindFirstChild("HumanoidRootPart")
                local th = p.Character:FindFirstChild("Humanoid")
                if thp and th and th.Health > 0 then
                    punch:Activate()
                    firetouchinterest(thp, hand, 0)
                    firetouchinterest(thp, hand, 1)
                end
            end
        end
    end
end)
