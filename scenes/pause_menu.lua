-- -*- coding: utf-8 -*-
local BaseScene = require("scenes.base_scene")

local pauseMenu = BaseScene.new(
    "游戏菜单",
    ""
)

-- 保存上一个场景的引用
pauseMenu.previousScene = nil

function pauseMenu:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "继续游戏", action = function() 
            if self.previousScene then
                Gamestate.switch(self.previousScene)
            else
                Gamestate.switch(scenes.forest)
            end
        end },
        { text = "手动保存", action = function() 
            saveSystem:saveGame()
            Gamestate.switch(scenes.save_success)
        end },
        { text = "手动读档", action = function() 
            if saveSystem:loadGame() then
                Gamestate.switch(scenes.load_success)
            else
                Gamestate.switch(scenes.load_fail)
            end
        end },
        { text = "设置", action = function() 
            Gamestate.switch(scenes.settings)
        end },
        { text = "返回菜单", action = function() 
            Gamestate.switch(scenes.menu)
        end }
    }
end

function pauseMenu:draw()
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
        
        menuY = menuY + 60
    end
    
    -- 绘制提示
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setFont(fonts.small)
    love.graphics.printf("使用方向键选择，回车确认", 0, 700, 1000, "center")
end

function pauseMenu:keypressed(key)
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

function pauseMenu:mousepressed(x, y, button)
    if button == 1 then
        local menuY = 250
        for i, btn in ipairs(self.buttons) do
            if y >= menuY - 5 and y <= menuY + 45 then
                self.selectedButton = i
                btn.action()
                return
            end
            menuY = menuY + 60
        end
    end
end

function pauseMenu:mousemoved(x, y)
    -- 鼠标移动时更新选中状态
    local menuY = 250
    for i, btn in ipairs(self.buttons) do
        if y >= menuY - 5 and y <= menuY + 45 then
            self.selectedButton = i
            return
        end
        menuY = menuY + 60
    end
end

return pauseMenu
