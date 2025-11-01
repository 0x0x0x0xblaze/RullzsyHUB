-- Load Liblary UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Red Dark Theme By RullzsyHUB
local RedDarkTheme = {
    TextColor = Color3.fromRGB(230, 230, 230),
    Background = Color3.fromRGB(15, 15, 18),
    Topbar = Color3.fromRGB(25, 25, 30),
    Shadow = Color3.fromRGB(5, 5, 8),
    NotificationBackground = Color3.fromRGB(25, 25, 30),
    NotificationActionsBackground = Color3.fromRGB(45, 45, 55),
    TabBackground = Color3.fromRGB(20, 20, 25),
    TabStroke = Color3.fromRGB(60, 0, 0),
    TabBackgroundSelected = Color3.fromRGB(120, 0, 0),
    TabTextColor = Color3.fromRGB(220, 180, 180),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
    ElementBackground = Color3.fromRGB(25, 25, 30),
    ElementBackgroundHover = Color3.fromRGB(35, 35, 40),
    SecondaryElementBackground = Color3.fromRGB(18, 18, 22),
    ElementStroke = Color3.fromRGB(60, 0, 0),
    SecondaryElementStroke = Color3.fromRGB(40, 0, 0),
    SliderBackground = Color3.fromRGB(45, 45, 50),
    SliderProgress = Color3.fromRGB(200, 30, 30),
    SliderStroke = Color3.fromRGB(255, 50, 50),
    ToggleBackground = Color3.fromRGB(30, 30, 35),
    ToggleEnabled = Color3.fromRGB(200, 0, 0),
    ToggleDisabled = Color3.fromRGB(80, 80, 90),
    ToggleEnabledStroke = Color3.fromRGB(255, 40, 40),
    ToggleDisabledStroke = Color3.fromRGB(100, 100, 110),
    ToggleEnabledOuterStroke = Color3.fromRGB(255, 60, 60),
    ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 55),
    DropdownSelected = Color3.fromRGB(35, 35, 40),
    DropdownUnselected = Color3.fromRGB(25, 25, 30),
    InputBackground = Color3.fromRGB(25, 25, 30),
    InputStroke = Color3.fromRGB(120, 0, 0),
    PlaceholderColor = Color3.fromRGB(160, 120, 120)
}

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "RullzsyHUB | Sadewa City",
    Icon = "braces",
    LoadingTitle = "Created By RullzsyHUB",
    LoadingSubtitle = "Follow Tiktok: @rullzsy99",
    Theme = RedDarkTheme,
})

-- Tab Menu
local AccountTab = Window:CreateTab("Account", "user")
local BypassTab = Window:CreateTab("Bypass", "shield")
local AutoWalkTab = Window:CreateTab("Auto Walk", "bot")
local PlayerTab = Window:CreateTab("Player Menu", "user-cog")
local RunAnimationTab = Window:CreateTab("Run Animation", "person-standing")
local ServerTab = Window:CreateTab("Finding Server", "globe")
local UpdateTab = Window:CreateTab("Update Checkpoint", "file")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Import
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local setclipboard = setclipboard or toclipboard
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

--| =========================================================== |--



--| =========================================================== |--
--| CHECK AUTH ACCOUNT                                          |--
--| =========================================================== |--
if not getgenv().AuthComplete then
    warn("[MAIN] Not authenticated! Please run auth script first.")
    return
end
--| =========================================================== |--
--| CHECK AUTH ACCOUNT - END                                    |--
--| =========================================================== |--



--| =========================================================== |--
--| ACCOUNT                                                     |--
--| =========================================================== |--
-- CONFIG
local API_CONFIG = {
	base_url = "https://panel.0xtunggereung.rullzsyhub.my.id/",
	get_user_endpoint = "get_user.php",
}

local FILE_CONFIG = {
	folder = "X_RULLZSYHUB_X",
	subfolder = "auth",
	filename = "token.dat"
}

-- Helper File
local function getAuthFilePath()
	return FILE_CONFIG.folder .. "/" .. FILE_CONFIG.subfolder .. "/" .. FILE_CONFIG.filename
end

local function loadTokenFromFile()
	if not isfile then return nil end
	local success, result = pcall(function()
		if not isfile(getAuthFilePath()) then return nil end
		local content = readfile(getAuthFilePath())
		local data = HttpService:JSONDecode(content)
		if data.username == LocalPlayer.Name then
			return data.token
		end
		return nil
	end)
	return success and result or nil
end

local function getToken()
	local fileToken = loadTokenFromFile()
	if fileToken and fileToken ~= "" then return fileToken end
	local envToken = getgenv().UserToken
	if envToken and envToken ~= "" then return tostring(envToken) end
	return nil
end

-- Safe HTTP Request
local function safeHttpRequest(url, method, data, headers)
	method = method or "GET"
	local reqData = { Url = url, Method = method }
	if headers then reqData.Headers = headers end
	if data and method == "POST" then reqData.Body = data end

	local ok, res = pcall(function() return HttpService:RequestAsync(reqData) end)
	if ok and res and res.Success and res.StatusCode == 200 then return true, res.Body end

	if method == "GET" then
		local ok2, res2 = pcall(function() return HttpService:GetAsync(url, false) end)
		if ok2 and res2 then return true, res2 end
		local ok3, res3 = pcall(function() return game:HttpGet(url) end)
		if ok3 and res3 then return true, res3 end
	end
	return false, tostring(res)
end

-- Data Placeholder
local userData = {
	username = "Guest",
	displayname = "Guest",
	token = "N/A",
	expire_timestamp = os.time(),
	status = "unknown"
}

local updateConnection = nil

-- UI Section
AccountTab:CreateDivider()
local InfoParagraph = AccountTab:CreateParagraph({
	Title = "Account Overview",
	Content = "Tunggu sebentar..."
})

