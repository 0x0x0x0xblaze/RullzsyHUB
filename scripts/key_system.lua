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
    Name = "RullzsyHUB | Key System",
    Icon = "shield",
    LoadingTitle = "Created By RullzsyHUB",
    LoadingSubtitle = "Follow Tiktok: @rullzsy99",
    Theme = RedDarkTheme,
})

-- Tab Menu
local AuthTab = Window:CreateTab("Authentication", "key")

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Import
local LocalPlayer = Players.LocalPlayer
local RobloxUsername = LocalPlayer.Name
--| =========================================================== |--



--| =========================================================== |--
--| FUNCTION KEY SYSTEM & CONFIG                                |--
--| =========================================================== |--
-- Path Save Token
local FILE_CONFIG = {
    folder = "X_RULLZSYHUB_X",
    subfolder = "auth",
    filename = "token.dat"
}

-- Function get auth file path
local function getAuthFilePath()
    return FILE_CONFIG.folder .. "/" .. FILE_CONFIG.subfolder .. "/" .. FILE_CONFIG.filename
end

-- Function save token
local function saveToken(token)
    local success, err = pcall(function()
        if not isfolder(FILE_CONFIG.folder) then
            makefolder(FILE_CONFIG.folder)
        end
        
        local authFolder = FILE_CONFIG.folder .. "/" .. FILE_CONFIG.subfolder
        if not isfolder(authFolder) then
            makefolder(authFolder)
        end
        
        local data = {
            token = token,
            username = RobloxUsername,
            saved_at = os.time(),
            version = "1.0"
        }
        
        writefile(getAuthFilePath(), HttpService:JSONEncode(data))
    end)
    
    if not success then
        warn("[AUTH] Gagal menyimpan token: " .. tostring(err))
    end
    
    return success
end

-- Function load token
local function loadToken()
    local success, result = pcall(function()
        if not isfile(getAuthFilePath()) then
            return nil
        end
        
        local content = readfile(getAuthFilePath())
        local data = HttpService:JSONDecode(content)
        
        if data.username == RobloxUsername then
            return data.token
        else
            return nil
        end
    end)
    
    if success then
        return result
    else
        warn("[AUTH] Failed to load token: " .. tostring(result))
        return nil
    end
end

-- Function delete token
local function deleteToken()
    pcall(function()
        if isfile(getAuthFilePath()) then
            delfile(getAuthFilePath())
        end
    end)
end

-- Api
local API_CONFIG = {
    base_url = "https://panel.0xtunggereung.rullzsyhub.my.id/",
    validate_endpoint = "/validate.php",
    main_script_url = "https://raw.githubusercontent.com/0x0x0x0xblaze/scripts-vip/refs/heads/main/RullzsyHUB%20-%20LOADER/main.lua"
}

-- Function safe http request
local function safeHttpRequest(url, method, data, headers)
    method = method or "GET"
    local requestData = {
        Url = url,
        Method = method
    }
    
    if headers then
        requestData.Headers = headers
    end
    
    if data and method == "POST" then
        requestData.Body = data
    end
    
    local ok, res = pcall(function()
        return HttpService:RequestAsync(requestData)
    end)
    
    if ok and res then
        if res.Success and res.StatusCode == 200 then
            return true, res.Body
        else
            return false, "HTTP Error: " .. (res.StatusCode or "Unknown")
        end
    end

    if method == "GET" then
        local ok2, res2 = pcall(function()
            return HttpService:GetAsync(url, false)
        end)
        if ok2 and res2 then 
            return true, res2 
        end

        local ok3, res3 = pcall(function()
            return game:HttpGet(url)
        end)
        if ok3 and res3 then 
            return true, res3 
        end
    end

    return false, tostring(res)
end

-- Function validate token
local function ValidateToken(token)
    if not token or token == "" then
        return false, "Token tidak boleh kosong!"
    end

    local encodedToken = HttpService:UrlEncode(tostring(token))
    local encodedUsername = HttpService:UrlEncode(tostring(RobloxUsername))
    local url = API_CONFIG.base_url .. API_CONFIG.validate_endpoint .. "?token=" .. encodedToken .. "&roblox_username=" .. encodedUsername
    
    local headers = {
        ["Content-Type"] = "application/json",
        ["User-Agent"] = "Roblox/WinInet",
        ["ngrok-skip-browser-warning"] = "true"
    }

    local ok, res = safeHttpRequest(url, "GET", nil, headers)
    if not ok then
        return false, "Connection error: " .. tostring(res)
    end

    local okDecode, data = pcall(function()
        return HttpService:JSONDecode(res)
    end)
    
    if not okDecode then
        return false, "Invalid server response format"
    end
    
    if type(data) ~= "table" then
        return false, "Invalid server response structure"
    end

    if tostring(data.status or ""):lower() == "success" then
        return true, data
    else
        local errorMsg = tostring(data.message or "Authentication failed")
        return false, errorMsg
    end
