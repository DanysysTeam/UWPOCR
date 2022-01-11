#cs Copyright
    Copyright 2022 Danysys. <hello@danysys.com>
    Licensed under the MIT license.
    See LICENSE file or go to https://opensource.org/licenses/MIT for details.
#ce Copyright

#cs Information
    Author(s)......: DanysysTeam (Danyfirex & Dany3j)
    Description....: UWP OCR UDF Universal Windows Platform Optical character recognition
    Remarks........: The current implementation is designed for using under Windows 10
    Version........: 1.0.0
    AutoIt Version.: 3.3.14.5
	Thanks to .....:
					http://forums.purebasic.com/english/viewtopic.php?f=12&t=77835
					https://www.autohotkey.com/boards/viewtopic.php?f=6&t=72674
#ce Information

#Region Settings
#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#Tidy_Parameters=/tcb=-1 /sf /ewnl /reel /gd ;/sfc
#EndRegion Settings

#Region Include
#include-once
#include <WinAPIConv.au3>
#include <GDIPlus.au3>
#EndRegion Include

; #VARIABLES# ===================================================================================================================
#Region - Internal Variables
Global $__g_oLanguageFactory = 0
Global $__g_oBitmapDecoderStatics = 0
Global $__g_oOcrEngineStatics = 0
Global $__g_oGlobalizationPreferencesStatics = 0
Global $__g_aLanguageInfo2D[0][2] ;LanguageTag|DisplayName
#EndRegion - Internal Variables
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
#Region - Public Constants

#Region Interfaces
Global Const $sTag_IInspectable = "GetIids hresult();GetRuntimeClassName hresult();GetTrustLevel hresult(int*);"

Global Const $sIID_ILanguageFactory = "{9B0252AC-0C27-44F8-B792-9793FB66C63E}"
Global Const $sTag_ILanguageFactory = $sTag_IInspectable & "CreateLanguage hresult(ptr;ptr*)"

Global Const $sIID_IBitmapDecoderStatics = "{438CCB26-BCEF-4E95-BAD6-23A822E58D01}"
Global Const $sTag_IBitmapDecoderStatics = $sTag_IInspectable & "BmpDecoderId hresult(ptr*);JpegDecoderId hresult(ptr*);PngDecoderId hresult(ptr*);" & _
		"TiffDecoderId hresult(ptr*);GifDecoderId hresult(ptr*);JpegXRDecoderId hresult(ptr*);IcoDecoderId hresult(ptr*);" & _
		"GetDecoderInformationEnumerator hresult();CreateAsync hresult(ptr;ptr*);CreateWithIdAsync hresult();"

Global Const $sIID_IOcrEngineStatics = "{5BFFA85A-3384-3540-9940-699120D428A8}"
Global Const $sTag_IOcrEngineStatics = $sTag_IInspectable & "MaxImageDimension hresult(uint*);AvailableRecognizerLanguages hresult(ptr*);" & _
		"IsLanguageSupported hresult(ptr;bool*);TryCreateFromLanguage hresult(ptr;ptr*);TryCreateFromUserProfileLanguages hresult(ptr*);"

Global Const $sIID_IGlobalizationPreferencesStatics = "{01BF4326-ED37-4E96-B0E9-C1340D1EA158}"
Global Const $sTag_IGlobalizationPreferencesStatics = $sTag_IInspectable & "GetCalendars hresult(ptr*);GetClocks hresult(ptr*);GetCurrencies hresult(ptr*);" & _
		"GetLanguages hresult(ptr*);GetHomeGeographicRegion hresult(ptr*);GetWeekStartsOn hresult(ptr*);"

Global Const $sIID___FIVectorView_1_HSTRING = "{2f13c006-a03a-5f69-b090-75a43e33423e}"
Global Const $sTag___FIVectorView_1_HSTRING = $sTag_IInspectable & "GetAt hresult(int;ptr*);GetSize hresult(uint*);IndexOf hresult(ptr;uint*;bool*);" & _
		"GetMany hresult(uint;uint;ptr*;uint*);"

