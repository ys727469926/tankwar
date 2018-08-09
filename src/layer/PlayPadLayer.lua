---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yangsen.
--- DateTime: 2018/8/8 11:42
---


local PlayPadLayer = class("PlayPadLayer", function()
    return cc.Layer:create()
end)

function PlayPadLayer:initButton()

    local spriteFrame = cc.SpriteFrameCache:getInstance()
    spriteFrame:addSpriteFrames("arrow.plist")

    --1234 上右下左
    for i = 1, 4 do
        local button = cc.Sprite:createWithSpriteFrameName(string.format("arrow_%d_64.png", i))
        button:setPosition(cc.p(150 + 100 * math.sin(math.rad(90 * (i - 1))),
                150 + 100 * math.cos(math.rad(90 * (i - 1)))))
        self:addChild(button, 0, i)
    end

end

function PlayPadLayer:initOnTouchEvent()


    --定义四个按钮区域
    local rect = {}
    rect[1] = cc.rect(101, 201, 98, 98) --up
    rect[2] = cc.rect(201, 101, 98, 98) --right
    rect[3] = cc.rect(101, 1, 98, 98)   --down
    rect[4] = cc.rect(1, 101, 98, 98)   --left

    local function onTouchBegan(touch)
        cclog("on touch")
        local locationInTouch = touch:getLocation()

        for i = 1, 4 do
            if cc.rectContainsPoint(rect[i], locationInTouch) then
                self:getChildByTag(i):setOpacity(180)
                self.groundLayer:tankMove(i)
                break
            end
        end
        return true
    end

    local resetOpacity = function()
        for i = 1, 4 do
            self:getChildByTag(i):setOpacity(255)
        end
    end

    local function onTouchMoved(touch)
        --cclog("on move")
        local locationInTouch = touch:getLocation()
        local function setOpacityBatchly(tag)
            --统一设置四个按钮的透明度，后期可由groundLayer获取移动标志以处理透明度
            for i = 1, 4 do
                if i == tag then
                    self:getChildByTag(i):setOpacity(180)
                else
                    self:getChildByTag(i):setOpacity(255)
                end

            end
        end

        local isInButton = false
        for i = 1, 4 do
            if cc.rectContainsPoint(rect[i], locationInTouch) then
                setOpacityBatchly(i)
                self.groundLayer:tankMove(i)
                isInButton = true
                break
            end
        end

        if not isInButton then
            --cclog("is not in button")
            self.groundLayer:tankStopMove()
            resetOpacity()
        end
    end

    local function onTouchEnded()
        --统一设置所有按钮透明度恢复，后期可由groundLayer获取移动标志以处理透明度
        self.groundLayer:tankStopMove()
        resetOpacity()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

    local evetDispatch = cc.Director:getInstance():getEventDispatcher()
    evetDispatch:addEventListenerWithSceneGraphPriority(listener, self)


end

function PlayPadLayer:ctor()
    cclog("pad layer ctor")

    local function onNodeEvent(event)
        if event == "enter" then
            self:initButton()
            self:initOnTouchEvent()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

return PlayPadLayer