local GameName = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.roblox.com/Marketplace/ProductInfo?assetId=6897226634"))["Name"]

local Client = { SavedSetting = false }

for _,ScreenGui in next, game:GetService("CoreGui"):GetChildren() do
    if ScreenGui.ClassName == "ScreenGui" and ScreenGui.Name == GameName then
        ScreenGui:Destroy()
    end
end



local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new(GameName, 5013109572)

--SECTION Services
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local PathFindingServices = game:GetService("PathfindingService")
local Path = PathFindingServices:CreatePath()

if (isfile and isfile(tostring(game.PlaceId)..".json")) then
    Client.SavedSetting = true
    Client.GameSetting = game:GetService('HttpService'):JSONDecode(readfile(tostring(game.PlaceId)..".json"))
else
    Client.SavedSetting = false
end

--SECTION Tables
local Configs = {
    AutoFarm = false,
    AutoExpand = false,
    AutoCollectHoney = false,
    AutoRebirth = false,
    Upgrades = {
        NormalAuto = false,
        RebirthAuto = false,
        NormalType = Client.SavedSetting and Client.GameSetting.Upgrades.NormalType or nil,
        RebirthType = Client.SavedSetting and Client.GameSetting.Upgrades.RebirthType or nil,
    },
    PathConfig = {
        Color = Color3.fromRGB(255,255,255),
        Shape = Client.SavedSetting and Client.GameSetting.PathConfig.Shape or "Ball",
        Material = Client.SavedSetting and Client.GameSetting.PathConfig.Material or "Neon"
    },
    themes = {
        Background = Color3.fromRGB(24, 24, 24),
        Glow = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(10, 10, 10),
        LightContrast = Color3.fromRGB(20, 20, 20),
        DarkContrast = Color3.fromRGB(14, 14, 14),  
        TextColor = Color3.fromRGB(255, 255, 255)
    },
    
}


local Data = {
    UpgradeTable = {
        Normal = {
            "WalkSpeed",
            "Tree Growth",
            "Axe Strength",
            "Golden Chance",
            "Workers",
            "Workers Strength",
            "Worker WalkSpeed",
            "Worker Max Logs"
        },
        NormalData = {
            ["WalkSpeed"] = "Speed",
            ["Tree Growth"] = "TreeGrowth",
            ["Axe Strength"] = "AxeStrength",
            ["Golden Chance"] = "GoldenChance",
            ["Workers"] = "WCount",
            ["Workers Strength"] = "WStrength",
            ["Worker WalkSpeed"] = "WSpeed",
            ["Worker Max Logs"] = "WLogs"
        },
        Rebirth = {
            "Raft Speed",
            "Log Multiplier",
            "Max Workers",
            "Farmer Capacity",
            "Fisherman Boost"
        },
        RebirthData = {
            ["Raft Speed"] = "RaftSpeed",
            ["Log Multiplier"] = "LogMultiplier",
            ["Max Workers"] = "MaxWorkers",
            ["Farmer Capacity"] = "FarmerCapacity",
            ["Fisherman Boost"] = "FishermanBoost",
        },

        UpgradePath = {
            Speed = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["Main"]["Hold"]["Speed"],
            TreeGrowth = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["Main"]["Hold"]["TreeGrowth"],
            GoldenChance = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["Main"]["Hold"]["GoldenChance"],
            WCount = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["Main"]["Hold"]["WCount"],
            WStrength = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["Main"]["Hold"]["WStrength"],
            WSpeed = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["Main"]["Hold"]["WSpeed"],
            WLogs = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["Main"]["Hold"]["WLogs"],
            RaftSpeed = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["RebirthUpgrades"]["Hold"]["RaftSpeed"],
            LogMultiplier = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["RebirthUpgrades"]["Hold"]["LogMultiplier"],
            MaxWorkers = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["RebirthUpgrades"]["Hold"]["MaxWorkers"],
            FarmerCapacity = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["RebirthUpgrades"]["Hold"]["FarmerCapacity"],
            FishermanBoost = Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["UpgradeMenu"]["RebirthUpgrades"]["Hold"]["FishermanBoost"]
        }
    }
}

local Functions = {}

