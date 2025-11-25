-- -*- coding: utf-8 -*-
sceneManager = {}

function sceneManager:init()
    self.currentScene = nil
    self.scenes = {}
end

function sceneManager:loadScene(sceneName)
    if scenes[sceneName] then
        self.currentScene = scenes[sceneName]
        gameState.currentScene = sceneName
        
        if ui then
            ui.buttons = {}
            ui.selectedButton = 1
        end
        
        if self.currentScene.onEnter then
            self.currentScene:onEnter()
        end
    end
end

function sceneManager:update(dt)
    if self.currentScene and self.currentScene.update then
        self.currentScene:update(dt)
    end
end

function sceneManager:draw()
    if self.currentScene then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(fonts.normal)
        
        if self.currentScene.title then
            love.graphics.setFont(fonts.title)
            love.graphics.printf(self.currentScene.title, 0, 20, 1000, "center")
        end
        
        if self.currentScene.text then
            love.graphics.setFont(fonts.normal)
            local text = self.currentScene.text
            if type(text) == "function" then
                text = text()
            end
            love.graphics.printf(text, 50, 80, 900, "left")
        end
        
        local buttonY = 300
        for i, choice in ipairs(self.currentScene.choices or {}) do
            local isSelected = (i == ui.selectedButton)
            local color = isSelected and {1, 1, 0} or {0.7, 0.7, 0.7}
            
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("line", 100, buttonY, 800, 40)
            love.graphics.setFont(fonts.small)
            love.graphics.printf(choice.text, 110, buttonY + 8, 780, "left")
            
            ui.buttons[i] = {
                x = 100,
                y = buttonY,
                width = 800,
                height = 40,
                text = choice.text,
                action = choice.action
            }
            
            buttonY = buttonY + 50
        end
        
        drawInventoryBar()
    end
end

function drawInventoryBar()
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
end
