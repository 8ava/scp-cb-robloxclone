local module = 
	{
		state = "walk";
		
		walkspeed = 0.9; -- walk - 0.9; sprint - 2.1
		lerp_speed = 0.7;
		
		rawspeed = 0;
		rawvector = Vector3.new();
		
		rawp = Vector3.new();
	}

module.subject = nil

local translation = {
	W = Vector3.new(1, 0, 0);
	S = Vector3.new(-1, 0, 0);
	A = Vector3.new(0, 0, -1);
	D = Vector3.new(0, 0, 1)
}

local deg = (math.pi / 2)

local lerp = function(y, z, a)
	return y + (z - y) * a
end

function module.step()
	if not module.subject then warn("character stepping while no subject!") return end
	
	if module.state == _G.enum.collider.sprint then
		module.walkspeed = 2.1
	end
	
	if module.state == _G.enum.collider.walk then
		module.walkspeed = 0.9
	end
	
	
	local keys = _G.input.get_down()
	
	local rawvector = {}
	for _, key in keys do
		table.insert(rawvector, translation[key])
	end

	local move_vector = Vector3.new()
	for _, key_vector in rawvector do
		move_vector += key_vector
	end

	local normalvector = (move_vector == Vector3.new(0, 0, 0)) and Vector3.new(0, 0, 0) or move_vector.Unit

	local fixed_rotation = (workspace.CurrentCamera.CFrame.Rotation * CFrame.Angles(0, deg, 0))
	local relative_position = (fixed_rotation * normalvector) * (module.walkspeed * 7)
	
	module.rawvector = module.rawvector:Lerp(Vector3.new(relative_position.X, 0, relative_position.Z), module.lerp_speed)
	module.subject.AssemblyLinearVelocity = module.rawvector
	module.rawp = module.subject.CFrame.Position
	
	module.rawspeed = module.rawvector.Magnitude / (module.walkspeed * 5)
	
	local feet = module.subject.Parent["1"]
	
	if math.round(module.rawvector.Magnitude) == 0 then
		feet.Material = Enum.Material.LeafyGrass
	else
		feet.Material = Enum.Material.CrackedLava
	end
	
	if module.rawspeed > 0 then
		--print(module.state)
		_G.tick += ((0.6 + (module.walkspeed * 0.45)) - _G.delta) * (module.rawspeed * 0.82)
	end
end

return module
