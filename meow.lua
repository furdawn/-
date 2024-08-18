repeat task.wait() until game:IsLoaded()
getgenv().Mainfarm = nil

local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain

Players.LocalPlayer.PlayerGui:FindFirstChild("MobileShiftLock"):Destroy()
local mainGUI = Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")
local altGUI = Players.LocalPlayer.PlayerGui.ScreenGui.UI.GamemodeMessage.textD
local knifePlayer

Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
Lighting.Brightness = 0
Lighting.GlobalShadows = false
settings().Rendering.QualityLevel = 1
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    end
end

local function BreakVel()
    for _, v in ipairs(Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

local function MapSetup()
    game.Workspace.Gravity = 215
    task.wait(1.25)
    Players.LocalPlayer.Character.Animate.Disabled = true
    game.Workspace.Gravity = 0
    for _, v in ipairs(game.Workspace.GameMap:GetDescendants()) do
        if v and v:IsA("BasePart") then
            v:Destroy()
        end
    end
    for _, v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
        if v and v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

local function Kill(targetPlayer)
    if targetPlayer and targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("HumanoidRootPart") then
        local localRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetPlayer:FindFirstChild("HumanoidRootPart")

        if localRoot and targetRoot then
            local offset = CFrame.new(-1, -5.75, 1)
            local targetCFrame = targetRoot.CFrame * offset
            local tween = TweenService:Create(localRoot, TweenInfo.new(0, Enum.EasingStyle.Linear), { CFrame = targetCFrame })
            tween:Play()
        end
    end
    BreakVel()
end

local function Start()
    MapSetup()
    BreakVel()

    getgenv().Mainfarm = true

    local targetText = mainGUI.TargetText.Text
    local targetPlayer = game.Workspace:FindFirstChild(targetText)

    while mainGUI.Visible and getgenv().Mainfarm do
        local currentTarget = mainGUI.TargetText.Text
        if currentTarget ~= targetText then
            targetPlayer = game.Workspace:FindFirstChild(currentTarget)
            targetText = currentTarget

            if not targetPlayer then
                break
            end
        end

        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
            local knife = Players.LocalPlayer.Backpack:FindFirstChild("Knife")
            if knife then
                knife.Parent = Players.LocalPlayer.Character
            end

            knifePlayer = targetText
            Kill(targetPlayer)
        else
            break
        end
        task.wait()
    end
    getgenv().Mainfarm = false
    game.Workspace.Gravity = 200
end

local function AltStart()
    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        task.wait()
    end
    Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
end

mainGUI:GetPropertyChangedSignal("Visible"):Connect(function()
    if mainGUI.Visible then
        Start()
    end
end)

altGUI:GetPropertyChangedSignal("Text"):Connect(function()
    if altGUI.Text == "Infection" or altGUI.Text == "Free For All" or altGUI.Text == "Juggernaut" then
        AltStart()
    end
end)

task.spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if Players.LocalPlayer.Character and getgenv().Mainfarm and not cooldown then
            local target = game.Workspace:FindFirstChild(knifePlayer)
            if target and target:FindFirstChild("HumanoidRootPart") then
                if Players.LocalPlayer:DistanceFromCharacter(target.Head.Position) <= 6.5 then
                    Players.LocalPlayer.PlayerScripts.localknifehandler.HitCheck:Fire(target)
                end
            end
            coroutine.wrap(function()
                cooldown = true
                task.wait(0.8)
                cooldown = false
            end)()
        else
            task.wait()
        end
    end)
end)

Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
print("--------------------- <3")
print("\n")
print("Astra's Assassin autofarm has loaded!")
print("\n")
print("--------------------- <3")
game:GetService("StarterGui"):SetCore("SendNotification",{["Title"] = "Successfully loaded!",["Text"] = "Astra's Assassin autofarm has loaded.",["Duration"] = 5,["Button1"] = "Purrfect!"})
