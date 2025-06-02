--services
local input = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local gui = game:GetService("GuiService")
--data
if RS:IsServer() then return "Controls module is inaccessible on the server." end
local convert = {W = "W", Up = "W", S = "S", Down = "S", D = "D", Right = "D", A = "A", Left = "A"}
--controls
local controls = {
	settings = {
		keys_dir = {
			W = Vector3.zAxis,
			A = Vector3.xAxis*-1,
			S = Vector3.zAxis*-1,
			D = Vector3.xAxis 
		}	
	},
	device = {
		phone = 0,
		keyboard = 1,
		controller = 2,
	},
	--properties
	dir = Vector3.zero,
	_device_ = 0,
	_camera_ = workspace.CurrentCamera
}
--methods
function controls.moving(Coordinate:CFrame,Unit:Vector3,tiltEnabled)
	Coordinate = CFrame.fromMatrix(Coordinate.Position,Coordinate.RightVector,Vector3.new(0,0,0),Coordinate.LookVector)
	return Coordinate:VectorToWorldSpace(Unit)
end

function controls.check_device()
	controls._device_ = if (input.KeyboardEnabled and input.MouseEnabled) then controls.device.keyboard elseif
		input.GamepadEnabled then controls.device.controller else controls.device.phone
end
--init
controls.check_device()
--signals
input.InputChanged:Connect(function(input)
	controls.check_device()	
	if controls._device_ == 0 then
		if input.KeyCode == Enum.KeyCode.Thumbstick1 then
			controls.dir = Vector3.new(input.Position.X,input.Position.Y)
			print(controls.dir)
		end
	end
end)

RS.RenderStepped:Connect(function(dt)
	if controls._device_ == 1 then
		local down = {}
		local vec,c = Vector3.zero,0 
		for key, con in convert do
			if input:IsKeyDown(Enum.KeyCode[key]) then
				down[con] = true
			end 
		end
		--calculations
		for key in down do
			vec += controls.settings.keys_dir[key]
			c += 1
		end
		controls.dir = (vec/c).Unit
	end
end)
--return
return controls
