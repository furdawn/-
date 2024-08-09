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

local function HidePlayer()
    game.Workspace.Gravity = 0
    local FemboyRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    Players.LocalPlayer.Character.Animate.Disabled = true
    TweenService:Create(FemboyRoot, TweenInfo.new(0, Enum.EasingStyle.Linear), {CFrame = Vector3.new(0,-5, 0)}):Play()
    Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
end

local function GameStart()
    game.Workspace.Gravity = 196.2
    DestroyMap()
    HidePlayer()
    print("Game started thing")

end

Players.LocalPlayer.Backpack.ChildAdded:Connect(function(v)
    if v.Name == "Knife" then
        GameStart()
    end
end)
