-- discord: .pxrson
local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")

local animIds = {
    ["rbxassetid://3638729053"] = true,
    ["rbxassetid://3638749874"] = true,
    ["rbxassetid://3638767427"] = true,
    ["rbxassetid://102357151005774"] = true
}

local char, hum, hand, punch, anim = nil,nil,nil,nil,nil
local lastAtk, lastRespawn = 0, 0
local targets = {}

local function updateChar()
    char = lp.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        punch = char:FindFirstChild("Punch")
        anim = hum and (char:FindFirstChildOfClass("Animator") or hum:FindFirstChildOfClass("Animator"))
    end
end

lp.CharacterAdded:Connect(updateChar)
updateChar()

rs.RenderStepped:Connect(function()
    local t = os.clock()
    if t - lastAtk < 0.05 then return end
    lastAtk = t

    if not char or not hum or not hand then
        updateChar()
        return
    end

    if not punch then
        local tool = lp.Backpack:FindFirstChild("Punch")
        if tool then
            hum:EquipTool(tool)
            punch = char:FindFirstChild("Punch")
        else
            if t - lastRespawn > 2 and hum and hum.Health > 0 then
                hum.Health = 0
                lastRespawn = t
            end
            return
        end
    end

    punch.attackTime.Value = 0
    punch:Activate()

    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp then
            local c = p.Character
            if c and c.Parent then
                local h = c:FindFirstChildOfClass("Humanoid")
                local head = c:FindFirstChild("Head")
                if h and head and h.Health > 0 then
                    firetouchinterest(head, hand, 0)
                    firetouchinterest(head, hand, 1)
                end
            end
        end
    end

    if anim then
        for _, trk in ipairs(anim:GetPlayingAnimationTracks()) do
            local a = trk.Animation
            if a and animIds[a.AnimationId] then
                trk:Stop()
            end
        end
    end
end)
