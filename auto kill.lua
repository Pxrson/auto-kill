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

local run = false

local function go(char)
	local hum = char:WaitForChild("Humanoid", 5)
	local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
	if not hum or not hand then return end
	local punch
	repeat
		punch = char:FindFirstChild("Punch") or lp.Backpack:FindFirstChild("Punch")
		if punch and not char:FindFirstChild("Punch") then hum:EquipTool(punch) end
		rs.Heartbeat:Wait()
	until punch
	run = true
	rs.Heartbeat:Connect(function()
		if not run then return end
		if punch:FindFirstChild("attackTime") then punch.attackTime.Value = 0 end
		local tool = hum:FindFirstChildOfClass("Tool")
		if not tool or tool.Name ~= "Punch" then
			local t = lp.Backpack:FindFirstChild("Punch")
			if t then hum:EquipTool(t) end
		end
		for _,p in ipairs(plrs:GetPlayers()) do
			if p ~= lp and p.Character then
				local h = p.Character:FindFirstChild("Humanoid")
				local hrp = p.Character:FindFirstChild("HumanoidRootPart")
				if h and hrp and h.Health > 0 then
					punch:Activate()
					firetouchinterest(hrp, hand, 0)
					firetouchinterest(hrp, hand, 1)
				end
			end
		end
		local animr = hum:FindFirstChildOfClass("Animator")
		if animr then
			for _,t in pairs(animr:GetPlayingAnimationTracks()) do
				if table.find(anims, t.Animation.AnimationId) then t:Stop() end
			end
		end
	end)
end

if lp.Character then go(lp.Character) end
lp.CharacterAdded:Connect(go)

task.spawn(function()
	while true do
		rs.Heartbeat:Wait()
		if not run and lp.Character and lp.Character:FindFirstChild("Punch") then
			go(lp.Character)
		end
	end
end)