Global Const $sIID___FIVectorView_1_Windows__CMedia__COcr__COcrLine = "{60c76eac-8875-5ddb-a19b-65a3936279ea}"
Global Const $sTag___FIVectorView_1_Windows__CMedia__COcr__COcrLine = $sTag___FIVectorView_1_HSTRING

Global Const $sIID_ILanguage = "{EA79A752-F7C2-4265-B1BD-C4DEC4E4F080}"
Global Const $sTag_ILanguage = $sTag_IInspectable & "GetLanguageTag hresult(ptr*);GetDisplayName hresult(ptr*);GetNativeName hresult(ptr*);GetScript hresult(ptr*);"

Global Const $sIID_IOcrEngine = "{5A14BC41-5B76-3140-B680-8825562683AC}"
Global Const $sTag_IOcrEngine = $sTag_IInspectable & "RecognizeAsync hresult(ptr;ptr*);RecognizerLanguage hresult(ptr*);"

Global Const $sIID_IRandomAccessStream = "{905A0FE1-BC53-11DF-8C49-001E4FC686DA}"
Global Const $sIID_IAsyncInfo = "{00000036-0000-0000-C000-000000000046}"

Global Const $sTag_IAsyncInfo = $sTag_IInspectable & "GetID hresult(int*);GetStatus hresult(int*);GetErrorCode hresult(long*)Cancel hresult();Close hresult();"

Global Const $sIID_IBitmapDecoder = "{ACEF22BA-1D74-4C91-9DFC-9620745233E6}"
Global Const $sTag_IBitmapDecoder = $sTag_IInspectable & "BitmapContainerProperties hresult(ptr*);DecoderInformation hresult(ptr*);FrameCount hresult(uint*);" & _
		"GetPreviewAsync  hresult(ptr*);GetFrameAsync hresult(uint;ptr*);"

Global Const $sIID_IBitmapFrame = "{72A49A1C-8081-438D-91BC-94ECFC8185C6}"
Global Const $sTag_IBitmapFrame = $sTag_IInspectable & "GetThumbnailAsync hresult();BitmapProperties hresult();BitmapPixelFormat hresult();BitmapAlphaMode hresult();" & _
		"DpiX hresult();DpiX hresult();PixelWidth hresult(uint*);PixelHeight hresult(uint*);OrientedPixelWidth hresult(uint*);OrientedPixelHeight hresult(uint*);" & _
		"GetPixelDataAsync hresult();GetPixelDataTransformedAsync hresult();"

Global Const $sIID_IBitmapFrameWithSoftwareBitmap = "{FE287C9A-420C-4963-87AD-691436E08383}"
Global Const $sTag_IBitmapFrameWithSoftwareBitmap = $sTag_IInspectable & "GetSoftwareBitmapAsync hresult(ptr*);GetSoftwareBitmapConvertedAsync hresult();" & _
		"GetSoftwareBitmapTransformedAsync  hresult();"

Global Const $sIID_ISoftwareBitmap = "{689E0708-7EEF-483F-963F-DA938818E073}"
Global Const $sTag_ISoftwareBitmap = $sTag_IInspectable & ""

Global Const $sIID_IOcrResult = "{9BD235B2-175B-3D6A-92E2-388C206E2F63}"
Global Const $sTag_IOcrResult = $sTag_IInspectable & "Lines hresult(ptr*);TextAngle hresult(double*);Text hresult(ptr*);"

Global Const $sIID_IOcrLine = "{0043A16F-E31F-3A24-899C-D444BD088124}"
Global Const $sTag_IOcrLine = $sTag_IInspectable & "GetWords hreulst(ptr*);GetText hreulst(ptr*);"

