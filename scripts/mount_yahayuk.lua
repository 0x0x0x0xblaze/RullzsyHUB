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
    Name = "RullzsyHUB | Mount Yahayuk",
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
local UpdateTab = Window:CreateTab("Update Checkpoint", "file")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
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
-- Api Check Account
local API_CONFIG = {
    base_url = "https://panel.0xtunggereung.rullzsyhub.my.id/",
    get_user_endpoint = "get_user.php",
}

local FILE_CONFIG = {
    folder = "X_RULLZSYHUB_X",
    subfolder = "auth",
    filename = "token.dat"
}

local function getAuthFilePath()
    return FILE_CONFIG.folder .. "/" .. FILE_CONFIG.subfolder .. "/" .. FILE_CONFIG.filename
end

local function loadTokenFromFile()
    if not isfile then
        return nil
    end
    
    local success, result = pcall(function()
        if not isfile(getAuthFilePath()) then
            return nil
        end
        
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
    if fileToken and fileToken ~= "" then
        return fileToken
    end
    
    local envToken = getgenv().UserToken
    if envToken and envToken ~= "" then
        return tostring(envToken)
    end
    
    return nil
end

local function safeHttpRequest(url, method, data, headers)
    method = method or "GET"
    local requestData = { Url = url, Method = method }

    if headers then requestData.Headers = headers end
    if data and method == "POST" then requestData.Body = data end

    local ok, res = pcall(function() return HttpService:RequestAsync(requestData) end)
    if ok and res and res.Success and res.StatusCode == 200 then
        return true, res.Body
    end

    if method == "GET" then
        local ok2, res2 = pcall(function() return HttpService:GetAsync(url, false) end)
        if ok2 and res2 then return true, res2 end
        local ok3, res3 = pcall(function() return game:HttpGet(url) end)
        if ok3 and res3 then return true, res3 end
    end

    return false, tostring(res)
end

local userData = {
    username = "Guest",
    role = "Member",
    expire_timestamp = os.time()
}

local updateConnection = nil

AccountTab:CreateSection("Informasi Akun")
local InfoParagraph = AccountTab:CreateParagraph({
    Title = "📊 Status Akun",
    Content = "🔄 Memuat data...\n⏳ Tunggu sebentar..."
})

local function formatTimeRealtime(seconds)
    if seconds <= 0 then return "Expired" end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%d Hari | %02d Jam | %02d Menit | %02d Detik", days, hours, minutes, secs)
end

local function getExpiryStatusRealtime(expireTimestamp)
    local remaining = expireTimestamp - os.time()
    local emoji = "🟢"

    if remaining <= 0 then
        emoji = "🔴"
        return emoji, "Expired"
    elseif remaining <= 86400 then
        emoji = "🟠"
    elseif remaining <= 259200 then
        emoji = "🟡"
    end

    return emoji, formatTimeRealtime(remaining)
end

local function updateAccountInfo()
    local savedToken = getToken()
    
    if not savedToken or savedToken == "" then
        InfoParagraph:Set({
            Title = "🚫 Token Error",
            Content = "❌ Token tidak ditemukan.\nSilakan restart dan login ulang."
        })
        return
    end

    InfoParagraph:Set({
        Title = "🔄 Memuat Data",
        Content = "⏳ Menghubungkan ke server..."
    })

    local encodedToken = HttpService:UrlEncode(tostring(savedToken))
    local url = API_CONFIG.base_url .. API_CONFIG.get_user_endpoint .. "?token=" .. encodedToken
    
    local headers = {
        ["Content-Type"] = "application/json",
        ["User-Agent"] = "Roblox/WinInet",
        ["ngrok-skip-browser-warning"] = "true"
    }

    local ok, res = safeHttpRequest(url, "GET", nil, headers)
    if not ok then
        InfoParagraph:Set({
            Title = "🚨 Connection Error",
            Content = "❌ Gagal terhubung ke server.\n" .. tostring(res)
        })
        return
    end

    local okDecode, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not okDecode or type(data) ~= "table" then
        InfoParagraph:Set({
            Title = "🔐 Server Error",
            Content = "❌ Format response tidak valid."
        })
        return
    end

    if data.status ~= "success" then
        InfoParagraph:Set({
            Title = "🔐 Authentication Failed",
            Content = "❌ " .. tostring(data.message or "Error")
        })
        return
    end

    userData.username = tostring(data.name or "Unknown")
    userData.role = tostring(data.role or "Member")
    userData.expire_timestamp = tonumber(data.expire_timestamp) or (os.time() + 86400)

    if updateConnection then
        updateConnection:Disconnect()
    end

    updateConnection = RunService.Heartbeat:Connect(function()
        local emoji, timeStr = getExpiryStatusRealtime(userData.expire_timestamp)
        InfoParagraph:Set({
            Title = "👨🏻‍💼 Welcome, " .. userData.username,
            Content = string.format(
                "🏷️  Role       : %s\n⏰  Expire     : %s %s\n\n✅ Status: Aktif",
                userData.role,
                emoji, timeStr
            )
        })
    end)
    
    Rayfield:Notify({
        Title = "Data Loaded",
        Content = "Welcome, " .. userData.username .. "!",
        Duration = 3,
		Image = "check-check",
    })
end

AccountTab:CreateSection("Quick Actions")

AccountTab:CreateButton({
    Name = "🔄 Refresh Akun",
    Callback = function()
        updateAccountInfo()
    end
})

AccountTab:CreateButton({
    Name = "🛒 Beli/Perpanjang Key",
    Callback = function()
        local discordLink = "https://discord.gg/KEajwZQaRd"
        if setclipboard then
            setclipboard(discordLink)
            Rayfield:Notify({
                Title = "Copied!",
                Content = "Discord link copied!",
                Duration = 3,
				Image = "clipboard",
            })
        end
    end
})

AccountTab:CreateParagraph({
    Title = "💡 Info",
    Content = "Untuk perpanjang key, silahkan buat ticket di Discord."
})

-- Auto load account info
task.spawn(function()
    task.wait(1)
    updateAccountInfo()
end)
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
local jsonFolder = mainFolder .. "/json_mount_yahayuk_patch_001"
if not isfolder(mainFolder) then
    makefolder(mainFolder)
end
if not isfolder(jsonFolder) then
    makefolder(jsonFolder)
end

-- JSON Auto Walk Files
local baseURL = "https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/json/json_mount_yahayuk/"
local jsonFiles = {
    "spawnpoint.json",
    "checkpoint_1.json",
    "checkpoint_2.json",
    "checkpoint_3.json",
    "checkpoint_4.json",
    "checkpoint_5.json",
}

-- Variables Auto Walk
local isPlaying = false
local playbackConnection = nil
local autoLoopEnabled = false
local currentCheckpoint = 0
local lastActivityTime = 0
local activityCheckConnection = nil
local ACTIVITY_TIMEOUT = 30
local isPaused = false
local manualLoopEnabled = false
local pausedTime = 0
local pauseStartTime = 0
local lastPlaybackTime = 0
local accumulatedTime = 0
local loopingEnabled = false
local isManualMode = false
local manualStartCheckpoint = 0
local recordedHipHeight = nil
local currentHipHeight = nil
local heightOffset = 0
local playbackSpeed = 1.0
local lastFootstepTime = 0
local footstepInterval = 0.35
local leftFootstep = true
local isFlipped = false
local FLIP_SMOOTHNESS = 0.05
local currentFlipRotation = CFrame.new()
local lastGroundedState = false
local landingCooldown = 0
local jumpCooldown = 0
local lastYVelocity = 0

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
    threshold = threshold or 4
    local rayOrigin = pos + Vector3.new(0, 1, 0)
    local rayDirection = Vector3.new(0, -threshold - 1, 0)

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    return result ~= nil, result and result.Position or nil
end

local function getGroundPosition(position)
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        return position 
    end
    
    local rayOrigin = Vector3.new(position.X, position.Y + 10, position.Z)
    local rayDirection = Vector3.new(0, -100, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = false
    
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if rayResult then
        return rayResult.Position
    end
    
    return position
end

local function calculateHeightOffset()
    if not humanoid or not character then return 0 end
    currentHipHeight = humanoid.HipHeight
    if not recordedHipHeight then
        recordedHipHeight = 2.0 
    end
    heightOffset = currentHipHeight - recordedHipHeight
    return heightOffset
end

local function adjustPositionForAvatarSize(position)
    if not humanoid or not character then return position end
    local offset = calculateHeightOffset()
    return Vector3.new(position.X, position.Y + offset, position.Z)
end

local function playFootstepSound()
    if not humanoid or not character then return end
    pcall(function()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local rayOrigin = hrp.Position
        local rayDirection = Vector3.new(0, -10, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if rayResult and rayResult.Instance then
            local sound = Instance.new("Sound")
            sound.Volume = 0.8
            sound.RollOffMaxDistance = 100
            sound.RollOffMinDistance = 10
            sound.SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
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
    local nearGround = isNearGround(humanoidRootPart.Position)
    
    if speed > 0.5 and nearGround then
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
        warn("File not found:", filePath)
        return nil
    end
    
    local success, result = pcall(function()
        local jsonData = readfile(filePath)
        if not jsonData or jsonData == "" then
            error("Empty file")
        end
        return HttpService:JSONDecode(jsonData)
    end)
    
    if success and result then
        if result[1] and result[1].hipHeight then
            recordedHipHeight = result[1].hipHeight
        elseif result[1] and result[1].position then
            local firstPos = tableToVec(result[1].position)
            local groundPos = getGroundPosition(firstPos)
            recordedHipHeight = firstPos.Y - groundPos.Y
        end
        return result
    else
        warn("❌ Load error for", fileName, ":", result)
        return nil
    end
end

local function findSurroundingFrames(data, t)
    if #data == 0 then return nil, nil, 0 end
    if t <= data[1].time then return 1, 1, 0 end
    if t >= data[#data].time then return #data, #data, 0 end
    
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

local function stopPlayback()
    isPlaying = false
    isPaused = false
    pausedTime = 0
    accumulatedTime = 0
    lastPlaybackTime = 0
    lastFootstepTime = 0
    recordedHipHeight = nil
    heightOffset = 0
    isFlipped = false
    currentFlipRotation = CFrame.new()
    lastGroundedState = false
    landingCooldown = 0
    jumpCooldown = 0
    lastYVelocity = 0
    
    if playbackConnection then
        playbackConnection:Disconnect()
        playbackConnection = nil
    end
    
    if activityCheckConnection then
        activityCheckConnection:Disconnect()
        activityCheckConnection = nil
    end
    
    if character and humanoid then
        humanoid:Move(Vector3.new(0, 0, 0), false)
        if humanoid:GetState() ~= Enum.HumanoidStateType.Running and
            humanoid:GetState() ~= Enum.HumanoidStateType.RunningNoPhysics then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end

local function startActivityMonitor()
    lastActivityTime = tick()
    
    if activityCheckConnection then
        activityCheckConnection:Disconnect()
    end
    
    activityCheckConnection = RunService.Heartbeat:Connect(function()
        if not autoLoopEnabled or not loopingEnabled then
            if activityCheckConnection then
                activityCheckConnection:Disconnect()
                activityCheckConnection = nil
            end
            return
        end
        
        local currentTime = tick()
        if isPlaying then
            lastActivityTime = currentTime
        elseif (currentTime - lastActivityTime) > ACTIVITY_TIMEOUT then
            warn("⚠️ Auto walk stuck detected! Restarting...")
            stopPlayback()
            
            if isManualMode then
                local restartCheckpoint = math.max(1, currentCheckpoint)
                
                Rayfield:Notify({
                    Title = "Auto Walk Recovery",
                    Content = "Mendeteksi stuck, restart dari checkpoint " .. restartCheckpoint,
                    Duration = 3,
                    Image = "refresh-cw"
                })
                
                task.wait(2)
                startManualAutoWalkSequence(restartCheckpoint)
            end
            lastActivityTime = currentTime
        end
    end)
end

local function startPlayback(data, onComplete)
    if not data or #data == 0 then
        warn("No data to play!")
        if onComplete then onComplete() end
        return
    end
    
    if isPlaying then stopPlayback() end
    isPlaying = true
    isPaused = false
    pausedTime = 0
    accumulatedTime = 0
    local playbackStartTime = tick()
    lastPlaybackTime = playbackStartTime
    local lastJumping = false
    lastGroundedState = true
    landingCooldown = 0
    jumpCooldown = 0
    lastYVelocity = 0
    calculateHeightOffset()
    
    if playbackConnection then
        playbackConnection:Disconnect()
        playbackConnection = nil
    end
    local first = data[1]
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local firstPos = tableToVec(first.position)
        firstPos = adjustPositionForAvatarSize(firstPos)
        local firstYaw = first.rotation or 0
        
        local startCFrame = CFrame.new(firstPos) * CFrame.Angles(0, firstYaw, 0)
        hrp.CFrame = startCFrame
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

        if humanoid then
            humanoid:Move(tableToVec(first.moveDirection or {x=0,y=0,z=0}), false)
        end
        
        task.wait(0.1)
    end
    
    playbackConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not isPlaying then return end
        if not character or not character.Parent then
            warn("⚠️ Character lost during playback, stopping...")
            stopPlayback()
            if onComplete then onComplete() end
            return
        end 
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
        if not character:FindFirstChild("HumanoidRootPart") then 
            warn("⚠️ HumanoidRootPart missing, stopping...")
            stopPlayback()
            if onComplete then onComplete() end
            return 
        end
        if not humanoid or humanoid.Parent ~= character then
            humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then
                warn("⚠️ Humanoid missing, stopping...")
                stopPlayback()
                if onComplete then onComplete() end
                return
            end
            calculateHeightOffset()
        end
        if landingCooldown > 0 then
            landingCooldown = landingCooldown - deltaTime
        end
        if jumpCooldown > 0 then
            jumpCooldown = jumpCooldown - deltaTime
        end
        
        local currentTime = tick()
        local actualDelta = currentTime - lastPlaybackTime
        lastPlaybackTime = currentTime
        actualDelta = math.min(actualDelta, 0.1)
        accumulatedTime = accumulatedTime + (actualDelta * playbackSpeed)
        local totalDuration = data[#data].time
        if accumulatedTime > totalDuration then
            local final = data[#data]
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local finalPos = tableToVec(final.position)
                finalPos = adjustPositionForAvatarSize(finalPos)
                local finalYaw = final.rotation or 0
                local targetCFrame = CFrame.new(finalPos) * CFrame.Angles(0, finalYaw, 0)
                local targetFlipRotation = isFlipped and CFrame.Angles(0, math.pi, 0) or CFrame.new()
                currentFlipRotation = currentFlipRotation:Lerp(targetFlipRotation, FLIP_SMOOTHNESS)
                hrp.CFrame = targetCFrame * currentFlipRotation
                
                if humanoid then
                    humanoid:Move(tableToVec(final.moveDirection or {x=0,y=0,z=0}), false)
                end
            end
            
            stopPlayback()
            if onComplete then 
                task.wait(0.1)
                onComplete() 
            end
            return
        end

        local i0, i1, alpha = findSurroundingFrames(data, accumulatedTime)
        local f0, f1 = data[i0], data[i1]
        if not f0 or not f1 then return end
        local pos0 = tableToVec(f0.position)
        local pos1 = tableToVec(f1.position)
        local vel0 = tableToVec(f0.velocity or {x=0,y=0,z=0})
        local vel1 = tableToVec(f1.velocity or {x=0,y=0,z=0})
        local move0 = tableToVec(f0.moveDirection or {x=0,y=0,z=0})
        local move1 = tableToVec(f1.moveDirection or {x=0,y=0,z=0})
        local yaw0 = f0.rotation or 0
        local yaw1 = f1.rotation or 0
        local state0 = f0.state or "Running"
        local state1 = f1.state or "Running"
        local interpPos = lerpVector(pos0, pos1, alpha)
        interpPos = adjustPositionForAvatarSize(interpPos)
        local interpVel = lerpVector(vel0, vel1, alpha)
        local interpMove = lerpVector(move0, move1, alpha)
        local interpYaw = lerpAngle(yaw0, yaw1, alpha)
        local hrp = character.HumanoidRootPart
        local shouldBeGrounded = (state0 == "Running" or state0 == "RunningNoPhysics" or state0 == "Landed") and
                                (state1 == "Running" or state1 == "RunningNoPhysics" or state1 == "Landed")
        
        local nearGround, groundPos = isNearGround(hrp.Position, 4)
        local targetCFrame = CFrame.new(interpPos) * CFrame.Angles(0, interpYaw, 0)
        local targetFlipRotation = isFlipped and CFrame.Angles(0, math.pi, 0) or CFrame.new()
        currentFlipRotation = currentFlipRotation:Lerp(targetFlipRotation, FLIP_SMOOTHNESS)
        if shouldBeGrounded and nearGround and landingCooldown <= 0 then
            local lerpFactor = math.clamp(1 - math.exp(-10 * actualDelta), 0, 1)
            hrp.CFrame = hrp.CFrame:Lerp(targetCFrame * currentFlipRotation, lerpFactor)
            if interpVel.Y < 0 then
                interpVel = Vector3.new(interpVel.X, 0, interpVel.Z)
            end
            if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                task.wait()
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            
            lastGroundedState = true
        else
            local lerpFactor = math.clamp(1 - math.exp(-8 * actualDelta), 0, 1)
            hrp.CFrame = hrp.CFrame:Lerp(targetCFrame * currentFlipRotation, lerpFactor)
            lastGroundedState = false
        end
        
        pcall(function()
            local currentVel = hrp.AssemblyLinearVelocity
            local smoothedXVel = lerp(currentVel.X, interpVel.X, 0.7)
            local smoothedYVel = lerp(currentVel.Y, interpVel.Y, 0.7)
            local smoothedZVel = lerp(currentVel.Z, interpVel.Z, 0.7)
            
            if lastYVelocity < -5 and smoothedYVel > -2 and nearGround then
                landingCooldown = 0.3
                smoothedYVel = 0
                
                if humanoid:GetState() ~= Enum.HumanoidStateType.Running then
                    humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                    task.wait(0.05)
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
            hrp.AssemblyLinearVelocity = Vector3.new(smoothedXVel, smoothedYVel, smoothedZVel)
            lastYVelocity = smoothedYVel
        end)
        if humanoid then
            local smoothedMove = humanoid.MoveDirection:Lerp(interpMove, 0.5)
            humanoid:Move(smoothedMove, false)
        end
        simulateNaturalMovement(interpMove, interpVel) 
        local jumpingNow = f0.jumping or false
        if f1.jumping then jumpingNow = true end
        
        if jumpingNow and not lastJumping and jumpCooldown <= 0 then
            local currentState = humanoid:GetState()
            if currentState == Enum.HumanoidStateType.Running or
                currentState == Enum.HumanoidStateType.RunningNoPhysics or
                currentState == Enum.HumanoidStateType.Landed or
                nearGround then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                jumpCooldown = 0.5
            end
        end
        lastJumping = jumpingNow
    end)
end

local function startAutoWalkSequence()
    currentCheckpoint = 0
    
    local function playNext()
        if not autoLoopEnabled then return end
        
        currentCheckpoint = currentCheckpoint + 1
        
        if currentCheckpoint > #jsonFiles then
            if loopingEnabled then
                Rayfield:Notify({
                    Title = "Auto Walk",
                    Content = "Semua checkpoint selesai! Looping dari awal...",
                    Duration = 3,
                    Image = "repeat"
                })
                task.wait(0.3)
                startAutoWalkSequence()
            else
                autoLoopEnabled = false
                Rayfield:Notify({
                    Title = "Auto Walk",
                    Content = "Auto walk selesai! Semua checkpoint sudah dilewati.",
                    Duration = 5,
                    Image = "check-check"
                })
            end
            return
        end
        
        local checkpointFile = jsonFiles[currentCheckpoint]
        local ok, path = EnsureJsonFile(checkpointFile)
        
        if not ok then
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to download checkpoint",
                Duration = 5,
                Image = "ban"
            })
            autoLoopEnabled = false
            return
        end
        
        local data = loadCheckpoint(checkpointFile)
        
        if data and #data > 0 then
            Rayfield:Notify({
                Title = "Auto Walk (Automatic)",
                Content = "Auto walk berhasil di jalankan",
                Duration = 2,
                Image = "bot"
            })
            task.wait(0.2)
            startPlayback(data, playNext)
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Error loading: " .. checkpointFile,
                Duration = 5,
                Image = "ban"
            })
            autoLoopEnabled = false
        end
    end
    
    playNext()
end

local function startManualAutoWalkSequence(startCheckpoint)
    currentCheckpoint = startCheckpoint - 1
    isManualMode = true
    autoLoopEnabled = true
    
    local function walkToStartIfNeeded(data)
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            warn("⚠️ Character not ready, retrying in 2 seconds...")
            task.wait(2)
            character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                return false
            end
        end
        local hrp = character.HumanoidRootPart
        if not data or not data[1] or not data[1].position then
            return true
        end
        local startPos = tableToVec(data[1].position)
        startPos = adjustPositionForAvatarSize(startPos)
        local distance = (hrp.Position - startPos).Magnitude
        if distance > 100 then
            Rayfield:Notify({
                Title = "Auto Walk (Manual)",
                Content = string.format("Kamu berada di luar area checkpoint (%.0f studs)! Silahkan respawn/jalan ke area checkpoint dan jalankan lagi auto walk nya.", distance),
                Duration = 5,
                Image = "alert-triangle"
            })
            autoLoopEnabled = false
            isManualMode = false
            return false
        end
        
        local humanoidLocal = character:FindFirstChildOfClass("Humanoid")
        if not humanoidLocal then
            warn("⚠️ Humanoid not found, cannot walk to start...")
            autoLoopEnabled = false
            isManualMode = false
            return false
        end
        
        Rayfield:Notify({
            Title = "Auto Walk (Manual)",
            Content = string.format("🚶 Berjalan ke titik awal... (%.0f studs)", distance),
            Duration = 2,
            Image = "walk"
        })
        
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
        
        while not reached and (tick() - startTime) < maxWaitTime and autoLoopEnabled do
            if not character or not character.Parent then
                warn("⚠️ Character removed during walk, waiting for respawn...")
                if moveConnection then
                    moveConnection:Disconnect()
                    moveConnection = nil
                end
                task.wait(3)
                character = player.Character
                return false
            end
            
            task.wait(0.1)
        end
        
        if moveConnection then
            moveConnection:Disconnect()
            moveConnection = nil
        end
        
        if not reached then
            Rayfield:Notify({
                Title = "Auto Walk (Manual)",
                Content = "Tidak bisa mencapai titik awal (timeout)!",
                Duration = 3,
                Image = "ban"
            })
            autoLoopEnabled = false
            isManualMode = false
            return false
        end
        
        return true
    end
    
    local function playNext()
        local retryCount = 0
        local maxRetries = 3
        
        while retryCount < maxRetries and autoLoopEnabled do
            if not autoLoopEnabled then return end
            
            if not character or not character.Parent then
                warn("⚠️ Character missing, waiting for respawn...")
                retryCount = retryCount + 1
                task.wait(3)
                character = player.Character
                if retryCount >= maxRetries then
                    warn("❌ Max retries reached, stopping...")
                    autoLoopEnabled = false
                    isManualMode = false
                    return
                end
                continue
            end
            
            currentCheckpoint = currentCheckpoint + 1
            
            if currentCheckpoint > #jsonFiles then
                if loopingEnabled then
                    Rayfield:Notify({
                        Title = "Auto Walk (Manual)",
                        Content = "Checkpoint selesai! Looping dari awal...",
                        Duration = 2,
                        Image = "repeat"
                    })
                    task.wait(0.3)
                    currentCheckpoint = 0
                    continue
                else
                    autoLoopEnabled = false
                    isManualMode = false
                    Rayfield:Notify({
                        Title = "Auto Walk (Manual)",
                        Content = "Auto walk selesai!",
                        Duration = 2,
                        Image = "check-check"
                    })
                    return
                end
            end
            
            local checkpointFile = jsonFiles[currentCheckpoint]
            local ok, path = EnsureJsonFile(checkpointFile)
            
            if not ok then
                warn("⚠️ Failed to download, retrying...")
                retryCount = retryCount + 1
                task.wait(2)
                continue
            end
            
            local data = loadCheckpoint(checkpointFile)
            
            if not data or #data == 0 then
                warn("⚠️ Failed to load checkpoint, retrying...")
                retryCount = retryCount + 1
                task.wait(2)
                continue
            end
            
            local okWalk = walkToStartIfNeeded(data)
            
            if not okWalk then
                return
            end
            
            retryCount = 0
            startPlayback(data, playNext)
            return
        end
        
        if autoLoopEnabled then
            warn("❌ Max retries exceeded, stopping auto walk...")
            autoLoopEnabled = false
            isManualMode = false
            Rayfield:Notify({
                Title = "Auto Walk Error",
                Content = "Auto walk stopped due to repeated errors",
                Duration = 5,
                Image = "ban"
            })
        end
    end
    
    playNext()
end

-- Functio play single checkpoint
local function playSingleCheckpointFile(fileName, checkpointIndex)
    if loopingEnabled then
        stopPlayback()
        startManualAutoWalkSequence(checkpointIndex)
        return
    end
    autoLoopEnabled = false
    isManualMode = false
    stopPlayback()
    
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
    startPos = adjustPositionForAvatarSize(startPos)
    
    local distance = (hrp.Position - startPos).Magnitude
    
    if distance > 100 then
        Rayfield:Notify({
            Title = "Auto Walk (Manual)",
            Content = string.format("Kamu berada di luar area checkpoint (%.0f studs)! Silahkan respawn/jalan ke area checkpoint dan jalankan lagi auto walk nya.", distance),
            Duration = 5,
            Image = "alert-triangle"
        })
        return
    end
    
    Rayfield:Notify({
        Title = "Auto Walk (Manual)",
        Content = string.format("🚶 Menuju ke titik awal... (%.0f studs)", distance),
        Duration = 2,
        Image = "walk"
    })
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        Rayfield:Notify({
            Title = "Error",
            Content = "Humanoid tidak ditemukan!",
            Duration = 4,
            Image = "ban"
        })
        return
    end
    
    local moving = true
    humanoid:MoveTo(startPos)
    
    local reachedConnection
    reachedConnection = humanoid.MoveToFinished:Connect(function(reached)
        if reached then
            moving = false
            reachedConnection:Disconnect()
            startPlayback(data, function()
                Rayfield:Notify({
                    Title = "Auto Walk (Manual)",
                    Content = "Auto walk selesai!",
                    Duration = 2,
                    Image = "check-check"
                })
            end)
        else
            Rayfield:Notify({
                Title = "Auto Walk (Manual)",
                Content = "❌ Gagal mencapai titik awal!",
                Duration = 3,
                Image = "ban"
            })
            moving = false
            reachedConnection:Disconnect()
        end
    end)
    
    task.spawn(function()
        local timeout = 20
        local elapsed = 0
        while moving and elapsed < timeout do
            task.wait(1)
            elapsed += 1
        end
        if moving then
            Rayfield:Notify({
                Title = "Auto Walk (Manual)",
                Content = "❌ Tidak bisa mencapai titik awal (timeout)!",
                Duration = 3,
                Image = "ban"
            })
            humanoid:Move(Vector3.new(0,0,0))
            moving = false
            if reachedConnection then reachedConnection:Disconnect() end
        end
    end)
end

-- Function respawn handler
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if autoLoopEnabled and loopingEnabled then
        warn("🔄 Character respawned, resuming auto walk in 3 seconds...")
        task.wait(3)
        
        if isManualMode then
            local resumeCheckpoint = math.max(1, currentCheckpoint)
            Rayfield:Notify({
                Title = "Auto Walk Resumed",
                Content = "Melanjutkan dari checkpoint " .. resumeCheckpoint,
                Duration = 3,
                Image = "play"
            })
            startManualAutoWalkSequence(resumeCheckpoint)
        end
    elseif isPlaying then
        stopPlayback()
    end
end)

-- Pause/Flip Menu UI
local BTN_COLOR = Color3.fromRGB(38, 38, 38)
local BTN_HOVER = Color3.fromRGB(55, 55, 55)
local TEXT_COLOR = Color3.fromRGB(230, 230, 230)
local WARN_COLOR = Color3.fromRGB(255, 140, 0)
local SUCCESS_COLOR = Color3.fromRGB(0, 170, 85)
local ROTATE_COLOR = Color3.fromRGB(100, 100, 255)

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
    
    -- Drag functionality
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
                Content = "❌ Tidak ada auto walk yang sedang berjalan!",
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
                Content = "⏸️ Auto walk dijeda.",
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
                Content = "▶️ Auto walk dilanjutkan.",
                Duration = 2,
                Image = "play"
            })
        end
    end)
    
    rotateBtn.MouseButton1Click:Connect(function()
        if not isPlaying then
            Rayfield:Notify({
                Title = "Rotate",
                Content = "❌ Auto walk harus berjalan terlebih dahulu!",
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

-- Override stopPlayback to reset UI
local originalStopPlayback = stopPlayback
stopPlayback = function()
    originalStopPlayback()
    pauseRotateUI.resetUIState()
end

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
       loopingEnabled = Value
       if Value then
           Rayfield:Notify({
               Title = "Looping",
               Content = "Berhasil diaktifkan!",
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
       end
   end,
})

-- Slider: Speed Control
local SpeedSlider = AutoWalkTab:CreateSlider({
    Name = "[◉] Set Speed Auto Walk",
    Range = {0.5, 1.1},
    Increment = 0.10,
    Suffix = "x Speed",
    CurrentValue = 0.5,
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
            if loopingEnabled then
                startActivityMonitor()
            end
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
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
            if loopingEnabled then
                startActivityMonitor()
            end
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
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
            if loopingEnabled then
                startActivityMonitor()
            end
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
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
            if loopingEnabled then
                startActivityMonitor()
            end
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
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
            if loopingEnabled then
                startActivityMonitor()
            end
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
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
            if loopingEnabled then
                startActivityMonitor()
            end
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})
--| =========================================================== |--
--| AUTO WALK - END                                             |--
--| =========================================================== |--



--| =========================================================== |--
--| PLAYER MENU                                                 |--
--| =========================================================== |--
-- Section Full Bright
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

-- Variable Full Bright
local FullBrightEnabled = false
local Lighting = game:GetService("Lighting")
local OriginalLightingSettings = {}

-- Function to save original lighting settings
local function SaveOriginalLighting()
    OriginalLightingSettings = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ShadowSoftness = Lighting.ShadowSoftness,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
    }
end

-- Function to apply Full Bright
local function ApplyFullBright(Enable)
    if Enable then
        -- Save original settings first
        if not next(OriginalLightingSettings) then
            SaveOriginalLighting()
        end
        
        -- Apply Full Bright settings
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.ShadowSoftness = 0
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        
        -- Remove fog and atmosphere effects
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("Atmosphere") or effect:IsA("BlurEffect") or 
               effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or
               effect:IsA("BloomEffect") then
                effect.Enabled = false
            end
        end
        Rayfield:Notify({
			Image = "user-cog",
            Title = "Full Bright",
            Content = "Berhasil diaktifkan.",
            Duration = 3
        })
    else
        -- Restore original lighting settings
        if next(OriginalLightingSettings) then
            Lighting.Ambient = OriginalLightingSettings.Ambient
            Lighting.Brightness = OriginalLightingSettings.Brightness
            Lighting.ColorShift_Bottom = OriginalLightingSettings.ColorShift_Bottom
            Lighting.ColorShift_Top = OriginalLightingSettings.ColorShift_Top
            Lighting.EnvironmentDiffuseScale = OriginalLightingSettings.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = OriginalLightingSettings.EnvironmentSpecularScale
            Lighting.OutdoorAmbient = OriginalLightingSettings.OutdoorAmbient
            Lighting.ShadowSoftness = OriginalLightingSettings.ShadowSoftness
            Lighting.GlobalShadows = OriginalLightingSettings.GlobalShadows
            Lighting.FogEnd = OriginalLightingSettings.FogEnd
        end
        
        -- Re-enable effects
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("Atmosphere") or effect:IsA("BlurEffect") or 
               effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or
               effect:IsA("BloomEffect") then
                effect.Enabled = true
            end
        end

        Rayfield:Notify({
			Image = "user-cog",
            Title = "Full Bright",
            Content = "Berhasil dimatikan.",
            Duration = 3
        })
    end
end

-- Section Full Bright
local Section = PlayerTab:CreateSection("Lighting Menu")

-- Toggle Full Bright
PlayerTab:CreateToggle({
    Name = "[◉] Full Bright",
    CurrentValue = false,
    Flag = "FullBrightToggle",
    Callback = function(Value)
        FullBrightEnabled = Value
        ApplyFullBright(FullBrightEnabled)
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
    Range = {16, 28},
    Increment = 1,
    Suffix = "x Speed",
    CurrentValue = 15,
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
-- Section
local Section = RunAnimationTab:CreateSection("Animation Pack List")

-----| ID ANIMATION |-----
local RunAnimations = {
    ["Run Animation 1"] = {
        Idle1   = "rbxassetid://122257458498464",
        Idle2   = "rbxassetid://102357151005774",
        Walk    = "http://www.roblox.com/asset/?id=18537392113",
        Run     = "rbxassetid://82598234841035",
        Jump    = "rbxassetid://75290611992385",
        Fall    = "http://www.roblox.com/asset/?id=11600206437",
        Climb   = "http://www.roblox.com/asset/?id=10921257536",
        Swim    = "http://www.roblox.com/asset/?id=10921264784",
        SwimIdle= "http://www.roblox.com/asset/?id=10921265698"
    },
    ["Run Animation 2"] = {
        Idle1   = "rbxassetid://122257458498464",
        Idle2   = "rbxassetid://102357151005774",
        Walk    = "rbxassetid://122150855457006",
        Run     = "rbxassetid://82598234841035",
        Jump    = "rbxassetid://75290611992385",
        Fall    = "rbxassetid://98600215928904",
        Climb   = "rbxassetid://88763136693023",
        Swim    = "rbxassetid://133308483266208",
        SwimIdle= "rbxassetid://109346520324160"
    },
    ["Run Animation 3"] = {
        Idle1   = "http://www.roblox.com/asset/?id=18537376492",
        Idle2   = "http://www.roblox.com/asset/?id=18537371272",
        Walk    = "http://www.roblox.com/asset/?id=18537392113",
        Run     = "http://www.roblox.com/asset/?id=18537384940",
        Jump    = "http://www.roblox.com/asset/?id=18537380791",
        Fall    = "http://www.roblox.com/asset/?id=18537367238",
        Climb   = "http://www.roblox.com/asset/?id=10921271391",
        Swim    = "http://www.roblox.com/asset/?id=99384245425157",
        SwimIdle= "http://www.roblox.com/asset/?id=113199415118199"
    },
    ["Run Animation 4"] = {
        Idle1   = "http://www.roblox.com/asset/?id=118832222982049",
        Idle2   = "http://www.roblox.com/asset/?id=76049494037641",
        Walk    = "http://www.roblox.com/asset/?id=92072849924640",
        Run     = "http://www.roblox.com/asset/?id=72301599441680",
        Jump    = "http://www.roblox.com/asset/?id=104325245285198",
        Fall    = "http://www.roblox.com/asset/?id=121152442762481",
        Climb   = "http://www.roblox.com/asset/?id=507765644",
        Swim    = "http://www.roblox.com/asset/?id=99384245425157",
        SwimIdle= "http://www.roblox.com/asset/?id=113199415118199"
    },
    ["Run Animation 5"] = {
        Idle1   = "http://www.roblox.com/asset/?id=656117400",
        Idle2   = "http://www.roblox.com/asset/?id=656118341",
        Walk    = "http://www.roblox.com/asset/?id=656121766",
        Run     = "http://www.roblox.com/asset/?id=656118852",
        Jump    = "http://www.roblox.com/asset/?id=656117878",
        Fall    = "http://www.roblox.com/asset/?id=656115606",
        Climb   = "http://www.roblox.com/asset/?id=656114359",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 6"] = {
        Idle1   = "http://www.roblox.com/asset/?id=616006778",
        Idle2   = "http://www.roblox.com/asset/?id=616008087",
        Walk    = "http://www.roblox.com/asset/?id=616013216",
        Run     = "http://www.roblox.com/asset/?id=616010382",
        Jump    = "http://www.roblox.com/asset/?id=616008936",
        Fall    = "http://www.roblox.com/asset/?id=616005863",
        Climb   = "http://www.roblox.com/asset/?id=616003713",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 7"] = {
        Idle1   = "http://www.roblox.com/asset/?id=1083195517",
        Idle2   = "http://www.roblox.com/asset/?id=1083214717",
        Walk    = "http://www.roblox.com/asset/?id=1083178339",
        Run     = "http://www.roblox.com/asset/?id=1083216690",
        Jump    = "http://www.roblox.com/asset/?id=1083218792",
        Fall    = "http://www.roblox.com/asset/?id=1083189019",
        Climb   = "http://www.roblox.com/asset/?id=1083182000",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 8"] = {
        Idle1   = "http://www.roblox.com/asset/?id=616136790",
        Idle2   = "http://www.roblox.com/asset/?id=616138447",
        Walk    = "http://www.roblox.com/asset/?id=616146177",
        Run     = "http://www.roblox.com/asset/?id=616140816",
        Jump    = "http://www.roblox.com/asset/?id=616139451",
        Fall    = "http://www.roblox.com/asset/?id=616134815",
        Climb   = "http://www.roblox.com/asset/?id=616133594",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 9"] = {
        Idle1   = "http://www.roblox.com/asset/?id=616088211",
        Idle2   = "http://www.roblox.com/asset/?id=616089559",
        Walk    = "http://www.roblox.com/asset/?id=616095330",
        Run     = "http://www.roblox.com/asset/?id=616091570",
        Jump    = "http://www.roblox.com/asset/?id=616090535",
        Fall    = "http://www.roblox.com/asset/?id=616087089",
        Climb   = "http://www.roblox.com/asset/?id=616086039",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 10"] = {
        Idle1   = "http://www.roblox.com/asset/?id=910004836",
        Idle2   = "http://www.roblox.com/asset/?id=910009958",
        Walk    = "http://www.roblox.com/asset/?id=910034870",
        Run     = "http://www.roblox.com/asset/?id=910025107",
        Jump    = "http://www.roblox.com/asset/?id=910016857",
        Fall    = "http://www.roblox.com/asset/?id=910001910",
        Climb   = "http://www.roblox.com/asset/?id=616086039",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 11"] = {
        Idle1   = "http://www.roblox.com/asset/?id=742637544",
        Idle2   = "http://www.roblox.com/asset/?id=742638445",
        Walk    = "http://www.roblox.com/asset/?id=742640026",
        Run     = "http://www.roblox.com/asset/?id=742638842",
        Jump    = "http://www.roblox.com/asset/?id=742637942",
        Fall    = "http://www.roblox.com/asset/?id=742637151",
        Climb   = "http://www.roblox.com/asset/?id=742636889",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 12"] = {
        Idle1   = "http://www.roblox.com/asset/?id=616111295",
        Idle2   = "http://www.roblox.com/asset/?id=616113536",
        Walk    = "http://www.roblox.com/asset/?id=616122287",
        Run     = "http://www.roblox.com/asset/?id=616117076",
        Jump    = "http://www.roblox.com/asset/?id=616115533",
        Fall    = "http://www.roblox.com/asset/?id=616108001",
        Climb   = "http://www.roblox.com/asset/?id=616104706",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 13"] = {
        Idle1   = "http://www.roblox.com/asset/?id=657595757",
        Idle2   = "http://www.roblox.com/asset/?id=657568135",
        Walk    = "http://www.roblox.com/asset/?id=657552124",
        Run     = "http://www.roblox.com/asset/?id=657564596",
        Jump    = "http://www.roblox.com/asset/?id=658409194",
        Fall    = "http://www.roblox.com/asset/?id=657600338",
        Climb   = "http://www.roblox.com/asset/?id=658360781",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 14"] = {
        Idle1   = "http://www.roblox.com/asset/?id=616158929",
        Idle2   = "http://www.roblox.com/asset/?id=616160636",
        Walk    = "http://www.roblox.com/asset/?id=616168032",
        Run     = "http://www.roblox.com/asset/?id=616163682",
        Jump    = "http://www.roblox.com/asset/?id=616161997",
        Fall    = "http://www.roblox.com/asset/?id=616157476",
        Climb   = "http://www.roblox.com/asset/?id=616156119",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 15"] = {
        Idle1   = "http://www.roblox.com/asset/?id=845397899",
        Idle2   = "http://www.roblox.com/asset/?id=845400520",
        Walk    = "http://www.roblox.com/asset/?id=845403856",
        Run     = "http://www.roblox.com/asset/?id=845386501",
        Jump    = "http://www.roblox.com/asset/?id=845398858",
        Fall    = "http://www.roblox.com/asset/?id=845396048",
        Climb   = "http://www.roblox.com/asset/?id=845392038",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 16"] = {
        Idle1   = "http://www.roblox.com/asset/?id=782841498",
        Idle2   = "http://www.roblox.com/asset/?id=782845736",
        Walk    = "http://www.roblox.com/asset/?id=782843345",
        Run     = "http://www.roblox.com/asset/?id=782842708",
        Jump    = "http://www.roblox.com/asset/?id=782847020",
        Fall    = "http://www.roblox.com/asset/?id=782846423",
        Climb   = "http://www.roblox.com/asset/?id=782843869",
        Swim    = "http://www.roblox.com/asset/?id=18537389531",
        SwimIdle= "http://www.roblox.com/asset/?id=18537387180"
    },
    ["Run Animation 17"] = {
        Idle1   = "http://www.roblox.com/asset/?id=891621366",
        Idle2   = "http://www.roblox.com/asset/?id=891633237",
        Walk    = "http://www.roblox.com/asset/?id=891667138",
        Run     = "http://www.roblox.com/asset/?id=891636393",
        Jump    = "http://www.roblox.com/asset/?id=891627522",
        Fall    = "http://www.roblox.com/asset/?id=891617961",
        Climb   = "http://www.roblox.com/asset/?id=891609353",
        Swim    = "http://www.roblox.com/asset/?id=18537389531",
        SwimIdle= "http://www.roblox.com/asset/?id=18537387180"
    },
    ["Run Animation 18"] = {
        Idle1   = "http://www.roblox.com/asset/?id=750781874",
        Idle2   = "http://www.roblox.com/asset/?id=750782770",
        Walk    = "http://www.roblox.com/asset/?id=750785693",
        Run     = "http://www.roblox.com/asset/?id=750783738",
        Jump    = "http://www.roblox.com/asset/?id=750782230",
        Fall    = "http://www.roblox.com/asset/?id=750780242",
        Climb   = "http://www.roblox.com/asset/?id=750779899",
        Swim    = "http://www.roblox.com/asset/?id=18537389531",
        SwimIdle= "http://www.roblox.com/asset/?id=18537387180"
    },
}

-- Functio run animation
local OriginalAnimations = {}
local CurrentPack = nil

local function SaveOriginalAnimations(Animate)
    OriginalAnimations = {}
    for _, child in ipairs(Animate:GetDescendants()) do
        if child:IsA("Animation") then
            OriginalAnimations[child] = child.AnimationId
        end
    end
end

local function ApplyAnimations(Animate, Humanoid, AnimPack)
    Animate.idle.Animation1.AnimationId = AnimPack.Idle1
    Animate.idle.Animation2.AnimationId = AnimPack.Idle2
    Animate.walk.WalkAnim.AnimationId   = AnimPack.Walk
    Animate.run.RunAnim.AnimationId     = AnimPack.Run
    Animate.jump.JumpAnim.AnimationId   = AnimPack.Jump
    Animate.fall.FallAnim.AnimationId   = AnimPack.Fall
    Animate.climb.ClimbAnim.AnimationId = AnimPack.Climb
    Animate.swim.Swim.AnimationId       = AnimPack.Swim
    Animate.swimidle.SwimIdle.AnimationId = AnimPack.SwimIdle
    Humanoid.Jump = true
end

local function RestoreOriginal()
    for anim, id in pairs(OriginalAnimations) do
        if anim and anim:IsA("Animation") then
            anim.AnimationId = id
        end
    end
end

local function SetupCharacter(Char)
    local Animate = Char:WaitForChild("Animate")
    local Humanoid = Char:WaitForChild("Humanoid")
    SaveOriginalAnimations(Animate)
    if CurrentPack then
        ApplyAnimations(Animate, Humanoid, CurrentPack)
    end
end

Players.LocalPlayer.CharacterAdded:Connect(function(Char)
    task.wait(1)
    SetupCharacter(Char)
end)

if Players.LocalPlayer.Character then
    SetupCharacter(Players.LocalPlayer.Character)
end

-- Toggle
for i = 1, 18 do
    local name = "[◉] Run Animation " .. i
    local pack = RunAnimations[name]

    RunAnimationTab:CreateToggle({
        Name = name,
        CurrentValue = false,
        Flag = name .. "Toggle",
        Callback = function(Value)
            if Value then
                CurrentPack = pack
            elseif CurrentPack == pack then
                CurrentPack = nil
                RestoreOriginal()
            end

            local Char = Players.LocalPlayer.Character
            if Char and Char:FindFirstChild("Animate") and Char:FindFirstChild("Humanoid") then
                if CurrentPack then
                    ApplyAnimations(Char.Animate, Char.Humanoid, CurrentPack)
                else
                    RestoreOriginal()
                end
            end
        end,
    })
end
--| =========================================================== |--
--| RUN ANIMATION - END                                         |--
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