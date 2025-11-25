-- -*- coding: utf-8 -*-
local BaseScene = require("scenes.base_scene")

local menu = BaseScene.new(
    "文字冒险游戏",
    ""
)

function menu:enter()
    self.selectedButton = 1
    
    -- 检查是否有存档
    local hasSave = saveSystem:hasSaveGame()
    
    self.buttons = {
        { text = "开始游戏", action = function() 
            -- 重置游戏状态
            gameState.inventory = {}
            gameState.resources = { wood = 0, stone = 0, food = 0 }
            gameState.tools = {}
            gameState.character = {
                name = "冒险者",
                health = 100,
                maxHealth = 100,
                level = 1,
                exp = 0
            }
            gameState.flags = {}
            Gamestate.switch(scenes.forest)
        end }
    }
    
    if hasSave then
        table.insert(self.buttons, {
            text = "继续游戏",
            action = function()
                saveSystem:loadGame()
                local sceneName = gameState.currentScene or "forest"
                if scenes[sceneName] then
                    Gamestate.switch(scenes[sceneName])
                else
                    Gamestate.switch(scenes.forest)
                end
            end
        })
    end
    
    table.insert(self.buttons, {
        text = "退出游戏",
        action = function()
            love.event.quit()
        end
    })
end

function menu:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.title)
    love.graphics.printf(self.title, 0, 100, 1000, "center")
    
    -- 绘制菜单
    love.graphics.setFont(fonts.normal)
    local menuY = 250
    for i, btn in ipairs(self.buttons) do
        local isSelected = (i == self.selectedButton)
        local color = isSelected and {1, 1, 0} or {0.7, 0.7, 0.7}
        
        love.graphics.setColor(unpack(color))
        love.graphics.printf(btn.text, 300, menuY, 400, "center")
        
        if isSelected then
            love.graphics.line(250, menuY + 25, 750, menuY + 25)
        end
        
        menuY = menuY + 80
    end
    
    -- 绘制提示
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setFont(fonts.small)
    love.graphics.printf("使用方向键选择，回车确认", 0, 700, 1000, "center")
end

function menu:keypressed(key)
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

function menu:mousepressed(x, y, button)
    if button == 1 then
        local menuY = 250
        for i, btn in ipairs(self.buttons) do
            if y >= menuY - 5 and y <= menuY + 45 then
                self.selectedButton = i
                btn.action()
                return
            end
            menuY = menuY + 80
        end
    end
end

function menu:mousemoved(x, y)
    -- 鼠标移动时更新选中状态
    local menuY = 250
    for i, btn in ipairs(self.buttons) do
        if y >= menuY - 5 and y <= menuY + 45 then
            self.selectedButton = i
            return
        end
        menuY = menuY + 80
    end
end

return menu
