-- -*- coding: utf-8 -*-
-- 简化的游戏状态机实现
local Gamestate = {}
Gamestate.current = nil

function Gamestate.new()
    return {
        enter = function() end,
        exit = function() end,
        update = function(dt) end,
        draw = function() end,
        keypressed = function(key) end,
        mousepressed = function(x, y, button) end,
    }
end

function Gamestate.switch(to)
    if Gamestate.current and Gamestate.current.exit then
        Gamestate.current:exit()
    end
    Gamestate.current = to
    if Gamestate.current and Gamestate.current.enter then
        Gamestate.current:enter()
    end
end

function Gamestate.update(dt)
    if Gamestate.current and Gamestate.current.update then
        Gamestate.current:update(dt)
    end
end

function Gamestate.draw()
    if Gamestate.current and Gamestate.current.draw then
        Gamestate.current:draw()
    end
end

function Gamestate.keypressed(key)
    if Gamestate.current and Gamestate.current.keypressed then
        Gamestate.current:keypressed(key)
    end
end

function Gamestate.mousepressed(x, y, button)
    if Gamestate.current and Gamestate.current.mousepressed then
        Gamestate.current:mousepressed(x, y, button)
    end
end

function Gamestate.mousemoved(x, y)
    if Gamestate.current and Gamestate.current.mousemoved then
        Gamestate.current:mousemoved(x, y)
    end
end

return Gamestate
