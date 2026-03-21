--[[
    AUTO WALLHOP + DOUBLE JUMP (VERSÃO BLINDADA)
    - Anti erro de carregamento
    - Funciona mobile
    - Double jump manual (3s)
]]

-- 🔒 garantir carregamento total
repeat task.wait() until game:IsLoaded()

-- serviços seguros
local Players = game:WaitForChild("Players")
local RunService = game:WaitForChild("RunService")
local GuiService = game:WaitForChild("GuiService")
local UserInputService = game:WaitForChild("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- 🔒 função segura de pegar personagem
local function getCharacter()
    local char = LocalPlayer.Character
    if not char or not char.Parent then
        char = LocalPlayer.CharacterAdded:Wait()
    end
    return char
end

-- 🔒 pegar camera SEMPRE válida
local function getCamera()
    local cam = workspace.CurrentCamera
    while not cam do
        task.wait()
        cam = workspace.CurrentCamera
    end
    return cam
end

-- --- UI ---
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoWallHopGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0, 140, 0, 50)
TextButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
TextButton.Text = "Wall Hop Off"
TextButton.TextColor3 = Color3.fromRGB(255,255,255)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextScaled = true
TextButton.Parent = ScreenGui

Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0,12)

RunService.RenderStepped:Connect(function()
    local inset = GuiService:GetGuiInset()
    TextButton.Position = UDim2.new(0,150,0,inset.Y - 58)
end)

-- --- VARS ---
local isWallHopEnabled = false
local isFlicking = false
local lastFlickTime = 0

-- =========================
-- DOUBLE JUMP
-- =========================
local doubleJumpReady = true
local doubleJumpUsed = false

RunService.Heartbeat:Connect(function()
    if not isWallHopEnabled then return end

    local char = getCharacter()
    local hum = char:FindFirstChild("Humanoid")

    if hum and hum.FloorMaterial ~= Enum.Material.Air then
        doubleJumpUsed = false
    end
end)

UserInputService.JumpRequest:Connect(function()
    if not isWallHopEnabled then return end

    local char = getCharacter()
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    if hum.FloorMaterial == Enum.Material.Air then
        if doubleJumpReady and not doubleJumpUsed then
            doubleJumpUsed = true
            doubleJumpReady = false

            hum:ChangeState(Enum.HumanoidStateType.Jumping)

            task.delay(3, function()
                doubleJumpReady = true
            end)
        end
    end
end)

-- =========================
-- FLICK
-- =========================
local function performFlick()
    if isFlicking then return end
    isFlicking = true

    local char = getCharacter()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then isFlicking = false return end

    local Camera = getCamera()

    -- boost
    hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)

    local start = Camera.CFrame
    local target = start * CFrame.Angles(0, math.rad(45), 0)

    local fast = math.random() < 0.4

    Camera.CFrame = target

    task.wait(fast and 0.012 or 0.018)

    local steps = fast and 4 or 6

    for i = 1, steps do
        local alpha = (i/steps)^(fast and 1.8 or 2)
        Camera.CFrame = target:Lerp(start, alpha)
        task.wait(fast and 0.004 or 0.006)
    end

    isFlicking = false
end

-- =========================
-- WALL DETECT
-- =========================
local lastHit = nil

RunService.Heartbeat:Connect(function()
    if not isWallHopEnabled then return end

    local char = getCharacter()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local Camera = getCamera()

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
                performFlick()
            end
        end
        lastHit = result.Instance
    else
        lastHit = nil
    end
end)

-- =========================
-- TOGGLE
-- =========================
TextButton.MouseButton1Click:Connect(function()
    isWallHopEnabled = not isWallHopEnabled
    TextButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
end)

print("SCRIPT BLINDADO CARREGADO 🔥")
