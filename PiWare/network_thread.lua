require("love.timer")
local connect = require("connect")
local thread = require("love.thread")
local client = connect()
local channel = thread.getChannel("network")
local controlChannel = thread.getChannel("control")

if client then
    client:settimeout(0.1)

    while true do
        local line, err = client:receive()
        if line then
            channel:push(line)
        elseif err ~= "timeout" then
            print("Network error: " .. tostring(err))
            break
        end

        local msg = controlChannel:pop()
        if msg == "stop" then
            break
        end
    end

    client:close()
end
