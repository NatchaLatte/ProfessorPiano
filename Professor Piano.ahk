Delay=250
Gui, Add, Text, , Setting Delay (Press PageUp Add Delay 50 and Press PageDown Sub Delay 50)
Gui, Add, Edit, w480
Gui, Add, UpDown, vSettingDelay Range-1-1000000,%Delay%
Gui, Add, Text, , TIP: Delay 1000 equals 1 second.
Gui, Add, Text, , Sheet music
Gui, Add, Edit, w480 h280 vSheetMusic, %SheetMusicDefault%
Gui, Add, Button, Default w80 gImportSheetMusic section, Import...
Gui, Add, StatusBar, , Stopping... Press F6 Start
Gui Show, w500 h450, Professor Piano - By Namida Kitsune
Toggle:=0
F6::
{
    if(Toggle == 0)
    {
        Toggle:=1
		SoundBeep
        SB_SetText("Running... Press Ctrl+F6 Stop")
		Gui, Submit, Nohide
		SheetMusic := StrReplace(SheetMusic, "`n")
		SheetMusic := StrReplace(SheetMusic, "`r")
		SheetMusic := StrReplace(SheetMusic, "/")
		SheetMusic := StrReplace(SheetMusic, "|")
		SheetMusic := StrReplace(SheetMusic,  "!", "{!}")
		SheetMusic := StrReplace(SheetMusic,  "^", "{^}")
    }

	if(Toggle == 1){
		Array := StrSplit(SheetMusic, "]")
		LastSheetMusic := Array.pop()
		ArrayLastSheetMusic := StrSplit(LastSheetMusic, "")
		LastSheetMusic := ""
		for index, element in ArrayLastSheetMusic
		{
			LastSheetMusic = %LastSheetMusic% %element%
		}
		stats := 0
		text := ""
		for index, element in Array
		{
			Loop, Parse, element, % "["
			{
				tempSheetMusic := A_LoopField
				if(stats == 0){
					stats := 1
					ArrayTempSheetMusic := StrSplit(tempSheetMusic, "")
					for indexArrayTempSheetMusic, elementArrayTempSheetMusic in ArrayTempSheetMusic
					{
						text = %text% %elementArrayTempSheetMusic%
					}
				}else{
					stats := 0
					text = %text% %tempSheetMusic%
				}
			}
		}
		text = %text% %LastSheetMusic%
		ArrayTwo := StrSplit(text, " ")
		for index, element in ArrayTwo
		{
			if(Toggle == 1)
			{
				Sleep %SettingDelay%
				SendInput % element
			}
		}
		Toggle:=0
		SoundBeep
		SB_SetText("Stopping... Press F6 Start")
	}
	return
}
^F6::
{
	Toggle:=0
	SoundBeep
	SB_SetText("Stopping... Press F6 Start")
	return
}

PgUp::
{
	Delay:=Delay+50
	SoundBeep
	GuiControl, , SettingDelay,%Delay%
	Gui, Submit, Nohide
	return
}
PgDn::
{
	Delay:=Delay-50
	SoundBeep
	GuiControl, , SettingDelay,%Delay%
	Gui, Submit, Nohide
	return
}

ImportSheetMusic:
	FileSelectFile, SelectedFileSheetMusic, 3, , Open, Text Documents (*.txt)
	FileRead, FileSheetMusic, %SelectedFileSheetMusic%
	GuiControl, , SheetMusic,%FileSheetMusic%
return
GuiEscape:
GuiClose:
    ExitApp