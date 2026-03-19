--[[
    Auto Wall Hop (TRYHARD VERSION)
    - Flick mais rápido
    - Direção invertida
    - Botão +30px mais alto
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

-- --- UI ---
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoWallHopGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0, 140, 0, 45)
TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.Text = "Wall Hop Off"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextScaled = true
TextButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = TextButton

-- POSIÇÃO (SUBIDO +30px)
RunService.RenderStepped:Connect(function()
    local inset = GuiService:GetGuiInset()
    TextButton.Position = UDim2.new(0, 10, 0, inset.Y - 28)
end)

-- --- VARIÁVEIS ---
local isWallHopEnabled = false
local isFlicking = false
local lastFlickTime = 0

local Camera = workspace.CurrentCamera

-- --- FLICK TRYHARD (RÁPIDO + INVERTIDO) ---
local function performVideoFlick()
    if isFlicking then return end
    isFlicking = true
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then
        isFlicking = false
        return
    end

    -- pulo
    hum:ChangeState(Enum.HumanoidStateType.Jumping)

    -- impulso mais forte (tryhard)
    hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)

    local startCFrame = Camera.CFrame

    -- INVERTIDO (agora positivo)
    local rotation = CFrame.fromAxisAngle(Vector3.new(0,1,0), math.rad(45))
    Camera.CFrame = rotation * startCFrame

    -- MAIS RÁPIDO
    task.wait(0.035)

    Camera.CFrame = startCFrame

    isFlicking = false
end

-- --- DETECÇÃO DE PAREDE ---
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
            if tick() - lastFlickTime > 0.04 then -- mais responsivo
                lastFlickTime = tick()
                performVideoFlick()
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

print("Auto Wall Hop (TRYHARD FAST) Loaded!")
