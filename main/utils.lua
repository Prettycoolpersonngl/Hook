--utilities
local utils
utils = {
	loop = function(datatype:number|{},f,data)
		if typeof(datatype) == "string" then
			local b,e,s = unpack(string.split(datatype,","))
			--
			if not b then error("missing beggining index") return end
			if not e then error("missing end index") return end
			--
			s = s or 1
			
			for i = b, e, s do
				f(i,data)
			end
		else
			for i, v in datatype do
				f(i,v,data)
			end
		end
		
		return data
	end,
	--[[
		this loop utility function runs a for loop and returns a table with new contents, 
		lowering the amount of lines you need for certain things
		
		Code Example:
		
		local loop,... = Hook:gtUtils()
		
		local myTable = {}
		local myData = loop("1,100",function(index)
			myTable[index] = index^2
		end))
		
		]]
	clone = function(Table:{}) : {}
		local clone = {}
		
		for index, value in Table do
			if index == "__types" or index == "_charged" or index == "__index" then clone[index] = value continue end
			clone[index] = typeof(value) == "table" and utils.clone(value) or value
		end
		
		return clone
	end,
	--[[
		deepclones a table
	]]
	flip = function(Table:{})
		Table = utils.clone(Table)
		
		for index, value in Table do
			Table[value] = index
		end

		return Table
	end,
	--[[
		deep *FLIPS* a table B)
	]]
	lib2array = function(lib:{})
		local newlib = {}
		
		for index, value in lib do
			table.insert(newlib,{index,value})
		end
		
		return newlib
	end,
	array2lib = function(l2a:{})
		local newlib = {}
		
		for index, value in l2a do
			newlib[value[1]] = value[2]
		end

		return newlib
	end,
	--time
	to_ms = function(t)
		return t*1000
	end,
	to_h = function(t)
		return t/60
	end,
	to_d = function(t)
		return t/60/24
	end,
	to_y = function(t)
		return t/60/24/365
	end,
}
--
return utils
