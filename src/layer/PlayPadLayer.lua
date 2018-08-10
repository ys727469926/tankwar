---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yangsen.
--- DateTime: 2018/8/8 11:42
---
local common = require("common")

local size = cc.Director:getInstance():getWinSize()

local PlayPadLayer = class("PlayPadLayer", function()
    return cc.Layer:create()
end)

function PlayPadLayer:initButton()

    local spriteFrame = cc.SpriteFrameCache:getInstance()
    spriteFrame:addSpriteFrames("arrows_fire.plist")

    --1234 上右下左
    for i = 1, 4 do
        local button = cc.Sprite:createWithSpriteFrameName(string.format("arrow_%d_64.png", i))
        button:setPosition(common.polarToRightAngle(240, 240, 160, i))
        self:addChild(button, 0, i)
    end

    local button = cc.Sprite:createWithSpriteFrameName("fire.png")
    button:setPosition(cc.p(size.width - 160, 160))
    self:addChild(button, 0, 5)
end

function PlayPadLayer:initOnTouchDirectionEvent()
    --定义四个按钮区域
    local rect = {}
    rect[1] = cc.rect(161, 321, 158, 158) --up
    rect[2] = cc.rect(321, 161, 158, 158) --right
    rect[3] = cc.rect(161, 1, 158, 158)   --down
    rect[4] = cc.rect(1, 161, 158, 158)   --left
    rect[5] = cc.rect(size.width - 260, 100, 160, 160) --fire

    local function onTouchesBegan(touches)
        --cclog("on touch")
        local locationInTouch = touches[1]:getLocation()

        --print(locationInTouch.x..'  '..locationInTouch.y)

        if cc.rectContainsPoint(rect[5], locationInTouch) then
            self:getChildByTag(5):setOpacity(180)
            local function fireCalmDown()
                self:getChildByTag(5):setOpacity(255)
            end
            performWithDelay(self, fireCalmDown, 0.5)
            self.groundLayer:operateByTag(5)
            return true
        else
            if self.isMovePadUsing == false then
                for i = 1, 4 do
                    if cc.rectContainsPoint(rect[i], locationInTouch) then
                        self:getChildByTag(i):setOpacity(180)
                        self.isMovePadUsing = true
                        self.groundLayer:operateByTag(i)
                        return true
                    end
                end
            end
        end
        return false

    end

    local resetOpacity = function()
        self:getChildByTag(self.groundLayer:getHeroDirection()):setOpacity(255)
    end

    local function onTouchesMoved(touches)
        --cclog("on move")
        local locationInTouch_1 = touches[1]:getLocation()

        --设置按钮透明度
        local function setOpacityBatchly(tag)
            local heroDirection = self.groundLayer:getHeroDirection()
            if heroDirection ~= tag then
                self:getChildByTag(heroDirection):setOpacity(255)
            end
            self:getChildByTag(tag):setOpacity(180)
        end

        local movePadEvent = function(location)
            local isInButton = false
            for i = 1, 4 do
                if cc.rectContainsPoint(rect[i], locationInTouch_1) then
                    setOpacityBatchly(i)
                    self.groundLayer:operateByTag(i)
                    isInButton = true
                    if not self.isMovePadUsing then
                        self.isMovePadUsing = true
                    end
                    break
                end
            end

            if not isInButton then
                self.isMovePadUsing = false
                self.groundLayer:heroStopMove()
                resetOpacity()
            end

        end

        movePadEvent(locationInTouch_1)

        if touches[2] then
            local locationInTouch_2 = touches[2]:getLocation()
            if not self.isMovePadUsing then
                movePadEvent(locationInTouch_2)
            end
        end

    end
    --
    local function onTouchesEnded(touches)
        local locationInTouch = touches[1]:getLocation()
        for i = 1, 4 do
            if cc.rectContainsPoint(rect[i], locationInTouch) then
                self.groundLayer:heroStopMove()
                resetOpacity()
            end
        end
    end

    local listener = cc.EventListenerTouchAllAtOnce:create()
    listener:registerScriptHandler(onTouchesBegan, cc.Handler.EVENT_TOUCHES_BEGAN)
    listener:registerScriptHandler(onTouchesMoved, cc.Handler.EVENT_TOUCHES_MOVED)
    listener:registerScriptHandler(onTouchesEnded, cc.Handler.EVENT_TOUCHES_ENDED)

    local evetDispatch = cc.Director:getInstance():getEventDispatcher()
    evetDispatch:addEventListenerWithSceneGraphPriority(listener, self)
end

--function PlayPadLayer:initFireButton()
--    local rect = cc.rect(size.width - 180, 20, 160, 160)
--
--    local function onTouchBegan(touch)
--        local locationInTouch = touch:getLocation()
--        if cc.rectContainsPoint(rect, locationInTouch) then
--            self:getChildByTag(5):setOpacity(180)
--            self.groundLayer:operateByTag(5)
--        end
--        return true
--    end
--
--    local function onTouchMoved(touch)
--        local locationInTouch = touch:getLocation()
--        if not cc.rectContainsPoint(rect, locationInTouch) then
--            self:getChildByTag(5):setOpacity(255)
--        end
--    end
--
--    local function onTouchEnded()
--        self:getChildByTag(5):setOpacity(255)
--    end
--
--    local listener = cc.EventListenerTouchOneByOne:create()
--    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
--    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
--    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
--
--    local evetDispatch = cc.Director:getInstance():getEventDispatcher()
--    evetDispatch:addEventListenerWithSceneGraphPriority(listener, self)
--
--end

function PlayPadLayer:ctor()
    cclog("pad layer ctor")
    self.isMovePadUsing = false
    self.isInMovePad = false

    local function onNodeEvent(event)
        if event == "enter" then
            self:initButton()
            self:initOnTouchDirectionEvent()
            --self:initFireButton()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

return PlayPadLayer