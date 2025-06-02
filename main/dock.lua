----------Welcome to Dock!-----------

-- Dock is hooks integrated Data store module

if game["Run Service"]:IsClient() then return nil end
--utility
local class = require(script.Parent.class)
--Services
local DataStoreService = game:GetService("DataStoreService")
local BanDataStore = DataStoreService:GetDataStore("?BST")
--classdata
local dock = nil
local vesselData = {
	anchors = {},
	jail = {},
	--methods
	__init = function(self,player:Player,autosave)
		self.captain = player
		--Check for the players status
		local succ, jail = pcall(function()
			return BanDataStore:GetAsync("hook_"..player.UserId)
		end)
		--Vessel Automatic Save
		if autosave then
			player:GetPropertyChangedSignal("Parent"):Connect(function()
				if player.Parent == game.Players then return end
				for name, anchor in self.anchors do
					self:reel(name)
				end
			end)
		end
		
		--Jail
		self.jail = jail or {}
		local jail = self.jail
		
		if jail.Jailed then
			--Check if the player is Permabanned
			if not jail.Time then player:Kick((jail.Reason or "You have been banned").." || Permanent ban") return end
			--Data
			local jailtime = jail.Time
			local jaildate = jail.Date
			--Checks if the jailed player has waited his jailtime
			if jaildate + jailtime > tick() then
				local date = os.date(nil,jaildate+jailtime)
				
				player:Kick((jail.Reason or "You have been banned").." || Unbanned by "..tostring(date))
			else
				jail.Jailed = false
			end
		end
	end,
	--
	cast = function(self,anchor:string,anchorbase:{any},key)
		--this is to ensure you dont accidentally change the ban datastore
		if string.find(anchor,"?") then error("Invalid anchor naming: '?'") return end
		--Anchors
		local anchorpoint = DataStoreService:GetDataStore(anchor)
		local succ, data = pcall(function()
			return anchorpoint:GetAsync(key or "hook_"..self.captain.UserId)
		end)
		--this gets the anchorpoint (datastore) and its data (with the given key)
		--[[
			Note that anchors are ALWAYS!! tables
			meaning you have to modify them like this: 
			
			yourvessel.youranchor.Cash = 999
		]]
		data = if data and next(data) then 
				dock.deserialize_table(data) 
			elseif anchorbase then
				anchorbase 
			else {}
		data.__anchorKey = key or "hook_"..self.captain.UserId
		self.anchors[anchor] = data
		
		return data
	end,
	reel = function(self,anchor:string)
		--saving should happen automatically but you can close an anchor/datastore manually if you like
		local anchorpoint = DataStoreService:GetDataStore(anchor)
		--Anchor
		local anchorn = self.anchors[anchor]
		local anchorkey = anchorn.__anchorKey
		anchorn.__anchorKey = nil
		
		anchorpoint:SetAsync(anchorkey,dock.serialize_table(anchorn))
		--closing of session
		self.anchors[anchor] = nil
	end,
	--
	arrest = function(self,bantime,reason)
		local jail = self.jail
		--Settings
		jail.Reason = reason
		jail.Jailed = true
		jail.Time = bantime
		jail.Date = tick()
		--Saving the jaildata
		BanDataStore:SetAsync("hook_"..self.captain.UserId,jail)
		--Kick player
		local date = os.date(nil,tick()+bantime)
		self.captain:Kick((jail.Reason or "You have been banned").." || Unbanned by "..tostring(date))
	end,
	--remove
	remove = function(self)
		for anchor, tab in self.anchors do
			self:reel(anchor)
		end
		
		for index, value in self do
			self[index] = nil
		end
		
		self = nil
	end,
}
--constructors
local vessel = class(vesselData)
--dock
dock = {
	vessels = {},
	--methods
	hoist = function(self,player:player) : vessel
		local vessel:vessel = vessel.new(player)
		self.vessels[player.Name] = vessel
		
		return vessel
	end,
	serialize_table = function(t)
		local serialized = {}
		
		for index, value in t do
			if typeof(value) == "Vector3" then
				local x,y,z = math.round(value.X*1000)/1000,math.round(value.Y*1000)/1000,math.round(value.Z*1000)/1000
				
				value = {x,y,z,"#~"}
			elseif typeof(value) == "Vector2" then
				local x,y = math.round(value.X*1000)/1000,math.round(value.Y*1000)/1000

				value = {x,y,"#~"}
			elseif typeof(value) == "UDim2" then
				local xscale,xoffset,yscale,yoffset = math.round(value.X.Scale*1000)/1000,value.X.Offset,math.round(value.Y.Scale*1000)/1000,value.Y.Offset

				value = {xscale,xoffset,yscale,yoffset,"#+"}
			elseif typeof(value) == "UDim" then
				local scale,offset = math.round(value.X*1000)/1000,value.Offset

				value = {scale,offset,"#+"}
			elseif typeof(value) == "CFrame" then
				local x,y,z = math.round(value.X*1000)/1000,math.round(value.Y*1000)/1000,math.round(value.Z*1000)/1000
				local R = {}
				for R = 0,2 do
					for R1 = 0,2 do
						table.insert(value[R..R1])
					end
				end
				
				value = {x,y,z,unpack(R)}
				table.insert(value,"#*")
			end
			
			serialized[index] = value
		end
		
		return serialized
	end,
	deserialize_table = function(t)
		local deserialized = {}

		for index, value in t do
			if typeof(value) == "table" then
				if value[4] == "#~" then
					value = Vector3.new(unpack(value))
				elseif value[3] == "#~" then
					value = Vector2.new(unpack(value))
				elseif value[5] == "#+" then
					value = UDim2.new(unpack(value))
				elseif value[3] == "#+" then
					value = UDim.new(unpack(value))
				elseif table.find(value,"#*") then
					value = CFrame.new(unpack(value))
				end
			end

			deserialized[index] = value
		end
		
		return deserialized
	end,
}

--exporting the type so you get autofill for your sessions
export type vessel = typeof(vesselData)

--return
return dock
