require("love.timer")
require("love.math")
local connect = require("connect")
local thread = require("love.thread")
local bit = require("bit")
local client = connect()
local sendChannel = thread.getChannel("send_command")
local controlChannel = thread.getChannel("control")

if client then
    client:settimeout(0.1)
    while true do
        local cmd = sendChannel:pop()
        if cmd then
            local len = #cmd
            local head = string.char(0x81)
            local mask_key = {
                love.math.random(0, 255),
                love.math.random(0, 255),
                love.math.random(0, 255),
                love.math.random(0, 255),
            }
            if len <= 125 then
                head = head .. string.char(bit.bor(0x80, len))
            else
                print("Send Thread Error: Message too long (> 125 chars)")
                break
            end

            local mask_str = string.char(unpack(mask_key))
            local masked = {}
            for i = 1, len do
                local b = cmd:byte(i)
                local m = mask_key[(i - 1) % 4 + 1]
                table.insert(masked, string.char(bit.bxor(b, m)))
            end
            client:send(head .. mask_str .. table.concat(masked))
        else
            love.timer.sleep(0.01)
        end
        local msg = controlChannel:peek()
        if msg == "stop" then
            break
        end
    end
    client:close()
else
    print("Send Thread: Could not connect.")
end
