-- -*- coding: utf-8 -*-
crafting = {}

-- 定义可制作的物品
crafting.recipes = {
    ["木棍"] = {
        requires = { wood = 2 },
        produces = { ["木棍"] = 1 },
        description = "用木材制作木棍"
    },
    ["石斧"] = {
        requires = { stone = 3, ["木棍"] = 1 },
        produces = { ["石斧"] = 1 },
        description = "用石头和木棍制作石斧"
    },
    ["篝火"] = {
        requires = { wood = 5, stone = 3 },
        produces = { ["篝火"] = 1 },
        description = "用木材和石头制作篝火"
    },
    ["背包"] = {
        requires = { ["皮革"] = 2, ["木棍"] = 3 },
        produces = { ["背包"] = 1 },
        description = "用皮革和木棍制作背包"
    }
}

function crafting:canCraft(recipeName)
    local recipe = self.recipes[recipeName]
    if not recipe then return false end
    
    for item, count in pairs(recipe.requires) do
        if string.find(item, "^[a-z]") then -- 资源
            if not gameState.resources[item] or gameState.resources[item] < count then
                return false
            end
        else -- 物品
            if not inventory:hasItem(item, count) then
                return false
            end
        end
    end
    return true
end

function crafting:craft(recipeName)
    if not self:canCraft(recipeName) then
        return false
    end
    
    local recipe = self.recipes[recipeName]
    
    -- 消耗材料
    for item, count in pairs(recipe.requires) do
        if string.find(item, "^[a-z]") then
            inventory:getResource(item, count)
        else
            inventory:removeItem(item, count)
        end
    end
    
    -- 获得产品
    for item, count in pairs(recipe.produces) do
        inventory:addItem(item, count)
    end
    
    return true
end

function crafting:getAvailableRecipes()
    local available = {}
    for name, recipe in pairs(self.recipes) do
        if self:canCraft(name) then
            table.insert(available, name)
        end
    end
    return available
end
