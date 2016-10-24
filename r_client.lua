--[[-------------------------------------------------
Notes:

> This code is using a relative image filepath. This will only work as long as the location it is from always exists, and the resource it is part of is running.
    To ensure it does not break, it is highly encouraged to move images into your local resource and reference them there.
--]]-------------------------------------------------


--- Components UI
BreakLock = {
    component = {}
}

DoorLockComp = {
    component = {}
}

PickLockComp = {
    component = {}
}

DoorLockPos = { {["PosInitial"] = 846},{["PosInitial"] = 814},{["PosInitial"] = 782}}
PickLockPos = { {["PosInitial"] = 750},{["PosInitial"] = 746},{["PosInitial"] = 744}}

-- Dont change anything here
CurrentLockPos = 3
TimesError = 0

-- The times the user can wrong the pass
MaxTimesError = 5
CanBeUnlocked = {{false},{false},{false}}
UnlockedPicks = {{false},{false},{false}}

RandomizeNumberSelection = {{{false},{false},{false}}}

-- Generate the cylinder sequence
CylinderSequence = {}

-- FX Sounds
-- Picklock break
fxPickLockBreak = {{":robber/fx/ui_lockpicking_pickbreak_02.wav"},{":robber/fx/ui_lockpicking_pickbreak_03.wav"}}
fxPickLockUnlock = {{":robber/fx/ui_lockpicking_unlock_01.wav"}}
--fxPickLockUnlock = {{":robber/fx/"}}
fxPickLockCylinder = {{":robber/fx/ui_lockpicking_cylinderstop_01.wav"},{":robber/fx/ui_lockpicking_cylinderstop_02.wav"},{":robber/fx/ui_lockpicking_cylindersqueak_07.wav"}}

local function generateRandomCylinder()

math.randomseed(getTickCount ())
    local CylinderSequenceNmr = ""
    repeat
		Choice = math.random(3)
		if string.find(CylinderSequenceNmr, Choice) == nil then
			CylinderSequenceNmr = CylinderSequenceNmr .. Choice 
			table.insert(CylinderSequence,{Choice})
		end	
    until string.len(CylinderSequenceNmr) == 3
	outputChatBox(CylinderSequenceNmr)
end


		 generateRandomCylinder()

function createPickLockWindow()
	  -- Background
        BreakLock.component[1] = guiCreateStaticImage(714, 357, 256, 256, ":robber/images/zadnik.png", false)
		
	    for i=1,3 do 
	  -- Door lock
        DoorLockComp.component[i] = guiCreateStaticImage(DoorLockPos[i]["PosInitial"], 445, 64, 64, ":robber/images/lapa"..i..".png", false)
	  -- Lockpick
        PickLockComp.component[i] = guiCreateStaticImage(PickLockPos[i]["PosInitial"], 462, 128, 128, ":robber/images/otm"..i..".png", false)
        guiSetVisible (PickLockComp.component[i], not guiGetVisible ( PickLockComp.component[i] ) )
		
		ChangeDoorLockColor(i,1)
		end
		 guiSetVisible (PickLockComp.component[CurrentLockPos],true)
		-- Lock frame
        BreakLock.component[2] = guiCreateStaticImage(714, 357, 256, 256, ":robber/images/zadnik1.png", false)
		
		
		--- Maximum height 0.50
		--- Minimum height 0.60
		---  guiSetPosition ( PickLockComp.component[CurrentLockPos], x, 0.50, true )

	    --local x,y = guiGetPosition ( DoorLockComp.component[CurrentLockPos], true )
		--outputChatBox("Y: "..y)
		toggleAllControls ( false, true, false )
		-- Bind the keys
         bindKey ( "arrow_r", "down", changePickLock )
         bindKey ( "arrow_l", "down", changePickLock )
		 bindKey ( "space", "down", setLockPickOpen )
         addEventHandler("onClientRender", getRootElement(), CheckCorrectColor)
    end
	addCommandHandler("picklock",createPickLockWindow)
	

	
	function ChangeDoorLockColor(id,color)
	if id and color <= 0 or id and color > 3 then id = 1 color = 1 end
	 guiStaticImageLoadImage(DoorLockComp.component[tonumber(id)], ":robber/images/lapa"..tonumber(color)..".png")
	end
	
	-- Function to select the pick to unlock
	function changePickLock ( key, keyState )
  if ( key == "arrow_r" and keyState == "down" ) then
    if(CurrentLockPos ~= 1) then
	CurrentLockPos = math.floor(CurrentLockPos-1)  	
	guiSetVisible (PickLockComp.component[CurrentLockPos+1], false  )
    guiSetVisible (PickLockComp.component[CurrentLockPos], true  )
 end
  elseif ( key == "arrow_l" and keyState == "down" ) then
     if(CurrentLockPos ~= 3) then
    CurrentLockPos = math.floor(CurrentLockPos+1)
    guiSetVisible (PickLockComp.component[CurrentLockPos-1], false  )
    guiSetVisible (PickLockComp.component[CurrentLockPos], true  )
  end
