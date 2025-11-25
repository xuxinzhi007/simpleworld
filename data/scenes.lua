-- -*- coding: utf-8 -*-
scenes = {}

-- 开始场景
scenes["start"] = {
    title = "文字冒险游戏",
    text = "欢迎来到这个神秘的世界。\n你是一位冒险者，准备开始你的探险之旅。\n选择你的路径并开始探索。",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "开始游戏",
                action = function()
                    sceneManager:loadScene("forest")
                end
            },
            {
                text = "帮助",
                action = function()
                    sceneManager:loadScene("help")
                end
            }
        }
    end
}

-- 帮助场景
scenes["help"] = {
    title = "帮助",
    text = "游戏说明：\n" ..
           "1. 探索世界并收集资源（木材、石头、食物）\n" ..
           "2. 使用资源制作工具和物品\n" ..
           "3. 做出影响故事的选择\n" ..
           "4. 管理你的背包和资源\n" ..
           "5. 升级并提高你的能力\n\n" ..
           "控制：方向键选择，回车确认，鼠标点击",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "返回菜单",
                action = function()
                    sceneManager:loadScene("start")
                end
            }
        }
    end
}

-- 森林场景
scenes["forest"] = {
    title = "神秘森林",
    text = "你来到了一片茂密的森林。\n阳光透过树叶洒下来。\n你听到远处传来奇怪的声音...",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "收集木材",
                action = function()
                    local amount = randomSystem:range(2, 5)
                    inventory:addResource("wood", amount)
                    sceneManager:loadScene("forest_collect")
                end
            },
            {
                text = "探索深处",
                action = function()
                    if randomSystem:chance(50) then
                        sceneManager:loadScene("forest_encounter")
                    else
                        sceneManager:loadScene("forest_empty")
                    end
                end
            },
            {
                text = "制作物品",
                action = function()
                    sceneManager:loadScene("crafting_menu")
                end
            },
            {
                text = "返回营地",
                action = function()
                    sceneManager:loadScene("camp")
                end
            }
        }
    end
}

-- 收集木材场景
scenes["forest_collect"] = {
    title = "收集成功",
    text = "你成功收集了一些木材！\n你的背包现在有了更多资源。",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "继续探索",
                action = function()
                    sceneManager:loadScene("forest")
                end
            }
        }
    end
}

-- 遭遇场景
scenes["forest_encounter"] = {
    title = "神秘发现",
    text = "你发现了一个古老的遗迹！\n它闪烁着奇异的光芒。\n你应该进去探索吗？",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "进入遗迹",
                action = function()
                    inventory:addItem("古币", 1)
                    inventory:addResource("stone", 3)
                    sceneManager:loadScene("forest_treasure")
                end
            },
            {
                text = "离开这里",
                action = function()
                    sceneManager:loadScene("forest")
                end
            }
        }
    end
}

-- 空场景
scenes["forest_empty"] = {
    title = "深处探索",
    text = "你在森林深处走了很久，但什么都没有发现。\n只有风吹过树叶的声音。",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "返回",
                action = function()
                    sceneManager:loadScene("forest")
                end
            }
        }
    end
}

-- 宝藏场景
scenes["forest_treasure"] = {
    title = "宝藏发现",
    text = "你找到了宝藏！\n获得了古币和石头。\n这些东西可能很有价值。",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "返回森林",
                action = function()
                    sceneManager:loadScene("forest")
                end
            }
        }
    end
}

-- 营地场景
scenes["camp"] = {
    title = "冒险者营地",
    text = "你回到了营地。\n这是一个安全的地方，你可以在这里休息和制作物品。",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "制作物品",
                action = function()
                    sceneManager:loadScene("crafting_menu")
                end
            },
            {
                text = "查看背包",
                action = function()
                    sceneManager:loadScene("inventory_view")
                end
            },
            {
                text = "继续探索",
                action = function()
                    sceneManager:loadScene("forest")
                end
            }
        }
    end
}

-- 制作菜单
scenes["crafting_menu"] = {
    title = "制作物品",
    text = "选择你想要制作的物品：",
    
    onEnter = function(self)
        self.choices = {}
        
        for recipeName, recipe in pairs(crafting.recipes) do
            local canCraft = crafting:canCraft(recipeName)
            local status = canCraft and "✓" or "✗"
            
            table.insert(self.choices, {
                text = status .. " " .. recipeName .. " - " .. recipe.description,
                action = function()
                    if crafting:craft(recipeName) then
                        sceneManager:loadScene("craft_success")
                    else
                        sceneManager:loadScene("craft_fail")
                    end
                end
            })
        end
        
        table.insert(self.choices, {
            text = "返回",
            action = function()
                sceneManager:loadScene("camp")
            end
        })
    end
}

-- 制作成功
scenes["craft_success"] = {
    title = "制作成功",
    text = "你成功制作了物品！",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "继续制作",
                action = function()
                    sceneManager:loadScene("crafting_menu")
                end
            },
            {
                text = "返回营地",
                action = function()
                    sceneManager:loadScene("camp")
                end
            }
        }
    end
}

-- 制作失败
scenes["craft_fail"] = {
    title = "制作失败",
    text = "你没有足够的材料来制作这个物品。",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "返回",
                action = function()
                    sceneManager:loadScene("crafting_menu")
                end
            }
        }
    end
}

-- 背包查看
scenes["inventory_view"] = {
    title = "背包",
    text = function()
        local text = "你的物品：\n"
        if next(gameState.inventory) == nil then
            text = text .. "背包是空的\n"
        else
            for item, count in pairs(gameState.inventory) do
                text = text .. item .. " x" .. count .. "\n"
            end
        end
        return text
    end,
    
    onEnter = function(self)
        self.choices = {
            {
                text = "返回",
                action = function()
                    sceneManager:loadScene("camp")
                end
            }
        }
    end
}
