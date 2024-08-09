-- Ensure you're working with the Players service
local Players = game:GetService("Players")

-- Reference the local player
local player = Players.LocalPlayer

-- Find the target GUI element
local targetGui = player.PlayerGui:FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target")

-- Function to handle changes in visibility
local function onVisibilityChanged()
    if targetGui.Visible then
        print("Target is now visible.")
    end
end

-- Connect the function to the 'Changed' event
targetGui:GetPropertyChangedSignal("Visible"):Connect(onVisibilityChanged)
