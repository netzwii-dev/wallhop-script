--[[
    Auto Wall Hop Script (Video Recreation Version)
    + Double Jump realista (3s cooldown fixo)
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

-- --- UI ---
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoWallHopGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local TextButton = Instance.new("TextButton")
TextButton.Name = "WallHopToggleButton"
TextButton.Size = UDim2.new(0, 140, 0, 50)
TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.Text = "Wall Hop Off"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
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

-- --- LOGIC ---
local isWallHopEnabled = false
local isFlicking = false
local lastFlickTime = 0
local Camera = workspace.CurrentCamera

-- =========================
-- CONTROLE DOUBLE JUMP
-- =========================
local canAirJump = false
local lastWallHopTime = 0

-- 🎯 Flick 45°
local function performVideoFlick()
    if isFlicking then return end
    isFlicking = true
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        isFlicking = false
        return
    end

    -- boost original
    hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)

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

    -- registra tempo do wallhop
    lastWallHopTime = tick()
    canAirJump = false

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

-- =========================
-- LIBERAÇÃO APÓS 3s REAL
-- =========================
RunService.Heartbeat:Connect(function()
    if not isWallHopEnabled then return end
    
    if not canAirJump and tick() - lastWallHopTime >= 3 then
        canAirJump = true
    end
end)

-- =========================
-- DOUBLE JUMP (SUAVE)
-- =========================
UserInputService.JumpRequest:Connect(function()
    if not isWallHopEnabled then return end
    if not canAirJump then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    if hum.FloorMaterial == Enum.Material.Air then
        canAirJump = false

        -- 🔥 força igual double jump real (ajustada)
        task.spawn(function()
            for i = 1, 2 do
                hrp.Velocity = Vector3.new(
                    hrp.Velocity.X,
                    48, -- altura ajustada (mais natural)
                    hrp.Velocity.Z
                )
                task.wait(0.025)
            end
        end)
    end
end)

-- toggle botão
TextButton.MouseButton1Click:Connect(function()
    isWallHopEnabled = not isWallHopEnabled
    TextButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
    TextButton.BackgroundColor3 = isWallHopEnabled and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(0, 0, 0)
end)

print("WallHop + DoubleJump Realista Loaded 🔥")
