repeat task.wait() until game:IsLoaded()
getgenv().Mainfarm = nil
getgenv().Altfarm = nil

local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain

Players.LocalPlayer.PlayerGui:FindFirstChild("MobileShiftLock"):Destroy()
local mainGUI = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")
local altGUI = Players.LocalPlayer.PlayerGui.ScreenGui.UI.GamemodeMessage.textD
local knifePlayer

Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
Lighting.Brightness = 0
Lighting.GlobalShadows = false
settings().Rendering.QualityLevel = 1
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    end
end

local function BreakVel()
    for _, v in ipairs(Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

local function MapSetup()
    game.Workspace.Gravity = 215
    task.wait(1.25)
    Players.LocalPlayer.Character.Animate.Disabled = true
    game.Workspace.Gravity = 0
    for _, v in ipairs(game.Workspace.GameMap:GetDescendants()) do
        if v and v:IsA("BasePart") then
            v:Destroy()
        end
    end
    for _, v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
        if v and v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

local function Kill(targetPlayer)
    if targetPlayer and targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("HumanoidRootPart") then
        local localRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetPlayer:FindFirstChild("HumanoidRootPart")

        if localRoot and targetRoot then
            local offset = CFrame.new(0, -5.5, -1)
            local targetCFrame = targetRoot.CFrame * offset
            local tween = TweenService:Create(localRoot, TweenInfo.new(0, Enum.EasingStyle.Linear), { CFrame = targetCFrame })
            tween:Play()
        end
    end
    BreakVel()
end

local function Start()
    MapSetup()
    BreakVel()

    getgenv().Mainfarm = true

    local targetText = mainGUI.TargetText.Text
    local targetPlayer = game.Workspace:FindFirstChild(targetText)

    while mainGUI.Visible and getgenv().Mainfarm do
        local currentTarget = mainGUI.TargetText.Text
        if currentTarget ~= targetText then
            targetPlayer = game.Workspace:FindFirstChild(currentTarget)
            targetText = currentTarget

            if not targetPlayer then
                break
            end
        end

        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
            local knife = Players.LocalPlayer.Backpack:FindFirstChild("Knife")
            if knife then
                knife.Parent = Players.LocalPlayer.Character
            end

            knifePlayer = targetText
            Kill(targetPlayer)
            task.wait()
        else
            break
        end
        task.wait()
    end
    getgenv().Mainfarm = false
    game.Workspace.Gravity = 200
end

local function AltStart()
    MapSetup()
    BreakVel()

    getgenv().Altfarm = true

    while getgenv().Altfarm and (altGUI.Text == "Infection" or altGUI.Text == "Free For All") do
        local playerList = Players:GetPlayers()
        local currentIndex = 1

        while getgenv().Altfarm and (altGUI.Text == "Infection" or altGUI.Text == "Free For All") do
            local targetPlayer = playerList[currentIndex]
            if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
                local startTime = tick()

                local knife = Players.LocalPlayer.Backpack:FindFirstChild("Knife")
                if knife then
                    knife.Parent = Players.LocalPlayer.Character
                end

                while tick() - startTime < 2 and getgenv().Altfarm and targetPlayer:FindFirstChild("HumanoidRootPart") do
                    Kill(targetPlayer)
                    task.wait()
                end

                currentIndex = currentIndex + 1
                if currentIndex > #playerList then
                    currentIndex = 1
                end
            else
                currentIndex = currentIndex + 1
                if currentIndex > #playerList then
                    currentIndex = 1
                end
            end
            task.wait()
        end
    end
    getgenv().Altfarm = false
    Workspace.Gravity = 200
end

mainGUI:GetPropertyChangedSignal("Visible"):Connect(function()
    if mainGUI.Visible then
        Start()
    end
end)

altGUI:GetPropertyChangedSignal("Text"):Connect(function()
    if altGUI.Text == "Free For All" or altGUI.Text == "Infection" then
        AltStart()
    end
end)

task.spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if Players.LocalPlayer.Character and (getgenv().Mainfarm or getgenv().Altfarm) and not cooldown then
            local target = game.Workspace:FindFirstChild(knifePlayer)
            if target and Players.LocalPlayer:DistanceFromCharacter(target.HumanoidRootPart.Position) <= 8 then
                Players.LocalPlayer.PlayerScripts.localknifehandler.HitCheck:Fire(target)
            end
            coroutine.wrap(function()
                cooldown = true
                task.wait(0.75)
                cooldown = false
            end)()
        else
            task.wait()
        end
    end)
end)

Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
print("--------------------- <3")
print("\n")
print("Astra's Assassin autofarm has loaded!")
print("\n")
print("--------------------- <3")
game:GetService("StarterGui"):SetCore("SendNotification",{["Title"] = "Successfully loaded!",["Text"] = "Astra's Assassin autofarm has loaded.",["Duration"] = 5,["Button1"] = "Purrfect!"})
