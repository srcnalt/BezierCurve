lg = love.graphics

function love.load()
	pointCount = 4
	points = {}

	lineN = {}
	lineX = {}
	lineY = {}

	bezier = {}

	time = 0
	step = 100
	c = 0
	r = 5
end

function love.update(dt)
	if #points < pointCount then return end

	if(c == step) then
		return
	else
		if time < 1 / step then
			time = time + dt
		else
			time = 0

			c = c + 1

			if lineN.pointA.x < lineN.pointB.x then
				lineX.pointA.x = lineX.pointA.x + math.abs(lineN.pointB.x - lineN.pointA.x) / step
			else
				lineX.pointA.x = lineX.pointA.x - math.abs(lineN.pointB.x - lineN.pointA.x) / step
			end

			if lineN.pointA.y < lineN.pointB.y then
				lineX.pointA.y = lineX.pointA.y + math.abs(lineN.pointB.y - lineN.pointA.y) / step
			else
				lineX.pointA.y = lineX.pointA.y - math.abs(lineN.pointB.y - lineN.pointA.y) / step
			end
			
			if lineN.pointB.x < lineN.pointC.x then
				lineX.pointB.x = lineX.pointB.x + math.abs(lineN.pointC.x - lineN.pointB.x) / step
			else
				lineX.pointB.x = lineX.pointB.x - math.abs(lineN.pointC.x - lineN.pointB.x) / step
			end

			if lineN.pointB.y < lineN.pointC.y then
				lineX.pointB.y = lineX.pointB.y + math.abs(lineN.pointC.y - lineN.pointB.y) / step
			else
				lineX.pointB.y = lineX.pointB.y - math.abs(lineN.pointC.y - lineN.pointB.y) / step
			end

			if lineN.pointC.x < lineN.pointD.x then
				lineX.pointC.x = lineX.pointC.x + math.abs(lineN.pointD.x - lineN.pointC.x) / step
			else
				lineX.pointC.x = lineX.pointC.x - math.abs(lineN.pointD.x - lineN.pointC.x) / step
			end

			if lineN.pointC.y < lineN.pointD.y then
				lineX.pointC.y = lineX.pointC.y + math.abs(lineN.pointD.y - lineN.pointC.y) / step
			else
				lineX.pointC.y = lineX.pointC.y - math.abs(lineN.pointD.y - lineN.pointC.y) / step
			end

			--

			if lineX.pointA.x < lineX.pointB.x then
				lineY.pointA.x = lineX.pointA.x + math.abs(lineX.pointB.x - lineX.pointA.x) / step * c
			else
				lineY.pointA.x = lineX.pointA.x - math.abs(lineX.pointB.x - lineX.pointA.x) / step * c
			end

			if lineX.pointA.y < lineX.pointB.y then
				lineY.pointA.y = lineX.pointA.y + math.abs(lineX.pointB.y - lineX.pointA.y) / step * c
			else
				lineY.pointA.y = lineX.pointA.y - math.abs(lineX.pointB.y - lineX.pointA.y) / step * c
			end

			if lineX.pointB.x < lineX.pointC.x then
				lineY.pointB.x = lineX.pointB.x + math.abs(lineX.pointC.x - lineX.pointB.x) / step * c
			else
				lineY.pointB.x = lineX.pointB.x - math.abs(lineX.pointC.x - lineX.pointB.x) / step * c
			end

			if lineX.pointB.y < lineX.pointC.y then
				lineY.pointB.y = lineX.pointB.y + math.abs(lineX.pointC.y - lineX.pointB.y) / step * c
			else
				lineY.pointB.y = lineX.pointB.y - math.abs(lineX.pointC.y - lineX.pointB.y) / step * c
			end
			
			table.insert(bezier, calcLineX(lineY, true))
		end
	end
end

function calcLineX(line)
	point = {x = 0, y = 0}

	if line.pointA.x < line.pointB.x then
	    point.x = line.pointA.x + math.abs(line.pointB.x - line.pointA.x) / step * c
	else
	    point.x = line.pointA.x - math.abs(line.pointB.x - line.pointA.x) / step * c
	end

	if line.pointA.y < line.pointB.y then
		point.y = line.pointA.y + math.abs(line.pointB.y - line.pointA.y) / step * c
	else
		point.y = line.pointA.y - math.abs(line.pointB.y - line.pointA.y) / step * c
	end

	return point
end

function love.draw()
	drawLine()

	drawBezier()

	lg.print("left mouse click reset\nright mouse click add point", 10, 10)
end

function drawLine(line, isX)
	if #points < pointCount then
		for i = 1, #points do
			lg.circle("fill", points[i].x, points[i].y, r)
		end
	else
		lg.circle("fill", lineN.pointA.x, lineN.pointA.y, r)
		lg.circle("fill", lineN.pointB.x, lineN.pointB.y, r)
		lg.circle("fill", lineN.pointC.x, lineN.pointC.y, r)
		lg.circle("fill", lineN.pointD.x, lineN.pointD.y, r)
		lg.line(lineN.pointA.x, lineN.pointA.y, lineN.pointB.x, lineN.pointB.y, lineN.pointC.x, lineN.pointC.y, lineN.pointD.x, lineN.pointD.y)

		lg.setColor(255, 255, 0)
		lg.line(lineX.pointA.x, lineX.pointA.y, lineX.pointB.x, lineX.pointB.y, lineX.pointC.x, lineX.pointC.y)
		lg.setColor(255, 255, 255)

		lg.setColor(0, 255, 0)
		lg.line(lineY.pointA.x, lineY.pointA.y, lineY.pointB.x, lineY.pointB.y)
		lg.setColor(255, 255, 255)
	end
end

function drawBezier()
	lg.setColor(255, 0, 0)

	for i = 1, #bezier do
        lg.circle("fill", bezier[i].x, bezier[i].y, 3)
    end

    lg.setColor(255, 255, 255)
end

function love.mousepressed(x, y, button, istouch)
	--reset
	if button == 2 then
		love.load()
	elseif button == 1 and #points < pointCount then
		table.insert(points, {x = x, y = y})

		if #points == pointCount then
			lineN = {
				pointA = {x = points[1].x, y = points[1].y},
				pointB = {x = points[2].x, y = points[2].y},
				pointC = {x = points[3].x, y = points[3].y},
				pointD = {x = points[4].x, y = points[4].y}
			}

			lineX = {
				pointA = {x = lineN.pointA.x, y = lineN.pointA.y},
				pointB = {x = lineN.pointB.x, y = lineN.pointB.y},
				pointC = {x = lineN.pointC.x, y = lineN.pointC.y}
			}

			lineY = {
				pointA = {x = lineX.pointA.x, y = lineX.pointA.y},
				pointB = {x = lineX.pointB.x, y = lineX.pointB.y}
			}

			--bezier = {x = points[1].x, y = points[1].y}
		end
	end	
end