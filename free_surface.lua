-------------------------------------------------------------------------------
-- 👇 YOUR MAIN SCRIPT CODE STARTS HERE 👇
-------------------------------------------------------------------------------

print(ProtectionConfig.HubName .. " Loaded Successfully!")
Here's the complete Delta Ultimate v5.1 script with Noclip added:

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera or workspace:WaitForChild("Camera")
local LocalPlayer = Players.LocalPlayer

-- Settings
local settings = {
    flySpeed = 50,
    espEnabled = true,
    espColor = Color3.fromRGB(255, 0, 0),
    walkSpeed = 16,
    jumpPower = 50,
    fullbrightEnabled = false,
    antiAFKEnabled = true,
    noclipEnabled = false
}

-- State
local flying = false
local espObjects = {}

-- ============================================
-- FUNCTION DEFINITIONS
-- ============================================

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUltimateGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Delta Ultimate v5.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Create tabs
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabBar.Parent = MainFrame

local tabButtons = {}
local tabNames = {"Main", "Movement", "Visual", "Utility", "Teleport", "Info"}
local frames = {}

-- Create frames first
for _, name in ipairs(tabNames) do
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, -65)
    frame.Position = UDim2.new(0, 0, 0, 65)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 5
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.Visible = (name == "Main")
    frame.Parent = MainFrame
    frames[name] = frame
end

-- Create tab buttons
for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.1667, 0, 1, 0)
    btn.Position = UDim2.new((i - 1) * 0.1667, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12
    btn.Parent = TabBar
    tabButtons[name] = btn
end

-- Tab switching
local function switchTab(tabName)
    for name, frame in pairs(frames) do
        frame.Visible = (name == tabName)
    end
    for name, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (name == tabName) and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- Helper functions
local function createButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 35)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = parent
    button.MouseButton1Click:Connect(callback)
    return button
end

local function createToggle(parent, text, initial, callback)
    local value = initial
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 35)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Text = text .. ": " .. (value and "ON" or "OFF")
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = parent
    button.MouseButton1Click:Connect(function()
        value = not value
        button.Text = text .. ": " .. (value and "ON" or "OFF")
        callback(value)
    end)
    return button
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 50)
    frame.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 55)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.Parent = frame

    local value = default
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, -20, 0, 20)
    sliderBtn.Position = UDim2.new(0, 10, 0, 25)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBtn.Text = "← " .. value .. " →"
    sliderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Font = Enum.Font.SourceSans
    sliderBtn.TextSize = 12
    sliderBtn.Parent = frame

    sliderBtn.MouseButton1Click:Connect(function()
        value = value + 1
        if value > max then value = min end
        sliderBtn.Text = "← " .. value .. " →"
        label.Text = text .. ": " .. value
        callback(value)
    end)

    sliderBtn.MouseButton2Click:Connect(function()
        value = value - 1
        if value < min then value = max end
        sliderBtn.Text = "← " .. value .. " →"
        label.Text = text .. ": " .. value
        callback(value)
    end)
end

-- FIXED SCRIPT LOADER (No game:HttpGet - uses HttpService instead)
local function loadScriptFromUrl(url)
    if not url or url == "" then
        warn("Please enter a valid URL")
        return
    end

    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Size = UDim2.new(0, 200, 0, 30)
    loadingLabel.Position = UDim2.new(0.5, -100, 0.7, 0)
    loadingLabel.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    loadingLabel.Text = "Loading script..."
    loadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingLabel.Font = Enum.Font.SourceSansBold
    loadingLabel.TextSize = 14
    loadingLabel.Parent = ScreenGui

    local success, result = pcall(function()
        local content = HttpService:GetAsync(url)
        if not content or content == "" then
            error("Failed to fetch URL - empty response")
        end

        local func = loadstring(content)
        if not func then
            error("Failed to compile script - invalid Lua code")
        end

        func()
    end)

    task.delay(2, function()
        loadingLabel:Destroy()
    end)

    if success then
        local successLabel = Instance.new("TextLabel")
        successLabel.Size = UDim2.new(0, 200, 0, 30)
        successLabel.Position = UDim2.new(0.5, -100, 0.7, 0)
        successLabel.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        successLabel.Text = "Script loaded successfully!"
        successLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        successLabel.Font = Enum.Font.SourceSansBold
        successLabel.TextSize = 14
        successLabel.Parent = ScreenGui

        task.delay(2, function()
            successLabel:Destroy()
        end)
    else
        warn("Script load error: " .. tostring(result))

        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(0, 200, 0, 30)
        errorLabel.Position = UDim2.new(0.5, -100, 0.7, 0)
        errorLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        errorLabel.Text = "Error: " .. tostring(result)
        errorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        errorLabel.Font = Enum.Font.SourceSansBold
        errorLabel.TextSize = 12
        errorLabel.Parent = ScreenGui

        task.delay(3, function()
            errorLabel:Destroy()
        end)
    end
