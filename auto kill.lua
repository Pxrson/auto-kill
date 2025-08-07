-- discord: .pxrson
-- used a bit of ai for help DONT KILL ME OK IM SORRY
local ps = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = ps.LocalPlayer

local aids = {"rbxassetid://3638729053","rbxassetid://3638749874","rbxassetid://3638767427","rbxassetid://102357151005774"}

local c = {}
local r = false

local function sa(h)
    local a = h:FindFirstChildOfClass("Animator")
    if not a then return end
    for _, t in pairs(a:GetPlayingAnimationTracks()) do
        local id = t.Animation.AnimationId
        for _, aid in pairs(aids) do
            if id == aid then t:Stop() break end
        end
    end
end

local function cl()
    r = false
    for _, conn in pairs(c) do if conn then conn:Disconnect() end end
    c = {}
end

local function oc(char)
    cl()
    local h = char:WaitForChild("Humanoid")
    local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
    if not hand then return end
    
    r = true
    c.m = rs.Heartbeat:Connect(function()
        local p = char:FindFirstChild("Punch")
        if not p then
            local t = lp.Backpack:FindFirstChild("Punch")
            if t then h:EquipTool(t) end
            return
        end
        
        p.attackTime.Value = 0
        local t = h:FindFirstChildOfClass("Tool")
        if not t or t.Name ~= "Punch" then
            local pt = lp.Backpack:FindFirstChild("Punch")
            if pt then h:EquipTool(pt) end
        end
        
        for _, pl in pairs(ps:GetPlayers()) do
            if pl ~= lp and pl.Character then
                local ph = pl.Character:FindFirstChild("Humanoid")
                local phrp = pl.Character:FindFirstChild("HumanoidRootPart")
                if ph and ph.Health > 0 and phrp then
                    p:Activate()
                    firetouchinterest(phrp, hand, 0)
                    firetouchinterest(phrp, hand, 1)
                end
            end
        end
        sa(h)
    end)
    
    c.pa = ps.PlayerAdded:Connect(function(np)
        np.CharacterAdded:Connect(function(nc)
            local ph = nc:FindFirstChild("Humanoid")
            local phrp = nc:FindFirstChild("HumanoidRootPart")
            if ph and ph.Health > 0 and phrp then
                local p = char:FindFirstChild("Punch")
                if p then
                    p:Activate()
                    firetouchinterest(phrp, hand, 0)
                    firetouchinterest(phrp, hand, 1)
                end
            end
        end)
    end)
    
    for _, pl in pairs(ps:GetPlayers()) do
        if pl ~= lp and pl.Character then
            pl.CharacterAdded:Connect(function(nc)
                local ph = nc:FindFirstChild("Humanoid")
                local phrp = nc:FindFirstChild("HumanoidRootPart")
                if ph and ph.Health > 0 and phrp then
                    local p = char:FindFirstChild("Punch")
                    if p then
                        p:Activate()
                        firetouchinterest(phrp, hand, 0)
                        firetouchinterest(phrp, hand, 1)
                    end
                end
            end)
        end
    end
end

if lp.Character then oc(lp.Character) end
lp.CharacterAdded:Connect(oc)

rs.Heartbeat:Connect(function()
    if not r and lp.Character and lp.Character:FindFirstChild("Punch") then
        oc(lp.Character)
    end
end)
