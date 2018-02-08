-- Project: Attack of the Cuteness Game
-- http://MasteringCoronaSDK.com
-- Version: 1.0
-- Copyright 2013 J. A. Whye. All Rights Reserved.
-- Images stolen from the internet

-- housekeeping stuff

display.setStatusBar(display.HiddenStatusBar)

local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- forwared variables
local spawnEnemy
local gameTitle
local scoreTxt
local score = 0
local hitPlanet
local planetDamage
local planet
local speedBump = 0 
local text2
local text3

-- preload audio
--loadstream for background sounds
local sndKill = audio.loadSound("boing-1.wav")
local sndBlast = audio.loadSound("blast.mp3")
local sndLose = audio.loadSound("wahwahwah.mp3")
local sndintro = audio.loadSound("introstartfx.wav")
local sndmain = audio.loadSound("main.mp3")
local sndend = audio.loadSound("ending.mp3")

-- game functions

function spawnEnemy()
	local enemypics = {"beetleship.png","octopus.png", "rocketship.png"}
	local enemy = display.newImage(enemypics[math.random(#enemypics)])
	
	-- local enemy = display.newImage("beetleship.png")
	--enemy.x = math.random(20, display.contentWidth-20)
	--enemy.y = math.random(20, display.contentHeight-20)
	if math.random(2) == 1 then
		enemy.x = math.random(-100,-10)
	else
		enemy.x = math.random (display.contentWidth + 10, display.contentWidth + 100)
		enemy.xScale = -1
	end	
	enemy.y = math.random(display.contentHeight)
	enemy.trans = transition.to(enemy, { x=centerX, y=centerY, time=math.random(2500-speedBump, 4500-speedBump), onComplete=hitPlanet} )
	--enemy.trans = transition.to (enemy, { x=centerX, y=centerY, time=3500, onComplete=hitPlanet})
	enemy:addEventListener ("tap", shipSmash)
	speedBump = speedBump + 50
end



function startGame()
	local text = display.newText("Tap here to start. Protect the planet!",0,0,"Helvetica",16)
	text.x = centerX
	text.y = display.contentHeight - 50
	text:setFillColor(0,0,0)
	local function goAway(event)
		display.remove(event.target)
		text = nil
		display.remove(gameTitle)
		spawnEnemy()
		audio.play(sndmain)
		scoreTxt = display.newText("Score: 0",0,0,"Helvetica",16)
		scoreTxt.x = centerX
		scoreTxt.y = display.screenOriginY + 10
		scoreTxt:setFillColor(0,0,0)
		score = 0
		planet.numHits = 10
		speedBump = 0
		planet.alpha = 1
		display.remove(text2)
		display.remove(text3)
	end
	text:addEventListener ("tap",goAway)
end


function planetDamage()
	planet.numHits = planet.numHits - 2
	planet.alpha = planet.numHits / 10
	if planet.numHits < 2 then
			planet.alpha = 0
			text2 = display.newText("Planet is Toast YOU Lose.",0,0,"Helvetica",16) 
			text2.x = centerX
			text2.y = centerY
			text2:setFillColor(0,0,0)
			text3 = display.newText("Your score: ",0,0,"Helvetica",16)
			text3.x = centerX
			text3.y = centerY +30
			text3:setFillColor(0,0,0)
			text3.text = "Your Score Was: " .. score
			display.remove(scoreTxt)
			timer.performWithDelay (1000, startGame)
			audio.play(sndend)
	else
			local function goAway(obj)
				planet.xScale =1
				planet.yScale = 1
				planet.alpha = planet.numHits / 10
			end	
			transition.to (planet, {time=200, xScale=1.2, yScale=1.2, alpha=1, onComplete=goAway})		
	end
end



function hitPlanet(obj)
	display.remove(obj)
	planetDamage()
	audio.play(sndBlast)
	if planet.numHits > 1 then
			spawnEnemy()
	end
end



function shipSmash(event)
	local obj = event.target
	display.remove(obj)
	audio.play(sndKill)
	transition.cancel (event.target.trans)
	score = score + 5
	scoreTxt.text = "Score: " .. score
	spawnEnemy()
	return true
end


-- create play screen
local function createPlayScreen()
	
	--Add background to screen
	local background = display.newImage("background.png")
	--background.x = centerX
	--background.y = centerY
	
	-- Background tranzparincy
	background.alpha = .1
	
	-- Add planet to screen
	planet = display.newImage("planet.png")
	planet.x = centerX
	planet.y = display.contentHeight + 60
	
	-- Planet tranzparincy and size
	planet.alpha = 0
	planet.xScale = .1
	planet.yScale = .1
	
	local function showTitle()
		gameTitle = display.newImage("gametitle.png")
		gameTitle.alpha = 0
		gameTitle.x = centerX 
		gameTitle.y = centerY - 40
		gameTitle.xScale = .3
		gameTitle.yScale = .3
		transition.to (gameTitle, {time=500, alpha=1, xScale=1, yScale=1, } )	
		startGame()
		end
		
	transition.to (background, {time=2500, y=centerY, x=centerX, alpha=1} )
	transition.to (planet, {time=2500, y=centerY, alpha=1, xScale=1, yScale=1, onComplete=showTitle} )
	audio.play(sndintro)
end	
	
createPlayScreen()


