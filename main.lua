if game.PlaceId ~= 142823291 then
    game.Players.LocalPlayer:Kick("Wrong game! (Murder Mystery 2)")
end
if FARM_MM2 == true then
    warn("Farm is already executed!", 0)
    return
end
pcall(function() getgenv().FARM_MM2 = true end)

local function meowfag()
    repeat task.wait() until game:IsLoaded()

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local Terrain = game.Workspace.Terrain

    local roleRemote = ReplicatedStorage.Remotes.Gameplay.RoleSelect
    local tweenInProgress

    local inLobby = Instance.new("Part")
    inLobby.Size = Vector3.new(3, 0.2, 3)
    inLobby.Position = Vector3.new(-109, 110, 33)
    inLobby.Color = Color3.fromRGB(183, 134, 255)
    inLobby.Transparency = 0.75
    inLobby.Anchored = true
    inLobby.Parent = workspace

    for _, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
        if v["Disable"] then
            v["Disable"](v)
        elseif v["Disconnect"] then
            v["Disconnect"](v)
        end
    end
    local VirtualUser = (game:GetService("VirtualUser"))
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    --- Optimization stuff :3
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    Lighting.Brightness = 0
    Lighting.GlobalShadows = false
    settings().Rendering.QualityLevel = "Level01"
    for _, v in ipairs(game.Workspace:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") then
            v:Destroy()
        end
    end
    for _,v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        end
    end
    for _, v in ipairs(game.Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
    local coinVisualizer = Players.LocalPlayer.PlayerScripts:FindFirstChild("CoinVisualizer")
    local weaponVisuals = Players.LocalPlayer.PlayerScripts:FindFirstChild("WeaponVisuals")
    if coinVisualizer then
        coinVisualizer:Destroy()
    end
    if weaponVisuals then
        weaponVisuals:Destroy()
    end
    --- Optimization Stuff :3

    local function resetCharacter()
        workspace.Gravity = 196.2
        repeat
            task.wait()
        until Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") and Players.LocalPlayer.Character.Humanoid.Health > 0
        Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health = 0
        Players.LocalPlayer.CharacterAdded:Wait()
    end

    local function noclip()
        workspace.Gravity = 0
        Players.LocalPlayer.Character.Animate.Disabled = true
        local wrkspcnrml = game.Workspace:WaitForChild("Normal", math.huge)
        if wrkspcnrml then
            local mapPrimary = wrkspcnrml:FindFirstChild("Map")
            local mapSecondary = wrkspcnrml:FindFirstChild("Parts")
            if mapPrimary then
                mapPrimary:Destroy()
            elseif mapSecondary then
                mapSecondary:Destroy()
            end
            local invisParts =  wrkspcnrml:FindFirstChild("Invis")
            local glitchToBoop = wrkspcnrml:FindFirstChild("GlitchProof")
            local interactiveParts = wrkspcnrml:FindFirstChild("Interactive")
            if invisParts then
                invisParts:Destroy()
            end
            if glitchToBoop then
                glitchToBoop:Destroy()
            end
            if interactiveParts then
                interactiveParts:Destroy()
            end
        end
    end

    local function gotoHide()
        if tweenInProgress then
            return
        end
        workspace.Gravity = 196.2
        local keepTeleporting = true
        roleRemote.OnClientEvent:Connect(function()
            keepTeleporting = false
        end)
        while keepTeleporting do
            repeat task.wait() until Players.LocalPlayer.Character and Players.LocalPlayer.Character:WaitForChild("Humanoid").Health > 0
            local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
            local humanoidRootPart = Character:WaitForChild("HumanoidRootPart", math.huge)
            local targetPosition = Vector3.new(-109, 112.5, 33)
            local distance = (humanoidRootPart.Position - targetPosition).Magnitude
            if distance > 15 then
                local hideMe = TweenService:Create(humanoidRootPart, TweenInfo.new(0, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPosition)})
                hideMe:Play()
                hideMe.Completed:Wait()
            end
        end
    end

    local function endRound()
        local targetPlayer = nil
        local flingDied = nil
        flinging = false
        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        for i, v in pairs(roles) do
            if v.Role == "Murderer" then
                targetPlayer = Players:FindFirstChild(i)
                break
            end
        end
        if not targetPlayer then
            warn("Murderer not found.")
            return
        end
        if Players.LocalPlayer == targetPlayer then
            resetCharacter()
            return
        end
        for _, child in pairs(Players.LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
            end
        end

        task.wait(1)

        local poofMurderer = Instance.new("BodyAngularVelocity")
        poofMurderer.Name = "SmirksWithMaliciousIntent"
        poofMurderer.Parent = Players.LocalPlayer.Character.HumanoidRootPart
        poofMurderer.AngularVelocity = Vector3.new(0, 95000, 0)
        poofMurderer.MaxTorque = Vector3.new(0, math.huge, 0)
        poofMurderer.P = math.huge
        local Char = Players.LocalPlayer.Character:GetChildren()
        for _, v in next, Char do
            if v:IsA("BasePart") then
                v.CanCollide = false
                v.Massless = true
                v.Velocity = Vector3.new(0, 0, 0)
            end
        end

        flinging = true
        while not Players.LocalPlayer or not Players.LocalPlayer.Character do
            task.wait()
        end
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            local startTime = os.time()
            while flinging == true and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character:FindFirstChild("HumanoidRootPart") do
                if not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    break
                end
                poofMurderer.AngularVelocity = Vector3.new(0, 95000, 0)
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(8), 0, math.rad(8))
                task.wait(0.1)
                poofMurderer.AngularVelocity = Vector3.new(0, 0, 0)
                if os.time() - startTime >= 4 then
                    break
                end
            end
            flinging = false
            resetCharacter()
        end
    end

    local function getClosest(coinID)
        local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        local shortestDistance = math.huge
        local closestCoin = nil

        local x = game.Workspace.Normal
        if not x then
            return
        end

        for _, coin in pairs(game.Workspace.Normal.CoinContainer:GetChildren()) do
            if coin:IsA("BasePart") then
                local touchInterest = coin:FindFirstChild("TouchInterest")
                if touchInterest then
                    if coin:GetAttribute("CoinID") == coinID or (coinID == "XYZ" and coin:GetAttribute("CoinID") ~= nil) then
                        local distance = (Character.HumanoidRootPart.Position - coin.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestCoin = coin
                        end
                    end
                end
            end
        end
        return closestCoin
    end

    local function tweenTo(coin)
        local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        if coin:FindFirstChild("TouchInterest") then
            if coin:IsA("BasePart") then
                coin.Size = Vector3.new(15, 15, 15)
            end
        else
            tweenInProgress = false
            return
        end

        local distance = (humanoidRootPart.Position - coin.Position).Magnitude

        local function setTween(targetPos, duration)
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, { CFrame = CFrame.new(targetPos) })
            tween:Play()
            tween.Completed:Wait()
        end

        if distance < 15 then
            setTween(coin.Position - Vector3.new(0, 10, 0), 0)
            setTween(coin.Position - Vector3.new(0, 4.1, 0), 0.1)
        elseif distance > 200 then
            setTween(coin.Position - Vector3.new(0, 10, 0), 0)
            setTween(coin.Position - Vector3.new(0, 4.1, 0), 0.1)
        else
            setTween(coin.Position - Vector3.new(0, 10, 0), distance / 25)
            setTween(coin.Position - Vector3.new(0, 4.1, 0), 0.1)
        end

        if coin then
            task.wait(0.5)
            coin:Destroy()
        end
        tweenInProgress = false
    end

    local function onGameStart()
        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        local muwuderer = nil
        for i, v in pairs(roles) do
            if v.Role == "Murderer" then
                muwuderer = Players:FindFirstChild(i)
                break
            end
        end

        if muwuderer == Players.LocalPlayer then
            Players.LocalPlayer.Character.Animate.Disabled = true
        else
            resetCharacter()
        end

        task.wait(15)

        local abc = Players.LocalPlayer.PlayerGui.MainGUI:WaitForChild("Game", 30)
        local eventAmount = tonumber(abc.CoinBags.Container.BeachBall.CurrencyFrame.Icon.Coins.text)
        local coinAmount = tonumber(abc.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins.text)

        local function containerCheck(nya)
            local x = game.Workspace:WaitForChild("Normal", nya)
            if not x then
                return false
            end
            if x then
                local y = x:FindFirstChild("CoinContainer")
                if not y then
                    return false
                elseif y then
                    return true
                end
            end
        end

        noclip()

        while eventAmount < 20 and coinAmount < 40 and containerCheck(60) do
            if not tweenInProgress then
                local closestEither = getClosest("XYZ")
                if closestEither then
                    tweenInProgress = true
                    tweenTo(closestEither)
                end
                eventAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.CurrencyFrame.Icon.Coins.text)
                coinAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins.text)
            end
        end

        while eventAmount < 20 and containerCheck(60) do
            if not tweenInProgress then
                local closestEvent = getClosest("BeachBall")
                if closestEvent then
                    tweenInProgress = true
                    tweenTo(closestEvent)
                end
                eventAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.CurrencyFrame.Icon.Coins.text)
            end
        end

        while coinAmount < 40 and containerCheck(60) do
            if not tweenInProgress then
                local closestCoin = getClosest("Coin")
                if closestCoin then
                    tweenInProgress = true
                    tweenTo(closestCoin)
                end
                coinAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins.text)
            end
        end

        tweenInProgress = false

        if not containerCheck(1) then
            gotoHide()
            return
        end
        endRound()
        gotoHide()
    end

    roleRemote.OnClientEvent:Connect(onGameStart)

    print("--------------------- <3")
    print("\n")
    print("Astra's MM2 autofarm has loaded!")
    print("\n")
    print("--------------------- <3")
    local gui = Instance.new("ScreenGui")
    gui.Name = "MeowGui"
    gui.Parent = game.CoreGui

    local MM2Text = Instance.new("TextLabel")
    MM2Text.Text = "Astra's MM2 Autofarm >,<"
    MM2Text.Size = UDim2.new(0.5, 0, 0.5, 0)
    MM2Text.Position = UDim2.new(0.25, 0, 0.25, 0)
    MM2Text.BackgroundTransparency = 1
    MM2Text.Font = Enum.Font.Sarpanch
    MM2Text.TextColor3 = Color3.new(0, 1, 1)
    MM2Text.TextStrokeColor3 = Color3.new(1, 0.5, 0.8)
    MM2Text.TextStrokeTransparency = 0
    MM2Text.TextScaled = true
    MM2Text.TextXAlignment = Enum.TextXAlignment.Center
    MM2Text.Parent = gui
    game:GetService("StarterGui"):SetCore("SendNotification",{["Title"] = "Correct key!",["Text"] = "Astra's MM2 autofarm has loaded.",["Duration"] = 10,["Button1"] = "Purrfect!"})
end

if _G.key then
    if _G.key:lower() == "mentallyinsane" then
        meowfag()
    end
else
    _G.key = nil
    game:GetService("Players").LocalPlayer:Kick("Nice one!!!")
end
