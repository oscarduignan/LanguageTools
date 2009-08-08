; -----------------------------------------
; Definition, Translation and Accent Cycling Hot Keys
; by Oscar Duignan <oscarduignan@gmail.com>
; -----------------------------------------

; Only one instance required
#SingleInstance force
#NoEnv

; -----------------------------------------
; Read settings file
; -----------------------------------------
Loop, read, settings.cfg
{
  NextLine = %A_LoopReadLine%
  LineLength := StrLen(NextLine)  
  if LineLength > 0
  {  
    SemiColonPos := InStr(NextLine,";")
    if SemiColonPos <> 1 
    {
      StringSplit, VAR,NextLine,"="
      %VAR1% = %VAR2%
    }
  }
}

StringReplace, ACCENT_TRANSFORMATIONS, ACCENT_TRANSFORMATIONS, %A_SPACE%, , All

; -----------------------------------------
; Set up the appropriate hot keys
; -----------------------------------------
HotKey, %DICTIONARY_HOTKEY%, Define, On
HotKey, %TRANSLATE_HOTKEY%, Translate, On
HotKey, %ACCENT_HOTKEY%, Cycle_Accents, On

exit

; -----------------------------------------
; Lookup selected text using dictionary.com
; -----------------------------------------
Define:
    clipboardBackup := clipboard
    SendPlay ^c
    ClipWait
    Run http://dictionary.reference.com/browse/%clipboard%
    clipboard := clipboardBackup
Return

; -----------------------------------------
; Lookup selected text using google translate
; -----------------------------------------
Translate:
    clipboardBackup := clipboard
    SendPlay ^c
    ClipWait
    Run http://translate.google.com/translate_t#%TRANSLATE_FROM%|%TRANSLATE_TO%|%clipboard%
    clipboard := clipboardBackup
Return

; -----------------------------------------
; Cycle through the accents for the character to the left of the text cursor
; -----------------------------------------
Cycle_Accents:
    clipboardBackup := clipboard
    clipboard := ""

    SendPlay +{Left}^c
    ClipWait

    charPosition := InStr(ACCENT_TRANSFORMATIONS,clipboard,true)

    if charPosition > 0
    {
        charPosition++
        nextChar := SubStr(ACCENT_TRANSFORMATIONS,charPosition,1)
        SendPlay {Raw}%nextChar%
    } else {
        SendPlay {Right}
    }
    
    clipboard := clipboardBackup
Return