Global Const $sIID_IPicture = "{7BF80980-BF32-101A-8BBB-00AA00300CAB}"
Global Const $sTag_IPicture = "GetHandle hresult();GethPal hresult();GetType hresult();GetWidth hresult();GetHeight hresult();Render hresult();SethPal hresult();" & _
		"GetCurDC hresult();SelectPicture hresult();GetKeepOriginalFormat hresult();PutKeepOriginalFormat hresult();" & _
		"PictureChanged hresult();SaveAsFile hresult(ptr;bool;int*);GetAttributes hresult(ptr;bool;int);"

#EndRegion Interfaces

#EndRegion - Public Constants

#Region - Internal Constants
Global Const $__g_hUWPOCR_Combase = DllOpen("Combase.dll")
Global Const $__g_hUWPOCR_SHCore = DllOpen("SHCore.dll")
#EndRegion - Internal Constants
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _UWPOCR_GetSupportedLanguages
; _UWPOCR_GetText
; _UWPOCR_Log
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __UWPOCR_CreateRuntimeClass
; __UWPOCR_ErrorHandler
; __UWPOCR_GetStringFromhString
; __UWPOCR_GetText
; __UWPOCR_Initialize
; __UWPOCR_LoadLanguageList2DArray
; __UWPOCR_Log
; __UWPOCR_RoGetActivationFactory
; __UWPOCR_WaitForAsyncInterface
; __UWPOCR_CreateHString
; __UWPOCR_CreateRandomAccessStreamOnFile
; __UWPOCR_CreateRandomAccessStreamOverStream
; __UWPOCR_DeleteHString
; ===============================================================================================================================

#Region Public Functions

Func _UWPOCR_GetSupportedLanguages()
	If Not __UWPOCR_Initialize() Then
		_UWPOCR_Log("FAIL __UWPOCR_Initialize")
		Return SetError(@error, @extended, 0)
	EndIf
	_UWPOCR_Log("OK __UWPOCR_Initialize")
	Return $__g_aLanguageInfo2D
EndFunc   ;==>_UWPOCR_GetSupportedLanguages

Func _UWPOCR_GetText($sImageFilePathOrhBitmap, $sLanguageTagToUse = Default, $bUseOcrLine = False)
	Local $oErrorHandler = ObjEvent("AutoIt.Error", __UWPOCR_ErrorHandler)
	#forceref $oErrorHandler

	_UWPOCR_Log("_UWPOCR_GetText")
	Return __UWPOCR_GetText($sImageFilePathOrhBitmap, $sLanguageTagToUse, $bUseOcrLine)
EndFunc   ;==>_UWPOCR_GetText

Func _UWPOCR_Log($pCallFunction = Default, Const $iCurrentError = @error, Const $iCurrentExtended = @extended, Const $iScriptLineNumber = @ScriptLineNumber)
	Local Static $pFunction = Default
	If @NumParams And IsFunc($pCallFunction) Then $pFunction = $pCallFunction
	If IsFunc($pFunction) And Not IsFunc($pCallFunction) Then Call($pFunction, $pCallFunction, $iScriptLineNumber)
	SetError($iCurrentError, $iCurrentExtended)
EndFunc   ;==>_UWPOCR_Log
#EndRegion Public Functions

#Region Internal Functions

Func __UWPOCR_CreateRuntimeClass($sActivatableClassId, $sGUID, $sInterfaceDescription)
	Local $pFactory = __UWPOCR_RoGetActivationFactory($sActivatableClassId, $sGUID)
	Local $oInterface = ObjCreateInterface($pFactory, $sGUID, $sInterfaceDescription)
	Return $oInterface
EndFunc   ;==>__UWPOCR_CreateRuntimeClass

Func __UWPOCR_ErrorHandler($oError)
	_UWPOCR_Log(@ScriptName & " (" & $oError.scriptline & ") : ==> COM Error intercepted !" & @CRLF & _
			@TAB & "err.number is: " & @TAB & @TAB & "0x" & Hex($oError.number) & @CRLF & _
			@TAB & "err.windescription:" & @TAB & $oError.windescription & @CRLF & _
			@TAB & "err.description is: " & @TAB & $oError.description & @CRLF & _
			@TAB & "err.source is: " & @TAB & @TAB & $oError.source & @CRLF & _
			@TAB & "err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
			@TAB & "err.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
			@TAB & "err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
			@TAB & "err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
			@TAB & "err.retcode is: " & @TAB & "0x" & Hex($oError.retcode) & @CRLF & @CRLF)
