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
        if character and not ~= Players.LocalPlayer.Name then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.BrickColor = BrickColor.new("Pink")
                humanoidRootPart.Size = Vector3.new(8, 8, 8)
                humanoidRootPart.Transparency = 0.95
                humanoidRootPart.CanCollide = false
            end
        end
    end
end

local function Kill(targetPlayer, currentTarget)
    if targetPlayer and targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("HumanoidRootPart") then
        local localRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetPlayer:FindFirstChild("HumanoidRootPart")
        local rdmstring

        task.wait(0.1)

        if localRoot and targetRoot then
            local offset = targetRoot.CFrame:vectorToWorldSpace(Vector3.new(0, 0, 2.5)) + Vector3.new(0, -4, 0)
            localRoot.CFrame = targetRoot.CFrame + offset
        end

        local args = {
            [1] = game:GetService("Players"):WaitForChild(currentTarget),
            [2] = "357a2a31448848af77500551969ebec5351969",
            [3] = 0,
            [4] = "3135089fb9ba3c65cec03b2a8745f79fa8658f"
        }
        for _, v in ipairs(game:GetService("SocialService"):GetChildren()) do
            if v:IsA("RemoteEvent") then
                v:FireServer(unpack(args))
            end
        end
    end
end

local function Start()
    Hitbox()
    BreakVelo()
    Players.LocalPlayer.Character.Animate.Disabled = true
    DestroyMap()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        task.wait()
    end

    local previousTarget = targetGUI.TargetText.Text
    local targetPlayer = game.Workspace:FindFirstChild(previousTarget)

    while targetGUI.Visible do
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
game:GetService("StarterGui"):SetCore("SendNotification",{["Title"] = "Correct key!",["Text"] = "Astra's Assassin autofarm has loaded.",["Duration"] = 5,["Button1"] = "Purrfect!"})
