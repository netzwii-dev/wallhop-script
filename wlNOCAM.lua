-- (Wallhop Humanoid Type - Made by netzwi)
-- All Credits: netzwi (tester, config and uploader)
-- The Best Wallhop Script

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- CONFIG
local DEFAULT_HIDE_GUI_KEY = Enum.KeyCode.RightShift
local DEFAULT_TOGGLE_SCRIPT_KEY = Enum.KeyCode.Q
local SETTINGS_FILE = "netzwii_wallhop_pc_settings.json"

-- STATES
local selectedMode = nil

local isWallHopEnabled = false
local isFlicking = false
local lastFlickTime = 0

local isWallHopping = false
local lastWallHopTime = 0
local WALLHOP_GRACE_TIME = 1.5
local WALLHOP_COOLDOWN = 0.18

local canDoubleJump = false
local lastDoubleJump = 0
local DOUBLE_JUMP_COOLDOWN = 3
local blockDoubleJump = false

local hideGuiKey = DEFAULT_HIDE_GUI_KEY
local toggleScriptKey = DEFAULT_TOGGLE_SCRIPT_KEY
local guiVisible = true
local guiMinimized = false

local waitingForHideKey = false
local waitingForToggleKey = false

local lastHitInstance = nil
local lastFlickAngle = nil

-- GUI REFS
local ScreenGui
local MainFrame
local MiniButton
local MobileButton
local MobileHideButton
local ToggleButton
local HideGuiBindButton
local ToggleBindButton
local Notice
local NoticeStroke

-- SETTINGS
local function safeKeyCodeFromName(name, fallback)
	if typeof(name) ~= "string" then
		return fallback
	end

	local ok, result = pcall(function()
		return Enum.KeyCode[name]
	end)

	if ok and result then
		return result
	end

	return fallback
end

local function saveSettings()
	if not writefile or not isfile then
		return
	end

	local data = {
		hideGuiKey = hideGuiKey.Name,
		toggleScriptKey = toggleScriptKey.Name,
	}

	pcall(function()
		writefile(SETTINGS_FILE, HttpService:JSONEncode(data))
	end)
end

local function loadSettings()
	if not readfile or not isfile then
		return
	end

	if not isfile(SETTINGS_FILE) then
		return
	end

	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(readfile(SETTINGS_FILE))
	end)

	if ok and decoded then
		hideGuiKey = safeKeyCodeFromName(decoded.hideGuiKey, DEFAULT_HIDE_GUI_KEY)
		toggleScriptKey = safeKeyCodeFromName(decoded.toggleScriptKey, DEFAULT_TOGGLE_SCRIPT_KEY)
	end
end

loadSettings()

local function addTrueRoundedShadow(parent, cornerRadius, strength, shadowColor)
	strength = strength or 1
	shadowColor = shadowColor or Color3.fromRGB(0, 0, 0)

	local layers = {
		{grow = math.floor(6 * strength), transparency = 0.84, y = 1},
		{grow = math.floor(12 * strength), transparency = 0.90, y = 2},
		{grow = math.floor(18 * strength), transparency = 0.95, y = 3},
	}

	for _, cfg in ipairs(layers) do
		local shadow = Instance.new("Frame")
		shadow.Name = "TrueShadow"
		shadow.AnchorPoint = Vector2.new(0.5, 0.5)
		shadow.Position = UDim2.new(0.5, 0, 0.5, cfg.y)
		shadow.Size = UDim2.new(1, cfg.grow, 1, cfg.grow)
		shadow.BackgroundColor3 = shadowColor
		shadow.BackgroundTransparency = cfg.transparency
		shadow.BorderSizePixel = 0
		shadow.ZIndex = 0
		shadow.Parent = parent
		Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, cornerRadius + math.floor(cfg.grow / 2.2))
	end
end

local function noTextStroke(obj)
	obj.TextStrokeTransparency = 1
end

