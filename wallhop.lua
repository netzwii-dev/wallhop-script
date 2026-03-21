--[[
    Auto Wall Hop (Balanced Version)
    - Mantém double jump
    - Wallhop funcional
    - Sem interferência agressiva
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

local function performFlick()
    if isFlicking then return end
    isFlicking = true

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        isFlicking = false
        return
    end

    local vel = hrp.Velocity
    local look = Camera.CFrame.LookVector

    -- 🔥 impulso equilibrado
    hrp.Velocity = Vector3.new(
        vel.X + (look.X * 20),     -- lateral
        vel.Y + 18,                -- 🔑 boost vertical leve (incremental!)
        vel.Z + (look.Z * 20)
    )

    -- 🎯 flick
    local startCFrame = Camera.CFrame
    local targetCFrame = startCFrame * CFrame.Angles(0, math.rad(45), 0)

    local fastFlick = math.random() < 0.4

    Camera.CFrame = targetCFrame
    task.wait(fastFlick and 0.012 or 0.018)

    local steps = fastFlick and 4 or 6

    for i = 1, steps do
        local alpha = (i / steps) ^ (fastFlick and 1.8 or 2)
        Camera.CFrame = targetCFrame:Lerp(startCFrame, alpha)
        task.wait(fastFlick and 0.004 or 0.006)
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

    -- só ativa caindo
    if hrp.Velocity.Y > -1 then return end

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
            if tick() - lastFlickTime > 0.07 then
                lastFlickTime = tick()
                performFlick()
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

print("WallHop Balanced Loaded")
