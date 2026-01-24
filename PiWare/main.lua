local controller = require("controller")
local command = require("command")

local network_thread = nil
local send_thread = nil
local scene = nil
local W, H = 800, 600
local data = {}
level = 1
speed = 1
life = 3

function setScene(name)
    local status, val = pcall(require, name)
    if status then
        scene = val
        if scene.load then
            scene.load(data)
        end
    else
        print("Error loading scene: " .. name .. " | " .. tostring(val))
    end
end

function love.load()
    love.window.setTitle("PiWare")
    love.window.setMode(W, H)
    maPolice = love.graphics.newFont("assets/font/GrapeSoda.ttf", 64)

    controller.init(data)

    network_thread = love.thread.newThread("network_thread.lua")
    network_thread:start()

    send_thread = love.thread.newThread("send_command_thread.lua")
    send_thread:start()

    setScene("title")
end

function love.update(dt)
    local network_channel = love.thread.getChannel("network")
    local msg = network_channel:pop()

    while msg do
        controller.handle_message(msg)
        msg = network_channel:pop()
    end

    if scene then
        scene.update(dt)
    end
end

function love.draw()
    love.graphics.setFont(maPolice)
    if scene then
        scene.draw()
    end
end

function love.quit()
    love.thread.getChannel("control"):push("stop")
end
