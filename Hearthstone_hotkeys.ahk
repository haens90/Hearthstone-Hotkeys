#SingleInstance force ; Replace an existing script
#NoEnv ; Don't check empty variables to see if they are environment variables
SetDefaultMouseSpeed, 0 ; Move mouse instantly

; Changes the tray icon's tooltip (displayed when mouse hovers over it)
Menu, tray, Tip, Hearthstone Hotkeys
; Show Tooltip in the tray that the script is active
TrayTip, Hearthstone Hotkeys, running...,,1

; Makes subsequent hotkeys only function if specified window is active
#IfWinActive Hearthstone ahk_class UnityWndClass 


;; VARIABLES
; Edit if you wish to adjust to your environment ;TODO doesn't work yet
#Persistent
Zone1 := GetAbsolutePixels(0.5, 0.25)
Zone2 := GetAbsolutePixels(0.5, 0.45)
Zone3 := GetAbsolutePixels(0.5, 0.65)
Zone4 := GetAbsolutePixels(0.5, 0.925)
RETURN


;; HOTKEYS
; Edit the keys in front of the :: if you wish to modify hotkeys

^!p::ExitApp

;Testcommand
^T::
Offset := GetAbsolutePixels(0.4800, 0.309)
PixelGetColor, OutputVar, Offset [1], Offset[2], RGB
;msgbox %OutputVar%
Targets := [0]
PlanTurn(Targets)
return
;Testcommand
T::
MouseGetPos, MouseX, MouseY
Offset := GetAbsolutePixels(0.02, 0.07)
Offset := [MouseX + Offset[1], MouseY + Offset[2]]
MouseMove, Offset[1], Offset[2]
return
;Testcommand
M::
Offset := GetAbsolutePixels(0.5200, 0.42)
MouseMove, Offset[1], Offset[2]
return

;start a very simple Bot
^B::
Bot()
return

;select Card or Button with left click
^U::
Unpack()
return

;Leave menu
BS:: ; Backspace
Back()
return

;Choose a Deck via Hotkey
^Numpad1:: ChooseDeck(1)
^Numpad2:: ChooseDeck(2)
^Numpad3:: ChooseDeck(3)
^Numpad4:: ChooseDeck(4)
^Numpad5:: ChooseDeck(5)
^Numpad6:: ChooseDeck(6)
^Numpad7:: ChooseDeck(7)
^Numpad8:: ChooseDeck(8)
^Numpad9:: ChooseDeck(9)

;select Card or Button with left click
^Enter:: ; Ctrl + Enter
^NumpadEnter:: ; Ctrl + Numblock Enter
Select()
return

;move down
^Down::
MoveFreely(false, true)
return
;move up
^Up::
MoveFreely(false, false)
return
;move left
^Left::
MoveFreely(true, true)
return
;move right
^Right::
MoveFreely(true, false)
return

;iterate zone
Up::
IterateZone()
return
;iterate zone
Down::
IterateZone(true)
return
;iterate Cards to the right
Right::
IterateCard()
return
;iterate Cards tothe left
Left::
IterateCard(true)
return

; Mulligan card 1
^1:: ; Ctrl + 1 on keyboard
Mulligan1()
return
; Mulligan card 2
^2:: ; Ctrl + 2 on keyboard
Mulligan2()
return
; Mulligan card 3
^3:: ; Ctrl + 3 on keyboard
Mulligan3()
return
; Mulligan card 4
^4:: ; Ctrl + 4 on keyboard
Mulligan4()
return

; Mulligan all cards
^D:: ; Ctrl + D
MulliganAll()
return

; Pass the turn
MButton:: ; Middle mouse button
^Space:: ; Ctrl + Spacebar
PassTurn()
return

; Target enemy hero
^LButton:: ; Ctrl + Left mouse button
^!Enter:: ; Ctrl + Alt + Enter
^!NumpadEnter:: ; Ctrl + Alt + Numblock Enter
TargetEnemyHero()
return

; Emote "Greetings"
F1:: ; F1 function key on top of the keyboard
Numpad1:: ; 1 on Numpad
NumpadEnd:: ; 1 on Numpad when Numlock is off
Emote(0.42, 0.80)
return

; Emote "Well Played"
F2::
Numpad2::
NumpadDown::
Emote(0.42, 0.72)
return

; Emote "Thanks"
F3::
Numpad3::
NumpadPgDn::
Emote(0.42, 0.64)
return

; Emote "Sorry"
F4::
Numpad4::
NumpadLeft::
Emote(0.58, 0.64)
return

; Emote "Oops"
F5::
Numpad5::
NumpadClear::
Emote(0.58, 0.72)
return

; Emote "Threaten"
F6::
Numpad6::
NumpadRight::
Emote(0.58, 0.80)
return

; Toggle borderless fullscreen window mode
;~ F12::
;~ ToggleFakeFullscreen()
;~ return

; Concede the match
^Esc:: ; Ctrl + Escape
Concede()
return

; Restart the match 
+Esc:: ; Ctrl + Shift + Escape
Restart()
return

; Quit application
^Q:: ; Ctrl + Q
Quit()
return

; Toggle "Sound in Background" option
^m:: ; Ctrl + m
ToggleBackgroundSound()
return

; Attack the opponent's face with all minions able to do so.
^a:: ; Ctrl + a
AttackFaceWithAllMinions()
return

