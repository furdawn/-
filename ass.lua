print("23242")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain
local Players = game:GetService("Players")

Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
Lighting.Brightness = 0
Lighting.GlobalShadows = false
settings().Rendering.QualityLevel = "Level01"

local function DestroyMap()
    Players.LocalPlayer.Character.Animate.Disabled = true
    for _, v in ipairs(game.Workspace.GameMap:GetDescendants()) do
        if v:IsA("BasePart") then
            v:Destroy()
        end
    end
end

local function GotoTarget(targetPlayer)
    print("Going")
    local femboyRoot = Players.LocalPlayer.Character.HumanoidRootPart
    local targetRoot = targetPlayer.Character.HumanoidRootPart
    local tween = TweenService:Create(femboyRoot, TweenInfo.new(0, Enum.EasingStyle.Linear), {CFrame = targetRoot.CFrame + Vector3.new(-2, -2, 0)})
    tween:Play()
end

local function GameStart()
    print("Game started.")
    game.Workspace.Gravity = 0
    DestroyMap()

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SheathKnife"):FireServer("off")

    local targetGui = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")
    local targetText = targetGui.TargetText.Text
    local gameEnded = false

    print(targetText)

    local targetPlayer = Players:FindFirstChild(targetText)
    if targetPlayer then
        print("Passed IF")
        GotoTarget(targetPlayer)
        print("Went")
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        local args = {
            [1] = targetPosition,
            [2] = 0,
            [3] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        }
        ReplicatedStorage.Remotes:FindFirstChild("ThrowKnife"):FireServer(unpack(args))
    end
end

Players.LocalPlayer.Backpack.ChildAdded:Connect(function(v)
    GameStart()
end)
