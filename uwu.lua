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
for _, v in pairs(game:GetDescendants()) do
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

local function BreakVelo()
    for _, v in ipairs(Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Velocity, v.RotVelocity = Vector3.zero, Vector3.zero
        end
    end
    Players.LocalPlayer.Character.Animate.Disabled = true
end

local function DestroyMap()
    workspace.Gravity = 0
    for _, v in pairs(Players:GetPlayers()) do
        if game.Workspace[v.Name] then
            for _, child in ipairs(game.Workspace[v.Name]:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CanCollide = false
                end
            end
        end
    end
    for _, v in pairs(game.Workspace.GameMap:GetDescendants()) do
        if v and v:IsA("BasePart") then
            v:Destroy()
        end
    end
end

local function Kill(targetPlayer)
    if targetPlayer and targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("HumanoidRootPart") then
        local localRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetPlayer:FindFirstChild("HumanoidRootPart")

        if localRoot and targetRoot then
            local offset = CFrame.new(0, -5, 0)
            local targetCFrame = targetRoot.CFrame * offset
            local tween = TweenService:Create(localRoot, TweenInfo.new(0, Enum.EasingStyle.Linear), { CFrame = targetCFrame })
            tween:Play()
            tween.Completed:Wait()
        end
    end
    BreakVelo()
end

local function Start()
    workspace.Gravity = 215
    BreakVelo()
    DestroyMap()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        task.wait()
    end

    local targetText = mainGUI.TargetText.Text
    local targetPlayer = game.Workspace:FindFirstChild(targetText)

    getgenv().Mainfarm = true

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
            knifePlayer = targetText
            Kill(targetPlayer)
        else
            break
        end
        task.wait()
    end
    getgenv().Mainfarm = false
    workspace.Gravity = 215
end

local function AltStart()
    workspace.Gravity = 215
    BreakVelo()
    DestroyMap()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        task.wait()
    end

    getgenv().Altfarm = true

    while altGUI.Text == "Free For All" or altGUI.Text == "Infection" and getgenv().Altfarm do
        for _, v in pairs(Players:GetPlayers()) do
            local startTime = tick()
            while tick() - startTime < 3 do
                if game.Workspace[v.Name] and game.Workspace[v.Name]:FindFirstChild("HumanoidRootPart") then
                    knifePlayer = v.Name
                    local targetPlayer = game.Workspace[v.Name]
                    Kill(targetPlayer)
                end
            end
        end
        task.wait()
    end
    getgenv().Altfarm = false
    workspace.Gravity = 215
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
        if Players.LocalPlayer.Character then
            for _, v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
            if (getgenv().Mainfarm or getgenv().Altfarm) and not cooldown then
                local target = game.Workspace[knifePlayer]
                if target and Players.LocalPlayer:DistanceFromCharacter(target.Head.Position) <= 8 then
                    Players.LocalPlayer.PlayerScripts.localknifehandler.HitCheck:Fire(target)
                end
                coroutine.wrap(function()
                    cooldown = true
                    task.wait(0.8)
                    cooldown = false
                end)()
            else
                task.wait()
            end
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
