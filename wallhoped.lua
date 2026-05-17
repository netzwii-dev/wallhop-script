-- Cerber X V1.1 (Made by nyhito)
-- All Credits: nyhito (tester, config and uploader)
-- The Best Flee the Facility Script

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

local CERBER_ICON_IMAGE = "rbxassetid://98605939008332"

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local GLOBAL_WALLHOP_TOKEN_NAME = "__nyhito_ftf_wallhop_active_token"
local ACTIVE_SCRIPT_TOKEN = tostring(os.clock()) .. "_" .. tostring(math.random(100000, 999999))

pcall(function()
	if getgenv then
		getgenv()[GLOBAL_WALLHOP_TOKEN_NAME] = ACTIVE_SCRIPT_TOKEN
	else
		_G[GLOBAL_WALLHOP_TOKEN_NAME] = ACTIVE_SCRIPT_TOKEN
	end
end)

local function isThisScriptActive()
	local ok, value = pcall(function()
		if getgenv then
			return getgenv()[GLOBAL_WALLHOP_TOKEN_NAME]
		end
		return _G[GLOBAL_WALLHOP_TOKEN_NAME]
	end)

	if not ok then
		return true
	end

	return value == ACTIVE_SCRIPT_TOKEN
end


local DEFAULT_HIDE_GUI_KEY = Enum.KeyCode.RightShift
local DEFAULT_TOGGLE_SCRIPT_KEY = Enum.KeyCode.Y
local DEFAULT_TOGGLE_BEAST_SLOW_KEY = Enum.KeyCode.I
local DEFAULT_TOGGLE_CORNER_WALK_KEY = Enum.KeyCode.R
local DEFAULT_TOGGLE_XRAY_KEY = Enum.KeyCode.X
local DEFAULT_TOGGLE_NON_SPAM_KEY = Enum.KeyCode.U
local DEFAULT_TOGGLE_CLIP_DANCE2_KEY = Enum.KeyCode.P
local DEFAULT_TOGGLE_FLOORBANG_ESP_KEY = Enum.KeyCode.F

local KEYBINDS_FILE = "nyhito_ftf_wallhop_keybinds.json"
local PREFS_FILE = "nyhito_ftf_wallhop_prefs.json"

selectedMode = nil

hideGuiKey = DEFAULT_HIDE_GUI_KEY
toggleScriptKey = DEFAULT_TOGGLE_SCRIPT_KEY
toggleBeastSlowKey = DEFAULT_TOGGLE_BEAST_SLOW_KEY
toggleCornerWalkKey = DEFAULT_TOGGLE_CORNER_WALK_KEY
toggleXrayKey = DEFAULT_TOGGLE_XRAY_KEY
toggleNonSpamKey = DEFAULT_TOGGLE_NON_SPAM_KEY
toggleClipDance2Key = DEFAULT_TOGGLE_CLIP_DANCE2_KEY
toggleFloorbangEspKey = DEFAULT_TOGGLE_FLOORBANG_ESP_KEY

waitingForHideKey = false
waitingForToggleKey = false
waitingForBeastSlowKey = false
waitingForCornerWalkKey = false
waitingForXrayKey = false
waitingForNonSpamKey = false
waitingForClipDance2Key = false
waitingForFloorbangEspKey = false

guiVisible = true
guiMinimized = false
mobileMenuOpen = false
mobileWallhopGuiHidden = false
mobileCornerWalkButtonVisible = false
mobileBeastSlowButtonVisible = false

ScreenGui = nil
MainFrame = nil
MiniButton = nil
MobileButton = nil
MobileCornerWalkButton = nil
MobileBeastSlowButton = nil
MobileMenuButton = nil
MobilePanel = nil
ToggleButton = nil
HideGuiBindButton = nil
ToggleBindButton = nil
BeastSlowBindButton = nil
CornerWalkBindButton = nil
XrayBindButton = nil
RealXrayBindButton = nil
ClipDance2BindButton = nil
FloorbangEspBindButton = nil
Notice = nil
NoticeStroke = nil
NoticeBar = nil

PcTabFunctions = nil
PcTabFlicks = nil
PcTabSettings = nil
PcFunctionsPage = nil
PcFlicksPage = nil
PcSettingsPage = nil
PcMinimalSettingsTitle = nil
PcCurrentUsingLabel = nil
PcSettingsXrayTitle = nil
PcSettingsNonSpamTitle = nil
PcSettingsXrayBox = nil
PcSettingsNonSpamBox = nil
PcSettingsNonSpamAfterTitle = nil
PcSettingsNonSpamAfterBox = nil
PcDance2TimeTitle = nil
PcDance2TimeBox = nil
PcCwalkRangeTitle = nil
PcCwalkRangeBox = nil
PcNormalWallhopButton = nil
PcNoMoveWallhopButton = nil
Pc360WallhopButton = nil
PcConsoleWallhopButton = nil
PcFlickTypesTitle = nil
PcFlickSettingsTitle = nil
PcNormalFlickButton = nil
PcSpeedFlickButton = nil
PcSlowFlickButton = nil

MobileTabFunctions = nil
MobileTabFlicks = nil
MobileTabSettings = nil
MobileFunctionsPage = nil
MobileFlicksPage = nil
MobileSettingsPage = nil
MobileMinimalSettingsTitle = nil
MobileCurrentUsingLabel = nil
SettingsXrayBox = nil
SettingsNonSpamBox = nil
SettingsNonSpamAfterTitle = nil
SettingsNonSpamAfterBox = nil
SettingsDance2TimeTitle = nil
SettingsDance2TimeBox = nil
SettingsCwalkRangeTitle = nil
SettingsCwalkRangeBox = nil
MobileNormalWallhopRow = nil
MobileNoMoveWallhopRow = nil
Mobile360WallhopRow = nil
MobileConsoleWallhopRow = nil
MobileFlickTypesTitle = nil
MobileFlickSettingsTitle = nil
MobileNormalFlickRow = nil
MobileSpeedFlickRow = nil
MobileSlowFlickRow = nil
MobileBeastSlowRow = nil
MobileCornerWalkRow = nil
MobileXrayRow = nil
MobileRealXrayRow = nil
MobileDance2TurnRow = nil
MobileFloorbangEspRow = nil
MobileHideGuiRow = nil

mobileBeastSlowSwitch = nil
mobileBeastSlowKnob = nil
mobileCornerWalkSwitch = nil
mobileCornerWalkKnob = nil
mobileXraySwitch = nil
mobileXrayKnob = nil
mobileRealXraySwitch = nil
mobileRealXrayKnob = nil
mobileDance2TurnSwitch = nil
mobileDance2TurnKnob = nil
mobileFloorbangEspSwitch = nil
mobileFloorbangEspKnob = nil
mobileHideGuiSwitch = nil
mobileHideGuiKnob = nil
mobileDragHandle = nil

local dragConnections = {}
local shadowRegistry = {}

clearScriptSlowInstant = nil
updateMobilePanelButtons = nil
setMobileWallhopVisualHidden = nil
setMobileCornerWalkButtonVisible = nil
setMobileBeastSlowButtonVisible = nil
applyVisibility = nil
updateFlickButtons = nil
switchPcTab = nil
switchMobileTab = nil

isWallHopEnabled = false
isSlowEnabled = false
isCornerWalkEnabled = false
isXrayEnabled = false
realXrayEnabled = false
isDance2TurnEnabled = false
isFloorbangEspEnabled = false
floorbangEspMarkers = {}
FLOORBANG_HORIZONTAL_RANGE = 35
dance2TurnToken = 0
dance2NoclipActive = false
dance2NoclipOriginalCanCollide = {}
allowThirdPersonEnabled = true
xrayOpacityValue = 60
nonSpamValue = 50
nonSpamAfterValue = 0
dance2TimeValue = 10
cwalkRangeValue = 1
consecutiveWallhopCount = 0
isFlicking = false
lastFlickTime = 0

isWallHopping = false
lastWallHopTime = 0
WALLHOP_GRACE_TIME = 1.5
WALLHOP_COOLDOWN = 0

canDoubleJump = false
lastDoubleJump = 0
DOUBLE_JUMP_COOLDOWN = 3
blockDoubleJump = false

lastHitPosition = nil
MIN_HIT_DISTANCE = 0.1
lastFlickAngle = nil

airborneSource = nil
airborneStartY = nil
airborneStartTime = 0
jumpedRecently = false

LEDGE_BLOCK_DISTANCE = 6.0
LEDGE_BLOCK_TIME = 0.20

SLOW_DURATION = 0.8
SLOW_WALKSPEED = 9
DEFAULT_WALKSPEED = 16
slowToken = 0
scriptSlowActive = false

FIRST_FLICK_RESET_GROUND_TIME = 3
lastLandedTime = 0
hasWallhoppedSinceLanding = false
specialFirstFlickArmed = false

currentFlickMode = "Normal Wallhop"
currentFlickSetting = "Normal Flick"
next360Direction = 1

local function destroyOld()


local function playIntroSound()
	task.spawn(function()
		pcall(function()
			local soundGui = PlayerGui:FindFirstChild("WallhopIntroSoundGui")
			if soundGui then
				soundGui:Destroy()
			end

			soundGui = Instance.new("ScreenGui")
			soundGui.Name = "WallhopIntroSoundGui"
			soundGui.ResetOnSpawn = false
			soundGui.Parent = PlayerGui

			local sound = Instance.new("Sound")
			sound.Name = "WallhopIntroSound"
			sound.SoundId = "rbxassetid://9118823102"
			sound.Volume = 0
			sound.PlaybackSpeed = 1
			sound.Parent = soundGui

			sound:Play()

			local fadeIn = TweenService:Create(
				sound,
				TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Volume = 0.45}
			)
			fadeIn:Play()

			task.delay(1.6, function()
				if sound and sound.Parent then
					local fadeOut = TweenService:Create(
						sound,
						TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{Volume = 0}
					)
					fadeOut:Play()

					task.delay(0.4, function()
						if soundGui and soundGui.Parent then
							soundGui:Destroy()
						end
					end)
				end
			end)
		end)
	end)
end

playIntroSound()



pcall(function()
	local oldFloor = workspace:FindFirstChild("CornerWalkArtificialFloor")
	if oldFloor then
		oldFloor:Destroy()
	end
end)

	for _, name in ipairs({
		"AutoWallHopGui",
		"AutoWallHopGuiMobile",
		"WallhopModeSelector"
	}) do
		local old = PlayerGui:FindFirstChild(name)
		if old then
			old:Destroy()
		end
	end
end

destroyOld()

local function getKeyCodeFromName(name, fallback)
	if typeof(name) ~= "string" then
		return fallback
	end

	local ok, value = pcall(function()
		return Enum.KeyCode[name]
	end)

	if ok and value then
		return value
	end

	return fallback
end

local function savePCKeybinds()
	if not writefile then
		return
	end

	local payload = {
		hideGuiKey = hideGuiKey.Name,
		toggleScriptKey = toggleScriptKey.Name,
		toggleBeastSlowKey = toggleBeastSlowKey.Name,
		toggleCornerWalkKey = toggleCornerWalkKey.Name,
		toggleXrayKey = toggleXrayKey.Name,
		toggleNonSpamKey = toggleNonSpamKey.Name,
		toggleClipDance2Key = toggleClipDance2Key.Name,
		toggleFloorbangEspKey = toggleFloorbangEspKey.Name
	}

	pcall(function()
		writefile(KEYBINDS_FILE, HttpService:JSONEncode(payload))
	end)
end

local function loadPCKeybinds()
	if not readfile or not isfile then
		return
	end

	if not isfile(KEYBINDS_FILE) then
		return
	end

	pcall(function()
		local raw = readfile(KEYBINDS_FILE)
		local decoded = HttpService:JSONDecode(raw)

		hideGuiKey = getKeyCodeFromName(decoded.hideGuiKey, DEFAULT_HIDE_GUI_KEY)
		toggleScriptKey = getKeyCodeFromName(decoded.toggleScriptKey, DEFAULT_TOGGLE_SCRIPT_KEY)
		toggleBeastSlowKey = getKeyCodeFromName(decoded.toggleBeastSlowKey, DEFAULT_TOGGLE_BEAST_SLOW_KEY)
		toggleCornerWalkKey = getKeyCodeFromName(decoded.toggleCornerWalkKey, DEFAULT_TOGGLE_CORNER_WALK_KEY)
		toggleXrayKey = getKeyCodeFromName(decoded.toggleXrayKey, DEFAULT_TOGGLE_XRAY_KEY)
		toggleNonSpamKey = getKeyCodeFromName(decoded.toggleNonSpamKey, DEFAULT_TOGGLE_NON_SPAM_KEY)
		toggleClipDance2Key = getKeyCodeFromName(decoded.toggleClipDance2Key, DEFAULT_TOGGLE_CLIP_DANCE2_KEY)
		toggleFloorbangEspKey = getKeyCodeFromName(decoded.toggleFloorbangEspKey, DEFAULT_TOGGLE_FLOORBANG_ESP_KEY)
	end)
end

local function saveUserPreferences()
	if not writefile then
		return
	end

	local payload = {
		xrayOpacityValue = tonumber(xrayOpacityValue) or 60,
		nonSpamValue = tonumber(nonSpamValue) or 50,
		nonSpamAfterValue = tonumber(nonSpamAfterValue) or 0,
		dance2TimeValue = tonumber(dance2TimeValue) or 10,
		cwalkRangeValue = tonumber(cwalkRangeValue) or 1,
		currentFlickMode = tostring(currentFlickMode or "Normal Wallhop"),
		currentFlickSetting = tostring(currentFlickSetting or "Normal Flick"),
		isWallHopEnabled = isWallHopEnabled,
		isSlowEnabled = isSlowEnabled,
		isCornerWalkEnabled = isCornerWalkEnabled,
		isNonSpamEnabled = isXrayEnabled,
		realXrayEnabled = realXrayEnabled,
		isDance2TurnEnabled = isDance2TurnEnabled,
		isFloorbangEspEnabled = isFloorbangEspEnabled,
		mobileWallhopGuiHidden = mobileWallhopGuiHidden,
		mobileCornerWalkButtonVisible = mobileCornerWalkButtonVisible,
		mobileBeastSlowButtonVisible = mobileBeastSlowButtonVisible,
		mobileMenuOpen = mobileMenuOpen,
		guiVisible = guiVisible,
		guiMinimized = guiMinimized
	}

	pcall(function()
		writefile(PREFS_FILE, HttpService:JSONEncode(payload))
	end)
end

local function loadUserPreferences()
	if not readfile or not isfile or not isfile(PREFS_FILE) then
		return
	end

	pcall(function()
		local raw = readfile(PREFS_FILE)
		local decoded = HttpService:JSONDecode(raw)
		if tonumber(decoded.xrayOpacityValue) then
			xrayOpacityValue = math.clamp(math.floor(tonumber(decoded.xrayOpacityValue)), 0, 100)
		end
		if tonumber(decoded.nonSpamValue) then
			nonSpamValue = math.clamp(math.floor(tonumber(decoded.nonSpamValue)), 10, 99)
		end
		if tonumber(decoded.nonSpamAfterValue) then
			nonSpamAfterValue = math.clamp(math.floor(tonumber(decoded.nonSpamAfterValue)), 0, 10)
		end
		if tonumber(decoded.dance2TimeValue) then
			dance2TimeValue = math.clamp(math.floor(tonumber(decoded.dance2TimeValue)), 5, 20)
		end
		if tonumber(decoded.cwalkRangeValue) and setCwalkRangeValue then
			setCwalkRangeValue(decoded.cwalkRangeValue)
		end
		if type(decoded.currentFlickMode) == "string" and decoded.currentFlickMode ~= "" then
			currentFlickMode = decoded.currentFlickMode
		end
		if type(decoded.currentFlickSetting) == "string" and decoded.currentFlickSetting ~= "" then
			if decoded.currentFlickSetting == "Normal Flick" or decoded.currentFlickSetting == "Speed Flick" or decoded.currentFlickSetting == "Slow Flick" then
				currentFlickSetting = decoded.currentFlickSetting
			end
		end
		if type(decoded.isWallHopEnabled) == "boolean" then
			isWallHopEnabled = decoded.isWallHopEnabled
		end
		if type(decoded.isSlowEnabled) == "boolean" then
			isSlowEnabled = decoded.isSlowEnabled
		end
		if type(decoded.isCornerWalkEnabled) == "boolean" then
			isCornerWalkEnabled = decoded.isCornerWalkEnabled
		end
		if type(decoded.isNonSpamEnabled) == "boolean" then
			isXrayEnabled = decoded.isNonSpamEnabled
		end
		if type(decoded.realXrayEnabled) == "boolean" then
			realXrayEnabled = decoded.realXrayEnabled
		end
		if type(decoded.isDance2TurnEnabled) == "boolean" then
			isDance2TurnEnabled = decoded.isDance2TurnEnabled
		end
		if type(decoded.isFloorbangEspEnabled) == "boolean" then
			isFloorbangEspEnabled = decoded.isFloorbangEspEnabled
		end
		if type(decoded.mobileWallhopGuiHidden) == "boolean" then
			mobileWallhopGuiHidden = decoded.mobileWallhopGuiHidden
		end
		if type(decoded.mobileCornerWalkButtonVisible) == "boolean" then
			mobileCornerWalkButtonVisible = decoded.mobileCornerWalkButtonVisible
		end
		if type(decoded.mobileBeastSlowButtonVisible) == "boolean" then
			mobileBeastSlowButtonVisible = decoded.mobileBeastSlowButtonVisible
		end
		if type(decoded.mobileMenuOpen) == "boolean" then
			mobileMenuOpen = decoded.mobileMenuOpen
		end
		if type(decoded.guiVisible) == "boolean" then
			guiVisible = decoded.guiVisible
		end
		if type(decoded.guiMinimized) == "boolean" then
			guiMinimized = decoded.guiMinimized
		end
		applyCurrentNonSpamCooldown()
	end)
end


local function allowThirdPersonAccess()
	if not allowThirdPersonEnabled then
		return
	end

	pcall(function()
		if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
			LocalPlayer.CameraMode = Enum.CameraMode.Classic
		end
	end)
end

RunService.RenderStepped:Connect(function()
	if isThisScriptActive and not isThisScriptActive() then
		return
	end

	allowThirdPersonAccess()
end)

local xrayOriginalTransparency = {}
local xrayOriginalLocalTransparency = {}

local function shouldXrayPart(part)
	if not part or not part:IsA("BasePart") then
		return false
	end

	if part:IsDescendantOf(PlayerGui) then
		return false
	end

	local char = LocalPlayer.Character
	if char and part:IsDescendantOf(char) then
		return false
	end

	if part.Name == "HumanoidRootPart" then
		return false
	end

	if isPlayerCharacter and isPlayerCharacter(part) then
		return false
	end

	return part.CanCollide
end

local function applyXrayToPart(part)
	if not shouldXrayPart(part) then
		return
	end

	if xrayOriginalTransparency[part] == nil then
		xrayOriginalTransparency[part] = part.Transparency
	end
	if xrayOriginalLocalTransparency[part] == nil then
		xrayOriginalLocalTransparency[part] = part.LocalTransparencyModifier
	end

	pcall(function()
		xrayTransparencyTarget = math.clamp((tonumber(xrayOpacityValue) or 60) / 100, 0, 1)
		part.Transparency = math.max(part.Transparency, xrayTransparencyTarget)
		part.LocalTransparencyModifier = math.max(part.LocalTransparencyModifier, xrayTransparencyTarget)
	end)
end

local function restoreXrayPart(part)
	local originalTransparency = xrayOriginalTransparency[part]
	local originalLocalTransparency = xrayOriginalLocalTransparency[part]

	if part and part.Parent then
		pcall(function()
			if originalTransparency ~= nil then
				part.Transparency = originalTransparency
			end
			if originalLocalTransparency ~= nil then
				part.LocalTransparencyModifier = originalLocalTransparency
			end
		end)
	end

	xrayOriginalTransparency[part] = nil
	xrayOriginalLocalTransparency[part] = nil
end

local function applyXray()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			applyXrayToPart(obj)
		end
	end
end

local function clearXray()
	for part in pairs(xrayOriginalTransparency) do
		restoreXrayPart(part)
	end
	table.clear(xrayOriginalTransparency)
	table.clear(xrayOriginalLocalTransparency)
end

local function setXrayEnabled(state)
	realXrayEnabled = state and true or false

	if realXrayEnabled then
		applyXray()
	else
		clearXray()
	end

	updateMobilePanelButtons()
	saveUserPreferences()
end

local function removeFloorbangESP(player)
	local marker = floorbangEspMarkers[player]
	if marker then
		pcall(function()
			if typeof(marker) == "Instance" then
				marker:Destroy()
			elseif type(marker) == "table" then
				if marker.folder and marker.folder.Parent then
					marker.folder:Destroy()
				elseif marker.anchor and marker.anchor.Parent then
					marker.anchor:Destroy()
				end
			end
		end)
	end
	floorbangEspMarkers[player] = nil
end

local function purgeFloorbangESPOrphans()
	pcall(function()
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj.Name == "FloorbangESP3DRing" or obj.Name == "FloorbangESPAnchor" or obj.Name == "FloorbangESPMarker" then
				obj:Destroy()
			end
		end
	end)
end

local function clearFloorbangESP()
	for player in pairs(floorbangEspMarkers) do
		removeFloorbangESP(player)
	end
	table.clear(floorbangEspMarkers)
	purgeFloorbangESPOrphans()
end

local function isPlayerAboveLocalPlayer(character, hrp)
	local localChar = LocalPlayer.Character
	local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
	if not localHrp or not hrp then
		return false
	end

	local horizontalDelta = Vector3.new(
		hrp.Position.X - localHrp.Position.X,
		0,
		hrp.Position.Z - localHrp.Position.Z
	)

	if horizontalDelta.Magnitude > FLOORBANG_HORIZONTAL_RANGE then
		return false
	end

	local okTarget, targetBoxCFrame, targetBoxSize = pcall(function()
		return character:GetBoundingBox()
	end)

	local okLocal, localBoxCFrame, localBoxSize = pcall(function()
		return localChar:GetBoundingBox()
	end)

	local targetBottomY = hrp.Position.Y
	local localTopY = localHrp.Position.Y

	if okTarget and targetBoxCFrame and targetBoxSize then
		targetBottomY = targetBoxCFrame.Position.Y - (targetBoxSize.Y / 2)
	end

	if okLocal and localBoxCFrame and localBoxSize then
		localTopY = localBoxCFrame.Position.Y + (localBoxSize.Y / 2)
	end

	return targetBottomY > (localTopY + 0.25)
end

local function getFloorbangBasePosition(character, hrp)
	if not character or not hrp then
		return nil
	end

	local ok, boxCFrame, boxSize = pcall(function()
		return character:GetBoundingBox()
	end)

	if ok and boxCFrame and boxSize then
		return Vector3.new(hrp.Position.X, boxCFrame.Position.Y - (boxSize.Y / 2) - 0.045, hrp.Position.Z)
	end

	return hrp.Position - Vector3.new(0, 3.08, 0)
end

