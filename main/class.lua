local utils = require(script.Parent.utils)
--class function
function class(properties) : {new:()->(),charge:(self,superclass:{})->()}
	if not properties then error("missing property table") return end
	local constructor = properties
	constructor.__charged = {}
	constructor.__types = {}
	constructor.__index = constructor
	--gives the constructor/object methods and properties of the superclass
	function constructor:charge(superclass)
		
		for index, inherited in superclass do
			if index == "__init" then table.insert(self.__charged,inherited) end
			if index == "_type" then table.insert(self.__types,inherited) end
			if index == "__charged" then
				for _, init in inherited do
					table.insert(self.__charged,init)
				end
			end
			if index == "__types" then
				for _, ty in inherited do
					table.insert(self.__types,ty)
				end
			end
			if not self[index] and index ~= "__init" then self[index] = inherited end
		end
	end
	
	function constructor:isa(type)
		if self._type == type then return true end
		for _, ty in self.__types do
			if ty == type then return true end
		end
	end
	--Constructs a new class object based on the constructor you made
	function constructor.new(...)
		local self = {}
		
		self =  setmetatable(self,utils.clone(constructor))
		--constructor functions
		if self.__init then self:__init(...) end
		for _, init in constructor.__charged do
			init(self,...)
		end
		
		return self
	end
	
	return constructor
end

return class
