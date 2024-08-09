-- Detect gamemodes

repeat wait() until game:IsLoaded()
if game.PlaceId ~= 379614936 then
    game.Players.LocalPlayer:Kick("Wrong game! (Assassin!)")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain
local Players = game:GetService("Players")

--- Optimization stuff :3
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
Lighting.Brightness = 0
Lighting.GlobalShadows = false
settings().Rendering.QualityLevel = "Level01"
--- Optimization stuff :3

local function DestroyMap()
    for _, v in ipairs(game.Workspace.GameMap:GetDescendants()) do
        if v:IsA("BasePart") then
            v:Destroy()
        end
    end
end

local function GotoTarget(targetPlayer)
    local femboyRoot = Players.LocalPlayer.HumanoidRootPart
    local targetRoot = targetPlayer.Character.HumanoidRootPart
    Players.LocalPlayer.Character.Animate.Disabled = true
    TweenService:Create(femboyRoot, TweenInfo.new(0, Enum.EasingStyle.Linear), {CFrame = targetRoot.CFrame + Vector3.new(-2, -2, 0)}):Play()
end

local function GameStart()
    print("Game started.")

    game.Workspace.Gravity = 0
    DestroyMap()

    local targetGui = Players.LocalPlayer.PlayerGui.ScreenGui.UI.Target
    local targetText = targetGui.TargetText.Text
    print(targetText)
    local knifeFound = true

    while knifeFound do
        print("easdasdsa")
        local targetPlayer = game.Players:FindFirstChild(targetText)
        if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
            local knife = targetPlayer.Backpack:FindFirstChild("Knife")
            if knife then
                if Players.LocalPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    GotoTarget(targetPlayer)
                    local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                    local args = {
                        [1] = targetPosition,
                        [2] = 0,
                        [3] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                    }
                    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ThrowKnife"):FireServer(unpack(args))
                end
            else
                knifeFound = false
            end
        end
    end
end

Players.LocalPlayer.Backpack.ChildAdded:Connect(function(v)
    if v.Name == "Knife" then
        GameStart()
    end
end)
