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

local function Kill(targetPlayer)
    if targetPlayer and targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("HumanoidRootPart") then
        local localRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetPlayer:FindFirstChild("HumanoidRootPart")

        if localRoot and targetRoot then
            localRoot.CFrame = CFrame.new(targetRoot.Position - Vector3.new(0, 3, 2))
        end

        BreakVelo()

        local args = {
            [1] = targetRoot.Position,
            [2] = 0,
            [3] = CFrame.new()
        }
        ReplicatedStorage.Remotes:FindFirstChild("ThrowKnife"):FireServer(unpack(args))
    end
end

local function Start()
    DestroyMap()
    BreakVelo()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        wait()
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
            Kill(targetPlayer)
        else
            break
        end
        wait()
    end
end

local function onVisibilityChanged()
    if targetGUI.Visible then
        Start()
    end
end

targetGUI:GetPropertyChangedSignal("Visible"):Connect(onVisibilityChanged)
