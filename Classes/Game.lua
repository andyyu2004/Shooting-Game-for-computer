
-- =============================================================

--======================================================================--
--== Game Class factory
--======================================================================--
local Game = class() -- define Game as a class (notice the capitals)
Game.__name = "Game" -- give the class a name
local enemies = {}
--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable") -- helper class to use when developint
-- pt.print_r(....) will print the contents of a table
local Controls	 	= require ("Classes.Controls") -- 
local Boundary		= require ("Classes.Boundary")
local EnemyClass	= require ("Classes.Enemy")
local PlayerClass 	= require ("Classes.Player")
local EnemyTwoClass = require ("Classes.EnemyTwo")
local EnemyThreeClass = require ("Classes.EnemyThree")
local SuperEnemyClass = require ("Classes.SuperEnemy")
local PowerUpSMG 	=	 require ("Classes.PowerUpSMG")


-- Constants
local fullw = display.contentWidth
local fullh = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

--======================================================================--
--== Initialization / Constructor
--======================================================================--
function Game:__init(group, options)

	self.group = group -- the group where the game should be inserted into	
	local enemyDetails = options.enemyDetails or {}
	
	self.enemyBulletIntervalMin = enemyDetails.bulletIntervalMin or 1000
	self.enemyBulletIntervalMax = enemyDetails.bulletIntervalMax or 5000
	self.enemyHealth=enemyDetails.health or 3 
	self.enemyBulletSpeed = enemyDetails.enemyBulletSpeed or 350
	self.enemySpeed = enemyDetails.enemySpeed or 90
	self.enemyN = 0
	self.enemyWaveIncrease = 1
	self.waveN=1
	self.scoreValue=0
	
	local playerDetails = options.playerDetails or {}
	self.playerSpeed = playerDetails.playerSpeed or 100
	self.bulletSpeed = playerDetails.bulletSpeed or 600 
	self.bulletInterval = playerDetails.bulletInterval or 300
	self.ammunition = 15 or playerDetails.ammunition
	self.reloadAmmunition=self.ammunition
	self.reloadTime = playerDetails.reloadTime or 3000
	self.rocketInterval = playerDetails.rocketInterval or 1000
	self.rocketSpeed = playerDetails.rocketSpeed or 675
	self.health = playerDetails.health or 1000

	self:gameOver()
   end

--======================================================================--
--== Code / Methods
--======================================================================--
function Game:setScore()
	self.setScore = function(event)
		self.scoreValue = self.scoreValue + event.score
		--print(self.score)
		self:drawScore()
		--print(event.score)
		end
	Runtime:addEventListener ("setScore", self.setScore)
end
	

function Game:drawScore()
	-- Displays the Score on the screen
	-- Receives: nil
	-- Returns: nil
	local options1 = {
		parent=self.group,
		text="Score: "..self.scoreValue,
		x=50,
		y=2.5,
		fontSize=16,
		font=native.systemFontBold
		}
	if self.scoreDisplay then
		self.scoreDisplay.text = "Score: "..self.scoreValue
	else
		self.scoreDisplay=display.newText(options1)
	end
end

function Game:setUp()
	-- sets up the game enviroment
	
	-- draw the 3 controls
	local leftKey = Controls:new(self.group, centerX-35,fullh-30, "images/up.png", -90, "a")
	local rightKey = Controls:new(self.group, centerX+35,fullh-30, "images/up.png", 90, "d")
	local upKey = Controls:new(self.group, centerX,fullh-47, "images/up.png", 0, "w")
	local downKey = Controls:new(self.group, centerX,fullh-13, "images/up.png", 180, "s")
	local rKey = Controls:new(self.group, centerX,-2000, "images/up.png", 180, "r")
	local lKey = Controls:new(self.group, centerX,-2000, "images/up.png", 180, "l")
	local fKey = Controls:new(self.group, centerX,-2000, "images/up.png", 180, "f")
	local spaceKey = Controls:new(self.group, centerX,-2000, "images/up.png", 0, "space")
	
	-- Add some boundaries and walls
	local Boundary = Boundary:new(self.group)
	
	-- draw the player
	self.Player =  PlayerClass:new(self.group,centerX,centerY, self.bulletSpeed, self.bulletInterval, self.playerSpeed, self.ammunition, self.reloadTime, self.rocketInterval, self.reloadAmmunition, self.rocketSpeed, self.health)

	
end  

