-- -*- coding: utf-8 -*-
-- 游戏保存系统
local save = {}

local SAVE_FILE = "savegame.lua"

function save:getSaveData()
    return {
        inventory = gameState.inventory,
        resources = gameState.resources,
        tools = gameState.tools,
        character = gameState.character,
        flags = gameState.flags,
        currentScene = gameState.currentScene
    }
end

function save:loadSaveData(data)
    gameState.inventory = data.inventory or {}
    gameState.resources = data.resources or { wood = 0, stone = 0, food = 0 }
    gameState.tools = data.tools or {}
    gameState.character = data.character or {
        name = "冒险者",
        health = 100,
        maxHealth = 100,
        level = 1,
        exp = 0
    }
    gameState.flags = data.flags or {}
    gameState.currentScene = data.currentScene or "forest"
end

function save:saveGame()
    local data = self:getSaveData()
    local serialized = self:serialize(data)
    love.filesystem.write(SAVE_FILE, "return " .. serialized)
end

function save:loadGame()
    if love.filesystem.getInfo(SAVE_FILE) then
        local chunk = love.filesystem.load(SAVE_FILE)
        if chunk then
            local data = chunk()
            self:loadSaveData(data)
            return true
        end
    end
    return false
end

function save:hasSaveGame()
    return love.filesystem.getInfo(SAVE_FILE) ~= nil
end

function save:deleteSaveGame()
    if love.filesystem.getInfo(SAVE_FILE) then
        love.filesystem.remove(SAVE_FILE)
    end
end

function save:serialize(t, indent)
    indent = indent or ""
    local result = "{\n"
    for k, v in pairs(t) do
        result = result .. indent .. "  "
        if type(k) == "string" then
            result = result .. "[\"" .. k .. "\"] = "
        else
            result = result .. "[" .. k .. "] = "
        end
        
        if type(v) == "table" then
            result = result .. self:serialize(v, indent .. "  ") .. ",\n"
        elseif type(v) == "string" then
            result = result .. "\"" .. v .. "\",\n"
        elseif type(v) == "number" or type(v) == "boolean" then
            result = result .. tostring(v) .. ",\n"
        end
    end
    result = result .. indent .. "}"
    return result
end

return save
