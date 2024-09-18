local plrs = game.Players
local lp = plrs.LocalPlayer
local kill_all_active = false

function hit_player(player)
    local args = {
        [1] = game:GetService("Players")[player]
    }
    game:GetService("ReplicatedStorage").meleeEvent:FireServer(unpack(args))
end

function start_kill()
    task.wait(0.1)
    for _, v in pairs(plrs:GetPlayers()) do
        if not kill_all_active then return end
        if v ~= lp then
            if v.Team ~= "Neutral" then
                if lp.Character.Humanoid.Health > 0 then
                    while v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 do
                        if not kill_all_active then return end
                        workspace.CurrentCamera.CameraSubject = v.Character.Head
                        lp.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, -7.5, 0)
                        hit_player(v.Name)
                        print("Hit: "..v.Name)
                        task.wait(0.005)
                    end
                else
                    repeat until lp.Character.Humanoid.Health > 0 or not kill_all_active
                end
            end
        end
    end
end

local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()

local window1 = engine.new({
    text = "Darko | Prison Life | "..game.PlaceId,
    
    size = UDim2.new(300, 200),
})

window1.open()

local main = window1.new({
    text = "Main",
})

local kill_all = main.new("switch", {
    text = "Kill All";
})
kill_all.set(false)
kill_all.event:Connect(function(bool)
    kill_all_active = bool
    if bool then
        start_kill()
    else
        workspace.CurrentCamera.CameraSubject = lp.Character.Humanoid
        lp.Character.Humanoid.Health = 0
    end
end)

print("Done")
