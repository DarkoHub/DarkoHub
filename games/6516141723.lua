-- TODO --
-- Make debug and optional loadstring
-- Maybe make this script a own project not in the Darko project

local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local playerGui = lp.PlayerGui

local mainUI = playerGui:WaitForChild("MainUI")
local mainGame = mainUI:WaitForChild("Initiator"):WaitForChild("Main_Game")
local mainGameSrc = require(mainGame)

local Script = {
    Functions = {},
    ESPTable = {
        Chest = {},
        Door = {},
        Entity = {},
        SideEntity = {},
        Gold = {},
        Guiding = {},
        Item = {},
        Objective = {},
        Player = {},
        HidingSpot = {},
        None = {}
    },
}
type ESP = {
    Color: Color3,
    IsEntity: boolean,
    Object: Instance,
    Text: string,
    TextParent: Instance,
    Type: string,
}
local entities = {"RushMoving", "Eyes"}
local current_room_location = 0
local auto_replay_wait = false


local window = engine.new({
    text = "Darko | Doors | "..game.PlaceId,
    size = Vector2.new(450, 200),
})
window.open()

local main = window.new({
    text = "Main",
})
local exploits = window.new({
    text = "Exploits",
})
local esp = window.new({
    text = "ESP",
})
local visuals = window.new({
    text = "Visuals",
})
local misc = window.new({
    text = "Misc",
})
local credits = window.new({
    text = "Credits",
})
local debug = window.new({
    text = "Debug",
})

-- << ESP >> --

local esp_enabled = esp.new("switch", {
    text = "ESP Enabled",
})

-- << VISUALS >> --

local field_of_view = visuals.new("slider", {
    text = "FOV",
    color = Color3.new(0, 0, 0),
    min = 70,
    max = 120,
    value = 70,
    rounding = 10,
})

-- << MISC >> --

local auto_replay = misc.new("switch", {
    text = "Auto Replay",
})

local speed_boost = misc.new("slider", {
    text = "Speed Boost",
    color = Color3.new(0, 0, 1.5),
    min = 0,
    max = 7,
    value = 0,
    rounding = 1,
})

-- << EXPLOITS >> --

local anti_eyes = exploits.new("switch", {
    text = "Anti Eyes",
})

-- << DEBUG >> --

local is_entity = debug.new("label", {
    text = "Is Entity: false | nil",
    color = Color3.new(1, 0, 0),
})

local lp_health = debug.new("label", {
    text = "Health: "..lp.Character.Humanoid.Health,
    color = Color3.new(0, 1, 0),
})

local lp_position = debug.new("label", {
    text = "Position: "..tostring(lp.Character.HumanoidRootPart.Position),
    color = Color3.new(0.5, 0.5, 0.5),
})

local current_room = debug.new("label", {
    text = "Current Room: 0",
    color = Color3.new(0.5, 0, 0.5),
})

local locate_key = debug.new("button", {
    text = "Locate Key",
})

-- << FUNCTIONS >> --

