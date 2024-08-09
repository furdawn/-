print("mewmeramstdgfrdsg")

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
    LocalPlayer.Character.HumanoidRootPart.Anchored = true
    if LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = rootPart.CFrame - Vector3.new(0, 10, 0)
        end
    end
end

local function GameStart()
    DestroyMap()
    HidePlayer()

    local targetGui = Players.LocalPlayer.PlayerGui.ScreenGui.UI.Target
    local previousTarget = ""
    local knifeFound = true

    while knifeFound do
        local targetText = targetGui.TargetText.Text
        if targetText ~= previousTarget then
            previousTarget = targetText
            local targetPlayer = game.Players:FindFirstChild(targetText)
            if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
                local backpack = targetPlayer.Backpack
                local knife = backpack:FindFirstChild("Knife")
                
                if knife then
                    if LocalPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.Animate.Disabled = true
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
        wait(0.1)
    end
end

LocalPlayer.Backpack.ChildAdded:Connect(function(v)
    if v.Name == "Knife" then
        GameStart()
    end
end)