local function buildFloorbangRing(player)
	local folder = Instance.new("Folder")
	folder.Name = "FloorbangESP3DRing"
	folder.Parent = workspace

	local anchor = Instance.new("Part")
	anchor.Name = "FloorbangESPAnchor"
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanTouch = false
	anchor.CanQuery = false
	anchor.CastShadow = false
	anchor.Transparency = 1
	anchor.Size = Vector3.new(0.15, 0.15, 0.15)
	anchor.Parent = folder

	local parts = {}
	local segments = 180
	local radius = 1.66
	local thickness = 0.115
	local height = 0.085
	local segmentLength = ((math.pi * 2 * radius) / segments) * 1.42

	for i = 1, segments do
		local glow = Instance.new("BoxHandleAdornment")
		glow.Name = "Glow"
		glow.Adornee = anchor
		glow.AlwaysOnTop = true
		glow.ZIndex = 9
		glow.Color3 = Color3.fromRGB(255, 0, 0)
		glow.Transparency = 0.58
		glow.Size = Vector3.new(segmentLength * 1.02, height * 0.9, thickness * 3.2)
		glow.Parent = anchor

		local segment = Instance.new("BoxHandleAdornment")
		segment.Name = "Ring"
		segment.Adornee = anchor
		segment.AlwaysOnTop = true
		segment.ZIndex = 10
		segment.Color3 = Color3.fromRGB(255, 0, 0)
		segment.Transparency = 0.01
		segment.Size = Vector3.new(segmentLength, height, thickness)
		segment.Parent = anchor

		table.insert(parts, {segment = segment, glow = glow, angle = ((i - 1) / segments) * math.pi * 2})
	end

	folder:SetAttribute("Radius", radius)
	folder:SetAttribute("Segments", segments)

	return {
		folder = folder,
		anchor = anchor,
		parts = parts
	}
end

local function positionFloorbangRing(player)
	local marker = floorbangEspMarkers[player]
	if not marker then
		return
	end

	local character = player.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not character or not hrp or not humanoid or humanoid.Health <= 0 or not isPlayerAboveLocalPlayer(character, hrp) then
		removeFloorbangESP(player)
		return
	end

	local basePosition = getFloorbangBasePosition(character, hrp)
	if not basePosition then
		return
	end

	local anchor = marker.anchor
	if not anchor or not anchor.Parent then
		removeFloorbangESP(player)
		return
	end

	anchor.CFrame = CFrame.new(basePosition)

	local radius = marker.folder and marker.folder:GetAttribute("Radius") or 1.66

	for _, data in ipairs(marker.parts or {}) do
		local angle = data.angle
		local x = math.cos(angle) * radius
		local z = math.sin(angle) * radius
		local localCFrame = CFrame.new(x, 0, z) * CFrame.Angles(0, -angle, 0)

		if data.segment and data.segment.Parent then
			data.segment.CFrame = localCFrame
		end
		if data.glow and data.glow.Parent then
			data.glow.CFrame = localCFrame
		end
	end
end

local function createFloorbangESP(player)
	if not isFloorbangEspEnabled or not player or player == LocalPlayer then
		return
	end

	local character = player.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not hrp or not humanoid or humanoid.Health <= 0 or not isPlayerAboveLocalPlayer(character, hrp) then
		removeFloorbangESP(player)
		return
	end

	local old = floorbangEspMarkers[player]
	if old and old.folder and old.folder.Parent and old.anchor and old.anchor.Parent then
		positionFloorbangRing(player)
		return
	end

	removeFloorbangESP(player)

	local marker = buildFloorbangRing(player)
	floorbangEspMarkers[player] = marker
	positionFloorbangRing(player)
end

local function updateFloorbangESP()
	if not isFloorbangEspEnabled then
		clearFloorbangESP()
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			createFloorbangESP(player)
			positionFloorbangRing(player)
		end
	end

	for player in pairs(floorbangEspMarkers) do
		if not player or not player.Parent or player == LocalPlayer then
			removeFloorbangESP(player)
		else
			local character = player.Character
			local hrp = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not hrp or not humanoid or humanoid.Health <= 0 or not isPlayerAboveLocalPlayer(character, hrp) then
				removeFloorbangESP(player)
			end
		end
	end
end

local function setFloorbangESPEnabled(state)
	isFloorbangEspEnabled = state and true or false

	if isFloorbangEspEnabled then
		purgeFloorbangESPOrphans()
		updateFloorbangESP()
	else
		clearFloorbangESP()
	end

	updateMobilePanelButtons()
	saveUserPreferences()
end

Players.PlayerRemoving:Connect(function(player)
	removeFloorbangESP(player)
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.35)
		if isFloorbangEspEnabled then
			createFloorbangESP(player)
		end
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		player.CharacterAdded:Connect(function()
			task.wait(0.35)
			if isFloorbangEspEnabled then
				createFloorbangESP(player)
			end
		end)
	end
end

RunService.RenderStepped:Connect(function()
	if not isThisScriptActive or not isThisScriptActive() then
		clearFloorbangESP()
		return
	end

	if isFloorbangEspEnabled then
		updateFloorbangESP()
	end
end)

local function restoreDance2Noclip()
	for part, oldValue in pairs(dance2NoclipOriginalCanCollide) do
		if part and part.Parent then
			pcall(function()
				part.CanCollide = oldValue
			end)
		end
	end

	table.clear(dance2NoclipOriginalCanCollide)
	dance2NoclipActive = false
end

local function isDance2AnimationPlaying()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then
		return false
	end

	for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
		local trackName = tostring(track.Name or ""):lower()
		local anim = track.Animation
		local animName = anim and tostring(anim.Name or ""):lower() or ""
		local animId = anim and tostring(anim.AnimationId or "") or ""

		if track.IsPlaying and (
			trackName:find("dance", 1, true)
			or animName:find("dance", 1, true)
			or animId:find("182436842", 1, true)
			or animId:find("182436935", 1, true)
			or animId:find("507776043", 1, true)
			or animId:find("507776720", 1, true)
			or animId:find("507777268", 1, true)
		) then
			return true
		end
	end

	return false
end

local function startDance2Noclip(token)
	if token ~= dance2TurnToken or not isDance2TurnEnabled then
		return
	end

	if not isDance2AnimationPlaying() then
		return
	end

	restoreDance2Noclip()
	dance2NoclipActive = true

	local char = LocalPlayer.Character
	if not char then
		return
	end

	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") then
			dance2NoclipOriginalCanCollide[obj] = obj.CanCollide
			pcall(function()
				obj.CanCollide = false
			end)
		end
	end
end

local function runDance2TurnSequence()
	if not isDance2TurnEnabled then
		return
	end

	dance2TurnToken += 1
	local token = dance2TurnToken

	task.delay(0.6, function()
		startDance2Noclip(token)

		if token == dance2TurnToken and dance2NoclipActive then
			task.spawn(function()
				while token == dance2TurnToken and isDance2TurnEnabled and dance2NoclipActive do
					if not isDance2AnimationPlaying() then
						task.delay(getDance2TimeSeconds(), function()
							if token == dance2TurnToken and dance2NoclipActive and not isDance2AnimationPlaying() then
								restoreDance2Noclip()
							end
						end)
						break
					end

					task.wait(0.03)
				end
			end)
		end
	end)

	task.delay(1.2, function()
		if token == dance2TurnToken then
			restoreDance2Noclip()
		end
	end)
end

local function setDance2TurnEnabled(state)
	isDance2TurnEnabled = state and true or false

	if not isDance2TurnEnabled then
		dance2TurnToken += 1
		restoreDance2Noclip()
	end


	updateMobilePanelButtons()
	saveUserPreferences()
end

local function isDance2Command(message)
	local msg = tostring(message or ""):lower()
	msg = msg:gsub("^%s+", ""):gsub("%s+$", "")
	return msg == "/e dance2" or msg == "/emote dance2" or msg == "dance2"
end

LocalPlayer.Chatted:Connect(function(message)
	if isDance2Command(message) then
		runDance2TurnSequence()
	end
end)

pcall(function()
	TextChatService.SendingMessage:Connect(function(message)
		local text = message and (message.Text or message.TextSource or "")
		if isDance2Command(text) then
			runDance2TurnSequence()
		end
	end)
end)

workspace.DescendantAdded:Connect(function(obj)
	if not isThisScriptActive or not isThisScriptActive() then
		return
	end

	if realXrayEnabled and obj:IsA("BasePart") then
		task.defer(function()
			applyXrayToPart(obj)
		end)
	end
end)

local function noTextStroke(obj)
	obj.TextStrokeTransparency = 1
end

local function registerShadow(host, shadow)
	shadowRegistry[host] = shadowRegistry[host] or {}
	table.insert(shadowRegistry[host], shadow)
end

local function setHostShadowVisible(host, visible)
	local list = shadowRegistry[host]
	if not list then
		return
	end

	for _, shadow in ipairs(list) do
		shadow.Visible = visible
		shadow.BackgroundTransparency = visible and shadow:GetAttribute("BaseTransparency") or 1
	end
end

local function setTargetTransparency(obj, bg, text)
	if bg ~= nil then
		obj:SetAttribute("TargetBGTransparency", bg)
	end
	if text ~= nil then
		obj:SetAttribute("TargetTextTransparency", text)
	end
end

local function getTargetBG(obj)
	local v = obj:GetAttribute("TargetBGTransparency")
	if typeof(v) == "number" then
		return v
	end
	return obj.BackgroundTransparency
end

local function getTargetText(obj)
	local v = obj:GetAttribute("TargetTextTransparency")
	if typeof(v) == "number" then
		return v
	end
	return obj.TextTransparency
end

local function addTrueRoundedShadow(parent, cornerRadius, strength, shadowColor)
	strength = strength or 1
	shadowColor = shadowColor or Color3.fromRGB(0, 0, 0)

	local layers = {
		{grow = math.floor(8 * strength), transparency = 0.82, y = 2},
		{grow = math.floor(16 * strength), transparency = 0.90, y = 4},
		{grow = math.floor(24 * strength), transparency = 0.95, y = 6},
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
		shadow.ZIndex = math.max(parent.ZIndex - 1, 0)
		shadow.Parent = parent
		shadow:SetAttribute("BaseTransparency", cfg.transparency)

		Instance.new("UICorner", shadow).CornerRadius =
			UDim.new(0, cornerRadius + math.floor(cfg.grow / 2.1))

		registerShadow(parent, shadow)
	end
end

local function elegantShow(root, finalSize, finalPosition, finalBgTransparency)
	if not root then
		return
	end

	root.Visible = true

	local targetSize = finalSize or root.Size
	local targetPos = finalPosition or root.Position
	local targetBg = finalBgTransparency
	if targetBg == nil then
		targetBg = getTargetBG(root)
	end

	root.Size = UDim2.new(
		targetSize.X.Scale * 0.72, math.floor(targetSize.X.Offset * 0.72),
		targetSize.Y.Scale * 0.72, math.floor(targetSize.Y.Offset * 0.72)
	)
	root.Position = targetPos
	root.BackgroundTransparency = 1
	setHostShadowVisible(root, false)

	for _, obj in ipairs(root:GetDescendants()) do
		if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("TextLabel") then
			pcall(function()
				obj.BackgroundTransparency = 1
			end)
		end
		if obj:IsA("TextButton") or obj:IsA("TextLabel") then
			pcall(function()
				obj.TextTransparency = 1
			end)
		end
		if obj:IsA("UIStroke") then
			pcall(function()
				obj.Transparency = 1
			end)
		end
	end

	TweenService:Create(root, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = targetSize,
		Position = targetPos,
		BackgroundTransparency = targetBg
	}):Play()

	task.delay(0.03, function()
		setHostShadowVisible(root, true)

		for _, obj in ipairs(root:GetDescendants()) do
			if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("TextLabel") then
				local goal = {}
				if obj:IsA("Frame") or obj:IsA("TextButton") then
					goal.BackgroundTransparency = getTargetBG(obj)
				end
				if obj:IsA("TextButton") or obj:IsA("TextLabel") then
					goal.TextTransparency = getTargetText(obj)
				end
				TweenService:Create(obj, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
			elseif obj:IsA("UIStroke") then
				TweenService:Create(obj, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 0
				}):Play()
			end
		end
	end)
end

local function elegantHide(root, onDone)
	if not root then
		if onDone then
			onDone()
		end
		return
	end

	local currentSize = root.Size
	local currentPos = root.Position
	local shrinkSize = UDim2.new(
		currentSize.X.Scale * 0.965, math.floor(currentSize.X.Offset * 0.965),
		currentSize.Y.Scale * 0.965, math.floor(currentSize.Y.Offset * 0.965)
	)

	local liftPos = UDim2.new(
		currentPos.X.Scale, currentPos.X.Offset,
		currentPos.Y.Scale, currentPos.Y.Offset + 4
	)

	for _, obj in ipairs(root:GetDescendants()) do
		if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("TextLabel") then
			local goal = {}

			if obj:IsA("Frame") or obj:IsA("TextButton") then
				goal.BackgroundTransparency = 1
			end

			if obj:IsA("TextButton") or obj:IsA("TextLabel") then
				goal.TextTransparency = 1
			end

			TweenService:Create(
				obj,
				TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
				goal
			):Play()
		elseif obj:IsA("UIStroke") then
			TweenService:Create(
				obj,
				TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
				{Transparency = 1}
			):Play()
		end
	end

	setHostShadowVisible(root, false)

	local tween = TweenService:Create(
		root,
		TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
		{
			Size = shrinkSize,
			Position = liftPos,
			BackgroundTransparency = 1
		}
	)

	tween:Play()
	tween.Completed:Connect(function()
		root.Visible = false
		root.Size = currentSize
		root.Position = currentPos

		if onDone then
			onDone()
		end
	end)
end

local activeNoticeId = 0
local function showNotice(text)
	if selectedMode ~= "PC" or not Notice or not NoticeStroke or not NoticeBar then
		return
	end

	activeNoticeId += 1
	local myId = activeNoticeId
	local msg = tostring(text or "")
	local noticeWidth = math.clamp(210 + (#msg * 4), 230, 460)

	Notice.Size = UDim2.new(0, noticeWidth, 0, 30)
	Notice.Text = msg
	Notice.Visible = true
	Notice.Position = UDim2.new(1, noticeWidth + 20, 0, 14)
	Notice.BackgroundTransparency = 1
	Notice.TextTransparency = 1
	NoticeStroke.Transparency = 1
	NoticeBar.BackgroundTransparency = 0
	NoticeBar.Size = UDim2.new(1, -12, 0, 2)
	NoticeBar.Position = UDim2.new(0, 6, 1, -4)

	TweenService:Create(Notice, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.08,
		TextTransparency = 0,
		Position = UDim2.new(1, -14, 0, 14)
	}):Play()

	TweenService:Create(NoticeStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 0.9
	}):Play()

	TweenService:Create(NoticeBar, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 0, 2),
		Position = UDim2.new(1, -6, 1, -4)
	}):Play()

	task.delay(2, function()
		if myId ~= activeNoticeId then
			return
		end

		TweenService:Create(Notice, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			BackgroundTransparency = 1,
			TextTransparency = 1,
			Position = UDim2.new(1, noticeWidth + 20, 0, 14)
		}):Play()

		TweenService:Create(NoticeStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Transparency = 1
		}):Play()

		TweenService:Create(NoticeBar, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			BackgroundTransparency = 1
		}):Play()

		task.delay(0.25, function()
			if myId == activeNoticeId then
				Notice.Visible = false
			end
		end)
	end)
end

local function canUseMobileTap(obj)
	local lastDragTime = obj:GetAttribute("LastDragTime")
	if typeof(lastDragTime) == "number" then
		return (tick() - lastDragTime) > 0.12
	end
	return true
end

local function bindRowPress(button, callback)
	local activeInput = nil
	local startPos = nil
	local moved = false
	local lastTap = 0

	button.Active = true
	button.Selectable = false
	button.AutoButtonColor = false

	local function fire()
		local now = tick()
		if now - lastTap < 0.08 then
			return
		end
		lastTap = now
		callback()
	end

	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			activeInput = input
			startPos = input.Position
			moved = false
		end
	end)

	button.InputChanged:Connect(function(input)
		if input == activeInput and startPos then
			local delta = input.Position - startPos
			if delta.Magnitude > 8 then
				moved = true
			end
		end
	end)

	button.InputEnded:Connect(function(input)
		if input == activeInput then
			local wasMoved = moved
			activeInput = nil
			startPos = nil
			moved = false

			if not wasMoved and canUseMobileTap(button) then
				fire()
			end
		end
	end)

	if button:IsA("GuiButton") then
		button.Activated:Connect(function()
			if canUseMobileTap(button) then
				fire()
			end
		end)
	end
end


local function updateSwitchVisual(switchFrame, knob, enabled)
	if not switchFrame or not knob then
		return
	end

	local offPos = UDim2.new(0, 3, 0.5, -13)
	local onPos = UDim2.new(1, -29, 0.5, -13)

	TweenService:Create(switchFrame, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = enabled and Color3.fromRGB(190,190,190) or Color3.fromRGB(20,20,24)
	}):Play()

	TweenService:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = enabled and onPos or offPos,
		BackgroundColor3 = enabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)
	}):Play()
end

local function createSwitchRow(parent, yOffset, labelText)
	local row = Instance.new("TextButton")
	row.Size = UDim2.new(1, -14, 0, 40)
	row.Position = UDim2.new(0, 7, 0, yOffset)
	row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	row.AutoButtonColor = false
	row.Text = ""
	row.BorderSizePixel = 0
	row.Parent = parent
	row.ZIndex = 5
	row.Active = true
	row.Selectable = false
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
	setTargetTransparency(row, 0, 1)

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(0, 130, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 15
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	label.ZIndex = 6
	label.Active = false
	noTextStroke(label)
	setTargetTransparency(label, 1, 0)

	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0, 54, 0, 28)
	switch.Position = UDim2.new(1, -94, 0.5, -14)
	switch.BackgroundColor3 = Color3.fromRGB(20,20,24)
	switch.BorderSizePixel = 0
	switch.Parent = row
	switch.ZIndex = 6
	switch.Active = false
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
	setTargetTransparency(switch, 0, nil)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 26, 0, 26)
	knob.Position = UDim2.new(0, 3, 0.5, -13)
	knob.BackgroundColor3 = Color3.fromRGB(0,0,0)
	knob.BorderSizePixel = 0
	knob.Parent = switch
	knob.ZIndex = 7
	knob.Active = false
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
	setTargetTransparency(knob, 0, nil)

	local switchHitbox = Instance.new("TextButton")
	switchHitbox.Name = "SwitchHitbox"
	switchHitbox.Size = UDim2.new(0, 68, 0, 38)
	switchHitbox.Position = UDim2.new(1, -101, 0.5, -19)
	switchHitbox.BackgroundTransparency = 1
	switchHitbox.Text = ""
	switchHitbox.AutoButtonColor = false
	switchHitbox.BorderSizePixel = 0
	switchHitbox.ZIndex = 20
	switchHitbox.Parent = row
	switchHitbox.Active = true
	switchHitbox.Selectable = false

	return row, switch, knob
end

local function createSimpleRow(parent, yOffset, labelText)
	local row = Instance.new("TextButton")
	row.Size = UDim2.new(1, -14, 0, 40)
	row.Position = UDim2.new(0, 7, 0, yOffset)
	row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	row.AutoButtonColor = false
	row.Text = ""
	row.BorderSizePixel = 0
	row.Parent = parent
	row.ZIndex = 5
	row.Active = true
	row.Selectable = false
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
	setTargetTransparency(row, 0, 1)

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -24, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.Parent = row
	label.ZIndex = 6
	label.Active = false
	noTextStroke(label)
	setTargetTransparency(label, 1, 0)

	return row
end

local function updateToggleButton()
	if selectedMode == "PC" and ToggleButton then
		ToggleButton.Text = isWallHopEnabled and "Wall Hop On" or "Wall Hop Off"
	elseif selectedMode == "Mobile" then
		if MobileButton then
			MobileButton.Text = isWallHopEnabled and "Wallhop On" or "Wallhop Off"
		end
		if MobileCornerWalkButton then
			MobileCornerWalkButton.Text = isCornerWalkEnabled and "C-walk On" or "C-walk Off"
		end
		if MobileBeastSlowButton then
			MobileBeastSlowButton.Text = isSlowEnabled and "Slow On" or "Slow Off"
		end
	end
end

setMobileWallhopVisualHidden = function(hidden)
	if not MobileButton then
		return
	end
	MobileButton.BackgroundTransparency = hidden and 1 or 0
	MobileButton.TextTransparency = hidden and 1 or 0
	setHostShadowVisible(MobileButton, not hidden)
end

setMobileCornerWalkButtonVisible = function(visible)
	if not MobileCornerWalkButton then
		return
	end

	MobileCornerWalkButton.Visible = visible
	MobileCornerWalkButton.BackgroundTransparency = visible and 0 or 1
	MobileCornerWalkButton.TextTransparency = visible and 0 or 1
	setHostShadowVisible(MobileCornerWalkButton, visible)
end

setMobileBeastSlowButtonVisible = function(visible)
	if not MobileBeastSlowButton then
		return
	end

	MobileBeastSlowButton.Visible = visible
	MobileBeastSlowButton.BackgroundTransparency = visible and 0 or 1
	MobileBeastSlowButton.TextTransparency = visible and 0 or 1
	setHostShadowVisible(MobileBeastSlowButton, visible)
end

function setFlickSetting(settingName)
	if settingName ~= "Normal Flick" and settingName ~= "Speed Flick" and settingName ~= "Slow Flick" then
		settingName = "Normal Flick"
	end

	currentFlickSetting = settingName
	updateFlickButtons()
	saveUserPreferences()
end

