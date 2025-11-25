-- -*- coding: utf-8 -*-
local BaseScene = require("scenes.base_scene")

scenes = {}

-- 开始场景（已移至 menu.lua）
-- 这里保留为兼容性

-- 帮助场景
scenes.help = BaseScene.new(
    "帮助",
    "游戏说明：\n" ..
    "1. 探索世界并收集资源（木材、石头、食物）\n" ..
    "2. 使用资源制作工具和物品\n" ..
    "3. 做出影响故事的选择\n" ..
    "4. 管理你的背包和资源\n" ..
    "5. 升级并提高你的能力\n\n" ..
    "控制：方向键选择，回车确认，鼠标点击\n" ..
    "游戏中按 ESC 打开菜单"
)

function scenes.help:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "返回菜单", action = function() Gamestate.switch(scenes.menu) end }
    }
end

-- 森林场景
scenes.forest = BaseScene.new(
    "神秘森林",
    "你来到了一片茂密的森林。\n阳光透过树叶洒下来。\n你听到远处传来奇怪的声音..."
)

function scenes.forest:enter()
    self.selectedButton = 1
    self.buttons = {
        {
            text = "收集木材",
            action = function()
                local amount = randomSystem:range(2, 5)
                inventory:addResource("wood", amount)
                Gamestate.switch(scenes.forest_collect)
            end
        },
        {
            text = "探索深处",
            action = function()
                if randomSystem:chance(50) then
                    Gamestate.switch(scenes.forest_encounter)
                else
                    Gamestate.switch(scenes.forest_empty)
                end
            end
        },
        {
            text = "制作物品",
            action = function()
                Gamestate.switch(scenes.crafting_menu)
            end
        },
        {
            text = "返回营地",
            action = function()
                Gamestate.switch(scenes.camp)
            end
        },
        {
            text = "返回菜单",
            action = function()
                Gamestate.switch(scenes.menu)
            end
        }
    }
end

-- 收集木材场景
scenes.forest_collect = BaseScene.new(
    "收集成功",
    "你成功收集了一些木材！\n你的背包现在有了更多资源。"
)

function scenes.forest_collect:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "继续探索", action = function() Gamestate.switch(scenes.forest) end }
    }
end

-- 遭遇场景
scenes.forest_encounter = BaseScene.new(
    "神秘发现",
    "你发现了一个古老的遗迹！\n它闪烁着奇异的光芒。\n你应该进去探索吗？"
)

function scenes.forest_encounter:enter()
    self.selectedButton = 1
    self.buttons = {
        {
            text = "进入遗迹",
            action = function()
                inventory:addItem("古币", 1)
                inventory:addResource("stone", 3)
                Gamestate.switch(scenes.forest_treasure)
            end
        },
        {
            text = "离开这里",
            action = function()
                Gamestate.switch(scenes.forest)
            end
        }
    }
end

-- 空场景
scenes.forest_empty = BaseScene.new(
    "深处探索",
    "你在森林深处走了很久，但什么都没有发现。\n只有风吹过树叶的声音。"
)

function scenes.forest_empty:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "返回", action = function() Gamestate.switch(scenes.forest) end }
    }
end

-- 宝藏场景
scenes.forest_treasure = BaseScene.new(
    "宝藏发现",
    "你找到了宝藏！\n获得了古币和石头。\n这些东西可能很有价值。"
)

function scenes.forest_treasure:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "返回森林", action = function() Gamestate.switch(scenes.forest) end }
    }
end

-- 营地场景
scenes.camp = BaseScene.new(
    "冒险者营地",
    "你回到了营地。\n这是一个安全的地方，你可以在这里休息和制作物品。"
)

function scenes.camp:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "制作物品", action = function() Gamestate.switch(scenes.crafting_menu) end },
        { text = "查看背包", action = function() Gamestate.switch(scenes.inventory_view) end },
        { text = "继续探索", action = function() Gamestate.switch(scenes.forest) end },
        { text = "返回菜单", action = function() Gamestate.switch(scenes.menu) end }
    }
end

-- 制作菜单
scenes.crafting_menu = BaseScene.new(
    "制作物品",
    "选择你想要制作的物品："
)

function scenes.crafting_menu:enter()
    self.selectedButton = 1
    self.buttons = {}
    
    for recipeName, recipe in pairs(crafting.recipes) do
        local canCraft = crafting:canCraft(recipeName)
        local status = canCraft and "✓" or "✗"
        
        table.insert(self.buttons, {
            text = status .. " " .. recipeName .. " - " .. recipe.description,
            action = function()
                if crafting:craft(recipeName) then
                    Gamestate.switch(scenes.craft_success)
                else
                    Gamestate.switch(scenes.craft_fail)
                end
            end
        })
    end
    
    table.insert(self.buttons, {
        text = "返回",
        action = function()
            Gamestate.switch(scenes.camp)
        end
    })
end

-- 制作成功
scenes.craft_success = BaseScene.new(
    "制作成功",
    "你成功制作了物品！"
)

function scenes.craft_success:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "继续制作", action = function() Gamestate.switch(scenes.crafting_menu) end },
        { text = "返回营地", action = function() Gamestate.switch(scenes.camp) end }
    }
end

-- 制作失败
scenes.craft_fail = BaseScene.new(
    "制作失败",
    "你没有足够的材料来制作这个物品。"
)

function scenes.craft_fail:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "返回", action = function() Gamestate.switch(scenes.crafting_menu) end }
    }
end

-- 背包查看
scenes.inventory_view = BaseScene.new(
    "背包",
    function()
        local text = "你的物品：\n"
        if next(gameState.inventory) == nil then
            text = text .. "背包是空的\n"
        else
            for item, count in pairs(gameState.inventory) do
                text = text .. item .. " x" .. count .. "\n"
            end
        end
        return text
    end
)

function scenes.inventory_view:enter()
    self.selectedButton = 1
    self.buttons = {
        { text = "返回", action = function() Gamestate.switch(scenes.camp) end }
    }
end

return scenes
