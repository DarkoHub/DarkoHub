local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()

local RunService = game:GetService("RunService")

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local playerGui = lp.PlayerGui

local mainUI = playerGui:WaitForChild("MainUI")
local mainGame = mainUI:WaitForChild("Initiator"):WaitForChild("Main_Game")
local mainGameSrc = require(mainGame)

local entities = {
    "RushMoving",
    "Eyes"
}
local current_room_location = 0


local window = engine.new({
    text = "Darko | Doors | "..game.PlaceId,
    size = Vector2.new(450, 200),
})
window.open()

-- << MISC >> --

local misc = window.new({
    text = "Misc",
})

local field_of_view = misc.new("slider", {
    text = "FOV",
    color = Color3.new(0, 0, 0),
    min = 70,
    max = 120,
    value = 70,
    rounding = 10,
})
field_of_view.event:Connect(function(x)
    mainGameSrc.fovtarget = x
end)

RunService.RenderStepped:Connect(function()
    mainGameSrc.fovtarget = field_of_view.value
end)

-- << DEBUG >> --

local debug = window.new({
    text = "Debug",
})

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

lp.Character.Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
    task.wait(0.1)
    lp_position.setText("Position: "..tostring(lp.Character.HumanoidRootPart.Position))
end)

workspace.CurrentRooms.ChildAdded:Connect(function(child)
    current_room_location = tonumber(child.Name) - 1
    current_room.setText("Current Room: "..tostring(current_room_location))
end)