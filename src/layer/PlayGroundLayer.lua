---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yangsen.
--- DateTime: 2018/8/8 11:41
---

local size = cc.Director:getInstance():getWinSize()

local playGroundLayer = class("playGroundLayer", function()
    return cc.Layer:create()
end)

function playGroundLayer:ctor()
    cclog("play ground layer init sprite")

    local Tank = require("sprite.Tank")

    local tank = Tank:create("tank_stay_1.png")
    tank:setPosition(cc.p(size.width / 2, size.height / 2))
    self:addChild(tank, 0, 1)
end

function playGroundLayer:tankMove(tag)
    self:getChildByTag(1):tankMove(tag)
end

function playGroundLayer:tankStopMove()
    self:getChildByTag(1):tankStopMove()
end

return playGroundLayer