updateFlickButtons = function()
	if PcCurrentUsingLabel then
		PcCurrentUsingLabel.Text = "Currently config: " .. currentFlickMode .. ", " .. currentFlickSetting
	end

	if MobileCurrentUsingLabel then
		MobileCurrentUsingLabel.Text = "Currently config: " .. currentFlickMode .. ", " .. currentFlickSetting
	end

	if PcNormalWallhopButton then
		PcNormalWallhopButton.BackgroundColor3 =
			currentFlickMode == "Normal Wallhop" and Color3.fromRGB(20,20,20) or Color3.fromRGB(6,6,6)
	end
	if PcNoMoveWallhopButton then
		PcNoMoveWallhopButton.BackgroundColor3 =
			currentFlickMode == "Visual Wallhop" and Color3.fromRGB(20,20,20) or Color3.fromRGB(6,6,6)
	end
	if Pc360WallhopButton then
		Pc360WallhopButton.BackgroundColor3 =
			currentFlickMode == "360° Wallhop" and Color3.fromRGB(20,20,20) or Color3.fromRGB(6,6,6)
	end
	if PcConsoleWallhopButton then
		PcConsoleWallhopButton.BackgroundColor3 =
			currentFlickMode == "Console Wallhop" and Color3.fromRGB(20,20,20) or Color3.fromRGB(6,6,6)
	end
	if MobileNormalWallhopRow then
		MobileNormalWallhopRow.BackgroundColor3 =
			currentFlickMode == "Normal Wallhop" and Color3.fromRGB(20,20,20) or Color3.fromRGB(0,0,0)
	end
	if MobileNoMoveWallhopRow then
		MobileNoMoveWallhopRow.BackgroundColor3 =
			currentFlickMode == "Visual Wallhop" and Color3.fromRGB(20,20,20) or Color3.fromRGB(0,0,0)
	end
	if Mobile360WallhopRow then
		Mobile360WallhopRow.BackgroundColor3 =
			currentFlickMode == "360° Wallhop" and Color3.fromRGB(20,20,20) or Color3.fromRGB(0,0,0)
	end
	if MobileConsoleWallhopRow then
		MobileConsoleWallhopRow.BackgroundColor3 =
			currentFlickMode == "Console Wallhop" and Color3.fromRGB(20,20,20) or Color3.fromRGB(0,0,0)
	end
	if PcNormalFlickButton then
		PcNormalFlickButton.BackgroundColor3 = currentFlickSetting == "Normal Flick" and Color3.fromRGB(20,20,20) or Color3.fromRGB(6,6,6)
	end
	if PcSpeedFlickButton then
		PcSpeedFlickButton.BackgroundColor3 = currentFlickSetting == "Speed Flick" and Color3.fromRGB(20,20,20) or Color3.fromRGB(6,6,6)
	end
	if PcSlowFlickButton then
		PcSlowFlickButton.BackgroundColor3 = currentFlickSetting == "Slow Flick" and Color3.fromRGB(20,20,20) or Color3.fromRGB(6,6,6)
	end
	if MobileNormalFlickRow then
		MobileNormalFlickRow.BackgroundColor3 = currentFlickSetting == "Normal Flick" and Color3.fromRGB(20,20,20) or Color3.fromRGB(0,0,0)
	end
	if MobileSpeedFlickRow then
		MobileSpeedFlickRow.BackgroundColor3 = currentFlickSetting == "Speed Flick" and Color3.fromRGB(20,20,20) or Color3.fromRGB(0,0,0)
	end
	if MobileSlowFlickRow then
		MobileSlowFlickRow.BackgroundColor3 = currentFlickSetting == "Slow Flick" and Color3.fromRGB(20,20,20) or Color3.fromRGB(0,0,0)
	end
end

updateMobilePanelButtons = function()
	if MobileHideGuiRow and MobileHideGuiRow:FindFirstChild("Label") then
		MobileHideGuiRow.Label.Text = "Wallhop"
	end
	if MobileCornerWalkRow and MobileCornerWalkRow:FindFirstChild("Label") then
		MobileCornerWalkRow.Label.Text = "Corner Walk"
	end
	if MobileXrayRow and MobileXrayRow:FindFirstChild("Label") then
		MobileXrayRow.Label.Text = "Non-spam"
	end
	if MobileRealXrayRow and MobileRealXrayRow:FindFirstChild("Label") then
		MobileRealXrayRow.Label.Text = "X-ray"
	end
	if MobileDance2TurnRow and MobileDance2TurnRow:FindFirstChild("Label") then
		MobileDance2TurnRow.Label.Text = "Clip Dance2"
	end
	if MobileFloorbangEspRow and MobileFloorbangEspRow:FindFirstChild("Label") then
		MobileFloorbangEspRow.Label.Text = "Floorbang ESP"
	end
	if MobileBeastSlowRow and MobileBeastSlowRow:FindFirstChild("Label") then
		MobileBeastSlowRow.Label.Text = "Beast Slow"
	end
	if MobileNormalWallhopRow and MobileNormalWallhopRow:FindFirstChild("Label") then
		MobileNormalWallhopRow.Label.Text = "Normal Wallhop"
	end
	if MobileNoMoveWallhopRow and MobileNoMoveWallhopRow:FindFirstChild("Label") then
		MobileNoMoveWallhopRow.Label.Text = "Visual Wallhop"
	end
	if Mobile360WallhopRow and Mobile360WallhopRow:FindFirstChild("Label") then
		Mobile360WallhopRow.Label.Text = "360° Wallhop"
	end
	if MobileConsoleWallhopRow and MobileConsoleWallhopRow:FindFirstChild("Label") then
		MobileConsoleWallhopRow.Label.Text = "Console Wallhop"
	end

	updateSwitchVisual(mobileHideGuiSwitch, mobileHideGuiKnob, not mobileWallhopGuiHidden)
	updateSwitchVisual(mobileCornerWalkSwitch, mobileCornerWalkKnob, mobileCornerWalkButtonVisible)
	updateSwitchVisual(mobileXraySwitch, mobileXrayKnob, isXrayEnabled)
	updateSwitchVisual(mobileRealXraySwitch, mobileRealXrayKnob, realXrayEnabled)
	updateSwitchVisual(mobileDance2TurnSwitch, mobileDance2TurnKnob, isDance2TurnEnabled)
	updateSwitchVisual(mobileFloorbangEspSwitch, mobileFloorbangEspKnob, isFloorbangEspEnabled)
	updateSwitchVisual(mobileBeastSlowSwitch, mobileBeastSlowKnob, mobileBeastSlowButtonVisible)

	setMobileWallhopVisualHidden(mobileWallhopGuiHidden)
	setMobileCornerWalkButtonVisible(mobileCornerWalkButtonVisible)
	setMobileBeastSlowButtonVisible(mobileBeastSlowButtonVisible)
	updateToggleButton()
	updateFlickButtons()
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
	if XrayBindButton then
		XrayBindButton.Text = waitingForNonSpamKey and "Press any key..." or ("Keybind Toggle Non-spam: " .. toggleNonSpamKey.Name)
	end
	if CornerWalkBindButton then
		CornerWalkBindButton.Text = waitingForCornerWalkKey and "Press any key..." or ("Keybind Toggle Corner Walk: " .. toggleCornerWalkKey.Name)
	end
	if BeastSlowBindButton then
		BeastSlowBindButton.Text = waitingForBeastSlowKey and "Press any key..." or ("Keybind Toggle Beast Slow: " .. toggleBeastSlowKey.Name)
	end
	if RealXrayBindButton then
		RealXrayBindButton.Text = waitingForXrayKey and "Press any key..." or ("Keybind Toggle X-ray: " .. toggleXrayKey.Name)
	end
	if ClipDance2BindButton then
		ClipDance2BindButton.Text = waitingForClipDance2Key and "Press any key..." or ("Keybind Toggle Clip Dance2: " .. toggleClipDance2Key.Name)
	end
	if FloorbangEspBindButton then
		FloorbangEspBindButton.Text = waitingForFloorbangEspKey and "Press any key..." or ("Keybind Toggle Floorbang ESP: " .. toggleFloorbangEspKey.Name)
	end
end

applyVisibility = function()
	if selectedMode == "PC" then
		if MainFrame then
			MainFrame.Visible = guiVisible and not guiMinimized
			setHostShadowVisible(MainFrame, guiVisible and not guiMinimized)
		end
		if MiniButton then
			MiniButton.Visible = guiVisible and guiMinimized
			setHostShadowVisible(MiniButton, guiVisible and guiMinimized)
		end
	elseif selectedMode == "Mobile" then
		if MobileButton then
			MobileButton.Visible = guiVisible and not mobileWallhopGuiHidden
		end
		if MobileCornerWalkButton then
			MobileCornerWalkButton.Visible = guiVisible and mobileCornerWalkButtonVisible
		end
		if MobileBeastSlowButton then
			MobileBeastSlowButton.Visible = guiVisible and mobileBeastSlowButtonVisible
		end
		if MobileMenuButton then
			MobileMenuButton.Visible = true
		end
		if MobilePanel then
			MobilePanel.Visible = mobileMenuOpen
			setHostShadowVisible(MobilePanel, mobileMenuOpen)
		end
		setMobileWallhopVisualHidden(mobileWallhopGuiHidden)
		setMobileCornerWalkButtonVisible(guiVisible and mobileCornerWalkButtonVisible)
		setMobileBeastSlowButtonVisible(guiVisible and mobileBeastSlowButtonVisible)
	end
end

local function setGuiVisible(state)
	guiVisible = state
	applyVisibility()
	showNotice(state and "GUI shown" or "GUI hidden")
end

local function setFlickMode(name)
	currentFlickMode = name
	updateFlickButtons()
	saveUserPreferences()
	if selectedMode == "PC" then
		showNotice("Using " .. name)
	end
end

local function createModeSelector(onPick)
	local selectorGui = Instance.new("ScreenGui")
	selectorGui.Name = "WallhopModeSelector"
	selectorGui.ResetOnSpawn = false
	selectorGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	selectorGui.Parent = PlayerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 320, 0, 170)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.Parent = selectorGui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
	addTrueRoundedShadow(frame, 16, 1.45, Color3.fromRGB(0, 0, 0))
	setTargetTransparency(frame, 0, nil)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -92, 0, 28)
	title.Position = UDim2.new(0, 18, 0, 14)
	title.BackgroundTransparency = 1
	title.Text = "Choose Version"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.Parent = frame
	noTextStroke(title)
	setTargetTransparency(title, 1, 0)


	local sub = Instance.new("TextLabel")
	sub.Size = UDim2.new(1, -92, 0, 16)
	sub.Position = UDim2.new(0, 46, 0, 42)
	sub.BackgroundTransparency = 1
	sub.Text = "Cerber X • the best Flee the Facility script"
	sub.TextColor3 = Color3.fromRGB(95,95,95)
	sub.Font = Enum.Font.Gotham
	sub.TextSize = 12
	sub.Parent = frame
	noTextStroke(sub)
	setTargetTransparency(sub, 1, 0)

	local selectorIcon = Instance.new("ImageLabel")
	selectorIcon.Size = UDim2.new(0, 56, 0, 56)
	selectorIcon.Position = UDim2.new(0, 18, 0, 10)
	selectorIcon.BackgroundTransparency = 1
	selectorIcon.Image = CERBER_ICON_IMAGE
	selectorIcon.ScaleType = Enum.ScaleType.Fit
	selectorIcon.Parent = frame
	setTargetTransparency(selectorIcon, 1, 0)

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
	setTargetTransparency(pcButton, 0, 0)

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
	setTargetTransparency(mobileButton, 0, 0)

	elegantShow(frame, UDim2.new(0, 336, 0, 170), UDim2.new(0.5, 0, 0.5, 0), 0)

	pcButton.MouseButton1Click:Connect(function()
		elegantHide(frame, function()
			selectorGui:Destroy()
			onPick("PC")
		end)
	end)

	mobileButton.MouseButton1Click:Connect(function()
		elegantHide(frame, function()
			selectorGui:Destroy()
			onPick("Mobile")
		end)
	end)
end

local function clearOldDragConnections()
	for _, c in ipairs(dragConnections) do
		if c and c.Disconnect then
			c:Disconnect()
		end
	end
	table.clear(dragConnections)
end

local function bindFreeDrag(handle, target, onMove, holdTime)
	local activeInput = nil
	local dragStart = nil
	local startPos = nil
	local holdSatisfied = false
	local holdCanceled = false
	local holdId = 0

	holdTime = holdTime or 0

	table.insert(dragConnections, handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			activeInput = input
			dragStart = input.Position
			startPos = target.Position
			holdSatisfied = false
			holdCanceled = false
			holdId += 1

			local myHoldId = holdId

			if holdTime <= 0 then
				holdSatisfied = true
			else
				task.delay(holdTime, function()
					if activeInput == input and not holdCanceled and holdId == myHoldId then
						holdSatisfied = true
						handle:SetAttribute("LastDragTime", tick())
					end
				end)
			end
		end
	end))

	table.insert(dragConnections, UserInputService.InputChanged:Connect(function(input)
		if input == activeInput and dragStart and startPos then
			local delta = input.Position - dragStart

			if not holdSatisfied then
				if delta.Magnitude >= 8 then
					holdCanceled = true
				end
				return
			end

			if delta.Magnitude >= 6 then
				handle:SetAttribute("LastDragTime", tick())
			end

			target.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)

			if onMove then
				onMove(delta)
			end
		end
	end))

	table.insert(dragConnections, UserInputService.InputEnded:Connect(function(input)
		if input == activeInput then
			activeInput = nil
			dragStart = nil
			startPos = nil
			holdSatisfied = false
			holdCanceled = false
			holdId += 1
		end
	end))
end

switchPcTab = function(name)
	if not PcFunctionsPage or not PcFlicksPage or not PcSettingsPage or not PcTabFunctions or not PcTabFlicks or not PcTabSettings then
		return
	end

	local isFunctions = name == "Functions"
	local isFlicks = name == "Flicks"
	local isSettings = name == "Settings"

	PcFunctionsPage.Visible = isFunctions
	PcFlicksPage.Visible = isFlicks
	PcSettingsPage.Visible = isSettings

	if ToggleButton then
		ToggleButton.Visible = isFunctions
	end

	if isFunctions and PcFunctionsPage:IsA("ScrollingFrame") then
		PcFunctionsPage.CanvasPosition = Vector2.new(0, 0)
	end
	if isFlicks and PcFlicksPage:IsA("ScrollingFrame") then
		PcFlicksPage.CanvasPosition = Vector2.new(0, 0)
	end
	if isSettings and PcSettingsPage:IsA("ScrollingFrame") then
		PcSettingsPage.CanvasPosition = Vector2.new(0, 0)
	end

	PcTabFunctions.BackgroundColor3 = isFunctions and Color3.fromRGB(20,20,20) or Color3.fromRGB(8,8,8)
	PcTabFlicks.BackgroundColor3 = isFlicks and Color3.fromRGB(20,20,20) or Color3.fromRGB(8,8,8)
	PcTabSettings.BackgroundColor3 = isSettings and Color3.fromRGB(20,20,20) or Color3.fromRGB(8,8,8)

	if isSettings then
		updateSettingsInputs()
	end

	if MainFrame and MainFrame:FindFirstChild("PcFooter") then
		MainFrame.PcFooter.Visible = false
	end
end

switchMobileTab = function(name)
	if not MobileFunctionsPage or not MobileFlicksPage or not MobileSettingsPage or not MobileTabFunctions or not MobileTabFlicks or not MobileTabSettings then
		return
	end

	mobileIsFunctions = name == "Functions"
	mobileIsFlicks = name == "Flicks"
	mobileIsSettings = name == "Settings"

	MobileFunctionsPage.Visible = mobileIsFunctions
	MobileFlicksPage.Visible = mobileIsFlicks
	MobileSettingsPage.Visible = mobileIsSettings

	if mobileIsFunctions and MobileFunctionsPage:IsA("ScrollingFrame") then
		MobileFunctionsPage.CanvasPosition = Vector2.new(0, 0)
	end
	if mobileIsFlicks and MobileFlicksPage:IsA("ScrollingFrame") then
		MobileFlicksPage.CanvasPosition = Vector2.new(0, 0)
	end
	if mobileIsSettings and MobileSettingsPage:IsA("ScrollingFrame") then
		MobileSettingsPage.CanvasPosition = Vector2.new(0, 0)
	end

	MobileTabFunctions.BackgroundColor3 = mobileIsFunctions and Color3.fromRGB(20,20,20) or Color3.fromRGB(8,8,8)
	MobileTabFlicks.BackgroundColor3 = mobileIsFlicks and Color3.fromRGB(20,20,20) or Color3.fromRGB(8,8,8)
	MobileTabSettings.BackgroundColor3 = mobileIsSettings and Color3.fromRGB(20,20,20) or Color3.fromRGB(8,8,8)

	if mobileIsSettings then
		updateSettingsInputs()
	end

	if MobilePanel and MobilePanel:FindFirstChild("MobileFooter") then
		MobilePanel.MobileFooter.Visible = false
	end
end

local function setSlowEnabled(state)
	isSlowEnabled = state and true or false

	if not isSlowEnabled then
		clearScriptSlowInstant()
	end

	updateMobilePanelButtons()
	saveUserPreferences()
end

local function setCornerWalkEnabled(state)
	isCornerWalkEnabled = state and true or false
	updateMobilePanelButtons()
	saveUserPreferences()
end


local function setMobileGuiHidden(state)
	mobileWallhopGuiHidden = state and true or false
	updateMobilePanelButtons()
	saveUserPreferences()
end

local function setMobileCornerWalkButtonState(state)
	mobileCornerWalkButtonVisible = state and true or false
	updateMobilePanelButtons()
	saveUserPreferences()
end

local function setMobileBeastSlowButtonState(state)
	mobileBeastSlowButtonVisible = state and true or false
	updateMobilePanelButtons()
	saveUserPreferences()
end


