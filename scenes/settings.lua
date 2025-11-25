-- -*- coding: utf-8 -*-
local BaseScene = require("scenes.base_scene")

local settings = BaseScene.new(
    "设置",
    "调整游戏设置"
)

function settings:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "音量: 100%", action = function() 
            -- 音量调整功能
        end },
        { text = "难度: 普通", action = function() 
            -- 难度调整功能
        end },
        { text = "返回", action = function() 
            Gamestate.switch(scenes.pause_menu)
        end }
    }
end

function settings:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.title)
    love.graphics.printf(self.title, 0, 100, 1000, "center")
    
    love.graphics.setFont(fonts.normal)
    love.graphics.printf(self.text, 50, 180, 900, "center")
    
    -- 绘制设置项
    local menuY = 300
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
end

function settings:keypressed(key)
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

function settings:mousepressed(x, y, button)
    if button == 1 then
        local menuY = 300
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

function settings:mousemoved(x, y)
    -- 鼠标移动时更新选中状态
    local menuY = 300
    for i, btn in ipairs(self.buttons) do
        if y >= menuY - 5 and y <= menuY + 45 then
            self.selectedButton = i
            return
        end
        menuY = menuY + 80
    end
end

return settings
