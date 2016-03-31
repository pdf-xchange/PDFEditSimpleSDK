{
	-----------------------------
	PDFXView 3.6 library wrapper
	-----------------------------
}


unit PXView_36;

interface

uses
  Windows;

Type
	PXVDocument	= Cardinal;
	LPPXVDocument	= ^PXVDocument;
	LONG	= Longint;
	PHDC    = ^HDC;
	size_t	= DWORD;
	PRect	= ^TRect;
	PLong	= ^LongInt;
	PHBitmap = ^HBitmap;


	PXV36_CALLBACK_FUNC = function (dwStage, dwLevel: DWORD; param: LPARAM): BOOL;stdcall;

	PXV_CommonRenderParameters = packed record
		WholePageRect:      PRect;
		DrawRect:           PRect;
		Flags:      		DWORD;
		RenderTarget:       DWORD;
	end;
	LPPXV_CommonRenderParameters = ^PXV_CommonRenderParameters;

Const
	// PXV36_CallbackStage
	PXCVClb_Start		= 1;
	PXCVClb_Processing	= 2;
	PXCVClb_Finish      = 3;

	// PXCV_RenderMode
	pxvrm_Viewing	= 0;
	pxvrm_Printing	= 1;
	pxvrm_Exporting	= 2;

	// PXCV_ReleaseCachedDataFlags
	pxvrcd_ReleaseDocumentImages	=	$01;
	pxvrcd_ReleaseDocumentFonts		=	$02;
	pxvrcd_ReleaseGlobalFonts		=	$04;

  // PXV_CommonRenderParametersFlags
	pxvrpf_None						   =	$00;
	pxvrpf_Rotate_NoRotate			=	$00;
	pxvrpf_Rotate_Rotate90CW		=	$01;
	pxvrpf_Rotate_Rotate180			=	$02;
	pxvrpf_Rotate_Rotate90CCW		=	$03;
	pxvrpf_Rotate_RotateMask		=	$03;
	pxvrpf_UseVectorRenderer		=	$04;
	pxvrpf_RenderAsGray 				= 	$08;



	////////////////////////////////////////////////////////////////////////
	// IMPORTED FUNCTIONS
	function PXCV_Init (pDoc :LPPXVDocument; key, DevCode:PAnsiChar):HRESULT;stdcall;external 'pxcview.dll';
	// Deinitialize PDF Object
	function PXCV_Delete (pDoc :PXVDocument):HRESULT;stdcall;external 'pxcview.dll';
	// Set callback function
	function PXCV_SetCallBack (pDoc :PXVDocument; pProc: PXV36_CALLBACK_FUNC; UserData: LParam):HRESULT;stdcall;external 'pxcview.dll';
	// Read document
	function PXCV_ReadDocumentW(pDoc :PXVDocument; pwFileName: PWChar; Flags: DWORD):HRESULT;stdcall;external 'pxcview.dll';
	// Check the password for encrypted document
	function PXCV_CheckPassword(pDoc :PXVDocument; pPassword: PByte; PassLen: DWORD):HRESULT;stdcall;external 'pxcview.dll';
	// Continue reading document after checking password
	function PXCV_FinishReadDocument(pDoc :PXVDocument; Flags: DWORD):HRESULT;stdcall;external 'pxcview.dll';

	function PXCV_GetPagesCount(pDoc :PXVDocument; count: PDWORD):HRESULT;stdcall;external 'pxcview.dll';

	function PXCV_GetPageDimensions(pDoc :PXVDocument; page_num: DWORD; width, height: PDouble):HRESULT;stdcall;external 'pxcview.dll';

	function PXCV_GetPageRotation(pDoc :PXVDocument; page_num: DWORD; angle: PLong):HRESULT;stdcall;external 'pxcview.dll';

	function PXCV_DrawPageToDC(pDoc :PXVDocument; page_num: DWORD; _hDC: HDC; pParams: LPPXV_CommonRenderParameters):HRESULT;stdcall;external 'pxcview.dll';

	function PXCV_DrawPageToDIBSection(pDoc :PXVDocument; page_num: DWORD; pParams: LPPXV_CommonRenderParameters;
										hBaseDC: HDC; backcolor: COLORREF; pResDIBSection: PHBitmap;
										hSection: THandle; dwOffset: DWORD):HRESULT;stdcall;external 'pxcview.dll';

	function PXCV_ReleasePageCachedData(pDoc :PXVDocument; page_num, dwFlags: DWORD):HRESULT;stdcall;external 'pxcview.dll';

	function PXCV_ReleaseCachedData(pDoc :PXVDocument; dwFlags: DWORD):HRESULT;stdcall;external 'pxcview.dll';



	function PXCV_Err_FormatSeverity (errcode: HRESULT; buf: PAnsiChar; maxlen: LONG):LONG; stdcall;external 'pxcview.dll';
	function PXCV_Err_FormatFacility (errcode: HRESULT; buf: PAnsiChar; maxlen: LONG):LONG; stdcall;external 'pxcview.dll';
	function PXCV_Err_FormatErrorCode(errcode: HRESULT; buf: PAnsiChar; maxlen: LONG):LONG; stdcall;external 'pxcview.dll';

