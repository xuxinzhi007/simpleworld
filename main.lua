-- -*- coding: utf-8 -*-
function love.load()
    love.window.setTitle("文字冒险游戏")
    
    -- 加载库
    Gamestate = require("libs.gamestate")
    UI = require("libs.ui")
    
    -- 加载字体
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
    
    -- 全局游戏状态
    gameState = {
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
    
    -- 加载游戏系统
    require("systems.inventory")
    require("systems.crafting")
    require("systems.random")
    saveSystem = require("systems.save")
    
    -- 加载场景
    require("scenes.scenes")
    scenes.menu = require("scenes.menu")
    scenes.pause_menu = require("scenes.pause_menu")
    scenes.settings = require("scenes.settings")
    
    -- 加载保存/读档场景
    local sl_scenes = require("scenes.save_load_scenes")
    scenes.save_success = sl_scenes.save_success
    scenes.load_success = sl_scenes.load_success
    scenes.load_fail = sl_scenes.load_fail
    
    randomSystem:init()
    
    -- 初始化第一个场景为菜单
    Gamestate.switch(scenes.menu)
end

function love.update(dt)
    Gamestate.update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setColor(1, 1, 1)
    Gamestate.draw()
end

function love.keypressed(key)
    if key == "escape" then
        -- 如果在游戏中，打开菜单；如果在菜单中，退出
        if Gamestate.current and Gamestate.current ~= scenes.menu and 
           Gamestate.current ~= scenes.pause_menu and
           Gamestate.current ~= scenes.settings then
            scenes.pause_menu.previousScene = Gamestate.current
            Gamestate.switch(scenes.pause_menu)
        else
            love.event.quit()
        end
    else
        Gamestate.keypressed(key)
    end
end

function love.mousepressed(x, y, button)
    Gamestate.mousepressed(x, y, button)
end

function love.mousemoved(x, y)
    if Gamestate.current and Gamestate.current.mousemoved then
        Gamestate.current:mousemoved(x, y)
    end
end
