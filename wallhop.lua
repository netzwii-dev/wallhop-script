--[[
    Auto Wall Hop (LEGIT PERFEITO)
    - funciona colado
    - comportamento natural
    - flick mantido
    - botão +20px direita
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

-- posição atualizada (+20px direita)
RunService.RenderStepped:Connect(function()
    local inset = GuiService:GetGuiInset()
    TextButton.Position = UDim2.new(0, 130, 0, inset.Y - 58)
end)

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
local isFlicking = false
local lastFlickTime = 0

local Camera = workspace.CurrentCamera

-- --- FLICK (mantido) ---
local function performVideoFlick()
    if isFlicking then return end
    isFlicking = true
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then
        isFlicking = false
        return
    end

    hum:ChangeState(Enum.HumanoidStateType.Jumping)

    local startCFrame = Camera.CFrame

    Camera.CFrame = startCFrame * CFrame.Angles(0, math.rad(45), 0)

    task.wait(0.04)

    Camera.CFrame = startCFrame

    isFlicking = false
end

-- --- DETECÇÃO LEGIT ---
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
        
        local speed = hrp.Velocity.Magnitude

        if speed > 2 then
            if tick() - lastFlickTime > 0.045 then
                lastFlickTime = tick()
                performVideoFlick()
            end
        end
    end
end)

-- --- BOTÃO ---
TextButton.MouseButton1Click:Connect(function()
    isWallHopEnabled = not isWallHopEnabled

    TextButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
    TextButton.BackgroundColor3 = isWallHopEnabled and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(0, 0, 0)
end)

print("Auto Wall Hop (LEGIT PERFECT + POS FIX) Loaded!")
