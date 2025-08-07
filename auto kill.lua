-- discord: .pxrson
-- used a bit of ai for help DONT KILL ME OK IM SORRY
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

local st = {
    run = false,
    last = 0,
    conn = {},
    targs = {},
    char = nil,
    hum = nil,
    tool = nil,
    hand = nil
}

local function clean()
    st.run = false
    st.targs = {}
    for _, c in pairs(st.conn) do
        if c then c:Disconnect() end
    end
    st.conn = {}
end

local function atk(targ)
    if not st.tool or not st.hand then return end
    local trp = targ.Character:FindFirstChild("HumanoidRootPart")
    if not trp then return end
    st.tool:Activate()
    firetouchinterest(trp, st.hand, 0)
    firetouchinterest(trp, st.hand, 1)
    if st.tool:FindFirstChild("attackTime") then
        st.tool.attackTime.Value = 0
    end
end

local function loop()
    if not st.run or not st.char then return end
    local ct = tick()
    if ct - st.last < 0.001 then return end
    
    st.targs = {}
    for _, p in pairs(plrs:GetPlayers()) do
        if p ~= lp and p.Character then
            local h = p.Character:FindFirstChild("Humanoid")
            local rp = p.Character:FindFirstChild("HumanoidRootPart")
            if h and h.Health > 0 and rp then
                local dist = (st.char.HumanoidRootPart.Position - rp.Position).Magnitude
                if dist <= 50 then
                    table.insert(st.targs, p)
                end
            end
        end
    end
    
    for _, t in pairs(st.targs) do
        if t.Character and t.Character:FindFirstChild("Humanoid") and t.Character:FindFirstChild("Humanoid").Health > 0 then
            atk(t)
        end
    end
    
    st.last = ct
end

local function init(char)
    clean()
    st.char = char
    st.hum = char:WaitForChild("Humanoid")
    st.hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
    if not st.hand then return end
    
    local bp = lp.Backpack
    local pt = bp:FindFirstChild("Punch")
    if pt then
        st.hum:EquipTool(pt)
        st.tool = st.hum:FindFirstChildOfClass("Tool")
    end
    
    repeat
        st.tool = st.hum:FindFirstChildOfClass("Tool")
        if not st.tool then
            local t = lp.Backpack:FindFirstChild("Punch")
            if t then st.hum:EquipTool(t) end
            rs.Heartbeat:Wait()
        end
    until st.tool
    
    st.run = true
    st.conn.main = rs.Heartbeat:Connect(loop)
    
    st.conn.pa = plrs.PlayerAdded:Connect(function(np)
        np.CharacterAdded:Connect(function(nc)
            rs.Heartbeat:Wait()
            if st.run and np.Character and np.Character:FindFirstChild("Humanoid") and np.Character:FindFirstChild("Humanoid").Health > 0 then
                atk(np)
            end
        end)
    end)
    
    for _, p in pairs(plrs:GetPlayers()) do
        if p ~= lp then
            p.CharacterAdded:Connect(function(nc)
                rs.Heartbeat:Wait()
                if st.run and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("Humanoid").Health > 0 then
                    atk(p)
                end
            end)
        end
    end
end

if lp.Character then init(lp.Character) end
lp.CharacterAdded:Connect(init)

spawn(function()
    while true do
        rs.Heartbeat:Wait()
        if not st.run and lp.Character and lp.Character:FindFirstChild("Punch") then
            init(lp.Character)
        end
    end
end)
