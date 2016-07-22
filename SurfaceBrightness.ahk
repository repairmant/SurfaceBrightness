#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; https://autohotkey.com/docs/KeyList.htm
;http://edgylogic.com/projects/display-brightness-vista-gadget/
UPcount = 0
DNcount = 0
UPcountB4 = 0
DNcountB4 = 0
HIGHEST = false
LOWEST = false
ScreenLevel := ComObjCreate("WScript.Shell").Exec("brightness.exe").StdOut.ReadAll()
bright = 1
GetKeyState, VolUPstate, Volume_Up, P
GetKeyState, VolDNstate, Volume_Down, P
Gui, DisplayCounters: New
Gui, Add, Text, w200 vText1, %UPcount% %DNcount%
Gui, Add, Text, w200 vText2, %VolUPstate% %VolDNstate%
Gui, Add, Text, w200 vText3, %UPcountB4% %DNcountB4%
Gui, Add, Text, w200 vText4, %ScreenLevel%
Gui, Add, Button, x5 y110 h20 w70 gexit Default, EXIT
Gui, Show, w200 h135, Key Test  ; Show Gui

Loop
{
    Sleep, 10
    GetKeyState, VolUPstate, Volume_Up, P
	GuiControl,, Text2, %VolUPstate% %VolDNstate%
	if VolUPstate = U ; The key has been released
    {
		if UPcount >=1
		{
			UPcountB4 = %UPcount%
			UPcount := 0
			GuiControl,, Text3, %UPcountB4% %DNcountB4%
			GuiControl,, Text1, %UPcount% %DNcount%
			if brightchange >= 1
			{
				;ScreenLevel := ComObjCreate("WScript.Shell").Exec("brightness.exe").StdOut.ReadAll(),, hide
				GuiControl,, Text4, %ScreenLevel%
				HIGHEST = false
			}
		}
	}
	if VolDNstate = U ; The key has been released
    {
		if DNcount >=1
		{
			UPcountB4 = %DNcount%
			DNcount := 0
			GuiControl,, Text3, %UPcountB4% %DNcountB4%
			GuiControl,, Text1, %UPcount% %DNcount%
			if brightchange >= 1
			{
				;ScreenLevel := ComObjCreate("WScript.Shell").Exec("brightness.exe").StdOut.ReadAll(),, hide
				GuiControl,, Text4, %ScreenLevel%
				LOWEST = false
			}
		}

	}
	brightchange := 0
	if VolUPstate = D  ; The key has been depressed
	{
		SoundGet, start_volume ;get volume percent
		start_volume -= 2 ;adjust for offset
	}
	while GetKeyState("Volume_Up")
    { ; The key has been depressed
		; SCXXX::Volume_Up
		UPcount++
		GuiControl,, Text1, %UPcount% %DNcount%
		if UPcount >40
		{
			UPcount -= 30
			GuiControl,, Text1, %UPcount% %DNcount%
			if HIGHEST = false
			{
				if ScreenLevel between 1 and 8
				{
					Run "brightness.exe"-data "9",,hide
					ScreenLevel = 9
					GuiControl,, Text4, %ScreenLevel%
					Sleep, 30
				}
				if ScreenLevel between 9 and 50
				{
					Run "brightness.exe"-data "54",,hide
					ScreenLevel = 54
					GuiControl,, Text4, %ScreenLevel%
					Sleep, 30
				}
				if ScreenLevel between 51 and 75
				{
					Run "brightness.exe"-data "100",,hide
					ScreenLevel = 100
					GuiControl,, Text4, %ScreenLevel%
					Sleep, 30
				}
				if ScreenLevel between 76 and 100
				{
					TrayTip Brightness, Brightness is Maxed
					HIGHEST = true
					Sleep, 30
				}
			}
			brightchange++
			GuiControl,, Text4, %ScreenLevel%
		}
		if brightchange >= 1
			SoundSet, %start_volume%
		Sleep, 10
	}
	;######################################################
	if VolDNstate = D  ; The key has been depressed
	{
		SoundGet, start_volume ;get volume percent
		start_volume += 2 ;adjust for offset
	}
	while GetKeyState("Volume_Down")
    { ; The key has been depressed
		; SCXXX::Volume_Down
		DNcount++
		GuiControl,, Text1, %UPcount% %DNcount%
		if DNcount >40
		{
			DNcount -= 30
			GuiControl,, Text1, %UPcount% %DNcount%
			if LOWEST = false
			{
				if ScreenLevel between 1 and 8
				{
					TrayTip Brightness, Brightness is at the lowest
					LOWEST = true
					Sleep, 30
				}
				if ScreenLevel between 9 and 50
				{
					Run "brightness.exe"-data "1",,hide
					ScreenLevel = 1
					GuiControl,, Text4, %ScreenLevel%
					Sleep, 30
				}
				if ScreenLevel between 51 and 75
				{
					Run "brightness.exe"-data "9",,hide
					ScreenLevel = 9
					GuiControl,, Text4, %ScreenLevel%
					Sleep, 30
				}
				if ScreenLevel between 76 and 100
				{
					Run "brightness.exe"-data "54",,hide
					ScreenLevel = 54
					GuiControl,, Text4, %ScreenLevel%
					Sleep, 30
				}
			}
			brightchange++
			GuiControl,, Text4, %ScreenLevel%
		}
		if brightchange >= 1
			SoundSet, %start_volume%
		Sleep, 10
	}
	SoundGet, end_volume ;get volume percent
}

guiclose:
exit:
 {
   exitapp
 }
return