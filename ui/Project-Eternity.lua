local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

getgenv().library_config = {
    loaded = false,
    name = ""
}

if game:WaitForChild("CoreGui"):FindFirstChild(getgenv().library_config.name) ~= nil and getgenv().library_config.loaded then
    game:WaitForChild("CoreGui"):FindFirstChild(getgenv().library_config.name):Destroy()
    getgenv().library_config.loaded = false
end
wait()
local library = {}
local util = {}

--[[
    * @param {number} length
    * @returns {string}
]]
function util:GenName(length: number)
    math.randomseed(os.time())
    local char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789"

    local random_string = {}

    for int = 1, length or 10 do
        local random_num = math.random(1, #char)
        local char = string.sub(char, random_num, random_num)

        random_string[#random_string+1] = char
    end

    return table.concat(random_string)
end

function util:Drag(frame, parent)
    parent = parent or frame
    
    -- stolen from wally or kiriot, kek
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            -- parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
            TweenService:Create(parent, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

getgenv().library_config.name = util:GenName(15)

function library:new(name)
    name = name or "<font color='rgb(0,0,0)'>Porn</font><font color='rgb(255,163,26)'>Hub</font>"

    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local Side = Instance.new("Frame")
    local TabContainer = Instance.new("ScrollingFrame")
    local TabContainerLayout = Instance.new("UIListLayout")
    local Title = Instance.new("TextLabel")
    local ElementContainer = Instance.new("Frame")
    local ElementContainerCorner = Instance.new("UICorner")

    ScreenGui.Name = getgenv().library_config.name
    ScreenGui.Parent = game:WaitForChild("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(34, 47, 62)
    Main.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.301066428, 0, 0.224321067, 0)
    Main.Size = UDim2.new(0, 484, 0, 466)
    
    util:Drag(Main)

    Side.Name = "Side"
    Side.Parent = Main
    Side.BackgroundColor3 = Color3.fromRGB(50, 69, 91)
    Side.BorderSizePixel = 0
    Side.Size = UDim2.new(0, 141, 0, 466)
    
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Side
    TabContainer.Active = true
    TabContainer.BackgroundColor3 = Color3.fromRGB(50, 69, 91)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0.139484972, 0)
    TabContainer.Size = UDim2.new(0, 141, 0, 401)
    TabContainer.ScrollBarThickness = 0
    TabContainer.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
    
    TabContainerLayout.Name = "TabContainerLayout"
    TabContainerLayout.Parent = TabContainer
    TabContainerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabContainerLayout.Padding = UDim.new(0, 3)

    Title.Name = "Title"
    Title.Parent = Side
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.0780141875, 0, 0.0150214592, 0)
    Title.Size = UDim2.new(0, 119, 0, 43)
    Title.Font = Enum.Font.Ubuntu
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(244, 235, 244)
    Title.TextSize = 18.000
    
    ElementContainer.Name = "ElementContainer"
    ElementContainer.Parent = Main
    ElementContainer.BackgroundColor3 = Color3.fromRGB(29, 40, 53)
    ElementContainer.BorderSizePixel = 0
    ElementContainer.Position = UDim2.new(0.307851225, 0, 0.0150214592, 0)
    ElementContainer.Size = UDim2.new(0, 326, 0, 451)

    ElementContainerCorner.CornerRadius = UDim.new(0, 10)
    ElementContainerCorner.Name = "ElementContainerCorner"
    ElementContainerCorner.Parent = ElementContainer

    local tabs = {}

    function tabs:tab(name)
        name = name or "Tab"

        local Tab = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local ElementHolder = Instance.new("ScrollingFrame")
        local ElementHolderLayout = Instance.new("UIListLayout")
        local ElementHolderPadding = Instance.new("UIPadding")
        
        local function Resize()
            local ACS = ElementHolderLayout.AbsoluteContentSize

            TweenService:Create(ElementHolder, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                CanvasSize = UDim2.new(0, ACS.X, 0, ACS.Y)
            }):Play()
        end

        Tab.Name = "Tab"
        Tab.Parent = TabContainer
        Tab.BackgroundColor3 = Color3.fromRGB(81, 112, 148)
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0.0390070938, 0, 0, 0)
        Tab.Size = UDim2.new(0, 130, 0, 33)
        Tab.Font = Enum.Font.Ubuntu
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.TextSize = 20.000
        Tab.MouseButton1Click:Connect(function()
            Resize()
            TweenService:Create(Tab, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(44, 60, 80)
            }):Play()
            ElementHolder.Visible = true
        end)
        
        TabCorner.CornerRadius = UDim.new(0, 5)
        TabCorner.Name = "TabCorner"
        TabCorner.Parent = Tab

        ElementHolder.Name = "ElementHolder"
        ElementHolder.Parent = ElementContainer
        ElementHolder.Active = true
        ElementHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ElementHolder.BackgroundTransparency = 1.000
        ElementHolder.BorderSizePixel = 0
        ElementHolder.Size = UDim2.new(0, 326, 0, 451)
        ElementHolder.ScrollBarThickness = 0
        ElementHolder.Visible = false
        
        ElementHolderLayout.Name = "ElementHolderLayout"
        ElementHolderLayout.Parent = ElementHolder
        ElementHolderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ElementHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ElementHolderLayout.Padding = UDim.new(0, 5)
        
        ElementHolderPadding.Name = "ElementHolderPadding"
        ElementHolderPadding.Parent = ElementHolder
        ElementHolderPadding.PaddingBottom = UDim.new(0, 5)
        ElementHolderPadding.PaddingTop = UDim.new(0, 5)

        local Elements = {}

        function Elements:button(name, callback)
            name = name or "Button"
            callback = callback or function () end

            local ElementButton = Instance.new("TextButton")
            local ElementButtonCorner = Instance.new("UICorner")

            ElementButton.Name = "ElementButton"
            ElementButton.Parent = ElementHolder
            ElementButton.BackgroundColor3 = Color3.fromRGB(34, 47, 62)
            ElementButton.Position = UDim2.new(0.0245398767, 0, 0.0077605322, 0)
            ElementButton.Size = UDim2.new(0, 310, 0, 28)
            ElementButton.Font = Enum.Font.Ubuntu
            ElementButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ElementButton.TextSize = 20.000
            ElementButton.Text = name
            
            ElementButtonCorner.CornerRadius = UDim.new(0, 10)
            ElementButtonCorner.Name = "ElementButtonCorner"
            ElementButtonCorner.Parent = ElementButton

            Resize()

            ElementButton.MouseButton1Click:Connect(function()
                pcall(callback)
            end)

            local button_functions = {}

            function button_functions:Destroy()
                ElementButton:Destroy()
            end

            function button_functions:Rename(new_name)
                new_name = new_name or "Renamed Button"
                ElementButton.Text = new_name
            end

            function button_functions:ChangeCallback(new_callback)
                new_callback = new_callback or function() end
                callback = new_callback
            end

            return button_functions
        end
        return Elements
    end
    return tabs
end

local lib = library:new('test')
local tab = lib:tab('test2')
local test_btn = tab:button('lol', function()
    print('err')
end)
tab:button('destroy test btn', function()
    test_btn:Destroy()
end)
tab:button('rename test btn', function()
    test_btn:Rename('lol bruh')
end)
tab:button('change callback', function()
    test_btn:ChangeCallback(function()
        print('callme')
    end)
end)