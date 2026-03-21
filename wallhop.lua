--[[
    Auto Wall Hop (Original Fixed)
    - Mantém wallhop original
    - Remove quebra de double jump
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

-- UI
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoWallHopGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0, 140, 0, 50)
TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.Text = "Wall Hop Off"
TextButton.TextColor3 = Color3.fromRGB(255,255,255)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextScaled = true
TextButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = TextButton

RunService.RenderStepped:Connect(function()
    local inset = GuiService:GetGuiInset()
    TextButton.Position = UDim2.new(0, 150, 0, inset.Y - 58)
end)

-- LOGIC
local isWallHopEnabled = false
local isFlicking = false
local lastFlickTime = 0
local Camera = workspace.CurrentCamera

local function performVideoFlick()
    if isFlicking then return end
    isFlicking = true
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        isFlicking = false
        return
    end

    -- 🔥 BOOST ORIGINAL (mantido)
    hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)

    -- 🎯 flick
    local startCFrame = Camera.CFrame
    local targetCFrame = startCFrame * CFrame.Angles(0, math.rad(45), 0)

    local fastFlick = math.random() < 0.4

    Camera.CFrame = targetCFrame

    if fastFlick then
        task.wait(0.012 + math.random() * 0.003)
    else
        task.wait(0.018 + math.random() * 0.004)
    end

    local steps = fastFlick and 4 or 6

    for i = 1, steps do
        local curve = fastFlick and 1.8 or (2 + math.random() * 0.3)
        local alpha = (i / steps) ^ curve
        Camera.CFrame = targetCFrame:Lerp(startCFrame, alpha)

        if fastFlick then
            task.wait(0.004 + math.random() * 0.001)
        else
            task.wait(0.006 + math.random() * 0.002)
        end
    end

    isFlicking = false
end

-- wall detect
local lastHitInstance = nil

RunService.Heartbeat:Connect(function()
    if not isWallHopEnabled then return end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {char}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local result = workspace:Raycast(
        hrp.Position,
        Camera.CFrame.LookVector * 3,
        raycastParams
    )

    if result and result.Instance and result.Instance.CanCollide then
        if lastHitInstance and lastHitInstance ~= result.Instance then
            if hrp.Velocity.Y < 0 and tick() - lastFlickTime > 0.065 then
                lastFlickTime = tick()
                performVideoFlick()
            end
        end
        lastHitInstance = result.Instance
    else
        lastHitInstance = nil
    end
end)

-- botão
TextButton.MouseButton1Click:Connect(function()
    isWallHopEnabled = not isWallHopEnabled
    TextButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
    TextButton.BackgroundColor3 = isWallHopEnabled and Color3.fromRGB(40,40,40) or Color3.fromRGB(0,0,0)
end)

print("WallHop Original Fixed Loaded")