-- Format time short (30d | 10h | 5m | 20s)
local function formatTimeShort(seconds)
	if seconds <= 0 then return "Expired" end
	local d = math.floor(seconds / 86400)
	local h = math.floor((seconds % 86400) / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = math.floor(seconds % 60)
	return string.format("%dd | %dh | %dm | %ds", d, h, m, s)
end

-- Fetch Account Info
local function updateAccountInfo()
	local savedToken = getToken()
	if not savedToken then
		InfoParagraph:Set({
			Title = "🚫 Token Tidak Ditemukan",
			Content = "❌ Tidak dapat memuat data akun.\nSilakan login ulang."
		})
		return
	end

	InfoParagraph:Set({
		Title = "Mengambil Data...",
		Content = "Sedang menghubungkan ke server..."
	})

	local encodedToken = HttpService:UrlEncode(savedToken)
	local url = API_CONFIG.base_url .. API_CONFIG.get_user_endpoint .. "?token=" .. encodedToken
	local headers = {
		["Content-Type"] = "application/json",
		["User-Agent"] = "Roblox/WinInet",
		["ngrok-skip-browser-warning"] = "true"
	}

	local ok, res = safeHttpRequest(url, "GET", nil, headers)
	if not ok then
		InfoParagraph:Set({
			Title = "🚨 Koneksi Gagal",
			Content = "❌ Tidak dapat terhubung ke server.\n" .. tostring(res)
		})
		return
	end

	local success, data = pcall(function() return HttpService:JSONDecode(res) end)
	if not success or type(data) ~= "table" then
		InfoParagraph:Set({
			Title = "⚠️ Data Tidak Valid",
			Content = "❌ Format data server salah."
		})
		return
	end

	if data.status ~= "success" then
		InfoParagraph:Set({
			Title = "🔐 Gagal Autentikasi",
			Content = "❌ " .. tostring(data.message or "Unknown error.")
		})
		return
	end

	-- Update user data
	userData.username = tostring(data.name or LocalPlayer.Name)
	userData.displayname = LocalPlayer.DisplayName
	userData.token = savedToken
	userData.expire_timestamp = tonumber(data.expire_timestamp) or os.time()
	userData.status = "active"

	-- Real-time countdown (expire realtime)
	if updateConnection then updateConnection:Disconnect() end
	updateConnection = RunService.Heartbeat:Connect(function()
		local remaining = userData.expire_timestamp - os.time()
		local timeStr = formatTimeShort(remaining)
		local content = string.format(
			"[◉] Display Name: %s\n[◉] Username: %s\n[◉] Token: %s\n[◉] Expire: %s\n[◉] Status: %s",
			userData.displayname,
			userData.username,
			userData.token,
			timeStr,
			(remaining <= 0 and "Expired" or "Aktif")
		)
		InfoParagraph:Set({
			Title = "-| Informasi Akun |-",
			Content = content
		})
	end)

	Rayfield:Notify({
		Title = "Account",
		Content = "Berhasil di refresh.",
		Duration = 3,
		Image = "check-check",
	})
end

AccountTab:CreateButton({
	Name = "[◉]  Refresh Data Akun",
	Callback = updateAccountInfo
})

AccountTab:CreateDivider()

AccountTab:CreateParagraph({
	Title = "-| Cara Memperpanjang Key/Token |-",
	Content = "1. Kalian click button di bawah bernama 🛒 Perpanjang Key" .. "\n" .. "2. Buka browser kalian maupun di pc/android/ios bebas" .. "\n" .. "3. Paste link discord yang telah di salin pada button perpanjang key" .. "\n" .. "4. Join ke group discord RullzsyHUB" .. "\n" .. "5. Jika sudah join cari bagian Ticket" .. "\n" .. "6. Jika sudah ketemu silahkan create ticket" .. "\n" .. "7. Masukan aja pesan mau perpanjang key dan tunggu sampe admin merespon"
})

AccountTab:CreateButton({
	Name = "🛒 Perpanjang Key",
	Callback = function()
		local link = "https://discord.gg/KEajwZQaRd"
		if setclipboard then
			setclipboard(link)
			Rayfield:Notify({
				Title = "Link Discord",
				Content = "Telah disalin ke clipboard.",
				Duration = 3,
				Image = "clipboard"
			})
		end
	end
})

-- Auto load
task.spawn(function()
	task.wait(1)
	updateAccountInfo()
end)

AccountTab:CreateDivider()
--| =========================================================== |--
--| ACCOUNT - END                                               |--
--| =========================================================== |--



--| =========================================================== |--
--| BYPASS                                                      |--
--| =========================================================== |--
-- Variable Anti Idle
getgenv().AntiIdleActive = false
local AntiIdleConnection
local MovementLoop

-- Function start idle
local function StartAntiIdle()
    if AntiIdleConnection then
        AntiIdleConnection:Disconnect()
        AntiIdleConnection = nil
    end
    if MovementLoop then
        MovementLoop:Disconnect()
        MovementLoop = nil
    end
    AntiIdleConnection = LocalPlayer.Idled:Connect(function()
        if getgenv().AntiIdleActive then
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
    MovementLoop = RunService.Heartbeat:Connect(function()
        if getgenv().AntiIdleActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            if tick() % 60 < 0.05 then
                root.CFrame = root.CFrame * CFrame.new(0, 0, 0.1)
                task.wait(0.1)
                root.CFrame = root.CFrame * CFrame.new(0, 0, -0.1)
            end
        end
    end)
end

-- Respawn Validation
local function SetupCharacterListener()
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        newChar:WaitForChild("HumanoidRootPart", 10)
        if getgenv().AntiIdleActive then
            StartAntiIdle()
        end
    end)
end

StartAntiIdle()
SetupCharacterListener()

-- Section
local Section = BypassTab:CreateSection("List All Bypass")

BypassTab:CreateToggle({
    Name = "[◉] Bypass AFK",
    CurrentValue = false,
    Flag = "AntiIdleToggle",
    Callback = function(Value)
        getgenv().AntiIdleActive = Value
        if Value then
            StartAntiIdle()
            Rayfield:Notify({
                Image = "shield",
                Title = "Bypass AFK",
                Content = "Bypass AFK diaktifkan.",
                Duration = 5
            })
        else
            if AntiIdleConnection then
                AntiIdleConnection:Disconnect()
                AntiIdleConnection = nil
            end
            if MovementLoop then
                MovementLoop:Disconnect()
                MovementLoop = nil
            end
            Rayfield:Notify({
                Image = "shield",
                Title = "Bypass AFK",
                Content = "Bypass AFK dimatikan.",
                Duration = 5
            })
        end
    end,
})
--| =========================================================== |--
--| BYPASS - END                                                |--
--| =========================================================== |--



--| =========================================================== |--
--| AUTO WALK                                                   |--
--| =========================================================== |--
-- Folder Path Auto Walk
local mainFolder = "X_RULLZSYHUB_X"
local jsonFolder = mainFolder .. "/json_sadewa_city_patch_001"
if not isfolder(mainFolder) then
    makefolder(mainFolder)
end
if not isfolder(jsonFolder) then
    makefolder(jsonFolder)
end

-- JSON Auto Walk Files
local baseURL = "https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/json/json_sadewa_city/"
local jsonFiles = {
    "spawnpoint.json",
    "checkpoint_1.json",
    "checkpoint_2.json",
    "checkpoint_3.json",
    "checkpoint_4.json",
    "checkpoint_5.json",
    "checkpoint_6.json",
    "checkpoint_7.json",
    "checkpoint_8.json",
    "checkpoint_9.json",
    "checkpoint_10.json",
    "checkpoint_11.json",
    "checkpoint_12.json",
    "checkpoint_13.json",
    "checkpoint_14.json",
    "checkpoint_15.json",
    "checkpoint_16.json",
    "checkpoint_17.json",
    "checkpoint_18.json",
}

-- Variables Auto Walk
local isPlaying = false
local playbackConnection = nil
local currentCheckpoint = 0
local playbackSpeed = 1.0
local heightOffset = 0

-- Looping Variables
local isLoopingEnabled = false
local loopStartCheckpoint = 0
local isLoopingActive = false

-- FPS Independent & Jump/Landing State Variables
local lastPlaybackTime = 0
local accumulatedTime = 0

-- Footstep
local lastFootstepTime = 0
local footstepInterval = 0.35
local leftFootstep = true

-- Flip Variables
local isFlipped = false
local FLIP_SMOOTHNESS = 0.05
local currentFlipRotation = CFrame.new()

-- Function Auto Walk
local function playFootstepSound()
	if not humanoid or not character then return end

	pcall(function()
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		-- Raycast ke bawah untuk deteksi material lantai
		local rayOrigin = hrp.Position
		local rayDirection = Vector3.new(0, -5, 0)
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = { character }
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
		if rayResult and rayResult.Instance then
			local material = rayResult.Material
			local sound = Instance.new("Sound")
			sound.Volume = 0.8
			sound.RollOffMaxDistance = 100
			sound.RollOffMinDistance = 10

			local soundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
			if material == Enum.Material.Grass then
				soundId = "rbxassetid://9118823107"
			elseif material == Enum.Material.Metal then
				soundId = "rbxassetid://260433111"
			elseif material == Enum.Material.Sand then
				soundId = "rbxassetid://9120089994"
			elseif material == Enum.Material.Wood then
				soundId = "rbxassetid://9118828605"
			end

			sound.SoundId = soundId
			sound.Parent = hrp
			sound:Play()
			game:GetService("Debris"):AddItem(sound, 1)
		end
	end)
end

local function simulateNaturalMovement(moveDirection, velocity)
	if not humanoid or not character then return end

	local horizontalVelocity = Vector3.new(velocity.X, 0, velocity.Z)
	local speed = horizontalVelocity.Magnitude

	local onGround = false
	pcall(function()
		local state = humanoid:GetState()
		onGround = (state == Enum.HumanoidStateType.Running or
			state == Enum.HumanoidStateType.RunningNoPhysics or
			state == Enum.HumanoidStateType.Landed)
	end)

	if speed > 0.5 and onGround then
		local currentTime = tick()
		local speedMultiplier = math.clamp(speed / 16, 0.3, 2)
		local adjustedInterval = footstepInterval / (speedMultiplier * playbackSpeed)

		if currentTime - lastFootstepTime >= adjustedInterval then
			playFootstepSound()
			lastFootstepTime = currentTime
			leftFootstep = not leftFootstep
		end
	end
end

local function vecToTable(v3)
    return {x = v3.X, y = v3.Y, z = v3.Z}
end

local function tableToVec(t)
    return Vector3.new(t.x, t.y, t.z)
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function lerpVector(a, b, t)
    return Vector3.new(lerp(a.X, b.X, t), lerp(a.Y, b.Y, t), lerp(a.Z, b.Z, t))
end

local function lerpAngle(a, b, t)
    local diff = (b - a)
    while diff > math.pi do diff = diff - 2*math.pi end
    while diff < -math.pi do diff = diff + 2*math.pi end
    return a + diff * t
end

local function isNearGround(pos, threshold)
    threshold = threshold or 3
    local rayOrigin = pos + Vector3.new(0, 1, 0)
    local rayDirection = Vector3.new(0, -threshold - 1, 0)

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    return result ~= nil, result and result.Position or nil
end

local function EnsureJsonFile(fileName)
    local savePath = jsonFolder .. "/" .. fileName
    if isfile(savePath) then return true, savePath end
    
    local ok, res = pcall(function() return game:HttpGet(baseURL..fileName) end)
    if ok and res and #res > 0 then
        writefile(savePath, res)
        return true, savePath
    end
    return false, nil
end

local function loadCheckpoint(fileName)
    local filePath = jsonFolder .. "/" .. fileName
    
    if not isfile(filePath) then
        return nil
    end

    local success, result = pcall(function()
        local jsonData = readfile(filePath)
        return HttpService:JSONDecode(jsonData)
    end)

    if success then
        return result
    else
        return nil
    end
end

local function findSurroundingFrames(data, t)
    if #data == 0 then
        return nil, nil, 0
    end

    if t <= data[1].time then
        return 1, 1, 0
    end

    if t >= data[#data].time then
        return #data, #data, 0
    end

    local left, right = 1, #data
    while left < right - 1 do
        local mid = math.floor((left + right) / 2)
        if data[mid].time <= t then
            left = mid
        else
            right = mid
        end
    end

    local i0, i1 = left, right
    local span = data[i1].time - data[i0].time
    local alpha = span > 0 and math.clamp((t - data[i0].time) / span, 0, 1) or 0

    return i0, i1, alpha
end

local function stopPlayback(forceStopLoop)
    isPlaying = false
    isPaused = false
    pausedTime = 0
    pauseStartTime = 0
    accumulatedTime = 0
    lastPlaybackTime = 0
    heightOffset = 0
    isFlipped = false
    currentFlipRotation = CFrame.new()
    
    if forceStopLoop == true then
        isLoopingActive = false
    end

    if playbackConnection then
        playbackConnection:Disconnect()
        playbackConnection = nil
    end

    if character and humanoid then
        humanoid:Move(Vector3.new(0, 0, 0), false)
        if humanoid:GetState() ~= Enum.HumanoidStateType.Running and
            humanoid:GetState() ~= Enum.HumanoidStateType.RunningNoPhysics then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end

local footstepSound = Instance.new("Sound")
footstepSound.Name = "AutoWalkFootstep"
footstepSound.SoundId = "rbxassetid://9118823107"
footstepSound.Volume = 1
footstepSound.Looped = false
footstepSound.Parent = workspace

local function playFootstep()
	if not footstepSound.IsPlaying then
		footstepSound:Play()
	end
end

local function startPlayback(data, onComplete)
	if not data or #data == 0 then  
		if onComplete then onComplete() end
		return
	end

	if isPlaying then
		stopPlayback()
	end

	if character and character:FindFirstChild("HumanoidRootPart") and data[1] then
		local firstFrame = data[1]
		local startPos = tableToVec(firstFrame.position)
		local startYaw = firstFrame.rotation or 0

		local hrp = character.HumanoidRootPart
		
		-- Hitung height offset terlebih dahulu
		local currentHipHeight = humanoid.HipHeight
		local recordedHipHeight = data[1].hipHeight or 2
		heightOffset = currentHipHeight - recordedHipHeight
		
		-- Terapkan height offset langsung pada posisi awal
		local correctedStartY = startPos.Y + heightOffset
		local correctedStartPos = Vector3.new(startPos.X, correctedStartY, startPos.Z)
		
		hrp.CFrame = CFrame.new(correctedStartPos) * CFrame.Angles(0, startYaw, 0)
		hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end

	isPlaying = true
	isPaused = false
	pausedTime = 0
	pauseStartTime = 0
	local playbackStartTime = tick()
	lastPlaybackTime = playbackStartTime
	accumulatedTime = 0
	local lastJumping = false

	if playbackConnection then
		playbackConnection:Disconnect()
		playbackConnection = nil
	end

	playbackConnection = RunService.Heartbeat:Connect(function(deltaTime)
		if not isPlaying then return end

		if isPaused then
			if pauseStartTime == 0 then
				pauseStartTime = tick()
			end
			lastPlaybackTime = tick()
			return
		else
			if pauseStartTime > 0 then
				pausedTime = pausedTime + (tick() - pauseStartTime)
				pauseStartTime = 0
				lastPlaybackTime = tick()
			end
		end

		if not character or not character:FindFirstChild("HumanoidRootPart") then return end
		if not humanoid or humanoid.Parent ~= character then
			humanoid = character:FindFirstChild("Humanoid")
		end

		local currentTime = tick()
		local actualDelta = math.min(currentTime - lastPlaybackTime, 0.1)
		lastPlaybackTime = currentTime
		accumulatedTime += (actualDelta * playbackSpeed)
		local totalDuration = data[#data].time

		if accumulatedTime > totalDuration then
			stopPlayback()
			if onComplete then onComplete() end
			return
		end

		local i0, i1, alpha = findSurroundingFrames(data, accumulatedTime)
		local f0, f1 = data[i0], data[i1]
		if not f0 or not f1 then return end

		local pos0, pos1 = tableToVec(f0.position), tableToVec(f1.position)
		local vel0, vel1 = tableToVec(f0.velocity or {x = 0, y = 0, z = 0}), tableToVec(f1.velocity or {x = 0, y = 0, z = 0})
		local move0, move1 = tableToVec(f0.moveDirection or {x = 0, y = 0, z = 0}), tableToVec(f1.moveDirection or {x = 0, y = 0, z = 0})
		local yaw0, yaw1 = f0.rotation or 0, f1.rotation or 0

		local interpPos = lerpVector(pos0, pos1, alpha)
		local interpVel = lerpVector(vel0, vel1, alpha)
		local interpMove = lerpVector(move0, move1, alpha)
		local interpYaw = lerpAngle(yaw0, yaw1, alpha)
		local hrp = character.HumanoidRootPart

		local correctedY = interpPos.Y + heightOffset
		local targetCFrame = CFrame.new(interpPos.X, correctedY, interpPos.Z) * CFrame.Angles(0, interpYaw, 0)
		local targetFlipRotation = isFlipped and CFrame.Angles(0, math.pi, 0) or CFrame.new()
		currentFlipRotation = currentFlipRotation:Lerp(targetFlipRotation, FLIP_SMOOTHNESS)

		local lerpFactor = math.clamp(1 - math.exp(-12 * actualDelta), 0, 1)
		hrp.CFrame = hrp.CFrame:Lerp(targetCFrame * currentFlipRotation, lerpFactor)
		simulateNaturalMovement(interpMove, interpVel)

		pcall(function()
			hrp.AssemblyLinearVelocity = interpVel
		end)

		if humanoid then
			humanoid:Move(interpMove, false)
		end

		-- Handle jumping
		local jumpingNow = f0.jumping or false
		if f1.jumping then jumpingNow = true end
		if jumpingNow and not lastJumping then
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
		lastJumping = jumpingNow
	end)
end

local function getNextCheckpointIndex(currentIndex)
    if currentIndex >= #jsonFiles then
        return 1
    else
        return currentIndex + 1
    end
end

local function playCheckpointSequence(startIndex)
    if not isLoopingEnabled then
        return
    end

    isLoopingActive = true
    local currentIndex = startIndex

    local function playNext()
        if not isLoopingEnabled or not isLoopingActive then
            return
        end

        local fileName = jsonFiles[currentIndex]

        local ok, path = EnsureJsonFile(fileName)
        if not ok then
            Rayfield:Notify({
                Title = "Error (Loop)",
                Content = "Gagal memuat checkpoint: " .. fileName,
                Duration = 4,
                Image = "ban"
            })
            stopPlayback(true)
            return
        end

        local data = loadCheckpoint(fileName)
        if not data or #data == 0 then
            Rayfield:Notify({
                Title = "Error (Loop)",
                Content = "Data checkpoint kosong: " .. fileName,
                Duration = 4,
                Image = "ban"
            })
            stopPlayback(true)
            return
        end
        currentCheckpoint = currentIndex
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local humanoidLocal = character and character:FindFirstChildOfClass("Humanoid")

        if not hrp or not humanoidLocal then
            Rayfield:Notify({
                Title = "Error (Loop)",
                Content = "Character tidak ditemukan!",
                Duration = 4,
                Image = "ban"
            })
            stopPlayback(true)
            return
        end

        local startPos = tableToVec(data[1].position)
        local distance = (hrp.Position - startPos).Magnitude
        if distance > 10 then
            local reached = false
            local moveConnection

            moveConnection = humanoidLocal.MoveToFinished:Connect(function(r)
                reached = true
                if moveConnection then
                    moveConnection:Disconnect()
                    moveConnection = nil
                end
            end)

            humanoidLocal:MoveTo(startPos)

            local startTime = tick()
            local maxWaitTime = 15

            while not reached and (tick() - startTime) < maxWaitTime do
                task.wait(0.1)
            end

            if moveConnection then
                moveConnection:Disconnect()
                moveConnection = nil
            end

            if not reached then
                Rayfield:Notify({
                    Title = "Auto Walk (Loop)",
                    Content = "Gagal mencapai titik awal (timeout)!",
                    Duration = 3,
                    Image = "ban"
                })
                stopPlayback(true)
                return
            end
        end
        startPlayback(data, function()
            if not isLoopingEnabled or not isLoopingActive then
                return
            end
            task.wait(0.1)
            local nextIndex
            if currentIndex < #jsonFiles then
                nextIndex = currentIndex + 1
            else
                nextIndex = nil
            end

            if nextIndex then
                currentIndex = nextIndex
                playNext()
            else
                Rayfield:Notify({
                    Title = "Auto Walk",
                    Content = "Semua checkpoint telah selesai! Silahkan click GUI Turun untuk kembali ke bc.",
                    Duration = 4,
                    Image = "check-check"
                })
                stopPlayback(true)
                isLoopingActive = false
            end
        end)
    end

    playNext()
end

local function playSingleCheckpointFile(fileName, checkpointIndex)
    stopPlayback(true)
    
    local ok, path = EnsureJsonFile(fileName)
    if not ok then
        Rayfield:Notify({
            Title = "Error",
            Content = "Failed to ensure JSON checkpoint",
            Duration = 4,
            Image = "ban"
        })
        return
    end
    
    local data = loadCheckpoint(fileName)
    if not data or #data == 0 then
        Rayfield:Notify({
            Title = "Error",
            Content = "File invalid / kosong",
            Duration = 4,
            Image = "ban"
        })
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Rayfield:Notify({
            Title = "Error",
            Content = "HumanoidRootPart tidak ditemukan!",
            Duration = 4,
            Image = "ban"
        })
        return
    end
    
    local startPos = tableToVec(data[1].position)
    local distance = (hrp.Position - startPos).Magnitude
    
    if distance > 100 then
        Rayfield:Notify({
            Title = "Auto Walk",
            Content = string.format("Kamu berada di luar area checkpoint (%.0f studs)! Silahkan respawn/jalan ke area checkpoint.", distance),
            Duration = 5,
            Image = "alert-triangle"
        })
        return
    end
    
    local modeText = isLoopingEnabled and "(Loop Mode)" or "(Manual)"
    
    local humanoidLocal = character:FindFirstChildOfClass("Humanoid")
    if not humanoidLocal then
        Rayfield:Notify({
            Title = "Error",
            Content = "Humanoid tidak ditemukan!",
            Duration = 4,
            Image = "ban"
        })
        return
    end
    
    local reached = false
    local moveConnection
    
    moveConnection = humanoidLocal.MoveToFinished:Connect(function(r)
        reached = true
        if moveConnection then
            moveConnection:Disconnect()
            moveConnection = nil
        end
    end)
    
    humanoidLocal:MoveTo(startPos)
    
    local startTime = tick()
    local maxWaitTime = 15
    
    while not reached and (tick() - startTime) < maxWaitTime do
        task.wait(0.1)
    end
    
    if moveConnection then
        moveConnection:Disconnect()
        moveConnection = nil
    end
    
    if not reached then
        Rayfield:Notify({
            Title = "Auto Walk",
            Content = "Gagal mencapai titik awal (timeout)!",
            Duration = 3,
            Image = "ban"
        })
        return
    end
    if isLoopingEnabled then
        loopStartCheckpoint = checkpointIndex
        playCheckpointSequence(checkpointIndex)
    else
        startPlayback(data, function()
            Rayfield:Notify({
                Title = "Auto Walk",
                Content = "Auto walk selesai!",
                Duration = 2,
                Image = "check-check"
            })
        end)
    end
end

-- ========== PAUSE/ROTATE UI ========== --
local BTN_COLOR = Color3.fromRGB(38, 38, 38)
local BTN_HOVER = Color3.fromRGB(55, 55, 55)
local TEXT_COLOR = Color3.fromRGB(230, 230, 230)
local SUCCESS_COLOR = Color3.fromRGB(0, 170, 85)

local function createPauseRotateUI()
    local ui = Instance.new("ScreenGui")
    ui.Name = "PauseRotateUI"
    ui.IgnoreGuiInset = true
    ui.ResetOnSpawn = false
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ui.Parent = CoreGui
    
    local bgFrame = Instance.new("Frame")
    bgFrame.Name = "PR_Background"
    bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgFrame.BackgroundTransparency = 0.4
    bgFrame.BorderSizePixel = 0
    bgFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    bgFrame.Position = UDim2.new(0.5, 0, 0.85, 0)
    bgFrame.Size = UDim2.new(0, 130, 0, 70)
    bgFrame.Visible = false
    bgFrame.Parent = ui
    
    local bgCorner = Instance.new("UICorner", bgFrame)
    bgCorner.CornerRadius = UDim.new(0, 20)
    
    local dragIndicator = Instance.new("Frame")
    dragIndicator.Name = "DragIndicator"
    dragIndicator.BackgroundTransparency = 1
    dragIndicator.Position = UDim2.new(0.5, 0, 0, 8)
    dragIndicator.Size = UDim2.new(0, 40, 0, 6)
    dragIndicator.AnchorPoint = Vector2.new(0.5, 0)
    dragIndicator.Parent = bgFrame
    
    local dotLayout = Instance.new("UIListLayout", dragIndicator)
    dotLayout.FillDirection = Enum.FillDirection.Horizontal
    dotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    dotLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    dotLayout.Padding = UDim.new(0, 6)
    
    for i = 1, 3 do
        local dot = Instance.new("Frame")
        dot.Name = "Dot" .. i
        dot.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        dot.BackgroundTransparency = 0.3
        dot.BorderSizePixel = 0
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Parent = dragIndicator

        local dotCorner = Instance.new("UICorner", dot)
        dotCorner.CornerRadius = UDim.new(1, 0)
    end
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "PR_Main"
    mainFrame.BackgroundTransparency = 1
    mainFrame.BorderSizePixel = 0
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.6, 0)
    mainFrame.Size = UDim2.new(1, -10, 0, 50)
    mainFrame.Parent = bgFrame
    
    local dragging = false
    local dragInput, dragStart, startPos
    local UserInputService = game:GetService("UserInputService")
    
    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        bgFrame.Position = newPos
    end
    
    bgFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = bgFrame.Position
            
            for i, dot in ipairs(dragIndicator:GetChildren()) do
                if dot:IsA("Frame") then
                    TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0
                    }):Play()
                end
            end
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    for i, dot in ipairs(dragIndicator:GetChildren()) do
                        if dot:IsA("Frame") then
                            TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                                BackgroundColor3 = Color3.fromRGB(150, 150, 150),
                                BackgroundTransparency = 0.3
                            }):Play()
                        end
                    end
                end
            end)
        end
    end)
    
    bgFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                for i, dot in ipairs(dragIndicator:GetChildren()) do
                    if dot:IsA("Frame") then
                        TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            BackgroundColor3 = Color3.fromRGB(150, 150, 150),
                            BackgroundTransparency = 0.3
                        }):Play()
                    end
                end
            end
        end
    end)
    
    local layout = Instance.new("UIListLayout", mainFrame)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 10)
    
    local function createButton(emoji, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 50, 0, 50)
        btn.BackgroundColor3 = BTN_COLOR
        btn.BackgroundTransparency = 0.1
        btn.TextColor3 = TEXT_COLOR
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 24
        btn.Text = emoji
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.Parent = mainFrame
        
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(1, 0)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
                BackgroundColor3 = BTN_HOVER,
                Size = UDim2.new(0, 54, 0, 54)
            }):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
                BackgroundColor3 = color or BTN_COLOR,
                Size = UDim2.new(0, 50, 0, 50)
            }):Play()
        end)
        
        return btn
    end
    
    local pauseResumeBtn = createButton("⏸️", BTN_COLOR)
    local rotateBtn = createButton("🔄", BTN_COLOR)
    
    local currentlyPaused = false
    local tweenTime = 0.25
    local showScale = 1
    local hideScale = 0
    
    local function showUI()
        bgFrame.Visible = true
        bgFrame.Size = UDim2.new(0, 130 * hideScale, 0, 70 * hideScale)
        TweenService:Create(bgFrame, TweenInfo.new(tweenTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 130 * showScale, 0, 70 * showScale)
        }):Play()
    end
    
    local function hideUI()
        TweenService:Create(bgFrame, TweenInfo.new(tweenTime, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 130 * hideScale, 0, 70 * hideScale)
        }):Play()
        task.delay(tweenTime, function()
            bgFrame.Visible = false
        end)
    end
    
    pauseResumeBtn.MouseButton1Click:Connect(function()
        if not isPlaying then
            Rayfield:Notify({
                Title = "Auto Walk",
                Content = "Tidak ada auto walk yang sedang berjalan!",
                Duration = 3,
                Image = "alert-triangle"
            })
            return
        end
        
        if not currentlyPaused then
            isPaused = true
            currentlyPaused = true
            pauseResumeBtn.Text = "▶️"
            pauseResumeBtn.BackgroundColor3 = SUCCESS_COLOR
            Rayfield:Notify({
                Title = "Auto Walk",
                Content = "Berhasil di pause.",
                Duration = 2,
                Image = "pause"
            })
        else
            isPaused = false
            currentlyPaused = false
            pauseResumeBtn.Text = "⏸️"
            pauseResumeBtn.BackgroundColor3 = BTN_COLOR
            Rayfield:Notify({
                Title = "Auto Walk",
                Content = "Berhasil di resume.",
                Duration = 2,
                Image = "play"
            })
        end
    end)
    
    rotateBtn.MouseButton1Click:Connect(function()
        if not isPlaying then
            Rayfield:Notify({
                Title = "Rotate",
                Content = "Auto walk harus berjalan terlebih dahulu!",
                Duration = 3,
                Image = "alert-triangle"
            })
            return
        end
        
        isFlipped = not isFlipped
        if isFlipped then
            rotateBtn.Text = "🔃"
            rotateBtn.BackgroundColor3 = SUCCESS_COLOR
            Rayfield:Notify({
                Title = "Rotate",
                Content = "Jalan mundur diaktifkan",
                Duration = 2,
                Image = "rotate-cw"
            })
        else
            rotateBtn.Text = "🔄"
            rotateBtn.BackgroundColor3 = BTN_COLOR
            Rayfield:Notify({
                Title = "Rotate",
                Content = "Jalan mundur dimatikan",
                Duration = 2,
                Image = "rotate-ccw"
            })
        end
    end)
    
    local function resetUIState()
        currentlyPaused = false
        pauseResumeBtn.Text = "⏸️"
        pauseResumeBtn.BackgroundColor3 = BTN_COLOR
        isFlipped = false
        rotateBtn.Text = "🔄"
        rotateBtn.BackgroundColor3 = BTN_COLOR
    end

    return {
        mainFrame = bgFrame,
        showUI = showUI,
        hideUI = hideUI,
        resetUIState = resetUIState
    }
