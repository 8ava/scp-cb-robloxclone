local module = {}
module.directory = Instance.new("Folder")
module.directory.Parent = game.ReplicatedFirst

local sound = Instance.new("Sound")

local blob = game:GetService("ReplicatedStorage"):WaitForChild("common"):WaitForChild("blob"):Clone()

function module:new(id, position, speed, volume)
	speed = speed or 1
	volume = volume or 0.5
	
	local a = sound:Clone()
	
	a.SoundId = "rbxassetid://".. tostring(id)
	a.PlaybackSpeed = speed
	a.Volume = volume
	
	
	if position then
		local b = blob:Clone()
		b.CFrame = CFrame.new(position)
		b.Parent = workspace.effects
		a.Parent = b
		
		a.Ended:Once(function()
			b:Destroy()
		end)

		a:Play()
	else
		a.Parent = module.directory
		
		a.Ended:Once(function()
			a:Destroy()
		end)

		a:Play()
	end
end

return module
