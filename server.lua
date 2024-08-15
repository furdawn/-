local Player = game.Players.LocalPlayer    
local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local Api = "https://games.roblox.com/v1/games/"

local _place,_id = game.PlaceId, game.JobId
local _servers = Api.._place.."/servers/Public?sortOrder=Desc&limit=100"

local function Hop()
    if #game.Players:GetPlayers() <= 3 then
        function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end

        local Next; repeat
            local Servers = ListServers(Next)
            for i,v in next, Servers.data do
                if v.playing < v.maxPlayers and v.id ~= _id then
                    local s,r = pcall(TPS.TeleportToPlaceInstance,TPS,_place,v.id,Player)
                    if s then break end
                end
            end

            Next = Servers.nextPageCursor
        until not Next
    end
end

while true do
    Hop()
    task.wait(5400)
end