; Attack the opponent's face with all minions able to do so.
; Afterwards, end the turn.
^w:: ; Ctrl + w
Xbutton2:: ; Special mouse button "navigation-forward" 
AttackFaceWithAllMinions(true)
return



;; FUNCTIONS

; Convert relative positions on screen into absolute 
; pixels for AHK commands. Allows for different resolutions.
GetAbsolutePixels(RatioX, RatioY) {
	WinGetPos,,, Width, Height
	AbsoluteX := Round(Width * RatioX)
	AbsoluteY := Round(Height * RatioY)
	return [AbsoluteX, AbsoluteY]
}

; Convert absolute positions on screen into relative
; pixels for AHK commands. Allows for different resolutions.
GetRelPosition(AbsoluteX, AbsoluteY) {
	WinGetPos,,, Width, Height
	RatioX := AbsoluteX / Width
	RatioY := AbsoluteY / Height
	return [RatioX , RatioY]
}

; Open (and wait for) the game menu
OpenMenu() {
	SendInput, {Esc} ; Bring up the menu
	Sleep, 200 ; Wait until it has popped up
}

; Emote takes relative position of emote to click
Emote(EmoteX, EmoteY) {
	BlockInput, On
	; if not in battle, don't click around
	Avatar := GetAbsolutePixels(0.5, 0.775)
	Emote := GetAbsolutePixels(EmoteX, EmoteY)
	MouseGetPos, MouseX, MouseY
	MouseClick, right, Avatar[1], Avatar[2]
	Sleep, 120 ; Wait until bubbles have popped up
	MouseClick, left, Emote[1], Emote[2]
	Sleep, 50
	MouseMove, %MouseX%, %MouseY% Return to original Position
	BlockInput, Off
}

; Presses the "END TURN" button on the right side, if possible
; Tested on following boards: Naxx, griffin, catapult, GvG/Laser
PassTurn() {
	BlockInput, On
	; the area to be searched for the "end turn" button
	EndTurnButton := [0.75, 0.46, 0.95, 0.46]
	MouseGetPos, MouseX, MouseY

	;Green button;MoveToColorInBox(Scanbox, Color, Tolerance = 50, offsetX = 0, offsetY = 0) 
	if (MoveToColorInBox(EndTurnButton, 0x00FF00, 50, 50)) {
		Click
		Click
		MouseMove, %MouseX%, %MouseY%
		BlockInput, Off
		return
	}
	
	; Yellow Button
	if (MoveToColorInBox(EndTurnButton, 0xFFFF00, 50, 50)) {
		Click
		Click
		MouseMove, %MouseX%, %MouseY%
		BlockInput, Off
		return
	}
	
	; Yellow button on Naxx board; the Naxx board is much darker
	if (MoveToColorInBox(EndTurnButton, 0x968B02, 50, 50)) {
		Click
		Click
		MouseMove, %MouseX%, %MouseY%
		BlockInput, Off
		return
	}
	
	BlockInput, Off
	return
}

ClickAndRestoreRel(x, y, speed = 0){
	ToClick := GetAbsolutePixels(x, y)
	ClickAndRestorePos(ToClick[1], ToClick[2], speed)
}

ClickAndRestorePos(x, y, speed = 0) {
	MouseGetPos, MouseX, MouseY
	MouseMove, x, y
	Sleep, 30
	MouseClick, left, x, y, ,speed
	if speed
		Sleep, 1000
	Sleep, 30
	; Seems to work better if we click thrice
;	MouseClick, left, x, y
;	MouseClick, left, x, y
	MouseMove, %MouseX%, %MouseY%
}

; Bring up the menu and click the "Concede" button
Concede() {
	BlockInput, On
	OpenMenu()
	Button := GetAbsolutePixels(0.5, 0.38)
	MouseClick, left, Button[1], Button[2]
	BlockInput, Off
}

; Bring up the menu and click the "Restart" button
Restart() {
	BlockInput, On
	OpenMenu()
	Button := GetAbsolutePixels(0.5, 0.50)
	MouseClick, left, Button[1], Button[2]
	BlockInput, Off
}

; Bring up the menu and click the "Quit" button
Quit() {
	BlockInput, On
	OpenMenu()
	Button := GetAbsolutePixels(0.5, 0.45)
	MouseClick, left, Button[1], Button[2]
	BlockInput, Off
}

; Toggle fullscreen window without border and sreen dimensions
;~ ToggleFakeFullscreen() {
	;~ WinGet, WindowStyle, Style
	;~ if (WindowStyle & +0xC00000) {
		;~ WinMove,,, 25, 2, A_ScreenWidth, A_ScreenHeight
		;~ WinSet, Style, -0xC00000 ; remove title bar
		;~ ; Works best if done twice, no idea why
		;~ WinMove,,, 0, 0, A_ScreenWidth, A_ScreenHeight
		;~ WinSet, Style, -0xC00000
	;~ } else {
		;~ ; Resize slightly smaller than screen, position at the top
		;~ WinMove,,, 25, 2, A_ScreenWidth-50, A_ScreenHeight-50
		;~ WinSet, Style, +0xC00000 ; restore title bar
	;~ }
;~ }

