--[[
    Auto Wall Hop (Refined)
    - Botão alinhado abaixo do chat
    - Flick leve 45° esquerda (quase instantâneo)
    - Wallhop original mantido
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- --- UI ---
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoWallHopGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0, 140, 0, 45)

-- 🔥 AJUSTE FINO DA POSIÇÃO (mais pra direita e mais pra cima)
TextButton.Position = UDim2.new(0, 60, 0, 20)

TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.Text = "Wall Hop Off"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextScaled = true
TextButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = TextButton

-- --- VARIÁVEIS ---
local isWallHopEnabled = false
local lastHopTime = 0
local Camera = workspace.CurrentCamera
local isFlicking = false

-- --- WALLHOP + FLICK LEVE ---
local function doWallHop()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if not hum or not hrp then return end

    -- pulo normal (NÃO ALTERADO)
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)

    -- 🔥 FLICK LEVE ESQUERDA (45° quase instantâneo)
    if not isFlicking then
        isFlicking = true

        local start = Camera.CFrame
        Camera.CFrame = start * CFrame.Angles(0, math.rad(-45), 0)

        task.wait(0.015) -- quase imperceptível

        Camera.CFrame = start
        isFlicking = false
    end
end

-- --- DETECÇÃO ---
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
        workspace.CurrentCamera.CFrame.LookVector * 3,
        raycastParams
    )

    if result and result.Instance and result.Instance.CanCollide then
        if lastHitInstance and lastHitInstance ~= result.Instance then
            if tick() - lastHopTime > 0.05 then
                lastHopTime = tick()
                doWallHop()
            end
        end
        lastHitInstance = result.Instance
    else
        lastHitInstance = nil
    end
end)

-- --- BOTÃO ---
TextButton.MouseButton1Click:Connect(function()
    isWallHopEnabled = not isWallHopEnabled

    TextButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
    TextButton.BackgroundColor3 = isWallHopEnabled and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(0, 0, 0)
end)

print("Auto Wall Hop (Refined) Loaded!")
