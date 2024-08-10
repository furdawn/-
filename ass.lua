print("alkternart")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain
local Players = game:GetService("Players")

local targetGUI = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")

game.Workspace.Gravity = 0
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
Lighting.Brightness = 0
Lighting.GlobalShadows = false
settings().Rendering.QualityLevel = 1

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

local function Start()
    DestroyMap()
    BreakVelo()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        wait()
    end

    local targetUser = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target").TargetText.Text
    local targetPlayer = game.Workspace:FindFirstChild(targetUser)

    if targetPlayer and targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("HumanoidRootPart") then
        local localHumanoid = Players.LocalPlayer.Character.HumanoidRootPart
        local targetHumanoid = targetPlayer:FindFirstChild("HumanoidRootPart")
        if localHumanoid and targetHumanoid then
            localHumanoid.CFrame = CFrame.new(targetHumanoid.Position - Vector3.new(0, 3, 2))
        end
    end

    BreakVelo()

    if targetPlayer and targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("HumanoidRootPart") then
        local targetHumanoid = targetPlayer:FindFirstChild("HumanoidRootPart")
        local args = {
            [1] = targetHumanoid.Position,
            [2] = 0,
            [3] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        }
        ReplicatedStorage.Remotes:FindFirstChild("ThrowKnife"):FireServer(unpack(args))
    end
end

local function StartALT()
    print("Different gamemode")
end

local function onVisibilityChanged()
    if targetGUI.Visible then
        Start()
    else
        StartALT()
    end
end

targetGUI:GetPropertyChangedSignal("Visible"):Connect(onVisibilityChanged)
