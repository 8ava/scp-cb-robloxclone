local service = game:GetService("UserInputService")

local input = {connection = nil; ["service"] = service}

input.kdown = 
	{
		LeftShift = function()
			if _G.collider.state == _G.enum.collider.walk then
				_G.collider.state = _G.enum.collider.sprint
			end
		end,
		
		Control = function()
			if _G.collider.state == _G.enum.collider.crouch then
				_G.collider.state = _G.enum.collider.walk
			return end
			
			_G.collider.state = _G.enum.collider.crouch
		end,
	}

input.kup = 
	{
		LeftShift = function()
			if _G.collider.state == _G.enum.collider.sprint then
				_G.collider.state = _G.enum.collider.walk
			end
		end,

		Control = function()
			if _G.collider.state == _G.enum.collider.crouch then
				_G.collider.state = _G.enum.collider.walk
			return end

			_G.collider.state = _G.enum.collider.crouch
		end,
	}

local function p(key:InputObject, t)
	if t == _G.enum.input.down then
		if key.UserInputType == Enum.UserInputType.MouseButton1 then
			if _G.cdata.interact_obj then
				_G.sound:new(_G.sounds.button)
			end
		return end
		
		local a = input.kdown[key.KeyCode.Name]; 
		if a then a() end
	else
		local a = input.kup[key.KeyCode.Name]; 
		if a then a() end
	end
end

function input.disconnect()
	if input.connection then input.connection:Disconnect() end
end

function input.connect()
	service.InputBegan:Connect(function(a) p(a, _G.enum.input.down)  end)
	service.InputEnded:Connect(function(a) p(a, _G.enum.input.up) end)
end

function input.get_down()
	local t = {}
	
	for _, a in service:GetKeysPressed() do
		table.insert(t, a.KeyCode.Name)
	end
	
	return t
end

function input.lock_mouse()
	service.MouseBehavior = Enum.MouseBehavior.LockCenter
end


function input.get_rawmouse_p()
	return service:GetMouseLocation()
end

function input.get_mouse_p()
	local a = input.get_rawmouse_p(); return Vector2.new(a.X / workspace.CurrentCamera.ViewportSize.X, a.Y / workspace.CurrentCamera.ViewportSize.Y)
end

function input.get_mouse_d()
	return service:GetMouseDelta()
end

function input.unlock_mouse()
	service.MouseBehavior = Enum.MouseBehavior.Default
end


return input
