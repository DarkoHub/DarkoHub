local plrs = game.Players
local lp = plrs.LocalPlayer

function hit_player(player)
    local args = {
        [1] = game:GetService("Players")[player]
    }
    game:GetService("ReplicatedStorage").meleeEvent:FireServer(unpack(args))
end

function change_team(arg)
    local args = {
        [1] = arg
    }
    workspace.Remote.TeamEvent:FireServer(unpack(args))
end

while true do
    task.wait(0.1)
    for _, v in pairs(plrs:GetPlayers()) do
        if v ~= lp then
            if v.Team ~= "Neutral" then
                if lp.Character.Humanoid.Health > 0 then
                    while v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 do
                        workspace.CurrentCamera.CameraSubject = v.Character.Head
                        lp.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, -7.5, 0)
                        hit_player(v.Name)
                        print("Hit: "..v.Name)
                        task.wait(0.005)
                    end
                else
                    repeat until lp.Character.Humanoid.Health > 0
                end
            end
        end
    end
end

-- while true do
--     change_team("Bright blue")
--     task.wait(0.5)
--     change_team("Bright orange")
-- end