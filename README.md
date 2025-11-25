# 文字冒险游戏 - LOVE2D

一个用 LOVE2D 制作的纯文本冒险游戏，支持复杂的剧情分支、资源收集、工具制作和高度自由的扩展。

## 功能特性

- **纯文本界面**：黑色背景，白色文字，简洁的色调
- **复杂剧情分支**：支持多条故事线和选择系统
- **点击文字按钮**：支持鼠标点击和键盘选择
- **随机性**：随机事件和概率系统
- **背包系统**：管理物品和资源
- **制作系统**：收集资源制作工具和物品
- **角色系统**：等级、经验、生命值等属性
- **高度可扩展**：易于添加新场景、物品和系统

## 项目结构

```
.
├── main.lua                 # 主程序入口
├── conf.lua                 # LOVE2D 配置
├── scenes/
│   └── sceneManager.lua     # 场景管理系统
├── systems/
│   ├── inventory.lua        # 背包系统
│   ├── crafting.lua         # 制作系统
│   └── random.lua           # 随机系统
└── data/
    └── scenes.lua           # 所有场景定义
```

## 如何运行

1. 安装 LOVE2D：https://love2d.org/
2. 在项目目录运行：`love .`

## 如何扩展

### 添加新场景

在 `data/scenes.lua` 中添加新场景：

```lua
scenes["新场景名"] = {
    title = "场景标题",
    text = "场景描述文本",
    
    onEnter = function(self)
        self.choices = {
            {
                text = "选项文本",
                action = function()
                    sceneManager:loadScene("下一个场景")
                end
            }
        }
    end
}
```

### 添加新物品和配方

在 `systems/crafting.lua` 中的 `crafting.recipes` 表中添加：

```lua
crafting.recipes["新物品"] = {
    requires = { wood = 2, stone = 1 },
    produces = { ["新物品"] = 1 },
    description = "物品描述"
}
```

### 添加新随机事件

在 `systems/random.lua` 中的 `randomSystem:getRandomEvent()` 函数中添加事件。

### 添加新系统

1. 在 `systems/` 目录创建新文件
2. 在 `main.lua` 中 require 该文件
3. 在需要的地方调用系统函数

## 游戏玩法

1. **探索**：在不同场景中移动，发现新的地点
2. **收集**：收集木材、石头、食物等资源
3. **制作**：使用资源制作工具和物品
4. **选择**：做出影响故事发展的选择
5. **升级**：通过完成任务获得经验和升级

## 控制方式

- **上/下箭头**：选择选项
- **回车/空格**：确认选择
- **鼠标点击**：直接点击选项
- **ESC**：退出游戏

## 自定义选项

### 修改窗口大小

编辑 `conf.lua`：

```lua
t.window.width = 1024
t.window.height = 768
```

### 修改字体大小

在 `scenes/sceneManager.lua` 中修改 `love.graphics.newFont()` 的参数。

### 修改颜色

在 `main.lua` 和 `scenes/sceneManager.lua` 中修改 `love.graphics.setColor()` 的 RGB 值。

## 扩展建议

- 添加更多场景和故事线
- 实现对话系统和 NPC
- 添加战斗系统
- 实现存档和读档功能
- 添加音效和背景音乐
- 创建更复杂的制作树
- 添加任务系统
- 实现技能系统

## 许可证

自由使用和修改
