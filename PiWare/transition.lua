local command = require("command")
local minigames = require("minigames.minigame_db")
local scene = {}
local timer = 0
local phase = 1
local selected_game = nil
local W, H

function scene.load(data)
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()
    timer = 0
    phase = 1
    selected_game = minigames[love.math.random(#minigames)]
    command.turnRedOff()
    command.turnGreenOff()
    command.turnBlueOff()
    if life >= 3 then
        command.turnRedOn()
        command.turnGreenOn()
        command.turnBlueOn()
    elseif life == 2 then
        command.turnRedOn()
        command.turnGreenOn()
    elseif life == 1 then
        command.turnRedOn()
    end
end

function scene.update(dt)
    timer = timer + dt
    local effective_time = 2 / speed
    if timer > effective_time then
        command.turnRedOff()
        command.turnGreenOff()
        command.turnBlueOff()

        setScene("minigames/" .. selected_game.file)
    elseif timer > effective_time / 2 then
        phase = 2
    end
end

function scene.draw()
    local text = ""
    if phase == 1 then
        text = "Level " .. level
    else
        text = selected_game.rule
    end

    local font = love.graphics.getFont()
    local textW = font:getWidth(text)
    local textH = font:getHeight()
    love.graphics.clear(0.2, 0.2, 0.2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(text, (W - textW) / 2, (H - textH) / 2)
end

return scene
