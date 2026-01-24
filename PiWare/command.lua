local M = {}
local client_conn = nil

local commands = {
    RED_ON = "TURN_RED_LED_ON",
    RED_OFF = "TURN_RED_LED_OFF",
    GREEN_ON = "TURN_GREEN_LED_ON",
    GREEN_OFF = "TURN_GREEN_LED_OFF",
    BLUE_ON = "TURN_BLUE_LED_ON",
    BLUE_OFF = "TURN_BLUE_LED_OFF",
}

M.ledR = false
M.ledG = false
M.ledB = false

local function send(cmd)
    local command = '{"Command": "' .. cmd .. '"}\n'
    love.thread.getChannel("send_command"):push(command)
end

function M.turnRedOn()
    send(commands.RED_ON)
    M.ledR = true
end

function M.turnRedOff()
    send(commands.RED_OFF)
    M.ledR = false
end

function M.turnGreenOn()
    send(commands.GREEN_ON)
    M.ledG = true
end

function M.turnGreenOff()
    send(commands.GREEN_OFF)
    M.ledG = false
end

function M.turnBlueOn()
    send(commands.BLUE_ON)
    M.ledB = true
end

function M.turnBlueOff()
    send(commands.BLUE_OFF)
    M.ledB = false
end

return M
