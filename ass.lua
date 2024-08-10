print("asmfgsrjmhsd")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain
local Players = game:GetService("Players")

local TargetGUI = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target").Visible

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
            if v and v:IsA("BasePart") then
                pcall(function()
                    v:Destroy()
                end)
            end
        end
    end
end

local function Assassinate()
    game.Workspace.Gravity = 0
    DestroyMap()

    while #Players.LocalPlayer:WaitForChild("Backpack"):GetChildren() == 0 do
        task.wait()
    end

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SheathKnife"):FireServer("off")

    local targetGui = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")
    local targetUser = targetGui.TargetText.Text
    local targetPlr = Players:FindFirstChild(targetUser)

    local function GotoTarget(gotoUser)
        local targetPlayer = Players:FindFirstChild(gotoUser)

        if targetPlayer then
            local tween = TweenService:Create(Players.LocalPlayer.Character.KnifeHandle.CFrame, TweenInfo.new(0, Enum.EasingStyle.Linear), {CFrame = targetPlayer.Character.KnifeHandle.CFrame + Vector3.new(-2, -2, 0)})
            tween:Play()
        else
            print("Player not found.")
        end
    end

    local function checkTarget(currentUser)
        if targetGui then
            return targetGui.TargetText.Text ~= currentUser
        end
        return false
    end

    if targetPlr then
        print("Passed")
        while not checkTarget(targetUser) and TargetGUI.Visible do
            GotoTarget(targetUser)
            task.wait(0.15)
            local args = {
                [1] = targetUser.KnifeHandle.CFrame,
                [2] = 0,
                [3] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            }
            ReplicatedStorage.Remotes:FindFirstChild("ThrowKnife"):FireServer(unpack(args))
        end
    end
end

local function onVisibilityChanged()
    if TargetGUI.Visible then
        Assassinate()
    end
end

TargetGUI:GetPropertyChangedSignal("Visible"):Connect(onVisibilityChanged)
