/* 
This is used for custom application code and allows sites to load site specific code 
Written for the VA508 Script project
Original scripts by: CBell
Updated: May, 2014 by Chris Bell
*/

use "VA508JAWS.jsb"

/***************************************************************
To add site specific code, Follow the instructions in file name 
VA508JAWS_SiteCode.jss. 
Remove the ";" from the line below to ensure Site Specific code 
is used.
***************************************************************/
;	Use "VA508JAWS_SiteCode.jss"

; constants are differentiated by underscores between words
Const	
; Not used by any code in this file, but read by JAWS.SR from this file to determine if the script file should be updated with a newer version
	VA508_Script_Version = 2

void Function _Filler()
; function needed here to force JAWS to load VA508JAWS script
EndFunction


/***************************************************************
Below is the Application specific code (Code written by SRS)
***************************************************************/

	include "hjconst.jsh"
	include "winstyles.jsh"

	const WC_CAPTION_LISTBOX = "TCaptionListBox"

MESSAGES
@msgLeaveTextBox 
Use control-tab or control-sshift-tab to leave this edit box.
@@

@msgHotKey
Here are some JAWS hot keys for use with CPRS:
description  hot key
Screen Sensitive Help   %keyfor(ScreenSensitiveHelp)
Speak chart tab and Patient name  %keyfor(VA508SendCustomCommand(3))
Switch Tab or exit rich edit box  %keyfor(VA508SendCustomCommand(1))
Reverse switch Tab or exit rich edit box  %keyfor(VA508SendCustomCommand(2))


In lists:
Click Cell: %keyfor(ltLeftClickCell)
Sort column  %keyfor(ltLeftClickHeader)

In tree views:
Edit item  %keyfor(f2editTreeNode)

Press escape to close this window
@@

EndMessages 

GLOBALS
	handle gprevFocus 

void Function _Filler()
; function needed here to force JAWS to load VA508JAWS script
EndFunction

; Add Custom Scripts Here




Int Function HandleCustomWindows (handle hFocus)
var 
	handle hReal,
	string sRealName,
	handle hwnd,
	string 	sClass,
	string sName,
	int isSameWindow
hReal = GetRealWindow (GetFocus())
sRealName = GetWindowName (hReal)
isSameWindow = hFocus == gprevFocus 
gprevFocus  = hFocus 
if sRealName == "Discharge Summary Properties" && GetWindowTypeCode (hFocus)   == WT_BUTTON then
	hwnd = GetNextWindow(FindWindow (hReal, "TStaticText")) ; third argument is window name.
	sClass =  GetWindowClass (hwnd)
	sName = GetWindowName(hwnd)
	if ( sClass == "TStaticText" ) then 
		SayMessage (OT_HELP, sName, "")
	endif 
elif  ((GetWindowClass (hFocus) == "TRichEdit"
       || GetWindowClass (hFocus) == "TMemo" 
       || GetWindowClass (hFocus) == "tCaptionMemo" ) 
     && (GetWindowStyleBits (hFocus) & ES_READONLY )) THEN
	Say (GetWindowText (hFocus, false), OT_SCREEN_MESSAGE )
	 return true
elif (GetWindowClass (hFocus) == "TCPRSDialogRichEdit" ) then ; Don't process the same window again.
	if  isSameWindow  then 
		return true
	EndIf
endif

return VA508JAWS::HandleCustomWindows( hFocus) 
EndFunction


string function GetCustomTutorMessage()
var 
	handle hFocus,
	string sClass 

hFocus = GetCurrentWindow ()
sClass = GetWindowClass (hFocus) 

if  sClass == "TRichEdit" 
&& ( ! GetWindowStyleBits (hFocus) & ES_READONLY ) Then  

		return msgLeaveTextBox  
	elif  sClass == "TStatusBar" Then
	return"Click Insert-PageDown at any time to read this status."
elif   sClass == "TCPRSDialogRichEdit" then
	return(" ")
EndIf
return GetCustomTutorMessage() ; call default 
endfunction

Script HotKeyHelp ()
if UserBufferIsActive () Then
	UserBufferDeactivate ()
EndIf
SayFormattedMessage (OT_USER_BUFFER, msgHotKey
)

EndScript

Script EnterKey ()
var
	int hItem,
	handle hWnd

sayCurrentScriptKeyLabel()
let hwnd = getFocus()
if getWindowClass(hWnd) == WC_CAPTION_LISTBOX then
	saveCursor()  JAWSCursor()  saveCursor()
	routeJAWSToPC()
	leftMouseButton()
	LeftMouseButton ()
	return
endIf
typeCurrentScriptKey() ; Pass key to application 
EndScript
