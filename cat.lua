local component = require("component")
local event = require("event")
local term = require("term")
local math = require("math")
local os = require("os")
local telescope = component.telescope
local isObserving = false
local moveCounter = 10

print("CTRL+C to Exit")

local function trackBody()
	local observation = telescope.getObservationStatus()
	isObserving = false
	if observation.object ~= "" then
		print("tracking: "..observation.object.." "..observation.progress)
		telescope.rotateTelescope(observation.relative_x, observation.relative_y)
		isObserving = true
		os.sleep(1)
	end
end

local function randomMove()
	moveCounter = 0
	local x = math.random(-50, 50)
	local y = math.random(-50, 50)
	if x > 0 then x = 100 else x = -100 end
	if y > 0 then y = 100 else y = -100 end
	print("Random move: "..x..", "..y)
	telescope.rotateTelescope(x, y)
end

while not event.pull(0.2, "interrupted") do
	moveCounter = moveCounter + 1
	if moveCounter > 40 and not isObserving then
		randomMove()
	end
	trackBody()
end
