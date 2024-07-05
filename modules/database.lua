Database = {}

local databaseTables = {
    ["accounts"] = {
        ["id"] = {Type = "INT", Auto_increment = true, Primary_key = true},
        ["username"] = {Type = "TEXT", Null = false},
        ["password"] = {Type = "TEXT", Null = false},
        ["rank"] = {Type = "INT", Default = 1}
    },
    
    ["characters"] = {
        ["id"] = {Type = "INT", Auto_increment = true, Primary_key = true},
        ["account"] = {Type = "INT", Null = false},
        
        ["name"] = {Type = "TEXT", Null = false},
        ["surname"] = {Type = "TEXT", Null = false},
        ["sex"] = {Type = "TEXT", Null = false},

        ["health"] = {Type = "INT", Default = 100},
        ["shield"] = {Type = "INT", Default = 0},

        ["money"] = {Type = "INT", Default = START_WITH_MONEY},
        ["bank"] = {Type = "INT", Default = START_WITH_BANK_BALANCE}
    },

    ["items"] = {
        ["id"] = {Type = "INT", Auto_increment = true, Primary_key = true},

        ["owner"] = {Type = "INT"},
        ["ownerType"] = {Type = "TEXT"},

        ["itemID"] = {Type = "INT"},
        ["amount"] = {Type = "INT", Default = 1}
    },

    ["vehicles"] = {
        ["id"] = {Type = "INT", Auto_increment = true, Primary_key = true},
        ["owner"] = {Type = "INT", Null = false},
        ["plate"] = {Type = "TEXT", Null = true},
        ["color"] = {Type = "Text", Default = toJSON({255, 255, 255}), Null = false}
    }
}

function Database.connect()
    local databaseProperties = DATABASE_CONNECTION
    local databaseAddress = string.format("dbname=%s;host=%s;charset=utf8", databaseProperties["Database"], databaseProperties["Host"])

    local databaseElement = dbConnect("mysql", databaseAddress, databaseProperties["User"], databaseProperties["Pass"])

    if databaseElement and isElement(databaseElement) then
        Database.element = databaseElement
        Database.prepare()

        return true
    else
        Print.error("Database connection failed")
        Pioneer.stopAll()
        return false
    end
end

function Database.prepare()
    for tableName, data in pairs(databaseTables) do
        local sqlData = ("CREATE TABLE IF NOT EXISTS %s ("):format(tableName)
        
        local count = 1
        local tableLength = table.count(data)

        local primaryKey

        for columnName, properties in pairs(data) do
            sqlData = sqlData .. columnName .. " " .. properties["Type"]

            if not properties["Null"] then
                sqlData = sqlData .. " NOT NULL"
            end

            if properties["Auto_increment"] then
                sqlData = sqlData .. " AUTO_INCREMENT"
            end

            if properties["Default"] then
                sqlData = sqlData .. " DEFAULT '" .. properties["Default"] .. "'"
            end

            if properties["Primary_key"] then
                primaryKey = columnName
            end

            if count ~= tableLength then
                sqlData = sqlData .. ", "
            end
        
            count = count + 1
        end

        if primaryKey then
            sqlData = sqlData .. ", PRIMARY KEY (" .. primaryKey .. ")"
        end

        sqlData = sqlData .. ")"

        if not dbExec(Database.element, sqlData) then
            Print.error("SQL Error: " .. sqlData)
        end
    end
end

function Database.query()
    -- TODO;
end