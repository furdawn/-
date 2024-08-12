repeat task.wait() until game:IsLoaded()
getgenv().Mainfarm = nil
getgenv().Altfarm = nil

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain

Players.LocalPlayer.PlayerGui.MobileShiftLock:Destroy()
local mainGUI = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")
local altGUI = Players.LocalPlayer.PlayerGui.ScreenGui.UI.GamemodeMessage.textD
local targetText = nil

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

local function ServerHop()
    -- Make this teleport when the server size is less than <= 3
end

local function BreakVelo()
    game.Workspace.Gravity = 250
    for _, v in ipairs(Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Velocity, v.RotVelocity = Vector3.zero, Vector3.zero
        end
    end
    Players.LocalPlayer.Character.Animate.Disabled = true
end

local function DestroyMap()
    game.Workspace.Gravity = 0
    local map = game.Workspace:FindFirstChild("GameMap")
    for _, v in pairs(map:GetDescendants()) do
        if v:IsA("BasePart") then
            v:Destroy()
        end
    end
end

local function SetupAtlas()
    for _, v in pairs(Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("BasePart") and
            v.Name == "Right Leg" or
            v.Name == "Left Leg" then
            v:Destroy()
        end
    end
end

local function Kill(targetPlayer)
    if targetPlayer and targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("HumanoidRootPart") then
        local localRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetPlayer:FindFirstChild("HumanoidRootPart")

        if localRoot and targetRoot then
            local offset = targetRoot.CFrame:vectorToWorldSpace(Vector3.new(-1.5, 0, 0.5) + Vector3.new(0, -3, 0))
            localRoot.CFrame = targetRoot.CFrame + offset
        end
    end
end

local function Start()
    targetText = nil
    BreakVelo()
    DestroyMap()
    SetupAtlas()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        task.wait()
    end

    targetText = mainGUI.TargetText.Text
    local targetPlayer = game.Workspace:FindFirstChild(targetText)

    getgenv().Mainfarm = true

    while mainGUI.Visible and getgenv().Mainfarm == true do
        local currentTarget = mainGUI.TargetText.Text
        if currentTarget ~= targetText then
            targetPlayer = game.Workspace:FindFirstChild(currentTarget)
            targetText = currentTarget

            if not targetPlayer then
                break
            end
        end

        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
            Kill(targetPlayer)
            task.wait(0.2)
        else
            break
        end
        task.wait()
    end
    getgenv().Mainfarm = false
    game.Workspace.Gravity = 250
end

local function AltStart()
    targetText = nil
    BreakVelo()
    DestroyMap()
    SetupAtlas()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        task.wait()
    end

    getgenv().Altfarm = true

    while altGUI.Text == "Free For All" or altGUI.Text == "Infection" and getgenv().Altfarm do
        for _, v in ipairs(Players:GetPlayers()) do
            if game.Workspace[v.Name]:FindFirstChild("HumanoidRootPart") then
                local knife = game.Workspace[v.Name]:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife")
                if knife then
                    targetText = v.Name
                    Kill(v)
                    task.wait(0.2)
                else
                    break
                end
            end
        end
        task.wait()
    end
end

mainGUI:GetPropertyChangedSignal("Visible"):Connect(function()
    if mainGUI.Visible then
        Start()
    end
end)

altGUI:GetPropertyChangedSignal("Text"):Connect(function()
    if altGUI.Text == "Free For All" or "Infection" then
        AltStart()
    end
end)

local cooldown = false
task.spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        if not cooldown and Players.LocalPlayer.Character and getgenv().Mainfarm or getgenv().Altfarm then
            if Players.LocalPlayer:DistanceFromCharacter(game.Workspace[targetText].Head.Position) <= 8 then
                Players.LocalPlayer.PlayerScripts.localknifehandler.HitCheck:Fire(game.Workspace[targetText])
                coroutine.wrap(function()
                    cooldown = true
                    task.wait(0.15)
                    cooldown = false
                end)()
            else
                task.wait()
            end
        end
    end)
end)

print("--------------------- <3")
print("\n")
print("Astra's Assassin autofarm has loaded!")
print("\n")
print("--------------------- <3")
game:GetService("StarterGui"):SetCore("SendNotification",{["Title"] = "Successfully loaded!",["Text"] = "Astra's Assassin autofarm has loaded.",["Duration"] = 5,["Button1"] = "Purrfect!"})
