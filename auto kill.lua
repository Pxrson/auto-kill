-- discord: .pxrson
-- ai helped clean it up
-- DONT KILL ME OK IM SORRY

local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer

local anims = {
	"rbxassetid://3638729053",
	"rbxassetid://3638749874",
	"rbxassetid://3638767427",
	"rbxassetid://102357151005774"
}

local function setup(char)
	local hum = char:WaitForChild("Humanoid")
	local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
	if not hand then return end

	local punch
	repeat
		punch = char:FindFirstChild("Punch") or lp.Backpack:FindFirstChild("Punch")
		if punch and not char:FindFirstChild("Punch") then hum:EquipTool(punch) end
		rs.Heartbeat:Wait()
	until punch

	rs.Heartbeat:Connect(function()
		if punch:FindFirstChild("attackTime") then punch.attackTime.Value = 0 end

		local tool = hum:FindFirstChildOfClass("Tool")
		if not tool or tool.Name ~= "Punch" then
			local t = lp.Backpack:FindFirstChild("Punch")
			if t then hum:EquipTool(t) end
		end

		for _, p in ipairs(plrs:GetPlayers()) do
			if p ~= lp then
				local c = p.Character
				if c then
					local h = c:FindFirstChild("Humanoid")
					local hrp = c:FindFirstChild("HumanoidRootPart")
					if h and hrp and h.Health > 0 then
						punch:Activate()
						firetouchinterest(hrp, hand, 0)
						firetouchinterest(hrp, hand, 1)
					end
				end
			end
		end

		local animr = hum:FindFirstChildOfClass("Animator")
		if animr then
			for _, t in pairs(animr:GetPlayingAnimationTracks()) do
				if table.find(anims, t.Animation.AnimationId) then t:Stop() end
			end
		end
	end)
end

for _, p in pairs(plrs:GetPlayers()) do
	if p ~= lp then
		p.CharacterAdded:Connect(function(c)
			rs.Heartbeat:Wait()
		end)
	end
end

plrs.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(c)
		rs.Heartbeat:Wait()
	end)
end)

if lp.Character then setup(lp.Character) end
lp.CharacterAdded:Connect(setup)

task.spawn(function()
	while true do
		rs.Heartbeat:Wait()
		if lp.Character and lp.Character:FindFirstChild("Punch") then
			setup(lp.Character)
		end
	end
end)
