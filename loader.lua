repeat
    task.wait()
until game:IsLoaded()

local placeID = game.PlaceId
local github = "https://raw.githubusercontent.com/DarkoHub/DarkoHub/main/"
local gamesString = game:HttpGet(github.."supported.lua")
local games = loadstring(gamesString)()

for _, v in pairs(games) do
    if v == placeID then
        loadstring(game:HttpGet(github.."games/"..placeID..".lua", true))()
        found = true
        break
    else
        loadstring(game:HttpGet(github.."universal.lua", true))()
    end
end
