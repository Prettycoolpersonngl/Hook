local class = require (script.Parent.class)
--
local Hook_Connection
local HookConnectionData = {
	_type = "InternalConnection",
	_parent = nil,
	_key = 0,
	_function = nil,
	isOnce = false,
	Disconnect = function(self)
		if self._parent then
			self._parent._connected[self._key] = nil
			self = nil
		end
	end,
}

local HookSignalData = {
	_type = "Hook_Signal",
	--functions
	__init = function(self)
		self._script = script
		self._connected = {}
	end,
	Call = function(self,...)
		if script ~= self._script then return end

		for j, connected in self._connected do
			task.spawn(function(...)
				if connected._delay then task.wait(connected._delay) end
				connected._function(...)
				if connected.isOnce then connected:Disconnect() end	
			end,...)
		end
	end,
	Connect = function(self,funct,delay)
		local ICN = Hook_Connection.new()
		ICN._function = funct

		table.insert(self._connected,ICN)
		ICN._key = table.find(self._connected,ICN)
		ICN._delay = delay

		return ICN
	end,
	Once = function(self,funct,delay)
		local ICN = Hook_Connection.new()
		ICN.isOnce = true
		ICN._function = funct
		ICN._delay = delay

		table.insert(self._connected,ICN)
		ICN._key = table.find(self._connected,ICN)
	end,
}
--To get this type when requiring the module simply index it
--[[ex:
		local HookSignal = require(Path.to.hook.Signal)
		local Signal:HookSignal.type = HookSignal.new()
		--> you should start getting autofill for your signal 
		
		the name of the connection type is just Connection so just write HookSignal.Connection and it should do it when connecting
		local HookConnection:HookSignal.connection = Signal:Connect(function()
			print("Hello world!")
		end))
]]
export type type = typeof(HookSignalData)
export type connection = typeof(HookConnectionData)

local Hook_Signal = class(HookSignalData)
Hook_Connection = class(HookConnectionData)
--return
return Hook_Signal
