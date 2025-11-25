-- -*- coding: utf-8 -*-
function love.load()
    love.window.setTitle("文字冒险游戏")
    
    -- Load font with UTF-8 support - use local font file
    local fontPath = "Noto_Sans_SC/NotoSansSC-Regular.ttf"
    
    if love.filesystem.getInfo(fontPath) then
        fonts = {
            title = love.graphics.newFont(fontPath, 24),
            normal = love.graphics.newFont(fontPath, 16),
            small = love.graphics.newFont(fontPath, 14)
        }
    else
        fonts = {
            title = love.graphics.newFont(24),
            normal = love.graphics.newFont(16),
            small = love.graphics.newFont(14)
        }
    end
    
    -- UI state
    ui = {
        selectedButton = 1,
        buttons = {},
        scrollOffset = 0
    }
    
    -- Game state
    gameState = {
        currentScene = "start",
        inventory = {},
        resources = { wood = 0, stone = 0, food = 0 },
        tools = {},
        character = {
            name = "冒险者",
            health = 100,
            maxHealth = 100,
            level = 1,
            exp = 0
        },
        flags = {}
    }
    
    -- Load game modules
    require("scenes/sceneManager")
    require("systems/inventory")
    require("systems/crafting")
    require("systems/random")
    require("data/scenes")
    
    randomSystem:init()
    sceneManager:init()
    sceneManager:loadScene("start")
end

function love.update(dt)
    sceneManager:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setColor(1, 1, 1)
    
    sceneManager:draw()
    drawUI()
end

function love.keypressed(key)
    if key == "up" then
        ui.selectedButton = math.max(1, ui.selectedButton - 1)
    elseif key == "down" then
        ui.selectedButton = math.min(#ui.buttons, ui.selectedButton + 1)
    elseif key == "return" or key == "space" then
        if ui.buttons[ui.selectedButton] then
            ui.buttons[ui.selectedButton].action()
        end
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        for i, btn in ipairs(ui.buttons) do
            if x >= btn.x and x <= btn.x + btn.width and
               y >= btn.y and y <= btn.y + btn.height then
                ui.selectedButton = i
                btn.action()
                break
            end
        end
    end
end

function drawUI()
    love.graphics.setFont(fonts.small)
    
    -- Draw status bar
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("生命值: " .. gameState.character.health .. "/" .. gameState.character.maxHealth, 10, 10, 200, "left")
    love.graphics.printf("等级: " .. gameState.character.level, 10, 30, 200, "left")
end
