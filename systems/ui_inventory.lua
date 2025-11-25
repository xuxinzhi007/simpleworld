-- -*- coding: utf-8 -*-
-- UI 背包系统
local UIInventory = {}

-- 物品分类
UIInventory.categories = {
    "全部",
    "工具",
    "材料",
    "消耗品"
}

UIInventory.itemCategories = {
    ["木棍"] = "工具",
    ["石斧"] = "工具",
    ["篝火"] = "工具",
    ["背包"] = "工具",
    ["古币"] = "材料",
    ["皮革"] = "材料",
    ["木材"] = "材料",
    ["石头"] = "材料",
    ["食物"] = "消耗品"
}

function UIInventory:getItemCategory(itemName)
    return self.itemCategories[itemName] or "其他"
end

function UIInventory:getItemsByCategory(category)
    local items = {}
    
    if category == "全部" then
        for item, count in pairs(gameState.inventory) do
            table.insert(items, { name = item, count = count })
        end
    else
        for item, count in pairs(gameState.inventory) do
            if self:getItemCategory(item) == category then
                table.insert(items, { name = item, count = count })
            end
        end
    end
    
    return items
end

function UIInventory:getResourcesByCategory(category)
    local resources = {}
    
    if category == "全部" or category == "材料" then
        for resource, count in pairs(gameState.resources) do
            table.insert(resources, { name = resource, count = count })
        end
    end
    
    return resources
end

function UIInventory:getAllItems(category)
    local items = {}
    
    -- 添加背包物品
    local invItems = self:getItemsByCategory(category)
    for _, item in ipairs(invItems) do
        table.insert(items, item)
    end
    
    -- 添加资源
    local resources = self:getResourcesByCategory(category)
    for _, resource in ipairs(resources) do
        table.insert(items, resource)
    end
    
    return items
end

return UIInventory
