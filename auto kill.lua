-- discord: .pxrson
local ps = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = ps.LocalPlayer

local anims = {
    "rbxassetid://3638729053",
    "rbxassetid://3638749874",
    "rbxassetid://3638767427",
    "rbxassetid://102357151005774",
}

local function stopAnims(h)
    local a = h:FindFirstChildOfClass("Animator")
    if not a then return end
    for _, t in a:GetPlayingAnimationTracks() do
        local id = t.Animation and t.Animation.AnimationId
        if id and table.find(anims, id) then
            t:Stop()
            t:Destroy()
        end
    end
end

local function killLoop(p, h)
    rs.Heartbeat:Connect(function()
        p.attackTime.Value = 0
    end)
    rs.Stepped:Connect(function()
        p.attackTime.Value = 0
        for _, pl in ps:GetPlayers() do
            if pl ~= lp and pl.Character then
                local th = pl.Character:FindFirstChild("Humanoid")
                local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                if th and hrp and th.Health > 0 then
                    p:Activate()
                    firetouchinterest(hrp, h, 0)
                    firetouchinterest(hrp, h, 1)
                end
            end
        end
    end)
end

local function onChar(c)
    local bp = lp:WaitForChild("Backpack")
    local h = c:WaitForChild("Humanoid")
    local hand = c:FindFirstChild("LeftHand") or c:FindFirstChild("Left Arm")

    local function equip()
        local t = bp:FindFirstChild("Punch")
        if t then h:EquipTool(t) end
    end

    repeat task.wait(0.1)
        equip()
    until c:FindFirstChild("Punch")

    local p = c:FindFirstChild("Punch")
    if not p or not hand then return end
    p.attackTime.Value = 0

    rs.Heartbeat:Connect(function()
        stopAnims(h)
        if not c:FindFirstChild("Punch") then equip() end
    end)

    killLoop(p, hand)
end

lp.CharacterAdded:Connect(onChar)
if lp.Character then onChar(lp.Character) end
