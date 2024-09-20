local plrs = game.Players
local lp = plrs.LocalPlayer
local target = nil

function hit_player(player)
    local args = {
        [1] = game:GetService("Players"):WaitForChild(player)
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Melee"):FireServer(unpack(args))
end

spawn(function()
    while true do
        task.wait(0.01)
        if target ~= nil then
            lp.Character.HumanoidRootPart.CFrame = plrs[target].Character.HumanoidRootPart.CFrame * CFrame.new(0, -12.5, 0)
        end
    end
end)

while true do
    task.wait(0.1)
    for _, v in pairs(plrs:GetPlayers()) do
        if v ~= lp then
            if v.Team == "Criminals" or v.Team == "Inmates" or v.Team == "Guards" or v.Team == "Warden" then
            	target = v.Name
                if lp.Character.Humanoid.Health > 0 then
                    while v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 do
                        workspace.CurrentCamera.CameraSubject = v.Character.Head
                        hit_player(v.Name)
                        print("Hit: "..v.Name)
                        task.wait(0.75)
                    end
                else
                    repeat until lp.Character.Humanoid.Health > 0
                end
            end
        end
    end
end