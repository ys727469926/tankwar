cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"
local PlayScene = require("scene.PlayScene")

--输出日志到控制台
cclog = function(...)
    print(string.format(...))
end

--添加返回键判断
local addCloseKeyPadListener = function()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_ANDROID == targetPlatform then
        local function onKeyReleased(keyCode)
            if keyCode == cc.KeyCode.KEY_BACK then
                cclog("close game with keypad")
                cc.Director:getInstance():endToLua()
            end
        end

        local listener = cc.EventListenerKeyboard:create()
        listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)

        local eventDisPatcher = cc.Director:getInstance():getEventDispatcher()
        eventDisPatcher:addEventListenerWithFixedPriority(listener, 1)
    end
end

local function main()
    collectgarbage("collect")
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    local director = cc.Director:getInstance()
    --director:getOpenGLView():setDesignResolutionSize(960, 640, 0)

    director:setDisplayStats(true)

    director:setAnimationInterval(1.0 / 60)

    addCloseKeyPadListener()

    --local scene = require("scene.MenuScene")
    --为调试，直接进入playscene
    local menuScene = PlayScene:create()
    --

    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(menuScene)
    else
        cc.Director:getInstance():runWithScene(menuScene)
    end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