-- setrawmetatable(Data and Functions and Configs, { __metatable = "LOL Imagine" })

--SECTION Functions
Functions.Notify = function(context, title, callback)
    callback = callback or function() end
    context = context or "Notification Text"
    title = title or "Notification Title"
    
    venyx:Notify(title, context, callback)
end

Functions.GetEnum = function(enum)
    if not (enum) then Functions.Notify('[GetEnum]: Missing Enum.', 'Error') end
    local tab = {}
	for _,v in pairs(enum:GetEnumItems()) do
        local gsub = string.gsub(tostring(v), 'Enum.'..tostring(enum)..'.','')
		table.insert(tab, gsub)
	end
	
	return tab
end

Functions.TweenToPos = function(...)
    local pos = ...
    if not (pos) then Functions.Notify('[Walk To Positon Function]: Missing Position.', "Error") end
    if not (type(pos) == "number" ) then Functions.Notify('[Walk To Positon Function]: Position Must Be a Number.', "Error") end

    game:GetService("TweenService"):Create(Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(9), {
        CFrame = ...
    }):Play()
end

Functions.GetPlot = function()
    for _,plot in next, game:GetService("Workspace").Plots:GetChildren() do
        if (plot:WaitForChild("Owner").Value == Players.LocalPlayer or plot:WaitForChild("Owner") == Players.LocalPlayer.Character) then
            return plot
        end
    end
    return nil
end

Functions.GetTrees = function()
    local plot = Functions.GetPlot();
    local RandomTree = nil
    local branch = nil
    for a,x in next, plot:GetChildren() do
        if x:IsA("Model") then
            for l, d in next, x:GetChildren() do
                if string.find(d.Name, "Tree") then
                    RandomTree = d
                    branch = x
                    break  
                end
            end
        end
    end

    return RandomTree, branch
end


Functions.AutoFarm = function()

    while RunService.Heartbeat:Wait() do
        local choice, branch = Functions.GetTrees()
        local treeNum = string.gsub(choice.Name, "Tree_", "")

        Path:ComputeAsync(Players.LocalPlayer.Character.HumanoidRootPart.Position, choice:WaitForChild("Base").Position)
        local waypoints = Path:GetWaypoints()

        for _,v in pairs(waypoints) do
            if (Configs.AutoFarm == false) then Players.LocalPlayer.Character.Humanoid:MoveTo(nil) end
            
            local Part = Instance.new("Part")
            Part.Shape = Configs.PathConfig.Shape
            Part.Material = Configs.PathConfig.Material
            Part.Size = Vector3.new(0.5,0.5,0.5)
            Part.Position = v.Position
            Part.Anchored = true
            Part.CanCollide = false
            Part.Color = Configs.PathConfig.Color
            Part.Parent = game:GetService("Workspace")

            Players.LocalPlayer.Character.Humanoid:MoveTo(v.Position)
            Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait(2)
            Part:Destroy()

        end
    
        if choice ~= nil and branch ~= nil then
            game:GetService("ReplicatedStorage").Communication.Remotes.HitTree:FireServer(Functions.GetPlot().Name,tostring(branch),treeNum)
        end
    end 
end

Functions.ExpandArea = function()
    for _,v in next, game:GetService("Workspace").Promps.Expansion:GetChildren() do
        if (v.ClassName == "Part" and v:FindFirstChild("Decal") ~= nil and v:FindFirstChild("TouchInterest") ~= nil) then
            v.CanCollide = false
            
            local cost = string.gsub(tostring(v.BillboardGui.Cost.Text), "%$", "")

            -- print(cost)

            if (Players.LocalPlayer.leaderstats.Coins.Value >= tonumber(cost)) then
                v.CFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            else
                return
            end
        end
    end
end


Functions.SuffixStringToNum = function(num)
    local suffixes = {"K", "M", "B", "T", "Q"}

    local n, suffix = string.match(num, "(.*)(%a)$")
	if n and suffix then
		local i = table.find(suffixes, suffix) or 0
		return tonumber(n) * math.pow(10, i * 3)
	end
	return tonumber(num)
end