local function pointInside(button, point)
	local absPos = button.AbsolutePosition
	local absSize = button.AbsoluteSize
	return point.X >= absPos.X
		and point.X <= absPos.X + absSize.X
		and point.Y >= absPos.Y
		and point.Y <= absPos.Y + absSize.Y
end

local activeNoticeId = 0
local function showNotice(text)
	if selectedMode ~= "PC" or not Notice or not NoticeStroke then
		return
	end

	activeNoticeId += 1
	local noticeId = activeNoticeId

	Notice.Text = text
	Notice.Position = UDim2.new(1, 240, 0, 0)
	Notice.TextTransparency = 1
	Notice.BackgroundTransparency = 0.08
	NoticeStroke.Transparency = 1

	TweenService:Create(Notice, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, 0, 0, 0),
		TextTransparency = 0
	}):Play()

	TweenService:Create(NoticeStroke, TweenInfo.new(0.14), {
		Transparency = 0.9
	}):Play()

	task.spawn(function()
		task.wait(1)
		if noticeId ~= activeNoticeId then
			return
		end

		TweenService:Create(Notice, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 250, 0, 0),
			TextTransparency = 1,
			BackgroundTransparency = 1
		}):Play()

		TweenService:Create(NoticeStroke, TweenInfo.new(0.2), {
			Transparency = 1
		}):Play()
	end)
end

local function updateToggleButton()
	if selectedMode == "PC" and ToggleButton then
		ToggleButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
	elseif selectedMode == "Mobile" and MobileButton then
		MobileButton.Text = isWallHopEnabled and "Wallhop On" or "Wallhop Off"
	end
end

local function updateBindButtons()
	if selectedMode ~= "PC" then
		return
	end

	if HideGuiBindButton then
		HideGuiBindButton.Text = waitingForHideKey and "Press any key..." or ("Keybind Hide GUI: " .. hideGuiKey.Name)
	end
	if ToggleBindButton then
		ToggleBindButton.Text = waitingForToggleKey and "Press any key..." or ("Keybind Toggle Wallhop: " .. toggleScriptKey.Name)
	end
end

local function applyVisibility()
	if selectedMode == "PC" then
		if MainFrame then
			MainFrame.Visible = guiVisible and not guiMinimized
		end
		if MiniButton then
			MiniButton.Visible = guiVisible and guiMinimized
		end
	elseif selectedMode == "Mobile" then
		if MobileButton then
			MobileButton.Visible = guiVisible
		end
	end
end

local function setGuiVisible(state)
	guiVisible = state
	applyVisibility()
	showNotice(state and "GUI shown" or "GUI hidden")
end

local function setMinimized(state)
	if selectedMode ~= "PC" then
		return
	end

	guiMinimized = state
	applyVisibility()

	if state then
		if MiniButton and MainFrame then
			MiniButton.Position = MainFrame.Position
		end
		showNotice("GUI minimized")
	else
		if MainFrame and MiniButton then
			MainFrame.Position = MiniButton.Position
		end
		showNotice("GUI restored")
	end