end

local pauseRotateUI = createPauseRotateUI()

local originalStopPlayback = stopPlayback
stopPlayback = function(forceStopLoop)
    originalStopPlayback(forceStopLoop)
    pauseRotateUI.resetUIState()
end

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if isPlaying then
        stopPlayback(true)
    end
end)

-- ========== AUTO WALK UI ========== --
-- Section: Settings
local Section = AutoWalkTab:CreateSection("Auto Walk (Settings)")

-- Toggle: Pause/Rotate Menu
local Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Pause/Flip Menu",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            pauseRotateUI.showUI()
        else
            pauseRotateUI.hideUI()
        end
    end,
})

-- Toggle: Enable Looping
local LoopingToggle = AutoWalkTab:CreateToggle({
   Name = "[◉] Enable Looping",
   CurrentValue = false,
   Callback = function(Value)
       isLoopingEnabled = Value
       if Value then
           Rayfield:Notify({
               Title = "Looping",
               Content = "Berhasil diaktifkan! Pilih checkpoint untuk memulai loop.",
               Duration = 3,
               Image = "repeat"
           })
       else
           Rayfield:Notify({
               Title = "Looping",
               Content = "Berhasil dimatikan!",
               Duration = 3,
               Image = "x"
           })
           if isLoopingActive then
               isLoopingActive = false
               stopPlayback(true)
           end
       end
   end,
})

