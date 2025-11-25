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
├── libs/                    # 库文件
│   ├── gamestate.lua        # 状态机（参考 HUMP）
│   └── ui.lua               # UI 组件库
├── scenes/
│   ├── base_scene.lua       # 基础场景类
│   └── scenes.lua           # 所有场景定义
├── systems/
│   ├── inventory.lua        # 背包系统
│   ├── crafting.lua         # 制作系统
│   └── random.lua           # 随机系统
├── Noto_Sans_SC/
│   └── NotoSansSC-Regular.ttf  # 中文字体
└── README.md
```

## 如何运行

1. 安装 LOVE2D：https://love2d.org/
2. 在项目目录运行：`love .`

## 架构说明

### 状态机（Gamestate）
使用简化的状态机管理游戏场景，参考 HUMP 库的设计：
- `Gamestate.switch(state)` - 切换场景
- `Gamestate.update(dt)` - 更新当前场景
- `Gamestate.draw()` - 绘制当前场景

### 基础场景类（BaseScene）
所有场景继承自 BaseScene，提供统一的接口：
- `enter()` - 进入场景时调用
- `exit()` - 离开场景时调用
- `update(dt)` - 每帧更新
- `draw()` - 绘制场景
- `keypressed(key)` - 键盘输入
- `mousepressed(x, y, button)` - 鼠标输入

## 如何扩展

### 添加新场景

```lua
scenes.myScene = BaseScene.new(
    "场景标题",
    "场景描述文本"
)

function scenes.myScene:enter()
    BaseScene.enter(self)
    self.buttons = {
        { text = "选项1", action = function() Gamestate.switch(scenes.otherScene) end },
        { text = "选项2", action = function() Gamestate.switch(scenes.anotherScene) end }
    }
end
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

## 参考库

项目参考了以下 LOVE2D 生态中的优秀库：

- **HUMP** (vrld/hump) - 状态机、计时器等工具
- **LOVE UI** (rxi/lui) - UI 框架
- **AnAL** (kikito/AnAL) - 动画库

## 许可证

自由使用和修改