end
local function createModeSelector(onPick)
	local selectorGui = Instance.new("ScreenGui")
	selectorGui.Name = "WallhopModeSelector"
	selectorGui.ResetOnSpawn = false
	selectorGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	selectorGui.Parent = PlayerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 280, 0, 170)
	frame.Position = UDim2.new(0.5, -140, 0.5, -85)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.Parent = selectorGui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

	addTrueRoundedShadow(frame, 16, 1.45, Color3.fromRGB(0, 0, 0))

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 28)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "Choose Version"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.Parent = frame
	noTextStroke(title)

	local sub = Instance.new("TextLabel")
	sub.Size = UDim2.new(1, -20, 0, 16)
	sub.Position = UDim2.new(0, 10, 0, 34)
	sub.BackgroundTransparency = 1
	sub.Text = "FtF Wallhop • made by netzwi"
	sub.TextColor3 = Color3.fromRGB(95,95,95)
	sub.Font = Enum.Font.Gotham
	sub.TextSize = 12
	sub.Parent = frame
	noTextStroke(sub)

	local pcButton = Instance.new("TextButton")
	pcButton.Size = UDim2.new(1, -20, 0, 42)
	pcButton.Position = UDim2.new(0, 10, 0, 68)
	pcButton.BackgroundColor3 = Color3.fromRGB(3, 3, 3)
	pcButton.Text = "PC Version"
	pcButton.TextColor3 = Color3.fromRGB(255,255,255)
	pcButton.Font = Enum.Font.GothamBold
	pcButton.TextSize = 17
	pcButton.Parent = frame
	Instance.new("UICorner", pcButton).CornerRadius = UDim.new(0, 12)
	noTextStroke(pcButton)

	local mobileButton = Instance.new("TextButton")
	mobileButton.Size = UDim2.new(1, -20, 0, 42)
	mobileButton.Position = UDim2.new(0, 10, 0, 116)
	mobileButton.BackgroundColor3 = Color3.fromRGB(3, 3, 3)
	mobileButton.Text = "Mobile Version"
	mobileButton.TextColor3 = Color3.fromRGB(255,255,255)
	mobileButton.Font = Enum.Font.GothamBold
	mobileButton.TextSize = 17
	mobileButton.Parent = frame
	Instance.new("UICorner", mobileButton).CornerRadius = UDim.new(0, 12)
	noTextStroke(mobileButton)

	pcButton.MouseButton1Click:Connect(function()
		selectorGui:Destroy()
		onPick("PC")
	end)

	mobileButton.MouseButton1Click:Connect(function()
		selectorGui:Destroy()
		onPick("Mobile")
	end)
end