-- Slider: Speed Control
local SpeedSlider = AutoWalkTab:CreateSlider({
    Name = "[◉] Speed Auto Walk",
    Range = {0.5, 1.2},
    Increment = 0.10,
    Suffix = "x Speed (Default 1x)",
    CurrentValue = 1.0,
    Callback = function(Value)
        playbackSpeed = Value

        local speedText = "Normal"
        if Value < 1.0 then
            speedText = "Lambat (" .. string.format("%.1f", Value) .. "x)"
        elseif Value > 1.0 then
            speedText = "Cepat (" .. string.format("%.1f", Value) .. "x)"
        else
            speedText = "Normal (" .. Value .. "x)"
        end
    end,
})

-- Section: Manual Controls
local Section = AutoWalkTab:CreateSection("Auto Walk (Manual)")

-- Toggle: Spawnpoint
local SCPToggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Spawnpoint)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("spawnpoint.json", 1)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 1
local CP1Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 1)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_1.json", 2)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 2
local CP2Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 2)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_2.json", 3)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 3
local CP3Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 3)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_3.json", 4)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 4
local CP4Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 4)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_4.json", 5)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 5
local CP5Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 5)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_5.json", 6)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 6
local CP6Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 6)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_6.json", 7)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 7
local CP7Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 7)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_7.json", 8)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 8
local CP8Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 8)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_8.json", 9)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 9
local CP9Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 9)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_9.json", 10)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 10
local CP10Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 10)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_10.json", 11)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 11
local CP11Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 11)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_11.json", 12)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 12
local CP12Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 12)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_12.json", 13)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 13
local CP13Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 13)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_13.json", 14)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 14
local CP14Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 14)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_14.json", 15)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 15
local CP15Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 15)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_15.json", 16)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 16
local CP16Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 16)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_16.json", 17)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 17
local CP17Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 17)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_17.json", 18)
        else
            stopPlayback(true)
        end
    end,
})

