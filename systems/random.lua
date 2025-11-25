-- -*- coding: utf-8 -*-
randomSystem = {}

function randomSystem:init()
    math.randomseed(os.time())
end

-- 随机事件
function randomSystem:getRandomEvent()
    local events = {
        { text = "你发现了一些木材！", reward = { wood = 5 } },
        { text = "你挖到了石头！", reward = { stone = 3 } },
        { text = "你找到了一些食物！", reward = { food = 2 } },
        { text = "你遇到了一只野兽，但它跑开了。", reward = {} },
        { text = "你发现了一个古老的遗迹。", reward = { ["古币"] = 1 } }
    }
    return events[math.random(1, #events)]
end

-- 随机选择
function randomSystem:randomChoice(choices)
    return choices[math.random(1, #choices)]
end

-- 随机概率
function randomSystem:chance(percentage)
    return math.random(1, 100) <= percentage
end

-- 随机范围
function randomSystem:range(min, max)
    return math.random(min, max)
end