; Go to the options menu and toggle "Sound In Background" option
ToggleBackgroundSound() {
	BlockInput, On
	MouseGetPos, MouseX, MouseY
	OpenMenu()
	OptionsButton := GetAbsolutePixels(0.5, 0.53)
	MouseClick, left, OptionsButton[1], OptionsButton[2]
	Sleep, 200 ; Wait for the menu to pop up
	SoundInBackgroundCheckBox := GetAbsolutePixels(0.56, 0.34)
	MouseClick, left, SoundInBackgroundCheckBox[1], SoundInBackgroundCheckBox[2]
	Sleep, 50
	SendInput, {Esc} ; Exit out of the menus
	Sleep, 100
	SendInput, {Esc}
	MouseMove, %MouseX%, %MouseY%
	BlockInput, Off
}

;Character determined by MousePos returns true if attacked
AttackCharacterWithAll() {
	BlockInput, On
	MinionRow := [0.2, 0.55, 0.9, 0.55]
	HeroRow := [0.5, 0.7, 0.65, 0.7]
	Pixel := [0,0]
	Ground := 0xa46f4c
	attacked := 0

;msgbox Minions should be attacked
	;attack with Minions
	while (FindColorInBox(MinionRow, Pixel, 0x6EFF43, 50)) { 
		ClickAndRestorePos(Pixel[1] + 10, Pixel[2])
		Sleep, 100
		Click
		Sleep, 100
		TargetEnemyHero()
		Sleep, 100
		Click, right
		Sleep, 3500
		attacked := 1
		if(FindColorAtRelOffset([0,0], 1, Ground, 20)) {
			BlockInput, Off
			return attacked
		}
	}

	;attack with Hero
	while (FindColorInBox(HeroRow, Pixel, 0x6EFF43, 50)) { 
		ClickAndRestorePos(Pixel[1] + 10, Pixel[2])
		Sleep, 100
		Click
		Sleep, 100
		TargetEnemyHero()
		Sleep, 100
		Click, right
		Sleep, 1900
		attacked := 1 
		if(FindColorAtRelOffset([0,0], 1, Ground, 20)) {
			BlockInput, Off
			return attacked
		}
	}
	BlockInput, Off
	return attacked
}

AttackAllMinions(Targets) {
	BlockInput, On
	clean := 1
	Loop, 13 {
		if(Targets[A_Index] > 0) {
			clean := 0
		}
	}
	if(!clean) {
		MoveToZone(1, true)
	}
	else {
		return
	}
	
	Loop, 13 {
		if(Mod(Targets[A_Index], 2) == 0 and !(Targets[A_Index] == 0)) {
			MoveToZone(1, true)
			MoveToCard(A_Index)
			if(AttackCharacterWithAll()) {
				Sleep, 3000
				PlanTurn(Targets)
			}
		}
	}
	
	Loop, 13 {
		if(Mod(Targets[A_Index], 2) == 0 and !(Targets[A_Index] == 0)) {
			return
		}
	}
	
	Loop, 13 {
		if(!(Targets[A_Index] == 0)) {
			MoveToZone(1, true)
			MoveToCard(A_Index)
			if(AttackCharacterWithAll()) {
				Sleep, 3000
				PlanTurn(Targets)
			}
		}
	}
	BlockInput, Off
}

AttackFaceWithAllMinions(EndTurnAfterwards=false, Hero= false) {
	BlockInput, On
	MouseGetPos, MouseX, MouseY
	MinionRow := [0.17, 0.55, 0.85, 0.55]
	HeroRow := [0.5, 0.7, 0.65, 0.7]
	Found := [0,0]
	attacked := 0

	; Have to position the mouse so that minions aren't hovered over, changing the color of their active aura
	Rest()
	
	;attack with Minions
	while (MoveToColorInBox(MinionRow, 0x6EFF43, 50, 10)) {
	MouseGetPos, Moused, Mousec
;msgbox attack %Moused%, %Mousec%
		TargetEnemyHero(false)
		Sleep, 1000 ; TODO check necessity
		Rest()
		attacked := 1
	}

	;attack with Hero
	Rest()
	Sleep, 100

	while (MoveToColorInBox(HeroRow, 0x6EFF43, 20, 10) and Hero) {
		TargetEnemyHero(false)
		attacked := 1
		Sleep, 1900
		Rest()
	}

	if (attacked and EndTurnAfterwards) {
		PassTurn()
	}

	MouseMove, MouseX, MouseY
	BlockInput, Off
}

; Drags from current mouse location to enemy hero
TargetEnemyHero(returnToOriginalPos=true) {
	BlockInput, On
	MouseGetPos, MouseX, MouseY
	MouseClick, left, MouseX, MouseY
	Sleep, 100
	SelectEnemyHero()
	if (returnToOriginalPos) {
		MouseMove, %MouseX%, %MouseY%
	}
	BlockInput, Off
	return
}

; Drags from current mouse location to specified enemy minion
TargetEnemyMinion(Position, returnToOriginalPos=true) {
	BlockInput, On
	MouseGetPos, MouseX, MouseY
	MouseClick, left, MouseX, MouseY
	Sleep, 100
	SelectEnemyMinion(Position)
	if (returnToOriginalPos) {
		MouseMove, %MouseX%, %MouseY%
	}
	BlockInput, Off
	return
}

SelectHero() { ;code unreachable/unused
	Hero := GetAbsolutePixels(0.5, 0.8)
	MouseMove, Hero[1], Hero[2], 5
}

