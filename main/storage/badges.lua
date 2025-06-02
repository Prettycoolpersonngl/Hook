--services
local BadgeService = game:GetService("BadgeService")
local RunService = game:GetService("RunService")
--return
return {
	--place badge ids here
	
	--here are the loaded badges
	inst = {},
	--methods
	loadBadges = function(self)
		for name, badge in self do
			if typeof(badge) == "number" then
				local Owns = RunService:IsClient() and BadgeService:UserHasBadgeAsync(badge) or "no, sorry!"
				local BadgeData = {
					id = badge,
					owned = Owns,
				}
				
				self.inst[name] = BadgeData
			end
		end
	end,
	award = function(self,index,player)
		if RunService:IsClient() then return end
		BadgeService:AwardBadge(player.UserId,self.inst[index].id)
	end,
	userowns = function(self,index,player)
		return BadgeService:UserHasBadgeAsync(player.UserId,self.inst[index].id)
	end,
}
