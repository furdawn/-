print("asdasdasdsd")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain
local Players = game:GetService("Players")

local TargetGUI = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")

game.Workspace.Gravity = 0

local function GotoTarget(gotoUser)
    local TargetPlayer = game.Workspace:FindFirstChild(gotoUser)
    if TargetPlayer and TargetPlayer:IsA("Model") and TargetPlayer:FindFirstChild("HumanoidRootPart") then
        local localHumanoid = Players.LocalPlayer.Character.HumanoidRootPart
        local targetHumanoid = TargetPlayer:FindFirstChild("HumanoidRootPart")
        if localHumanoid and targetHumanoid then
            local tween = TweenService:Create(localHumanoid, TweenInfo.new(0, Enum.EasingStyle.Linear), {CFrame = targetHumanoid.CFrame * CFrame.new(0, -4, -5)})
            tween:Play()
        end
    end
end

local function CheckTarget(currentUser)
    if TargetGUI then
        return TargetGUI.TargetText.Text ~= currentUser
    end
    return false
end

local function Assassinate()
    print("111")

    while #Players.LocalPlayer:WaitForChild("Backpack"):GetChildren() == 0 do
        task.wait(0.5)
    end

    print("222")

    local knife = Players.LocalPlayer:FindFirstChildOfClass("Backpack").Knife
    knife.Parent = Players.LocalPlayer.Character

    local targetUser = TargetGUI.TargetText.Text

    print("333")

    while not CheckTarget(targetUser) and Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target").Visible do
        print("444")
        GotoTarget(targetUser)
        local TargetPlayer = game.Workspace:FindFirstChild(targetUser)
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
    end
end

local function onVisibilityChanged()
    if TargetGUI.Visible then
        Assassinate()
    end
end

TargetGUI:GetPropertyChangedSignal("Visible"):Connect(onVisibilityChanged)
