
local sin = math.sin
local rad = math.rad
local clamp = math.clamp

local lerp = function(y, z, a)
	return y + (z - y) * a
end


local camera = {}

camera.settings = {
	walkspeed = 1;
	
	mouse_smooth_f = 0.95;

	bob_speed = 4;
	bob_z_max = 0.01314;
	damage_mult = 1;

	bob_y_max = 0.22;
	
	max_angle = (math.pi / 2) - 0.017453292519943295 - math.rad(25); -- simplified radian
	
	in_pd = false;
	
	pd_speed = 0.05;
	pd_max = 0.5;
}

camera.rotation = CFrame.new()
camera.position = CFrame.new()

camera.rawmouse = Vector2.new()
camera.mouse = Vector2.new()

camera.anchor = nil

camera.matrix = {
	position = {
		x = 0,
		y = 0,
		z = 0
	};

	rotation = {
		x = 0,
		y = 0,
		z = 0
	}
}


camera._clock = os.clock()

camera._step_r = 0
camera._step_b = false

function camera.step()
	local clock = os.clock()
	local delta = clock - camera._clock
	
	local char_tick = _G.tick / 16
	
	
	local anchor_inst = camera.anchor and camera.anchor:GetPivot().Position or Vector3.new()
	
	local mouse = _G.input.get_mouse_d()
	camera.rawmouse = Vector2.new(
		camera.rawmouse.X - rad(mouse.X), 
		clamp(camera.rawmouse.Y - rad(mouse.Y), -camera.settings.max_angle, camera.settings.max_angle))
	
	camera.mouse = Vector2.new(
		lerp(camera.mouse.X, camera.rawmouse.X, camera.settings.mouse_smooth_f * 12 * delta), 
		clamp(lerp(camera.mouse.Y, camera.rawmouse.Y, camera.settings.mouse_smooth_f * 12 * delta), -camera.settings.max_angle, camera.settings.max_angle))
	
	
	local bob_static = math.sin(char_tick) * camera.settings.bob_z_max * camera.settings.damage_mult
	
	camera.matrix.rotation.z = bob_static
	camera.matrix.position.y = math.sin(char_tick * 2) * camera.settings.bob_y_max
	
	if camera.settings.in_pd then
		camera.matrix.rotation.z = bob_static + 
			math.sin(clock * camera.settings.pd_speed) * camera.settings.pd_max
	end

	camera.position = anchor_inst + Vector3.new(camera.matrix.position.x, camera.matrix.position.y, camera.matrix.position.z)
	camera.rotation = CFrame.fromOrientation(
		camera.matrix.rotation.x + camera.mouse.Y, 
		camera.matrix.rotation.y + camera.mouse.X, 
		camera.matrix.rotation.z
	)
	
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	workspace.CurrentCamera.CFrame = CFrame.new(camera.position) * camera.rotation.Rotation
	
	
	local sin_direction = bob_static > camera._step_r
	
	if sin_direction ~= camera._step_b then
		if _G.collider.rawspeed <= 0 then return end
		
		if _G.collider.state == "sprint" then
			_G.sound:new(_G.sounds.step.concrete.sprint.draw())
		else
			_G.sound:new(_G.sounds.step.concrete.walk.draw())
		end
	end
	
	camera._step_r = bob_static
	camera._step_b = sin_direction
	
	camera._clock = os.clock()
end


return camera
