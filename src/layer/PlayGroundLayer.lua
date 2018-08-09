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

function playGroundLayer:operateByTag(tag)
    if tag ~= 5 then
        self:getChildByTag(1):tankMove(tag)
    else
        if self:getChildByTag(1):tankFire() then
            local function fireCalmDown()
                self:getChildByTag(1):setFireCalmDown()
                cclog("already calm down")
            end
            performWithDelay(self, fireCalmDown, 0.5)
        end
    end

end

function playGroundLayer:heroStopMove()
    self:getChildByTag(1):tankStopMove()
end

function playGroundLayer:getHeroDirection()
    return self:getChildByTag(1):getCurrentDirection()
end

return playGroundLayer