local function buildPCGui()
	ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "FtFWallhopGuiPC"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 265, 0, 164)
	MainFrame.Position = UDim2.new(0.5, -132, 0.5, -82)
	MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BackgroundTransparency = 0
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

	addTrueRoundedShadow(MainFrame, 16, 1, Color3.fromRGB(0, 0, 0))

	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.BackgroundTransparency = 1
	TopBar.Parent = MainFrame

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -44, 0, 22)
	Title.Position = UDim2.new(0, 12, 0, 7)
	Title.BackgroundTransparency = 1
	Title.Text = "FtF Wallhop"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 19
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TopBar
	noTextStroke(Title)

	local SubTitle = Instance.new("TextLabel")
	SubTitle.Size = UDim2.new(1, -44, 0, 12)
	SubTitle.Position = UDim2.new(0, 12, 0, 25)
	SubTitle.BackgroundTransparency = 1
	SubTitle.Text = "PC Version"
	SubTitle.TextColor3 = Color3.fromRGB(110, 110, 110)
	SubTitle.Font = Enum.Font.Gotham
	SubTitle.TextSize = 10
	SubTitle.TextXAlignment = Enum.TextXAlignment.Left
	SubTitle.Parent = TopBar
	noTextStroke(SubTitle)

	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
	MinimizeButton.Position = UDim2.new(1, -29, 0, 8)
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MinimizeButton.Text = "—"
	MinimizeButton.TextColor3 = Color3.fromRGB(225, 225, 225)
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.TextSize = 14
	MinimizeButton.Parent = TopBar
	Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(1, 0)
	noTextStroke(MinimizeButton)

	local ContentFrame = Instance.new("Frame")
	ContentFrame.Name = "ContentFrame"
	ContentFrame.Size = UDim2.new(1, -18, 1, -46)
	ContentFrame.Position = UDim2.new(0, 9, 0, 38)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Parent = MainFrame

	ToggleButton = Instance.new("TextButton")
	ToggleButton.Size = UDim2.new(1, 0, 0, 34)
	ToggleButton.Position = UDim2.new(0, 0, 0, 0)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	ToggleButton.Text = "Wall Hop Off"
	ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
	ToggleButton.Font = Enum.Font.GothamBold
	ToggleButton.TextSize = 17
	ToggleButton.TextXAlignment = Enum.TextXAlignment.Left
	ToggleButton.Parent = ContentFrame
	Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)
	noTextStroke(ToggleButton)

	local TogglePadding = Instance.new("UIPadding")
	TogglePadding.PaddingLeft = UDim.new(0, 14)
	TogglePadding.Parent = ToggleButton

	HideGuiBindButton = Instance.new("TextButton")
	HideGuiBindButton.Size = UDim2.new(1, 0, 0, 28)
	HideGuiBindButton.Position = UDim2.new(0, 0, 0, 40)
	HideGuiBindButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	HideGuiBindButton.Text = "Keybind Hide GUI: RightShift"
	HideGuiBindButton.TextColor3 = Color3.fromRGB(225,225,225)
	HideGuiBindButton.Font = Enum.Font.Gotham
	HideGuiBindButton.TextSize = 12
	HideGuiBindButton.TextXAlignment = Enum.TextXAlignment.Left
	HideGuiBindButton.Parent = ContentFrame
	Instance.new("UICorner", HideGuiBindButton).CornerRadius = UDim.new(0, 11)
	noTextStroke(HideGuiBindButton)

	local HidePadding = Instance.new("UIPadding")
	HidePadding.PaddingLeft = UDim.new(0, 14)
	HidePadding.Parent = HideGuiBindButton

	ToggleBindButton = Instance.new("TextButton")
	ToggleBindButton.Size = UDim2.new(1, 0, 0, 28)
	ToggleBindButton.Position = UDim2.new(0, 0, 0, 72)
	ToggleBindButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	ToggleBindButton.Text = "Keybind Toggle Wallhop: Q"
	ToggleBindButton.TextColor3 = Color3.fromRGB(225,225,225)
	ToggleBindButton.Font = Enum.Font.Gotham
	ToggleBindButton.TextSize = 12
	ToggleBindButton.TextXAlignment = Enum.TextXAlignment.Left
	ToggleBindButton.Parent = ContentFrame
	Instance.new("UICorner", ToggleBindButton).CornerRadius = UDim.new(0, 11)
	noTextStroke(ToggleBindButton)

	local ToggleBindPadding = Instance.new("UIPadding")
	ToggleBindPadding.PaddingLeft = UDim.new(0, 14)
	ToggleBindPadding.Parent = ToggleBindButton

	local BottomLabel = Instance.new("TextLabel")
	BottomLabel.Size = UDim2.new(1, -2, 0, 12)
	BottomLabel.Position = UDim2.new(0, 2, 1, -14)
	BottomLabel.BackgroundTransparency = 1
	BottomLabel.Text = "the best ftf wallhop ever - netzwi panel"
	BottomLabel.TextColor3 = Color3.fromRGB(85, 85, 85)
	BottomLabel.Font = Enum.Font.Gotham
	BottomLabel.TextSize = 8
	BottomLabel.TextXAlignment = Enum.TextXAlignment.Left
	BottomLabel.Parent = ContentFrame
	noTextStroke(BottomLabel)

	MiniButton = Instance.new("TextButton")
	MiniButton.Name = "MiniButton"
	MiniButton.Size = UDim2.new(0, 140, 0, 36)
	MiniButton.Position = UDim2.new(0.5, -70, 0.5, -18)
	MiniButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MiniButton.Visible = false
	MiniButton.Text = "FtF Wallhop"
	MiniButton.TextColor3 = Color3.fromRGB(255,255,255)
	MiniButton.Font = Enum.Font.GothamBold
	MiniButton.TextSize = 14
	MiniButton.Parent = ScreenGui
	Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(1, 0)
	noTextStroke(MiniButton)

	addTrueRoundedShadow(MiniButton, 999, 0.8, Color3.fromRGB(0, 0, 0))

	local NoticeHolder = Instance.new("Frame")
	NoticeHolder.Name = "NoticeHolder"
	NoticeHolder.AnchorPoint = Vector2.new(1, 0)
	NoticeHolder.Position = UDim2.new(1, -10, 0, 8)
	NoticeHolder.Size = UDim2.new(0, 210, 0, 28)
	NoticeHolder.BackgroundTransparency = 1
	NoticeHolder.Parent = ScreenGui

	Notice = Instance.new("TextLabel")
	Notice.AnchorPoint = Vector2.new(1, 0)
	Notice.Position = UDim2.new(1, 240, 0, 0)
	Notice.Size = UDim2.new(0, 200, 0, 26)
	Notice.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Notice.BackgroundTransparency = 0.08
	Notice.TextTransparency = 1
	Notice.Text = ""
	Notice.TextColor3 = Color3.fromRGB(255,255,255)
	Notice.Font = Enum.Font.GothamBold
	Notice.TextSize = 11
	Notice.TextXAlignment = Enum.TextXAlignment.Center
	Notice.Parent = NoticeHolder
	Instance.new("UICorner", Notice).CornerRadius = UDim.new(1, 0)
	noTextStroke(Notice)

	NoticeStroke = Instance.new("UIStroke")
	NoticeStroke.Color = Color3.fromRGB(0,0,0)
	NoticeStroke.Transparency = 1
	NoticeStroke.Thickness = 1
	NoticeStroke.Parent = Notice

	local dragging = false
	local dragStart
	local startPos
	local dragTarget = MainFrame

	local function beginDrag(input, target)
		dragging = true
		dragTarget = target
		dragStart = input.Position
		startPos = target.Position
	end

	local function updateDrag(input)
		if not dragging or not dragTarget then
			return
		end

		local delta = input.Position - dragStart
		dragTarget.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	local function bindDrag(handle, target)
		handle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				beginDrag(input, target)
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
	end

	bindDrag(TopBar, MainFrame)
	bindDrag(MiniButton, MiniButton)

	UserInputService.InputChanged:Connect(function(input)
		if selectedMode == "PC" and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateDrag(input)
		end
	end)

	MinimizeButton.MouseButton1Click:Connect(function()
		setMinimized(true)
	end)

	MiniButton.MouseButton1Click:Connect(function()
		setMinimized(false)
	end)

	HideGuiBindButton.MouseButton1Click:Connect(function()
		waitingForHideKey = true
		waitingForToggleKey = false
		updateBindButtons()
		showNotice("Press a key...")
	end)

	ToggleBindButton.MouseButton1Click:Connect(function()
		waitingForToggleKey = true
		waitingForHideKey = false
		updateBindButtons()
		showNotice("Press a key...")
	end)

	RunService.RenderStepped:Connect(function()
		if selectedMode ~= "PC" then return end
		local inset = GuiService:GetGuiInset()
		if guiVisible and not dragging then
			if not guiMinimized and MainFrame.Position == UDim2.new(0.5, -132, 0.5, -82) then
				MainFrame.Position = UDim2.new(0.5, -132, 0.5, -82 + inset.Y / 2)
			end
		end
	end)

	showNotice("PC version loaded")