SelectEnemyHero() {
	BlockInput, On
	Hero := GetAbsolutePixels(0.5, 0.211)
	MouseMove, Hero[1], Hero[2], 5
	Sleep, 100
	MouseClick, left, Hero[1], Hero[2]
	Sleep, 100
	BlockInput, Off
}

SelectEnemyMinion(Position) {
	BlockInput, On
	MoveToZone(1, true) 
	MoveToCard(Position)
	MouseClick, left, Hero[1], Hero[2]
	Sleep, 100
	BlockInput, Off
}

;used to remove cursor from cards or battlefield
Rest() {
	RestingPos := GetAbsolutePixels(0.3, 0.65)
	MouseMove, RestingPos[1], RestingPos[2]
}

Mulligan1() {
	BlockInput, On
	Button := GetAbsolutePixels(0.3, 0.45)
	MouseClick, left, Button[1], Button[2]
	BlockInput, Off
}

Mulligan2() {
	BlockInput, On
	Button := GetAbsolutePixels(0.45, 0.45)
	MouseClick, left, Button[1], Button[2]
	BlockInput, Off
}

Mulligan3() {
	BlockInput, On
	Button := GetAbsolutePixels(0.625, 0.45)
	MouseClick, left, Button[1], Button[2]
	BlockInput, Off
}

Mulligan4() {
	BlockInput, On
	Button := GetAbsolutePixels(0.75, 0.45)
	MouseClick, left, Button[1], Button[2]
	BlockInput, Off
}

MulliganAll() {
	BlockInput, On 
	Mulligan1()
		Sleep, 100
	Mulligan2()
		Sleep, 100
	Mulligan3()
		Sleep, 100
	Mulligan4()
	Sleep, 100
	Button := GetAbsolutePixels(0.5, 0.75)
	MouseClick, left, Button[1], Button[2]
	BlockInput, Off
}

IterateCard(negate=false) {
	BlockInput, On
	MouseGetPos, MouseX, MouseY
	Zone := GetZone()
	
	LeftEnd := GetAbsolutePixels(0.285,0.38) ; y is for Zone 1 ;cards rightmost and leftmost
	RightEnd := GetAbsolutePixels(0.717,0.38) ; y is for Zone 2 ; (TODO) not yet

	; define margins so that we do not move too far
	if (Zone == 4) {
		LowerMargin := GetAbsolutePixels(0.334, 0.0)
		UpperMargin := GetAbsolutePixels(0.6, 0.0)
		increment := 45
	}
	else if (Zone == 3 or Zone == 0) {
		LowerMargin := GetAbsolutePixels(0.41, 0.0)
		UpperMargin := GetAbsolutePixels(0.59, 0.0)
		increment := 150
	} 
	else if (Zone == 1 or Zone == 2) {
		LowerMargin := GetAbsolutePixels(0.17, 0.0)
		UpperMargin := GetAbsolutePixels(0.85, 0.0)
		increment := (RightEnd[1] - LeftEnd[1]) / 12
	}
	else {
		LowerMargin := GetAbsolutePixels(0.17, 0.0)
		UpperMargin := GetAbsolutePixels(0.85, 0.0)
		increment := 75
	}
	
	if(negate) {
		increment := -1 * increment
	} else {
		increment := increment + 1 ; remove rounding error
	}
	MouseX := MouseX + increment

	;move
	if (MouseX >= UpperMargin[1] and !negate) {
		MouseMove, UpperMargin[1], MouseY, 5
	} else if (MouseX <= LowerMargin[1] and negate){
		MouseMove, LowerMargin[1], MouseY, 5
	} else {
		MouseMove, MouseX, MouseY, 5
	}
	BlockInput, Off
}

MoveToCard(Position, force=false) {
	if(force) {
		IterateZone()
		IterateZone(true) ;center
	}
	count := 7 - Position

	if(Position < 7) {
		Loop, %count% {
			IterateCard(true)		
		}
	} 
	else {
		count := count * -1
		Loop, %count% {
			IterateCard()		
		}
	}
}

