local Players = game:GetService("Players")

local function ResetCharacter()
    Players.LocalPlayer.Character:WaitForChild("Humanoid", 30):ChangeState(15)
end

local function endRound(targetPlayer)
    print("Flinging murderer >;3")

    local humanoidRootPart = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local flingDied = nil

    for _, child in pairs(Players.LocalPlayer.Character:GetDescendants()) do
        if child:IsA("BasePart") then
            child.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
        end
    end

    local bambam = Instance.new("BodyAngularVelocity")
    bambam.Name = "Floppa"
    bambam.Parent = Players.LocalPlayer.Character.HumanoidRootPart
    bambam.AngularVelocity = Vector3.new(0,99999,0)
    bambam.MaxTorque = Vector3.new(0,math.huge,0)
    bambam.P = math.huge

    local Char = Players.LocalPlayer.Character:GetDescendants()
    for _, v in next, Char do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Massless = true
            v.Velocity = Vector3.new(0, 0, 0)
            print("Changed")
        end
    end

    workspace.Gravity = 196.2

    local function flingDiedF()
        if flingDied then
            flingDied:Disconnect()
        end
        wait(.1)
        if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character.HumanoidRootPart then return end
        for _, v in pairs(Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
            if v.ClassName == 'BodyAngularVelocity' then
                v:Destroy()
            end
        end
        for _, child in pairs(Players.LocalPlayer.Character:GetDescendants()) do
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
            bambam.AngularVelocity = Vector3.new(0,99999,0)
            wait(.2)
            bambam.AngularVelocity = Vector3.new(0,0,0)
            wait(.1)
        end
    end
    ResetCharacter()
end

local targetPlayer = Players:FindFirstChild("Lexi44132")
endRound(targetPlayer)
