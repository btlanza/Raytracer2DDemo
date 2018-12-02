function love.load()

	require "class"
	require "Ray"
	require "Segment"
	
	-- Window setup
	WindowRes = {x = 1280, y = 720}
	love.window.setMode(WindowRes.x, WindowRes.y, {vsync=false})
	
	-- Segments
	segments = {
				-- Border
				Segment:new(0, 0, WindowRes.x, 0), Segment:new(WindowRes.x, 0, WindowRes.x, WindowRes.y),
				Segment:new(WindowRes.x, WindowRes.y, 0, WindowRes.y), Segment:new(0, WindowRes.y, 0, 0),
				-- Square
				Segment:new(300, 300, 400, 300), Segment:new(400, 300, 400, 400),
				Segment:new(400, 400, 300, 400), Segment:new(300, 400, 300, 300),
				-- Some Other Shape
				Segment:new(800, 350, 1100, 350), Segment:new(1100, 350, 1000, 450),
				Segment:new(1000, 450, 1050, 360), Segment:new(1050, 360, 900, 375),
				Segment:new(900, 375, 800, 350),
				-- Another Square
				Segment:new(600, 600, 700, 600), Segment:new(700, 600, 700, 700),
				Segment:new(700, 700, 600, 700), Segment:new(600, 700, 600, 600)
				}
				
	-- Program options
	numRays = 1000
	angles = {}
	for i = 0, numRays - 1, 1 do
		table.insert(angles, i * math.pi * 2 / numRays + 0.00001)
	end
	
	-- Rays
	rays = {}
	for i = 1, numRays, 1 do
		table.insert(rays, Ray:new(0, 0, 0))
	end

	-- Intersections
	tempTable = {}
	intersections = {}
	temp = nil
	
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	
end

function love.update()

	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()

	intersections = {}
	
	if (love.mouse.getX() > WindowRes.x or love.mouse.getX() < 1) then
		mouseX = WindowRes.x / 2
	end
	
	if (love.mouse.getY() > WindowRes.y or love.mouse.getY() < 1) then
		mouseY = WindowRes.y / 2
	end

	for i = 1, numRays, 1 do
		rays[i]:set(angles[i], mouseX, mouseY)
	end
	
	for i = 1, numRays, 1 do
		for j = 1, table.getn(segments), 1 do
			temp = getIntersection(rays[i], segments[j])
			if(temp ~= nil) then
				table.insert(tempTable, temp)
			end
		end
		table.insert(intersections, getMinimumDistance(tempTable))
		tempTable = {}
	end

end

function love.draw()
	
	-- Draw rays
	if (false) then
		for i = 1, table.getn(intersections), 1 do
			love.graphics.line(mouseX, mouseY, intersections[i].x, intersections[i].y)
		end
	end
	
	drawPolygons()
	
	-- Draw line segments
	if (true) then
		for i = 1, table.getn(segments), 1 do
			segments[i]:draw()
		end
	end
	
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print(love.timer.getFPS(), 10, 10)
	love.graphics.setColor(255, 255, 255, 255)

end

function getIntersection(ray, segment)

	-- Ray
	rpx = ray.a.x
	rpy = ray.a.y
	rdx = ray.b.x - ray.a.x
	rdy = ray.b.y - ray.a.y
	
	-- Segment
	spx = segment.a.x
	spy = segment.a.y
	sdx = segment.b.x - segment.a.x
	sdy = segment.b.y - segment.a.y
	
	-- Test for parallelism
	rmag = math.sqrt(rdx * rdx + rdy + rdy)
	smag = math.sqrt(sdx * sdx + sdy * sdy)
	if(rdx / rmag == sdx / smag and rdy / rmag == sdy / smag) then
		return nil
	end
	
	-- Solve for T1 and T2
	T2 = (rdx * (spy - rpy) + rdy * (rpx - spx)) / (sdx * rdy - sdy * rdx)
	T1 = (spx + sdx * T2 - rpx) / rdx
	
	-- Checks if values are within parameters
	if(T1 < 0) then return nil end
	if(T2 < 0 or T2 > 1) then return nil end
	
	-- Returns the point of intersection
	return {x = rpx + rdx * T1, y = rpy + rdy * T1, param = T1}

end

function getMinimumDistance(intersections)

	iteration = 1
	
	if(table.getn(intersections) == 1) then
		return intersections[1]
	end
	
	temp = math.sqrt(math.pow(intersections[1].x - mouseX, 2) + math.pow(intersections[1].y - mouseY, 2))
	for i = 2, table.getn(intersections), 1 do
		if(temp > math.sqrt(math.pow(intersections[i].x - mouseX, 2) + math.pow(intersections[i].y - mouseY, 2))) then
			temp = math.sqrt(math.pow(intersections[i].x - mouseX, 2) + math.pow(intersections[i].y - mouseY, 2))
			iteration = i
		end
	end
	
	return intersections[iteration]

end

function drawPolygons()

	love.graphics.setColor(255, 255, 255, 255)
	numIntersections = table.getn(intersections)
	love.graphics.polygon("fill", mouseX, mouseY, intersections[numIntersections].x, intersections[numIntersections].y, intersections[1].x, intersections[1].y)
	for i = 2, numIntersections, 1 do
		love.graphics.polygon("fill", mouseX, mouseY, intersections[i-1].x, intersections[i-1].y, intersections[i].x, intersections[i].y)
	end
	love.graphics.setColor(255, 255, 255, 255)

end