print("asd")

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
    local Map = game.Workspace:FindFirstChild("GameMap")
    if Map then
        for _, v in ipairs(Map:GetDescendants()) do
            if v:IsA("BasePart") then
                v:Destroy()
            end
        end
    end
end

function getRoot(targetChar)
    local rootPart = targetChar:FindFirstChild('HumanoidRootPart') or targetChar:FindFirstChild('Torso') or targetChar:FindFirstChild('UpperTorso') or targetChar:FindFirstChild('LowerTorso') or targetChar:FindFirstChild('Head')
    return rootPart
end


local function GotoTarget(targetUser)
    local femboyRoot = getRoot(Players.LocalPlayer.Character)
    local targetPlayer = Players:FindFirstChild(targetUser)

    if targetPlayer then
        local targetRoot = getRoot(targetPlayer.Character)
        local tween = TweenService:Create(femboyRoot, TweenInfo.new(0, Enum.EasingStyle.Linear), {CFrame = targetRoot.CFrame + Vector3.new(-2, -2, 0)})
        tween:Play()
    else
        print("Player not found.")
    end
end

local function Assassinate()
    game.Workspace.Gravity = 0
    DestroyMap()

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SheathKnife"):FireServer("off")

    local targetGui = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")
    local targetUser = targetGui.TargetText.Text

    if Players:FindFirstChild(targetUser) then
        print("Passed")
        GotoTarget(targetUser)
        local args = {
            [1] = getRoot(targetUser.Character),
            [2] = 0,
            [3] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        }
        ReplicatedStorage.Remotes:FindFirstChild("ThrowKnife"):FireServer(unpack(args))
    end
end

local function onVisibilityChanged()
    if Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target").Visible then
        Assassinate()
    end
end

Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target"):GetPropertyChangedSignal("Visible"):Connect(onVisibilityChanged)
