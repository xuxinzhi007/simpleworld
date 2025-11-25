-- -*- coding: utf-8 -*-
local BaseScene = require("scenes.base_scene")
local UIInventory = require("systems.ui_inventory")

local inventoryDetail = {
    title = "背包",
    text = "",
    selectedCategory = 1,
    selectedItem = 1,
    previousScene = nil,
    gridCols = 4,
    gridRows = 3,
    cellSize = 80,
    cellPadding = 10
}

function inventoryDetail:enter()
    self.selectedCategory = 1
    self.selectedItem = 1
end

function inventoryDetail:update(dt)
end

function inventoryDetail:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.title)
    love.graphics.printf(self.title, 0, 10, 1000, "center")
    
    -- 绘制玩家信息面板
    self:drawPlayerInfo()
    
    -- 绘制分类选择
    self:drawCategories()
    
    -- 绘制物品网格
    self:drawItemGrid()
    
    -- 绘制提示
    self:drawHints()
end

function inventoryDetail:drawPlayerInfo()
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", 10, 50, 300, 120)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.small)
    
    local char = gameState.character
    local infoY = 60
    love.graphics.printf("角色: " .. char.name, 20, infoY, 280, "left")
    infoY = infoY + 20
    love.graphics.printf("生命值: " .. char.health .. "/" .. char.maxHealth, 20, infoY, 280, "left")
    infoY = infoY + 20
    love.graphics.printf("等级: " .. char.level, 20, infoY, 280, "left")
    infoY = infoY + 20
    love.graphics.printf("经验: " .. char.exp, 20, infoY, 280, "left")
end

function inventoryDetail:drawCategories()
    local categoryX = 320
    local categoryY = 60
    local categoryWidth = 130
    local categoryHeight = 30
    local spacing = 10
    
    love.graphics.setFont(fonts.small)
    
    for i, category in ipairs(UIInventory.categories) do
        local isSelected = (i == self.selectedCategory)
        local color = isSelected and {1, 1, 0} or {0.5, 0.5, 0.5}
        
        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("line", categoryX, categoryY, categoryWidth, categoryHeight)
        love.graphics.printf(category, categoryX + 5, categoryY + 5, categoryWidth - 10, "center")
        
        categoryX = categoryX + categoryWidth + spacing
    end
end

function inventoryDetail:drawItemGrid()
    local items = UIInventory:getAllItems(UIInventory.categories[self.selectedCategory])
    
    local gridStartX = 50
    local gridStartY = 180
    local cellSize = self.cellSize
    local padding = self.cellPadding
    local cols = self.gridCols
    
    love.graphics.setFont(fonts.small)
    
    for i, item in ipairs(items) do
        local row = math.floor((i - 1) / cols)
        local col = (i - 1) % cols
        
        local x = gridStartX + col * (cellSize + padding)
        local y = gridStartY + row * (cellSize + padding)
        
        local isSelected = (i == self.selectedItem)
        local color = isSelected and {1, 1, 0} or {0.5, 0.5, 0.5}
        
        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("line", x, y, cellSize, cellSize)
        
        -- 绘制物品名称
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(item.name, x + 5, y + 10, cellSize - 10, "center")
        
        -- 绘制数量
        love.graphics.printf("x" .. item.count, x + 5, y + cellSize - 25, cellSize - 10, "center")
    end
end

function inventoryDetail:drawHints()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setFont(fonts.small)
    love.graphics.printf("方向键选择分类和物品 | 点击返回按钮或按 B 返回", 0, 750, 1000, "center")
    
    -- 绘制返回按钮
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.rectangle("line", 850, 710, 140, 30)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("返回", 850, 715, 140, "center")
    
    self.returnButtonRect = { x = 850, y = 710, w = 140, h = 30 }
end

function inventoryDetail:keypressed(key)
    if key == "left" then
        self.selectedCategory = math.max(1, self.selectedCategory - 1)
        self.selectedItem = 1
    elseif key == "right" then
        self.selectedCategory = math.min(#UIInventory.categories, self.selectedCategory + 1)
        self.selectedItem = 1
    elseif key == "up" then
        self.selectedItem = math.max(1, self.selectedItem - self.gridCols)
    elseif key == "down" then
        self.selectedItem = self.selectedItem + self.gridCols
    elseif key == "b" then
        -- B 键返回
        if self.previousScene then
            Gamestate.switch(self.previousScene)
        else
            Gamestate.switch(scenes.camp)
        end
    end
end

function inventoryDetail:mousepressed(x, y, button)
    if button == 1 then
        -- 检查返回按钮
        if self.returnButtonRect then
            local rect = self.returnButtonRect
            if x >= rect.x and x <= rect.x + rect.w and
               y >= rect.y and y <= rect.y + rect.h then
                if self.previousScene then
                    Gamestate.switch(self.previousScene)
                else
                    Gamestate.switch(scenes.camp)
                end
                return
            end
        end
        
        -- 检查分类点击
        local categoryX = 320
        local categoryY = 60
        local categoryWidth = 130
        local categoryHeight = 30
        local spacing = 10
        
        for i, category in ipairs(UIInventory.categories) do
            if x >= categoryX and x <= categoryX + categoryWidth and
               y >= categoryY and y <= categoryY + categoryHeight then
                self.selectedCategory = i
                self.selectedItem = 1
                return
            end
            categoryX = categoryX + categoryWidth + spacing
        end
        
        -- 检查物品网格点击
        local items = UIInventory:getAllItems(UIInventory.categories[self.selectedCategory])
        local gridStartX = 50
        local gridStartY = 180
        local cellSize = self.cellSize
        local padding = self.cellPadding
        local cols = self.gridCols
        
        for i, item in ipairs(items) do
            local row = math.floor((i - 1) / cols)
            local col = (i - 1) % cols
            
            local cellX = gridStartX + col * (cellSize + padding)
            local cellY = gridStartY + row * (cellSize + padding)
            
            if x >= cellX and x <= cellX + cellSize and
               y >= cellY and y <= cellY + cellSize then
                self.selectedItem = i
                return
            end
        end
    end
end

function inventoryDetail:mousemoved(x, y)
    -- 检查返回按钮悬停
    if self.returnButtonRect then
        local rect = self.returnButtonRect
        if x >= rect.x and x <= rect.x + rect.w and
           y >= rect.y and y <= rect.y + rect.h then
            return
        end
    end
    
    -- 检查分类悬停
    local categoryX = 320
    local categoryY = 60
    local categoryWidth = 130
    local categoryHeight = 30
    local spacing = 10
    
    for i, category in ipairs(UIInventory.categories) do
        if x >= categoryX and x <= categoryX + categoryWidth and
           y >= categoryY and y <= categoryY + categoryHeight then
            self.selectedCategory = i
            self.selectedItem = 1
            return
        end
        categoryX = categoryX + categoryWidth + spacing
    end
    
    -- 检查物品网格悬停
    local items = UIInventory:getAllItems(UIInventory.categories[self.selectedCategory])
    local gridStartX = 50
    local gridStartY = 180
    local cellSize = self.cellSize
    local padding = self.cellPadding
    local cols = self.gridCols
    
    for i, item in ipairs(items) do
        local row = math.floor((i - 1) / cols)
        local col = (i - 1) % cols
        
        local cellX = gridStartX + col * (cellSize + padding)
        local cellY = gridStartY + row * (cellSize + padding)
        
        if x >= cellX and x <= cellX + cellSize and
           y >= cellY and y <= cellY + cellSize then
            self.selectedItem = i
            return
        end
    end
end

return inventoryDetail