-- Toggle: Checkpoint 18
local CP18Toggle = AutoWalkTab:CreateToggle({
    Name = "[◉] Auto Walk (Checkpoint 18)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_18.json", 19)
        else
            stopPlayback(true)
        end
    end,
})
--| =========================================================== |--
--| AUTO WALK - END                                             |--
--| =========================================================== |--



--| =========================================================== |--
--| PLAYER MENU                                                 |--
--| =========================================================== |--
-- Section Nametag Menu
local Section = PlayerTab:CreateSection("Nametag Menu")

-- Toggle Hidenametag
local HideNametagToggle = PlayerTab:CreateToggle({
    Name = "[◉] Hide Nametags",
    CurrentValue = false,
    Callback = function(Value)
        local function hideNametagsForCharacter(character)
            if not character then return end
            local head = character:FindFirstChild("Head")
            if not head then return end
            for _, obj in pairs(head:GetChildren()) do
                if obj:IsA("BillboardGui") then
                    obj.Enabled = false
                end
            end
        end

        local function showNametagsForCharacter(character)
            if not character then return end
            local head = character:FindFirstChild("Head")
            if not head then return end
            for _, obj in pairs(head:GetChildren()) do
                if obj:IsA("BillboardGui") then
                    obj.Enabled = true
                end
            end
        end

        local function setNametagsVisible(state)
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    if state then
                        showNametagsForCharacter(player.Character)
                    else
                        hideNametagsForCharacter(player.Character)
                    end
                end
            end
        end

        if Value then
            setNametagsVisible(false)
            nametagConnections = {}
            local function connectPlayer(player)
                local charAddedConn
                charAddedConn = player.CharacterAdded:Connect(function(char)
                    task.wait(1)
                    hideNametagsForCharacter(char)
                end)
                table.insert(nametagConnections, charAddedConn)
            end
            for _, player in pairs(Players:GetPlayers()) do
                connectPlayer(player)
            end
            table.insert(nametagConnections, Players.PlayerAdded:Connect(connectPlayer))
			Rayfield:Notify({
				Image = "user-cog",
                Title = "Hide Nametag",
                Content = "Berhasil diaktifkan.",
                Duration = 3
            })
        else
            setNametagsVisible(true)
            if nametagConnections then
                for _, conn in pairs(nametagConnections) do
                    if conn.Connected then conn:Disconnect() end
                end
            end
            nametagConnections = nil
			Rayfield:Notify({
				Image = "user-cog",
                Title = "Hide Nametag",
                Content = "Berhasil dimatikan.",
                Duration = 3
            })
        end
    end,
})

