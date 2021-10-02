local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MaiKokain/scripts/main/ui/kavo-modified.lua"))()
local Window = Library.CreateLib("Anime Worlds Simulator", "GrapeTheme")
local MainTab = Window:NewTab("Main")
local FarmSection = MainTab:NewSection("Farms")

_G.Config = {
    farm_ene = false,
    farm_bush = false,
    auto_attacks = false,
    bush_type = "YZFruit"
}

setmetatable(_G.Config, {
    __index = "Bruh",
    __metatable = "Bruh"
})

FarmSection:NewToggle("Auto Kill Enemy", "Automatically kills enemy.", function(state)
    _G.Config.farm_ene = state

    local function get_enemy()
        for _,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
            local plr_lvl = string.gsub(game.Players.LocalPlayer.Character.Head.PlayerOverhead.PlayerLevel.Text, "LEVEL ", "")
            local ene_lvl = string.gsub(v.HumanoidRootPart:FindFirstChildOfClass("BillboardGui").Back["NPC_Level"].Text, "LEVEL ", "")
            if v.ClassName == "Model" and v:FindFirstChild("Humanoid") ~= nil and tonumber(plr_lvl) >= tonumber(ene_lvl) then
                return v
            end
        end
        return nil
    end
    
    while _G.Config.farm_ene do
        if not _G.Config.farm_ene then break end
        local enemy = get_enemy()
        if enemy and enemy:FindFirstChild("Humanoid").Health >= 0 and _G.Config.farm_ene then
            local connect
            connect = game:GetService("RunService").Heartbeat:Connect(function()
                if enemy:FindFirstChild("HumanoidRootPart") == nil or _G.Config.farm_ene == false then connect:Disconnect() end
                game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState(11)
            end)
            repeat wait()
                if enemy:FindFirstChild("HumanoidRootPart") == nil then break end
                game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
                    CFrame = enemy:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                }):Play()
                local ohString1 = "Melee"
                local ohString2 = "Punch"
            
                game:GetService("ReplicatedStorage").Remotes.Events.PerformAttack:FireServer(ohString1, ohString2)
            until enemy:FindFirstChild("Humanoid").Health <= 0 or _G.Config.farm_ene == false
        end
        wait()
    end
end)

FarmSection:NewToggle("Auto use Attacks", "Automatically use Fighters Attachs", function(state)
    _G.Config.auto_attacks = state

    local function get_attacks_frame()
        local atk_tb = {}
        local atk_frame_path = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Bottom.Attacks:GetChildren()
        for i = 1, #atk_frame_path do
            if atk_frame_path[i]:IsA("Frame") and string.match(atk_frame_path[i].Name, 'Slot') then
                table.insert(atk_tb, atk_frame_path[i])
            end
        end
        return atk_tb
    end

    while _G.Config.auto_attacks do
        if not _G.Config.auto_attacks then break end
        local br = get_attacks_frame()
        for i = 1, #br do
            br[i].UseAttack:Fire()
            wait()
        end
        wait()
    end
end)

local bush, bushes = game:GetService("Workspace").FruitBushes:GetChildren(), {}
for i = 1, #bush do
    table.insert(bushes, bush[i].Name)
end

FarmSection:NewDropdown("Select Bush", "Selects a bush for Auto Bush.", bushes, function(txt)
    _G.Config.bush_type = txt
end)

FarmSection:NewToggle("Auto Hit Bush", "Automatically Hit Bush. By Selected Type.", function(state)
    _G.Config.farm_bush = state
    
    local function get_bush()
        for _,v in next, (game:GetService("Workspace").FruitBushes:FindFirstChild(_G.Config.bush_type):GetChildren()) do
            if v.ClassName == "Part" and v:FindFirstChild(_G.Config.bush_type) ~= nil then
                return v
            end
        end
        return nil
    end
    
    while _G.Config.farm_bush do
        if not _G.Config.farm_bush then break end
        local bush = get_bush()
        if bush and bush:FindFirstChild(_G.Config.bush_type) then
            local connect
            connect = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.Config.farm_bush == false or bush:FindFirstChild(_G.Config.bush_type) == nil then
                    connect:Disconnect()
                end
                game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
            end)
            repeat wait()
                game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
                    CFrame = bush.CFrame * CFrame.new(0, 1, 0)
                }):Play()
                local ohString1 = "Melee"
                local ohString2 = "Punch"
                
                game:GetService("ReplicatedStorage").Remotes.Events.PerformAttack:FireServer(ohString1, ohString2)
            until bush:FindFirstChild(_G.Config.bush_type) == nil or _G.Config.farm_bush == false
        end
        wait()
    end
end)

--[[
    // Auto hatch

    for i = 1, 10 do
        game:GetService("ReplicatedStorage").Remotes.Events.HatchOrb:FireServer(tostring(i))
        game:GetService("RunService").RenderStepped:Wait()
    end
]]