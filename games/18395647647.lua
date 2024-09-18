local obbys = workspace.Obbys
local plrs = game.Players
local lp = plrs.LocalPlayer

getgenv().auto_finish = false
getgenv().farm_delay = 2.5

local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()

local window1 = engine.new({
    text = "Darko | Obby RNG | "..game.PlaceId,
    size = Vector2.new(325, 200),
})

window1.open()

local main = window1.new({
    text = "Main",
})

local farming = main.new("dock")

local auto_finish = farming.new("switch", {
    text = "Auto Finish";
})
auto_finish.set(false)
auto_finish.event:Connect(function(bool)
    getgenv().auto_finish = bool
    while getgenv().auto_finish do
        for _, v in next, obbys:GetChildren() do
            if v.EndTouchPart.EndTouchPart.Transparency == 0 then
                lp.Character:PivotTo(v.EndTouchPart.EndTouchPartHitBox.CFrame)
            end
        end
        task.wait(getgenv().farm_delay)
    end
end)

local farm_delay = farming.new("slider", {
    text = "Delay",
    color = Color3.new(0.168627, 0.219607, 0.325490),
    min = 1,
    max = 10,
    value = 2,
    rounding = 1,
})
farm_delay.event:Connect(function(x)
    getgenv().farm_delay = x
end)
farm_delay.set(2.5)