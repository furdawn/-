local function meowfag()
    repeat wait() until game:IsLoaded()
    if game.PlaceId ~= 142823291 then
        game.Players.LocalPlayer:Kick("This is a Murder Mystery 2 script..,,")
    end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local Terrain = Workspace.Terrain

    local roleRemote = ReplicatedStorage.Remotes.Gameplay.RoleSelect
    local tweenInProgress

    local inLobby = Instance.new("Part")
    inLobby.Size = Vector3.new(3, 0.2, 3)
    inLobby.Position = Vector3.new(-109, 110, 33)
    inLobby.Color = Color3.fromRGB(183, 134, 255)
    inLobby.Transparency = 0.75
    inLobby.Anchored = true
    inLobby.Parent = workspace

    --- Optimization stuff :3
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    Lighting.Brightness = 0
    Lighting.GlobalShadows = false
    settings().Rendering.QualityLevel = "Level01"
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") then
            v:Destroy()
        end
    end
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        end
    end
    for _, v in ipairs(Workspace:GetDescendants()) do
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

    local function ResetCharacter()
        Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
        Players.LocalPlayer.CharacterAdded:Wait()
        workspace.Gravity = 196.2
    end

    local function Noclip()
        Players.LocalPlayer.CharacterAdded:Wait()
        local function NoclipLoop()
            if Players.LocalPlayer.Character ~= nil then
                for _, child in pairs(Players.LocalPlayer.Character:GetDescendants()) do
                    if child:IsA("BasePart") and child.CanCollide == true then
                        child.CanCollide = false
                    end
                end
            end
        end
        RunService.Stepped:Connect(NoclipLoop)

        local wrkspcnrml = Workspace.Normal
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
        Players.LocalPlayer.Character.Animate.Disabled = true
        workspace.Gravity = 0
    end

    local function gotoHide()
        workspace.Gravity = 196.2
        local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = Character:WaitForChild("HumanoidRootPart", 60)
        local targetPosition = Vector3.new(-109, 112.5, 33)
        local hideMe = TweenService:Create(humanoidRootPart, TweenInfo.new(0, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPosition)})
        hideMe:Play()
        hideMe.Completed:Wait()
    end

    local function endRound()
        print("Flinging murderer >;3")
        workspace.Gravity = 10
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
            ResetCharacter()
            return
        end

        for _, child in pairs(Players.LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
            end
        end

        Noclip()
        wait(.1)

        local poofMurderer = Instance.new("BodyAngularVelocity")
        poofMurderer.Name = "SmirksWithMaliciousIntent"
        poofMurderer.Parent = Players.LocalPlayer.Character.HumanoidRootPart
        poofMurderer.AngularVelocity = Vector3.new(0,100000,0)
        poofMurderer.MaxTorque = Vector3.new(0,math.huge,0)
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
        local function flingDiedF()
            if flingDied then
                flingDied:Disconnect()
            end
            flinging = false
            wait(0.1)
            if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character.HumanoidRootPart then return end
            for _,v in pairs(Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                if v.ClassName == 'BodyAngularVelocity' then
                    v:Destroy()
                end
            end
            for _, child in pairs(Players.LocalPlayer.Character:GetDescendants()) do
                if child.ClassName == "Part" or child.ClassName == "MeshPart" then
                    child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                end
            end
            ResetCharacter()
        end
        flingDied = Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Died:Connect(flingDiedF)

        if Players.LocalPlayer and Players.LocalPlayer.Character and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            local startTime = os.time()
            while flinging == true and targetPlayer.Character.Humanoid and targetPlayer.Character.Humanoid.Health > 0 do
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, -1, 1.5)
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0, math.rad(8))
                poofMurderer.AngularVelocity = Vector3.new(0, 100000, 0)
                wait(.1)
                poofMurderer.AngularVelocity = Vector3.new(0, 0, 0)
                if os.time() - startTime >= 8 then
                    break
                end
            end
            ResetCharacter()
        end
        gotoHide()
    end

    local function getClosest(coinID)
        local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = Character:WaitForChild("HumanoidRootPart", 60)
        local shortestDistance = math.huge
        local closestCoin = nil

        local mrrrrp = Workspace:WaitForChild("Normal", 15)
        if not mrrrrp then
            warn("Normal not found in Workspace.")
            return
        end

        local mrrooowww = mrrrrp:WaitForChild("CoinContainer", 15)
        if not mrrooowww then
            warn("CoinContainer not found in Normal.")
            return
        end

        for _, coin in pairs(mrrooowww:GetChildren()) do
            if coin:IsA("BasePart") then
                local touchInterest = coin:FindFirstChild("TouchInterest")
                if touchInterest then
                    if coin:GetAttribute("CoinID") == coinID or (coinID == "MEOW" and coin:GetAttribute("CoinID") ~= nil) then
                        local distance = (humanoidRootPart.Position - coin.Position).Magnitude
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
        local humanoidRootPart = Character:WaitForChild("HumanoidRootPart", 60)
        local hitbox = coin:FindFirstChild("TouchInterest")
        if hitbox then
            local hitboxParent = hitbox.Parent
            if hitboxParent:IsA("BasePart") then
                hitboxParent.Size = Vector3.new(14, 14, 14)
            end
        end

        workspace.Gravity = 0
        local distance = (humanoidRootPart.Position - coin.Position).Magnitude

        local function setTween(targetPos, duration)
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, { CFrame = CFrame.new(targetPos) })
            tween:Play()
            tween.Completed:Wait()
        end

        if distance < 10 then
            setTween(coin.Position - Vector3.new(0, 3.9, 0), 0.2)
        elseif distance > 150 then
            setTween(coin.Position - Vector3.new(0, 9, 0), 0)
            task.wait(0.1)
            setTween(coin.Position - Vector3.new(0, 4.1, 0), 0.2)
        else
            setTween(coin.Position - Vector3.new(0, 9, 0), distance / 45)
            task.wait(0.1)
            setTween(coin.Position - Vector3.new(0, 4.1, 0), 0.2)
        end

        if coin then
            task.wait(0.3)
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
            print("Murderer, Not resetting :3")
            Players.LocalPlayer.Character.Animate.Disabled = true
        else
            ResetCharacter()
        end

        task.wait(10)

        local abc = Players.LocalPlayer.PlayerGui.MainGUI:WaitForChild("Game", 30)
        local eventAmount = tonumber(abc.CoinBags.Container:WaitForChild("BeachBall", 30).CurrencyFrame.Icon.Coins.text)
        local coinAmount = tonumber(abc.CoinBags.Container:WaitForChild("Coin", 30).CurrencyFrame.Icon.Coins.text)

        print("Game started, farming!")
        Noclip()

        local function coinContainerChecker()
            local x = Workspace:FindFirstChild("Normal")
            if not x then
                return false
            end

            if x then
                local y = x:WaitForChild("CoinContainer")
                if not y then
                    return false
                elseif y then
                    return true
                end
            end
        end

        while eventAmount < 20 and coinAmount < 40 and coinContainerChecker() do
            if not tweenInProgress then
                local closestEither = getClosest("MEOW")
                if closestEither then
                    tweenInProgress = true
                    tweenTo(closestEither)
                else
                    task.wait(3)
                end
                coinAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins.text)
                eventAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.CurrencyFrame.Icon.Coins.text)
            end
        end

        while eventAmount < 20 and coinContainerChecker() do
            if not tweenInProgress then
                local closestEvent = getClosest("BeachBall")
                if closestEvent then
                    tweenInProgress = true
                    tweenTo(closestEvent)
                else
                    task.wait(3)
                end
                eventAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.CurrencyFrame.Icon.Coins.text)
            end
        end

        while coinAmount < 40 and coinContainerChecker() do
            if not tweenInProgress then
                local closestCoin = getClosest("Coin")
                if closestCoin then
                    tweenInProgress = true
                    tweenTo(closestCoin)
                else
                    task.wait(3)
                end
                coinAmount = tonumber(Players.LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins.text)
            end
        end

        if not coinContainerChecker() then
            gotoHide()
            print("Game ended, waiting...")
            return
        end
        endRound()
        print("Game ended, waiting...")
    end

    roleRemote.OnClientEvent:Connect(onGameStart)

    print("--------------------- <3")
    print("\n")
    print("Transgirl fawn's MM2 autofarm has loaded!")
    print("\n")
    print("--------------------- <3")
    local gui = Instance.new("ScreenGui")
    gui.Name = "MeowGui"
    gui.Parent = game.CoreGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = "Fawn's MM2 Autofarm >,<"
    textLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0.25, 0, 0.25, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Sarpanch
    textLabel.TextColor3 = Color3.new(0.082352, 1, 1)
    textLabel.TextScaled = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.Parent = gui
end

if _G.key then
    local afk = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        afk:CaptureController()
        afk:ClickButton2(Vector2.new())
        task.wait(2)
    end)
    if _G.key:lower() == "mentallyinsane" then
        meowfag()
    end
else
    _G.key = nil
    game:GetService("Players").LocalPlayer:Kick("Nice one!!! >///<")
end