Const
	//Error codes
	S_OK						= $00000000;
	PXC_OK						= $00000000;
	BASE_ERROR                  = $80000000;
  PS_ERR_NOTIMPLEMENTED        = $821404b0; // Not implemented
  PS_ERR_INVALID_ARG           = $82140001; // Invalid argument
  PS_ERR_MEMALLOC              = $821403e8; // Insufficient memory
  PS_ERR_USER_BREAK            = $821401f4; // Operation aborted by user
  PS_ERR_INTERNAL              = $82140011; // Internal error
  PS_ERR_INVALID_FILE_FORMAT   = $82140002; // Invalid file format
  PS_ERR_REQUIRED_PROP_NOT_SET = $82142716; // Required property is not set
  PS_ERR_INVALID_PROP_TYPE     = $82142717; // Invalid property type
  PS_ERR_INVALID_PROP_VALUE    = $82142718; // Invalid property value
  PS_ERR_INVALID_OBJECT_NUM    = $82142719; // Invalid object number
  PS_ERR_INVALID_PS_OPERATOR   = $8214271c; // Invalid PS operator
  PS_ERR_UNKNOWN_OPERATOR      = $82142787; // Unknown operator
  PS_ERR_INVALID_CONTENT_STATE = $82142788; // Invalid content state
  PS_ERR_NoPassword            = $821427a8; // No password
  PS_ERR_UnknowCryptFlt        = $821427a9; // Unknown crypt filter
  PS_ERR_WrongPassword         = $821427aa; // Wrong password
  PS_ERR_InvlaidObjStruct      = $821427ab; // Invalid object structure
  PS_ERR_WrongEncryptDict      = $821427ac; // Invalid encryption dictionary
  PS_ERR_DocEncrypted          = $821427ad; // Document encrypted
  PS_ERR_DocNOTEncrypted       = $821427ae; // Document not encrypted
  PS_ERR_WrongObjStream        = $821427af; // Invalid object stream
  PS_ERR_WrongTrailer          = $821427b0; // Invalid document trailer
  PS_ERR_WrongXRef             = $821427b1; // Invalid xref table
  PS_ERR_WrongDecodeParms      = $821427b2; // Invalid decode parameter(s)
  PS_ERR_XRefNotFounded        = $821427b3; // xref table is not foud
  PS_ERR_DocAlreadyRead        = $821427b4; // Document is already read
  PS_ERR_DocNotRead            = $821427b5; // Document is not read


	
function PXC_ERROR(v: HRESULT): HRESULT;
function IS_DS_FAILED(v: HRESULT): BOOL;
function IS_DS_ERROR(v: HRESULT): BOOL;
function IS_DS_WARNING(v: HRESULT): BOOL;

implementation

function PXC_ERROR(v: HRESULT): HRESULT;
begin
	Result := HRESULT(DWORD(v) or BASE_ERROR);
end;

function IS_DS_FAILED(v: HRESULT): BOOL;
begin
	Result := BOOL(v and BASE_ERROR);
end;

function IS_DS_ERROR(v: HRESULT): BOOL;
begin
	Result := BOOL(v and $80000000);
end;

function IS_DS_WARNING(v: HRESULT): BOOL;
begin
	Result := BOOL(v and $40000000);
end;

end.

