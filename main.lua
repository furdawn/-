local function meowfag()
    repeat wait() until game:IsLoaded()
    if game.PlaceId ~= 142823291 then
        game.Players.LocalPlayer:Kick("This is a Murder Mystery 2 script..,,")
    end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local Terrain = Workspace.Terrain

    local roleRemote = ReplicatedStorage.Remotes.Gameplay.RoleSelect
    local tweenInProgress = false
    local nyaClipping = false

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

    local function Noclip()
        nyaClipping = true
        Workspace.Gravity = 0
        Stepped = nil
        Stepped = game:GetService("RunService").Stepped:Connect(function()
            if not nyaClipping == false then
                for _, b in pairs(Workspace:GetChildren()) do
                    if b.Name == Players.LocalPlayer.Name then
                        for _, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end
            else
                Stepped:Disconnect()
            end
        end)

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
            if invisParts then
                invisParts:Destroy()
            end
            if glitchToBoop then
                glitchToBoop:Destroy()
            end
        end

        Players.LocalPlayer.Character:WaitForChild("Animate").Disabled = true
    end

    local function ResetCharacter()
        nyaClipping = false
        local thingymeow = Players.LocalPlayer.Character:WaitForChild("Humanoid")
        thingymeow:ChangeState(15)
        if thingymeow then
            Players.LocalPlayer.Character:WaitForChild("Animate").Disabled = true
        end
    end

    local function endRound()
        print("Flinging murderer >;3")

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

        for _, child in pairs(Players.LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
            end
        end

        Noclip()
        wait(.1)

        local bambam = Instance.new("BodyAngularVelocity")
        bambam.Name = "FFFWWEWSSDZZZ"
        bambam.Parent = Players.LocalPlayer.Character.HumanoidRootPart
        bambam.AngularVelocity = Vector3.new(0,99999,0)
        bambam.MaxTorque = Vector3.new(0,math.huge,0)
        bambam.P = math.huge
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
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(-1,-1,0)
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0, math.rad(8))
                bambam.AngularVelocity = Vector3.new(0,99999,0)
                wait(.1)
                bambam.AngularVelocity = Vector3.new(0,0,0)
                if os.time() - startTime >= 15 then
                    break
                end
            end
            ResetCharacter()
        end
    end

    local function getClosest(coinID)
        local humanoidRootPart = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        local shortestDistance = math.huge
        local closestCoin = nil

        local mrrrrp = Workspace:WaitForChild("Normal", math.huge)
        if not mrrrrp then
            warn("Normal not found in Workspace.")
            return
        end

        local mrrooowww = mrrrrp:WaitForChild("CoinContainer", math.huge)
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
        local humanoidRootPart = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        local hitbox = coin:FindFirstChild("TouchInterest")
        if hitbox then
            local hitboxParent = hitbox.Parent
            if hitboxParent:IsA("BasePart") then
                hitboxParent.Size = Vector3.new(13, 13, 13)
            end
        end

        local distance = (humanoidRootPart.Position - coin.Position).Magnitude

        if distance > 100 then
            tweenDuration = 0.1
        else
            tweenDuration = distance / 47
        end

        local firstTweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear)
        local firstTween = TweenService:Create(humanoidRootPart, firstTweenInfo, {
            CFrame = CFrame.new(coin.Position - Vector3.new(0, 6, 0))
        })
        firstTween:Play()
        firstTween.Completed:Wait()

        local upTweenInfo = TweenInfo.new(0.24, Enum.EasingStyle.Linear)
        local upTween = TweenService:Create(humanoidRootPart, upTweenInfo, {
            CFrame = CFrame.new(coin.Position - Vector3.new(0, 3.6, 0))
        })
        upTween:Play()
        upTween.Completed:Wait()

        local downTweenInfo = TweenInfo.new(0.24, Enum.EasingStyle.Linear)
        local downTween = TweenService:Create(humanoidRootPart, downTweenInfo, {
            CFrame = CFrame.new(coin.Position - Vector3.new(0, 6, 0))
        })
        downTween:Play()
        downTween.Completed:Wait()

        if coin then
            coin:Destroy()
        end
        tweenInProgress = false
    end

    local function onGameStart()
        local function coinContainerChecker()
            local normalContainer = Workspace:WaitForChild("Normal", 5)
            if not normalContainer then
                return false
            end

            local success, coinContainer = pcall(function()
                return normalContainer:WaitForChild("CoinContainer", 5)
            end)

            if success and coinContainer then
                return true
            else
                return false
            end
        end

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
        else
            ResetCharacter()
        end

        wait(12)

        local abc = Players.LocalPlayer.PlayerGui.MainGUI:WaitForChild("Game", 420)
        local def = abc.CoinBags:WaitForChild("Container", 420)

        local eventAmount = tonumber(def:WaitForChild("BeachBall").CurrencyFrame.Icon.Coins.text)
        local coinAmount = tonumber(def:WaitForChild("Coin").CurrencyFrame.Icon.Coins.text)

        print("Game started, farming!")
        Noclip()

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
                task.wait(0.25)
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
                task.wait(0.25)
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
                task.wait(0.25)
            end
        end

        if coinContainerChecker() then
            endRound()
        end
        print("Game ended, waiting...")
        ResetCharacter()
        local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        while not humanoidRootPart do
            humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                wait(1)
            end
        end
        humanoidRootPart.CFrame = humanoidRootPart.CFrame - Vector3.new(0, 20, 0)
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
    textLabel.Text = "Fawn's MM2 Autofarm ;3"
    textLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0.25, 0, 0.25, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Antique
    textLabel.TextColor3 = Color3.new(1, 0.478431, 0.705882)
    textLabel.TextScaled = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.Parent = gui
end

if _G.key then
    if _G.key:lower() == "mentallyinsane" then
        meowfag()
    end
else
    _G.key = nil
    game:GetService("Players").LocalPlayer:Kick("Nice one!!! >///<")
end

local afk = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    afk:CaptureController()
    afk:ClickButton2(Vector2.new())
    task.wait(2)
end)
