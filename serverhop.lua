local Player = game.Players.LocalPlayer
local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local Api = "https://games.roblox.com/v1/games/"
local _place = game.PlaceId

local altUsers = {"xneonPaws", "xmysticPaws", "xwiredPaws", "xvividPaws", "xpepperPaws", "xMewPaws1", "xMewPaws3", "xMewPaws4", "Koi_ish", "DMADusk"}

for i, user in ipairs(altUsers) do
    if user == Player.Name then
        table.remove(altUsers, i)
        break
    end
end

local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=10"

local function ListServers(cursor)
    local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
    return Http:JSONDecode(Raw)
end

local function altChecker()
    for _, player in pairs(game.Players:GetPlayers()) do
        if table.find(altUsers, player.Name) then
            return true
        end
    end
    return false
end

local function attemptTeleport()
    local playerCount = #game.Players:GetPlayers()
    if playerCount < 5 or altChecker() then
        local Servers = ListServers()
        local Server = Servers.data[math.random(1, #Servers.data)]
        TPS:TeleportToPlaceInstance(_place, Server.id, Player)
    end
end

game.Players.PlayerAdded:Connect(attemptTeleport)
game.Players.PlayerRemoving:Connect(attemptTeleport)
attemptTeleport()