function showSettingsNotice(message)
	if not ScreenGui then
		return
	end

	SettingsNoticeId = (SettingsNoticeId or 0) + 1
	local thisNoticeId = SettingsNoticeId

	local oldFrame = SettingsNoticeFrame
	if oldFrame and oldFrame.Parent then
		SettingsNoticeFrame = nil
		pcall(function()
			TweenService:Create(oldFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1,
				Position = UDim2.new(1, oldFrame.AbsoluteSize.X + 20, 0, oldFrame.Position.Y.Offset)
			}):Play()

			for _, child in ipairs(oldFrame:GetDescendants()) do
				if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
					TweenService:Create(child, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
				elseif child:IsA("Frame") then
					TweenService:Create(child, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
				elseif child:IsA("UIStroke") then
					TweenService:Create(child, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1}):Play()
				end
			end
		end)
		task.delay(0.09, function()
			if oldFrame and oldFrame.Parent then
				oldFrame:Destroy()
			end
		end)
	end

	local msg = tostring(message)
	local longMsg = #msg > 38
	local noticeHeight = longMsg and 48 or 30
	local noticeWidth = longMsg and 330 or 230

	local currentFrame = Instance.new("Frame")
	currentFrame.Size = UDim2.new(0, noticeWidth, 0, noticeHeight)
	currentFrame.Position = UDim2.new(1, noticeWidth + 20, 0, 14)
	currentFrame.AnchorPoint = Vector2.new(1, 0)
	currentFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	currentFrame.BackgroundTransparency = 1
	currentFrame.BorderSizePixel = 0
	currentFrame.ZIndex = 90
	currentFrame.Parent = ScreenGui
	SettingsNoticeFrame = currentFrame
	Instance.new("UICorner", currentFrame).CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255,255,255)
	stroke.Thickness = 1
	stroke.Transparency = 1
	stroke.Parent = currentFrame

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -14, 1, -10)
	textLabel.Position = UDim2.new(0, 7, 0, 3)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = msg
	textLabel.TextColor3 = Color3.fromRGB(255,255,255)
	textLabel.TextTransparency = 1
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = longMsg and 10 or 11
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.ZIndex = 91
	textLabel.Parent = currentFrame
	noTextStroke(textLabel)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -12, 0, 2)
	bar.Position = UDim2.new(0, 6, 1, -4)
	bar.BackgroundColor3 = Color3.fromRGB(255,255,255)
	bar.BackgroundTransparency = 0
	bar.BorderSizePixel = 0
	bar.ZIndex = 91
	bar.Parent = currentFrame
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	TweenService:Create(currentFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.08,
		Position = UDim2.new(1, -14, 0, 14)
	}):Play()
	TweenService:Create(textLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.9}):Play()
	TweenService:Create(bar, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 0, 2),
		Position = UDim2.new(1, -6, 1, -4)
	}):Play()

	task.delay(2, function()
		if thisNoticeId ~= SettingsNoticeId or SettingsNoticeFrame ~= currentFrame then
			return
		end

		if currentFrame and currentFrame.Parent then
			TweenService:Create(currentFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				BackgroundTransparency = 1,
				Position = UDim2.new(1, noticeWidth + 20, 0, 14)
			}):Play()
			TweenService:Create(textLabel, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
			TweenService:Create(bar, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()

			task.delay(0.25, function()
				if thisNoticeId == SettingsNoticeId and SettingsNoticeFrame == currentFrame then
					currentFrame:Destroy()
					SettingsNoticeFrame = nil
				end
			end)
		end
	end)
end



function getCwalkRangeDistance(value)
	value = tonumber(value) or 1
	if value <= 1 then return 1.08 end
	if value == 2 then return 1.22 end
	if value == 3 then return 1.36 end
	if value == 4 then return 1.45 end
	return 1.57
end

function setCwalkRangeValue(value)
	cwalkRangeValue = math.clamp(math.floor(tonumber(value) or 1), 1, 5)
	CORNER_WALK_WALL_DISTANCE = getCwalkRangeDistance(cwalkRangeValue)
end

function getNumberFromSettingBox(box)
	local raw = tostring(box and box.Text or "")
	local num = tonumber(raw) or tonumber(raw:match("[-]?%d+"))
	return num
end

function getEffectiveWallhopCooldown()
	if not isXrayEnabled then
		return 0
	end

	local after = math.clamp(math.floor(tonumber(nonSpamAfterValue) or 0), 0, 10)
	if consecutiveWallhopCount < after then
		return 0
	end

	return (tonumber(nonSpamValue) or 50) / 100
end

function applyCurrentNonSpamCooldown()
	WALLHOP_COOLDOWN = getEffectiveWallhopCooldown()
end











function updateSettingsInputs()
	if SettingsXrayBox then
		SettingsXrayBox.Text = tostring(math.floor(tonumber(xrayOpacityValue) or 60)) .. "%"
		SettingsXrayBox.TextTransparency = 0
		SettingsXrayBox.BackgroundTransparency = 0
	end
	if PcSettingsXrayBox then
		PcSettingsXrayBox.Text = tostring(math.floor(tonumber(xrayOpacityValue) or 60)) .. "%"
		PcSettingsXrayBox.TextTransparency = 0
		PcSettingsXrayBox.BackgroundTransparency = 0
	end
	if SettingsNonSpamBox then
		SettingsNonSpamBox.Text = tostring(math.floor(tonumber(nonSpamValue) or 50)) .. "ms"
		SettingsNonSpamBox.TextTransparency = 0
		SettingsNonSpamBox.BackgroundTransparency = 0
	end
	if PcSettingsNonSpamBox then
		PcSettingsNonSpamBox.Text = tostring(math.floor(tonumber(nonSpamValue) or 50)) .. "ms"
		PcSettingsNonSpamBox.TextTransparency = 0
		PcSettingsNonSpamBox.BackgroundTransparency = 0
	end
	if SettingsNonSpamAfterBox then
		SettingsNonSpamAfterBox.Text = tostring(math.floor(tonumber(nonSpamAfterValue) or 0)) .. "wh"
		SettingsNonSpamAfterBox.TextTransparency = 0
		SettingsNonSpamAfterBox.BackgroundTransparency = 0
	end
	if PcSettingsNonSpamAfterBox then
		PcSettingsNonSpamAfterBox.Text = tostring(math.floor(tonumber(nonSpamAfterValue) or 0)) .. "wh"
		PcSettingsNonSpamAfterBox.TextTransparency = 0
		PcSettingsNonSpamAfterBox.BackgroundTransparency = 0
	end
	if SettingsDance2TimeBox then
		SettingsDance2TimeBox.Text = tostring(math.floor(tonumber(dance2TimeValue) or 10)) .. "ms"
		SettingsDance2TimeBox.TextTransparency = 0
		SettingsDance2TimeBox.BackgroundTransparency = 0
	end
	if PcDance2TimeBox then
		PcDance2TimeBox.Text = tostring(math.floor(tonumber(dance2TimeValue) or 10)) .. "ms"
		PcDance2TimeBox.TextTransparency = 0
		PcDance2TimeBox.BackgroundTransparency = 0
	end
	if SettingsCwalkRangeBox then
		SettingsCwalkRangeBox.Text = tostring(math.floor(tonumber(cwalkRangeValue) or 1)) .. "sd"
		SettingsCwalkRangeBox.TextTransparency = 0
		SettingsCwalkRangeBox.BackgroundTransparency = 0
	end
	if PcCwalkRangeBox then
		PcCwalkRangeBox.Text = tostring(math.floor(tonumber(cwalkRangeValue) or 1)) .. "sd"
		PcCwalkRangeBox.TextTransparency = 0
		PcCwalkRangeBox.BackgroundTransparency = 0
	end
	for _, lbl in ipairs({MobileMinimalSettingsTitle, SettingsNonSpamTitle, SettingsNonSpamAfterTitle, SettingsDance2TimeTitle, SettingsCwalkRangeTitle, SettingsXrayTitle, PcMinimalSettingsTitle, PcSettingsNonSpamTitle, PcSettingsNonSpamAfterTitle, PcDance2TimeTitle, PcCwalkRangeTitle, PcSettingsXrayTitle}) do
		if lbl then
			lbl.TextTransparency = 0
			lbl.Visible = true
		end
	end
end

function applyXraySettingFromBox(sourceBox)
	local activeBox = sourceBox or SettingsXrayBox or PcSettingsXrayBox
	value = getNumberFromSettingBox(activeBox)
	if not value or value < 0 or value > 100 then
		showSettingsNotice("Minimum value is 0 and the maximum value is 100.")
		updateSettingsInputs()
		return
	end

	xrayOpacityValue = math.floor(value)

	if realXrayEnabled then
		clearXray()
		applyXray()
	end

	updateSettingsInputs()
	saveUserPreferences()
	showSettingsNotice("Successfully changed, the transparency of xray is at " .. tostring(xrayOpacityValue) .. " percentage.")
end

function applyNonSpamSettingFromBox(sourceBox)
	local activeBox = sourceBox or SettingsNonSpamBox or PcSettingsNonSpamBox
	value = getNumberFromSettingBox(activeBox)
	if not value or value < 10 or value > 99 then
		showSettingsNotice("Minimum value is 10 and the maximum value is 99.")
		updateSettingsInputs()
		return
	end

	nonSpamValue = math.floor(value)

	if isXrayEnabled then
		applyCurrentNonSpamCooldown()
	end

	updateSettingsInputs()
	saveUserPreferences()
	showSettingsNotice("Successfully changed, non-spam time will be at " .. tostring(nonSpamValue) .. " milliseconds.")
end

function applyNonSpamAfterSettingFromBox(sourceBox)
	local activeBox = sourceBox or SettingsNonSpamAfterBox or PcSettingsNonSpamAfterBox
	value = getNumberFromSettingBox(activeBox)
	if not value or value < 0 or value > 10 then
		showSettingsNotice("Minimum value is 0 and the maximum value is 10.")
		updateSettingsInputs()
		return
	end

	nonSpamAfterValue = math.floor(value)
	applyCurrentNonSpamCooldown()
	updateSettingsInputs()
	saveUserPreferences()
	showSettingsNotice("Successfully changed, it will now run non-spam time after " .. tostring(nonSpamAfterValue) .. " wallhops.")
end

function getDance2TimeSeconds()
	return math.clamp((tonumber(dance2TimeValue) or 10) / 100, 0.05, 0.20)
end

function applyDance2TimeSettingFromBox(sourceBox)
	local activeBox = sourceBox or SettingsDance2TimeBox or PcDance2TimeBox
	value = getNumberFromSettingBox(activeBox)
	if not value or value < 5 or value > 20 then
		showSettingsNotice("Minimum value is 5 and the maximum value is 20.")
		updateSettingsInputs()
		return
	end

	dance2TimeValue = math.floor(value)
	local secondsText = string.format("%.2f", getDance2TimeSeconds())
	updateSettingsInputs()
	saveUserPreferences()
	showSettingsNotice("Sucessfully changed, the noclip for /e dance2 will now be at " .. secondsText .. " seconds.")
end

function applyCwalkRangeSettingFromBox(sourceBox)
	local activeBox = sourceBox or SettingsCwalkRangeBox or PcCwalkRangeBox
	value = getNumberFromSettingBox(activeBox)
	if not value or value < 1 or value > 5 then
		showSettingsNotice("Minimum value is 1 and the maximum value is 5.")
		updateSettingsInputs()
		return
	end
	setCwalkRangeValue(value)
	updateSettingsInputs()
	saveUserPreferences()
	showSettingsNotice("Successfully changed, the Corner walk range will be at " .. tostring(cwalkRangeValue) .. " studs.")
end

function createSettingsLabel(parent, y, textValue)
	SettingsLabel = Instance.new("TextLabel")
	SettingsLabel.Size = UDim2.new(1, -76, 0, 24)
	SettingsLabel.Position = UDim2.new(0, 12, 0, y)
	SettingsLabel.BackgroundTransparency = 1
	SettingsLabel.Text = textValue
	SettingsLabel.TextColor3 = Color3.fromRGB(255,255,255)
	SettingsLabel.TextTransparency = 0
	SettingsLabel.Font = Enum.Font.GothamBold
	SettingsLabel.TextSize = 14
	SettingsLabel.TextXAlignment = Enum.TextXAlignment.Left
	SettingsLabel.TextYAlignment = Enum.TextYAlignment.Center
	SettingsLabel.ZIndex = 30
	SettingsLabel.Parent = parent
	noTextStroke(SettingsLabel)
	setTargetTransparency(SettingsLabel, 1, 0)
	return SettingsLabel
end

function addSettingsPressEffect(button)
	if not button then
		return
	end

	local pressOverlay = Instance.new("Frame")
	pressOverlay.Name = "PressOverlay"
	pressOverlay.Size = UDim2.new(1, 0, 1, 0)
	pressOverlay.Position = UDim2.new(0, 0, 0, 0)
	pressOverlay.BackgroundColor3 = Color3.fromRGB(255,255,255)
	pressOverlay.BackgroundTransparency = 1
	pressOverlay.BorderSizePixel = 0
	pressOverlay.ZIndex = button.ZIndex + 1
	pressOverlay.Active = false
	pressOverlay.Parent = button
	Instance.new("UICorner", pressOverlay).CornerRadius = UDim.new(0, 10)

	local pressing = false
	local function setOverlay(alpha)
		pcall(function()
			TweenService:Create(pressOverlay, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = alpha
			}):Play()
		end)
	end

	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			pressing = true
			setOverlay(0.82)
		end
	end)

	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			pressing = false
			setOverlay(1)
		end
	end)

	button.MouseLeave:Connect(function()
		if pressing then
			pressing = false
			setOverlay(1)
		end
	end)

	if button:IsA("GuiButton") then
		button.Activated:Connect(function()
			setOverlay(0.82)
			task.delay(0.08, function()
				if pressOverlay and pressOverlay.Parent then
					setOverlay(1)
				end
			end)
		end)
	end
end

function createSettingsButton(parent, y, textValue)
	SettingsButton = Instance.new("TextButton")
	SettingsButton.Size = UDim2.new(1, -14, 0, 32)
	SettingsButton.Position = UDim2.new(0, 7, 0, y)
	SettingsButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
	SettingsButton.Text = textValue
	SettingsButton.TextColor3 = Color3.fromRGB(255,255,255)
	SettingsButton.Font = Enum.Font.GothamBold
	SettingsButton.TextSize = 13
	SettingsButton.AutoButtonColor = false
	SettingsButton.ZIndex = 36
	SettingsButton.Parent = parent
	Instance.new("UICorner", SettingsButton).CornerRadius = UDim.new(0, 10)
	SettingsButtonStroke = Instance.new("UIStroke")
	SettingsButtonStroke.Color = Color3.fromRGB(35,35,35)
	SettingsButtonStroke.Thickness = 1
	SettingsButtonStroke.Transparency = 0.08
	SettingsButtonStroke.Parent = SettingsButton
	noTextStroke(SettingsButton)
	setTargetTransparency(SettingsButton, 0, 0)
	addSettingsPressEffect(SettingsButton)
	return SettingsButton
end

function buildMobileSettingsPage()
	MobileSettingsPage = Instance.new("ScrollingFrame")
	MobileSettingsPage.Size = UDim2.new(1, 0, 1, -58)
	MobileSettingsPage.Position = UDim2.new(0, 0, 0, 58)
	MobileSettingsPage.BackgroundTransparency = 1
	MobileSettingsPage.BorderSizePixel = 0
	MobileSettingsPage.ScrollBarThickness = 3
	MobileSettingsPage.ScrollingDirection = Enum.ScrollingDirection.Y
	MobileSettingsPage.CanvasSize = UDim2.new(0, 0, 0, 270)
	MobileSettingsPage.Visible = false
	MobileSettingsPage.Parent = MobilePanel

	MobileMinimalSettingsTitle = Instance.new("TextLabel")
	MobileMinimalSettingsTitle.Size = UDim2.new(1, -14, 0, 22)
	MobileMinimalSettingsTitle.Position = UDim2.new(0, 7, 0, 4)
	MobileMinimalSettingsTitle.BackgroundTransparency = 1
	MobileMinimalSettingsTitle.Text = "Minimal Settings"
	MobileMinimalSettingsTitle.TextColor3 = Color3.fromRGB(255,255,255)
	MobileMinimalSettingsTitle.Font = Enum.Font.GothamBold
	MobileMinimalSettingsTitle.TextSize = 13
	MobileMinimalSettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
	MobileMinimalSettingsTitle.Parent = MobileSettingsPage
	noTextStroke(MobileMinimalSettingsTitle)
	setTargetTransparency(MobileMinimalSettingsTitle, 1, 0)

	SettingsNonSpamTitle = createSettingsLabel(MobileSettingsPage, 32, "Non-spam Time")
	SettingsNonSpamTitle.ZIndex = 40
	SettingsNonSpamTitle.TextTransparency = 0
	setTargetTransparency(SettingsNonSpamTitle, 1, 0)

	SettingsNonSpamBox = Instance.new("TextBox")
	SettingsNonSpamBox.Size = UDim2.new(0, 58, 0, 28)
	SettingsNonSpamBox.Position = UDim2.new(1, -65, 0, 30)
	SettingsNonSpamBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	SettingsNonSpamBox.TextColor3 = Color3.fromRGB(255,255,255)
	SettingsNonSpamBox.Font = Enum.Font.GothamBold
	SettingsNonSpamBox.TextSize = 12
	SettingsNonSpamBox.Text = tostring(nonSpamValue) .. "ms"
	SettingsNonSpamBox.ClearTextOnFocus = true
	SettingsNonSpamBox.ZIndex = 41
	SettingsNonSpamBox.Parent = MobileSettingsPage
	Instance.new("UICorner", SettingsNonSpamBox).CornerRadius = UDim.new(0, 8)
	SettingsNonSpamBoxStroke = Instance.new("UIStroke")
	SettingsNonSpamBoxStroke.Color = Color3.fromRGB(35,35,35)
	SettingsNonSpamBoxStroke.Thickness = 1
	SettingsNonSpamBoxStroke.Transparency = 0.08
	SettingsNonSpamBoxStroke.Parent = SettingsNonSpamBox
	noTextStroke(SettingsNonSpamBox)
	SettingsNonSpamBox.FocusLost:Connect(function()
		applyNonSpamSettingFromBox(SettingsNonSpamBox)
	end)

	SettingsNonSpamAfterTitle = createSettingsLabel(MobileSettingsPage, 68, "Non-spam After")
	SettingsNonSpamAfterTitle.ZIndex = 40
	SettingsNonSpamAfterTitle.TextTransparency = 0
	setTargetTransparency(SettingsNonSpamAfterTitle, 1, 0)

	SettingsNonSpamAfterBox = Instance.new("TextBox")
	SettingsNonSpamAfterBox.Size = UDim2.new(0, 58, 0, 28)
	SettingsNonSpamAfterBox.Position = UDim2.new(1, -65, 0, 66)
	SettingsNonSpamAfterBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	SettingsNonSpamAfterBox.TextColor3 = Color3.fromRGB(255,255,255)
	SettingsNonSpamAfterBox.Font = Enum.Font.GothamBold
	SettingsNonSpamAfterBox.TextSize = 12
	SettingsNonSpamAfterBox.Text = tostring(nonSpamAfterValue) .. "wh"
	SettingsNonSpamAfterBox.ClearTextOnFocus = true
	SettingsNonSpamAfterBox.ZIndex = 41
	SettingsNonSpamAfterBox.Parent = MobileSettingsPage
	Instance.new("UICorner", SettingsNonSpamAfterBox).CornerRadius = UDim.new(0, 8)
	SettingsNonSpamAfterBoxStroke = Instance.new("UIStroke")
	SettingsNonSpamAfterBoxStroke.Color = Color3.fromRGB(35,35,35)
	SettingsNonSpamAfterBoxStroke.Thickness = 1
	SettingsNonSpamAfterBoxStroke.Transparency = 0.08
	SettingsNonSpamAfterBoxStroke.Parent = SettingsNonSpamAfterBox
	noTextStroke(SettingsNonSpamAfterBox)
	SettingsNonSpamAfterBox.FocusLost:Connect(function()
		applyNonSpamAfterSettingFromBox(SettingsNonSpamAfterBox)
	end)

	SettingsDance2TimeTitle = createSettingsLabel(MobileSettingsPage, 104, "Dance2 Time")
	SettingsDance2TimeTitle.ZIndex = 40
	SettingsDance2TimeTitle.TextTransparency = 0
	setTargetTransparency(SettingsDance2TimeTitle, 1, 0)

	SettingsDance2TimeBox = Instance.new("TextBox")
	SettingsDance2TimeBox.Size = UDim2.new(0, 58, 0, 28)
	SettingsDance2TimeBox.Position = UDim2.new(1, -65, 0, 102)
	SettingsDance2TimeBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	SettingsDance2TimeBox.TextColor3 = Color3.fromRGB(255,255,255)
	SettingsDance2TimeBox.Font = Enum.Font.GothamBold
	SettingsDance2TimeBox.TextSize = 12
	SettingsDance2TimeBox.Text = tostring(dance2TimeValue) .. "ms"
	SettingsDance2TimeBox.ClearTextOnFocus = true
	SettingsDance2TimeBox.ZIndex = 41
	SettingsDance2TimeBox.Parent = MobileSettingsPage
	Instance.new("UICorner", SettingsDance2TimeBox).CornerRadius = UDim.new(0, 8)
	SettingsDance2TimeBoxStroke = Instance.new("UIStroke")
	SettingsDance2TimeBoxStroke.Color = Color3.fromRGB(35,35,35)
	SettingsDance2TimeBoxStroke.Thickness = 1
	SettingsDance2TimeBoxStroke.Transparency = 0.08
	SettingsDance2TimeBoxStroke.Parent = SettingsDance2TimeBox
	noTextStroke(SettingsDance2TimeBox)
	SettingsDance2TimeBox.FocusLost:Connect(function()
		applyDance2TimeSettingFromBox(SettingsDance2TimeBox)
	end)

	SettingsCwalkRangeTitle = createSettingsLabel(MobileSettingsPage, 140, "C-walk Range")
	SettingsCwalkRangeTitle.ZIndex = 40
	SettingsCwalkRangeTitle.TextTransparency = 0
	setTargetTransparency(SettingsCwalkRangeTitle, 1, 0)

	SettingsCwalkRangeBox = Instance.new("TextBox")
	SettingsCwalkRangeBox.Size = UDim2.new(0, 58, 0, 28)
	SettingsCwalkRangeBox.Position = UDim2.new(1, -65, 0, 138)
	SettingsCwalkRangeBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	SettingsCwalkRangeBox.TextColor3 = Color3.fromRGB(255,255,255)
	SettingsCwalkRangeBox.Font = Enum.Font.GothamBold
	SettingsCwalkRangeBox.TextSize = 12
	SettingsCwalkRangeBox.Text = tostring(cwalkRangeValue) .. "sd"
	SettingsCwalkRangeBox.ClearTextOnFocus = true
	SettingsCwalkRangeBox.ZIndex = 41
	SettingsCwalkRangeBox.Parent = MobileSettingsPage
	Instance.new("UICorner", SettingsCwalkRangeBox).CornerRadius = UDim.new(0, 8)
	SettingsCwalkRangeBoxStroke = Instance.new("UIStroke")
	SettingsCwalkRangeBoxStroke.Color = Color3.fromRGB(35,35,35)
	SettingsCwalkRangeBoxStroke.Thickness = 1
	SettingsCwalkRangeBoxStroke.Transparency = 0.08
	SettingsCwalkRangeBoxStroke.Parent = SettingsCwalkRangeBox
	noTextStroke(SettingsCwalkRangeBox)
	SettingsCwalkRangeBox.FocusLost:Connect(function()
		applyCwalkRangeSettingFromBox(SettingsCwalkRangeBox)
	end)

	SettingsXrayTitle = createSettingsLabel(MobileSettingsPage, 176, "X-ray Opacity")
	SettingsXrayTitle.ZIndex = 40
	SettingsXrayTitle.TextTransparency = 0
	setTargetTransparency(SettingsXrayTitle, 1, 0)

	SettingsXrayBox = Instance.new("TextBox")
	SettingsXrayBox.Size = UDim2.new(0, 58, 0, 28)
	SettingsXrayBox.Position = UDim2.new(1, -65, 0, 174)
	SettingsXrayBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	SettingsXrayBox.TextColor3 = Color3.fromRGB(255,255,255)
	SettingsXrayBox.Font = Enum.Font.GothamBold
	SettingsXrayBox.TextSize = 12
	SettingsXrayBox.Text = tostring(xrayOpacityValue) .. "%"
	SettingsXrayBox.ClearTextOnFocus = true
	SettingsXrayBox.ZIndex = 41
	SettingsXrayBox.Parent = MobileSettingsPage
	Instance.new("UICorner", SettingsXrayBox).CornerRadius = UDim.new(0, 8)
	SettingsXrayBoxStroke = Instance.new("UIStroke")
	SettingsXrayBoxStroke.Color = Color3.fromRGB(35,35,35)
	SettingsXrayBoxStroke.Thickness = 1
	SettingsXrayBoxStroke.Transparency = 0.08
	SettingsXrayBoxStroke.Parent = SettingsXrayBox
	noTextStroke(SettingsXrayBox)
	SettingsXrayBox.FocusLost:Connect(function()
		applyXraySettingFromBox(SettingsXrayBox)
	end)

	updateSettingsInputs()
end

