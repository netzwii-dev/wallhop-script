local UserInputService = game:GetService("UserInputService")

local doubleJumpReady = true
local doubleJumpUsed = false
local lastGroundedTime = 0

-- detectar chão
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")

    if hum and hum.FloorMaterial ~= Enum.Material.Air then
        doubleJumpUsed = false
        lastGroundedTime = tick()
    end
end)

-- input (mobile + pc)
UserInputService.JumpRequest:Connect(function()
    if not isWallHopEnabled then return end
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return end

    -- se estiver no ar
    if hum.FloorMaterial == Enum.Material.Air then
        
        if doubleJumpReady and not doubleJumpUsed then
            doubleJumpUsed = true
            doubleJumpReady = false

            -- executa o pulo manual
            hum:ChangeState(Enum.HumanoidStateType.Jumping)

            -- cooldown de 3s
            task.delay(3, function()
                doubleJumpReady = true
            end)
        end
    end
end)
