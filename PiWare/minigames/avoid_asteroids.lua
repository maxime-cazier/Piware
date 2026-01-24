local scene = {}
local W, H
local timer = 6
local ufoImg = nil
local asteroidImg = nil
local dataController = nil
local asteroids = {}
local spawnTimer = 0
local shipY = 300
local win = true

function scene.load(data)
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()
    dataController = data

    if not ufoImg then
        ufoImg = love.graphics.newImage("assets/ufo.png")
    end
    if not asteroidImg then
        asteroidImg = love.graphics.newImage("assets/asteroid.png")
    end
    timer = 6
    spawnTimer = 0
    asteroids = {}
    shipY = H / 2
    win = true
end

local function finish()
    level = level + 1
    speed = speed + 0.05
    if speed > 2.5 then
        speed = 2.5
    end

    if not win then
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

    local dist = dataController.distance or 0
    if dist > 25 then
        dist = 25
    end
    if dist < 0 then
        dist = 0
    end
    local targetY = H - (dist / 25) * H
    shipY = shipY + (targetY - shipY) * 10 * dt
    spawnTimer = spawnTimer + dt
    if spawnTimer >= 1.5 then
        spawnTimer = 0
        local asteroid = {
            x = W + 100,
            y = love.math.random(50, H - 150),
            w = 150,
            h = 150,
            speed = 300 * speed,
        }
        table.insert(asteroids, asteroid)
    end

    for i = #asteroids, 1, -1 do
        local a = asteroids[i]
        a.x = a.x - a.speed * dt
        local shipX, shipW, shipH = 50, 100, 100
        if
            shipX < a.x + a.w
            and shipX + shipW > a.x
            and shipY < a.y + a.h
            and shipY + shipH > a.y
        then
            win = false
            finish()
            return
        end

        if a.x < -200 then
            table.remove(asteroids, i)
        end
    end
end

function scene.draw()
    love.graphics.clear(0.05, 0.05, 0.1)
    love.graphics.print(string.format("%.1f", timer), 10, 10)
    local ufoScale = 100 / ufoImg:getWidth()
    love.graphics.draw(ufoImg, 50, shipY, 0, ufoScale, ufoScale)
    local astScale = 150 / asteroidImg:getWidth()
    for _, a in ipairs(asteroids) do
        love.graphics.draw(asteroidImg, a.x, a.y, 0, astScale, astScale)
    end
end

return scene
