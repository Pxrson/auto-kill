local plrs = game:GetService("Players")
local ts = game:GetService("TeleportService")

queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Pxrson/auto-kill/refs/heads/main/auto%20kill.lua'))()")

if #plrs:GetPlayers() <= 5 then
    ts:Teleport(game.PlaceId)
    return
end

loadstring(game:HttpGet('https://raw.githubusercontent.com/Pxrson/auto-kill/refs/heads/main/auto%20kill.lua'))()
