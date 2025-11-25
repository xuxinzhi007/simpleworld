-- -*- coding: utf-8 -*-
-- 基础场景类
local BaseScene = {}

function BaseScene.new(title, text)
    local scene = {
        title = title,
        text = text,
        buttons = {},
        selectedButton = 1,
        mouseX = 0,
        mouseY = 0
    }
    
    function scene:enter()
        if self.selectedButton == nil then
            self.selectedButton = 1
        end
    end
    
    function scene:exit()
        -- 自动保存游戏
        if saveSystem then
            gameState.currentScene = self.title
            saveSystem:saveGame()
        end
    end
    
    function scene:update(dt)
    end
    
    function scene:draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(fonts.title)
        love.graphics.printf(self.title, 0, 20, 1000, "center")
        
        love.graphics.setFont(fonts.normal)
        local text = self.text
        if type(text) == "function" then
            text = text()
        end
        love.graphics.printf(text, 50, 80, 900, "left")
        
        -- 绘制按钮
        local buttonY = 300
        for i, btn in ipairs(self.buttons) do
            local isSelected = (i == self.selectedButton)
            local color = isSelected and {1, 1, 0} or {0.7, 0.7, 0.7}
            
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("line", 100, buttonY, 800, 40)
            love.graphics.setFont(fonts.small)
            love.graphics.printf(btn.text, 110, buttonY + 8, 780, "left")
            
            buttonY = buttonY + 50
        end
        
        self:drawInventoryBar()
    end
    
    function scene:drawInventoryBar()
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, 700, 1000, 100)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(fonts.small)
        
        local text = "资源: 木材=" .. gameState.resources.wood .. 
                     " 石头=" .. gameState.resources.stone .. 
                     " 食物=" .. gameState.resources.food
        love.graphics.printf(text, 10, 710, 980, "left")
        
        local invText = "背包: "
        for item, count in pairs(gameState.inventory) do
            invText = invText .. item .. "x" .. count .. " "
        end
        love.graphics.printf(invText, 10, 740, 980, "left")
        
        -- 绘制状态栏
        love.graphics.printf("生命值: " .. gameState.character.health .. "/" .. gameState.character.maxHealth, 10, 760, 200, "left")
        love.graphics.printf("等级: " .. gameState.character.level, 250, 760, 200, "left")
        
        -- 绘制菜单按钮提示
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.printf("按 ESC 打开菜单", 800, 760, 200, "right")
    end
    
    function scene:keypressed(key)
        if key == "up" then
            self.selectedButton = math.max(1, self.selectedButton - 1)
        elseif key == "down" then
            self.selectedButton = math.min(#self.buttons, self.selectedButton + 1)
        elseif key == "return" or key == "space" then
            if self.buttons[self.selectedButton] then
                self.buttons[self.selectedButton].action()
            end
        end
    end
    
    function scene:mousepressed(x, y, button)
        if button == 1 then
            local buttonY = 300
            for i, btn in ipairs(self.buttons) do
                -- 检查鼠标是否在按钮区域内（更宽松的范围）
                if x >= 80 and x <= 920 and y >= buttonY - 5 and y <= buttonY + 45 then
                    self.selectedButton = i
                    btn.action()
                    return
                end
                buttonY = buttonY + 50
            end
        end
    end
    
    function scene:mousemoved(x, y)
        -- 鼠标移动时更新选中状态
        local buttonY = 300
        for i, btn in ipairs(self.buttons) do
            if x >= 80 and x <= 920 and y >= buttonY - 5 and y <= buttonY + 45 then
                self.selectedButton = i
                return
            end
            buttonY = buttonY + 50
        end
    end
    
    return scene
end

return BaseScene
