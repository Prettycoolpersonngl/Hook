--services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
--modules
local signal = require(script.Parent.Parent.signal)
--private
local input_signals = {}
--falloff
local falloff = {
	settings = {},
	--properties
	actions_falloff = {
		run = tick(),
		jump = tick()
	},
	inputs_falloff = {},
}
--events
UserInputService.InputBegan:Connect(function(input:InputObject,gpe)
	if gpe then return end
	local index = input.KeyCode~=Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
	--input signals
	for _, signal in input_signals do
		if input.KeyCode == signal[1] or input.UserInputType == signal[1] then
			signal[2]:Call(falloff:get_last_input(input.KeyCode == signal[1] and input.KeyCode or input.UserInputType))
		end
	end
	--falloff
	local previous_falloff = falloff.inputs_falloff[index]
	falloff.inputs_falloff[index] = {input,tick()}
end)

--methods
function falloff:get_input_signal(Input)
	local input_signal:signal.type = signal.new()
	
	table.insert(input_signals,{Input,input_signal})
	
	return input_signal	
end

function falloff:get_last_input(Keycode)
	return tick()-(self.inputs_falloff[Keycode] or {nil,0})[2]
end
--return
return falloff
