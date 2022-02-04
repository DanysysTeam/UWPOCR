#include <GUIConstantsEx.au3>
#include <Array.au3>
#include "..\UWPOCR.au3"

_Example()

Func _Example()
;~ 	_UWPOCR_Log(__UWPOCR_Log)
	_GDIPlus_Startup()   ;initialize GDI+
	Local $sText = "Hello World!!!" & @CRLF & "AutoIt Rocks" & @CRLF & "0123456789" & @CRLF & "WPUOCR UDF"
	Local Const $iW = 500, $iH = 500
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iW, $iH) ;create an empty bitmap
	Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap) ;get the graphics context of the bitmap
	_GDIPlus_GraphicsSetSmoothingMode($hBmpCtxt, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
	_GDIPlus_GraphicsClear($hBmpCtxt, 0xFFFFFFFF) ;clear bitmap with color white
	_GDIPlus_GraphicsDrawString($hBmpCtxt, $sText, 0, 0, "Comic Sans MS", 52)  ;draw some text to the bitmap


	Local $aWords = _UWPOCR_GetWordsRectTo2DArray($hBitmap)
	_ArrayDisplay($aWords)


	Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 1)

	For $i = 0 To UBound($aWords) - 1
		_GDIPlus_GraphicsDrawRect($hBmpCtxt, $aWords[$i][1], $aWords[$i][2], $aWords[$i][3], $aWords[$i][4], $hPen)
		_GDIPlus_GraphicsDrawString($hBmpCtxt, $aWords[$i][0] & StringFormat(" (%d,%d,%d,%d)", $aWords[$i][1], $aWords[$i][2], $aWords[$i][3], $aWords[$i][4]), _
				$aWords[$i][1], $aWords[$i][2] - ($aWords[$i][4] / 3.5))
	Next

	Local $hGUI = GUICreate("Words' Rect", $iW, $iH)
	GUISetState(@SW_SHOW)

	Local $hGUIGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
	_GDIPlus_GraphicsDrawImageRect($hGUIGraphic, $hBitmap, 0, 0, $iW, $iH)

	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hBmpCtxt)
	_GDIPlus_GraphicsDispose($hGUIGraphic)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()
EndFunc   ;==>_Example
