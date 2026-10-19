-- TP ADMIN PANEL - Luau UI Prototype
-- For use in Roblox Studio / experiences you own or are authorized to test.
-- This is a UI demo: it does NOT grant admin powers in other people's games.
-- Server actions (freeze/kick/ban) must be implemented and permission-checked
-- on the server in an experience you control.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("TPAdminPanel")
if old then old:Destroy() end

local BLUE = Color3.fromRGB(45, 125, 255)
local BG = Color3.fromRGB(15, 19, 29)
local PANEL = Color3.fromRGB(24, 30, 44)
local FIELD = Color3.fromRGB(33, 41, 59)
local WHITE = Color3.fromRGB(240, 244, 255)
local MUTED = Color3.fromRGB(156, 170, 195)

local gui = Instance.new("ScreenGui")
gui.Name = "TPAdminPanel"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 360, 0, 520)
main.Position = UDim2.new(0.5, -180, 0.5, -260)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = BLUE
stroke.Thickness = 1.5
stroke.Transparency = 0.15
stroke.Parent = main

local function makeLabel(parent, text, size, pos, color, font, textSize)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.Size = size
    label.Position = pos
    label.TextColor3 = color or WHITE
    label.Font = font or Enum.Font.Gotham
    label.TextSize = textSize or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundColor3 = PANEL
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

makeLabel(header, "TP ADMIN", UDim2.new(1, -65, 0, 25), UDim2.new(0, 16, 0, 8),
    WHITE, Enum.Font.GothamBold, 20)
makeLabel(header, "COMMAND CENTER  •  UI DEMO", UDim2.new(1, -65, 0, 16),
    UDim2.new(0, 17, 0, 33), MUTED, Enum.Font.GothamMedium, 9)

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 32, 0, 32)
close.Position = UDim2.new(1, -44, 0, 13)
close.BackgroundColor3 = Color3.fromRGB(80, 38, 48)
close.Text = "×"
close.TextColor3 = WHITE
close.TextSize = 23
close.Font = Enum.Font.GothamBold
close.BorderSizePixel = 0
close.Parent = header
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Drag the panel by its header.
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local search = Instance.new("TextBox")
search.Name = "PlayerSearch"
search.PlaceholderText = "Search players..."
search.Text = ""
search.ClearTextOnFocus = false
search.Size = UDim2.new(1, -28, 0, 34)
search.Position = UDim2.new(0, 14, 0, 70)
search.BackgroundColor3 = FIELD
search.TextColor3 = WHITE
search.PlaceholderColor3 = MUTED
search.Font = Enum.Font.Gotham
search.TextSize = 13
search.BorderSizePixel = 0
search.Parent = main
Instance.new("UICorner", search).CornerRadius = UDim.new(0, 8)

local playerList = Instance.new("ScrollingFrame")
playerList.Name = "PlayerList"
playerList.Size = UDim2.new(1, -28, 0, 112)
playerList.Position = UDim2.new(0, 14, 0, 112)
playerList.BackgroundColor3 = PANEL
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 4
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.Parent = main
Instance.new("UICorner", playerList).CornerRadius = UDim.new(0, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = playerList

local selectedPlayer = nil
local function refreshPlayers()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local count = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(player.Name), string.lower(search.Text), 1, true)
            or string.find(string.lower(player.DisplayName), string.lower(search.Text), 1, true) then
            count += 1
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -8, 0, 29)
            button.Position = UDim2.new(0, 4, 0, 0)
            button.BackgroundColor3 = (selectedPlayer == player) and BLUE or FIELD
            button.Text = player.DisplayName .. "  (@" .. player.Name .. ")"
            button.TextColor3 = WHITE
            button.Font = Enum.Font.Gotham
            button.TextSize = 12
            button.BorderSizePixel = 0
            button.Parent = playerList
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            button.MouseButton1Click:Connect(function()
                selectedPlayer = player
                refreshPlayers()
            end)
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, count * 33 + 4)
end

