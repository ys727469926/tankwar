---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yangsen.
--- DateTime: 2018/8/9 16:21
---

local Bullet = class("Bullet", function(direction, positionX, positionY, isHero)
    return cc.Sprite:create()
end)

function Bullet:ctor(direction, positionX, positionY, isHero)
    self.direction = direction
    self.positionX = positionX
    self.positionY = positionY
    self.isHero = isHero
end

return Bullet