-- Variable Walk Speed
local WalkSpeedEnabled = false
local WalkSpeedValue = 16

-- Function apply walk speed
local function ApplyWalkSpeed(Humanoid)
    if WalkSpeedEnabled then
        Humanoid.WalkSpeed = WalkSpeedValue
        Rayfield:Notify({
			Image = "user-cog",
            Title = "Walk Speed",
            Content = "Berhasil diaktifkan.",
            Duration = 3
        })
    else
        Humanoid.WalkSpeed = 16
        Rayfield:Notify({
			Image = "user-cog",
            Title = "Walk Speed",
            Content = "Berhasil dimatikan.",
            Duration = 3
        })
    end
end

-- Function to set up on respawn
local function SetupCharacter(Char)
    local Humanoid = Char:WaitForChild("Humanoid")
    ApplyWalkSpeed(Humanoid)
end

-- Connect when player respawns
LocalPlayer.CharacterAdded:Connect(function(Char)
    task.wait(1)
    SetupCharacter(Char)
end)

-- Initial setup for current character
if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end

-- Section Walk Speed
local Section = PlayerTab:CreateSection("Walk Menu")

-- Toggle Walk Speed
PlayerTab:CreateToggle({
    Name = "[◉] Walk Speed",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(Value)
        WalkSpeedEnabled = Value
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("Humanoid") then
            ApplyWalkSpeed(Char.Humanoid)
        end
    end,
})

-- Slider Walk Speed
PlayerTab:CreateSlider({
    Name = "[◉] Set Walk Speed",
    Range = {16, 65},
    Increment = 1,
    Suffix = "x Speed (Default 16x)",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        WalkSpeedValue = Value
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("Humanoid") and WalkSpeedEnabled then
            Char.Humanoid.WalkSpeed = WalkSpeedValue
        end
    end,
})

-- Variable Time Changer
local Lighting = game:GetService("Lighting")
local TimeLockEnabled = false
local CurrentTimeValue = 12

-- Function apply time
local function ApplyTimeChange(Value)
    if typeof(Value) == "number" then
        Lighting.ClockTime = Value
        CurrentTimeValue = Value
    end
end

-- Keep the time locked if user wants constant lighting
task.spawn(function()
    while task.wait(1) do
        if TimeLockEnabled then
            Lighting.ClockTime = CurrentTimeValue
        end
    end
end)

-- Section
local Section = PlayerTab:CreateSection("Time Menu")

-- Toggle Time Changer
PlayerTab:CreateToggle({
    Name = "[◉] Lock Time",
    CurrentValue = false,
    Callback = function(Value)
        TimeLockEnabled = Value

        if Value then
            Rayfield:Notify({
                Image = "user-cog",
                Title = "Lock Time",
                Content = "Berhasil diaktifkan.",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Image = "user-cog",
                Title = "Lock Time",
                Content = "Berhasil dimatikan.",
                Duration = 3
            })
        end
    end,
})

-- Slider Time Changer
PlayerTab:CreateSlider({
    Name = "[◉] Set Time of Day",
    Range = {0, 24},
    Increment = 1,
    Suffix = "Hours",
    CurrentValue = 12,
    Callback = function(Value)
        ApplyTimeChange(Value)
    end,
})
--| =========================================================== |--
--| PLAYER MENU - END                                           |--
--| =========================================================== |--



--| =========================================================== |--
--| RUN ANIMATION                                               |--
--| =========================================================== |--

-----| ID ANIMATION |-----
local Section = RunAnimationTab:CreateSection("Animation Pack List")

