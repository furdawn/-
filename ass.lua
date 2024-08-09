-- Detect gamemodes

repeat wait() until game:IsLoaded()
if game.PlaceId ~= 379614936 then
    game.Players.LocalPlayer:Kick("Wrong game! (Assassin!)")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--- Optimization stuff :3
game.Workspace.Gravity = 0
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
    LocalPlayer.Character.Animate.Disabled = true
    if LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = rootPart.CFrame - Vector3.new(0, 10, 0)
        end
    end
    LocalPlayer.Character.HumanoidRootPart.Anchored = true
end

local function GameStart()
    DestroyMap()
    HidePlayer()
    print("Game started thing")
end

LocalPlayer.Backpack.ChildAdded:Connect(function(v)
    if v.Name == "Knife" then
        GameStart()
    end
end)