local function buildMobileGui()
	clearOldDragConnections()
	loadUserPreferences()

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
	MobileButton:SetAttribute("LastDragTime", 0)
	MobileButton:SetAttribute("CustomMoved", false)
	Instance.new("UICorner", MobileButton).CornerRadius = UDim.new(0, 12)
	noTextStroke(MobileButton)
	addTrueRoundedShadow(MobileButton, 14, 1.15, Color3.fromRGB(0, 0, 0))
	setTargetTransparency(MobileButton, 0, 0)

	local function createFloatingMobileButton(name, text)
		local button = Instance.new("TextButton")
		button.Name = name
		button.Size = UDim2.new(0, 140, 0, 50)
		button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		button.Text = text
		button.TextColor3 = Color3.fromRGB(255,255,255)
		button.Font = Enum.Font.GothamBold
		button.TextScaled = true
		button.Visible = false
		button.Parent = ScreenGui
		button:SetAttribute("LastDragTime", 0)
		button:SetAttribute("CustomMoved", false)
		Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)
		noTextStroke(button)
		addTrueRoundedShadow(button, 14, 1.15, Color3.fromRGB(0, 0, 0))
		setTargetTransparency(button, 0, 0)
		return button
	end

	MobileCornerWalkButton = createFloatingMobileButton("CornerWalkButton", "C-walk Off")
	MobileBeastSlowButton = createFloatingMobileButton("BeastSlowButton", "Slow Off")

	local inset = GuiService:GetGuiInset()

	MobileMenuButton = Instance.new("TextButton")
	MobileMenuButton.Size = UDim2.new(0, 54, 0, 54)
	MobileMenuButton.Position = UDim2.new(0, 86, 0, inset.Y - 60)
	MobileMenuButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MobileMenuButton.Text = "≡"
	MobileMenuButton.TextColor3 = Color3.fromRGB(255,255,255)
	MobileMenuButton.Font = Enum.Font.GothamBold
	MobileMenuButton.TextSize = 22
	MobileMenuButton.Parent = ScreenGui
	Instance.new("UICorner", MobileMenuButton).CornerRadius = UDim.new(1, 0)
	noTextStroke(MobileMenuButton)
	addTrueRoundedShadow(MobileMenuButton, 999, 1.05, Color3.fromRGB(0, 0, 0))
	setTargetTransparency(MobileMenuButton, 0, 0)

	MobilePanel = Instance.new("Frame")
	MobilePanel.Size = UDim2.new(0, 232, 0, 324)
	MobilePanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MobilePanel.BorderSizePixel = 0
	MobilePanel.Visible = false
	MobilePanel.Parent = ScreenGui
	Instance.new("UICorner", MobilePanel).CornerRadius = UDim.new(0, 14)
	addTrueRoundedShadow(MobilePanel, 14, 1.15, Color3.fromRGB(0, 0, 0))
	setTargetTransparency(MobilePanel, 0, nil)

	mobileDragHandle = Instance.new("Frame")
	mobileDragHandle.Size = UDim2.new(1, -16, 0, 14)
	mobileDragHandle.Position = UDim2.new(0, 7, 0, 5)
	mobileDragHandle.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	mobileDragHandle.BorderSizePixel = 0
	mobileDragHandle.Parent = MobilePanel
	mobileDragHandle.Active = true
	Instance.new("UICorner", mobileDragHandle).CornerRadius = UDim.new(1, 0)
	setTargetTransparency(mobileDragHandle, 0, nil)

	MobileTabFunctions = Instance.new("TextButton")
	MobileTabFunctions.Size = UDim2.new(0, 62, 0, 26)
	MobileTabFunctions.Position = UDim2.new(0, 8, 0, 24)
	MobileTabFunctions.BackgroundColor3 = Color3.fromRGB(20,20,20)
	MobileTabFunctions.Text = "Functions"
	MobileTabFunctions.TextColor3 = Color3.fromRGB(255,255,255)
	MobileTabFunctions.Font = Enum.Font.GothamBold
	MobileTabFunctions.TextSize = 11
	MobileTabFunctions.Parent = MobilePanel
	MobileTabFunctions.AutoButtonColor = false
	Instance.new("UICorner", MobileTabFunctions).CornerRadius = UDim.new(0, 10)
	setTargetTransparency(MobileTabFunctions, 0, 0)
	noTextStroke(MobileTabFunctions)

	MobileTabFlicks = Instance.new("TextButton")
	MobileTabFlicks.Size = UDim2.new(0, 62, 0, 26)
	MobileTabFlicks.Position = UDim2.new(0, 84, 0, 24)
	MobileTabFlicks.BackgroundColor3 = Color3.fromRGB(8,8,8)
	MobileTabFlicks.Text = "Flicks"
	MobileTabFlicks.TextColor3 = Color3.fromRGB(255,255,255)
	MobileTabFlicks.Font = Enum.Font.GothamBold
	MobileTabFlicks.TextSize = 11
	MobileTabFlicks.Parent = MobilePanel
	MobileTabFlicks.AutoButtonColor = false
	Instance.new("UICorner", MobileTabFlicks).CornerRadius = UDim.new(0, 10)
	setTargetTransparency(MobileTabFlicks, 0, 0)
	noTextStroke(MobileTabFlicks)

	MobileTabSettings = Instance.new("TextButton")
	MobileTabSettings.Size = UDim2.new(0, 66, 0, 26)
	MobileTabSettings.Position = UDim2.new(0, 160, 0, 24)
	MobileTabSettings.BackgroundColor3 = Color3.fromRGB(8,8,8)
	MobileTabSettings.Text = "Settings"
	MobileTabSettings.TextColor3 = Color3.fromRGB(255,255,255)
	MobileTabSettings.Font = Enum.Font.GothamBold
	MobileTabSettings.TextSize = 11
	MobileTabSettings.Parent = MobilePanel
	MobileTabSettings.AutoButtonColor = false
	Instance.new("UICorner", MobileTabSettings).CornerRadius = UDim.new(0, 10)
	setTargetTransparency(MobileTabSettings, 0, 0)
	noTextStroke(MobileTabSettings)

	MobileFunctionsPage = Instance.new("ScrollingFrame")
	MobileFunctionsPage.Size = UDim2.new(1, 0, 1, -58)
	MobileFunctionsPage.Position = UDim2.new(0, 0, 0, 58)
	MobileFunctionsPage.BackgroundTransparency = 1
	MobileFunctionsPage.BorderSizePixel = 0
	MobileFunctionsPage.ScrollBarThickness = 3
	MobileFunctionsPage.ScrollingDirection = Enum.ScrollingDirection.Y
	MobileFunctionsPage.CanvasSize = UDim2.new(0, 0, 0, 368)
	MobileFunctionsPage.Parent = MobilePanel

	MobileFlicksPage = Instance.new("ScrollingFrame")
	MobileFlicksPage.Size = UDim2.new(1, 0, 1, -58)
	MobileFlicksPage.Position = UDim2.new(0, 0, 0, 58)
	MobileFlicksPage.BackgroundTransparency = 1
	MobileFlicksPage.BorderSizePixel = 0
	MobileFlicksPage.ScrollBarThickness = 3
	MobileFlicksPage.ScrollingDirection = Enum.ScrollingDirection.Y
	MobileFlicksPage.CanvasSize = UDim2.new(0, 0, 0, 420)
	MobileFlicksPage.Parent = MobilePanel
	MobileFlicksPage.Visible = false

	buildMobileSettingsPage()

	MobileAllFunctionsTitle = Instance.new("TextLabel")
	MobileAllFunctionsTitle.Size = UDim2.new(1, -14, 0, 22)
	MobileAllFunctionsTitle.Position = UDim2.new(0, 7, 0, 4)
	MobileAllFunctionsTitle.BackgroundTransparency = 1
	MobileAllFunctionsTitle.Text = "All Functions"
	MobileAllFunctionsTitle.TextColor3 = Color3.fromRGB(255,255,255)
	MobileAllFunctionsTitle.Font = Enum.Font.GothamBold
	MobileAllFunctionsTitle.TextSize = 13
	MobileAllFunctionsTitle.TextXAlignment = Enum.TextXAlignment.Left
	MobileAllFunctionsTitle.Parent = MobileFunctionsPage
	noTextStroke(MobileAllFunctionsTitle)
	setTargetTransparency(MobileAllFunctionsTitle, 1, 0)

	MobileHideGuiRow, mobileHideGuiSwitch, mobileHideGuiKnob = createSwitchRow(MobileFunctionsPage, 30, "Wallhop")
	MobileXrayRow, mobileXraySwitch, mobileXrayKnob = createSwitchRow(MobileFunctionsPage, 72, "Non-spam")
	MobileRealXrayRow, mobileRealXraySwitch, mobileRealXrayKnob = createSwitchRow(MobileFunctionsPage, 114, "X-ray")
	MobileCornerWalkRow, mobileCornerWalkSwitch, mobileCornerWalkKnob = createSwitchRow(MobileFunctionsPage, 156, "Corner Walk")
	MobileBeastSlowRow, mobileBeastSlowSwitch, mobileBeastSlowKnob = createSwitchRow(MobileFunctionsPage, 198, "Beast Slow")
	MobileDance2TurnRow, mobileDance2TurnSwitch, mobileDance2TurnKnob = createSwitchRow(MobileFunctionsPage, 240, "Clip Dance2")
	MobileFloorbangEspRow, mobileFloorbangEspSwitch, mobileFloorbangEspKnob = createSwitchRow(MobileFunctionsPage, 282, "Floorbang ESP")

	MobileFlickTypesTitle = Instance.new("TextLabel")
	MobileFlickTypesTitle.Size = UDim2.new(1, -14, 0, 22)
	MobileFlickTypesTitle.Position = UDim2.new(0, 7, 0, 4)
	MobileFlickTypesTitle.BackgroundTransparency = 1
	MobileFlickTypesTitle.Text = "Flick Types"
	MobileFlickTypesTitle.TextColor3 = Color3.fromRGB(255,255,255)
	MobileFlickTypesTitle.Font = Enum.Font.GothamBold
	MobileFlickTypesTitle.TextSize = 13
	MobileFlickTypesTitle.TextXAlignment = Enum.TextXAlignment.Left
	MobileFlickTypesTitle.Parent = MobileFlicksPage
	noTextStroke(MobileFlickTypesTitle)
	setTargetTransparency(MobileFlickTypesTitle, 1, 0)

	MobileNormalWallhopRow = createSimpleRow(MobileFlicksPage, 30, "Normal Wallhop")
	MobileNoMoveWallhopRow = createSimpleRow(MobileFlicksPage, 72, "Visual Wallhop")
	Mobile360WallhopRow = createSimpleRow(MobileFlicksPage, 114, "360° Wallhop")
	MobileConsoleWallhopRow = createSimpleRow(MobileFlicksPage, 156, "Console Wallhop")

	MobileFlickSettingsTitle = Instance.new("TextLabel")
	MobileFlickSettingsTitle.Size = UDim2.new(1, -14, 0, 22)
	MobileFlickSettingsTitle.Position = UDim2.new(0, 7, 0, 202)
	MobileFlickSettingsTitle.BackgroundTransparency = 1
	MobileFlickSettingsTitle.Text = "Flick Settings"
	MobileFlickSettingsTitle.TextColor3 = Color3.fromRGB(255,255,255)
	MobileFlickSettingsTitle.Font = Enum.Font.GothamBold
	MobileFlickSettingsTitle.TextSize = 13
	MobileFlickSettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
	MobileFlickSettingsTitle.Parent = MobileFlicksPage
	noTextStroke(MobileFlickSettingsTitle)
	setTargetTransparency(MobileFlickSettingsTitle, 1, 0)

	MobileNormalFlickRow = createSimpleRow(MobileFlicksPage, 228, "Normal Flick")
	MobileSpeedFlickRow = createSimpleRow(MobileFlicksPage, 270, "Speed Flick")
	MobileSlowFlickRow = createSimpleRow(MobileFlicksPage, 312, "Slow Flick")

	MobileCurrentUsingLabel = Instance.new("TextLabel")
	MobileCurrentUsingLabel.Size = UDim2.new(1, -14, 0, 46)
	MobileCurrentUsingLabel.Position = UDim2.new(0, 7, 0, 354)
	MobileCurrentUsingLabel.BackgroundTransparency = 1
	MobileCurrentUsingLabel.Text = "Currently config: " .. currentFlickMode .. ", " .. currentFlickSetting
	MobileCurrentUsingLabel.TextColor3 = Color3.fromRGB(200,200,200)
	MobileCurrentUsingLabel.Font = Enum.Font.Gotham
	MobileCurrentUsingLabel.TextSize = 10
	MobileCurrentUsingLabel.TextWrapped = true
	MobileCurrentUsingLabel.TextXAlignment = Enum.TextXAlignment.Left
	MobileCurrentUsingLabel.TextYAlignment = Enum.TextYAlignment.Top
	MobileCurrentUsingLabel.Parent = MobileFlicksPage
	noTextStroke(MobileCurrentUsingLabel)
	setTargetTransparency(MobileCurrentUsingLabel, 1, 0)

	local mobileFooter = Instance.new("TextLabel")
	mobileFooter.Name = "MobileFooter"
	mobileFooter.Size = UDim2.new(1, -14, 0, 14)
	mobileFooter.Position = UDim2.new(0, 7, 1, -18)
	mobileFooter.BackgroundTransparency = 1
	mobileFooter.Text = ""
	mobileFooter.TextColor3 = Color3.fromRGB(95,95,95)
	mobileFooter.Font = Enum.Font.Gotham
	mobileFooter.TextSize = 10
	mobileFooter.TextXAlignment = Enum.TextXAlignment.Left
	mobileFooter.ZIndex = 80
	mobileFooter.Visible = false
	mobileFooter.Parent = MobilePanel
	noTextStroke(mobileFooter)
	setTargetTransparency(mobileFooter, 1, 0)

	local function placeMobileButtonDefault()
		local insetNow = GuiService:GetGuiInset()

		if not MobileButton:GetAttribute("CustomMoved") then
			MobileButton.Position = UDim2.new(0, 150, 0, insetNow.Y - 58)
		end

		if MobileCornerWalkButton and not MobileCornerWalkButton:GetAttribute("CustomMoved") then
			MobileCornerWalkButton.Position = UDim2.new(
				MobileButton.Position.X.Scale,
				MobileButton.Position.X.Offset,
				MobileButton.Position.Y.Scale,
				MobileButton.Position.Y.Offset + MobileButton.Size.Y.Offset + 8
			)
		end

		if MobileBeastSlowButton and not MobileBeastSlowButton:GetAttribute("CustomMoved") then
			local baseButton = MobileCornerWalkButton or MobileButton
			MobileBeastSlowButton.Position = UDim2.new(
				baseButton.Position.X.Scale,
				baseButton.Position.X.Offset,
				baseButton.Position.Y.Scale,
				baseButton.Position.Y.Offset + baseButton.Size.Y.Offset + 8
			)
		end
	end

	local function placePanelToRightOfWallhop()
		local xOffset = MobileButton.Position.X.Offset + MobileButton.Size.X.Offset + 28
		local yOffset = MobileButton.Position.Y.Offset + 6
		MobilePanel.Position = UDim2.new(0, xOffset, 0, yOffset)
	end

	RunService.RenderStepped:Connect(function()
		if not isThisScriptActive() then
			return
		end

		if selectedMode ~= "Mobile" then
			return
		end
		placeMobileButtonDefault()

		if mobileMenuOpen and not MobilePanel:GetAttribute("CustomMoved") then
			placePanelToRightOfWallhop()
		end
	end)

	placeMobileButtonDefault()
	placePanelToRightOfWallhop()

	bindFreeDrag(MobileButton, MobileButton, function()
		MobileButton:SetAttribute("CustomMoved", true)

		if MobileCornerWalkButton and not MobileCornerWalkButton:GetAttribute("CustomMoved") then
			MobileCornerWalkButton.Position = UDim2.new(
				MobileButton.Position.X.Scale,
				MobileButton.Position.X.Offset,
				MobileButton.Position.Y.Scale,
				MobileButton.Position.Y.Offset + MobileButton.Size.Y.Offset + 8
			)
		end

		if MobileBeastSlowButton and not MobileBeastSlowButton:GetAttribute("CustomMoved") then
			local baseButton = MobileCornerWalkButton or MobileButton
			MobileBeastSlowButton.Position = UDim2.new(
				baseButton.Position.X.Scale,
				baseButton.Position.X.Offset,
				baseButton.Position.Y.Scale,
				baseButton.Position.Y.Offset + baseButton.Size.Y.Offset + 8
			)
		end

		if not MobilePanel:GetAttribute("CustomMoved") then
			placePanelToRightOfWallhop()
		end
	end, 0.5)

	bindFreeDrag(MobileCornerWalkButton, MobileCornerWalkButton, function()
		MobileCornerWalkButton:SetAttribute("CustomMoved", true)

		if MobileBeastSlowButton and not MobileBeastSlowButton:GetAttribute("CustomMoved") then
			MobileBeastSlowButton.Position = UDim2.new(
				MobileCornerWalkButton.Position.X.Scale,
				MobileCornerWalkButton.Position.X.Offset,
				MobileCornerWalkButton.Position.Y.Scale,
				MobileCornerWalkButton.Position.Y.Offset + MobileCornerWalkButton.Size.Y.Offset + 8
			)
		end
	end, 0.5)

	bindFreeDrag(MobileBeastSlowButton, MobileBeastSlowButton, function()
		MobileBeastSlowButton:SetAttribute("CustomMoved", true)
	end, 0.5)

	bindFreeDrag(MobileMenuButton, MobileMenuButton)
	bindFreeDrag(mobileDragHandle, MobilePanel, function()
		MobilePanel:SetAttribute("CustomMoved", true)
	end)

	MobileButton.Activated:Connect(function()
		if not canUseMobileTap(MobileButton) then
			return
		end
		isWallHopEnabled = not isWallHopEnabled
		updateToggleButton()
		saveUserPreferences()
	end)

	MobileCornerWalkButton.Activated:Connect(function()
		if not canUseMobileTap(MobileCornerWalkButton) then
			return
		end
		setCornerWalkEnabled(not isCornerWalkEnabled)
		updateToggleButton()
	end)

	MobileBeastSlowButton.Activated:Connect(function()
		if not canUseMobileTap(MobileBeastSlowButton) then
			return
		end
		setSlowEnabled(not isSlowEnabled)
		updateToggleButton()
	end)

	MobileMenuButton.Activated:Connect(function()
		if not canUseMobileTap(MobileMenuButton) then
			return
		end

		mobileMenuOpen = not mobileMenuOpen
		saveUserPreferences()

		if mobileMenuOpen then
			if not MobilePanel:GetAttribute("CustomMoved") then
				placePanelToRightOfWallhop()
			end

			MobilePanel.BackgroundTransparency = 1
			MobilePanel.Size = UDim2.new(0, 224, 0, 316)

			elegantShow(MobilePanel, UDim2.new(0, 232, 0, 324), MobilePanel.Position, 0)
		else
			elegantHide(MobilePanel)
		end
	end)

	MobileTabFunctions.Activated:Connect(function()
		switchMobileTab("Functions")
	end)

	MobileTabFlicks.Activated:Connect(function()
		switchMobileTab("Flicks")
	end)

	MobileTabSettings.Activated:Connect(function()
		switchMobileTab("Settings")
	end)

	bindRowPress(MobileHideGuiRow and MobileHideGuiRow:FindFirstChild("SwitchHitbox"), function()
		setMobileGuiHidden(not mobileWallhopGuiHidden)
	end)

	bindRowPress(MobileCornerWalkRow and MobileCornerWalkRow:FindFirstChild("SwitchHitbox"), function()
		setMobileCornerWalkButtonState(not mobileCornerWalkButtonVisible)
	end)

	bindRowPress(MobileBeastSlowRow and MobileBeastSlowRow:FindFirstChild("SwitchHitbox"), function()
		setMobileBeastSlowButtonState(not mobileBeastSlowButtonVisible)
	end)

	bindRowPress(MobileXrayRow and MobileXrayRow:FindFirstChild("SwitchHitbox"), function()
		isXrayEnabled = not isXrayEnabled
		applyCurrentNonSpamCooldown()
		updateMobilePanelButtons()
		saveUserPreferences()
	end)

	bindRowPress(MobileRealXrayRow and MobileRealXrayRow:FindFirstChild("SwitchHitbox"), function()
		setXrayEnabled(not realXrayEnabled)
	end)

	bindRowPress(MobileDance2TurnRow and MobileDance2TurnRow:FindFirstChild("SwitchHitbox"), function()
		setDance2TurnEnabled(not isDance2TurnEnabled)
	end)

	bindRowPress(MobileFloorbangEspRow and MobileFloorbangEspRow:FindFirstChild("SwitchHitbox"), function()
		setFloorbangESPEnabled(not isFloorbangEspEnabled)
	end)

	bindRowPress(MobileNormalWallhopRow, function()
		setFlickMode("Normal Wallhop")
	end)

	bindRowPress(MobileNoMoveWallhopRow, function()
		setFlickMode("Visual Wallhop")
	end)

	bindRowPress(Mobile360WallhopRow, function()
		setFlickMode("360° Wallhop")
	end)

	bindRowPress(MobileConsoleWallhopRow, function()
		setFlickMode("Console Wallhop")
	end)

	bindRowPress(MobileNormalFlickRow, function()
		setFlickSetting("Normal Flick")
	end)

	bindRowPress(MobileSpeedFlickRow, function()
		setFlickSetting("Speed Flick")
	end)

	bindRowPress(MobileSlowFlickRow, function()
		setFlickSetting("Slow Flick")
	end)

	switchMobileTab("Functions")
	updateMobilePanelButtons()
	updateSettingsInputs()
	if realXrayEnabled then
		applyXray()
	end
end

local function setMinimized(state)
	if selectedMode ~= "PC" then
		return
	end

	guiMinimized = state

	if state then
		if MainFrame and MiniButton then
			local savedPos = MainFrame.Position

			elegantHide(MainFrame, function()
				MainFrame.Visible = false

				MiniButton.Position = savedPos
				MiniButton.Visible = true
				setHostShadowVisible(MiniButton, true)

				MiniButton.BackgroundTransparency = 1
				MiniButton.TextTransparency = 1
				MiniButton.Size = UDim2.new(0, 138, 0, 38)

				local finalMiniSize = UDim2.new(0, 150, 0, 42)
				local finalMiniPos = savedPos

				TweenService:Create(
					MiniButton,
					TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{
						Size = finalMiniSize,
						Position = finalMiniPos,
						BackgroundTransparency = 0,
						TextTransparency = 0
					}
				):Play()
			end)
		end

		showNotice("GUI minimized")
	else
		if MainFrame and MiniButton then
			local restorePos = MiniButton.Position

			local miniTween = TweenService:Create(
				MiniButton,
				TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
				{
					BackgroundTransparency = 1,
					TextTransparency = 1,
					Size = UDim2.new(0, 140, 0, 39)
				}
			)

			miniTween:Play()
			miniTween.Completed:Connect(function()
				MiniButton.Visible = false
				setHostShadowVisible(MiniButton, false)

				MainFrame.Position = restorePos
				MainFrame.Size = UDim2.new(0, 335, 0, 300)

				elegantShow(MainFrame, UDim2.new(0, 335, 0, 300), restorePos, 0)
			end)
		end

		showNotice("GUI restored")
	end
end

local function createPcTabButton(parent, x, text)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 96, 0, 28)
	button.Position = UDim2.new(0, x, 0, 54)
	button.BackgroundColor3 = Color3.fromRGB(8,8,8)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255,255,255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 13
	button.AutoButtonColor = false
	button.Parent = parent
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
	noTextStroke(button)
	setTargetTransparency(button, 0, 0)
	return button
end

local function createPcActionButton(parent, y, text)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -36, 0, 30)
	button.Position = UDim2.new(0, 18, 0, y)
	button.BackgroundColor3 = Color3.fromRGB(6,6,6)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255,255,255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.AutoButtonColor = false
	button.Parent = parent
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
	noTextStroke(button)
	setTargetTransparency(button, 0, 0)
	return button
end

