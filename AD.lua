local function get_equip()
    for _, v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if v and v.ClassName == "Tool" then
            game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(v)
            return v.Name
        end
    end

    for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if v.ClassName == "Tool" then
            return v.Name
        end
    end
end

local function get_enemy()
    for _,v in next, game:GetService"Workspace":FindFirstChild("Enemies"):GetChildren() do
        if v:FindFirstChild("HumanoidRootPart") ~= nil then
            return v
        end
    end
    return nil
end

_G.farm = true

while _G.farm do
    if not _G.farm then break end
    local tool = get_equip()
    local enemy = get_enemy()

    if enemy then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, -6, 0) * CFrame.Angles(math.rad(90), 0, 0)
        game:GetService("RunService").Heartbeat:Connect(function()
            game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState(11)
        end)

        local data = {
            [1] = {
                [1] = enemy,
                [2] = enemy:FindFirstChild("HumanoidRootPart").Position
            }
        }
            
        game:GetService("ReplicatedStorage").Remotes.UseSword:InvokeServer(game.Players.LocalPlayer.Character:FindFirstChild(tool), data)
    end
end