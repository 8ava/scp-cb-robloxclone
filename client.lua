game.ReplicatedFirst:RemoveDefaultLoadingScreen()

local localplayer = game.Players.LocalPlayer

local client = game:GetService("ReplicatedFirst")
local storage = game:GetService("ReplicatedStorage")

local runs = game:GetService("RunService")

-- preloading

do
	local toload = {
		client;
		game:GetService("Workspace");
		storage;
	}
	
	local preload = game:GetService("ContentProvider")
	
	local loadstart = os.clock()
	
	for _, a in toload do
		preload:PreloadAsync(a:GetDescendants())
	end
	
	
	do
		script:WaitForChild("camera")
		script:WaitForChild("input")
		script:WaitForChild("collider")
		script:WaitForChild("sound")
		
		script.Parent:WaitForChild("soundpack")
		
		storage:WaitForChild("communication")
		storage:WaitForChild("common")
		
		client:WaitForChild("interface")
		client:WaitForChild("clientdata")
		
		workspace:WaitForChild("characters")
	end
	
	
	print("preload finished in ".. tostring(os.clock() - loadstart))
end

local data = require(client.clientdata)

local resources = storage.common

local sound = require(script.sound)
local input = require(script.input)
local camera = require(script.camera)
local collider = require(script.collider)

local interface = client.interface

local events = storage.communication
local pooler = require(resources.pool)

local enum = require(resources.enums)
_G.enum = enum

_G.cdata = data

_G.events = events
_G.resources = storage:WaitForChild("common")

_G.tick = 0

_G.input = input
_G.camera = camera
_G.collider = collider

_G.sound = sound
_G.pooler = pooler


local soundpack = require(script.Parent.soundpack)
_G.sounds = soundpack

require(script.DOORTEST)

do
	interface.Parent = localplayer.PlayerGui
	_G.gui = require(interface.manager)
end

events.newcharacter.OnClientEvent:Connect(function(data)
	local character = workspace.characters[localplayer.UserId]
	if not character then warn("client could not find character when server signaled!") return end
	
	input.lock_mouse()
	
	camera.anchor = character["3"]
	
	runs.RenderStepped:Connect(camera.step)
	input.service.MouseIconEnabled = false
	
	collider.subject = character["2"]
	runs.Heartbeat:Connect(collider.step)
	
	input.connect()
end)

events.newsound.OnClientEvent:Connect(function(index)
	sound:new(soundpack.ambient.general[index], nil, 1, 0.2)
end)
