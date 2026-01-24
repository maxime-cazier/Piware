local socket = require("socket")
local config = require("config")

local function connect()
    local client, err = socket.connect(config.HOST, config.PORT)

    if not client then
        print("Unable to connect to server : " .. tostring(err))
        return nil
    end
    local handshake = "GET /ws HTTP/1.1\r\n"
        .. "Host: "
        .. config.HOST
        .. ":"
        .. config.PORT
        .. "\r\n"
        .. "Upgrade: websocket\r\n"
        .. "Connection: Upgrade\r\n"
        .. "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n"
        .. "Sec-WebSocket-Version: 13\r\n\r\n"
    client:send(handshake)
    local responseLine, err = client:receive()

    if responseLine and responseLine:find("101") then
        print("Connected to server.")
        return client
    else
        print("Server refused handshake : " .. (responseLine or err))
        client:close()
        return nil
    end
end

return connect
