print("mwwowowowow")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain
local Players = game:GetService("Players")

local TargetGUI = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")

game.Workspace.Gravity = 0
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
Lighting.Brightness = 0
Lighting.GlobalShadows = false
settings().Rendering.QualityLevel = 1

local function DestroyMap()
    local Map = game.Workspace:FindFirstChild("GameMap")
    for _, v in pairs(Map:GetDescendants()) do
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

local function GotoTarget(gotoUser)
    local TargetPlayer = game.Workspace:FindFirstChild(gotoUser)
    if TargetPlayer and TargetPlayer:IsA("Model") and TargetPlayer:FindFirstChild("HumanoidRootPart") then
        local localHumanoid = Players.LocalPlayer.Character.HumanoidRootPart
        local targetHumanoid = TargetPlayer:FindFirstChild("HumanoidRootPart")
        if localHumanoid and targetHumanoid then
            print("a")
            --localHumanoid.CFrame = targetHumanoid.CFrame * CFrame.new(0, -5, -5)
        end
    end
    BreakVelo()
end

local function Assassinate()
    Players.LocalPlayer.Character.Animate.Disabled = true
    DestroyMap()
    BreakVelo()

    print("111")

    local Knife = Players.LocalPlayer:FindFirstChildOfClass("Backpack").Knife
    Knife.Parent = Players.LocalPlayer.Character

    local TargetUser = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target").TargetText.Text
    local CurTarget = TargetUser

    while CurTarget == TargetUser do
        GotoTarget(CurTarget)
        print("222")
        local TargetPlayer = game.Workspace:FindFirstChild(TargetUser)
        if TargetPlayer and TargetPlayer:IsA("Model") and TargetPlayer:FindFirstChild("HumanoidRootPart") then
            local targetHumanoid = TargetPlayer:FindFirstChild("HumanoidRootPart")
            local args = {
                [1] = targetHumanoid.Position,
                [2] = 0,
                [3] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            }
            print(targetHumanoid.Position)
            ReplicatedStorage.Remotes:FindFirstChild("ThrowKnife"):FireServer(unpack(args))
        end
        TargetUser = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target").TargetText.Text
    end
end

local function onVisibilityChanged()
    if TargetGUI.Visible then
        Assassinate()
    end
end

TargetGUI:GetPropertyChangedSignal("Visible"):Connect(onVisibilityChanged)