function Game:startGame()
	-- dispatch instructions to enemies to spawn enemies
	--Wave Control
	self.drawText = function()
		local textOptions = {
			parent=self.group,
			text="Wave "..self.waveN,
			x=centerX,
			y=centerY-80,
			fontSize=18,
			font=native.systemFontBold
			}
			--if self.waveNotification then
			--display.remove( self.waveNotification )
			--end
			self.waveNotification=display.newText(textOptions)
		end
	
	
	self.drawText()
	self.timer = timer.performWithDelay (3000,
		function()
		display.remove(self.waveNotification)
	for i=1,self.enemyWaveIncrease do -- spawns wave one, this was written first before the spawnWaves function, dont think it is worth updating as it is still pretty functional
		self.enemy = EnemyClass:new(self.group, -20*i, -20*i, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
		self.enemy = EnemyClass:new(self.group, 20*i+fullw, -20*i, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
		self.enemy = EnemyClass:new(self.group, -20*i, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
		self.enemy = EnemyClass:new(self.group, 20*i+fullw, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
		--self.enemyTwo = EnemyTwoClass:new(self.group, 20*i+fullw, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
		self.enemyN=4*self.enemyWaveIncrease
		--enemies[i] = EnemyClass:new(self.group, 100, 100, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
		end
		print("No. Of Enemies = "..self.enemyN)
	self.waveN=self.waveN+1
	end)

	
	self.spawnWaves=function(event)
		self.enemyN=self.enemyN - event.modifier
		print("No. Of Enemies =  "..self.enemyN)
		if self.enemyN == 0 then
			self:drawText()
			print ("Wave "..self.waveN)
			self.timer = timer.performWithDelay (3000,
			function()
				display.remove(self.waveNotification)
				if self.waveN > 7 then 
					for i = 1,(self.waveN * self.enemyWaveIncrease) do
						self.enemy = EnemyClass:new(self.group, -20*i, -20*i, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, 20*i+fullw, -20*i, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, -20*i, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, 20*i+fullw, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyTwoClass:new(self.group,nil, nil, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
						self.enemy = EnemyThreeClass:new(self.group,nil, nil, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
					end	
					for i = 1, (self.waveN * self.enemyWaveIncrease - 5) do
						SuperEnemyClass:new(self.group,nil, nil, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
					end
				elseif self.waveN == 7 then
					for i = 1,3 do
						SuperEnemyClass:new(self.group,nil, nil, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
						self.enemy = EnemyClass:new(self.group, -20*i, -20*i, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, 20*i+fullw, -20*i, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, -20*i, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, 20*i+fullw, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyTwoClass:new(self.group,nil, nil, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
					end
		
				elseif self.waveN==5 then
					for i = 1,2 do
						SuperEnemyClass:new(self.group,nil, nil, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
						self.enemy = EnemyClass:new(self.group, -20*i, -20*i, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, 20*i+fullw, -20*i, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, -20*i, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, 20*i+fullw, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
					end	
				elseif self.waveN==3 then
					SuperEnemyClass:new(self.group,nil, nil, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
				else
					for i=1, (self.waveN * self.enemyWaveIncrease) do
						self.enemy = EnemyClass:new(self.group, -20*i, -20*i, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, 20*i+fullw, -20*i, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, -20*i, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						self.enemy = EnemyClass:new(self.group, 20*i+fullw, 20*i+fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
						if self.waveN >=3 then
							self.enemy = EnemyTwoClass:new(self.group,nil, nil, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
						end
						if self.waveN>=5 then
							self.enemy = EnemyThreeClass:new(self.group,nil, nil, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
						end
					end
				end			
				if self.waveN > 7 then 
					self.enemyN = 6*self.waveN*self.enemyWaveIncrease + (self.waveN*self.enemyWaveIncrease-5)
				elseif self.waveN==7 then
					self.enemyN = 18
				elseif self.waveN > 5 then  
					self.enemyN=6*self.waveN*self.enemyWaveIncrease
				elseif self.waveN == 5 then
					self.enemyN=10
				elseif self.waveN > 3 then 
					self.enemyN=5*self.waveN*self.enemyWaveIncrease
				elseif self.waveN == 3 then 
					self.enemyN=1 
				else 
					self.enemyN=4*self.waveN*self.enemyWaveIncrease
				end
				print("No. of Enemies ".. self.enemyN)
				self.waveN=self.waveN + 1
			end)
		end
	end
	Runtime:addEventListener("enemyN", self.spawnWaves)
	
	self:deconstructor()
end

function Game:listen()
	-- listen to for custom messages
	function self.keyPressed (self, event) -- if a key is pressed
		if event.phase == "began" then -- the following dispatchEvent style movement allows for diagonals which is otherwise non functional
			if event.key == "a" then
				local a = {
					name = "xVelocity",
					xVelocity = -self.playerSpeed
					}	
				Runtime:dispatchEvent(a)
				--print"a"
				--self.Player:move(-self.playerSpeed, yVelocity)
				--if event.key =="w" then
					--self.Player:move(-self.playerSpeed, -self.playerSpeed)
				--end	
				--self.Player:jump(-self.antiStickJumpValue, 0)
			end	
			if event.key == "d" then
				local d = {
					name = "xVelocity",
					xVelocity = self.playerSpeed
					}	
				Runtime:dispatchEvent(d)
				--self.Player:move(self.playerSpeed, yVelocity)
				--self.Player:jump(self.antiStickJumpValue, 0)
			end	
			if event.key == "w" then
				local w = {
					name = "yVelocity",
					yVelocity = -self.playerSpeed
					}	
				Runtime:dispatchEvent(w)
				--self.Player:move(xVelocity, -self.playerSpeed)
				--self.Player:jump(0, self.antiStickJumpValue)
			end	
			if event.key == "s" then
				local s = {
					name = "yVelocity",
					yVelocity = self.playerSpeed
					}	
				Runtime:dispatchEvent(s)
				--self.Player:move(xVelocity, self.playerSpeed)
				--self.Player:jump(0, -self.antiStickJumpValue)
			end	
			
			if event.key == "r" then
				self.Player:reload()
				--print(event.key)
			end
			if event.key == "f" then
				self.Player:meleeAttack()
				--print(event.key)
			end
			if event.key == "l" then -- for suicidal purposes to test endgame errors or whatever else may be needed on demand (not redundant!!! :)   )
			--	self.enemy = EnemyThreeClass:new(self.group, fullw, fullh, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed)
				--self.enemy = EnemyTwoClass:new(self.group,nil, nil, self.enemyBulletSpeed, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
				--SuperEnemyClass:new(self.group,nil, nil, self.enemyBulletSpeed*0.6, self.enemyHealth, self.enemyBulletIntervalMin, self.enemyBulletIntervalMax, self.enemySpeed) 
			end
			if event.key == "space" then
				self.Player:fireSMG()
			end
		elseif event.phase == "ended" then -- if press is ended then set x/y speed to 0
			if event.key == "a" or "d" then
				local optionsX = {
					name = "xVelocity",
					xVelocity = 0
					}	
				Runtime:dispatchEvent(optionsX)
			end
			if event.key == "w" or "s" then
				local optionsY = {
					name = "yVelocity",
					yVelocity = 0
					}	
				Runtime:dispatchEvent(optionsY)
			end
		end
	 end
	Runtime:addEventListener("keyPressed", self)
  
	-- Called when a mouse event has been received.
	--function self.onMouseEvent( event )
    --if event.isPrimaryButtonDown then
   function self.touchListener (event)
   	self.Player:setBulletDirection(event.x, event.y) -- ensures the bullet direction is in the correct spot when shot
	     	-- print("fire")
    	if (event.phase=="began") then -- or (event.phase=="moved") then
    		--print("touch detected")
	       	
	      	-- print("x = ".. event.x)
	        --print("y = ".. event.y)
	     	 --self.Player:startFire()
			self.Player:fireBullet()
		elseif (event.phase=="moved") then -- for phone usage, swipe for rocket
	     	--self.Player:fireRocket()-- recomment later
	        -- The mouse's primary/left button is not being pressed.
		end
	end
	Runtime:addEventListener ("touch", self.touchListener)   
	
	
	function self.onMouseEvent( event )
		self.Player:setBulletDirection(event.x,event.y) -- updates the vector calculations in playerClass whenever mouse movement is detected so the bullets shoot in correct location
		--print"setting direction"
		if event.isSecondaryButtonDown then
			--print("Right Click")
			--self.Player:setBulletDirection(event.x, event.y)
			self.Player:fireRocket()
		end
		if event.isMiddleButtonDown then
		--	self.Player:setBulletDirection(event.x, event.y)
		--self.Player:fireSMG()
		
		end
    end
	Runtime:addEventListener( "mouse", self.onMouseEvent )

end

function Game:gameOver()
	self.gameOver = function() -- displays score in gameOver Scene
			local options = {
				name = "endGameScore",
				score = self.scoreValue
			}
		self.dispatchTimer = timer.performWithDelay(1200, function()
		Runtime:dispatchEvent(options)
		--print("dispatchscore event")
		end)
	end
	Runtime:addEventListener("gameOver", self.gameOver)
end

function Game:deconstructor() 
	self.group.finalize = function() 
		Runtime:removeEventListener("mouse", self.onMouseEvent)
		Runtime:removeEventListener("keyPressed", self)
		Runtime:removeEventListener ("touch", self.touchListener)   
		Runtime:removeEventListener("enemyN", self.spawnWaves)
		Runtime:removeEventListener("setScore", self.setScore)
		Runtime:removeEventListener("gameOver", self.gameOver)
		--print ("removed group SDFJSDLFKJSDLFKJSDLFJSDFLJSDL")
		--self.enemy:deconstructor()
		timer.cancel(self.timer)
		print("self.group finalize")
		--display.remove(self.enemy)
		--self.enemy=nil
		end
	self.group:addEventListener("finalize")
end
--======================================================================--
--== Return factory
--======================================================================--
return Game