IterateZone(negate=false) {
	BlockInput, On
	MouseGetPos, MouseX, MouseY

	Zone0 := GetAbsolutePixels(0.5, 0.1)
	Zone1 := GetAbsolutePixels(0.5, 0.25)
	Zone2 := GetAbsolutePixels(0.5, 0.45)
	Zone3 := GetAbsolutePixels(0.5, 0.65)
	Zone4 := GetAbsolutePixels(0.47, 0.925)
	LowerMargin := GetAbsolutePixels(0.18, 0.0)
	UpperMargin := GetAbsolutePixels(0.82, 0.0)
	MinimumIncrement := 30
	X := Zone0[1]
	
	Zone := GetZone() ; TODO use Zone in every if clause

	;movement between the zones
	if(negate){ ;down
		if (Zone == 3 or Zone == 4) {
			X := Zone4[1]
			MouseY := Zone4[2]
		} 
		if (Zone == 2) { ; in Zone two also visit history
			if (MouseX <= LowerMargin[1]) { ;history
				MouseY := MouseY + MinimumIncrement
				if (MouseY > Zone3[2]) { ;make fluent switch between zones
					MouseY := (Zone3[2] + Zone4[2]) / 2
				} else {
					X := LowerMargin[1]
				}
			}
			else {
				MouseY := (Zone3[2] + Zone4[2]) / 2
			}
		} 
		if (Zone == 1) { ; in Zone one also visit deck and history
			if (MouseX >= UpperMargin[1]) { ;deck 
				X := UpperMargin[1]
			}
			else if (MouseX <= LowerMargin[1]) { ;history
				X := LowerMargin[1]
				MouseY := MouseY + MinimumIncrement
			}
			else {
				MouseY := (Zone2[2] + Zone3[2]) / 2
			}
		} 
		if (Zone == 0) {
			MouseY := (Zone1[2] + Zone2[2]) / 2
		}
		if (MouseY < Zone0[2]) { ;opponent cards
			MouseY := (Zone0[2] + Zone1[2]) / 2
		}
	}
	else {
		if (Zone == 0) {
			MouseMove, Zone0[1], Zone0[2] / 2, 5
			return
		}
		if (Zone == 1) { ; in Zone one also visit history
			if (MouseX <= LowerMargin[1]) { ;history
				MouseY := MouseY - MinimumIncrement
				if (MouseY < Zone1[2]) { ;make fluent switch between zones
					MouseY := (Zone0[2] + Zone1[2]) / 2
				}
				else {
					X := LowerMargin[1]
				}
			}
			else {
				MouseY := (Zone0[2] + Zone1[2]) / 2
			}
		}
		if (Zone == 2) { ; in Zone two also visit deck and history
			if (MouseX >= UpperMargin[1]) { ;deck
				X := UpperMargin[1]
			}
			else if (MouseX <= LowerMargin[1]) { ;history
				X := LowerMargin[1]
				MouseY := MouseY - MinimumIncrement
			}
			else {
				MouseY := (Zone1[2] + Zone2[2]) / 2
			}
		}
		if (Zone == 3) {
			MouseY := (Zone2[2] + Zone3[2]) / 2
		}
		if (Zone == 4) {
			MouseY :=  (Zone3[2] + Zone4[2]) / 2
		}
	}
	MouseMove, X , MouseY, 5
	BlockInput, Off
}

GetZone() {
	MouseGetPos, MouseX, MouseY

	Zone1 := GetAbsolutePixels(0.5, 0.25)
	Zone2 := GetAbsolutePixels(0.5, 0.45)
	Zone3 := GetAbsolutePixels(0.5, 0.65)
	Zone4 := GetAbsolutePixels(0.47, 0.925)

	if (MouseY >= Zone4[2]) {
		return 4
	}
	if (MouseY >= Zone3[2]) {
		return 3
	}
	if (MouseY >= Zone2[2]) {
		return 2
	}
	if (MouseY >= Zone1[2]) {
		return 1
	}
	return 0
}

MoveToZone(TargetZone, force = false) {
	CurrentZone := GetZone()
	if(CurrentZone == TargetZone and force) {
		IterateZone()
		IterateZone(true)
	}
	if (CurrentZone == TargetZone) {
		return
	}
	else if (CurrentZone > TargetZone) {
		IterateZone()
		MoveToZone(TargetZone)
		sleep, 50
		return
	}
	else if (CurrentZone < TargetZone) {
		IterateZone(true)
		MoveToZone(TargetZone)
		sleep, 50
		return
	}
}

Select() {
	MouseGetPos, MouseX, MouseY
	MouseClick, left, MouseX, MouseY
}

GoToCards() { ;Code not usable 
	global Zone4
	MouseMove, Zone4[1], Zone4[2]
}

MoveFreely(horizontal, negate) {
	MouseGetPos, MouseX, MouseY
	increment := 40
	
	if(negate) {
		increment := -1 * increment
	}
	if(horizontal) {
		MouseX := MouseX + increment
	} else {
		MouseY := MouseY - increment
	}

	MouseMove, MouseX, MouseY, 5
}

ChooseDeck(int) {
	upperRow := 0.27
	middleRow := 0.47
	lowerRow := 0.67
	rightCol := 0.5
	middleCol := 0.37
	leftCol := 0.25
	ChooseButton := GetAbsolutePixels(0.72, 0.8)
	
	if(int ==1) {
		Deck := GetAbsolutePixels(leftCol, lowerRow )
	}if(int == 2) {
		Deck := GetAbsolutePixels(middleCol, lowerRow )
	}if(int == 3) {
		Deck := GetAbsolutePixels(rightCol, lowerRow )
	}if(int == 4) {
		Deck := GetAbsolutePixels(leftCol, middleRow)
	}if(int == 5) {
		Deck := GetAbsolutePixels(middleCol, middleRow)
	}if(int == 6) {
		Deck := GetAbsolutePixels(rightCol, middleRow)
	}if(int == 7) {
		Deck := GetAbsolutePixels(leftCol, upperRow )
	}if(int == 8) {
		Deck := GetAbsolutePixels(middleCol, upperRow )
	}if(int == 9) {
		Deck := GetAbsolutePixels(rightCol, upperRow )
	}
	MouseMove, Deck[1], Deck[2], 5	
	MouseClick, left, Deck[1], Deck[2]
	Sleep, 100
	MouseMove, ChooseButton[1], ChooseButton[2], 5	
	MouseClick, left, ChooseButton[1], ChooseButton[2]
}

