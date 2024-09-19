local plrs = game.Players
local lp = plrs.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local combat = lp.Backpack.Combat

local target = false
local target_name = "target"

char.Humanoid:EquipTool(combat)

spawn(function()
    while true do
        task.wait(0.01)
        if target then
            print("Targeting: " .. target_name)
            char.HumanoidRootPart.CFrame = plrs[target_name].Character.HumanoidRootPart.CFrame * CFrame.new(0, -50, 0)
            combat:Activate()
        end
    end
end)

while true do
    for _, v in pairs(plrs:GetPlayers()) do
        if v.Name ~= lp.Name then
            workspace.CurrentCamera.CameraSubject = v.Character.Head
            target_name = v.Name
            target = true
            while v.Character.Humanoid.Health > 5 do
                combat:Activate()
                task.wait(0.1)
                target = false
                char.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                task.wait(0.1)
                target = true
            end
            target = false
        end
    end
end