end
end



  function CheckCorrectColor()
  
	    local x,y = guiGetPosition ( PickLockComp.component[CurrentLockPos], true )
        local x1,y1 = guiGetPosition ( DoorLockComp.component[CurrentLockPos], true )
		
		-- Generate random cylinder force to movement
		function generateRandomNumber()
		math.randomseed(getTickCount())
		local randomForce = math.random(1,4)
		if(randomForce == 1) then
		return 0.001
		elseif(randomForce == 2) then
		return 0.01
		elseif(randomForce == 3) then
		return 0.001
		elseif(randomForce == 4) then
	    return 0.01
		else 
		return 0.001
		end
		end
		
		local randomForceSpeed = tonumber(generateRandomNumber())
		
		if getKeyState( "arrow_u" ) == true then
				if(y1 >= 0.50) then
					if(not UnlockedPicks[CurrentLockPos][1]) then
	    guiSetPosition ( PickLockComp.component[CurrentLockPos], x,y1+0.02-randomForceSpeed,true )
	    guiSetPosition ( DoorLockComp.component[CurrentLockPos], x1,y1-randomForceSpeed,true )
		
		end
		end
		elseif(y1 >= 0.49 and y1 <= 0.579) then
	if(not UnlockedPicks[CurrentLockPos][1]) then
	    guiSetPosition ( PickLockComp.component[CurrentLockPos], x,y1+0.02+0.001,true )
	    guiSetPosition ( DoorLockComp.component[CurrentLockPos], x1,y1+0.001,true )	
		end
	end
	

	for i=1,3 do
	 local xx,yy = guiGetPosition ( DoorLockComp.component[i], true )
	    if(yy <= 0.533 and yy >= 0.528) then
		ChangeDoorLockColor(i,2)
		if(i == CurrentLockPos and not CanBeUnlocked[i][1]) then
		setSoundVolume(playSound(fxPickLockCylinder[math.random(1,2)][1]), 0.4)
		end
		CanBeUnlocked[i][1] = true
		setTimer(ChangeDoorLockColor,500,1,i,1)
		else
		CanBeUnlocked[i][1] = false
		end
	
	
	if(i ~= CurrentLockPos) then
	if(yy >= 0.49 and yy <= 0.579) then
	if(not UnlockedPicks[i][1]) then
	    guiSetPosition ( DoorLockComp.component[i], xx,yy+0.001,true )
		end
		end
		end
	end
	end
	
	function checkOpenPicks()
	local TotalPicksOpen = 0
	for k,v in ipairs(UnlockedPicks) do
	if(v[1]) then
	TotalPicksOpen = TotalPicksOpen + 1
	end
	if(TotalPicksOpen >= 3) then
	outputChatBox("Você arrombou a fechadura com sucesso!",0,255,0)
	ResetOptions()
	setSoundVolume(playSound(fxPickLockUnlock[1][1]), 0.6) 
	end
	end
	end
	
	function ResetOptions()
		toggleAllControls ( true, true, true )
		 unbindKey ( "arrow_r", "down", changePickLock )
         unbindKey ( "arrow_l", "down", changePickLock )
		 unbindKey ( "space", "down", setLockPickOpen )
		 
		 
	
	   for i=1,3 do 
	  -- Door lock
		destroyElement (  DoorLockComp.component[i] )
		destroyElement (  PickLockComp.component[i] )
		destroyElement (  BreakLock.component[i])
		end
		 
         removeEventHandler("onClientRender", getRootElement(), CheckCorrectColor)
	end
	
	function nextStepNumber()
	local NumberPhase = 1
	for i=1,3 do
		if(UnlockedPicks[i][1] == true) then
		NumberPhase = NumberPhase+1
		end
		end
		return NumberPhase
		end

	function setLockPickOpen(lock)
    local NumberPhase = nextStepNumber() 
	if(CanBeUnlocked[CurrentLockPos][1]) then

	if(CurrentLockPos == CylinderSequence[NumberPhase][1] ) or NumberPhase >= 3 then	
	UnlockedPicks[CurrentLockPos][1] = true
	nextStepNumber()
	checkOpenPicks()
	setSoundVolume(playSound(fxPickLockCylinder[3][1]), 0.6)
	else
	
	TimesError = math.floor(TimesError + 1)	
	outputChatBox("Você errou a sequência, "..TimesError.." tentativa de "..MaxTimesError.."!",255,70,0)
	for i=1,3 do
	UnlockedPicks[i][1] = false
	end
	ChangeDoorLockColor(CurrentLockPos,3)
	setTimer(ChangeDoorLockColor,500,1,CurrentLockPos,1)
	if(TimesError >= MaxTimesError) then
	ResetOptions()
	outputChatBox("Você errou todas as tentativas e quebrou sua gazua!", 255,0,0)
	setSoundVolume(playSound(fxPickLockBreak[math.random(1,2)][1]), 0.6) -- play broken fx and set the sound volume to 60%
	end
	end
	else
	TimesError = math.floor(TimesError + 1)
	outputChatBox("Você errou a "..TimesError.." tentativa de "..MaxTimesError.."!",255,0,0)
	for i=1,3 do
	UnlockedPicks[i][1] = false
	end
	ChangeDoorLockColor(CurrentLockPos,3)
	setTimer(ChangeDoorLockColor,500,1,CurrentLockPos,1)
	if(TimesError >= MaxTimesError) then
	ResetOptions()
	outputChatBox("Você errou todas as tentativas e quebrou sua gazua!", 255,0,0)

	
	setSoundVolume(playSound(fxPickLockBreak[math.random(1,2)][1]), 0.6) -- play broken fx and set the sound volume to 60%
	
	end
	end
	end
 
  
  
  
  

  