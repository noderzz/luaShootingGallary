function love.load()
    -- Target Table
    target = {}
    target.x = love.graphics.getWidth() / 2
    target.y = love.graphics.getHeight() / 2
    target.radius = 50

    -- Game Values
    score = 0
    timer = 0
    gameState = 1
    tryAgainState = 1
    countdown = 0
    triggerCountdown = 1
    middleHeight = love.graphics.getHeight() / 2

    -- Game Fonts
    gameFont = love.graphics.newFont(40)

    -- Sprites
    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    -- Make mouse invisible
    love.mouse.setVisible(false)
    test_bool = false

    -- Particle Test
    particleSystem = love.graphics.newParticleSystem(love.graphics.newImage("sprites/smoke.png"), 3)
    particleSystem:setPosition(0, 0)
    particleSystem:setParticleLifetime(.1, 1) -- Particles live at least 1 second and at most 5 seconds
    particleSystem:setSizeVariation(1)
    particleSystem:setLinearAcceleration(-100, -100, 100, 100) -- Acceleration in pixels per second^2
    particleSystem:setColors(255, 200, 155, 100, 50, 20, 10, 0) -- Fade from white to transparent
    particleSystem:setSizes(.1, .5)
    particleSystem:setRotation(0, 2 * math.pi)

end

function love.update(dt)
    -- Timer
    if timer > 0 then
        timer = timer - dt
    end
    if timer < 0 then
        timer = 0
        gameState = 1
        triggerCountdown = 3
    end

    -- Pause Test
    if countdown > 0 then
        countdown = countdown - dt
    end
    if countdown < 0 then
        countdown = 0
        gameState = 2
        timer = 10
        score = 0
        tryAgainState = 2
        randomCoordinateJump()
    end

    particleSystem:update(dt)

end

function love.draw()
    -- Draw Background
    love.graphics.draw(sprites.sky, 0, 0)

    -- Draw Score
    love.graphics.setFont(gameFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Score: " .. score, 5, 5)

    -- Draw Timer
    love.graphics.setFont(gameFont)
    
    love.graphics.print("Time: " .. math.ceil(timer), love.graphics.getWidth() / 2, 5)
    
    if gameState == 1 and tryAgainState == 2 then
        love.graphics.setColor(255/255, 87/255, 51/255)
        love.graphics.printf("GAME OVER", 0, middleHeight - 40, love.graphics.getWidth(), "center")
        love.graphics.setColor(1,1,1)
        love.graphics.printf("YOUR SCORE: ".. score, 0, middleHeight, love.graphics.getWidth(), "center")
        love.graphics.printf("Click anywhere to try again!", 0, middleHeight + 40, love.graphics.getWidth(), "center")
        if countdown > 0 then
            love.graphics.printf("Next Game In: " .. math.ceil(countdown), 0, middleHeight + 75, love.graphics.getWidth(), "center")
        end
    elseif gameState == 1 then
        love.graphics.printf("Click anywhere to begin!", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end

    -- Add Graphics
    if gameState == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
    love.graphics.draw(particleSystem, 0, 0)
    
end

-- Random Coordinate Jump
function randomCoordinateJump()
    target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
end

-- Code for what happens when the mouse is pressed
function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 and countdown == 0 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        -- Outer Layer
        if gameState == 1 and button == 1 and triggerCountdown == 3 then
            countdown = 3
            triggerCountdown = 1
        elseif gameState == 1 and button == 1 and triggerCountdown == 1 then
            gameState = 2
            timer = 10
            score = 0
            tryAgainState = 2
            randomCoordinateJump()
        -- Outer Layer
        elseif mouseToTarget < target.radius and mouseToTarget >= target.radius * (2/3) then
            callParticles(x,y)
            score = score + 1
            randomCoordinateJump()
        -- Middle Layer
        elseif mouseToTarget < target.radius * (2/3) and mouseToTarget >= target.radius * (1/3) then
            callParticles(x,y)
            score = score + 2
            randomCoordinateJump()
        -- Inner Layer
        elseif mouseToTarget < target.radius * (1/3) then
            callParticles(x,y)
            score = score + 3
            randomCoordinateJump()
        end
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function callParticles(x,y)
    particleSystem:setPosition(x, y)
    particleSystem:emit(30)
end
