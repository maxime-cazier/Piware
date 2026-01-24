local M = {}
local target_table = nil

local ALPHA = 0.2

function M.init(t)
    target_table = t
    target_table.btn1 = false
    target_table.btn2 = false
    target_table.btn3 = false
    target_table.distance = 0
end

function M.handle_message(msg_str)
    local startJson = string.find(msg_str, "{")
    if startJson then
        local json_str = string.sub(msg_str, startJson)
        local dist_str = string.match(json_str, '"Distance":([%d%.]+)')
        local distance = tonumber(dist_str)

        local btn1_str = string.match(json_str, '"Button1":(%a+)')
        local button1_etat = (btn1_str == "true")

        local btn2_str = string.match(json_str, '"Button2":(%a+)')
        local button2_etat = (btn2_str == "true")

        local btn3_str = string.match(json_str, '"Button3":(%a+)')
        local button3_etat = (btn3_str == "true")
        if distance ~= nil then
            target_table.distance = distance ~= -1
                    and ALPHA * distance + (1 - ALPHA) * target_table.distance
                or target_table.distance
        end
        if button1_etat ~= nil then
            target_table.btn1 = button1_etat
        end
        if button2_etat ~= nil then
            target_table.btn2 = button2_etat
        end
        if button3_etat ~= nil then
            target_table.btn3 = button3_etat
        end
    end
end

return M
