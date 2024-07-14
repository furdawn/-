local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function Noclip()
    for _, v in next, Players.LocalPlayer.Character:GetDescendants() do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
    workspace.Gravity = 0
    Players.LocalPlayer.Character.Animate.Disabled = true
end

local function ResetCharacter()
    Players.LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(15)
end

local function endRound(targetPlayer)
    print("Flinging murderer SMIRK TEHE~")

    local humanoidRootPart = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local flingDied = nil
    local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()

    for _, child in pairs(Players.LocalPlayer.Character:GetDescendants()) do
        if child:IsA("BasePart") then
            child.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
        end
    end

    Noclip()

    local bambam = Instance.new("BodyAngularVelocity")
    bambam.Name = "MMMMYUMMMY"
    bambam.Parent = Players.LocalPlayer.Character.HumanoidRootPart
    bambam.AngularVelocity = Vector3.new(0, 99999, 0)
    bambam.MaxTorque = Vector3.new(0, math.huge, 0)
    bambam.P = math.huge

    for _, v in next, Players.LocalPlayer.Character:GetChildren() do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Massless = true
            v.Velocity = Vector3.new(0, 0, 0)
        end
    end

    local function flingDiedF()
        if flingDied then
            flingDied:Disconnect()
        end
        wait(0.1)
        local speakerChar = Players.LocalPlayer.Character
        if not speakerChar or not Players.LocalPlayer.Character.HumanoidRootPart then return end
        for _, v in pairs(Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
            if v.ClassName == 'BodyAngularVelocity' then
                v:Destroy()
            end
        end
        for _, child in pairs(speakerChar:GetDescendants()) do
            if child.ClassName == "Part" or child.ClassName == "MeshPart" then
                child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
            end
        end
        ResetCharacter()
    end

    flingDied = Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Died:Connect(flingDiedF)
    local targetHumanoid = targetPlayer.Character:WaitForChild("Humanoid")

    while targetPlayer and targetPlayer.Character and targetHumanoid.Health > 0 do
        if targetPlayer and targetPlayer.Character then
            humanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 1, 0)
            bambam.AngularVelocity = Vector3.new(0, 99999, 0)
            wait(0.2)
            bambam.AngularVelocity = Vector3.new(0, 0, 0)
            wait(0.1)
        end
    end

    ResetCharacter()
end

local targetPlayer = Players:GetPlayers()[1]
endRound(targetPlayer)
