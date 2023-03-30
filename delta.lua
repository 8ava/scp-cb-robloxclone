
local last = os.clock()
local function a()
	local clock = os.clock()
	
	_G.delta = clock - last 
	last = clock
end

game:GetService("RunService").Heartbeat:Connect(a)