EndFunc   ;==>__UWPOCR_ErrorHandler

Func __UWPOCR_GetStringFromhString($hString)
	Local $aCall = DllCall($__g_hUWPOCR_Combase, "wstr", "WindowsGetStringRawBuffer", "ptr", $hString, "uint*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Local $iSize = $aCall[2]
	$aCall = DllCall($__g_hUWPOCR_Combase, "wstr", "WindowsGetStringRawBuffer", "ptr", $hString, "uint*", $iSize)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aCall[0]
EndFunc   ;==>__UWPOCR_GetStringFromhString

Func __UWPOCR_GetText($sImageFilePathOrhBitmap, $sLanguageTagToUse, $bUseOcrLine = False)
	Local $sTextResult = ""
	If Not __UWPOCR_Initialize() Then
		_UWPOCR_Log("FAIL __UWPOCR_Initialize")
		Return SetError(@error, @extended, $sTextResult)
	EndIf
	_UWPOCR_Log("OK __UWPOCR_Initialize")

	Local $bIsBitmap = False
	Local $sImageFilePath = ""
	Local $hBitmap = 0

	If IsString($sImageFilePathOrhBitmap) Then
		If Not FileExists($sImageFilePathOrhBitmap) Then
			_UWPOCR_Log("FAIL __UWPOCR_GetText -> Image File not found")
			Return SetError(@error, @extended, $sTextResult)
		EndIf
		$sImageFilePath = $sImageFilePathOrhBitmap
	Else
		$hBitmap = $sImageFilePathOrhBitmap
		$bIsBitmap = True
		If Not $hBitmap Then
			_UWPOCR_Log("FAIL __UWPOCR_GetText -> Invalid hBitmap")
			Return SetError(@error, @extended, $sTextResult)
		EndIf
	EndIf

	If $sLanguageTagToUse = Default Then $sLanguageTagToUse = $__g_aLanguageInfo2D[0][0]
	Local $iLanguageSupported = False
	For $i = 0 To UBound($__g_aLanguageInfo2D) - 1
		If $__g_aLanguageInfo2D[$i][0] = $sLanguageTagToUse Then
			$iLanguageSupported = True
		EndIf
	Next

	If Not $iLanguageSupported Then
		_UWPOCR_Log("FAIL __UWPOCR_GetText -> Unsupported Language [" & $sLanguageTagToUse & "]")
		SetError(1, 1, $sTextResult)
	EndIf
	_UWPOCR_Log("OK __UWPOCR_GetText -> Supported Language [" & $sLanguageTagToUse & "]")

	Local $phStringLanguage = __UWPOCR_CreateHString($sLanguageTagToUse)
	Local $pILanguage = 0
	$__g_oLanguageFactory.CreateLanguage($phStringLanguage, $pILanguage)
	Local $oLenguage = ObjCreateInterface($pILanguage, $sIID_ILanguage, $sTag_ILanguage)

	Local $pIOcrEngine = 0
	$__g_oOcrEngineStatics.TryCreateFromLanguage($oLenguage(), $pIOcrEngine)
	Local $oOcrEngine = ObjCreateInterface($pIOcrEngine, $sIID_IOcrEngine, $sTag_IOcrEngine)

	Local $pIRandomAccessStream = 0
	If $bIsBitmap Then
;~ 		;Handle hImage/hBitmap GDI ;faster
		Local $sImgCLSID = _GDIPlus_EncodersGetCLSID("jpg") ;create CLSID for a JPG image file type
		Local $tGUID = _WinAPI_GUIDFromString($sImgCLSID) ;convert CLSID GUID to binary form and returns $tagGUID structure
		Local $tParams = _GDIPlus_ParamInit(1) ;initialize an encoder parameter list and return $tagGDIPENCODERPARAMS structure
		Local $tData = DllStructCreate("int Quality") ;create struct to set JPG quality setting
		DllStructSetData($tData, "Quality", 100) ;quality 0-100 (0: lowest, 100: highest)
		Local $pData = DllStructGetPtr($tData) ;get pointer from quality struct
		_GDIPlus_ParamAdd($tParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, $pData) ;add a value to an encoder parameter list
		Local $pStream = _WinAPI_CreateStreamOnHGlobal() ;create stream
		_GDIPlus_ImageSaveToStream($hBitmap, $pStream, $tGUID, $tParams) ;save the bitmap in JPG format in memory
		$pIRandomAccessStream = __UWPOCR_CreateRandomAccessStreamOverStream($pStream)
		_WinAPI_ReleaseStream($pStream)

		;handle hBitmap It's slower
;~ 		Local $pStream = _WinAPI_CreateStreamOnHGlobal(0)
;~ 		Local $tPD = DllStructCreate("uint cbSize;uint picType;handle hBitmap;int;int;") ;PICTDESC
;~ 		$tPD.cbSize = DllStructGetSize($tPD)
;~ 		$tPD.picType = 1 ;PICTYPE_BITMAP
;~ 		$tPD.hBitmap = $hBitmap
;~ 		Local $tGUID = _WinAPI_GUIDFromString($sIID_IPicture)
;~ 		Local $pIPicture = 0
;~ 		Local $aCall = DllCall("OleAut32.dll", "long", "OleCreatePictureIndirect", "struct*", $tPD, "struct*", $tGUID, "bool", False, "ptr*", 0)
;~ 		$pIPicture = $aCall[4]
;~ 		Local $oPicture = ObjCreateInterface($pIPicture, $sIID_IPicture, $sTag_IPicture)
;~ 		Local $iSize=0
;~ 		$oPicture.SaveAsFile($pStream, True, $iSize)
;~ 		$pIRandomAccessStream = __UWPOCR_CreateRandomAccessStreamOverStream($pStream)
;~ 		_WinAPI_ReleaseStream($pStream)

	Else
		$pIRandomAccessStream = __UWPOCR_CreateRandomAccessStreamOnFile($sImageFilePath)
	EndIf

	If Not $pIRandomAccessStream Then
		_UWPOCR_Log("FAIL __UWPOCR_GetText -> IRandomAccessStream")
		Return SetError(2, 2, $sTextResult)
	EndIf

	Local $pIBitmapDecoder = 0
	$__g_oBitmapDecoderStatics.CreateAsync($pIRandomAccessStream, $pIBitmapDecoder)
	If Not __UWPOCR_WaitForAsyncInterface($pIBitmapDecoder) Then
		_UWPOCR_Log("FAIL __UWPOCR_GetText -> WaitForAsync IBitmapDecoder")
		Return SetError(3, 3, $sTextResult)
	EndIf

	Local $oBitmapDecoder = ObjCreateInterface($pIBitmapDecoder, $sIID_IBitmapDecoder, $sTag_IBitmapDecoder)
	Local $oBitmapFrame = ObjCreateInterface($oBitmapDecoder(), $sIID_IBitmapFrame, $sTag_IBitmapFrame)

	Local $iWidth = 0
	Local $iHeight = 0
	Local $iMaxDimensions = 0
	$oBitmapFrame.PixelWidth($iWidth)
	$oBitmapFrame.PixelHeight($iHeight)
	$__g_oOcrEngineStatics.MaxImageDimension($iMaxDimensions)

	If $iWidth > $iMaxDimensions Or $iHeight > $iMaxDimensions Then
		_UWPOCR_Log("FAIL __UWPOCR_GetText -> OcrEngine MaxDimension")
		Return SetError(4, 4, $sTextResult)
	EndIf

	Local $pBitmapFrameWithSoftwareBitmap = 0
	$oBitmapDecoder.QueryInterface($sIID_IBitmapFrameWithSoftwareBitmap, $pBitmapFrameWithSoftwareBitmap)
	Local $oBitmapFrameWithSoftwareBitmap = ObjCreateInterface($pBitmapFrameWithSoftwareBitmap, $sIID_IBitmapFrameWithSoftwareBitmap, _
			$sTag_IBitmapFrameWithSoftwareBitmap)

	If Not IsObj($oBitmapFrameWithSoftwareBitmap) Then
		_UWPOCR_Log("FAIL __UWPOCR_GetText -> IBitmapFrameWithSoftwareBitmap")
		Return SetError(5, 5, $sTextResult)
	EndIf

	Local $pISoftwareBitmap = 0
	$oBitmapFrameWithSoftwareBitmap.GetSoftwareBitmapAsync($pISoftwareBitmap)
	If Not __UWPOCR_WaitForAsyncInterface($pISoftwareBitmap) Then
		_UWPOCR_Log("FAIL __UWPOCR_GetText -> WaitForAsync ISoftwareBitmap")
		Return SetError(6, 6, $sTextResult)
	EndIf

	Local $oSoftwareBitmap = ObjCreateInterface($pISoftwareBitmap, $sIID_ISoftwareBitmap, $sTag_ISoftwareBitmap)
	Local $pIOcrResult = 0
	$oOcrEngine.RecognizeAsync($oSoftwareBitmap(), $pIOcrResult)
	If Not __UWPOCR_WaitForAsyncInterface($pIOcrResult) Then
		_UWPOCR_Log("FAIL __UWPOCR_GetText -> WaitForAsync IOcrResult")
		Return SetError(7, 7, $sTextResult)
	EndIf

	Local $oOcrResult = ObjCreateInterface($pIOcrResult, $sIID_IOcrResult, $sTag_IOcrResult)

	Local $iAngle = 0
	$oOcrResult.TextAngle($iAngle)

	If $bUseOcrLine Then
		Local $pFIVOcrLines = 0
		$oOcrResult.Lines($pFIVOcrLines)
		Local $oFIVOcrLines = ObjCreateInterface($pFIVOcrLines, $sIID___FIVectorView_1_Windows__CMedia__COcr__COcrLine, _
				$sTag___FIVectorView_1_Windows__CMedia__COcr__COcrLine)

		Local $iCountLines = 0
		$oFIVOcrLines.GetSize($iCountLines)

		Local $pIOCRLine = 0
		Local $oIOCRLine = 0
		Local $phStringLine = ""
		For $i = 0 To $iCountLines - 1
			$oFIVOcrLines.GetAt($i, $pIOCRLine)
			$oIOCRLine = ObjCreateInterface($pIOCRLine, $sIID_IOcrLine, $sTag_IOcrLine)
			$oIOCRLine.GetText($phStringLine)
			$sTextResult &= __UWPOCR_GetStringFromhString($phStringLine) & @CRLF
			__UWPOCR_DeleteHString($phStringLine)
			$oIOCRLine = 0
		Next

	Else
		Local $phResultText = ""
		$oOcrResult.Text($phResultText)
		$sTextResult = __UWPOCR_GetStringFromhString($phResultText)
		__UWPOCR_DeleteHString($phResultText)
	EndIf

	Return SetError(@error, $iAngle, $sTextResult)

EndFunc   ;==>__UWPOCR_GetText

Func __UWPOCR_Initialize()
	If (Not IsObj($__g_oLanguageFactory)) Or (Not IsObj($__g_oBitmapDecoderStatics)) Or _
			(Not IsObj($__g_oOcrEngineStatics)) Or (Not IsObj($__g_oGlobalizationPreferencesStatics)) Then
		_GDIPlus_Startup()
		$__g_oLanguageFactory = __UWPOCR_CreateRuntimeClass("Windows.Globalization.Language", _
				$sIID_ILanguageFactory, $sTag_ILanguageFactory)
		$__g_oBitmapDecoderStatics = __UWPOCR_CreateRuntimeClass("Windows.Graphics.Imaging.BitmapDecoder", _
				$sIID_IBitmapDecoderStatics, $sTag_IBitmapDecoderStatics)
		$__g_oOcrEngineStatics = __UWPOCR_CreateRuntimeClass("Windows.Media.Ocr.OcrEngine", _
				$sIID_IOcrEngineStatics, $sTag_IOcrEngineStatics)
		$__g_oGlobalizationPreferencesStatics = __UWPOCR_CreateRuntimeClass("Windows.System.UserProfile.GlobalizationPreferences", _
				$sIID_IGlobalizationPreferencesStatics, $sTag_IGlobalizationPreferencesStatics)

		If Not __UWPOCR_LoadLanguageList2DArray() Then Return SetError(@error, @extended, 0)

	EndIf
	If IsObj($__g_oLanguageFactory) And IsObj($__g_oBitmapDecoderStatics) And _
			IsObj($__g_oOcrEngineStatics) And IsObj($__g_oGlobalizationPreferencesStatics) Then Return SetError(0, 0, 1)

	Return SetError(1, 0, 0)
EndFunc   ;==>__UWPOCR_Initialize

Func __UWPOCR_LoadLanguageList2DArray()
	Local $pFIVLanguages = 0
	$__g_oGlobalizationPreferencesStatics.GetLanguages($pFIVLanguages)
	Local $oFIVLanguages = ObjCreateInterface($pFIVLanguages, $sIID___FIVectorView_1_HSTRING, $sTag___FIVectorView_1_HSTRING)
	If Not IsObj($oFIVLanguages) Then Return SetError(@error, @extended, 0)

	Local $iCountLanguages = 0
	$oFIVLanguages.GetSize($iCountLanguages)
	ReDim $__g_aLanguageInfo2D[$iCountLanguages][2]

	Local $phStringLanguage = 0
	Local $pILanguage = 0
	Local $oLanguage = 0
	Local $phStringLanguageTag = 0
	Local $phStringDisplayName = 0
	Local $bIsLanguageSupported = False
	Local $iCountLanguageSupported = 0

	For $i = 0 To $iCountLanguages - 1
		$oFIVLanguages.GetAt($i, $phStringLanguage)
		$__g_oLanguageFactory.CreateLanguage($phStringLanguage, $pILanguage)
		$oLanguage = ObjCreateInterface($pILanguage, $sIID_ILanguage, $sTag_ILanguage)

		If IsObj($oLanguage) Then
			$oLanguage.GetLanguageTag($phStringLanguageTag)
			$oLanguage.GetDisplayName($phStringDisplayName)
			$__g_oOcrEngineStatics.IsLanguageSupported($oLanguage(), $bIsLanguageSupported)
			If $bIsLanguageSupported Then
				$__g_aLanguageInfo2D[$iCountLanguageSupported][0] = __UWPOCR_GetStringFromhString($phStringLanguageTag)
				$__g_aLanguageInfo2D[$iCountLanguageSupported][1] = __UWPOCR_GetStringFromhString($phStringDisplayName)
				$iCountLanguageSupported += 1
			EndIf
			__UWPOCR_DeleteHString($phStringLanguageTag)
			__UWPOCR_DeleteHString($phStringDisplayName)
		EndIf
		$oLanguage = 0
	Next
	$oFIVLanguages = 0
	ReDim $__g_aLanguageInfo2D[$iCountLanguageSupported][2]
	If $iCountLanguageSupported Then Return SetError(0, 0, 1)

	Return SetError(1, 0, 0)
EndFunc   ;==>__UWPOCR_LoadLanguageList2DArray

Func __UWPOCR_Log($sString, $iScriptLineNumber)
	ConsoleWrite(StringFormat((StringInStr($sString, "FAIL") ? "!" : ">") & "[%s-L%04s]\t%s", "Debug", $iScriptLineNumber, $sString) & @CRLF)
EndFunc   ;==>__UWPOCR_Log

Func __UWPOCR_RoGetActivationFactory($shString, $sGUID)
	Local $hString = __UWPOCR_CreateHString($shString)
	Local $tGUID = _WinAPI_GUIDFromString($sGUID)
	Local $aCall = DllCall($__g_hUWPOCR_Combase, "long", "RoGetActivationFactory", "ptr", $hString, "struct*", $tGUID, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(@error, @extended, 0)
	__UWPOCR_DeleteHString($hString)
	Return $aCall[3]
EndFunc   ;==>__UWPOCR_RoGetActivationFactory

Func __UWPOCR_WaitForAsyncInterface(ByRef $pOutInterface)
	Local $oAsyncInfo = ObjCreateInterface($pOutInterface, $sIID_IAsyncInfo, $sTag_IAsyncInfo)
	If Not IsObj($oAsyncInfo) Then Return False

	Local $iStatus = 0
	Local $iErrorCode = 0
	$oAsyncInfo.GetStatus($iStatus)
	Local $bError = 0

	While True
		$oAsyncInfo.GetStatus($iStatus)
		If $iStatus <> 0 Then
			If $iStatus <> 1 Then
				$oAsyncInfo.GetErrorCode($iErrorCode)
				$bError = $iErrorCode
				ExitLoop
			EndIf
			$oAsyncInfo.GetErrorCode($iErrorCode)
			ExitLoop
		EndIf
		Sleep(10)
	WEnd

	If $bError Then Return SetError(1, $iErrorCode, 0)

	Local $lpInterface = $pOutInterface
	Local $tpInterface = DllStructCreate("ptr", $lpInterface)
	Local $pInterface = DllStructGetData($tpInterface, 1)
	Local $tInterfaceFunctionTable = DllStructCreate("ptr Methods[9]", $pInterface)
	Local $aCall = DllCallAddress("long", DllStructGetData($tInterfaceFunctionTable, "Methods", 9), "ptr", $lpInterface, "ptr*", 0)
	If Not @error And $aCall[2] Then
		$pOutInterface = $aCall[2]
		Return 1
	EndIf
	$pOutInterface = 0
	Return 0
EndFunc   ;==>__UWPOCR_WaitForAsyncInterface
#EndRegion Internal Functions

#Region Internal Utils Functions

Func __UWPOCR_CreateHString($sString)
	Local $aCall = DllCall($__g_hUWPOCR_Combase, "long", "WindowsCreateString", "wstr", $sString, "uint", StringLen($sString), "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(@error, @extended, 0)
	Return $aCall[3]
EndFunc   ;==>__UWPOCR_CreateHString

Func __UWPOCR_CreateRandomAccessStreamOnFile($sImageFilePath)
	Local $tGUID = _WinAPI_GUIDFromString($sIID_IRandomAccessStream)
	Local $aCall = DllCall($__g_hUWPOCR_SHCore, "long", "CreateRandomAccessStreamOnFile", "wstr", $sImageFilePath, _
			"int", 0, "struct*", $tGUID, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(@error, @extended, 0)
	Return $aCall[4]
EndFunc   ;==>__UWPOCR_CreateRandomAccessStreamOnFile

Func __UWPOCR_CreateRandomAccessStreamOverStream($pStream)
	Local $tGUID = _WinAPI_GUIDFromString($sIID_IRandomAccessStream)
	Local $aCall = DllCall($__g_hUWPOCR_SHCore, "long", "CreateRandomAccessStreamOverStream", "ptr", $pStream, "int", 0, "struct*", $tGUID, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(@error, @extended, 0)
	Return $aCall[4]
EndFunc   ;==>__UWPOCR_CreateRandomAccessStreamOverStream

Func __UWPOCR_DeleteHString($hString)
	Local $aCall = DllCall($__g_hUWPOCR_Combase, "long", "WindowsDeleteString", "ptr", $hString)
	If @error Or $aCall[0] Then Return SetError(@error, @extended, 0)
	Return 1
EndFunc   ;==>__UWPOCR_DeleteHString
#EndRegion Internal Utils Functions

