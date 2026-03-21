
--[[
    Auto Wall Hop Script (Video Recreation Version)
    + Double Jump sincronizado com animação real
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

Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 12)

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
-- DOUBLE JUMP CONTROL
-- =========================
local canAirJump = false
local lastJumpTime = 0

-- 🎯 Flick
local function performVideoFlick()
    if isFlicking then return end
    isFlicking = true
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        isFlicking = false
        return
    end

    hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)

    local start = Camera.CFrame
    local target = start * CFrame.Angles(0, math.rad(45), 0)

    Camera.CFrame = target
    task.wait(0.015)

    for i = 1, 5 do
        Camera.CFrame = target:Lerp(start, i/5)
        task.wait(0.005)
    end

    isFlicking = false
end

-- wall detect
local lastHit = nil

RunService.Heartbeat:Connect(function()
    if not isWallHopEnabled then return end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char}
    params.FilterType = Enum.RaycastFilterType.Exclude

    local result = workspace:Raycast(
        hrp.Position,
        Camera.CFrame.LookVector * 3,
        params
    )

    if result and result.Instance and result.Instance.CanCollide then
        if lastHit and lastHit ~= result.Instance then
            if hrp.Velocity.Y < 0 and tick() - lastFlickTime > 0.065 then
                lastFlickTime = tick()
                performVideoFlick()
            end
        end
        lastHit = result.Instance
    else
        lastHit = nil
    end
end)

-- cooldown real
RunService.Heartbeat:Connect(function()
    if not isWallHopEnabled then return end
    if tick() - lastJumpTime >= 3 then
        canAirJump = true
    end
end)

-- =========================
-- DOUBLE JUMP REALISTA
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
        lastJumpTime = tick()

        -- 🔥 impulso progressivo (igual jogo)
        task.spawn(function()
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 34, hrp.Velocity.Z)
            task.wait(0.03)
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 30, hrp.Velocity.Z)
        end)

        -- 🔥 sincronização de animação
        task.delay(0.05, function()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)

        task.delay(0.12, function()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
            end
        end)
    end
end)

-- toggle
TextButton.MouseButton1Click:Connect(function()
    isWallHopEnabled = not isWallHopEnabled
    TextButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
end)

print("WallHop + DoubleJump ULTRA REALISTA 🔥")
