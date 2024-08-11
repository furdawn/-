-- Detect alt gamemodes, Should be easy by just teleporting to every player and stabbing them repeatedly until the match is over.

getgenv().Autofarm = nil

local TweenService = game:GetService("TweenService")
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

local function DestroyMap()
    local map = game.Workspace:FindFirstChild("GameMap")
    for _, v in pairs(map:GetDescendants()) do
        if v:IsA("BasePart") then
            v:Destroy()
        end
    end
end

local function BreakVelo()
    for _, v in ipairs(Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Velocity, v.RotVelocity = Vector3.zero, Vector3.zero
        end
    end
end

local function Hitbox()
    for _, player in pairs(Players:GetPlayers()) do
        local character = game.Workspace:FindFirstChild(player.Name)
        if character and player.Name ~= Players.LocalPlayer.Name then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Size = Vector3.new(12, 12, 12)
                humanoidRootPart.Transparency = 0.90
                humanoidRootPart.BrickColor = BrickColor.New("Pink")
            end
        end
    end
end

local function Kill(targetPlayer, currentTarget)
    if targetPlayer and targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("HumanoidRootPart") then
        local localRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetPlayer:FindFirstChild("HumanoidRootPart")

        if localRoot and targetRoot then
            local offset = targetRoot.CFrame:vectorToWorldSpace(Vector3.new(3, 0, 2)) + Vector3.new(0, -5, 0)
            local targetCFrame = targetRoot.CFrame + offset
            local tween = TweenService:Create(localRoot, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
            tween:Play()
        end

        Players.LocalPlayer.PlayerScripts.localknifehandler.HitCheck:Fire(targetPlayer)
    end
end

local function Start()
    getgenv().Autofarm = true
    Hitbox()
    BreakVelo()
    Players.LocalPlayer.Character.Animate.Disabled = true
    DestroyMap()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        task.wait()
    end

    local previousTarget = targetGUI.TargetText.Text
    local targetPlayer = game.Workspace:FindFirstChild(previousTarget)

    while targetGUI.Visible and getgenv.Autofarm == true do
        local currentTarget = targetGUI.TargetText.Text
        if currentTarget ~= previousTarget then
            targetPlayer = game.Workspace:FindFirstChild(currentTarget)
            previousTarget = currentTarget

            if not targetPlayer then
                break
            end
        end

        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
            Kill(targetPlayer, currentTarget)
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

print("--------------------- <3")
print("\n")
print("Astra's Assassin autofarm has loaded!")
print("\n")
print("--------------------- <3")
game:GetService("StarterGui"):SetCore("SendNotification",{["Title"] = "Successfully loaded!",["Text"] = "Astra's Assassin autofarm has loaded.",["Duration"] = 5,["Button1"] = "Purrfect!"})
