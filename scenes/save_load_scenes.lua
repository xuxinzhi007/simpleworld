-- -*- coding: utf-8 -*-
local BaseScene = require("scenes.base_scene")

local scenes_sl = {}

-- 保存成功
scenes_sl.save_success = BaseScene.new(
    "保存成功",
    "游戏已保存！"
)

function scenes_sl.save_success:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "返回", action = function() 
            Gamestate.switch(scenes.pause_menu)
        end }
    }
    
    -- 2秒后自动返回
    self.timer = 2
end

function scenes_sl.save_success:update(dt)
    self.timer = self.timer - dt
    if self.timer <= 0 then
        Gamestate.switch(scenes.pause_menu)
    end
end

-- 读档成功
scenes_sl.load_success = BaseScene.new(
    "读档成功",
    "游戏已加载！"
)

function scenes_sl.load_success:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "返回", action = function() 
            Gamestate.switch(scenes.pause_menu)
        end }
    }
    
    -- 2秒后自动返回
    self.timer = 2
end

function scenes_sl.load_success:update(dt)
    self.timer = self.timer - dt
    if self.timer <= 0 then
        Gamestate.switch(scenes.pause_menu)
    end
end

-- 读档失败
scenes_sl.load_fail = BaseScene.new(
    "读档失败",
    "没有找到存档文件！"
)

function scenes_sl.load_fail:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "返回", action = function() 
            Gamestate.switch(scenes.pause_menu)
        end }
    }
end

return scenes_sl
