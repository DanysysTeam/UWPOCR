#include <GDIPlus.au3>
#include "..\UWPOCR.au3"


_Example()

Func _Example()

	#Region - create test JPG file
	_GDIPlus_Startup()
	;Create Temp Image File
	Local $sImageFilePath = @ScriptDir & "\SampleImage.jpg"
	Local $sText = "Hello World!!!" & @CRLF & "AutoIt Rocks" & @CRLF & "0123456789" & @CRLF & "WPUOCR UDF"
	Local Const $iW = 500, $iH = 500
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iW, $iH) ;create an empty bitmap
	Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap) ;get the graphics context of the bitmap
	_GDIPlus_GraphicsSetSmoothingMode($hBmpCtxt, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
	_GDIPlus_GraphicsClear($hBmpCtxt, 0xFFFFFFFF) ;clear bitmap with color white

	_GDIPlus_GraphicsDrawString($hBmpCtxt, $sText, 0, 0, "Comic Sans MS", 52)  ;draw some text to the bitmap
	_GDIPlus_ImageSaveToFile($hBitmap, $sImageFilePath) ;save bitmap to disk
	;cleanup GDI+ resources
	_GDIPlus_GraphicsDispose($hBmpCtxt)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()
	#EndRegion

	Local $hTimer, $sOCRTextResult

	; Get OCR Text
;~ 	_UWPOCR_Log(__UWPOCR_Log) ;Enable Log

	; Get OCR Text without Line Breaks
	$hTimer = TimerInit()
	$sOCRTextResult = _UWPOCR_GetText($sImageFilePath)
	MsgBox(0, "Time Elapsed: " & TimerDiff($hTimer), $sOCRTextResult)

	; Get OCR Text Add Line Breaks
	$hTimer = TimerInit()
	$sOCRTextResult = _UWPOCR_GetText($sImageFilePath, Default, True)
	MsgBox(0, "Time Elapsed: " & TimerDiff($hTimer), $sOCRTextResult)

	FileDelete($sImageFilePath)
EndFunc   ;==>_Example