end
local function buildMobileGui()
	ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AutoWallHopGuiMobile"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	MobileButton = Instance.new("TextButton")
	MobileButton.Size = UDim2.new(0, 140, 0, 50)
	MobileButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MobileButton.Text = "Wallhop Off"
	MobileButton.TextColor3 = Color3.fromRGB(255,255,255)
	MobileButton.Font = Enum.Font.GothamBold
	MobileButton.TextScaled = true
	MobileButton.Parent = ScreenGui
	Instance.new("UICorner", MobileButton).CornerRadius = UDim.new(0, 12)
	noTextStroke(MobileButton)

	addTrueRoundedShadow(MobileButton, 14, 1, Color3.fromRGB(0, 0, 0))

	MobileHideButton = Instance.new("TextButton")
	MobileHideButton.Size = UDim2.new(0, 54, 0, 54)
	MobileHideButton.Position = UDim2.new(0, 20, 0, 180)
	MobileHideButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MobileHideButton.Text = "≡"
	MobileHideButton.TextColor3 = Color3.fromRGB(255,255,255)
	MobileHideButton.Font = Enum.Font.GothamBold
	MobileHideButton.TextSize = 22
	MobileHideButton.Parent = ScreenGui
	Instance.new("UICorner", MobileHideButton).CornerRadius = UDim.new(1, 0)
	noTextStroke(MobileHideButton)

	addTrueRoundedShadow(MobileHideButton, 999, 1, Color3.fromRGB(0, 0, 0))

	RunService.RenderStepped:Connect(function()
		if selectedMode ~= "Mobile" then return end
		local inset = GuiService:GetGuiInset()
		if not MobileButton:GetAttribute("CustomMoved") then
			MobileButton.Position = UDim2.new(0, 150, 0, inset.Y - 58)
		end
	end)

	local drag = {
		target = nil,
		input = nil,
		startInputPos = nil,
		startTargetPos = nil,
		holdReady = false,
		holdStamp = 0,
		moved = false,
	}

	local function resetDrag()
		drag.target = nil
		drag.input = nil
		drag.startInputPos = nil
		drag.startTargetPos = nil
		drag.holdReady = false
		drag.holdStamp = 0
		drag.moved = false
	end

	local function prepareHold(target, input, needHold)
		drag.target = target
		drag.input = input
		drag.startInputPos = input.Position
		drag.startTargetPos = target.Position
		drag.moved = false

		if needHold then
			drag.holdReady = false
			drag.holdStamp = tick()
			local stamp = drag.holdStamp
			task.spawn(function()
				task.wait(0.5)
				if drag.target == target and drag.input == input and drag.holdStamp == stamp then
					drag.holdReady = true
				end
			end)
		else
			drag.holdReady = true
			drag.holdStamp = tick()
		end
	end

	local function toggleMobileWallhopText()
		isWallHopEnabled = not isWallHopEnabled
		MobileButton.Text = isWallHopEnabled and "Wallhop On" or "Wallhop Off"
	end

	local function beginTracking(target, needHold, clickAction)
		target.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				prepareHold(target, input, needHold)

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						local shouldClick = (drag.target == target and not drag.moved)
						resetDrag()
						if shouldClick and clickAction then
							clickAction()
						end
					end
				end)
			end
		end)
	end

	beginTracking(MobileButton, true, toggleMobileWallhopText)

	beginTracking(MobileHideButton, false, function()
		MobileButton.Visible = not MobileButton.Visible
	end)

	UserInputService.InputChanged:Connect(function(input)
		if selectedMode ~= "Mobile" then return end
		if not drag.target or not drag.input then return end
		if input ~= drag.input then return end
		if not drag.holdReady then return end

		if drag.target == MobileButton and not pointInside(drag.target, input.Position) then
			resetDrag()
			return
		end

		local delta = input.Position - drag.startInputPos

		drag.target.Position = UDim2.new(
			drag.startTargetPos.X.Scale,
			drag.startTargetPos.X.Offset + delta.X,
			drag.startTargetPos.Y.Scale,
			drag.startTargetPos.Y.Offset + delta.Y
		)

		drag.moved = true

		if drag.target == MobileButton then
			MobileButton:SetAttribute("CustomMoved", true)
		end
	end)
