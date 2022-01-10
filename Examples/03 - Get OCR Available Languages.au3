#include <Array.au3>
#include "..\UWPOCR.au3"


_Example()

Func _Example()

	Local $aSupportedLanguages = _UWPOCR_GetSupportedLanguages()
	_ArrayDisplay($aSupportedLanguages, "Supported Languages", "", 0, Default, "LanguageTag|DisplayName")
EndFunc   ;==>_Example
