local controller = require("controller")
local command = require("command")

local scene = {}

local cloudImg
local titleImg
local clouds = {}
local W, H
local dataController

function scene.load(data)
    cloudImg = love.graphics.newImage("assets/cloud.png")
    titleImg = love.graphics.newImage("assets/cloudTitle.png")
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()
    dataController = data
    command.turnRedOn()

    clouds = {
        { x = 40, y = 80 },
        { x = 450, y = 240 },
        { x = 220, y = 350 },
    }
end

function scene.update(dt)
    local cloudW = cloudImg:getWidth()
    local cloudH = cloudImg:getHeight()
    local speed = 50

    for _, cloud in ipairs(clouds) do
        cloud.x = cloud.x + speed * dt

        if cloud.x > W + cloudW then
            cloud.x = -cloudW
            cloud.y = love.math.random(cloudH, H - cloudH)
        end
    end

    if not last_btn_state then
        last_btn_state = { false, false, false }
    end

    local btns =
        { dataController.btn1, dataController.btn2, dataController.btn3 }
    local pressed = false

    for i = 1, 3 do
        if btns[i] and not last_btn_state[i] then
            pressed = true
        end
        last_btn_state[i] = btns[i]
    end

    if pressed then
        level = 1
        speed = 1
        life = 3
        setScene("transition")
    end
end

function scene.draw()
    local dist = dataController.distance or 50
    local t = dist / 200
    if t > 1 then
        t = 1
    end

    local r1, g1, b1 = 0.1, 0.3, 0.6
    local r2, g2, b2 = 0.6, 0.9, 1.0

    local r = r1 + (r2 - r1) * t
    local g = g1 + (g2 - g1) * t
    local b = b1 + (b2 - b1) * t

    love.graphics.clear(r, g, b)

    love.graphics.setColor(1, 1, 1)
    for _, cloud in ipairs(clouds) do
        love.graphics.draw(cloudImg, cloud.x, cloud.y)
    end
    love.graphics.draw(titleImg, 0, 0)

    local text = "Press a button"
    local font = love.graphics.getFont()
    local textW = font:getWidth(text)
    local textH = font:getHeight()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(text, (W - textW) / 2, H - 100)
end

return scene
