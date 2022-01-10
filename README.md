# UWPOCR

[![Latest Version](https://img.shields.io/badge/Latest-v1.0.0-green.svg)]()
[![AutoIt Version](https://img.shields.io/badge/AutoIt-3.3.14.5-blue.svg)]()
[![MIT License](https://img.shields.io/github/license/mashape/apistatus.svg)]()
[![Made with Love](https://img.shields.io/badge/Made%20with-%E2%9D%A4-red.svg?colorB=e31b23)]()


UWPOCR UDF is a simple library to use Universal Windows Platform Optical character recognition API.


## Features
* Get Text From Image File.
* Get Text From GDI+ Bitmap.
* Easy to use.

## Usage

##### Basic use:
```autoit
#include "..\UWPOCR.au3"

_Example()

Func _Example()
	Local $sOCRTextResult = _UWPOCR_GetText(FileOpenDialog("Select Image", @ScriptDir & "\", "Images (*.jpg;*.bmp;*.png;*.tif;*.gif)"))
	MsgBox(0,"",$sOCRTextResult)
EndFunc

```

##### More examples [here.](/Examples)


## Release History
See [CHANGELOG.md](CHANGELOG.md)


<!-- ## Acknowledgments & Credits -->


## License

Usage is provided under the [MIT](https://choosealicense.com/licenses/mit/) License.

Copyright © 2022, [Danysys.](https://www.danysys.com)