end

local function createTextBox(parent, placeholder, executeText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 60)
    frame.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 65)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Parent = parent

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.95, 0, 0, 25)
    textBox.Position = UDim2.new(0.025, 0, 0.05, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = 14
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.ClearTextOnFocus = true
    textBox.Parent = frame

    local executeBtn = Instance.new("TextButton")
    executeBtn.Size = UDim2.new(0.95, 0, 0, 25)
    executeBtn.Position = UDim2.new(0.025, 0, 0.55, 0)
    executeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    executeBtn.Text = executeText
    executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeBtn.Font = Enum.Font.SourceSansBold
    executeBtn.TextSize = 14
    executeBtn.Parent = frame

    executeBtn.MouseButton1Click:Connect(function()
        local url = textBox.Text or ""
        url = url:gsub("%s+", "")
        if url ~= "" then
            loadScriptFromUrl(url)
        else
            warn("Please enter a script URL")
        end
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local url = textBox.Text or ""
            url = url:gsub("%s+", "")
            if url ~= "" then
                loadScriptFromUrl(url)
            end
        end
    end)

    return {textBox = textBox, executeBtn = executeBtn}
end

-- FLY SYSTEM
local function startFly()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    humanoid:ChangeState(Enum.HumanoidStateType.Flying)

    local bv = Instance.new("BodyVelocity")
    bv.Name = "DeltaFlyBV"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 10000
    bv.Velocity = Vector3.new()
    bv.Parent = rootPart

    local bg = Instance.new("BodyGyro")
    bg.Name = "DeltaFlyBG"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 10000
    bg.D = 100
    bg.CFrame = rootPart.CFrame
    bg.Parent = rootPart
end

local function stopFly()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end

        if rootPart then
            local bv = rootPart:FindFirstChild("DeltaFlyBV")
            local bg = rootPart:FindFirstChild("DeltaFlyBG")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
end

local flyConnection = nil
local function enableFly()
    startFly()

    if flyConnection then flyConnection:Disconnect() end

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end

        local character = LocalPlayer.Character
        if not character then return end

        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        local bv = rootPart:FindFirstChild("DeltaFlyBV")
        local bg = rootPart:FindFirstChild("DeltaFlyBG")

        if not bv or not bg then
            startFly()
            return
        end

        local cf = Camera.CFrame
        local moveDirection = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cf.RightVector end

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

        if moveDirection.Magnitude > 0 then  
            moveDirection = moveDirection.Unit * settings.flySpeed  
        end

        bv.Velocity = moveDirection  
        bg.CFrame = cf  
    end)  
end

local function disableFly()  
    flying = false  
    if flyConnection then  
        flyConnection:Disconnect()  
        flyConnection = nil  
    end  
    stopFly()  
end

-- NOCLIP SYSTEM  
local noclipConnection = nil

local function enableNoclip()  
    if noclipConnection then noclipConnection:Disconnect() end
    
    noclipConnection = RunService.Stepped:Connect(function()  
        if not settings.noclipEnabled then return end
        
        local character = LocalPlayer.Character  
        if not character then return end
        
        for _, part in ipairs(character:GetDescendants()) do  
            if part:IsA("BasePart") and part.CanCollide then  
                part.CanCollide = false  
            end  
        end  
    end)  
end

local function disableNoclip()  
    if noclipConnection then  
        noclipConnection:Disconnect()  
        noclipConnection = nil  
    end
    
    -- Restore collision on all parts  
    local character = LocalPlayer.Character  
    if character then  
        for _, part in ipairs(character:GetDescendants()) do  
            if part:IsA("BasePart") then  
                part.CanCollide = true  
            end  
        end  
    end  
end

