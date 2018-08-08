---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yangsen.
--- DateTime: 2018/8/8 11:41
---

local size = cc.Director:getInstance():getWinSize()

local playGroundLayer = class("playGroundLayer", function()
    return cc.Layer:create()
end)

local initSprite = function(target)
    cclog("play ground layer init sprite")

    local Tank = require("sprite.Tank")

    local tank = Tank:create("tank_stay_1.png")
    tank:setPosition(cc.p(size.width / 2, size.height / 2))
    target:addChild(tank, 0, 1)
end

function playGroundLayer:create()
    cclog("play groud layer init")
    local layer = playGroundLayer.new()

    initSprite(layer)

    return layer
end

function playGroundLayer:ctor()
end

function playGroundLayer:heroMove(tag)
    self:getChildByTag(1):tankMove(tag)
end

return playGroundLayer