search:GetPropertyChangedSignal("Text"):Connect(refreshPlayers)
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(function(player)
    if selectedPlayer == player then selectedPlayer = nil end
    refreshPlayers()
end)

makeLabel(main, "QUICK COMMANDS", UDim2.new(1, -28, 0, 18),
    UDim2.new(0, 14, 0, 235), MUTED, Enum.Font.GothamBold, 11)

local status = makeLabel(main, "Ready — UI demo only; no action executed.",
    UDim2.new(1, -28, 0, 42), UDim2.new(0, 14, 1, -55),
    Color3.fromRGB(137, 226, 163), Enum.Font.Gotham, 11)
status.TextWrapped = true
status.TextYAlignment = Enum.TextYAlignment.Top

local function button(text, x, y, callback, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.5, -18, 0, 35)
    b.Position = UDim2.new(x, x == 0 and 14 or 4, 0, y)
    b.BackgroundColor3 = color or FIELD
    b.Text = text
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    b.BorderSizePixel = 0
    b.Parent = main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function preview(action)
    if not selectedPlayer then
        status.TextColor3 = Color3.fromRGB(255, 190, 110)
        status.Text = "Select a player first. Demo only; no action executed."
        return
    end
    status.TextColor3 = Color3.fromRGB(137, 226, 163)
    status.Text = "Preview: " .. action .. " → " .. selectedPlayer.Name
        .. "\nNo game action executed. Connect to an authorized server system."
end

button("❄  Freeze", 0, 260, function() preview("Freeze") end)
button("♨  Unfreeze", 1, 260, function() preview("Unfreeze") end)
button("➤  Goto", 0, 302, function() preview("Goto") end)
button("⛔  Kick", 1, 302, function() preview("Kick") end)
button("🛡  Ban", 0, 344, function() preview("Ban") end,
    Color3.fromRGB(78, 39, 49))
button("🔓  Unban", 1, 344, function() preview("Unban") end,
    Color3.fromRGB(43, 79, 67))
button("↻  Refresh", 0, 386, function()
    refreshPlayers()
    status.Text = "Player list refreshed."
end)

local commandBox = Instance.new("TextBox")
commandBox.Name = "CommandInput"
commandBox.PlaceholderText = ";goto PlayerName"
commandBox.Text = ""
commandBox.ClearTextOnFocus = false
commandBox.Size = UDim2.new(1, -104, 0, 34)
commandBox.Position = UDim2.new(0, 14, 0, 428)
commandBox.BackgroundColor3 = FIELD
commandBox.TextColor3 = WHITE
commandBox.PlaceholderColor3 = MUTED
commandBox.Font = Enum.Font.Code
commandBox.TextSize = 12
commandBox.BorderSizePixel = 0
commandBox.Parent = main
Instance.new("UICorner", commandBox).CornerRadius = UDim.new(0, 8)

local runButton = Instance.new("TextButton")
runButton.Size = UDim2.new(0, 76, 0, 34)
runButton.Position = UDim2.new(1, -90, 0, 428)
runButton.BackgroundColor3 = BLUE
runButton.Text = "Preview"
runButton.TextColor3 = WHITE
runButton.Font = Enum.Font.GothamBold
runButton.TextSize = 11
runButton.BorderSizePixel = 0
runButton.Parent = main
Instance.new("UICorner", runButton).CornerRadius = UDim.new(0, 8)

local function previewInput()
    local raw = commandBox.Text
    if raw == "" then
        status.Text = "Type a command to preview."
        return
    end
    status.TextColor3 = Color3.fromRGB(137, 226, 163)
    status.Text = "Command preview: " .. raw .. "\nNot sent to any game server."
end
runButton.MouseButton1Click:Connect(previewInput)
commandBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then previewInput() end
end)

makeLabel(main, "Use only in experiences you own or are authorized to test.",
    UDim2.new(1, -28, 0, 16), UDim2.new(0, 14, 0, 470),
    MUTED, Enum.Font.Gotham, 9)

refreshPlayers()