local function buildPCGui()
	clearOldDragConnections()
	loadPCKeybinds()
	loadUserPreferences()

	ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AutoWallHopGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 335, 0, 300)
	MainFrame.Position = UDim2.new(0.5, -167, 0.5, -150)
	MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 22)
	addTrueRoundedShadow(MainFrame, 22, 1.25, Color3.fromRGB(0, 0, 0))
	setTargetTransparency(MainFrame, 0, nil)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0, 130, 0, 30)
	title.Position = UDim2.new(0, 18, 0, 8)
	title.BackgroundTransparency = 1
	title.Text = "Cerber X"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 28
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = MainFrame
	noTextStroke(title)
	setTargetTransparency(title, 1, 0)

	local headerIcon = Instance.new("ImageLabel")
	headerIcon.Size = UDim2.new(0, 42, 0, 42)
	headerIcon.Position = UDim2.new(0, 128, 0, 10)
	headerIcon.BackgroundTransparency = 1
	headerIcon.Image = CERBER_ICON_IMAGE
	headerIcon.ScaleType = Enum.ScaleType.Fit
	headerIcon.Parent = MainFrame
	setTargetTransparency(headerIcon, 1, 0)

	local sub = Instance.new("TextLabel")
	sub.Size = UDim2.new(1, -60, 0, 16)
	sub.Position = UDim2.new(0, 18, 0, 34)
	sub.BackgroundTransparency = 1
	sub.Text = "PC Version"
	sub.TextColor3 = Color3.fromRGB(95,95,95)
	sub.Font = Enum.Font.Gotham
	sub.TextSize = 14
	sub.TextXAlignment = Enum.TextXAlignment.Left
	sub.Parent = MainFrame
	noTextStroke(sub)
	setTargetTransparency(sub, 1, 0)

	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
	MinimizeButton.Position = UDim2.new(1, -44, 0, 12)
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	MinimizeButton.Text = "—"
	MinimizeButton.TextColor3 = Color3.fromRGB(255,255,255)
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.TextSize = 20
	MinimizeButton.AutoButtonColor = false
	MinimizeButton.Parent = MainFrame
	Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(1, 0)
	noTextStroke(MinimizeButton)
	setTargetTransparency(MinimizeButton, 0, 0)

	ToggleButton = Instance.new("TextButton")
	ToggleButton.Size = UDim2.new(1, -36, 0, 28)
	ToggleButton.Position = UDim2.new(0, 18, 0, 82)
	ToggleButton.BackgroundTransparency = 1
	ToggleButton.Text = "Wall Hop Off"
	ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
	ToggleButton.Font = Enum.Font.GothamBold
	ToggleButton.TextSize = 24
	ToggleButton.TextXAlignment = Enum.TextXAlignment.Left
	ToggleButton.AutoButtonColor = false
	ToggleButton.Parent = MainFrame
	noTextStroke(ToggleButton)
	setTargetTransparency(ToggleButton, 1, 0)

	PcTabFunctions = createPcTabButton(MainFrame, 18, "Functions")
	PcTabFlicks = createPcTabButton(MainFrame, 120, "Flicks")
	PcTabSettings = createPcTabButton(MainFrame, 222, "Settings")

	PcFunctionsPage = Instance.new("ScrollingFrame")
	PcFunctionsPage.Size = UDim2.new(1, 0, 1, -116)
	PcFunctionsPage.Position = UDim2.new(0, 0, 0, 110)
	PcFunctionsPage.BackgroundTransparency = 1
	PcFunctionsPage.BorderSizePixel = 0
	PcFunctionsPage.ScrollBarThickness = 4
	PcFunctionsPage.ScrollingDirection = Enum.ScrollingDirection.Y
	PcFunctionsPage.CanvasSize = UDim2.new(0, 0, 0, 190)
	PcFunctionsPage.Parent = MainFrame

	PcFlicksPage = Instance.new("ScrollingFrame")
	PcFlicksPage.Size = UDim2.new(1, 0, 1, -94)
	PcFlicksPage.Position = UDim2.new(0, 0, 0, 88)
	PcFlicksPage.BackgroundTransparency = 1
	PcFlicksPage.BorderSizePixel = 0
	PcFlicksPage.ScrollBarThickness = 4
	PcFlicksPage.ScrollingDirection = Enum.ScrollingDirection.Y
	PcFlicksPage.CanvasSize = UDim2.new(0, 0, 0, 295)
	PcFlicksPage.Visible = false
	PcFlicksPage.Parent = MainFrame

	PcSettingsPage = Instance.new("ScrollingFrame")
	PcSettingsPage.Size = UDim2.new(1, 0, 1, -94)
	PcSettingsPage.Position = UDim2.new(0, 0, 0, 88)
	PcSettingsPage.BackgroundTransparency = 1
	PcSettingsPage.BorderSizePixel = 0
	PcSettingsPage.ScrollBarThickness = 4
	PcSettingsPage.ScrollingDirection = Enum.ScrollingDirection.Y
	PcSettingsPage.CanvasSize = UDim2.new(0, 0, 0, 230)
	PcSettingsPage.Visible = false
	PcSettingsPage.Parent = MainFrame

	PcKeybindsTitle = Instance.new("TextLabel")
	PcKeybindsTitle.Size = UDim2.new(1, -36, 0, 20)
	PcKeybindsTitle.Position = UDim2.new(0, 18, 0, 0)
	PcKeybindsTitle.BackgroundTransparency = 1
	PcKeybindsTitle.Text = "Keybinds"
	PcKeybindsTitle.TextColor3 = Color3.fromRGB(255,255,255)
	PcKeybindsTitle.Font = Enum.Font.GothamBold
	PcKeybindsTitle.TextSize = 14
	PcKeybindsTitle.TextXAlignment = Enum.TextXAlignment.Left
	PcKeybindsTitle.Parent = PcFunctionsPage
	noTextStroke(PcKeybindsTitle)
	setTargetTransparency(PcKeybindsTitle, 1, 0)

	HideGuiBindButton = Instance.new("TextButton")
	HideGuiBindButton.Size = UDim2.new(1, -36, 0, 20)
	HideGuiBindButton.Position = UDim2.new(0, 18, 0, 22)
	HideGuiBindButton.BackgroundTransparency = 1
	HideGuiBindButton.TextColor3 = Color3.fromRGB(255,255,255)
	HideGuiBindButton.Font = Enum.Font.Gotham
	HideGuiBindButton.TextSize = 14
	HideGuiBindButton.TextXAlignment = Enum.TextXAlignment.Left
	HideGuiBindButton.AutoButtonColor = false
	HideGuiBindButton.Parent = PcFunctionsPage
	noTextStroke(HideGuiBindButton)
	setTargetTransparency(HideGuiBindButton, 1, 0)

	ToggleBindButton = Instance.new("TextButton")
	ToggleBindButton.Size = UDim2.new(1, -36, 0, 20)
	ToggleBindButton.Position = UDim2.new(0, 18, 0, 42)
	ToggleBindButton.BackgroundTransparency = 1
	ToggleBindButton.TextColor3 = Color3.fromRGB(255,255,255)
	ToggleBindButton.Font = Enum.Font.Gotham
	ToggleBindButton.TextSize = 14
	ToggleBindButton.TextXAlignment = Enum.TextXAlignment.Left
	ToggleBindButton.AutoButtonColor = false
	ToggleBindButton.Parent = PcFunctionsPage
	noTextStroke(ToggleBindButton)
	setTargetTransparency(ToggleBindButton, 1, 0)

	BeastSlowBindButton = Instance.new("TextButton")
	BeastSlowBindButton.Size = UDim2.new(1, -36, 0, 20)
	BeastSlowBindButton.Position = UDim2.new(0, 18, 0, 102)
	BeastSlowBindButton.BackgroundTransparency = 1
	BeastSlowBindButton.TextColor3 = Color3.fromRGB(255,255,255)
	BeastSlowBindButton.Font = Enum.Font.Gotham
	BeastSlowBindButton.TextSize = 14
	BeastSlowBindButton.TextXAlignment = Enum.TextXAlignment.Left
	BeastSlowBindButton.AutoButtonColor = false
	BeastSlowBindButton.Parent = PcFunctionsPage
	noTextStroke(BeastSlowBindButton)
	setTargetTransparency(BeastSlowBindButton, 1, 0)

	CornerWalkBindButton = Instance.new("TextButton")
	CornerWalkBindButton.Size = UDim2.new(1, -36, 0, 20)
	CornerWalkBindButton.Position = UDim2.new(0, 18, 0, 82)
	CornerWalkBindButton.BackgroundTransparency = 1
	CornerWalkBindButton.TextColor3 = Color3.fromRGB(255,255,255)
	CornerWalkBindButton.Font = Enum.Font.Gotham
	CornerWalkBindButton.TextSize = 14
	CornerWalkBindButton.TextXAlignment = Enum.TextXAlignment.Left
	CornerWalkBindButton.AutoButtonColor = false
	CornerWalkBindButton.Parent = PcFunctionsPage
	noTextStroke(CornerWalkBindButton)
	setTargetTransparency(CornerWalkBindButton, 1, 0)

	XrayBindButton = Instance.new("TextButton")
	XrayBindButton.Size = UDim2.new(1, -36, 0, 20)
	XrayBindButton.Position = UDim2.new(0, 18, 0, 62)
	XrayBindButton.BackgroundTransparency = 1
	XrayBindButton.TextColor3 = Color3.fromRGB(255,255,255)
	XrayBindButton.Font = Enum.Font.Gotham
	XrayBindButton.TextSize = 14
	XrayBindButton.TextXAlignment = Enum.TextXAlignment.Left
	XrayBindButton.AutoButtonColor = false
	XrayBindButton.Parent = PcFunctionsPage
	noTextStroke(XrayBindButton)
	setTargetTransparency(XrayBindButton, 1, 0)

	RealXrayBindButton = Instance.new("TextButton")
	RealXrayBindButton.Size = UDim2.new(1, -36, 0, 20)
	RealXrayBindButton.Position = UDim2.new(0, 18, 0, 122)
	RealXrayBindButton.BackgroundTransparency = 1
	RealXrayBindButton.TextColor3 = Color3.fromRGB(255,255,255)
	RealXrayBindButton.Font = Enum.Font.Gotham
	RealXrayBindButton.TextSize = 14
	RealXrayBindButton.TextXAlignment = Enum.TextXAlignment.Left
	RealXrayBindButton.AutoButtonColor = false
	RealXrayBindButton.Parent = PcFunctionsPage
	noTextStroke(RealXrayBindButton)
	setTargetTransparency(RealXrayBindButton, 1, 0)

	ClipDance2BindButton = Instance.new("TextButton")
	ClipDance2BindButton.Size = UDim2.new(1, -36, 0, 20)
	ClipDance2BindButton.Position = UDim2.new(0, 18, 0, 142)
	ClipDance2BindButton.BackgroundTransparency = 1
	ClipDance2BindButton.TextColor3 = Color3.fromRGB(255,255,255)
	ClipDance2BindButton.Font = Enum.Font.Gotham
	ClipDance2BindButton.TextSize = 14
	ClipDance2BindButton.TextXAlignment = Enum.TextXAlignment.Left
	ClipDance2BindButton.AutoButtonColor = false
	ClipDance2BindButton.Parent = PcFunctionsPage
	noTextStroke(ClipDance2BindButton)
	setTargetTransparency(ClipDance2BindButton, 1, 0)

	FloorbangEspBindButton = Instance.new("TextButton")
	FloorbangEspBindButton.Size = UDim2.new(1, -36, 0, 20)
	FloorbangEspBindButton.Position = UDim2.new(0, 18, 0, 162)
	FloorbangEspBindButton.BackgroundTransparency = 1
	FloorbangEspBindButton.TextColor3 = Color3.fromRGB(255,255,255)
	FloorbangEspBindButton.Font = Enum.Font.Gotham
	FloorbangEspBindButton.TextSize = 14
	FloorbangEspBindButton.TextXAlignment = Enum.TextXAlignment.Left
	FloorbangEspBindButton.AutoButtonColor = false
	FloorbangEspBindButton.Parent = PcFunctionsPage
	noTextStroke(FloorbangEspBindButton)
	setTargetTransparency(FloorbangEspBindButton, 1, 0)

	PcMinimalSettingsTitle = Instance.new("TextLabel")
	PcMinimalSettingsTitle.Size = UDim2.new(1, -36, 0, 20)
	PcMinimalSettingsTitle.Position = UDim2.new(0, 18, 0, 0)
	PcMinimalSettingsTitle.BackgroundTransparency = 1
	PcMinimalSettingsTitle.Text = "Minimal Settings"
	PcMinimalSettingsTitle.TextColor3 = Color3.fromRGB(255,255,255)
	PcMinimalSettingsTitle.Font = Enum.Font.GothamBold
	PcMinimalSettingsTitle.TextSize = 14
	PcMinimalSettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
	PcMinimalSettingsTitle.Parent = PcSettingsPage
	noTextStroke(PcMinimalSettingsTitle)
	setTargetTransparency(PcMinimalSettingsTitle, 1, 0)

	PcSettingsNonSpamTitle = createSettingsLabel(PcSettingsPage, 30, "Non-spam Time")
	PcSettingsNonSpamTitle.TextSize = 15
	PcSettingsNonSpamTitle.ZIndex = 40
	PcSettingsNonSpamTitle.TextTransparency = 0
	setTargetTransparency(PcSettingsNonSpamTitle, 1, 0)

	PcSettingsNonSpamBox = Instance.new("TextBox")
	PcSettingsNonSpamBox.Size = UDim2.new(0, 62, 0, 28)
	PcSettingsNonSpamBox.Position = UDim2.new(1, -80, 0, 28)
	PcSettingsNonSpamBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	PcSettingsNonSpamBox.TextColor3 = Color3.fromRGB(255,255,255)
	PcSettingsNonSpamBox.Font = Enum.Font.GothamBold
	PcSettingsNonSpamBox.TextSize = 13
	PcSettingsNonSpamBox.Text = tostring(nonSpamValue) .. "ms"
	PcSettingsNonSpamBox.ClearTextOnFocus = true
	PcSettingsNonSpamBox.ZIndex = 41
	PcSettingsNonSpamBox.Parent = PcSettingsPage
	Instance.new("UICorner", PcSettingsNonSpamBox).CornerRadius = UDim.new(0, 8)
	PcSettingsNonSpamBoxStroke = Instance.new("UIStroke")
	PcSettingsNonSpamBoxStroke.Color = Color3.fromRGB(35,35,35)
	PcSettingsNonSpamBoxStroke.Thickness = 1
	PcSettingsNonSpamBoxStroke.Transparency = 0.08
	PcSettingsNonSpamBoxStroke.Parent = PcSettingsNonSpamBox
	noTextStroke(PcSettingsNonSpamBox)
	setTargetTransparency(PcSettingsNonSpamBox, 0, 0)
	PcSettingsNonSpamBox.FocusLost:Connect(function()
		applyNonSpamSettingFromBox(PcSettingsNonSpamBox)
	end)

	PcSettingsNonSpamAfterTitle = createSettingsLabel(PcSettingsPage, 60, "Non-spam After")
	PcSettingsNonSpamAfterTitle.TextSize = 15
	PcSettingsNonSpamAfterTitle.ZIndex = 40
	PcSettingsNonSpamAfterTitle.TextTransparency = 0
	setTargetTransparency(PcSettingsNonSpamAfterTitle, 1, 0)

	PcSettingsNonSpamAfterBox = Instance.new("TextBox")
	PcSettingsNonSpamAfterBox.Size = UDim2.new(0, 62, 0, 28)
	PcSettingsNonSpamAfterBox.Position = UDim2.new(1, -80, 0, 58)
	PcSettingsNonSpamAfterBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	PcSettingsNonSpamAfterBox.TextColor3 = Color3.fromRGB(255,255,255)
	PcSettingsNonSpamAfterBox.Font = Enum.Font.GothamBold
	PcSettingsNonSpamAfterBox.TextSize = 13
	PcSettingsNonSpamAfterBox.Text = tostring(nonSpamAfterValue) .. "wh"
	PcSettingsNonSpamAfterBox.ClearTextOnFocus = true
	PcSettingsNonSpamAfterBox.ZIndex = 41
	PcSettingsNonSpamAfterBox.Parent = PcSettingsPage
	Instance.new("UICorner", PcSettingsNonSpamAfterBox).CornerRadius = UDim.new(0, 8)
	PcSettingsNonSpamAfterBoxStroke = Instance.new("UIStroke")
	PcSettingsNonSpamAfterBoxStroke.Color = Color3.fromRGB(35,35,35)
	PcSettingsNonSpamAfterBoxStroke.Thickness = 1
	PcSettingsNonSpamAfterBoxStroke.Transparency = 0.08
	PcSettingsNonSpamAfterBoxStroke.Parent = PcSettingsNonSpamAfterBox
	noTextStroke(PcSettingsNonSpamAfterBox)
	setTargetTransparency(PcSettingsNonSpamAfterBox, 0, 0)
	PcSettingsNonSpamAfterBox.FocusLost:Connect(function()
		applyNonSpamAfterSettingFromBox(PcSettingsNonSpamAfterBox)
	end)

	PcDance2TimeTitle = createSettingsLabel(PcSettingsPage, 90, "Dance2 Time")
	PcDance2TimeTitle.TextSize = 15
	PcDance2TimeTitle.ZIndex = 40
	PcDance2TimeTitle.TextTransparency = 0
	setTargetTransparency(PcDance2TimeTitle, 1, 0)

	PcDance2TimeBox = Instance.new("TextBox")
	PcDance2TimeBox.Size = UDim2.new(0, 62, 0, 28)
	PcDance2TimeBox.Position = UDim2.new(1, -80, 0, 88)
	PcDance2TimeBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	PcDance2TimeBox.TextColor3 = Color3.fromRGB(255,255,255)
	PcDance2TimeBox.Font = Enum.Font.GothamBold
	PcDance2TimeBox.TextSize = 13
	PcDance2TimeBox.Text = tostring(dance2TimeValue) .. "ms"
	PcDance2TimeBox.ClearTextOnFocus = true
	PcDance2TimeBox.ZIndex = 41
	PcDance2TimeBox.Parent = PcSettingsPage
	Instance.new("UICorner", PcDance2TimeBox).CornerRadius = UDim.new(0, 8)
	PcDance2TimeBoxStroke = Instance.new("UIStroke")
	PcDance2TimeBoxStroke.Color = Color3.fromRGB(35,35,35)
	PcDance2TimeBoxStroke.Thickness = 1
	PcDance2TimeBoxStroke.Transparency = 0.08
	PcDance2TimeBoxStroke.Parent = PcDance2TimeBox
	noTextStroke(PcDance2TimeBox)
	setTargetTransparency(PcDance2TimeBox, 0, 0)
	PcDance2TimeBox.FocusLost:Connect(function()
		applyDance2TimeSettingFromBox(PcDance2TimeBox)
	end)

	PcCwalkRangeTitle = createSettingsLabel(PcSettingsPage, 120, "C-walk Range")
	PcCwalkRangeTitle.TextSize = 15
	PcCwalkRangeTitle.ZIndex = 40
	PcCwalkRangeTitle.TextTransparency = 0
	setTargetTransparency(PcCwalkRangeTitle, 1, 0)

	PcCwalkRangeBox = Instance.new("TextBox")
	PcCwalkRangeBox.Size = UDim2.new(0, 62, 0, 28)
	PcCwalkRangeBox.Position = UDim2.new(1, -80, 0, 118)
	PcCwalkRangeBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	PcCwalkRangeBox.TextColor3 = Color3.fromRGB(255,255,255)
	PcCwalkRangeBox.Font = Enum.Font.GothamBold
	PcCwalkRangeBox.TextSize = 13
	PcCwalkRangeBox.Text = tostring(cwalkRangeValue) .. "sd"
	PcCwalkRangeBox.ClearTextOnFocus = true
	PcCwalkRangeBox.ZIndex = 41
	PcCwalkRangeBox.Parent = PcSettingsPage
	Instance.new("UICorner", PcCwalkRangeBox).CornerRadius = UDim.new(0, 8)
	PcCwalkRangeBoxStroke = Instance.new("UIStroke")
	PcCwalkRangeBoxStroke.Color = Color3.fromRGB(35,35,35)
	PcCwalkRangeBoxStroke.Thickness = 1
	PcCwalkRangeBoxStroke.Transparency = 0.08
	PcCwalkRangeBoxStroke.Parent = PcCwalkRangeBox
	noTextStroke(PcCwalkRangeBox)
	setTargetTransparency(PcCwalkRangeBox, 0, 0)
	PcCwalkRangeBox.FocusLost:Connect(function()
		applyCwalkRangeSettingFromBox(PcCwalkRangeBox)
	end)

	PcSettingsXrayTitle = createSettingsLabel(PcSettingsPage, 150, "X-ray Opacity")
	PcSettingsXrayTitle.TextSize = 15
	PcSettingsXrayTitle.ZIndex = 40
	PcSettingsXrayTitle.TextTransparency = 0
	setTargetTransparency(PcSettingsXrayTitle, 1, 0)

	PcSettingsXrayBox = Instance.new("TextBox")
	PcSettingsXrayBox.Size = UDim2.new(0, 62, 0, 28)
	PcSettingsXrayBox.Position = UDim2.new(1, -80, 0, 148)
	PcSettingsXrayBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	PcSettingsXrayBox.TextColor3 = Color3.fromRGB(255,255,255)
	PcSettingsXrayBox.Font = Enum.Font.GothamBold
	PcSettingsXrayBox.TextSize = 13
	PcSettingsXrayBox.Text = tostring(xrayOpacityValue) .. "%"
	PcSettingsXrayBox.ClearTextOnFocus = true
	PcSettingsXrayBox.ZIndex = 41
	PcSettingsXrayBox.Parent = PcSettingsPage
	Instance.new("UICorner", PcSettingsXrayBox).CornerRadius = UDim.new(0, 8)
	PcSettingsXrayBoxStroke = Instance.new("UIStroke")
	PcSettingsXrayBoxStroke.Color = Color3.fromRGB(35,35,35)
	PcSettingsXrayBoxStroke.Thickness = 1
	PcSettingsXrayBoxStroke.Transparency = 0.08
	PcSettingsXrayBoxStroke.Parent = PcSettingsXrayBox
	noTextStroke(PcSettingsXrayBox)
	setTargetTransparency(PcSettingsXrayBox, 0, 0)
	PcSettingsXrayBox.FocusLost:Connect(function()
		applyXraySettingFromBox(PcSettingsXrayBox)
	end)

	PcFlickTypesTitle = Instance.new("TextLabel")
	PcFlickTypesTitle.Size = UDim2.new(1, -36, 0, 20)
	PcFlickTypesTitle.Position = UDim2.new(0, 18, 0, 0)
	PcFlickTypesTitle.BackgroundTransparency = 1
	PcFlickTypesTitle.Text = "Flick Types"
	PcFlickTypesTitle.TextColor3 = Color3.fromRGB(255,255,255)
	PcFlickTypesTitle.Font = Enum.Font.GothamBold
	PcFlickTypesTitle.TextSize = 14
	PcFlickTypesTitle.TextXAlignment = Enum.TextXAlignment.Left
	PcFlickTypesTitle.Parent = PcFlicksPage
	noTextStroke(PcFlickTypesTitle)
	setTargetTransparency(PcFlickTypesTitle, 1, 0)

	PcNormalWallhopButton = createPcActionButton(PcFlicksPage, 24, "Normal Wallhop")
	PcNoMoveWallhopButton = createPcActionButton(PcFlicksPage, 52, "Visual Wallhop")
	Pc360WallhopButton = createPcActionButton(PcFlicksPage, 80, "360° Wallhop")
	PcConsoleWallhopButton = createPcActionButton(PcFlicksPage, 108, "Console Wallhop")

	PcFlickSettingsTitle = Instance.new("TextLabel")
	PcFlickSettingsTitle.Size = UDim2.new(1, -36, 0, 20)
	PcFlickSettingsTitle.Position = UDim2.new(0, 18, 0, 140)
	PcFlickSettingsTitle.BackgroundTransparency = 1
	PcFlickSettingsTitle.Text = "Flick Settings"
	PcFlickSettingsTitle.TextColor3 = Color3.fromRGB(255,255,255)
	PcFlickSettingsTitle.Font = Enum.Font.GothamBold
	PcFlickSettingsTitle.TextSize = 14
	PcFlickSettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
	PcFlickSettingsTitle.Parent = PcFlicksPage
	noTextStroke(PcFlickSettingsTitle)
	setTargetTransparency(PcFlickSettingsTitle, 1, 0)

	PcNormalFlickButton = createPcActionButton(PcFlicksPage, 164, "Normal Flick")
	PcSpeedFlickButton = createPcActionButton(PcFlicksPage, 192, "Speed Flick")
	PcSlowFlickButton = createPcActionButton(PcFlicksPage, 220, "Slow Flick")

	PcCurrentUsingLabel = Instance.new("TextLabel")
	PcCurrentUsingLabel.Size = UDim2.new(1, -36, 0, 32)
	PcCurrentUsingLabel.Position = UDim2.new(0, 18, 0, 250)
	PcCurrentUsingLabel.BackgroundTransparency = 1
	PcCurrentUsingLabel.TextColor3 = Color3.fromRGB(200,200,200)
	PcCurrentUsingLabel.Font = Enum.Font.Gotham
	PcCurrentUsingLabel.TextSize = 12
	PcCurrentUsingLabel.TextWrapped = true
	PcCurrentUsingLabel.TextXAlignment = Enum.TextXAlignment.Left
	PcCurrentUsingLabel.TextYAlignment = Enum.TextYAlignment.Top
	PcCurrentUsingLabel.Parent = PcFlicksPage
	noTextStroke(PcCurrentUsingLabel)
	setTargetTransparency(PcCurrentUsingLabel, 1, 0)

	local footer = Instance.new("TextLabel")
	footer.Name = "PcFooter"
	footer.Size = UDim2.new(1, -36, 0, 14)
	footer.Position = UDim2.new(0, 18, 1, -14)
	footer.BackgroundTransparency = 1
	footer.Text = ""
	footer.TextColor3 = Color3.fromRGB(95,95,95)
	footer.Font = Enum.Font.Gotham
	footer.TextSize = 11
	footer.TextXAlignment = Enum.TextXAlignment.Left
	footer.Visible = false
	footer.Parent = MainFrame
	noTextStroke(footer)
	setTargetTransparency(footer, 1, 0)

	MiniButton = Instance.new("TextButton")
	MiniButton.Size = UDim2.new(0, 150, 0, 42)
	MiniButton.Position = MainFrame.Position
	MiniButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MiniButton.Text = "Cerber X"
	MiniButton.TextColor3 = Color3.fromRGB(220,220,220)
	MiniButton.Font = Enum.Font.GothamBold
	MiniButton.TextSize = 22
	MiniButton.Visible = false
	MiniButton.AutoButtonColor = false
	MiniButton.Parent = ScreenGui
	Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(1, 0)
	noTextStroke(MiniButton)
	addTrueRoundedShadow(MiniButton, 999, 1.1, Color3.fromRGB(0, 0, 0))
	setTargetTransparency(MiniButton, 0, 0)

	Notice = Instance.new("TextLabel")
	Notice.Size = UDim2.new(0, 230, 0, 30)
	Notice.Position = UDim2.new(1, -14, 0, 14)
	Notice.AnchorPoint = Vector2.new(1, 0)
	Notice.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Notice.BackgroundTransparency = 1
	Notice.TextColor3 = Color3.fromRGB(255,255,255)
	Notice.TextTransparency = 1
	Notice.Font = Enum.Font.GothamBold
	Notice.TextSize = 11
	Notice.TextWrapped = false
	Notice.TextXAlignment = Enum.TextXAlignment.Left
	Notice.TextYAlignment = Enum.TextYAlignment.Center
	Notice.ClipsDescendants = true
	Notice.ZIndex = 90
	Notice.Visible = false
	Notice.Parent = ScreenGui
	Instance.new("UICorner", Notice).CornerRadius = UDim.new(0, 10)
	local noticePadding = Instance.new("UIPadding")
	noticePadding.PaddingLeft = UDim.new(0, 8)
	noticePadding.PaddingRight = UDim.new(0, 8)
	noticePadding.PaddingTop = UDim.new(0, 2)
	noticePadding.Parent = Notice
	noTextStroke(Notice)
	setTargetTransparency(Notice, 0.08, 0)

	NoticeBar = Instance.new("Frame")
	NoticeBar.Size = UDim2.new(1, -12, 0, 2)
	NoticeBar.Position = UDim2.new(0, 6, 1, -4)
	NoticeBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
	NoticeBar.BackgroundTransparency = 0
	NoticeBar.BorderSizePixel = 0
	NoticeBar.ZIndex = 91
	NoticeBar.Parent = Notice
	Instance.new("UICorner", NoticeBar).CornerRadius = UDim.new(1, 0)

	NoticeStroke = Instance.new("UIStroke")
	NoticeStroke.Color = Color3.fromRGB(255,255,255)
	NoticeStroke.Thickness = 1
	NoticeStroke.Transparency = 1
	NoticeStroke.Parent = Notice

	MinimizeButton.MouseButton1Click:Connect(function()
		setMinimized(true)
	end)

	MiniButton.MouseButton1Click:Connect(function()
		setMinimized(false)
	end)

	PcTabFunctions.MouseButton1Click:Connect(function()
		switchPcTab("Functions")
	end)

	PcTabFlicks.MouseButton1Click:Connect(function()
		switchPcTab("Flicks")
	end)

	PcTabSettings.MouseButton1Click:Connect(function()
		switchPcTab("Settings")
	end)

	if ClipDance2BindButton then
		ClipDance2BindButton.MouseButton1Click:Connect(function()
			waitingForClipDance2Key = true
			waitingForHideKey = false
			waitingForToggleKey = false
			waitingForBeastSlowKey = false
			waitingForCornerWalkKey = false
			waitingForXrayKey = false
			waitingForNonSpamKey = false
			waitingForFloorbangEspKey = false
			updateBindButtons()
			showNotice("Press a key...")
		end)
	end

	if FloorbangEspBindButton then
		FloorbangEspBindButton.MouseButton1Click:Connect(function()
			waitingForFloorbangEspKey = true
			waitingForHideKey = false
			waitingForToggleKey = false
			waitingForBeastSlowKey = false
			waitingForCornerWalkKey = false
			waitingForXrayKey = false
			waitingForNonSpamKey = false
			waitingForClipDance2Key = false
			waitingForFloorbangEspKey = false
			updateBindButtons()
			showNotice("Press a key...")
		end)
	end

	HideGuiBindButton.MouseButton1Click:Connect(function()
		waitingForHideKey = true
		waitingForToggleKey = false
		waitingForBeastSlowKey = false
		waitingForCornerWalkKey = false
		waitingForXrayKey = false
		waitingForNonSpamKey = false
		waitingForClipDance2Key = false
		waitingForFloorbangEspKey = false
		updateBindButtons()
		showNotice("Press a key...")
	end)

	ToggleBindButton.MouseButton1Click:Connect(function()
		waitingForToggleKey = true
		waitingForHideKey = false
		waitingForBeastSlowKey = false
		waitingForCornerWalkKey = false
		waitingForXrayKey = false
		waitingForNonSpamKey = false
		waitingForClipDance2Key = false
		waitingForFloorbangEspKey = false
		updateBindButtons()
		showNotice("Press a key...")
	end)

	BeastSlowBindButton.MouseButton1Click:Connect(function()
		waitingForBeastSlowKey = true
		waitingForHideKey = false
		waitingForToggleKey = false
		waitingForCornerWalkKey = false
		waitingForXrayKey = false
		waitingForNonSpamKey = false
		waitingForClipDance2Key = false
		waitingForFloorbangEspKey = false
		updateBindButtons()
		showNotice("Press a key...")
	end)

	CornerWalkBindButton.MouseButton1Click:Connect(function()
		waitingForCornerWalkKey = true
		waitingForHideKey = false
		waitingForToggleKey = false
		waitingForBeastSlowKey = false
		waitingForXrayKey = false
		waitingForNonSpamKey = false
		waitingForClipDance2Key = false
		waitingForFloorbangEspKey = false
		updateBindButtons()
		showNotice("Press a key...")
	end)

	XrayBindButton.MouseButton1Click:Connect(function()
		waitingForNonSpamKey = true
		waitingForHideKey = false
		waitingForToggleKey = false
		waitingForBeastSlowKey = false
		waitingForCornerWalkKey = false
		waitingForXrayKey = false
		updateBindButtons()
		showNotice("Press a key...")
	end)

	RealXrayBindButton.MouseButton1Click:Connect(function()
		waitingForXrayKey = true
		waitingForHideKey = false
		waitingForToggleKey = false
		waitingForBeastSlowKey = false
		waitingForCornerWalkKey = false
		waitingForNonSpamKey = false
		waitingForClipDance2Key = false
		waitingForFloorbangEspKey = false
		updateBindButtons()
		showNotice("Press a key...")
	end)

	ToggleButton.MouseButton1Click:Connect(function()
		isWallHopEnabled = not isWallHopEnabled
		updateToggleButton()
		saveUserPreferences()
		showNotice(isWallHopEnabled and "Wallhop enabled" or "Wallhop disabled")
	end)

	PcNormalWallhopButton.MouseButton1Click:Connect(function()
		setFlickMode("Normal Wallhop")
	end)

	PcNoMoveWallhopButton.MouseButton1Click:Connect(function()
		setFlickMode("Visual Wallhop")
	end)

	Pc360WallhopButton.MouseButton1Click:Connect(function()
		setFlickMode("360° Wallhop")
	end)

	PcConsoleWallhopButton.MouseButton1Click:Connect(function()
		setFlickMode("Console Wallhop")
	end)

	PcNormalFlickButton.MouseButton1Click:Connect(function()
		setFlickSetting("Normal Flick")
	end)

	PcSpeedFlickButton.MouseButton1Click:Connect(function()
		setFlickSetting("Speed Flick")
	end)

	PcSlowFlickButton.MouseButton1Click:Connect(function()
		setFlickSetting("Slow Flick")
	end)

	switchPcTab("Functions")
	updateBindButtons()
	updateToggleButton()
	updateFlickButtons()
	updateSettingsInputs()
	if realXrayEnabled then
		applyXray()
	end
	elegantShow(MainFrame, UDim2.new(0, 335, 0, 300), MainFrame.Position, 0)
	showNotice("PC version loaded")
