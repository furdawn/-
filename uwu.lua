---@diagnostic disable: undefined-global
getgenv().Autofarm = true

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain

local targetGUI = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")

game.Workspace.Gravity = 0
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
Lighting.Brightness = 0
Lighting.GlobalShadows = false
settings().Rendering.QualityLevel = 1
for i,v in pairs(game:GetDescendants()) do
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
    for _, v in ipairs(Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Velocity, v.RotVelocity = Vector3.zero, Vector3.zero
        end
    end
end

local function DestroyMap()
    local map = game.Workspace:FindFirstChild("GameMap")
    for _, v in pairs(map:GetDescendants()) do
        if v:IsA("BasePart") then
            v:Destroy()
        end
    end
end

local function SetupAtlas()
    Players.LocalPlayer.Character.Animate.Disabled = true
    for i,v in pairs(Players.LocalPlayer.Character:GetChildren()) do
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
            local offset = targetRoot.CFrame:vectorToWorldSpace(Vector3.new(-1.5, 0, 1) + Vector3.new(0, -4, 0))
            localRoot.CFrame = targetRoot.CFrame + offset
        end
    end
end

local function Start()
    getgenv().Autofarm = true
    BreakVelo()
    DestroyMap()
    SetupAtlas()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        task.wait()
    end

    local previousTarget = targetGUI.TargetText.Text
    local targetPlayer = game.Workspace:FindFirstChild(previousTarget)

    while targetGUI.Visible and getgenv().Autofarm == true do
        local currentTarget = targetGUI.TargetText.Text
        if currentTarget ~= previousTarget then
            targetPlayer = game.Workspace:FindFirstChild(currentTarget)
            previousTarget = currentTarget

            if not targetPlayer then
                break
            end
        end

        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
            Kill(targetPlayer)
            task.wait(0.25)
       else
            break
        end
        task.wait()
    end
    getgenv().Autofarm = false
end

local function onVisibilityChanged()
    if targetGUI.Visible then
        Start()
    end
end

targetGUI:GetPropertyChangedSignal("Visible"):Connect(onVisibilityChanged)

task.spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if Players.LocalPlayer.Character and not cooldown and game.Players.LocalPlayer.PlayerGui.ScreenGui.UI.Target.Visible == true and getgenv().Autofarm == true then
            if Players.LocalPlayer:DistanceFromCharacter(game.Workspace[game.Players.LocalPlayer.PlayerGui.ScreenGui.UI.Target.TargetText.Text].Head.Position) <= 6.5 then
                Players.LocalPlayer.PlayerScripts.localknifehandler.HitCheck:Fire(game.Workspace[game.Players.LocalPlayer.PlayerGui.ScreenGui.UI.Target.TargetText.Text])
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

print("--------------------- <3")
print("\n")
print("Astra's Assassin autofarm has loaded!")
print("\n")
print("--------------------- <3")
game:GetService("StarterGui"):SetCore("SendNotification",{["Title"] = "Successfully loaded!",["Text"] = "Astra's Assassin autofarm has loaded.",["Duration"] = 5,["Button1"] = "Purrfect!"})
