-- AUTO WALLHOP + DOUBLE JUMP (REFINADO - FIX ANIMAÇÃO)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- UI
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

Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 12)

RunService.RenderStepped:Connect(function()
    local inset = GuiService:GetGuiInset()
    TextButton.Position = UDim2.new(0, 150, 0, inset.Y - 58)
end)

-- STATES
local isWallHopEnabled = false
local isFlicking = false
local lastFlickTime = 0
local Camera = workspace.CurrentCamera

local isWallHopping = false

-- DOUBLE JUMP
local canDoubleJump = false
local lastDoubleJump = 0
local DOUBLE_JUMP_COOLDOWN = 3

-- CROUCH CHECK (FTF-LIKE)
local function isCrouching(hum, hrp)
    if not hum or not hrp then return false end

    local horizontalSpeed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude

    if hum.WalkSpeed <= 9 and horizontalSpeed < 10 then
        return true
    end

    return false
end

-- CHARACTER HANDLER
local function setupCharacter(char)
    local hum = char:WaitForChild("Humanoid")

    hum.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Freefall then
            canDoubleJump = true
        end

        if new == Enum.HumanoidStateType.Landed then
            canDoubleJump = false
        end
    end)
end

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- DOUBLE JUMP INPUT
UserInputService.JumpRequest:Connect(function()
    if not isWallHopEnabled then return end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if not isWallHopping then return end

    if canDoubleJump and tick() - lastDoubleJump > DOUBLE_JUMP_COOLDOWN then
        lastDoubleJump = tick()
        canDoubleJump = false

        hrp.Velocity = Vector3.new(hrp.Velocity.X, 34.5, hrp.Velocity.Z)
        hum:ChangeState(Enum.HumanoidStateType.Jumping)

        task.delay(0.18, function()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
            end
        end)
    end
end)

-- FLICK
local function performVideoFlick()
    if isFlicking then return end
    isFlicking = true

    isWallHopping = true

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then
        isFlicking = false
        return
    end

    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    hrp.Velocity = Vector3.new(hrp.Velocity.X, 44.8, hrp.Velocity.Z)

    local startCFrame = Camera.CFrame
    local targetCFrame = startCFrame * CFrame.Angles(0, math.rad(45), 0)

    local fastFlick = math.random() < 0.4

    Camera.CFrame = targetCFrame

    task.wait(fastFlick and 0.013 or 0.019)

    local steps = fastFlick and 4 or 6

    for i = 1, steps do
        local alpha = (i / steps) ^ (fastFlick and 1.8 or 2.2)
        Camera.CFrame = targetCFrame:Lerp(startCFrame, alpha)
        task.wait(fastFlick and 0.0045 or 0.0065)
    end

    task.delay(0.1, function()
        if hum and hum:GetState() == Enum.HumanoidStateType.Jumping then
            hum:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    end)

    task.delay(0.25, function()
        isWallHopping = false
    end)

    isFlicking = false
end

-- WALL DETECT (AGORA IGNORA PLAYERS)
local lastHitInstance = nil

local function isPlayerCharacter(instance)
    if not instance then return false end
    local model = instance:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        return true
    end
    return false
end

RunService.Heartbeat:Connect(function()
    if not isWallHopEnabled then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if not hrp or not hum then return end

    -- BLOQUEIO AGACHADO
    if isCrouching(hum, hrp) then return end

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char}
    params.FilterType = Enum.RaycastFilterType.Exclude

    local look = Camera.CFrame.LookVector
    local horizontal = Vector3.new(look.X, 0, look.Z)

    if horizontal.Magnitude > 0 then
        horizontal = horizontal.Unit
    end

    -- ALCANCE AJUSTADO
    local direction = horizontal * 1.8

    local result = nil

    local offsets = {
        Vector3.new(0, -2.2, 0),
        Vector3.new(0, -1.2, 0),
        Vector3.new(0, -0.4, 0)
    }

    for _, offset in ipairs(offsets) do
        local origin = hrp.Position + offset
        local ray = workspace:Raycast(origin, direction, params)

        if ray and ray.Instance and ray.Instance.CanCollide then
            if not isPlayerCharacter(ray.Instance) then
                result = ray
                break
            end
        end
    end

    if result and result.Instance then
        if lastHitInstance and lastHitInstance ~= result.Instance then
            if hrp.Velocity.Y < -1 and tick() - lastFlickTime > 0.07 then
                lastFlickTime = tick()
                performVideoFlick()
            end
        end
        lastHitInstance = result.Instance
    else
        lastHitInstance = nil
    end
end)

-- TOGGLE
TextButton.MouseButton1Click:Connect(function()
    isWallHopEnabled = not isWallHopEnabled
    TextButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
    TextButton.BackgroundColor3 = isWallHopEnabled and Color3.fromRGB(40,40,40) or Color3.fromRGB(0,0,0)
end)

print("WallHop Loaded (1.8 + Crouch FTF)")