end

clearScriptSlowInstant = function()
	slowToken += 1
	scriptSlowActive = false

	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChild("Humanoid")
	if hum and hum.Parent and hum.WalkSpeed == SLOW_WALKSPEED then
		hum.WalkSpeed = DEFAULT_WALKSPEED
	end
end

local function applyWallhopSlow(hum)
	if not hum or not hum.Parent or not isSlowEnabled then
		return
	end

	slowToken += 1
	local myToken = slowToken

	scriptSlowActive = true
	hum.WalkSpeed = SLOW_WALKSPEED

	task.delay(SLOW_DURATION, function()
		if not hum or not hum.Parent then
			scriptSlowActive = false
			return
		end

		if myToken ~= slowToken then
			return
		end

		scriptSlowActive = false

		if not isSlowEnabled then
			return
		end

		if hum.WalkSpeed == SLOW_WALKSPEED then
			hum.WalkSpeed = DEFAULT_WALKSPEED
		end
	end)
end

local function isCrouching(hum, hrp)
	if not hum or not hrp then
		return false
	end

	if scriptSlowActive then
		return false
	end

	local horizontalSpeed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
	return hum.WalkSpeed <= 9 and horizontalSpeed < 8
end

local function setupCharacter(char)
	local hum = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")

	slowToken = 0
	scriptSlowActive = false

	hum.StateChanged:Connect(function(_, new)
		if new == Enum.HumanoidStateType.Jumping then
			jumpedRecently = true
			airborneSource = "jump"
			airborneStartY = hrp.Position.Y
			airborneStartTime = tick()
		end

		if new == Enum.HumanoidStateType.Freefall then
			canDoubleJump = true

			if airborneSource == nil then
				if jumpedRecently then
					airborneSource = "jump"
				else
					airborneSource = "ledge"
				end

				airborneStartY = hrp.Position.Y
				airborneStartTime = tick()
			end
		end

		if new == Enum.HumanoidStateType.Landed then
			canDoubleJump = false
			lastHitPosition = nil
			airborneSource = nil
			airborneStartY = nil
			airborneStartTime = 0
			jumpedRecently = false

			lastLandedTime = tick()
			hasWallhoppedSinceLanding = false
			specialFirstFlickArmed = false
		end
	end)
end

if LocalPlayer.Character then
	setupCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

UserInputService.JumpRequest:Connect(function()
	if not isThisScriptActive() then
		return
	end

	if not isWallHopEnabled or blockDoubleJump then
		return
	end

	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChild("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then
		return
	end

	local stillValid = isWallHopping or (tick() - lastWallHopTime <= WALLHOP_GRACE_TIME)
	if not stillValid then
		return
	end

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

local jumpAnimToken = 0
local rotationLockToken = 0
local activeJumpTrack = nil

local function playWallhopArmPulse(hum)
	if not hum or not hum.Parent then
		return
	end

	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = hum
	end

	if activeJumpTrack then
		pcall(function()
			activeJumpTrack:Stop(0.02)
			activeJumpTrack:Destroy()
		end)
		activeJumpTrack = nil
	end

	local anim = Instance.new("Animation")
	anim.AnimationId = hum.RigType == Enum.HumanoidRigType.R15
		and "rbxassetid://507765000"
		or "rbxassetid://125750702"

	local ok, track = pcall(function()
		return animator:LoadAnimation(anim)
	end)

	if not ok or not track then
		anim:Destroy()
		return
	end

	activeJumpTrack = track
	track.Priority = Enum.AnimationPriority.Action
	track.Looped = false
	track:Play(0.025, 1, 1.25)

	task.delay(0.34, function()
		if activeJumpTrack == track then
			pcall(function()
				track:Stop(0.08)
				track:Destroy()
			end)
			activeJumpTrack = nil
		end
		pcall(function()
			anim:Destroy()
		end)
	end)
end

local function lockBodyRotation(hum, duration)
	if not hum or not hum.Parent then
		return
	end

	rotationLockToken += 1
	local myToken = rotationLockToken
	local oldAutoRotate = hum.AutoRotate

	hum.AutoRotate = false

	task.delay(duration or 0.35, function()
		if myToken ~= rotationLockToken then
			return
		end
		if hum and hum.Parent then
			hum.AutoRotate = oldAutoRotate
		end
	end)
end

local function forceWallhopJump(hum)
	if not hum or not hum.Parent then
		return
	end

	jumpAnimToken += 1
	local myToken = jumpAnimToken

	playWallhopArmPulse(hum)

	pcall(function()
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end)

	task.delay(0.085, function()
		if myToken ~= jumpAnimToken then
			return
		end

		if hum and hum.Parent then
			local state = hum:GetState()
			if state == Enum.HumanoidStateType.Jumping then
				pcall(function()
					hum:ChangeState(Enum.HumanoidStateType.Freefall)
				end)
			end
		end
	end)
end

local function pickNextFlick(useSpecialFirst)
	local minAngle, maxAngle

	if useSpecialFirst then
		minAngle, maxAngle = 80, 100
	else
		minAngle, maxAngle = 80, 100
	end

	local attempt = 0
	local angle

	repeat
		angle = math.random(minAngle, maxAngle)
		attempt += 1
	until not lastFlickAngle or math.abs(angle - lastFlickAngle) >= 10 or attempt > 20

	lastFlickAngle = angle
	return math.rad(angle)
end

local function getFlickSettingSpeedScale()
	if currentFlickSetting == "Speed Flick" then
		return 0.78
	elseif currentFlickSetting == "Slow Flick" then
		return 1.24
	end
	return 1
end

local function getFlickSettingStepAdd()
	if currentFlickSetting == "Speed Flick" then
		return 0
	elseif currentFlickSetting == "Slow Flick" then
		return 1
	end
	return 0
end

local function applyFlickSettingProfile(profile)
	local scale = getFlickSettingSpeedScale()
	local stepAdd = getFlickSettingStepAdd()

	profile.goSteps = math.max(1, (tonumber(profile.goSteps) or 1) + stepAdd)
	profile.returnSteps = math.max(1, (tonumber(profile.returnSteps) or 1) + stepAdd)
	profile.goDelayMin = (tonumber(profile.goDelayMin) or 0) * scale
	profile.goDelayMax = (tonumber(profile.goDelayMax) or 0) * scale
	profile.returnDelayMin = (tonumber(profile.returnDelayMin) or 0) * scale
	profile.returnDelayMax = (tonumber(profile.returnDelayMax) or 0) * scale
	profile.holdTime = (tonumber(profile.holdTime) or 0) * (currentFlickSetting == "Speed Flick" and 0.55 or currentFlickSetting == "Slow Flick" and 1.35 or 1)
	profile.overshootBaseDelay = (tonumber(profile.overshootBaseDelay) or 0) * scale

	return profile
end

local function getFlickProfile(useSpecialFirst)
	if useSpecialFirst then
		return applyFlickSettingProfile({
			goSteps = math.random(3, 4),
			goDelayMin = 0.0130,
			goDelayMax = 0.0165,
			holdTime = 0.01,
			returnSteps = math.random(2, 3),
			returnDelayMin = 0.0095,
			returnDelayMax = 0.0120,
			overshootMin = 22,
			overshootMax = 25,
			overshootBaseDelay = 0.0085
		})
	end

	local flickRoll = math.random()

	if flickRoll < 0.10 then
		return applyFlickSettingProfile({
			goSteps = math.random(3, 4),
			goDelayMin = 0.0118,
			goDelayMax = 0.0148,
			holdTime = 0.01,
			returnSteps = math.random(2, 3),
			returnDelayMin = 0.0080,
			returnDelayMax = 0.0103,
			overshootMin = 12,
			overshootMax = 18,
			overshootBaseDelay = 0.0068
		})
	elseif flickRoll < 0.40 then
		return applyFlickSettingProfile({
			goSteps = math.random(4, 5),
			goDelayMin = 0.0122,
			goDelayMax = 0.0155,
			holdTime = 0.01,
			returnSteps = math.random(3, 4),
			returnDelayMin = 0.0085,
			returnDelayMax = 0.0110,
			overshootMin = 14,
			overshootMax = 20,
			overshootBaseDelay = 0.0075
		})
	else
		return applyFlickSettingProfile({
			goSteps = math.random(3, 4),
			goDelayMin = 0.0128,
			goDelayMax = 0.0162,
			holdTime = 0.01,
			returnSteps = math.random(2, 3),
			returnDelayMin = 0.0090,
			returnDelayMax = 0.0119,
			overshootMin = 16,
			overshootMax = 22,
			overshootBaseDelay = 0.0085
		})
	end
end


local rotateToken = 0

local function getCameraYaw()
	local look = Camera.CFrame.LookVector
	local flat = Vector3.new(look.X, 0, look.Z)

	if flat.Magnitude <= 0 then
		return nil
	end

	flat = flat.Unit
	return math.atan2(-flat.X, -flat.Z)
end

local function restoreCharacterRotate(hum, hrp, myToken)
	task.delay(0.12, function()
		if myToken ~= rotateToken then
			return
		end

		if hum and hum.Parent then
			pcall(function()
				hum.AutoRotate = true
			end)
		end

		if hrp and hrp.Parent then
			local camYaw = getCameraYaw()
			if camYaw then
				pcall(function()
					hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, camYaw, 0)
				end)
			end
		end
	end)

	task.delay(0.32, function()
		if myToken ~= rotateToken then
			return
		end

		if hum and hum.Parent then
			pcall(function()
				hum.AutoRotate = true
			end)
		end
	end)

	task.delay(0.65, function()
		if myToken ~= rotateToken then
			return
		end

		if hum and hum.Parent then
			pcall(function()
				hum.AutoRotate = true
			end)
		end
	end)
end

local function performNormalWallhop()
	if isFlicking then
		return
	end

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

	rotateToken += 1
	local myRotateToken = rotateToken

	if hum then
		pcall(function()
			hum.AutoRotate = false
		end)
	end

	local useSpecialFirst = specialFirstFlickArmed and not hasWallhoppedSinceLanding
	if useSpecialFirst then
		specialFirstFlickArmed = false
	end
	hasWallhoppedSinceLanding = true

	forceWallhopJump(hum)
	lockBodyRotation(hum, 0.36)
	pcall(function() hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0) end)

	local baseYaw = hrp.Orientation.Y
	local angle = -pickNextFlick(useSpecialFirst)
	local profile = getFlickProfile(useSpecialFirst)

	local goSteps = profile.goSteps
	local goDelayMin = profile.goDelayMin
	local goDelayMax = profile.goDelayMax
	local holdTime = profile.holdTime
	local returnSteps = profile.returnSteps
	local returnDelayMin = profile.returnDelayMin
	local returnDelayMax = profile.returnDelayMax

	local overshoot = math.rad(math.random(profile.overshootMin, profile.overshootMax) + 5)
	local overshootBaseDelay = profile.overshootBaseDelay
	local useOvershoot = math.random() < 0.40

	for i = 1, goSteps do
		local alpha = i / goSteps
		local offset = angle * alpha
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)

		if i < goSteps then
			RunService.RenderStepped:Wait()
			task.wait(goDelayMin + math.random() * (goDelayMax - goDelayMin))
		end
	end

	task.wait(holdTime)

	for i = 1, returnSteps do
		local alpha = i / returnSteps
		local offset = angle * (1 - alpha)
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)

		if i < returnSteps then
			RunService.RenderStepped:Wait()
			task.wait(returnDelayMin + math.random() * (returnDelayMax - returnDelayMin))
		end
	end

	if useOvershoot then
		task.delay(0.018, function()
			if not hrp or not hrp.Parent then
				return
			end

			local smallSteps = math.random(2, 3)
			local localDelay = overshootBaseDelay * (math.random(88, 102) / 100)

			for i = 1, smallSteps do
				local alpha = i / smallSteps
				local offset = overshoot * alpha
				hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)
				if i < smallSteps then
					RunService.RenderStepped:Wait()
					task.wait(localDelay)
				end
			end

			for i = 1, smallSteps do
				local alpha = i / smallSteps
				local offset = overshoot * (1 - alpha)
				hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)
				if i < smallSteps then
					RunService.RenderStepped:Wait()
					task.wait(localDelay)
				end
			end

			hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw), 0)
		end)
	end

	hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw), 0)
	restoreCharacterRotate(hum, hrp, myRotateToken)

	if isSlowEnabled then
		applyWallhopSlow(hum)
	end

	task.delay(0.05, function()
		blockDoubleJump = false
	end)

	task.delay(0.20, function()
		isWallHopping = false
	end)

	isFlicking = false
end


local function apply360FlickSettingProfile(profile)
	local scale = getFlickSettingSpeedScale()
	local stepAdd = currentFlickSetting == "Speed Flick" and -1 or currentFlickSetting == "Slow Flick" and 1 or 0

	profile.steps = math.max(4, (tonumber(profile.steps) or 8) + stepAdd)
	profile.stepDelay = (tonumber(profile.stepDelay) or 0.0042) * scale
	return profile
end

local function get360FlickProfile()
	local flickRoll = math.random()

	if flickRoll < 0.10 then
		return apply360FlickSettingProfile({
			steps = 8,
			stepDelay = 0.0038
		})
	elseif flickRoll < 0.40 then
		return apply360FlickSettingProfile({
			steps = 9,
			stepDelay = 0.0042
		})
	else
		return apply360FlickSettingProfile({
			steps = 10,
			stepDelay = 0.0045
		})
	end
end

local function perform360Wallhop()
	if isFlicking then
		return
	end

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

	rotateToken += 1
	local myRotateToken = rotateToken

	if hum then
		pcall(function()
			hum.AutoRotate = false
		end)
	end

	local useSpecialFirst = specialFirstFlickArmed and not hasWallhoppedSinceLanding
	if useSpecialFirst then
		specialFirstFlickArmed = false
	end
	hasWallhoppedSinceLanding = true

	forceWallhopJump(hum)
	lockBodyRotation(hum, 0.36)
	pcall(function()
		hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end)

	local baseYaw = math.rad(hrp.Orientation.Y)

	-- Alterna a direção:
	-- 1 = começa girando para a direita
	-- -1 = começa girando para a esquerda
	local direction = next360Direction
	next360Direction = -next360Direction

	local profile360 = get360FlickProfile()
	local steps = profile360.steps
	local stepDelay = profile360.stepDelay

	for i = 1, steps do
		if not hrp or not hrp.Parent then
			break
		end

		local alpha = i / steps
		local spin = math.rad(360) * alpha * direction

		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, baseYaw + spin, 0)

		if i < steps then
			RunService.RenderStepped:Wait()
			task.wait(stepDelay)
		end
	end

	-- Para exatamente no centro/yaw inicial, sem dar outro giro.
	if hrp and hrp.Parent then
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, baseYaw, 0)
	end

	restoreCharacterRotate(hum, hrp, myRotateToken)

	if isSlowEnabled then
		applyWallhopSlow(hum)
	end

	task.delay(0.05, function()
		blockDoubleJump = false
	end)

	task.delay(0.20, function()
		isWallHopping = false
	end)

	isFlicking = false