Back() { ;TODO detect Arena and leave it - Push Button without moving mouse
	SendInput, {Esc}
	SendInput, {Esc}
	ChooseButton := GetAbsolutePixels(0.82, 0.92)
;	ControlClick , _ , Hearthstone,,,, NA ;x1312 y828 absolute coordinates don't work
	MouseClick, left, ChooseButton[1], ChooseButton[2]
}

Unpack(duration = 1000) {
	InputBox, times, Packopener , Insert number of packs to be opened. ,,,,,,,,1

	Pack := GetAbsolutePixels(0.2, 0.15)
	CardTopLeft := GetAbsolutePixels(0.45, 0.3)
	CardTopMiddle := GetAbsolutePixels(0.55, 0.25)
	CardTopRight := GetAbsolutePixels(0.75, 0.3)
	CardBottomLeft := GetAbsolutePixels(0.5, 0.7)
	CardBottomRight := GetAbsolutePixels(0.7, 0.7)
	ChooseButton := GetAbsolutePixels(0.55, 0.5)

	Loop %times% {
		if (!WinActive(Hearthstone)) break
		MouseClickDrag, left, Pack[1], Pack[2], ChooseButton[1], ChooseButton[2], 2
		Sleep, duration / 10
		MouseClick, left, CardTopLeft[1], CardTopLeft[2]
		Sleep, duration / 10
		MouseClick, left, CardTopMiddle[1], CardTopMiddle[2]
		Sleep, duration / 10
		MouseClick, left, CardTopRight[1], CardTopRight[2]
		Sleep, duration / 10
		MouseClick, left, CardBottomRight[1], CardBottomRight[2]
		Sleep, duration / 10
		MouseClick, left, CardBottomLeft[1], CardBottomLeft[2]
		Sleep, duration / 10
		MouseClick, left, ChooseButton[1], ChooseButton[2]
		Sleep, duration / 10
	}
}

StartGame() {
	; Choose A Deck if in Selectionmenu
	; Blue button
	ChooseButton := [0.73, 0.803]
	Jaina := 0.12
	Thrall := 0.3
	if (FindColorAtPoint(ChooseButton, 15, 0x2f67ff, 20)) {
		ChooseDeck(1)
		Sleep, 250
		ClickAndRestoreRel(0.75, Thrall) ; Case of Training ;adjust for certain opponent
		Sleep, 10
		Click
		Sleep, 30000
	}

		Sleep, 250
	;mulligan cards if window and selection active
	ChooseButton := [0.5, 0.8]

	;MouseMove, ChooseButton[1], ChooseButton[2]
	if (WinActive(Hearthstone) and FindColorAtPoint(ChooseButton, 5, 7fc4ff, 20)) { ; 
		MulliganAll()
		Sleep, 10000
		Emote(0.42, 0.80)
	}
}

Bot() {
	BlockInput, On
	
	StartGame() 

	EndTurnButton := [0.75, 0.46, 0.95, 0.46]
	FoundYellow := [0,0]
	FoundGreen := [0,0]
	FoundYellowNaxx := [0,0]

	while (WinActive(Hearthstone)) 
	{
		FindColorInBox(EndTurnButton, FoundGreen, 0x00FF00, 50)
		FindColorInBox(EndTurnButton, FoundYellow, 0xFFFF00, 50)
		FindColorInBox(EndTurnButton, FoundYellowNaxx, 0x968B02, 20)
		Sleep, 1250 ; wait for new card to arrive to hand

		if (FoundYellowNaxx[1] or FoundYellow[1] or FoundGreen[1]) 
		{
			Targets := [0]
			PlanTurn(Targets)
			DoTurn(Targets)
			PassTurn()
			Sleep, 2500 ; Do not start next turn early! Please! :D
		}
		StartGame() ;only triggers in menu(hopefully) 
	}
	BlockInput, Off
}

DoTurn(Targets) { 
	PlayAllCards(Targets)
;	Sleep, 2000 ;some minions do have nasty effects that cover the board when summoned
	PlanTurn(Targets)

	Rest()
	AttackAllMinions(Targets)
	PlayAllCards(Targets)
;	Sleep, 2000

	Rest()
	AttackFaceWithAllMinions(,true)
	PlayAllCards()
;	Sleep, 2000
}

PlayAllCards(Targets := 0) {
	Hand := [0.3, 0.98, 0.7, 1]
	FoundYellow := [0,0]
	FoundGreen := [0,0]

;Gand := GetAbsolutePixels(Hand[1], Hand[2])
;MouseMove, Gand[1], Gand[2]
;Sleep, 10000
	
	if (Zone == 4) {
		IterateZone() ;definetely leave hand
		Sleep, 200 ; card takes time to shrink
	}

	;Play Cards
	while (FindColorInBox(Hand, FoundGreen, 0x50ff34, 30) or FindColorInBox(Hand, FoundYellow, 0x50FF00, 20)) ;TODO 0xFFFF00 finds golden and corehound
	{
		if (FoundYellow[1] > 0) {
			MouseMove, FoundYellow[1] + 5, FoundYellow[2]
		}
		else {
			MouseMove, FoundGreen[1] + 5, FoundGreen[2]
		}
		Sleep, 100
		if(Targets != 0) {
			flag := 0
			Loop, 13 {
				if (Targets[A_Index] > 0) { 
					TargetEnemyMinion(A_Index)
					flag :=  1
					break
				}
			}
			if(!flag) {
				TargetEnemyHero()
			}
		}
		else { 
			TargetEnemyHero()
		}

		Zone := GetZone()
		if (Zone == 4)
		{
			IterateZone() ;definetely leave hand
			Sleep, 200 ; card takes time to shrink
		}
	}
}