end

local function isCrouching(hum, hrp)
	if not hum or not hrp then return false end
	local horizontalSpeed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
	return hum.WalkSpeed <= 9 and horizontalSpeed < 8
end

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

UserInputService.JumpRequest:Connect(function()
	if not isWallHopEnabled or blockDoubleJump then return end

	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChild("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	local stillValid = isWallHopping or (tick() - lastWallHopTime <= WALLHOP_GRACE_TIME)
	if not stillValid then return end

	if canDoubleJump and tick() - lastDoubleJump > DOUBLE_JUMP_COOLDOWN then
		lastDoubleJump = tick()
		canDoubleJump = false

		hrp.Velocity = Vector3.new(hrp.Velocity.X, 30, hrp.Velocity.Z)
		hum:ChangeState(Enum.HumanoidStateType.Jumping)

		task.delay(0.18, function()
			if hum then
				hum:ChangeState(Enum.HumanoidStateType.Freefall)
			end
		end)
	end
end)

local function pickNextFlick()
	local minAngle, maxAngle = 50, 80
	local attempt = 0
	local angle
	repeat
		angle = math.random(minAngle, maxAngle)
		attempt += 1
	until not lastFlickAngle or math.abs(angle - lastFlickAngle) >= 10 or attempt > 20
	lastFlickAngle = angle
	return math.rad(angle)
end

local function performVideoFlick()
	if isFlicking then return end
	isFlicking = true
	isWallHopping = true
	lastWallHopTime = tick()
	blockDoubleJump = true

	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChild("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then
		isFlicking = false
		return
	end

	hrp.Velocity = Vector3.new(hrp.Velocity.X, 44.8, hrp.Velocity.Z)
	hum:ChangeState(Enum.HumanoidStateType.Jumping)

	local baseYaw = hrp.Orientation.Y
	local angle = -pickNextFlick()

	local flickRoll = math.random()
	local steps
	local delayMin
	local delayMax

	if flickRoll < 0.10 then
		steps = math.random(3,4)
		delayMin = 0.003
		delayMax = 0.0045
	elseif flickRoll < 0.40 then
		steps = math.random(4,5)
		delayMin = 0.0045
		delayMax = 0.0065
	else
		steps = math.random(7,9)
		delayMin = 0.008
		delayMax = 0.012
	end

	local baseDelay = 0.01
	local overshoot = math.rad(math.random(20,30))
	local useOvershoot = math.random() < 0.9
  for i = 1, steps do
		local alpha = i / steps
		local curve
		if alpha <= 0.6 then
			curve = math.sin((alpha / 0.6) * (math.pi/2))
		else
			curve = math.sin(((1 - alpha) / 0.4) * (math.pi/2))
		end

		local offset = angle * curve
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)

		RunService.RenderStepped:Wait()
		task.wait(delayMin + math.random() * (delayMax - delayMin))
	end

	if useOvershoot then
		task.delay(0.05, function()
			if not hrp or not hrp.Parent then return end

			local smallSteps = 4

			for i = 1, smallSteps do
				local alpha = i / smallSteps
				local offset = overshoot * alpha
				hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)
				RunService.RenderStepped:Wait()
				task.wait(baseDelay)
			end

			for i = 1, smallSteps do
				local alpha = i / smallSteps
				local offset = overshoot * (1 - alpha)
				hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)
				RunService.RenderStepped:Wait()
				task.wait(baseDelay)
			end

			hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw), 0)
		end)
	end

	hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw), 0)

	if hum:GetState() ~= Enum.HumanoidStateType.Freefall then
		hum:ChangeState(Enum.HumanoidStateType.Freefall)
	end

	task.delay(0.05, function()
		blockDoubleJump = false
	end)

	task.delay(0.15, function()
		isWallHopping = false
	end)

	isFlicking = false
