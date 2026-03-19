--[[
    Auto Wall Hop Script (Final Version)
    - Flick 90° esquerda mais suave
    - Botão arrastável + sistema de trava (hold 1s)
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- --- UI ---
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoWallHopGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0, 140, 0, 50)
TextButton.Position = UDim2.new(0.1, 0, 0.7, 0)
TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.Text = "Wall Hop Off"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextScaled = true
TextButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = TextButton

-- --- VARIÁVEIS ---
local isWallHopEnabled = false
local isFlicking = false
local lastFlickTime = 0
local isLocked = false

local Camera = workspace.CurrentCamera

-- --- FLICK MODIFICADO ---
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

    -- impulso
    hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)

    -- câmera (90° esquerda + mais suave)
    local startCFrame = Camera.CFrame
    Camera.CFrame = startCFrame * CFrame.Angles(0, math.rad(-90), 0)

    task.wait(0.08)

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
            if tick() - lastFlickTime > 0.05 then
                lastFlickTime = tick()
                performVideoFlick()
            end
        end
        lastHitInstance = result.Instance
    else
        lastHitInstance = nil
    end
end)

-- --- BOTÃO ON/OFF ---
TextButton.MouseButton1Click:Connect(function()
    if isLocked then return end

    isWallHopEnabled = not isWallHopEnabled

    TextButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
    TextButton.BackgroundColor3 = isWallHopEnabled and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(0, 0, 0)
end)

-- --- DRAG + LOCK ---
local dragging = false
local dragStart, startPos
local holdStart = 0

TextButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        
        holdStart = tick()

        if not isLocked then
            dragging = true
            dragStart = input.Position
            startPos = TextButton.Position
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and not isLocked and (
        input.UserInputType == Enum.UserInputType.MouseMovement 
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        
        local delta = input.Position - dragStart

        TextButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        
        dragging = false

        -- segurar 1s = trava/destrava
        if tick() - holdStart > 1 then
            isLocked = not isLocked

            if isLocked then
                TextButton.Text = "Locked 🔒"
                TextButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            else
                TextButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
                TextButton.BackgroundColor3 = isWallHopEnabled and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(0, 0, 0)
            end
        end
    end
end)

print("Auto Wall Hop (Final) Loaded!")
