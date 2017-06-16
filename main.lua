lg = love.graphics

function love.load()
	lineA = {
		pointA = {x = 20, y = 20},
		pointB = {x = 550, y = 550}
	}

	lineB = {
		pointA = {x = 500, y = 20},
		pointB = {x = 600, y = 550}
	}

	lineX = {
		pointA = {x = 20, y = 20},
		pointB = {x = 600, y = 550}
	}

	bx = 20
	by = 20

	bezier = {{x = 20, y = 20}}
	time = 0
	step = 100
	c = 0
end

function love.update(dt)
	if(c == step) then
		return
	else
		if time < 1 / step then
			time = time + dt
		else
			time = 0

			c = c + 1

			lineX.pointA.x = lineX.pointA.x + math.abs(lineA.pointB.x - lineA.pointA.x) / step
			lineX.pointA.y = lineX.pointA.y + math.abs(lineA.pointB.y - lineA.pointA.y) / step

			lineX.pointB.x = lineX.pointB.x + math.abs(lineB.pointA.x - lineB.pointB.x) / step
			lineX.pointB.y = lineX.pointB.y - math.abs(lineB.pointB.y - lineB.pointA.y) / step

			if lineX.pointB.y < lineX.pointA.y then
			    bx = lineX.pointA.x + math.abs(lineX.pointB.x - lineX.pointA.x) / step * c
				by = lineX.pointA.y - math.abs(lineX.pointB.y - lineX.pointA.y) / step * c
			else
				bx = lineX.pointA.x + math.abs(lineX.pointB.x - lineX.pointA.x) / step * c
				by = lineX.pointA.y + math.abs(lineX.pointB.y - lineX.pointA.y) / step * c
			end

			table.insert(bezier, {x = bx, y = by})
		end
	end
end

function love.draw()
	drawLine(lineA, false)
	drawLine(lineB, false)
	drawLine(lineX, true)

	drawBezier()
end

function drawLine(line, isX)
	if isX then
		lg.setColor(255, 0, 0)
	end

	lg.circle("fill", line.pointA.x, line.pointA.y, 5)
	lg.circle("fill", line.pointB.x, line.pointB.y, 5)

	lg.line(line.pointA.x, line.pointA.y, line.pointB.x, line.pointB.y)

	lg.setColor(255, 255, 255)
end

function drawBezier()
	lg.setColor(0, 255, 0)

	for i = 1, #bezier do
        lg.circle("fill", bezier[i].x, bezier[i].y, 1)
    end

    lg.setColor(255, 255, 255)
end

 
function love.mousepressed(x, y, button, istouch)
   if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
      love.load()
   end
end