---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yangsen.
--- DateTime: 2018/8/6 12:47
---


local missionScene = class("missionScene", function()
    return cc.Scene:create()
end)

function missionScene:create()

    cclog("missionScene init")
    local scene = missionScene:new()
    local layer = require("layer.missionLayer")
    local missionLayer = layer:create()
    scene:addChild(missionLayer)
    return scene
end

function missionScene:ctor()
end

return missionScene