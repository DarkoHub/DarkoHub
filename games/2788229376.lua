local plrs = game.Players
local lp = plrs.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local combat = lp.Backpack.Combat

local target_under = false
local target_behind = false
local target_name = "target"

char.Humanoid:EquipTool(combat)

spawn(function()
    while true do
        task.wait(0.01)
        if target_under then
            char.HumanoidRootPart.CFrame = plrs[target_name].Character.HumanoidRootPart.CFrame * CFrame.new(0, -50, 0)
            combat:Activate()
        end
    end
end)

spawn(function()
    while true do
        task.wait(0.01)
        if target_behind then
            char.HumanoidRootPart.CFrame = plrs[target_name].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            combat:Activate()
        end
    end
end)

while true do
    for _, v in pairs(plrs:GetPlayers()) do
        if v.Name ~= lp.Name then
            workspace.CurrentCamera.CameraSubject = v.Character.Head
            target_name = v.Name
            target_under = true
            while v.Character.Humanoid.Health > 5 do
                task.wait(3)
                target_under = false
                target_behind = true
                task.wait(3)
                target_behind = false
                target_under = true
            end
            target_under = false
            target_behind = false
        end
    end
end