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
    Name = "RullzsyHUB | Script Loader",
    Icon = "braces",
    LoadingTitle = "Created By RullzsyHUB",
    LoadingSubtitle = "Follow Tiktok: @rullzsy99",
    Theme = RedDarkTheme,
})

-- Tab Menu
local ScriptsTab = Window:CreateTab("List All Scripts", "layers")

--| =========================================================== |--



--| =========================================================== |--
--| USER INTERFACE                                              |--
--| =========================================================== |--
local Section = ScriptsTab:CreateSection("🔴 Total Map: 5")

local Divider = ScriptsTab:CreateDivider()

ScripstTab:CreateButton({
	Name = "[ 1 ] Mount Yahayuk",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Yahayuk...", Duration=4})
		loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_yahayuk.lua"))()
	end
})

local Divider = ScriptsTab:CreateDivider()
--| =========================================================== |--
--| USER INTERFACE - END                                        |--
--| =========================================================== |--