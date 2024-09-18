local plrs = game.Players
local lp = plrs.LocalPlayer

function hit_player(name: string)
	local args = {
	    [1] = "shootRifle",
	    [2] = "hit",
	    [3] = {
	        [1] = game:GetService("Players")[name].Character.Humanoid
	    }
	}
	game:GetService("ReplicatedStorage").Event:FireServer(unpack(args))
end

while true do
    task.wait(0.1)
    for _, v in pairs(plrs:GetPlayers()) do
        if v ~= lp then
            if v.Team ~= lp.Team then
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