Functions.SplitChar = function(source, sep)
    local result, i = {}, 1
    while true do
        local a, b = source:find(sep)
        if not a then break end
        local candidat = source:sub(1, a - 1)
        if candidat ~= "" then 
            result[i] = candidat
        end i=i+1
        source = source:sub(b + 1)
    end
    if source ~= "" then 
        result[i] = source
    end
    return result
end


Functions.AutoRebirth = function()
    if Functions.GetPlot():FindFirstChild("0_0") ~= nil and Functions.GetPlot()["0_0"]:FindFirstChild("Rebirth") ~= nil then
        
        local cost = Functions.SuffixStringToNum(Functions.GetPlot()["0_0"]["Rebirth"].BillboardGui.Cost.Text)

        if (Players.LocalPlayer.leaderstats.Coins.Value >= cost) then
            -- Players.LocalPlayer.Character.Humanoid:MoveTo(nil)
            -- wait()
            Players.LocalPlayer.Character.Humanoid:MoveTo(Functions.GetPlot()["0_0"]["Rebirth"].Position)
        else
            return
        end
    end
end

Functions.GetHoney = function()
    local Plot = Functions.GetPlot()

    if Plot:FindFirstChild("-3_-3") ~= nil then
        local Honey = Functions.SplitChar(Plot["-3_-3"].Jar.Lid.BillboardGui.Counter.Text, "/")
        local current, max = Honey[1], Honey[2]

        if tonumber(current) >= tonumber(max) then
            -- Players.LocalPlayer.Character.Humanoid:MoveTo(nil)
            -- wait()
            Players.LocalPlayer.Character.Humanoid:MoveTo(Plot["-3_-3"].Claim.Position)
        else
            return
        end
    end
end

--SECTION Main
local HomePage = venyx:addPage("Home", 6026568198)
local CreditSection = HomePage:addSection("Credits")
CreditSection:addButton("Developed By: Hentai#4902")
CreditSection:addButton("UI By: Venyx")


local FarmPage = venyx:addPage("Auto", 6023565901)
local AutoFarmSection = FarmPage:addSection("Auto Farm(s)")

AutoFarmSection:addToggle("Auto Farm", nil,function(state)
    Configs.AutoFarm = state
    
    RunService.Stepped:Connect(function()
        if (Configs.AutoFarm) then
            Players.LocalPlayer.Character.Humanoid:ChangeState(11)
        end
    end)

    if (Configs.AutoFarm) then
        Players.LocalPlayer.Character.Humanoid:ChangeState(11)
        repeat RunService.Heartbeat:Wait()
            Functions.AutoFarm()
        until Configs.AutoFarm == false
    else
        Players.LocalPlayer.Character.Humanoid:ChangeState(11)
    end
end)


AutoFarmSection:addToggle("Auto Expand", nil, function(state)
    Configs.AutoExpand = state
    if (Configs.AutoExpand) then
        repeat
            RunService.Heartbeat:Wait() 
            Functions.ExpandArea()
        until Configs.AutoExpand == false
    end
end)

AutoFarmSection:addToggle("Auto Collect Honey", nil, function(state)
    Configs.AutoCollectHoney = state

    if (Configs.AutoCollectHoney) then
        repeat RunService.Heartbeat:Wait()
            Functions.GetHoney()
        until Configs.AutoCollectHoney == false
    end
end)

AutoFarmSection:addToggle("Auto Rebirth", nil, function(state)
    Configs.AutoRebirth = state

    if (Configs.AutoRebirth) then
        repeat RunService.Heartbeat:Wait()
            Functions.AutoRebirth()
        until Configs.AutoRebirth == false
    end
end)

AutoFarmSection:addDropdown("Select Upgrade (Normal)", Data.UpgradeTable.Normal, function(txt)
    Configs.Upgrades.NormalType = Data.UpgradeTable.NormalData[txt]
    -- print(Configs.Upgrades.NormalType)
end)

AutoFarmSection:addDropdown("Select Upgrade (Rebirth)", Data.UpgradeTable.Rebirth, function(txt)
    Configs.Upgrades.RebirthType = Data.UpgradeTable.RebirthData[txt]
    -- print(Configs.Upgrades.RebirthType)
end)


