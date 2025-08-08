local plrs = game:GetService("Players")
local tp = game:GetService("TeleportService")
local rf = game:GetService("ReplicatedFirst")
local http = game:GetService("HttpService")

local function hop()
    local list = http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    local servers = {}
    for _, s in ipairs(list) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            servers[#servers+1] = s.id
        end
    end
    if #servers > 0 then
        tp:TeleportToPlaceInstance(game.PlaceId, servers[math.random(#servers)], plrs.LocalPlayer)
    else
        tp:Teleport(game.PlaceId, plrs.LocalPlayer)
    end
end

while true do
    if #plrs:GetPlayers() < 5 then
        for _, o in ipairs(rf:GetChildren()) do
            if o:IsA("Script") or o:IsA("LocalScript") then o:Destroy() end
        end
        hop()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pxrson/auto-kill/refs/heads/main/auto%20kill.lua",true))()
    end
    task.wait(10)
end
