#include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include "..\UWPOCR.au3"


_Example()

Func _Example()

	#Region - create example bitmap	- take a screenshot
	_GDIPlus_Startup()
	;hImage/hBitmap GDI
	Local $hTimer = TimerInit()
	Local $hHBitmap = _ScreenCapture_Capture("", 0, 0, @DesktopWidth / 2, @DesktopHeight / 2, False)
	Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
	#EndRegion - create example bitmap	- take a screenshot

	#Region - do the OCR Stuff
	;Get OCR Text From hImage/hBitmap
;~ 	_UWPOCR_Log(__UWPOCR_Log) ;Enable Log
	Local $sOCRTextResult = _UWPOCR_GetText($hBitmap, Default, True)
	MsgBox(0, "Time Elapsed: " & TimerDiff($hTimer), $sOCRTextResult)
	#EndRegion - do the OCR Stuff

	#Region - bitmap clean up
	_WinAPI_DeleteObject($hHBitmap)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()
	#EndRegion - bitmap clean up

EndFunc   ;==>_Example
