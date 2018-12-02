Segment = class:new()

function Segment:init(ax, ay, bx, by)

	self.a = {x = ax, y = ay}
	self.b = {x = bx, y = by}

end

function Segment:set(ax, ay, bx, by)

	self.a = {x = ax, y = ay}
	self.b = {x = bx, y = by}

end

function Segment:draw()

	love.graphics.line(self.a.x, self.a.y, self.b.x, self.b.y)

end