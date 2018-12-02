Ray = class:new()

require "main"

function Ray:init(angle, px, py)

	self.angle = angle
	self.dx = math.cos(angle)
	self.dy = math.sin(angle)
	self.a = {x = px, y = py}
	self.b = {x = px + self.dx, y = py + self.dy}

end

function Ray:set(angle, px, py)

	self.angle = angle
	self.dx = math.cos(angle)
	self.dy = math.sin(angle)
	self.a = {x = px, y = py}
	self.b = {x = px + self.dx, y = py + self.dy}
	
end

-- Draws ray without collisions
function Ray:drawTest()

	love.graphics.line(self.a.x, self.a.y, 1000000 * self.dx, 1000000 * self.dy)

end