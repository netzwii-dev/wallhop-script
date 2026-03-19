-- serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Button = Instance.new("TextButton")
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 120, 0, 35)

-- posição AJUSTADA (mais pra direita e mais pra cima)
Button.Position = UDim2.new(0, 140, 0, 210)

Button.Text = "Wallhop: OFF"
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.TextColor3 = Color3.new(1,1,1)
Button.TextSize = 14

local enabled = false

-- toggle
Button.MouseButton1Click:Connect(function()
    enabled = not enabled
    Button.Text = enabled and "Wallhop: ON" or "Wallhop: OFF"
end)

-- pegar personagem
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

-- flick leve pra esquerda
local function flickLeft()
    local original = camera.CFrame
    camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(-45), 0)
    task.wait(0.04) -- bem rápido
    camera.CFrame = original
end

-- wallhop loop
RunService.RenderStepped:Connect(function()
    if not enabled then return end
    
    local char = getChar()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if humanoid and root then
        -- verifica se está no ar e perto de parede
        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            
            local ray = Ray.new(root.Position, root.CFrame.LookVector * 3)
            local hit = workspace:FindPartOnRay(ray, char)
            
            if hit then
                -- pulo + impulso
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
                
                -- flick leve
                flickLeft()
            end
        end
    end
end)
