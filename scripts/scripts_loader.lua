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
local ScriptTab = Window:CreateTab("List All Scripts", "layers")
local UpdateTab = Window:CreateTab("Update Script", "file")

--| =========================================================== |--



--| =========================================================== |--
--| USER INTERFACE                                              |--
--| =========================================================== |--
local Section = ScriptTab:CreateSection("🔴 Total Map: 13")

local Divider = ScriptTab:CreateDivider()

ScriptTab:CreateButton({
	Name = "[◉] Mount Yahayuk",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Yahayuk...", Duration=4})
		loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_yahayuk.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Mount Sibuatan",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Sibuatan...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_sibuatan.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Mount Funny",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Funny...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_funny.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Mount Age",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Age...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_age.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Mount Yntkts",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Yntkts...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_yntkts.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Mount Hmmm",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Hmmm...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_hmmm.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Mount Pargoy",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Pargoy...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_pargoy.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Mount Yacape",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Yacape...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_yacape.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Sadewa City",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Sadewa City...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/sadewa_city.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Mount Arunika",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Arunika...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_arunika.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Mount Freestyle",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Freestyle...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_freestyle.lua"))()
	end
})

ScriptTab:CreateButton({
	Name = "[◉] Mount Ragon",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Ragon...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_ragon.lua"))()
	end
})


ScriptTab:CreateButton({
	Name = "[◉] Mount Bilek",
	Callback = function()
		Rayfield:Notify({Title="Executing", Image="file", Content="Loading Mount Bilek...", Duration=4})
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/0x0x0x0xblaze/RullzsyHUB/refs/heads/main/scripts/mount_bilek.lua"))()
	end
})

local Divider = ScriptTab:CreateDivider()
--| =========================================================== |--
--| USER INTERFACE - END                                        |--
--| =========================================================== |--



--| =========================================================== |--
--| UPDATE SCRIPT                                               |--
--| =========================================================== |--
local Section = UpdateTab:CreateSection("Update Script Menu")
local Paragraph = UpdateTab:CreateParagraph({
	Title = "Keterangan !!!",
	Content = "Jalankan update script menu, untuk mengupdate ke versi terbaru." .. "\n\n" .. "Panduan Cara Update:" .. "\n" .. "1. Jalankan toggle RUN UPDATE SCRIPT" .. "\n" .. "2. Tunggu sampai selesai update script" .. "\n" .. "3. Jika sudah selesai, silahkan execute ulang script nya."
})

-- Folder target
local targetFolder = "X_RULLZSYHUB_X"

-- Label status
local Label = UpdateTab:CreateLabel("📁 STATUS: ...")

-- Toggle Update Script
UpdateTab:CreateToggle({
	Name = "RUN UPDATE SCRIPT",
	CurrentValue = false,
	Callback = function(state)
		if state then
			task.spawn(function()
				Label:Set("📁 STATUS: Menghapus file cache...")
				Rayfield:Notify({
					Title = "Update Script",
					Content = "Proses menghapus cache...",
					Image = "file",
					Duration = 8
				})

				-- Hapus semua file + folder
				if isfolder(targetFolder) then
					local files = listfiles(targetFolder)
					for i, f in ipairs(files) do
						pcall(function() delfile(f) end)
						Label:Set("📁 STATUS: Proses Update ("..i.."/"..#files..")")
						task.wait(0.2)
					end

					-- Hapus folder utama setelah semua file terhapus
					task.wait(0.5)
					pcall(function() delfolder(targetFolder) end)

					Label:Set("📁 STATUS: Proses Update Selesai!...")
					Rayfield:Notify({
						Title = "Update Script",
						Content = "Proses hapus cache selesai...",
						Image = "check",
						Duration = 8
					})
				else
					Label:Set("📁 STATUS: Kamu sudah menggunakan versi terbaru!...")
					Rayfield:Notify({
						Title = "Update Script",
						Content = "Kamu sudah menggunakan versi terbaru, jadi ga usah di update lagi.",
						Image = "alert",
						Duration = 8
					})
				end

				task.wait(2)
				Rayfield:Notify({
					Title = "Proses Selesai",
					Content = "Update script selesai! Silahkan execute ulang script nya...",
					Image = "check-check",
					Duration = 8
				})
				task.wait(3)
				Rayfield:Destroy()
			end)
		end
	end
})
--| =========================================================== |--
--| UPDATE SCRIPT - END                                         |--
--| =========================================================== |--