MoveToColorInBox(Scanbox, Color, Tolerance = 50, offsetX = 0, offsetY = 0) {
	Pixel := [0,0]
	if (FindColorInBox(Scanbox, Pixel, Color, Tolerance)) {
		MouseMove, Pixel[1] + offsetX, Pixel[2] + offsetY
		return 1
	}
	else
		return 0
}

;recieves Area as array with relative borders of the area to search in and returns found absolute pixel in Pixel
FindColorInBox(Scanbox, Pixel, Color, Tolerance = 50) {
	TopLeft := GetAbsolutePixels(Scanbox[1], Scanbox[2])
	BottomRight := GetAbsolutePixels(Scanbox[3], Scanbox[4])

	if (TopLeft[2] == BottomRight[2]) {
		BottomRight[2] := BottomRight[2] + 1
	}
	if (TopLeft[1] == BottomRight[1]) {
		BottomRight[2] := BottomRight[2] + 1
	}

	PixelSearch, FoundColorX, FoundColorY, TopLeft[1], TopLeft[2], BottomRight[1], BottomRight[2], Color, Tolerance, Fast RGB

var := Scanbox[1]
vars := Scanbox[2]
var1 := Scanbox[3]
vars2 := Scanbox[4]
vart := TopLeft [1]
varst := BottomRight[1]
;msgbox Color %Color% Ort %FoundColorX% : %FoundColorY% . %var%, %vars%, %var1%, %vars2%, leftright %vart%, %varst%

	if (FoundColorX) {
		Pixel[1] := FoundColorX
		Pixel[2] := FoundColorY		
		return 1
	}
	else { 
		Pixel.remove(2)
		Pixel.remove(1)
		return 0
	}
}

; recieves relative position to search at in Center and returns found pixel in Center as absolute pixel
FindColorAtPoint(Center, ScanDistance, Color, Tolerance = 50) {
	Pixel := GetAbsolutePixels(Center[1], Center[2])

	PixelSearch, FoundColorX, FoundColorY, Pixel[1] - ScanDistance, Pixel[2] - ScanDistance, Pixel[1] + ScanDistance, Pixel[2] - ScanDistance, Color, Tolerance, Fast RGB

var := Center[1]
vars := Center[2]
;msgbox Color %Color% with Tolerance: %Tolerance% at %FoundColorX% : %FoundColorY% . Center: %var% : %vars% including "radius" %ScanDistance%
	if (FoundColorX) {
		Center[1] := FoundColorX
		Center[2] := FoundColorY
;MouseMove, Center[1], Center[2]
		return 1
	}
	else { ;msgbox nothing found at pixel
		Pixel.remove(2)
		Pixel.remove(1)
		return 0
	}
}

; recieves relative Position relative to mouse curser to search at in Center and returns found absolute pixel in Pixel ;TODO write method that does the same for a recieved Position instead of MousePos
FindColorAtRelOffset(Offset, ScanDistance, Color, Tolerance = 50, Pixel = 0) {
	MouseGetPos, MouseX, MouseY
	Mouse := GetRelPosition(MouseX, MouseY)
	Offset := [Mouse[1] + Offset[1], Mouse[2] + Offset[2]]
var := Offset[1]
vars := Offset[2]
;msgbox Color %Color% Ort %var%, %vars%
	if (FindColorAtPoint(Offset, ScanDistance, Color, Tolerance)) {
		Pixel[1] := Offset[1]
		Pixel[2] := Offset[2]
		return 1
	}
}

PlanTurn(Targets) {
	MinionRow := [0.17, 0.55, 0.85, 0.55]
	HeroRow := [0.5, 0.7, 0.65, 0.7]
	Hand := [0.3, 0.98, 0.7, 1]
	if(FindColorInBox(MinionRow, FoundGreen, 0x00FF00, 50) or FindColorInBox(HeroRow, FoundGreen, 0x00FF00, 50) or FindColorInBox(Hand, FoundGreen, 0x00FF00, 50)) {
		FindOpponentMinions(Targets)
		DetectTaunt(Targets)
	T1 := Targets[1]
	T2 := Targets[2]
	T3 := Targets[3]
	T4 := Targets[4]
	T5 := Targets[5]
	T6 := Targets[6]
	T7 := Targets[7]
	T8 := Targets[8]
	T9 := Targets[9]
	T10 := Targets[10]
	T11 := Targets[11]
	T12 := Targets[12]
	T13 := Targets[13]
;msgbox print %T1%, %T2%, %T3%, %T4%, %T5%, %T6%, %T7%, %T8%, %T9%, %T10%, %T11%, %T12%, %T13% 
	}
}

