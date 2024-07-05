Print = {}

function Print.info(text)
    return outputDebugString("PIONEER: " .. tostring(text), 3, 63, 63, 255)
end

function Print.error(text)
    return outputDebugString("PIONEER ERROR: " .. tostring(text), 3, 255, 63, 63)
end

function table.count(data)
    local count = 0

    for _, _ in pairs(data) do
        count = count + 1
    end

    return count
end