end

local function isPlayerCharacter(instance)
	if not instance then return false end
	local model = instance:FindFirstAncestorOfClass("Model")
	return model and model:FindFirstChildOfClass("Humanoid")
end

local function hasValidHorizontalEdge(rayResult, params)
	if not rayResult or not rayResult.Instance then return false end

	local hitPos = rayResult.Position
	local normal = rayResult.Normal.Unit

	local right = normal:Cross(Vector3.new(0, 1, 0))
	if right.Magnitude < 0.01 then
		return false
	end
	right = right.Unit

	local surfaceOffset = normal * 0.08

	local verticalChecks = {
		Vector3.new(0, 0.9, 0),
		Vector3.new(0, -0.9, 0),
		Vector3.new(0, 1.25, 0),
		Vector3.new(0, -1.25, 0),
	}

	local foundHorizontalEdge = false
	for _, vOffset in ipairs(verticalChecks) do
		local origin = hitPos + vOffset + surfaceOffset
		local probe = workspace:Raycast(origin, -normal * 0.22, params)

		if not probe or not probe.Instance or probe.Instance ~= rayResult.Instance then
			foundHorizontalEdge = true
			break
		end
	end

	if not foundHorizontalEdge then
		return false
	end

	return true
end

local function findValidWall(hrp, params, directions)
	local offsets = {
		Vector3.new(0,-2.2,0),
		Vector3.new(0,-1.2,0),
		Vector3.new(0,-0.4,0)
	}

	for _, dir in ipairs(directions) do
		for _, offset in ipairs(offsets) do
			local origin = hrp.Position + offset
			local ray = workspace:Raycast(origin, dir, params)
			if ray and ray.Instance and ray.Instance.CanCollide and not isPlayerCharacter(ray.Instance) then
				if hasValidHorizontalEdge(ray, params) then
					return ray
				end
			end
		end
	end

	return nil
