local startCFrame = Camera.CFrame
local targetCFrame = startCFrame * CFrame.Angles(0, math.rad(45), 0)

-- 40% chance de flick rápido
local fastFlick = math.random() < 0.4

-- ida rápida
Camera.CFrame = targetCFrame

-- pausa
if fastFlick then
    task.wait(0.012 + math.random() * 0.003)
else
    task.wait(0.018 + math.random() * 0.004)
end

-- configs dinâmicas
local steps = fastFlick and 4 or 6

for i = 1, steps do
    local curve = fastFlick and 1.8 or (2 + math.random() * 0.3)
    local alpha = (i / steps) ^ curve
    Camera.CFrame = targetCFrame:Lerp(startCFrame, alpha)

    if fastFlick then
        task.wait(0.004 + math.random() * 0.001)
    else
        task.wait(0.006 + math.random() * 0.002)
    end
end