local RunAnimations = {
    ["Run Animation 1"] = {
        Idle1="rbxassetid://122257458498464", Idle2="rbxassetid://102357151005774",
        Walk="http://www.roblox.com/asset/?id=18537392113", Run="rbxassetid://82598234841035",
        Jump="rbxassetid://75290611992385", Fall="http://www.roblox.com/asset/?id=11600206437",
        Climb="http://www.roblox.com/asset/?id=10921257536", Swim="http://www.roblox.com/asset/?id=10921264784",
        SwimIdle="http://www.roblox.com/asset/?id=10921265698"
    },
    ["Run Animation 2"] = {
        Idle1="rbxassetid://122257458498464", Idle2="rbxassetid://102357151005774",
        Walk="rbxassetid://122150855457006", Run="rbxassetid://82598234841035",
        Jump="rbxassetid://75290611992385", Fall="rbxassetid://98600215928904",
        Climb="rbxassetid://88763136693023", Swim="rbxassetid://133308483266208",
        SwimIdle="rbxassetid://109346520324160"
    },
    ["Run Animation 3"] = {
        Idle1="http://www.roblox.com/asset/?id=18537376492", Idle2="http://www.roblox.com/asset/?id=18537371272",
        Walk="http://www.roblox.com/asset/?id=18537392113", Run="http://www.roblox.com/asset/?id=18537384940",
        Jump="http://www.roblox.com/asset/?id=18537380791", Fall="http://www.roblox.com/asset/?id=18537367238",
        Climb="http://www.roblox.com/asset/?id=10921271391", Swim="http://www.roblox.com/asset/?id=99384245425157",
        SwimIdle="http://www.roblox.com/asset/?id=113199415118199"
    },
    ["Run Animation 4"] = {
        Idle1="http://www.roblox.com/asset/?id=118832222982049", Idle2="http://www.roblox.com/asset/?id=76049494037641",
        Walk="http://www.roblox.com/asset/?id=92072849924640", Run="http://www.roblox.com/asset/?id=72301599441680",
        Jump="http://www.roblox.com/asset/?id=104325245285198", Fall="http://www.roblox.com/asset/?id=121152442762481",
        Climb="http://www.roblox.com/asset/?id=507765644", Swim="http://www.roblox.com/asset/?id=99384245425157",
        SwimIdle="http://www.roblox.com/asset/?id=113199415118199"
    },
    ["Run Animation 5"] = {
        Idle1="http://www.roblox.com/asset/?id=656117400", Idle2="http://www.roblox.com/asset/?id=656118341",
        Walk="http://www.roblox.com/asset/?id=656121766", Run="http://www.roblox.com/asset/?id=656118852",
        Jump="http://www.roblox.com/asset/?id=656117878", Fall="http://www.roblox.com/asset/?id=656115606",
        Climb="http://www.roblox.com/asset/?id=656114359", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 6"] = {
        Idle1="http://www.roblox.com/asset/?id=616006778", Idle2="http://www.roblox.com/asset/?id=616008087",
        Walk="http://www.roblox.com/asset/?id=616013216", Run="http://www.roblox.com/asset/?id=616010382",
        Jump="http://www.roblox.com/asset/?id=616008936", Fall="http://www.roblox.com/asset/?id=616005863",
        Climb="http://www.roblox.com/asset/?id=616003713", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 7"] = {
        Idle1="http://www.roblox.com/asset/?id=1083195517", Idle2="http://www.roblox.com/asset/?id=1083214717",
        Walk="http://www.roblox.com/asset/?id=1083178339", Run="http://www.roblox.com/asset/?id=1083216690",
        Jump="http://www.roblox.com/asset/?id=1083218792", Fall="http://www.roblox.com/asset/?id=1083189019",
        Climb="http://www.roblox.com/asset/?id=1083182000", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 8"] = {
        Idle1="http://www.roblox.com/asset/?id=616136790", Idle2="http://www.roblox.com/asset/?id=616138447",
        Walk="http://www.roblox.com/asset/?id=616146177", Run="http://www.roblox.com/asset/?id=616140816",
        Jump="http://www.roblox.com/asset/?id=616139451", Fall="http://www.roblox.com/asset/?id=616134815",
        Climb="http://www.roblox.com/asset/?id=616133594", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 9"] = {
        Idle1="http://www.roblox.com/asset/?id=616088211", Idle2="http://www.roblox.com/asset/?id=616089559",
        Walk="http://www.roblox.com/asset/?id=616095330", Run="http://www.roblox.com/asset/?id=616091570",
        Jump="http://www.roblox.com/asset/?id=616090535", Fall="http://www.roblox.com/asset/?id=616087089",
        Climb="http://www.roblox.com/asset/?id=616086039", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 10"] = {
        Idle1="http://www.roblox.com/asset/?id=910004836", Idle2="http://www.roblox.com/asset/?id=910009958",
        Walk="http://www.roblox.com/asset/?id=910034870", Run="http://www.roblox.com/asset/?id=910025107",
        Jump="http://www.roblox.com/asset/?id=910016857", Fall="http://www.roblox.com/asset/?id=910001910",
        Climb="http://www.roblox.com/asset/?id=616086039", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 11"] = {
        Idle1="http://www.roblox.com/asset/?id=742637544", Idle2="http://www.roblox.com/asset/?id=742638445",
        Walk="http://www.roblox.com/asset/?id=742640026", Run="http://www.roblox.com/asset/?id=742638842",
        Jump="http://www.roblox.com/asset/?id=742637942", Fall="http://www.roblox.com/asset/?id=742637151",
        Climb="http://www.roblox.com/asset/?id=742636889", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 12"] = {
        Idle1="http://www.roblox.com/asset/?id=616111295", Idle2="http://www.roblox.com/asset/?id=616113536",
        Walk="http://www.roblox.com/asset/?id=616122287", Run="http://www.roblox.com/asset/?id=616117076",
        Jump="http://www.roblox.com/asset/?id=616115533", Fall="http://www.roblox.com/asset/?id=616108001",
        Climb="http://www.roblox.com/asset/?id=616104706", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 13"] = {
        Idle1="http://www.roblox.com/asset/?id=657595757", Idle2="http://www.roblox.com/asset/?id=657568135",
        Walk="http://www.roblox.com/asset/?id=657552124", Run="http://www.roblox.com/asset/?id=657564596",
        Jump="http://www.roblox.com/asset/?id=658409194", Fall="http://www.roblox.com/asset/?id=657600338",
        Climb="http://www.roblox.com/asset/?id=658360781", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 14"] = {
        Idle1="http://www.roblox.com/asset/?id=616158929", Idle2="http://www.roblox.com/asset/?id=616160636",
        Walk="http://www.roblox.com/asset/?id=616168032", Run="http://www.roblox.com/asset/?id=616163682",
        Jump="http://www.roblox.com/asset/?id=616161997", Fall="http://www.roblox.com/asset/?id=616157476",
        Climb="http://www.roblox.com/asset/?id=616156119", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 15"] = {
        Idle1="http://www.roblox.com/asset/?id=845397899", Idle2="http://www.roblox.com/asset/?id=845400520",
        Walk="http://www.roblox.com/asset/?id=845403856", Run="http://www.roblox.com/asset/?id=845386501",
        Jump="http://www.roblox.com/asset/?id=845398858", Fall="http://www.roblox.com/asset/?id=845396048",
        Climb="http://www.roblox.com/asset/?id=845392038", Swim="http://www.roblox.com/asset/?id=910028158",
        SwimIdle="http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 16"] = {
        Idle1="http://www.roblox.com/asset/?id=782841498", Idle2="http://www.roblox.com/asset/?id=782845736",
        Walk="http://www.roblox.com/asset/?id=782843345", Run="http://www.roblox.com/asset/?id=782842708",
        Jump="http://www.roblox.com/asset/?id=782847020", Fall="http://www.roblox.com/asset/?id=782846423",
        Climb="http://www.roblox.com/asset/?id=782843869", Swim="http://www.roblox.com/asset/?id=18537389531",
        SwimIdle="http://www.roblox.com/asset/?id=18537387180"
    },
    ["Run Animation 17"] = {
        Idle1="http://www.roblox.com/asset/?id=891621366", Idle2="http://www.roblox.com/asset/?id=891633237",
        Walk="http://www.roblox.com/asset/?id=891667138", Run="http://www.roblox.com/asset/?id=891636393",
        Jump="http://www.roblox.com/asset/?id=891627522", Fall="http://www.roblox.com/asset/?id=891617961",
        Climb="http://www.roblox.com/asset/?id=891609353", Swim="http://www.roblox.com/asset/?id=18537389531",
        SwimIdle="http://www.roblox.com/asset/?id=18537387180"
    },
    ["Run Animation 18"] = {
        Idle1="http://www.roblox.com/asset/?id=750781874", Idle2="http://www.roblox.com/asset/?id=750782770",
        Walk="http://www.roblox.com/asset/?id=750785693", Run="http://www.roblox.com/asset/?id=750783738",
        Jump="http://www.roblox.com/asset/?id=750782230", Fall="http://www.roblox.com/asset/?id=750780242",
        Climb="http://www.roblox.com/asset/?id=750779899", Swim="http://www.roblox.com/asset/?id=18537389531",
        SwimIdle="http://www.roblox.com/asset/?id=18537387180"
    },
}