-- ESP functions  
local function createESP(player)  
    if player == LocalPlayer then return end  
    if espObjects[player] then return end

    local function setupESP(char)  
        local head = char:FindFirstChild("Head")  
        if not head then return end

        local esp = Instance.new("BillboardGui")  
        esp.Name = "ESP_" .. player.Name  
        esp.Size = UDim2.new(0, 200, 0, 50)  
        esp.AlwaysOnTop = true  
        esp.Adornee = head  
        esp.Parent = char

        local textLabel = Instance.new("TextLabel")  
        textLabel.Size = UDim2.new(1, 0, 1, 0)  
        textLabel.BackgroundTransparency = 1  
        textLabel.Text = player.Name  
        textLabel.TextColor3 = settings.espColor  
        textLabel.TextStrokeTransparency = 0  
        textLabel.Font = Enum.Font.SourceSansBold  
        textLabel.TextSize = 16  
        textLabel.Parent = esp

        espObjects[player] = esp  
    end

    if player.Character then  
        setupESP(player.Character)  
    end

    player.CharacterAdded:Connect(function(char)  
        task.wait(0.5)  
        if espObjects[player] then  
            espObjects[player]:Destroy()  
            espObjects[player] = nil  
        end  
        setupESP(char)  
    end)  
end

local function updateESP()  
    for player, esp in pairs(espObjects) do  
        if not player.Parent or not player.Character or not player.Character:FindFirstChild("Head") then  
            esp:Destroy()  
            espObjects[player] = nil  
        else  
            esp.Adornee = player.Character.Head  
            local distance = math.huge  
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then  
                distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.Head.Position).Magnitude  
            end  
            local textLabel = esp:FindFirstChild("TextLabel")  
            if textLabel then  
                textLabel.Text = player.Name .. " [" .. math.floor(distance) .. "m]"  
            end  
        end  
    end  
end

local function removeAllESP()  
    for player, esp in pairs(espObjects) do  
        esp:Destroy()  
        espObjects[player] = nil  
    end  
end

-- TELEPORT SYSTEM  
local function teleportToPlayer(targetPlayer)  
    if not targetPlayer then return end

    local character = LocalPlayer.Character  
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")  
    if not rootPart then return end

    local targetChar = targetPlayer.Character  
    if not targetChar then return end

    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")  
    if not targetRoot then return end

    rootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 3, 0)

    local notification = Instance.new("TextLabel")  
    notification.Size = UDim2.new(0, 200, 0, 30)  
    notification.Position = UDim2.new(0.5, -100, 0.8, 0)  
    notification.BackgroundColor3 = Color3.fromRGB(0, 150, 0)  
    notification.Text = "Teleported to " .. targetPlayer.Name  
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)  
    notification.Font = Enum.Font.SourceSansBold  
    notification.TextSize = 14  
    notification.Parent = ScreenGui

    task.delay(2, function()  
        notification:Destroy()  
    end)  
end

-- Player list for teleport tab  
local function refreshPlayerList()  
    for _, child in ipairs(frames["Teleport"]:GetChildren()) do  
        if child:IsA("TextButton") then  
            child:Destroy()  
        end  
    end

    local yPos = 0  
    for _, player in ipairs(Players:GetPlayers()) do  
        if player ~= LocalPlayer then  
            local button = Instance.new("TextButton")  
            button.Size = UDim2.new(0.9, 0, 0, 35)  
            button.Position = UDim2.new(0.05, 0, 0, yPos)  
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  
            button.Text = player.Name .. " (Click to TP)"  
            button.TextColor3 = Color3.fromRGB(255, 255, 255)  
            button.Font = Enum.Font.SourceSans  
            button.TextSize = 14  
            button.Parent = frames["Teleport"]

            button:SetAttribute("TargetPlayer", player.Name)

            button.MouseButton1Click:Connect(function()  
                local targetName = button:GetAttribute("TargetPlayer")  
                local target = Players:FindFirstChild(targetName)  
                if target then  
                    teleportToPlayer(target)  
                end  
            end)

            yPos = yPos + 40  
        end  
    end

    frames["Teleport"].CanvasSize = UDim2.new(0, 0, 0, yPos + 10)  
end

-- Player added/removed connections  
Players.PlayerAdded:Connect(function(player)  
    if settings.espEnabled then  
        createESP(player)  
    end  
    refreshPlayerList()  
end)

Players.PlayerRemoving:Connect(function(player)  
    if espObjects[player] then  
        espObjects[player]:Destroy()  
        espObjects[player] = nil  
    end  
    refreshPlayerList()  
end)

-- Main loop  
RunService.RenderStepped:Connect(function()  
    if settings.espEnabled then  
        updateESP()  
    end  
end)

-- ============================================  
-- UI ELEMENTS CREATION  
-- ============================================

-- MAIN TAB  
createToggle(frames["Main"], "ESP", settings.espEnabled, function(value)  
    settings.espEnabled = value  
    if value then  
        for _, player in ipairs(Players:GetPlayers()) do  
            createESP(player)  
        end  
    else  
        removeAllESP()  
    end  
end)

createButton(frames["Main"], "Refresh ESP", function()  
    removeAllESP()  
    for _, player in ipairs(Players:GetPlayers()) do  
        createESP(player)  
    end  
end)

