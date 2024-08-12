repeat task.wait() until game:IsLoaded()
getgenv().Mainfarm = nil
getgenv().Altfarm = nil

local myAccounts = {"cuffedpaws", "DMADusk", "tr4nsfem"}

local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = game.Workspace.Terrain

Players.LocalPlayer.PlayerGui.MobileShiftLock:Destroy()
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
for _, v in pairs(game:GetDescendants()) do
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

local function ServerHop()
    local Player = game.Players.LocalPlayer    
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"

    local _place,_id = game.PlaceId, game.JobId
    local _servers = Api.._place.."/servers/Public?sortOrder=Desc&limit=100"

    local function ListServers(cursor)
        local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
        return Http:JSONDecode(Raw)
    end

    local Next; repeat
        local Servers = ListServers(Next)
        for _,v in pairs(Servers.data) do
            if v.playing >= 4 and v.playing < v.maxPlayers and v.id ~= _id then
                local success, err = pcall(TPS.TeleportToPlaceInstance, TPS, _place, v.id, Player)
                if success then
                    break
                end
            end
        end

        Next = Servers.nextPageCursor
    until not Next
end

local function PlayerCount()
    local playerCount = #Players:GetPlayers()
    local myAccountPresent = false

    for _, player in pairs(Players:GetPlayers()) do
        if table.find(myAccounts, player.Name) then
            myAccountPresent = true
            break
        end
    end

    if playerCount <= 3 and not myAccountPresent then
        ServerHop()
    end
end

local function BreakVelo()
    workspace.Gravity = 215
    for _, v in ipairs(Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Velocity, v.RotVelocity = Vector3.zero, Vector3.zero
        end
    end
    Players.LocalPlayer.Character.Animate.Disabled = true
    workspace.Gravity = 0
end

local function DestroyMap()
    for _, v in pairs(Players:GetPlayers()) do
        if game.Workspace[v.Name] then
            for _, child in ipairs(game.Workspace[v.Name]:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CanCollide = false
                end
            end
        end
    end
    for _, v in pairs(game.Workspace.GameMap:GetDescendants()) do
        if v and v:IsA("BasePart") then
            v:Destroy()
        end
    end
end

local function SetupAtlas()
    for _, v in pairs(Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("BasePart") and
            v.Name == "Right Leg" or
            v.Name == "Left Leg" then
            v:Destroy()
        end
    end
end

local function Kill(targetPlayer)
    if targetPlayer and targetPlayer:IsA("Model") and targetPlayer:FindFirstChild("HumanoidRootPart") then
        local localRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetPlayer:FindFirstChild("HumanoidRootPart")

        if localRoot and targetRoot then
            local offset = targetRoot.CFrame:vectorToWorldSpace(Vector3.new(-1.25, -2.25, 0.5))
            local targetCFrame = targetRoot.CFrame + offset
            targetCFrame = targetCFrame * CFrame.Angles(0, 0, math.pi * 0.5)
            local tween = TweenService:Create(localRoot, TweenInfo.new((Players.LocalPlayer.Character.HumanoidRootPart - targetCFrame.Position).Magnitude / 5, Enum.EasingStyle.Linear), { CFrame = targetCFrame })
            tween:Play()
            tween.Completed:Wait()
        end
    end
end

local function Start()
    targetText = nil
    BreakVelo()
    DestroyMap()
    SetupAtlas()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        task.wait()
    end

    local targetText = mainGUI.TargetText.Text
    local targetPlayer = game.Workspace:FindFirstChild(targetText)

    getgenv().Mainfarm = true

    while mainGUI.Visible and getgenv().Mainfarm == true do
        local currentTarget = mainGUI.TargetText.Text
        if currentTarget ~= targetText then
            targetPlayer = game.Workspace:FindFirstChild(currentTarget)
            targetText = currentTarget

            if not targetPlayer then
                break
            end
        end

        if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
            knifePlayer = targetText
            Kill(targetPlayer)
            task.wait(0.1)
        else
            break
        end
        task.wait()
    end
    getgenv().Mainfarm = false
    workspace.Gravity = 215
end

local function AltStart()
    targetText = nil
    BreakVelo()
    DestroyMap()
    SetupAtlas()

    while #Players.LocalPlayer.Backpack:GetChildren() == 0 do
        task.wait()
    end

    getgenv().Altfarm = true

    while altGUI.Text == "Free For All" or altGUI.Text == "Infection" and getgenv().Altfarm do
        for _, v in pairs(Players:GetPlayers()) do
            local startTime = tick()
            while tick() - startTime < 3 do
                if game.Workspace[v.Name] and game.Workspace[v.Name]:FindFirstChild("HumanoidRootPart") then
                    knifePlayer = v.Name
                    local targetPlayer = game.Workspace[v.Name]
                    Kill(targetPlayer)
                    task.wait(0.1)
                end
            end
        end
        task.wait()
    end
    getgenv().Altfarm = false
    workspace.Gravity = 215
end

mainGUI:GetPropertyChangedSignal("Visible"):Connect(function()
    if mainGUI.Visible then
        Start()
    end
end)

altGUI:GetPropertyChangedSignal("Text"):Connect(function()
    if altGUI.Text == "Free For All" or "Infection" then
        AltStart()
    end
end)

local cooldown = false
task.spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if knifePlayer and game.Workspace:FindFirstChild(knifePlayer) and game.Workspace[knifePlayer]:FindFirstChild("HumanoidRootPart") then
            if not cooldown and Players.LocalPlayer.Character and getgenv().MainFarm == true or getgenv().Altfarm == true then
                if Players.LocalPlayer:DistanceFromCharacter(game.Workspace[knifePlayer].Head.Position) <= 8 then
                    Players.LocalPlayer.PlayerScripts.localknifehandler.HitCheck:Fire(game.Workspace[knifePlayer])
                    coroutine.wrap(function()
                        cooldown = true
                        task.wait(0.25)
                        cooldown = false
                    end)()
                else
                    task.wait()
                end
            end
        end
    end)
end)

coroutine.wrap(function()
    while true do
        PlayerCount()
        task.wait(3600)
    end
end)()

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
