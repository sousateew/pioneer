Pioneer = {}

addEventHandler("onResourceStart", resourceRoot,
    function()
        Pioneer.setup()
    end
)

function Pioneer.setup()
    Database.connect()
end

function Pioneer.stopAll()
    local resourcesData = getResources()
    
    for index, resourceElement in pairs(resourcesData) do
        local resourceState = getResourceState(resourceElement)

        if resourceState == "running" then
            stopResource(resourceElement)
        end
    end

    Print.info("Stopped all")
end