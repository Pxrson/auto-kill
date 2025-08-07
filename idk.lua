-- fixing
local ts = game:GetService("TeleportService")
local plrs = game:GetService("Players")
local id = game.PlaceId

local function loadAutoKill()
    local scriptCode = game:HttpGet("https://raw.githubusercontent.com/Pxrson/auto-kill/main/auto%20kill.lua")
    loadstring(scriptCode)()
end

local function hop()
    if #plrs:GetPlayers() < 5 then
        for _, obj in ipairs(game:GetService("ReplicatedFirst"):GetChildren()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                obj:Destroy()
            end
        end
        ts:Teleport(id, plrs.LocalPlayer)
    else
        loadAutoKill()
    end
end

while true do
    hop()
    task.wait(10)
end
