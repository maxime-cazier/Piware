local module = {}
local command = require("command")
local ledImgs = {}
local btnImg = nil
local checkImg = nil
local crossImg = nil

function module.create(target_goal)
    local s = {}

    local W, H
    local timer = 0
    local dataController = nil
    local last_btn_state = { false, false, false }
    local config = { false, false, false }
    local goal = { false, false, false }
    local won = false

    local function updatePhysicalLEDs()
        if config[1] then
            command.turnRedOn()
        else
            command.turnRedOff()
        end
        if config[2] then
            command.turnGreenOn()
        else
            command.turnGreenOff()
        end
        if config[3] then
            command.turnBlueOn()
        else
            command.turnBlueOff()
        end
    end

    function s.load(data)
        W = love.graphics.getWidth()
        H = love.graphics.getHeight()
        dataController = data
        if #ledImgs == 0 then
            ledImgs = {
                love.graphics.newImage("assets/redLED.png"),
                love.graphics.newImage("assets/greenLED.png"),
                love.graphics.newImage("assets/blueLED.png"),
            }
        end
        if not btnImg then
            btnImg = love.graphics.newImage("assets/button.png")
        end
        goal = target_goal
        local same = true
        while same do
            config = {
                love.math.random() > 0.5,
                love.math.random() > 0.5,
                love.math.random() > 0.5,
            }
            same = true
            for i = 1, 3 do
                if config[i] ~= goal[i] then
                    same = false
                    break
                end
            end
        end
        updatePhysicalLEDs()
        timer = 7 / speed
        last_btn_state = { data.btn1, data.btn2, data.btn3 }
        won = false
    end

    local function finish() end

    function s.update(dt)
        timer = timer - dt
        if timer <= 0 then
            level = level + 1
            speed = speed + 0.05
            if speed > 2.5 then
                speed = 2.5
            end
            won = true
            for i = 1, 3 do
                if config[i] ~= goal[i] then
                    won = false
                    break
                end
            end
            if not won then
                life = life - 1
            end
            if life <= 0 then
                setScene("title")
            else
                setScene("transition")
            end
            return
        end

        local btns =
            { dataController.btn1, dataController.btn2, dataController.btn3 }
        local changed = false
        for i = 1, 3 do
            if btns[i] and not last_btn_state[i] then
                config[i] = not config[i]
                changed = true
            end
            last_btn_state[i] = btns[i]
        end

        if changed then
            updatePhysicalLEDs()
        end
    end

    function s.draw()
        love.graphics.print(string.format("%.1f", timer), 10, 10)

        local ledW = ledImgs[1]:getWidth()
        local targetLedW = 120
        local ledScale = targetLedW / ledW
        local yLed = 50
        local spacingLed = (W - (3 * targetLedW)) / 4

        for i = 1, 3 do
            local x = spacingLed * i + targetLedW * (i - 1)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(ledImgs[i], x, yLed, 0, ledScale, ledScale)
        end

        local btnW = btnImg:getWidth()
        local targetBtnW = 150
        local btnScale = targetBtnW / btnW
        local yBtn = 250
        local spacingBtn = (W - (3 * targetBtnW)) / 4

        for i = 1, 3 do
            local x = spacingBtn * i + targetBtnW * (i - 1)

            local imgToDraw = btnImg
            local curImgW = imgToDraw:getWidth()
            local curScale = targetBtnW / curImgW

            love.graphics.draw(imgToDraw, x, yBtn, 0, curScale, curScale)
        end
    end

    return s
end

return module
