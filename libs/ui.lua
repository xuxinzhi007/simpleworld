-- -*- coding: utf-8 -*-
-- 简化的 UI 库
local UI = {}

-- 文字按钮（简洁风格）
function UI.TextButton(x, y, text, callback)
    return {
        x = x,
        y = y,
        text = text,
        callback = callback,
        hovered = false,
        width = 200,
        height = 40,
        
        update = function(self, mx, my)
            self.hovered = mx >= self.x and mx <= self.x + self.width and
                          my >= self.y and my <= self.y + self.height
        end,
        
        draw = function(self, isSelected, font)
            font = font or fonts.normal
            love.graphics.setFont(font)
            
            local color = (isSelected or self.hovered) and {1, 1, 0} or {0.7, 0.7, 0.7}
            love.graphics.setColor(unpack(color))
            
            -- 绘制下划线效果
            love.graphics.printf(self.text, self.x, self.y, self.width, "left")
            if isSelected or self.hovered then
                love.graphics.line(self.x, self.y + 25, self.x + self.width, self.y + 25)
            end
        end,
        
        isClicked = function(self, mx, my)
            return self.hovered
        end
    }
end

-- 文字菜单组
function UI.TextMenu(x, y, buttons, spacing)
    spacing = spacing or 50
    return {
        x = x,
        y = y,
        buttons = buttons,
        selected = 1,
        spacing = spacing,
        
        update = function(self, mx, my)
            for _, btn in ipairs(self.buttons) do
                btn:update(mx, my)
            end
        end,
        
        draw = function(self, font)
            font = font or fonts.normal
            for i, btn in ipairs(self.buttons) do
                btn.y = self.y + (i - 1) * self.spacing
                btn:draw(i == self.selected, font)
            end
        end,
        
        selectNext = function(self)
            self.selected = math.min(#self.buttons, self.selected + 1)
        end,
        
        selectPrev = function(self)
            self.selected = math.max(1, self.selected - 1)
        end,
        
        activate = function(self)
            if self.buttons[self.selected] and self.buttons[self.selected].callback then
                self.buttons[self.selected]:callback()
            end
        end,
        
        clickAt = function(self, mx, my)
            for i, btn in ipairs(self.buttons) do
                if btn:isClicked(mx, my) then
                    self.selected = i
                    btn:callback()
                    return true
                end
            end
            return false
        end
    }
end

-- 传统按钮（保留）
function UI.Button(x, y, width, height, text, callback)
    return {
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
        callback = callback,
        hovered = false,
        
        update = function(self, mx, my)
            self.hovered = mx >= self.x and mx <= self.x + self.width and
                          my >= self.y and my <= self.y + self.height
        end,
        
        draw = function(self, isSelected)
            local color = (isSelected or self.hovered) and {1, 1, 0} or {0.7, 0.7, 0.7}
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
            love.graphics.printf(self.text, self.x + 10, self.y + 8, self.width - 20, "left")
        end,
        
        isClicked = function(self, mx, my)
            return self.hovered and mx >= self.x and mx <= self.x + self.width and
                   my >= self.y and my <= self.y + self.height
        end
    }
end

function UI.ButtonGroup(buttons)
    return {
        buttons = buttons,
        selected = 1,
        
        update = function(self, mx, my)
            for _, btn in ipairs(self.buttons) do
                btn:update(mx, my)
            end
        end,
        
        draw = function(self)
            for i, btn in ipairs(self.buttons) do
                btn:draw(i == self.selected)
            end
        end,
        
        selectNext = function(self)
            self.selected = math.min(#self.buttons, self.selected + 1)
        end,
        
        selectPrev = function(self)
            self.selected = math.max(1, self.selected - 1)
        end,
        
        activate = function(self)
            if self.buttons[self.selected] and self.buttons[self.selected].callback then
                self.buttons[self.selected]:callback()
            end
        end,
        
        clickAt = function(self, mx, my)
            for i, btn in ipairs(self.buttons) do
                if btn:isClicked(mx, my) then
                    self.selected = i
                    btn:callback()
                    return true
                end
            end
            return false
        end
    }
end

return UI
