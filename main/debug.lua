--Module
local TestService = game.TestService

return {
	descendants = function(Instance:Instance,Print_Class:boolean)
		if typeof(Instance) ~= "Instance" then error("Attempt to output descendants of type '"..typeof(Instance).."'") return end
		
		local indent = "	|"
		
		print(Instance)
		for index, Descendant in Instance:GetDescendants() do
			local Ancestors = 0
			local Parent = Descendant
			--finding ancestors
			repeat Ancestors += 1 Parent = Parent.Parent until Parent == Instance
			--
			print(string.rep(indent,Ancestors).." > "..Descendant.Name..(Print_Class and ":"..Descendant.ClassName or ""))
		end
	end,
	--This function Prints out an instance and all of its Descendants
	--[[ Ex:
		local MyInstance = path.to.Instance
		
		debug.descendants(MyInstance)
		----Output----
		MyInstance
			| > Child1
				| > Descendant1
			| > Child2
		----
		Example2:
		
		debug.descendants(MyInstance,true)
		----Output----
		MyInstance:BasePart
			| > Child1:BasePart
				| > Descendant1:Texture
			| > Child2:Decal
		----
	]]
}
