function love.load()
    -- Target Table
    target = {}
    target.x = love.graphics.getWidth() / 2
    target.y = love.graphics.getHeight() / 2
    target.radius = 50

    -- Game Values
    score = 0
    timer = 10

    -- Game Fonts
    gameFont = love.graphics.newFont(40)

    -- Sprites
    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    -- Make mouse invisible
    love.mouse.setVisible(false)
end

function love.update(dt)
    -- Timer
    if timer > 0 then
        timer = timer - dt
    end
    if timer < 0 then
        timer = 0
    end
end

function love.draw()
    -- Draw Background
    love.graphics.draw(sprites.sky, 0, 0)

    -- Draw Circle
    love.graphics.setColor(1,0,0)
    love.graphics.circle("fill", target.x, target.y, target.radius)

    -- Draw Score
    love.graphics.setFont(gameFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(score, 0, 0)

    -- Draw Timer
    love.graphics.setFont(gameFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(math.ceil(timer), love.graphics.getWidth() / 2, 0)

    -- Add Graphics
    love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
    
end

-- Code for what happens when the mouse is pressed
function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        -- Outer Layer
        if mouseToTarget < target.radius and mouseToTarget >= target.radius * (2/3) then
            score = score + 1
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        -- Middle Layer
        elseif mouseToTarget < target.radius * (2/3) and mouseToTarget >= target.radius * (1/3) then
            score = score + 2
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        -- Inner Layer
        elseif mouseToTarget < target.radius * (1/3) then
            score = score + 3
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        end
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end