end

-- Function Auto Login
local savedToken = loadToken()
if savedToken and tostring(savedToken) ~= "" and #tostring(savedToken) >= 5 then
    local valid, result = ValidateToken(savedToken)
    if valid then
        getgenv().UserToken = savedToken
        getgenv().AuthComplete = true
        getgenv().AuthTimestamp = os.time()
        
        local ok, res = safeHttpRequest(API_CONFIG.main_script_url)
        if ok then
            local fn, err = loadstring(res)
            if fn then
                local ok2, runErr = pcall(fn)
                if ok2 then
                    return
                else
                    warn("[AUTH] Runtime error: " .. tostring(runErr))
                end
            else
                warn("[AUTH] Compile error: " .. tostring(err))
            end
        end
    else
        deleteToken()
    end
end
--| =========================================================== |--
--| FUNCTION KEY SYSTEM & CONFIG - END                          |--
--| =========================================================== |--



--| =========================================================== |--
--| USER INTERFACE                                              |--
--| =========================================================== |--
local Divider = AuthTab:CreateDivider()

AuthTab:CreateParagraph({
    Title = "Welcome To Script RullzsyHUB",
    Content = "Username: " .. RobloxUsername .. "\n\nScript ini menggunakan sistem key, dan untuk mendapatkan key nya anda bisa claim freetrial atau membelinya di discord RullzsyHUB."
})

local TokenInput = AuthTab:CreateInput({
    Name = "🔒 Input Key",
    PlaceholderText = "Masukan key disini...",
    RemoveTextAfterFocusLost = false,
    Callback = function(t)
        enteredToken = tostring(t or ""):gsub("%s+", ""):gsub("[\n\r\t]", "")
    end
})

local function verifyAndLogin(token)
    local currentToken = token:gsub("%s+", ""):gsub("[\n\r\t]", "")
    if currentToken == "" or #currentToken < 5 then
        Rayfield:Notify({ Image = "triangle-alert", Title = "Key Kosong", Content = "Pastikan input key nya tidak boleh kosong.", Duration = 3 })
        return
    end
    Rayfield:Notify({ Image = "shield-half", Title = "Validating", Content = "Pengecekan token dengan username: " .. RobloxUsername .. "...", Duration = 2 })

    local valid, result = ValidateToken(currentToken)
    if valid then
        Rayfield:Notify({ Image = "check-check", Title = "Key Valid", Content = "Welcome! Loading main script...", Duration = 3 })
        saveToken(currentToken)
        getgenv().UserToken = currentToken
        getgenv().AuthComplete = true
        task.wait(1)

        local ok, res = safeHttpRequest(API_CONFIG.main_script_url)
        if ok then
            local fn, err = loadstring(res)
            if fn then
                Rayfield:Destroy()
                task.wait(0.5)
                pcall(fn)
            else
                Rayfield:Notify({ Title = "❌ Script Error", Content = tostring(err), Duration = 5 })
            end
        else
            Rayfield:Notify({ Image = "ban", Title = "Fetch Gagal", Content = tostring(res), Duration = 5 })
        end
    else
        Rayfield:Notify({ Image = "ban", Title = "Key salah!...", Content = tostring(result), Duration = 5 })
    end
end

AuthTab:CreateButton({
    Name = "🔴 Verify Key",
    Callback = function()
        verifyAndLogin(enteredToken)
    end
})

local Divider = AuthTab:CreateDivider()

AuthTab:CreateButton({
    Name = "🌐 Join Discord | RullzsyHUB",
    Callback = function()
        local inviteLink = "https://discord.gg/KEajwZQaRd"
        if setclipboard then
            setclipboard(inviteLink)
            Rayfield:Notify({ Image = "clipboard", Title = "Copied!", Content = "Link discord telah di copy.", Duration = 3 })
        else
            Rayfield:Notify({ Title = "🌐 Discord", Content = inviteLink, Duration = 5 })
        end
    end
})

local Divider = AuthTab:CreateDivider()
--| =========================================================== |--
--| USER INTERFACE - END                                        |--
--| =========================================================== |--