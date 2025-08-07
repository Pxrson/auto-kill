-- discord: .pxrson
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")

local lp = plrs.LocalPlayer

local pids = {
    "rbxassetid://3638729053",
    "rbxassetid://3638749874",
    "rbxassetid://3638767427",
    "rbxassetid://102357151005774",
}

local function stopanims(h)
    local a = h:FindFirstChildOfClass("Animator")
    if a then
        for _, t in ipairs(a:GetPlayingAnimationTracks()) do
            local aid = t.Animation and t.Animation.AnimationId
            if aid and table.find(pids, aid) then
                t:Stop()
                t:Destroy()
            end
        end
    end
    local tool = h.Parent:FindFirstChild("Punch")
    if tool then
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("Animation") and table.find(pids, obj.AnimationId) then
                obj:Destroy()
            end
        end
    end
end

local function onchar(c)
    local bp = lp:WaitForChild("Backpack")
    local h = c:WaitForChild("Humanoid")
    local hand = c:FindFirstChild("LeftHand") or c:FindFirstChild("Left Arm")

    repeat
        task.wait(0.1)
        local punch = bp:FindFirstChild("Punch")
        if punch then
            h:EquipTool(punch)
        end
    until c:FindFirstChild("Punch")

    local punch = c:FindFirstChild("Punch") or bp:FindFirstChild("Punch")
    if not punch or not hand then return end

    if punch:FindFirstChild("attackTime") then
        punch.attackTime.Value = 0
    end

    rs.Heartbeat:Connect(function()
        stopanims(h)
        local curr = c:FindFirstChildOfClass("Tool")
        local punchtool = bp:FindFirstChild("Punch") or c:FindFirstChild("Punch")
        if (not curr or curr.Name ~= "Punch") and punchtool and punchtool.Parent == bp then
            h:EquipTool(punchtool)
        end
    end)

    rs.Heartbeat:Connect(function()
        if punch and punch:FindFirstChild("attackTime") then
            punch.attackTime.Value = 0
        end
    end)

    rs.Stepped:Connect(function()
        if not punch or not punch.Parent then return end
        if punch:FindFirstChild("attackTime") then
            punch.attackTime.Value = 0
        end
        for _, plr in ipairs(plrs:GetPlayers()) do
            if plr ~= lp and plr.Character then
                local th = plr.Character:FindFirstChild("Humanoid")
                local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if th and thrp and th.Health > 0 then
                    punch:Activate()
                    firetouchinterest(thrp, hand, 0)
                    firetouchinterest(thrp, hand, 1)
                end
            end
        end
    end)
end

plrs.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(onchar)
end)

lp.CharacterAdded:Connect(onchar)
if lp.Character then
    onchar(lp.Character)
end
