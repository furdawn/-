local Players = game:GetService("Players")

local function ResetCharacter()
    Players.LocalPlayer.Character:WaitForChild("Humanoid", 30):ChangeState(15)
end

local function noclip()
    if Clip == false and Players.LocalPlayer.Character ~= nil then
        for _, child in pairs(Players.LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
                child.CanCollide = false
            end
        end
    end
end

local function unfling()
	if flingDied then
		flingDied:Disconnect()
	end
	flinging = false
	wait(.1)
	local speakerChar = Players.LocalPlayer.Character
	if not speakerChar or not getRoot(speakerChar) then return end
	for i,v in pairs(getRoot(speakerChar):GetChildren()) do
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

local function endRound()
    flinging = false
	for _, child in pairs(Players.LocalPlayer.Character:GetDescendants()) do
		if child:IsA("BasePart") then
			child.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
		end
	end
	noclip()
	wait(.1)
	local bambam = Instance.new("BodyAngularVelocity")
	bambam.Name = "FFFWWEWSSDZZZ"
	bambam.Parent = Players.LocalPlayer.Character.HumanoidRootPart
	bambam.AngularVelocity = Vector3.new(0,99999,0)
	bambam.MaxTorque = Vector3.new(0,math.huge,0)
	bambam.P = math.huge
	local Char = Players.LocalPlayer.Character:GetChildren()
	for i, v in next, Char do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.Massless = true
			v.Velocity = Vector3.new(0, 0, 0)
		end
	end
	flinging = true
	local function flingDiedF()
		unfling()
	end
	flingDied = Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Died:Connect(flingDiedF)
	repeat
		bambam.AngularVelocity = Vector3.new(0,99999,0)
		wait(.2)
		bambam.AngularVelocity = Vector3.new(0,0,0)
		wait(.1)
	until flinging == false
end

endRound()
