#ifndef __PDF_XCHANGE_VIEW_36_INTERFACE_H__
#define __PDF_XCHANGE_VIEW_36_INTERFACE_H__

#define PXV36_API	__stdcall

#ifndef _STATIC_EXPORT_
	#ifdef PXCVIEW_EXPORTS
		// Since the DLL exports are defined in the .DEF file, there is no need for __declspec(dllexport), the more so as it causes LNK4197 warning.
		#define PXCVIEW36_API /*__declspec(dllexport)*/
	#else
		#define PXCVIEW36_API __declspec(dllimport)
	#endif
#else
	#define PXCVIEW36_API
#endif

typedef void* PXVDocument;

typedef BOOL (__stdcall *PXV36_CALLBACK_FUNC)(DWORD dwStage, DWORD dwLevel, LPARAM param);

enum PXV36_CallbackStage
{
	PXCVClb_Start = 1,
	PXCVClb_Processing,
	PXCVClb_Finish,
};


#ifdef __cplusplus
extern "C" {
#endif

enum PXCV_RenderMode
{
	pxvrm_Viewing = 0,
	pxvrm_Printing,
	pxvrm_Exporting,

};

enum PXCV_ReleaseCachedDataFlags
{
	pxvrcd_ReleaseDocumentImages	=	0x0001,
	pxvrcd_ReleaseDocumentFonts		=	0x0002,
	pxvrcd_ReleaseGlobalFonts		=	0x0004,
};

#pragma pack(push, 1)
typedef struct _PXV_CommonRenderParameters
{
	LPRECT		WholePageRect;
	LPRECT		DrawRect;
	DWORD		Flags;
	DWORD		RenderTarget;
} PXV_CommonRenderParameters, *LPPXV_CommonRenderParameters;

typedef struct _PXV_DrawToImageParams
{
	DWORD		ImageFormat;			//
	DWORD		Flags;					// 
	DWORD		Bpp;					// 1, 8, 24, 32; HIWORD is used as DPI value in range [50; 9600]
} PXV_DrawToImageParams, *LPPXV_DrawToImageParams;

#pragma pack(pop)


enum PXV_CommonRenderParametersFlags
{
	pxvrpf_None						=	0x0000,
	pxvrpf_Rotate_NoRotate			=	0x0000,
	pxvrpf_Rotate_Rotate90CW		=	0x0001,
	pxvrpf_Rotate_Rotate180			=	0x0002,
	pxvrpf_Rotate_Rotate90CCW		=	0x0003,
	pxvrpf_Rotate_RotateMask		=	0x0003,
	pxvrpf_UseVectorRenderer		=	0x0004,
	pxvrpf_RenderAsGray				=	0x0008,
	pxvrpf_EmbeddedFontAsCurves		=	0x0010,
	pxvrpf_AllFontsAsCuves			=	0x0030,
	//
	pxvrpf_NoTransparentBkgnd		=	0x0040,
	//
	pxvrpf_BlackAndWhite			=	0x0080,		// for drawtodc: result will be black-and-white
	pxvrpf_Dither					=	0x0100,		// use dithering or not; has meaning only with pxvrpf_BlackAndWhite
};

enum PXV_DrawToImageFlags
{
	pxvdif_None						=	0x0000,
};

#define IMGF_PNG				0x504e4720		// 'PNG '
#define IMGF_JPEG				0x4a504547		// 'JPEG'
#define IMGF_TIFF				0x54494646		// 'TIFF'

PXCVIEW36_API	HRESULT PXV36_API PXCV_Init(PXVDocument* pDoc, LPCSTR Key, LPCSTR DevCode);
// Deinitialize PDF Object
PXCVIEW36_API	HRESULT PXV36_API PXCV_Delete(PXVDocument Doc);
// Set callback function
PXCVIEW36_API	HRESULT PXV36_API PXCV_SetCallBack(PXVDocument Doc, PXV36_CALLBACK_FUNC pProc, LPARAM UserData);
// Read document from file
PXCVIEW36_API	HRESULT PXV36_API PXCV_ReadDocumentW(PXVDocument Doc, LPCWSTR pwFileName, DWORD Flags);
// Read document form IStream interface
PXCVIEW36_API	HRESULT PXV36_API PXCV_ReadDocumentFromIStream(PXVDocument Doc, IStream* stream, DWORD Flags);
// ReadDocument from memory
PXCVIEW36_API	HRESULT PXV36_API PXCV_ReadDocumentFromMemory(PXVDocument Doc, const BYTE* mem, UINT size, DWORD Flags);
// Check the password for encrypted document
PXCVIEW36_API	HRESULT PXV36_API PXCV_CheckPassword(PXVDocument Doc, BYTE* pPassword, DWORD PassLen);
// Continue reading document after checking password
PXCVIEW36_API	HRESULT PXV36_API PXCV_FinishReadDocument(PXVDocument Doc, DWORD Flags);

PXCVIEW36_API	HRESULT PXV36_API PXCV_GetPermissions(PXVDocument Doc, DWORD* enclevel, DWORD* permFlags);

PXCVIEW36_API	HRESULT PXV36_API PXCV_GetDocumentInfoW(PXVDocument Doc, LPCSTR name, LPWSTR value, DWORD* valuebufLen);

PXCVIEW36_API	HRESULT PXV36_API PXCV_GetPagesCount(PXVDocument Doc, DWORD* count);

PXCVIEW36_API	HRESULT PXV36_API PXCV_GetPageDimensions(PXVDocument Doc, DWORD page_num, double* width, double* height);

PXCVIEW36_API	HRESULT PXV36_API PXCV_GetPageRotation(PXVDocument Doc, DWORD page_num, LONG* angle);

PXCVIEW36_API	HRESULT PXV36_API PXCV_DrawPageToDC(PXVDocument Doc, DWORD page_num, HDC hDC, LPPXV_CommonRenderParameters pParams);

PXCVIEW36_API	HRESULT PXV36_API PXCV_DrawPageToDIBSection(PXVDocument Doc, DWORD page_num, LPPXV_CommonRenderParameters pParams,
															HDC hBaseDC, COLORREF backcolor, HBITMAP* pResDIBSection, HANDLE hSection, DWORD dwOffset);

PXCVIEW36_API	HRESULT PXV36_API PXCV_DrawPageToIStream(PXVDocument Doc, DWORD page_num, LPPXV_CommonRenderParameters pParams,
														 COLORREF backcolor, LPPXV_DrawToImageParams pImageParams, IStream* pDest);

PXCVIEW36_API	HRESULT PXV36_API PXCV_ReleasePageCachedData(PXVDocument Doc, DWORD page_num, DWORD dwFlags);

PXCVIEW36_API	HRESULT PXV36_API PXCV_ReleaseCachedData(PXVDocument Doc, DWORD dwFlags);

//-- Error descriptions API
PXCVIEW36_API LONG PXV36_API PXCV_Err_FormatSeverity(HRESULT errorcode, LPSTR buf, LONG maxlen);
PXCVIEW36_API LONG PXV36_API PXCV_Err_FormatFacility(HRESULT errorcode, LPSTR buf, LONG maxlen);
PXCVIEW36_API LONG PXV36_API PXCV_Err_FormatErrorCode(HRESULT errorcode, LPSTR buf, LONG maxlen);


#ifdef __cplusplus
}
#endif

#endif//__PDF_XCHANGE_VIEW_36_INTERFACE_H__
