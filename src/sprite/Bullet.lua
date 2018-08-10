---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yangsen.
--- DateTime: 2018/8/9 16:21
---

local common = require("common")
local size = cc.Director:getInstance():getWinSize()

local Bullet = class("Bullet", function(direction, positionX, positionY, isHero)
    return cc.Sprite:create()
end)

function Bullet:ctor(direction, positionX, positionY, isHero)
    self.direction = direction
    self.positionX = positionX
    self.positionY = positionY
    self.isHero = isHero

    local spriteFrame = cc.SpriteFrameCache:getInstance()
    spriteFrame:addSpriteFrames("tank.plist")
    self:setSpriteFrame("bullet.png")

    --local testSize = self:getContentSize()
    --print('test  '..testSize.width.."   "..testSize.height)

    for i = 1, 4 do
        if direction == i then
            self:setRotation(90 * (i - 1))
            local position = common.polarToRightAngle(positionX, positionY, 25, i)
            self.positionX = position.x
            self.positionY = position.y
            self:setPosition(position)
            break
        end
    end

    local physicsBody = cc.PhysicsBody:createBox(self:getContentSize())
    physicsBody:setDynamic(false)

    physicsBody:setCategoryBitmask(0x02)
    physicsBody:setContactTestBitmask(0x01)
    self:addComponent(physicsBody)
end

function Bullet:fly()

    local time, destination = common.initMoveTo(
            self.direction,
            0.0025,
            self.positionX,
            self.positionY,
            0)
    local action = cc.MoveTo:create(time, destination)

    local flyOutOfScene = function()
        self:removeFromParent()
    end

    local sequence = cc.Sequence:create(action, cc.CallFunc:create(flyOutOfScene))

    self:runAction(sequence)
end

return Bullet