end

local function isWithinWallhopAngle(cameraLook, wallNormal, maxAngleDeg)
	local look = Vector3.new(cameraLook.X, 0, cameraLook.Z)
	local normal = Vector3.new(wallNormal.X, 0, wallNormal.Z)

	if look.Magnitude <= 0 or normal.Magnitude <= 0 then
		return false
	end

	look = look.Unit
	normal = normal.Unit

	local dotFront = math.clamp(look:Dot(-normal), -1, 1)
	local dotBack = math.clamp(look:Dot(normal), -1, 1)

	local frontAngle = math.deg(math.acos(dotFront))
	local backAngle = math.deg(math.acos(dotBack))

	return frontAngle <= maxAngleDeg or backAngle <= maxAngleDeg
end

RunService.Heartbeat:Connect(function()
	if not selectedMode then return end
	if not isWallHopEnabled then return end

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")

	if not hrp or not hum then return end
	if isCrouching(hum, hrp) then return end

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {char}
	params.FilterType = Enum.RaycastFilterType.Exclude

	local look = Camera.CFrame.LookVector
	local horizontal = Vector3.new(look.X, 0, look.Z)

	if horizontal.Magnitude <= 0 then
		lastHitInstance = nil
		return
	end

	horizontal = horizontal.Unit

	local forwardDirection = horizontal * 1.55
	local backwardDirection = -horizontal * 1.55

	local result = findValidWall(hrp, params, {
		forwardDirection,
		backwardDirection
	})

	if result and result.Instance then
		local validAngle = isWithinWallhopAngle(Camera.CFrame.LookVector, result.Normal, 25)

		if validAngle then
			if lastHitInstance and lastHitInstance ~= result.Instance then
				if hrp.Velocity.Y < -2.2 and tick() - lastFlickTime > WALLHOP_COOLDOWN then
					lastFlickTime = tick()
					performVideoFlick()
				end
			end
			lastHitInstance = result.Instance
		else
			lastHitInstance = nil
		end
	else
		lastHitInstance = nil
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if selectedMode ~= "PC" then return end
	if gameProcessed then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

	local key = input.KeyCode
	if key == Enum.KeyCode.Unknown then return end

	if waitingForHideKey then
		if key ~= toggleScriptKey then
			hideGuiKey = key
			waitingForHideKey = false
			updateBindButtons()
			saveSettings()
			showNotice("Hide GUI updated")
		else
			showNotice("Key already in use")
		end
		return
	end

	if waitingForToggleKey then
		if key ~= hideGuiKey then
			toggleScriptKey = key
			waitingForToggleKey = false
			updateBindButtons()
			saveSettings()
			showNotice("Wallhop key updated")
		else
			showNotice("Key already in use")
		end
		return
	end

	if key == hideGuiKey then
		setGuiVisible(not guiVisible)
		return
	end

	if key == toggleScriptKey then
		isWallHopEnabled = not isWallHopEnabled
		updateToggleButton()
		showNotice(isWallHopEnabled and "Wallhop enabled" or "Wallhop disabled")
		return
	end
end)

createModeSelector(function(mode)
	selectedMode = mode

	if mode == "PC" then
		buildPCGui()
		updateBindButtons()
	else
		buildMobileGui()
	end

	updateToggleButton()
	applyVisibility()
end)

print("Made by netzwi | Best Flee The Facility Wallhop Script - Loaded Successfully ✅")
