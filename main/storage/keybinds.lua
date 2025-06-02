-------------HOW TO ASSIGN KEYBINDS------------------	
--add the name of the keybind to the corresponding Action
--EXAMPLE: Jump = {"Space","A"} -- detects when pressing A and space
--Checkinput checks the inputobject for the corresponding action
----------------------------------------------------------
return {
	Up = {"Space"},
	Down = {"Shift"},
	--method
	CheckInput = function(self,Input:InputObject,Action)
		local Keybind:string = self[Action]

		return table.find(Keybind,Input.KeyCode.Name) 
			or table.find(Keybind,Input.UserInputType.Name) 
			or table.find(Keybind,Input.UserInputType.Name..Input.Position.Z)
	end,
}
