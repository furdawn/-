repeat wait() until game:IsLoaded()
if game.PlaceId ~= 142823291 then
    game.Players.LocalPlayer:Kick("Wrong game! (Murder Mystery 2)")
end

local function meowfag()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local Terrain = game.Workspace.Terrain

    local gameRemote = ReplicatedStorage.Remotes.Gameplay.RoleSelect
    local tweenInProgress = false

    local inLobby = Instance.new("Part")
    inLobby.Size = Vector3.new(3, 0.2, 3)
    inLobby.Position = Vector3.new(-109, 110, 33)
    inLobby.Color = Color3.fromRGB(183, 134, 255)
    inLobby.Transparency = 0.75
    inLobby.Anchored = true
    inLobby.Parent = workspace

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
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        end
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
    local coinVisualizer = Players.LocalPlayer.PlayerScripts:WaitForChild("CoinVisualizer")
    local weaponVisuals = Players.LocalPlayer.PlayerScripts:WaitForChild("WeaponVisuals")
    if coinVisualizer then
        coinVisualizer:Destroy()
    end
    if weaponVisuals then
        weaponVisuals:Destroy()
    end
    --- Optimization Stuff :3

    local function resetCharacter()
        Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
    end

    local function Noclip()
        workspace.Gravity = 0
        repeat wait() until Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Animate")
        Players.LocalPlayer.Character.Animate.Disabled = true
        local wrkspcnrml = game.Workspace:WaitForChild("Normal", 30)
        if wrkspcnrml then
            local mapPrimary = wrkspcnrml:FindFirstChild("Map")
            local mapSecondary = wrkspcnrml:FindFirstChild("Parts")
            local invisParts =  wrkspcnrml:FindFirstChild("Invis")
            local glitchParts = wrkspcnrml:FindFirstChild("GlitchProof")
            local interactiveParts = wrkspcnrml:FindFirstChild("Interactive")
            if mapPrimary then
                mapPrimary:Destroy()
            elseif mapSecondary then
                mapSecondary:Destroy()
            end
            if invisParts then
                invisParts:Destroy()
            end
            if glitchParts then
                glitchParts:Destroy()
            end
            if interactiveParts then
                interactiveParts:Destroy()
            end
        end
    end

    local function gotoHide()
        workspace.Gravity = 196.2
        local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = Character:WaitForChild("HumanoidRootPart", math.huge)
        local targetPosition = Vector3.new(-109, 112.5, 33)
        local hideMe = TweenService:Create(humanoidRootPart, TweenInfo.new(0, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPosition)})
        hideMe:Play()
        hideMe.Completed:Wait()
    end

    local function endRound()
        flinging = false
        local targetPlayer = nil
        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        for i, v in pairs(roles) do
            if v.Role == "Murderer" then
                targetPlayer = Players:FindFirstChild(i)
                break
            end
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
        if targetPlayer and targetPlayer.Character and targetPlayer.Character.Humanoid then
            local startTime = os.time()
            while flinging == true and Players.LocalPlayer.Character and targetPlayer.Character do
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
        end
        local speakerChar = Players.LocalPlayer.Character
        if not speakerChar or not Players.LocalPlayer.HumanoidRootPart then return end
        for _, v in pairs(Players.LocalPlayer.HumanoidRootPart:GetChildren()) do
            if v.ClassName == 'BodyAngularVelocity' then
                v:Destroy()
            end
        end
        for _, child in pairs(speakerChar:GetDescendants()) do
            if child.ClassName == "Part" or child.ClassName == "MeshPart" then
                child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
            end
        end
        resetCharacter()
        gotoHide()
    end

    local function getClosest(coinID)
        local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = Character:WaitForChild("HumanoidRootPart", math.huge)
        local shortestDistance = 420420
        local closestCoin = nil

        local x = game.Workspace:FindFirstChild("Normal")
        if not x then
            return
        end

        for _, coin in pairs(x.CoinContainer:GetChildren()) do
            if coin:IsA("BasePart") then
                if coin:FindFirstChild("TouchInterest") then
                    if coin:GetAttribute("CoinID") == coinID or (coinID == "Meow" and coin:GetAttribute("CoinID") ~= nil) then
                        local distance = (humanoidRootPart.Position - coin.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestCoin = coin
                        end
                    end
                end
            end
        end
        if closestCoin == nil then
            return
        else
            return closestCoin
        end
    end

    local function tweenTo(coin)
        local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        if coin:FindFirstChild("TouchInterest") then
            if coin:IsA("BasePart") then
                coin.Size = Vector3.new(13, 13, 13)
            end
        else
            tweenInProgress = false
            return
        end

        local function setTween(targetPos, duration)
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, { CFrame = CFrame.new(targetPos) })
            tween:Play()
            tween.Completed:Wait()
        end

        local distance = (humanoidRootPart.Position - coin.Position).Magnitude
        if distance > 100 then
            setTween(coin.Position - Vector3.new(0, 8.5, 0), 0)
            setTween(coin.Position - Vector3.new(0, 4, 0), 0.35)
        elseif distance < 18 then
            setTween(coin.Position - Vector3.new(0, 8.5, 0), 0)
            setTween(coin.Position - Vector3.new(0, 4, 0), 0.35)
        else
            setTween(coin.Position - Vector3.new(0, 8.5, 0), distance / 35)
            setTween(coin.Position - Vector3.new(0, 4, 0), 0.35)
        end

        if coin then
            task.wait(0.35)
            coin:Destroy()
        else
            task.wait(0.35)
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

        task.wait(18)

        repeat wait() until Players.LocalPlayer.PlayerGui.MainGUI.Game
        local eventAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.CurrencyFrame.Icon.Coins.text)
        local coinAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins.text)

        Noclip()

        local function containerCheck()
            local x = game.Workspace:FindFirstChild("Normal")
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

        while containerCheck() and eventAmount < 20 and coinAmount < 40 do
            if not tweenInProgress then
                local closestEither = getClosest("Meow")
                if closestEither then
                    tweenInProgress = true
                    tweenTo(closestEither)
                end
                eventAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.CurrencyFrame.Icon.Coins.text)
                coinAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins.text)
            end
        end

        while containerCheck() and eventAmount < 20 do
            if not tweenInProgress then
                local closestEvent = getClosest("BeachBall")
                if closestEvent then
                    tweenInProgress = true
                    tweenTo(closestEvent)
                end
                eventAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.CurrencyFrame.Icon.Coins.text)
            end
        end

        while containerCheck() and coinAmount < 40 do
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

        if not containerCheck() then
            gotoHide()
        end
        endRound()
    end

    gameRemote.OnClientEvent:Connect(onGameStart)

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