; possible positioning in 13 positions: oe0eoeOeoe0eo - "e" for even count "o" for odd count ;TODO golden
; array Targets will contain 1 if respective position is occupied ; TODO measure minion and use this to define Offset
FindOpponentMinions(Targets) {
	;CheckPoint := [-0.02, -0.055] ; fots for Zone2
	;CheckPoint := [0.02, 0.071] ; old for white border [-0.02, -0.025]
	;Red := 0xff0000 ; 0x80251c ; somewhere in blood drop 0xcc2a23
	;RedTol := 0
	;White := 0xFFFFFF 
	;WhiteTol := 50
	;Green := 0x00ff00
	;GreenTol := 0
	Offset := [-0.012, 0.085] ;[0, -0.043] ; [0, 0.11]
	GrayGods := 0x50485f 
	Gray := 0x544b47 ;0x947e9c ;0x978d7f ; 0x282929 ;0x9c8d83 ;0x9f8b7c ;0x5b5552 ;leftbottom (Pixel: 783, 392) 5a5551 4e423d 50485f
	GodsTolerance := 5
	Tolerance := 20
	Distance := 1
	Pixel := [1,1]

	Loop, 13 {
		Targets[A_Index] := 0
	}

	MoveToZone(1, true)
	sleep 50

MouseGetPos, MouseX, MouseY
LeftEnd := GetAbsolutePixels(Offset[1], Offset[2])
MouseX := LeftEnd[1] + MouseX
MouseY := LeftEnd[2] + MouseY
var := Offset[1]
vars := Offset[2]
;msgbox Found Pixel: %var% %vars% Berechnetes Suchziel: %MouseX% %MouseY%
;MouseMove, MouseX, MouseY
;sleep 5000
	
	;if(FindColorAtRelOffset(CheckPoint, Distance, Red, RedTol, Pixel) or FindColorAtRelOffset(CheckPoint, Distance, White, WhiteTol, Pixel) or FindColorAtRelOffset(CheckPoint, Distance, Green, GreenTol, Pixel)) {
	if(FindColorAtRelOffset(Offset, Distance, Gray, Tolerance, Pixel)) {
		odd := 1
	} 
	else {
		odd := 0 ; 0 cards in field is also even
		IterateCard(true) ; goto even
	}
	
	if(!odd and !(FindColorAtRelOffset(Offset, Distance, Gray, Tolerance, Pixel))) {
		return
	}

;TODO nonminion cards could be a problem since the loop ends
	while(FindColorAtRelOffset(Offset, Distance, Gray, Tolerance, Pixel)) {
		IterateCard(true)
		IterateCard(true)
		CardsMovedLeft := A_Index

MouseGetPos, MouseX, MouseY
LeftEnd := GetAbsolutePixels(CheckPoint[1], Checkpoint[2])
MouseX := LeftEnd[1] + MouseX
MouseY := LeftEnd[2] + MouseY
var := Pixel[1]
vars := Pixel[2]
;msgbox Found Pixel: %var% %vars% Berechnetes Suchziel: %MouseX% %MouseY%
;ClickAndRestorePos(Pixel[1], Pixel[2], 100)

	}
	
	Unoccupied := 7 - (CardsMovedLeft * 2 - odd)
	IterateCard()
	IterateCard()
	
;TODO nonminion cards could be a problem since the loop ends
	while(FindColorAtRelOffset(Offset, Distance, Gray, Tolerance, Pixel)) {
		Targets[A_Index * 2 + Unoccupied - 1] := 1
		Filled := A_Index
		if((A_Index * 2 + Unoccupied) >= 14) {
			return
		}
		Targets[A_Index * 2 + Unoccupied] := 0
		IterateCard()
		IterateCard()
	}
}

DetectTaunt(Targets){ ; 5b5958 mr 535353 mr 545351 m 595756 m 595a5c m 3d373b mr ;unten 6c6f70 ;TODO make it work for golden
	BlockInput, On
	UnoccupiedLeft := 0
	UnoccupiedRight := 0
	Pixel := 0
	Offset := [0, 0.12] ; old top left [-0.02500, -0.038]

	while(Targets[14 - A_Index] == 0) {
		UnoccupiedRight := A_Index
	}
	if(UnoccupiedRight >= 13)
		return ; There is nothing to see here.
	while(Targets[A_Index] == 0) {
		UnoccupiedLeft := A_Index
	}
	count := 13 - UnoccupiedLeft - UnoccupiedRight
	MoveToCard(UnoccupiedLeft + 1, true)
	
	Loop, %count% {
		if(Targets[A_Index + UnoccupiedLeft] > 0) { 
			;if ((FindColorAtRelOffset(Offset, 8, 0x6c6f70, 20, Pixel) or FindColorAtRelOffset(Offset, 8, 0x506944, 20, Pixel)) and (Mod(Targets[A_Index + UnoccupiedLeft], 2) != 0)) {
			if (FindColorAtRelOffset(Offset, 8, 0x5E6C5A, 29, Pixel) and (Mod(Targets[A_Index + UnoccupiedLeft], 2) != 0)) {
				Targets[A_Index + UnoccupiedLeft] :=  Targets[A_Index + UnoccupiedLeft] * 2
			}

MouseGetPos, MX, MY
;msgbox Mouse %MX%, %MY%
LeftEnd := GetAbsolutePixels(Offset[1], Offset[2])
MX := LeftEnd[1] + MX
MY := LeftEnd[2] + MY
;msgbox Searchpoint %MX%, %MY%
;ClickAndRestorePos(MX, MY, 100)

		}
		if(A_Index < (13 - UnoccupiedLeft - UnoccupiedRight)) {
			IterateCard()
			Sleep, 50
		}
	}
	BlockInput, Off
}