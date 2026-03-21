--[[
    WallHop Aim Assist (Mobile Friendly)
    - NÃO quebra double jump
    - NÃO força pulo
    - Ajuda MUITO no wallhop
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Camera = workspace.CurrentCamera

-- UI
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0,140,0,50)
Button.Text = "Assist OFF"
Button.BackgroundColor3 = Color3.fromRGB(0,0,0)
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.Font = Enum.Font.GothamBold
Button.TextScaled = true
Button.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Button)

RunService.RenderStepped:Connect(function()
    local inset = GuiService:GetGuiInset()
    Button.Position = UDim2.new(0,150,0,inset.Y - 58)
end)

local enabled = false

Button.MouseButton1Click:Connect(function()
    enabled = not enabled
    Button.Text = enabled and "Assist ON" or "Assist OFF"
end)

-- LOGIC
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

RunService.Heartbeat:Connect(function()
    if not enabled then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    rayParams.FilterDescendantsInstances = {char}

    local result = workspace:Raycast(
        hrp.Position,
        Camera.CFrame.LookVector * 4,
        rayParams
    )

    if result and result.Instance and result.Instance.CanCollide then
        
        -- 🎯 alinhar câmera levemente com a parede
        local normal = result.Normal
        local wallDir = (Vector3.new(normal.Z, 0, -normal.X)).Unit

        Camera.CFrame = Camera.CFrame:Lerp(
            CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + wallDir),
            0.25
        )

        -- 🔥 impulso lateral leve (não mexe no Y)
        local vel = hrp.Velocity

        hrp.Velocity = Vector3.new(
            vel.X + wallDir.X * 12,
            vel.Y,
            vel.Z + wallDir.Z * 12
        )
    end
end)

print("WallHop Aim Assist Loaded")
