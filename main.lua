-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
	
--physics library
local physics = require("physics")
	
-- include the Corona "composer" module
--local composer = require "composer"
	
local centerX = display.contentCenterX
local centerY = display.contentCenterY
	
-- forward references
local startGameButton
	
physics.start()

-- functions
function createPlayScreen()
	
	local background = display.newImage("stbg.jpg")
	background.x = centerX	
	background.y = display.contentHeight-10
	background.yScale = 1.4
	
	--physics.addBody ( background, "static")
	
	-- newRect(x, y, width, height)
	local ground = display.newRect( centerX,  centerY+250, 1500, 1)
	ground.objType = "ground"
	physics.addBody( ground, "static", { bounce=0.0, friction=0.3 } )	

	-- parallax scrolling background

	local function scrollBG(self, event)
		if self.x < -100 then
			self.x = 1000-display.contentWidth
		else
			self.x = self.x - 3
			-- it's going to move 3 pixels every second
		end
	end
	
	background.enterFrame = scrollBG
	Runtime:addEventListener("enterFrame", background)

	-- display start button
    startGameButton = display.newImage("startGame.png")
	startGameButton.x = centerX
	startGameButton.y =display.contentHeight+10
	startGameButton.alpha = 0
	transition.to(startGameButton, {time = 2000, alpha = 1, y = centerY} )
	-- end display button
	
end

function startGame()

	-- show the moving cat
	function catAnimation(event)

		-- remove button
		local obj = event.target
		display.remove(obj)
		
		-- show animation
		local sheetData = {
			width = 512,
			height = 256,
			numFrames = 8,
			sheetContentWidth = 2048,
			sheetContentHeight = 512
		}
	
		local mySheet = graphics.newImageSheet("cat.png", sheetData)

		local sequenceData = {
				{name = "normalRun", start = 1, count = 8, time = 500},
				{name = "fastRun", frames = {1, 2, 4, 5, 6, 7}, time = 250, loopCount = 0}

		}
		
		local animation = display.newSprite(mySheet, sequenceData)
		animation.x = centerX-200
--		animation.y = display.contentHeight
		animation.y = centerY
		animation.xScale = .2
		animation.yScale = .2
		animation.timeScale = 1.0
		animation:setSequence("normalRun")
		animation:play()
		-- end 
		
		physics.addBody(animation)
		
		--physics.addBody ( animation, "dynamic", {density =.1, friction =.2, bounce =0, radius = 2})	
		
         --function activateCat(self, event) 
			--applyForce(onX, onY, finalX, finalY)
			--y  = 0 is from the top of the screen. When we move down, it's positive y & on moving up, it's negative y
	     -- self:applyForce(0, -1.5, self.x, self.y)
		 --end
		
		function touchScreen(event)

			if event.phase == "began" then 
		--		animation.enterFrame = activateCat
		--		Runtime:addEventListener("enterFrame", animation)
		--	     setLinearVelocity(x, y)
			 	animation:setLinearVelocity(0, -200)
			end
			
		--	if event.phase == "ended" then
		--		Runtime:removeEventListener("enterFrame", animation)
		--	end

		end
		
		Runtime:addEventListener("touch", touchScreen)	
	end

	startGameButton:addEventListener("tap", catAnimation)

end

function sendEnemy()
		local ball = display.newImage("ball.png")
		ball.x = centerX+100
		ball.y = centerY
		physics.addBody(ball, "static", {density = 0.1, bounce = 0.1})
		
		math.randomseed (os.time())
		ball.x = math.random(centerX+300,  centerX+400)
		ball.y = math.random(centerY-100, centerY+100)

		ball.trans = transition.to(ball, {x = math.random(centerX-400,  centerX-300), y = math.random(centerY-100, centerY+100), time = 2000})
		
		timer.performWithDelay(1000, sendEnemy)
end

createPlayScreen()
startGame()
--timer.performWithDelay(5000,sendEnemy)