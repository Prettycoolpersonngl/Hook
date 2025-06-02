--var
local Animations = script:GetChildren()
--methods
local len = function(t) 
	local n=0 
	for _, v in t 
		do  n+= 1 
	end 
	return n 
end
--code
return {Instances = Animations,
	Loaded = {},
	Load = function(self,Humanoid:Humanoid)
		local Loaded:{AnimationTrack} = {}
		
		for _, I:Animation in self.Instances do
			self.Loaded[I.Name] = Humanoid:FindFirstChildOfClass("Animator"):LoadAnimation(I)
		end
	end,
}
