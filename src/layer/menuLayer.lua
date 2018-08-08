---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yangsen.
--- DateTime: 2018/8/8 11:11
---

local size = cc.Director:getInstance():getWinSize()

local menuLayer = class("menuLayer", function()
    return cc.Layer:create()
end)

function menuLayer:create()
    cclog("menuLayer init")
    local layer = menuLayer:new()

    local spriteFrame = cc.SpriteFrameCache:getInstance()
    spriteFrame:addSpriteFrames("tank.plist")

    local sprite = cc.Sprite:createWithSpriteFrameName("tank_stay_1.png")
    sprite:setPosition(cc.p(260, size.height - 214))
    layer:addChild(sprite)

    --在菜单之前加的label

    --
    local titleLabel = cc.Label:createWithSystemFont("TANK WAR", "Arial", 78)
    titleLabel:setPosition(cc.p(size.width / 2 + 30, size.height - 216))
    layer:addChild(titleLabel)

    --添加菜单项
    cc.MenuItemFont:setFontName("Times New Roman")
    cc.MenuItemFont:setFontSize(48)


    --退出游戏按钮+函数
    local quit = cc.MenuItemFont:create("QUIT")

    local closeGame = function()
        cc.Director:getInstance():endToLua()
    end
    quit:registerScriptTapHandler(closeGame)

    --开始游戏按钮+函数
    local start = cc.MenuItemFont:create("START")
    local function startGame(sender)
        cclog("starting Game")
        local director = cc.Director:getInstance()
        local scene = require("scene.missionScene")
        local missionScene = scene:create()

        director:replaceScene(missionScene)
    end
    start:registerScriptTapHandler(startGame)

    --创建主菜单，如果是ios则退出按钮不可见
    local menu
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        cclog("create menu without closeButton")
        menu = cc.Menu:create(start)
    else
        cclog("create menu with closeButton")
        menu = cc.Menu:create(start, quit)
    end
    menu:alignItemsHorizontallyWithPadding(50)
    menu:setPosition(cc.p(size.width / 2, size.height / 2 - 112))
    layer:addChild(menu)

    --添加坦克移动动画
    local animation = cc.Animation:create()
    for i = 1, 2 do
        local frameName = string.format("tank_move_%d.png", i)
        cclog("frameName = %s", frameName)
        local tankFrame = spriteFrame:getSpriteFrameByName(frameName)
        animation:addSpriteFrame(tankFrame)
    end

    animation:setDelayPerUnit(0.15)
    animation:setRestoreOriginalFrame(true)

    local action = cc.Animate:create(animation)
    sprite:runAction(cc.RepeatForever:create(action))

    return layer
end

return menuLayer

