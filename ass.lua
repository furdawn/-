repeat wait() until game:IsLoaded()
if game.PlaceId ~= 379614936 then
    game.Players.LocalPlayer:Kick("Wrong game! (Assassin!)")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:FindFirstChild("Backpack")

print("Optimization")

--- Optimization stuff :3
game.Workspace.Gravity = 0
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
Lighting.Brightness = 0
Lighting.GlobalShadows = false
settings().Rendering.QualityLevel = "Level01"
local function Optimizer()
    LocalPlayer.Character.Animate.Disabled = true
    if v:IsA("Texture") or v:IsA("Decal") then
        v:Destroy()
    end
    if v:IsA("Part") or v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    end
    if v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Enabled = false
    end
end
--- Optimization stuff :3

print("Noclip")

local function NoclipLoop()
    if Clip == false and speaker.Character ~= nil then
        for _, child in pairs(speaker.Character:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
                child.CanCollide = false
            end
        end
    end
end
Noclipping = RunService.Stepped:Connect(NoclipLoop)

local function setTween(targetPos)
    local tweenInfo = TweenInfo.new(0, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(localHumanoid, tweenInfo, { CFrame = CFrame.new(targetPos) })
    tween:Play()
    tween.Completed:Wait()
end

print("Optimizer")

Optimizer()
ReplicatedStorage.Remotes.WaitForChild("SheathKnife"):FireServer("off")
local targetGui = Players.LocalPlayer.PlayerGui.ScreenGui.UI.Target
local targetText = targetGui.TargetText.Text
local previousTarget = ""

print("Game started")

while targetGui.Visible do
    print("Visible")
    local targetName = targetText
    if targetName ~= previousTarget then
        previousTarget = targetName
        local targetPlayer = game.Players:FindFirstChild(targetName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
            local args = {
                [1] = targetPosition,
                [2] = 0,
                [3] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            }
            setTween(targetPosition - Vector3.new(0, -5, 0))
            print("Tween")
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ThrowKnife"):FireServer(unpack(args))
            print("Thrown")
        end
    end
    targetText = targetGui.TargetText.Text
    print("Updated targetText")
end