function Script.Functions.ESP(args: ESP)

    local ESPManager = {
        Color = args.Color,
        IsEntity = args.IsEntity,
        Object = args.Object,
        Text = args.Text,
        TextParent = args.TextParent,
        Type = args.Type or "None",

        Highlights = {},
        Humanoid = nil,
        RSConnection = nil,
    }

    local tableIndex = #Script.ESPTable[ESPManager.Type] + 1

    local highlight = Instance.new("Highlight") do
        highlight.Adornee = ESPManager.Object
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = ESPManager.Object
    end
    table.insert(ESPManager.Highlights, highlight)

    if ESPManager.IsEntity and ESPManager.Object.PrimaryPart.Transparency == 1 then
        ESPManager.Humanoid = Instance.new("Humanoid", ESPManager.Object)
        ESPManager.Object.PrimaryPart.Transparency = 0.99
    end

    local billboardGui = Instance.new("BillboardGui") do
        billboardGui.Adornee = ESPManager.TextParent or ESPManager.Object
		billboardGui.AlwaysOnTop = true
		billboardGui.ClipsDescendants = false
		billboardGui.Size = UDim2.new(0, 1, 0, 1)
		billboardGui.StudsOffset = ESPManager.Offset
        billboardGui.Parent = ESPManager.TextParent or ESPManager.Object
	end

    local textLabel = Instance.new("TextLabel") do
		textLabel.BackgroundTransparency = 1
		textLabel.Font = Enum.Font.Oswald
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.Text = ESPManager.Text
		textLabel.TextColor3 = ESPManager.Color
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.TextStrokeTransparency = 0.75
        textLabel.Parent = billboardGui
	end

    function ESPManager.Destroy()
        if ESPManager.RSConnection then
            ESPManager.RSConnection:Disconnect()
        end

        if ESPManager.IsEntity and ESPManager.Object then
            if ESPManager.Humanoid then
                ESPManager.Humanoid:Destroy()
            end
            if ESPManager.Object.PrimaryPart then
                ESPManager.Object.PrimaryPart.Transparency = 1
            end
        end

        for _, highlight in pairs(ESPManager.Highlights) do
            highlight:Destroy()
        end
        if billboardGui then billboardGui:Destroy() end

        if Script.ESPTable[ESPManager.Type][tableIndex] then
            Script.ESPTable[ESPManager.Type][tableIndex] = nil
        end
    end

    ESPManager.RSConnection = RunService.Stepped:Connect(function()
        if not ESPManager.Object or not ESPManager.Object:IsDescendantOf(workspace) then
            ESPManager.Destroy()
            return
        end

        for _, highlight in pairs(ESPManager.Highlights) do
            highlight.Enabled = esp_enabled.on
        end
    end)

    Script.ESPTable[ESPManager.Type][tableIndex] = ESPManager
    return ESPManager
end

locate_key.event:Connect(function()
    for _, v in pairs(workspace.CurrentRooms:FindFirstChild(current_room_location):GetDescendants()) do
        if v.Name == "KeyObtain" then
            if v:FindFirstChild("locate esp") then
                return
            else
                local esp = Instance.new("Highlight")
                esp.Name = "locate esp"
                esp.Parent = v
            end
        end
    end
end)

workspace.ChildAdded:Connect(function(child)
    if table.find(entities, tostring(child.Name)) then
        is_entity.setText("Is Entity: true | ".. tostring(child.Name))
        is_entity.setColor(Color3.new(0, 1, 0))
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Workspace";
            Text = tostring(child.Name).." has been added to the workspace.";
            Duration = 5;
        })
    end
end)

workspace.ChildRemoved:Connect(function(child)
    if table.find(entities, tostring(child.Name)) then
        is_entity.setText("Is Entity: false | nil")
        is_entity.setColor(Color3.new(1, 0, 0))
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Workspace";
            Text = tostring(child.Name).." has been removed from the workspace.";
            Duration = 5;
        })
    end
end)

lp.Character.Humanoid.HealthChanged:Connect(function(health)
    if health > 75 then
        lp_health.setColor(Color3.new(0, 1, 0))
    elseif health > 25 then
        lp_health.setColor(Color3.new(1, 1, 0))
    else
        lp_health.setColor(Color3.new(1, 0, 0))
    end
    lp_health.setText("Health: "..health)
end)

-- Might slow down the game

-- lp.Character.Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
--     task.wait(0.1)
--     lp_position.setText("Position: "..tostring(lp.Character.HumanoidRootPart.Position))
-- end)

workspace.CurrentRooms.ChildAdded:Connect(function(child)
    current_room_location = tonumber(child.Name) - 1
    current_room.setText("Current Room: "..tostring(current_room_location))
end)

RunService.RenderStepped:Connect(function()
    if lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = 15 + speed_boost.value end
    if field_of_view.value > 70 then
        mainGameSrc.fovtarget = field_of_view.value
    end
    if auto_replay.on then
        if lp.Character.Humanoid.Health == 0 then
            if auto_replay_wait then
                return
            else
                auto_replay_wait = true
                task.wait(4)
                game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("PlayAgain"):FireServer()
                auto_replay_wait = false
            end
        end
    end
    if anti_eyes.on then
        remotesFolder.MotorReplication:FireServer(-649)
    end
end)