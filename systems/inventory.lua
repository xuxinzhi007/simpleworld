-- -*- coding: utf-8 -*-
inventory = {}

function inventory:addItem(itemName, count)
    count = count or 1
    if gameState.inventory[itemName] then
        gameState.inventory[itemName] = gameState.inventory[itemName] + count
    else
        gameState.inventory[itemName] = count
    end
end

function inventory:removeItem(itemName, count)
    count = count or 1
    if gameState.inventory[itemName] then
        gameState.inventory[itemName] = gameState.inventory[itemName] - count
        if gameState.inventory[itemName] <= 0 then
            gameState.inventory[itemName] = nil
        end
        return true
    end
    return false
end

function inventory:hasItem(itemName, count)
    count = count or 1
    return gameState.inventory[itemName] and gameState.inventory[itemName] >= count
end

function inventory:addResource(resourceName, count)
    count = count or 1
    if gameState.resources[resourceName] then
        gameState.resources[resourceName] = gameState.resources[resourceName] + count
    end
end

function inventory:getResource(resourceName, count)
    count = count or 1
    if gameState.resources[resourceName] and gameState.resources[resourceName] >= count then
        gameState.resources[resourceName] = gameState.resources[resourceName] - count
        return true
    end
    return false
end

function inventory:addTool(toolName)
    if not gameState.tools[toolName] then
        gameState.tools[toolName] = true
    end
end

function inventory:hasTool(toolName)
    return gameState.tools[toolName] == true
end