local OriginalAnimations = {}

local function SaveOriginal(Char)
    local Animate = Char:FindFirstChild("Animate")
    if not Animate then return end
    local originals = {}
    for _, child in ipairs(Animate:GetDescendants()) do
        if child:IsA("Animation") then
            originals[child] = child.AnimationId
        end
    end
    OriginalAnimations[Char] = originals
end

local function ApplyAnimation(Char, animName)
    local Animate, Humanoid = Char:FindFirstChild("Animate"), Char:FindFirstChild("Humanoid")
    if not (Animate and Humanoid) then return end
    local pack = RunAnimations[animName]
    if not pack then return end

    Animate.idle.Animation1.AnimationId = pack.Idle1
    Animate.idle.Animation2.AnimationId = pack.Idle2
    Animate.walk.WalkAnim.AnimationId = pack.Walk
    Animate.run.RunAnim.AnimationId = pack.Run
    Animate.jump.JumpAnim.AnimationId = pack.Jump
    Animate.fall.FallAnim.AnimationId = pack.Fall
    Animate.climb.ClimbAnim.AnimationId = pack.Climb
    Animate.swim.Swim.AnimationId = pack.Swim
    Animate.swimidle.SwimIdle.AnimationId = pack.SwimIdle
    Humanoid.Jump = true
end

local function RestoreOriginal(Char)
    local originals = OriginalAnimations[Char]
    if not originals then return end
    for anim, id in pairs(originals) do
        if anim and anim:IsA("Animation") then
            anim.AnimationId = id
        end
    end
end

-- Toggle
for i = 1, 18 do
    local name = "Run Animation " .. i
    RunAnimationTab:CreateToggle({
        Name = "[◉] " .. name,
        CurrentValue = false,
        Flag = name .. "Toggle",
        Callback = function(Value)
            local Char = Players.LocalPlayer.Character
            if not (Char and Char:FindFirstChild("Animate") and Char:FindFirstChild("Humanoid")) then return end

            if Value then
                SaveOriginal(Char)
                ApplyAnimation(Char, name)
                Rayfield:Notify({
                    Image = "person-standing",
                    Title = name,
                    Content = "Berhasil diterapkan.",
                    Duration = 3
                })
            else
                RestoreOriginal(Char)
                Rayfield:Notify({
                    Image = "person-standing",
                    Title = name,
                    Content = "Berhasil dimatikan.",
                    Duration = 3
                })
            end
        end,
    })
end

--| =========================================================== |--
--| RUN ANIMATION - END                                         |--
--| =========================================================== |--



--| =========================================================== |--
--| FINDING SERVER                                              |--
--| =========================================================== |--
local ServerSection = ServerTab:CreateSection("Server Menu")

-- Varibale Server
local HttpService = game:GetService("HttpService")
local PlaceId = game.PlaceId
local Servers = {}

local function FetchServers()
    local Cursor = ""
    Servers = {}

    repeat
        local URL = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100%s", PlaceId, Cursor ~= "" and "&cursor="..Cursor or "")
        local Response = game:HttpGet(URL)
        local Data = HttpService:JSONDecode(Response)

        for _, server in pairs(Data.data) do
            table.insert(Servers, server)
        end

        Cursor = Data.nextPageCursor
        task.wait(0.5)
    until not Cursor

    return Servers
end

-- Function Join Server
local function CreateServerButtons()
    ServerTab:CreateParagraph({Title = "🔍 Mencari Server...", Content = "Tunggu sebentar sedang mencari data server..."})
    local allServers = FetchServers()
    ServerTab:CreateSection(" ")

    for _, server in pairs(allServers) do
        local playerCount = string.format("%d/%d", server.playing, server.maxPlayers)
        local isSafe = server.playing <= (server.maxPlayers / 2)

        local emoji = isSafe and "🟢" or "🟥"
        local safety = isSafe and "Safe" or "No Safe"

        local name = string.format("%s Server [%s] - %s", emoji, playerCount, safety)

        ServerTab:CreateButton({
            Name = name,
            Callback = function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId, server.id)
            end,
        })
    end

    ServerTab:CreateParagraph({Title = "- | Selesai! |-", Content = "Pilih salah satu server sepi di atas untuk join."})
end

-- Toggle Start Find Server
ServerTab:CreateButton({
    Name = "[◉] START FIND SERVER",
    Callback = function()
        CreateServerButtons()
    end,
})

local Divider = ServerTab:CreateDivider()
--| =========================================================== |--
--| FINDING SERVER - END                                        |--
--| =========================================================== |--



--| =========================================================== |--
--| UPDATE CHECKPOINT                                           |--
--| =========================================================== |--
-- Variable Update Script
local updateEnabled = false
local stopUpdate = {false}

-- Divider
local Divider = UpdateTab:CreateDivider()

-- Label
local Label = UpdateTab:CreateLabel("STATUS: Pengecekan file...")

-- Function verify file & auto download checkpoint
task.spawn(function()
    for i, f in ipairs(jsonFiles) do
        local ok = EnsureJsonFile(f)
        Label:Set((ok and "STATUS: Proses Cek File: " or " Gagal: ").." ("..i.."/"..#jsonFiles..")")
        task.wait(0.5)
    end
    Label:Set("STATUS: Semua checkpoint aman...")
end)

-- Toggle
UpdateTab:CreateToggle({
    Name = "[◉] UPDATE CHECKPOINT",
    CurrentValue = false,
    Callback = function(state)
        if state then
            updateEnabled = true
            stopUpdate[1] = false
            task.spawn(function()
                Label:Set("STATUS: Proses update file...")
                for _, f in ipairs(jsonFiles) do
                    local savePath = jsonFolder .. "/" .. f
                    if isfile(savePath) then
                        delfile(savePath)
                    end
                end
                for i, f in ipairs(jsonFiles) do
                    if stopUpdate[1] then break end
                    Rayfield:Notify({
                        Title = "Update Checkpoint",
                        Content = "Proses Update " .. " ("..i.."/"..#jsonFiles..")",
                        Duration = 2,
                        Image = "file",
                    })
                    local ok, res = pcall(function() return game:HttpGet(baseURL..f) end)
                    if ok and res and #res > 0 then
                        writefile(jsonFolder.."/"..f, res)
                        Label:Set("STATUS: Proses Update: ".. " ("..i.."/"..#jsonFiles..")")
                    else
                        Rayfield:Notify({
                            Title = "Update Chcekpoint",
                            Content = "Gagal mengupdate checkpoint!",
                            Duration = 3,
                            Image = "ban",
                        })
                        Label:Set("STATUS: Gagal update: ".. " ("..i.."/"..#jsonFiles..")")
                    end
                    task.wait(0.3)
                end
                if not stopUpdate[1] then
                    Rayfield:Notify({
                        Title = "Update Checkpoint",
                        Content = "Berhasil di update!...",
                        Duration = 5,
                        Image = "check-check",
                    })
                else
                    Rayfield:Notify({
                        Title = "Update Checkpoint",
                        Content = "Berhasil dibatalkan!",
                        Duration = 3,
                        Image = "triangle-alert",
                    })
                end
                for i, f in ipairs(jsonFiles) do
                    local ok = EnsureJsonFile(f)
                    Label:Set((ok and "STATUS: Verify Checkpoint: " or " Failed: ").." ("..i.."/"..#jsonFiles..")")
                    task.wait(0.3)
                end
                Label:Set("STATUS: Semua file aman...")
            end)
        else
            updateEnabled = false
            stopUpdate[1] = true
        end
    end,
})

-- Divider
local Divider = UpdateTab:CreateDivider()
--| =========================================================== |--
--| UPDATE CHECKPOINT - END                                     |--
--| =========================================================== |--