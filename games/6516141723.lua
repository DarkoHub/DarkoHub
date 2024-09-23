local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()
local entities = {
    "RushMoving",
    "Eyes"
}

local window = engine.new({
    text = "Darko | Doors | "..game.PlaceId,
    size = Vector2.new(300, 200),
})
window.open()

local main = window.new({
    text = "Main",
})

local is_entity = main.new("label", {
    text = "Is Entity: false | nil",
    color = Color3.new(1, 0, 0),
})

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
