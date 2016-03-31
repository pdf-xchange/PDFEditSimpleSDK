// stdafx.cpp : source file that includes just the standard includes
// pxcview36_sample_app.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"

// TODO: reference any additional headers you need in STDAFX.H
// and not in this file
#if defined(_M_AMD64)
#pragma comment(lib, "PDFXEditSimple.x64.lib")
#else
#pragma comment(lib, "PDFXEditSimple.x86.lib")
#endif

#pragma comment(lib, "comctl32.lib")