local scene = {}
local W, H
local timer = 0
local time_limit = 5
local problem = ""
local answer = 0
local options = {}
local correct_idx = 0
local btnImg = nil
local checkImg = nil
local crossImg = nil
local dataController = nil
local last_btn_state = { false, false, false }
local answered = false
local won = false
local selected_btn = 0

local function generateProblem()
    local ops = { "+", "-", "*" }
    local n1 = love.math.random(1, 10)
    local n2 = love.math.random(1, 10)
    local n3 = love.math.random(1, 10)
    local op1 = ops[love.math.random(1, 3)]
    local op2 = ops[love.math.random(1, 3)]

    problem = string.format("(%d %s %d) %s %d", n1, op1, n2, op2, n3)

    local res1
    if op1 == "+" then
        res1 = n1 + n2
    elseif op1 == "-" then
        res1 = n1 - n2
    elseif op1 == "*" then
        res1 = n1 * n2
    end

    if op2 == "+" then
        answer = res1 + n3
    elseif op2 == "-" then
        answer = res1 - n3
    elseif op2 == "*" then
        answer = res1 * n3
    end
end

local function generateOptions()
    options = {}
    correct_idx = love.math.random(1, 3)
    for i = 1, 3 do
        if i == correct_idx then
            table.insert(options, answer)
        else
            local offset = love.math.random(-5, 5)
            if offset == 0 then
                offset = 1
            end
            table.insert(options, answer + offset)
        end
    end
end

function scene.load(data)
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()
    dataController = data
    if not btnImg then
        btnImg = love.graphics.newImage("assets/button.png")
    end
    if not checkImg then
        checkImg = love.graphics.newImage("assets/checkmark.png")
    end
    if not crossImg then
        crossImg = love.graphics.newImage("assets/redCross.png")
    end

    generateProblem()
    generateOptions()

    timer = 5 / speed

    last_btn_state = { data.btn1, data.btn2, data.btn3 }
    answered = false
    won = false
    selected_btn = 0
end

local function finish()
    level = level + 1
    speed = speed + 0.05
    if speed > 2.5 then
        speed = 2.5
    end

    if not won then
        life = life - 1
    end

    if life <= 0 then
        setScene("title")
    else
        setScene("transition")
    end
end

function scene.update(dt)
    timer = timer - dt
    if timer <= 0 then
        finish()
        return
    end

    if answered then
        return
    end

    local btns =
        { dataController.btn1, dataController.btn2, dataController.btn3 }
    for i = 1, 3 do
        if btns[i] and not last_btn_state[i] then
            answered = true
            selected_btn = i
            if i == correct_idx then
                won = true
            else
                won = false
            end
        end
        last_btn_state[i] = btns[i]
    end
end

function scene.draw()
    local font = love.graphics.getFont()
    local pText = problem .. " = ?"
    local pW = font:getWidth(pText)
    love.graphics.print(pText, (W - pW) / 2, 50)

    love.graphics.print(string.format("%.1f", timer), 10, 10)

    local btnW = btnImg:getWidth()
    local btnH = btnImg:getHeight()
    local targetBunW = 150
    local scale = targetBunW / btnW

    local yBtn = 250
    local spacing = (W - (3 * targetBunW)) / 4

    for i = 1, 3 do
        local x = spacing * i + targetBunW * (i - 1)
        love.graphics.setColor(1, 1, 1)

        local imgToDraw = btnImg

        if answered and i == selected_btn then
            if won then
                imgToDraw = checkImg
            else
                imgToDraw = crossImg
            end
        end

        local curImgW = imgToDraw:getWidth()
        local curScale = targetBunW / curImgW

        love.graphics.draw(imgToDraw, x, yBtn, 0, curScale, curScale)

        local ans = tostring(options[i])
        local ansW = font:getWidth(ans)
        local yText = yBtn + btnH * scale + 20
        love.graphics.print(ans, x + (targetBunW - ansW) / 2, yText)
    end
end

return scene