AutoFarmSection:addToggle("Auto Upgrade (Normal)", nil, function(state)
    Configs.Upgrades.NormalAuto = state
    if (Configs.Upgrades.NormalAuto) then
        repeat RunService.Heartbeat:Wait()
            game:GetService("ReplicatedStorage").Communication.Remotes.Upgrade:FireServer(Configs.Upgrades.NormalType)
        until Configs.Upgrades.NormalAuto == false
    end
end)

AutoFarmSection:addToggle("Auto Upgrade (Rebirth)", nil, function(state)
    Configs.Upgrades.RebirthAuto = state
    if (Configs.Upgrades.RebirthAuto) then
        repeat RunService.Heartbeat:Wait()
            game:GetService("ReplicatedStorage").Communication.Remotes.Upgrade:FireServer(Configs.Upgrades.NormalType)
        until Configs.Upgrades.RebirthAuto == false
    end
end)

local SettingPage = venyx:addPage("Utilities", 6031280882)

local LocalPlayerSection = SettingPage:addSection("Others")
LocalPlayerSection:addToggle("Jesus", nil, function(state)
    if (game:GetService("Workspace"):WaitForChild("Water") ~= nil) then
    	game:GetService("Workspace")["Water"].CanCollide = state
    end
end)
LocalPlayerSection:addToggle("Show Compass", nil, function(state)
    if (Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["Display"]:WaitForChild("Compass") ~= nil) then
        Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["Display"]["Compass"].Active = true
        Players.LocalPlayer.PlayerGui:FindFirstChild("Main")["Display"]["Compass"].Visible = state
    end
end)
-- LocalPlayerSection:addButton("Redeem All Code", function()
--     for _,code in next, (Data.codes) do
--         game:GetService("ReplicatedStorage").Communication.Bindables.RedeemCode:InvokeServer(code)
--     end
-- end)

local Customization = venyx:addPage("Customization", 6034925618)

local PathSetting = Customization:addSection("Path Customize")
PathSetting:addColorPicker("Path Color", Color3.fromRGB(255,255,255), function(color3) 
    Configs.PathConfig.Color = color3
end)
PathSetting:addDropdown("Path Shape", Functions.GetEnum(Enum.PartType), function(txt)
    Configs.PathConfig.Shape = txt
end)
PathSetting:addDropdown("Part Material", Functions.GetEnum(Enum.Material), function(txt)
    Configs.PathConfig.Material = txt
end)
PathSetting:addButton("View Part", function()
    local ViewPart = Instance.new('Part')
    ViewPart.Parent = game:GetService("Workspace")
    ViewPart.Shape = Configs.PathConfig.Shape
    ViewPart.Material = Configs.PathConfig.Material
    ViewPart.Size = Vector3.new(0.5,0.5,0.5)
    ViewPart.Position = Players.LocalPlayer.Character.HumanoidRootPart.Position
    ViewPart.Anchored = true
    ViewPart.CanCollide = false
    ViewPart.Color = Configs.PathConfig.Color
    Functions.Notify("[View Part]: Part will be Destoryed in 10 Seconds", "Info")
    wait(10)
    ViewPart:Destroy()
end)


local ThemePickerSection = Customization:addSection("Theme's Customize (Doesn't Save to lazy)")
for theme, color in pairs(Configs.themes) do
    ThemePickerSection:addColorPicker(theme, color, function(color3)
        venyx:setTheme(theme, color3)
    end)
end

if writefile then
    while true do
        RunService.Heartbeat:Wait(5)
        if (Client.SavedSetting) then
            writefile(tostring(game.PlaceId)..".json", game:GetService("HttpService"):JSONEncode({
                Upgrades = {
                    NormalType = Configs.Upgrades.NormalType,
                    RebirthType = Configs.Upgrades.RebirthType,
                },
                PathConfig = {
                    Shape = Configs.PathConfig.Shape or "Ball",
                    Material = Configs.PathConfig.Material or "Neon"
                }
            }))
        else
            writefile(tostring(game.PlaceId)..".json", game:GetService("HttpService"):JSONEncode({
                Upgrades = {
                    NormalType = nil,
                    RebirthType = nil,
                },
                PathConfig = {
                    Shape = "Ball",
                    Material = "Neon"
                }
            }))
            Client.SavedSetting = true
        end
    end
end