end

local function performNoMoveWallhop()
	if isFlicking then
		return
	end

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

	local useSpecialFirst = specialFirstFlickArmed and not hasWallhoppedSinceLanding
	if useSpecialFirst then
		specialFirstFlickArmed = false
	end
	hasWallhoppedSinceLanding = true

	forceWallhopJump(hum)

	local baseYaw = hrp.Orientation.Y
	local angle = -pickNextFlick(useSpecialFirst)
	local profile = getFlickProfile(useSpecialFirst)

	local goSteps = profile.goSteps
	local goDelayMin = profile.goDelayMin
	local goDelayMax = profile.goDelayMax
	local holdTime = profile.holdTime
	local returnSteps = profile.returnSteps
	local returnDelayMin = profile.returnDelayMin
	local returnDelayMax = profile.returnDelayMax

	local overshoot = math.rad(math.random(profile.overshootMin, profile.overshootMax) + 5)
	local overshootBaseDelay = profile.overshootBaseDelay
	local useOvershoot = math.random() < 0.40

	for i = 1, goSteps do
		local alpha = i / goSteps
		local offset = angle * alpha
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)

		if i < goSteps then
			RunService.RenderStepped:Wait()
			task.wait(goDelayMin + math.random() * (goDelayMax - goDelayMin))
		end
	end

	task.wait(holdTime)

	for i = 1, returnSteps do
		local alpha = i / returnSteps
		local offset = angle * (1 - alpha)
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)

		if i < returnSteps then
			RunService.RenderStepped:Wait()
			task.wait(returnDelayMin + math.random() * (returnDelayMax - returnDelayMin))
		end
	end

	if useOvershoot then
		task.delay(0.018, function()
			if not hrp or not hrp.Parent then
				return
			end

			local smallSteps = math.random(2, 3)
			local localDelay = overshootBaseDelay * (math.random(88, 102) / 100)

			for i = 1, smallSteps do
				local alpha = i / smallSteps
				local offset = overshoot * alpha
				hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)
				if i < smallSteps then
					RunService.RenderStepped:Wait()
					task.wait(localDelay)
				end
			end

			for i = 1, smallSteps do
				local alpha = i / smallSteps
				local offset = overshoot * (1 - alpha)
				hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw) + offset, 0)
				if i < smallSteps then
					RunService.RenderStepped:Wait()
					task.wait(localDelay)
				end
			end

			hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw), 0)
		end)
	end

	hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(baseYaw), 0)

	if isSlowEnabled then
		applyWallhopSlow(hum)
	end

	task.delay(0.05, function()
		blockDoubleJump = false
	end)

	task.delay(0.20, function()
		isWallHopping = false
	end)

	isFlicking = false
end

local function performConsoleWallhop()
	if isFlicking then
		return
	end

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

	rotateToken += 1
	local myRotateToken = rotateToken

	if hum then
		pcall(function()
			hum.AutoRotate = false
		end)
	end

	hasWallhoppedSinceLanding = true
	specialFirstFlickArmed = false

	forceWallhopJump(hum)
	lockBodyRotation(hum, currentFlickSetting == "Speed Flick" and 0.54 or currentFlickSetting == "Slow Flick" and 0.70 or 0.62)
	pcall(function() hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0) end)

	local function getCameraFlat()
		local look = Camera.CFrame.LookVector
		local flat = Vector3.new(look.X, 0, look.Z)
		if flat.Magnitude <= 0 then
			return nil
		end
		return flat.Unit
	end

	local function getYawFromVector(vec)
		return math.atan2(-vec.X, -vec.Z)
	end

	local function wrapAngle(angle)
		return math.atan2(math.sin(angle), math.cos(angle))
	end

	local camFlat = getCameraFlat()
	if camFlat then
		local targetYaw = getYawFromVector(camFlat)
		local flickYaw = targetYaw - math.rad(85)

		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, flickYaw, 0)

		task.spawn(function()
			local returnSteps = currentFlickSetting == "Speed Flick" and 16 or currentFlickSetting == "Slow Flick" and 22 or 20
			local stepDelay = currentFlickSetting == "Speed Flick" and 0.032 or currentFlickSetting == "Slow Flick" and 0.046 or 0.040

			for i = 1, returnSteps do
				if not hrp or not hrp.Parent then
					break
				end

				local liveFlat = getCameraFlat()
				if not liveFlat then
					break
				end

				local liveTargetYaw = getYawFromVector(liveFlat)
				local currentYaw = math.atan2(-hrp.CFrame.LookVector.X, -hrp.CFrame.LookVector.Z)
				local delta = wrapAngle(liveTargetYaw - currentYaw)
				local nextYaw = currentYaw + (delta * (currentFlickSetting == "Speed Flick" and 0.040 or currentFlickSetting == "Slow Flick" and 0.024 or 0.03))

				hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, nextYaw, 0)

				if i < returnSteps then
					RunService.RenderStepped:Wait()
					task.wait(stepDelay)
				end
			end

			if hum and hum.Parent and myRotateToken == rotateToken then
				pcall(function()
					hum.AutoRotate = true
				end)
			end
		end)
	end

	if isSlowEnabled then
		applyWallhopSlow(hum)
	end

	task.delay(0.12, function()
		blockDoubleJump = false
	end)

	restoreCharacterRotate(hum, hrp, myRotateToken)

	task.delay(0.28, function()
		if hum and hum.Parent and myRotateToken == rotateToken then
			pcall(function()
				hum.AutoRotate = true
			end)
		end
	end)

	task.delay(0.45, function()
		isWallHopping = false
	end)

	isFlicking = false
end

local function performSelectedWallhop()
	if currentFlickMode == "Console Wallhop" then
		performConsoleWallhop()
	elseif currentFlickMode == "Visual Wallhop" then
		performNoMoveWallhop()
	elseif currentFlickMode == "360° Wallhop" then
		perform360Wallhop()
	else
		performNormalWallhop()
	end
end

local function isPlayerCharacter(instance)
	if not instance then
		return false
	end

	local model = instance:FindFirstAncestorOfClass("Model")
	return model and model:FindFirstChild("Humanoid")
end

local function isWallLikeSurface(normal)
	return math.abs(normal.Y) < 0.35
end

local function hasValidHorizontalEdge(rayResult, params)
	if not rayResult or not rayResult.Instance then
		return false
	end

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

	return foundHorizontalEdge
end

local function findValidWall(hrp, params, directions)
	local offsets = {
		Vector3.new(0, -2.3, 0),
		Vector3.new(0, -2.2, 0),
		Vector3.new(0, -2.1, 0)
	}

	for _, dir in ipairs(directions) do
		for _, offset in ipairs(offsets) do
			local origin = hrp.Position + offset
			local ray = workspace:Raycast(origin, dir, params)

			if ray and ray.Instance and ray.Instance.CanCollide and not isPlayerCharacter(ray.Instance) then
				if isWallLikeSurface(ray.Normal) and hasValidHorizontalEdge(ray, params) then
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



local cornerWalkAirStart = 0
local cornerWalkFloorPart = nil
local lastCornerWalkTouch = 0

local CORNER_WALK_AIR_TIME = 0.03
CORNER_WALK_WALL_DISTANCE = 1.08
local CORNER_WALK_MIN_MOVE = 0.08
local CORNER_WALK_MIN_REAL_SPEED = 0.45
local CORNER_WALK_FLOOR_THICKNESS = 0.16
local CORNER_WALK_FLOOR_LENGTH = 4.20
local CORNER_WALK_FLOOR_WIDTH = 0.62

local function flatUnit(vec)
	if not vec or vec.Magnitude < 0.05 then
		return nil
	end
	return vec.Unit
end

local function removeCornerWalkFloor()
	if cornerWalkFloorPart then
		pcall(function()
			cornerWalkFloorPart:Destroy()
		end)
	end

	cornerWalkFloorPart = nil
	lastCornerWalkTouch = 0
end

local function getCornerWalkFloor()
	if cornerWalkFloorPart and cornerWalkFloorPart.Parent then
		return cornerWalkFloorPart
	end

	local part = Instance.new("Part")
	part.Name = "CornerWalkArtificialFloor"
	part.Anchored = true
	part.CanCollide = true
	part.CanTouch = false
	part.CanQuery = false
	part.Transparency = 1
	part.CastShadow = false
	part.Material = Enum.Material.SmoothPlastic
	part.Size = Vector3.new(CORNER_WALK_FLOOR_LENGTH, CORNER_WALK_FLOOR_THICKNESS, CORNER_WALK_FLOOR_WIDTH)
	part.Parent = workspace

	cornerWalkFloorPart = part
	return part
end

local function isCornerWalkStateAllowed(hum)
	if not hum then
		return false
	end

	local state = hum:GetState()

	if state == Enum.HumanoidStateType.Dead
		or state == Enum.HumanoidStateType.Seated
		or state == Enum.HumanoidStateType.PlatformStanding
		or state == Enum.HumanoidStateType.Swimming
		or state == Enum.HumanoidStateType.Climbing
		or state == Enum.HumanoidStateType.Jumping then
		removeCornerWalkFloor()
		return false
	end

	if state == Enum.HumanoidStateType.Freefall then
		if cornerWalkAirStart <= 0 then
			cornerWalkAirStart = tick()
		end

		if (tick() - cornerWalkAirStart) > CORNER_WALK_AIR_TIME then
			removeCornerWalkFloor()
			return false
		end

		return true
	end

	cornerWalkAirStart = 0
	return true
end

local function getCornerWalkDirections(hrp, hum)
	local dirs = {}

	local move = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z)
	move = flatUnit(move)

	if move then
		table.insert(dirs, move)
		table.insert(dirs, -move)

		local side = flatUnit(move:Cross(Vector3.new(0, 1, 0)))
		if side then
			table.insert(dirs, side)
			table.insert(dirs, -side)

			local d1 = flatUnit(move + side)
			local d2 = flatUnit(move - side)
			local d3 = flatUnit(-move + side)
			local d4 = flatUnit(-move - side)

			if d1 then table.insert(dirs, d1) end
			if d2 then table.insert(dirs, d2) end
			if d3 then table.insert(dirs, d3) end
			if d4 then table.insert(dirs, d4) end
		end
	end

	return dirs
end

local function findCornerWalkEdge(hrp, hum, params)
	if not hrp or not hum then
		return nil
	end

	local dirs = getCornerWalkDirections(hrp, hum)

	-- Somente a região do pé. Não tem outro offset.
	local footOffset = Vector3.new(0, -2.35, 0)

	local bestRay = nil
	local bestDist = math.huge

	for _, dir in ipairs(dirs) do
		local origin = hrp.Position + footOffset
		local ray = workspace:Raycast(origin, dir * CORNER_WALK_WALL_DISTANCE, params)

		if ray and ray.Instance and ray.Instance.CanCollide and not isPlayerCharacter(ray.Instance) then
			-- Só aceita dobra/edge, não parede lisa.
			if isWallLikeSurface(ray.Normal)
				and hasValidHorizontalEdge(ray, params)
				and isWithinWallhopAngle(Camera.CFrame.LookVector, ray.Normal, 35) then

				local dist = (ray.Position - origin).Magnitude
				if dist < bestDist then
					bestRay = ray
					bestDist = dist
				end
			end
		end
	end

	return bestRay
end

local function updateCornerWalkFloor(hrp, hum, edgeRay)
	if not hrp or not hum or not edgeRay then
		removeCornerWalkFloor()
		return
	end

	if hum.MoveDirection.Magnitude < CORNER_WALK_MIN_MOVE then
		removeCornerWalkFloor()
		return
	end

	local vel = hrp.Velocity
	local horizontalSpeed = Vector3.new(vel.X, 0, vel.Z).Magnitude

	if horizontalSpeed < CORNER_WALK_MIN_REAL_SPEED then
		removeCornerWalkFloor()
		return
	end

	local normal = Vector3.new(edgeRay.Normal.X, 0, edgeRay.Normal.Z)
	normal = flatUnit(normal)
	if not normal then
		removeCornerWalkFloor()
		return
	end

	local tangent = flatUnit(normal:Cross(Vector3.new(0, 1, 0)))
	if not tangent then
		removeCornerWalkFloor()
		return
	end

	local move = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z)
	move = flatUnit(move)
	if move and tangent:Dot(move) < 0 then
		tangent = -tangent
	end

	local floor = getCornerWalkFloor()

	-- A superfície de cima do chão fica exatamente na linha detectada no pé.
	local floorTopY = edgeRay.Position.Y - 0.70
	local floorCenterY = floorTopY - (CORNER_WALK_FLOOR_THICKNESS / 2)

	-- Coloca o chão levemente para fora da parede, na direção do jogador.
	local center = edgeRay.Position + (normal * (CORNER_WALK_FLOOR_WIDTH * 0.45))
	center = Vector3.new(center.X, floorCenterY, center.Z)

	floor.Size = Vector3.new(CORNER_WALK_FLOOR_LENGTH, CORNER_WALK_FLOOR_THICKNESS, CORNER_WALK_FLOOR_WIDTH)
	floor.CFrame = CFrame.fromMatrix(
		center,
		tangent,
		Vector3.new(0, 1, 0),
		normal
	)

	lastCornerWalkTouch = tick()
end

local function runCornerWalk()
	if not isCornerWalkEnabled then
		cornerWalkAirStart = 0
		removeCornerWalkFloor()
		return
	end

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")

	if not char or not hrp or not hum then
		cornerWalkAirStart = 0
		removeCornerWalkFloor()
		return
	end

	if hum.MoveDirection.Magnitude < CORNER_WALK_MIN_MOVE then
		cornerWalkAirStart = 0
		removeCornerWalkFloor()
		return
	end

	local realHorizontalSpeed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
	if realHorizontalSpeed < CORNER_WALK_MIN_REAL_SPEED then
		cornerWalkAirStart = 0
		removeCornerWalkFloor()
		return
	end

	if not isCornerWalkStateAllowed(hum) then
		return
	end

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {char}
	params.FilterType = Enum.RaycastFilterType.Exclude

	local edgeRay = findCornerWalkEdge(hrp, hum, params)
	if not edgeRay then
		removeCornerWalkFloor()
		return
	end

	updateCornerWalkFloor(hrp, hum, edgeRay)
end

RunService.Heartbeat:Connect(function()
	if not isThisScriptActive() then
		removeCornerWalkFloor()
		restoreDance2Noclip()
		return
	end

	runCornerWalk()
end)

RunService.Heartbeat:Connect(function()
	if not isThisScriptActive() then
		return
	end

	if not isWallHopEnabled then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChild("Humanoid")
		if hum and hum.AutoRotate == false then
			pcall(function()
				hum.AutoRotate = true
			end)
		end
		return
	end

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")

	if not hrp or not hum then
		return
	end

	if isCrouching(hum, hrp) then
		return
	end

	local state = hum:GetState()
	local airborne = state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping

	if state == Enum.HumanoidStateType.Landed then
		if not hasWallhoppedSinceLanding and lastLandedTime > 0 and tick() - lastLandedTime >= FIRST_FLICK_RESET_GROUND_TIME then
			specialFirstFlickArmed = true
		end
	end

	if not airborne then
		lastHitPosition = nil
		consecutiveWallhopCount = 0
		applyCurrentNonSpamCooldown()
		return
	end

	local allowWallhop = true

	if airborneSource == "ledge" and airborneStartY then
		local fallDistance = airborneStartY - hrp.Position.Y
		local airTime = tick() - airborneStartTime

		if fallDistance < LEDGE_BLOCK_DISTANCE and airTime < LEDGE_BLOCK_TIME then
			allowWallhop = false
		end
	end

	if not allowWallhop then
		lastHitPosition = nil
		return
	end

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {char}
	params.FilterType = Enum.RaycastFilterType.Exclude

	local look = Camera.CFrame.LookVector
	local horizontal = Vector3.new(look.X, 0, look.Z)

	if horizontal.Magnitude <= 0 then
		lastHitPosition = nil
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
		local validAngle = currentFlickMode == "Console Wallhop"
			or isWithinWallhopAngle(Camera.CFrame.LookVector, result.Normal, 25)

		if validAngle then
			local farEnough = true
			if lastHitPosition then
				farEnough = (result.Position - lastHitPosition).Magnitude >= MIN_HIT_DISTANCE
			end

			local activeCooldown = getEffectiveWallhopCooldown()
			if hrp.Velocity.Y < -0.8 and tick() - lastFlickTime > activeCooldown and farEnough then
				lastFlickTime = tick()
				consecutiveWallhopCount = consecutiveWallhopCount + 1
				applyCurrentNonSpamCooldown()
				lastHitPosition = result.Position
				performSelectedWallhop()
			else
				lastHitPosition = result.Position
			end
		else
			lastHitPosition = nil
		end
	else
		lastHitPosition = nil
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not isThisScriptActive() then
		return
	end

	if gameProcessed then
		return
	end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then
		return
	end

	local key = input.KeyCode

	if selectedMode == "PC" then
		if waitingForHideKey then
			if key ~= toggleScriptKey and key ~= toggleBeastSlowKey and key ~= toggleCornerWalkKey and key ~= toggleXrayKey and key ~= toggleNonSpamKey and key ~= toggleClipDance2Key and key ~= toggleFloorbangEspKey then
				hideGuiKey = key
				waitingForHideKey = false
				savePCKeybinds()
				updateBindButtons()
				showNotice("Hide GUI key updated")
			else
				showNotice("Key already in use")
			end
			return
		end

		if waitingForToggleKey then
			if key ~= hideGuiKey and key ~= toggleBeastSlowKey and key ~= toggleCornerWalkKey and key ~= toggleXrayKey and key ~= toggleNonSpamKey and key ~= toggleClipDance2Key and key ~= toggleFloorbangEspKey then
				toggleScriptKey = key
				waitingForToggleKey = false
				savePCKeybinds()
				updateBindButtons()
				showNotice("Wallhop key updated")
			else
				showNotice("Key already in use")
			end
			return
		end

		if waitingForBeastSlowKey then
			if key ~= hideGuiKey and key ~= toggleScriptKey and key ~= toggleCornerWalkKey and key ~= toggleXrayKey and key ~= toggleNonSpamKey and key ~= toggleClipDance2Key and key ~= toggleFloorbangEspKey then
				toggleBeastSlowKey = key
				waitingForBeastSlowKey = false
				savePCKeybinds()
				updateBindButtons()
				showNotice("Beast Slow key updated")
			else
				showNotice("Key already in use")
			end
			return
		end

		if waitingForCornerWalkKey then
			if key ~= hideGuiKey and key ~= toggleScriptKey and key ~= toggleBeastSlowKey and key ~= toggleXrayKey and key ~= toggleNonSpamKey and key ~= toggleClipDance2Key and key ~= toggleFloorbangEspKey then
				toggleCornerWalkKey = key
				waitingForCornerWalkKey = false
				savePCKeybinds()
				updateBindButtons()
				showNotice("Corner Walk key updated")
			else
				showNotice("Key already in use")
			end
			return
		end

		if waitingForNonSpamKey then
			if key ~= hideGuiKey and key ~= toggleScriptKey and key ~= toggleBeastSlowKey and key ~= toggleCornerWalkKey and key ~= toggleXrayKey and key ~= toggleClipDance2Key and key ~= toggleFloorbangEspKey then
				toggleNonSpamKey = key
				waitingForNonSpamKey = false
				savePCKeybinds()
				updateBindButtons()
				showNotice("Non-spam key updated")
			else
				showNotice("Key already in use")
			end
			return
		end

		if waitingForXrayKey then
			if key ~= hideGuiKey and key ~= toggleScriptKey and key ~= toggleBeastSlowKey and key ~= toggleCornerWalkKey and key ~= toggleNonSpamKey and key ~= toggleClipDance2Key and key ~= toggleFloorbangEspKey then
				toggleXrayKey = key
				waitingForXrayKey = false
				savePCKeybinds()
				updateBindButtons()
				showNotice("X-ray key updated")
			else
				showNotice("Key already in use")
			end
			return
		end

		if waitingForClipDance2Key then
			if key ~= hideGuiKey and key ~= toggleScriptKey and key ~= toggleBeastSlowKey and key ~= toggleCornerWalkKey and key ~= toggleXrayKey and key ~= toggleNonSpamKey and key ~= toggleFloorbangEspKey then
				toggleClipDance2Key = key
				waitingForClipDance2Key = false
				savePCKeybinds()
				updateBindButtons()
				showNotice("Clip Dance2 key updated")
			else
				showNotice("Key already in use")
			end
			return
		end

		if waitingForFloorbangEspKey then
			if key ~= hideGuiKey and key ~= toggleScriptKey and key ~= toggleBeastSlowKey and key ~= toggleCornerWalkKey and key ~= toggleXrayKey and key ~= toggleNonSpamKey and key ~= toggleClipDance2Key then
				toggleFloorbangEspKey = key
				waitingForFloorbangEspKey = false
				savePCKeybinds()
				updateBindButtons()
				showNotice("Floorbang ESP key updated")
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
			saveUserPreferences()
			showNotice(isWallHopEnabled and "Wallhop enabled" or "Wallhop disabled")
			return
		end

		if key == toggleBeastSlowKey then
			setSlowEnabled(not isSlowEnabled)
			saveUserPreferences()
			showNotice(isSlowEnabled and "Beast Slow enabled" or "Beast Slow disabled")
			return
		end

		if key == toggleCornerWalkKey then
			setCornerWalkEnabled(not isCornerWalkEnabled)
			saveUserPreferences()
			showNotice(isCornerWalkEnabled and "Corner Walk enabled" or "Corner Walk disabled")
			return
		end

		if key == toggleNonSpamKey then
			isXrayEnabled = not isXrayEnabled
			applyCurrentNonSpamCooldown()
			updateBindButtons()
			updateMobilePanelButtons()
			saveUserPreferences()
			showNotice(isXrayEnabled and "Non-spam enabled" or "Non-spam disabled")
			return
		end

		if key == toggleClipDance2Key then
			setDance2TurnEnabled(not isDance2TurnEnabled)
			showNotice(isDance2TurnEnabled and "Clip Dance2 enabled" or "Clip Dance2 disabled")
			return
		end

		if key == toggleFloorbangEspKey then
			setFloorbangESPEnabled(not isFloorbangEspEnabled)
			showNotice(isFloorbangEspEnabled and "Floorbang ESP enabled" or "Floorbang ESP disabled")
			return
		end

		if key == toggleXrayKey then
			setXrayEnabled(not realXrayEnabled)
			saveUserPreferences()
			showNotice(realXrayEnabled and "X-ray enabled" or "X-ray disabled")
			return
		end
	end
end)

createModeSelector(function(mode)
	selectedMode = mode

	if mode == "PC" then
		buildPCGui()
	else
		buildMobileGui()
	end

	updateToggleButton()
	updateMobilePanelButtons()
	updateFlickButtons()
	applyVisibility()
	if isFloorbangEspEnabled then
		updateFloorbangESP()
	end
end)

print("Cerber X V1.1 • Loaded Successfully ✅")