-- MOVEMENT TAB  
createToggle(frames["Movement"], "Fly", false, function(value)  
    if value then  
        flying = true  
        enableFly()  
    else  
        flying = false  
        disableFly()  
    end  
end)

createSlider(frames["Movement"], "Fly Speed", 10, 200, settings.flySpeed, function(value)  
    settings.flySpeed = value  
end)

-- NOCLIP TOGGLE (NEW)
createToggle(frames["Movement"], "Noclip", settings.noclipEnabled, function(value)  
    settings.noclipEnabled = value  
    if value then  
        enableNoclip()  
    else  
        disableNoclip()  
    end  
end)

createButton(frames["Movement"], "Speed Boost", function()  
    local character = LocalPlayer.Character  
    if character then  
        local humanoid = character:FindFirstChildOfClass("Humanoid")  
        if humanoid then  
            humanoid.WalkSpeed = settings.walkSpeed + 50  
            task.wait(5)  
            humanoid.WalkSpeed = settings.walkSpeed  
        end  
    end  
end)

-- VISUAL TAB  
createToggle(frames["Visual"], "Fullbright", settings.fullbrightEnabled, function(value)  
    settings.fullbrightEnabled = value  
    if value then  
        Lighting.Brightness = 2  
        Lighting.ClockTime = 12  
        Lighting.FogEnd = 100000  
        Lighting.FogStart = 0  
    else  
        Lighting.Brightness = 1  
        Lighting.ClockTime = 14  
        Lighting.FogEnd = 500  
        Lighting.FogStart = 0  
    end  
end)

-- UTILITY TAB  
createToggle(frames["Utility"], "Anti-AFK", settings.antiAFKEnabled, function(value)  
    settings.antiAFKEnabled = value  
    if value then  
        VirtualUser:CaptureController()  
        VirtualUser:Button1Down(Vector2.new(0, 0))  
    end  
end)

createButton(frames["Utility"], "Teleport to Nearest", function()  
    local nearest = nil  
    local nearestDist = math.huge  
    for _, player in ipairs(Players:GetPlayers()) do  
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude  
            if dist < nearestDist then  
                nearestDist = dist  
                nearest = player  
            end  
        end  
    end  
    if nearest then  
        teleportToPlayer(nearest)  
    end  
end)

-- Script loader  
createTextBox(frames["Utility"], "Enter script URL (e.g. https://pastebin.com/raw/...)", "Load Script")

-- TELEPORT TAB  
createButton(frames["Teleport"], "Refresh Player List", function()  
    refreshPlayerList()  
end)

-- Initial player list  
refreshPlayerList()

-- INFO TAB  
local function createInfoLabel(parent, text)  
    local label = Instance.new("TextLabel")  
    label.Size = UDim2.new(0.9, 0, 0, 25)  
    label.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 30)  
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)  
    label.Text = text  
    label.TextColor3 = Color3.fromRGB(255, 255, 255)  
    label.Font = Enum.Font.SourceSans  
    label.TextSize = 14  
    label.Parent = parent  
    return label  
end

-- Get user info  
local userId = LocalPlayer.UserId  
local userName = LocalPlayer.Name  
local displayName = LocalPlayer.DisplayName  
local accountAge = LocalPlayer.AccountAge  
local dateCreated = os.date("%Y-%m-%d", os.time() - (accountAge * 86400))

createInfoLabel(frames["Info"], "Script: Delta Ultimate v5.1")  
createInfoLabel(frames["Info"], "Version: 5.1")  
createInfoLabel(frames["Info"], "Username: " .. userName)  
createInfoLabel(frames["Info"], "Display Name: " .. displayName)  
createInfoLabel(frames["Info"], "User ID: " .. userId)  
createInfoLabel(frames["Info"], "Account Age: " .. accountAge .. " days")  
createInfoLabel(frames["Info"], "Account Created: " .. dateCreated)  
createInfoLabel(frames["Info"], "Game: " .. game.Name)  
createInfoLabel(frames["Info"], "Place ID: " .. game.PlaceId)  
createInfoLabel(frames["Info"], "Game ID: " .. game.GameId)  
createInfoLabel(frames["Info"], "Job ID: " .. game.JobId)  
createInfoLabel(frames["Info"], "Creator: Glitchederror0724")  
createInfoLabel(frames["Info"], "Created: 2024")  
createInfoLabel(frames["Info"], "Status: Loaded Successfully")

print("Delta Ultimate v5.1 loaded successfully!")  
print("Welcome, " .. userName .. "!")
