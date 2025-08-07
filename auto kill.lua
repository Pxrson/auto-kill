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
end

lp.CharacterAdded:Connect(setupChar)
if lp.Character then
    setupChar(lp.Character)
end

local function stopAndEquip()
    if not hum or not bp then return end
    local anim = hum:FindFirstChildOfClass("Animator")
    if anim then
        for _, t in ipairs(anim:GetPlayingAnimationTracks()) do
            if t.Animation and table.find(anims, t.Animation.AnimationId) then
                t:Stop()
                t:Destroy()
            end
        end
    end
    local tool = hum.Parent and hum.Parent:FindFirstChild("Punch")
    if tool then
        for _, a in ipairs(tool:GetDescendants()) do
            if a:IsA("Animation") and table.find(anims, a.AnimationId) then
                a:Destroy()
            end
        end
    end
    local punchTool = bp:FindFirstChild("Punch")
    if punchTool and not hum:IsEquipped(punchTool) then
        hum:EquipTool(punchTool)
        punch = punchTool
    end
    if punch and punch:FindFirstChild("attackTime") then
        punch.attackTime.Value = 0
    end
end

rs.Heartbeat:Connect(stopAndEquip)

rs.Stepped:Connect(function()
    if punch and punch.Parent and hand then
        punch.attackTime.Value = 0
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local h = p.Character:FindFirstChild("Humanoid")
                if hrp and h and h.Health > 0 then
                    punch:Activate()
                    firetouchinterest(hrp, hand, 0)
                    firetouchinterest(hrp, hand, 1)
                end
            end
        end
    end
end)
