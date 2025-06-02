--------------- Welcome to Hook! ------------------
--[[
	Hook is my Custom utility Module which provides a variety of tools.
	If you dont understand how to use some of the Modules, comments inside each one should explain how it works.
]]

--Hook Module
type service = "tween"
local Hook = {
	dock = require(script.dock),
	class = require(script.class),
	debug = require(script.debug),
	signal = require(script.signal),
	storage = require(script.storage),
	utils = require(script.utils),
	--
	gtUtils = function(self)
		return unpack(require(script.utils))
	end,
}

return Hook
