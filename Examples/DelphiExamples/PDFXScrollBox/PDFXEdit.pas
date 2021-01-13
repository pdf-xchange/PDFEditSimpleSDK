unit PDFXEdit;
{ This unit provides an object wrapper to the Tracker Software PDF Viewer (www.docu-track.com).

  The PXView_36 unit was provided by Tracker software. In this unit, we wrap up functionality
  in the PXView_36 unit in an object, TPDFXView, as well as providing the constants as enumerations,
  and adding a missing enumeration (taken from the C header file) and some error constants, in case
  you want to use the PXView API itself.

  Future updates may look at using the ReleaseCachedData or ReleasePageCachedData when reading
  large PDF files...

  You can of course, still use the direct API calls in PXView_36.

  Author: C Fraser, Hill Laboratories

  This file is free to use and refine as necessary. It has been provided to Tracker Software
  as a better Delphi Example for them to use as they see fit.

  If you refine it/bug fix it, I would really appreciate an update (email IT@hill-labs.co.nz)
}
interface

uses
  Windows, SysUtils, PDFXEditSimple;

type
  {Just an enumeration wrapper to the PXView_36.pas constants as in the C header}
  TPXV36_CallbackStage = (
    PXCVClb_Start = 1,
    PXCVClb_Processing = 2,
    PXCVClb_Finish = 3
  );

  {Just an enumeration wrapper to the PXView_36.pas constants as in the C header}
  TPXCV_RenderMode = (
    pxvrm_Viewing = 0,
  	pxvrm_Printing = 1,
	  pxvrm_Exporting = 2
  );

  {Just an enumeration wrapper to the PXView_36.pas constants as in the C header}
  TPXCV_ReleaseCachedDataFlags = (
    pxvrcd_ReleaseDocumentImages =	$01,
    pxvrcd_ReleaseDocumentFonts	 =	$02,
    pxvrcd_ReleaseGlobalFonts		 =	$04
  );

  {This was missed in the the PXView_36.pas file, so taken from the C header}
  TPXV_CommonRenderParametersFlags = (
    pxvrpf_None                 = $00,
    pxvrpf_Rotate_NoRotate			=	$00,
    pxvrpf_Rotate_Rotate90CW		=	$01,
    pxvrpf_Rotate_Rotate180			=	$02,
    pxvrpf_Rotate_Rotate90CCW		=	$03,
    pxvrpf_Rotate_RotateMask		=	$03,
    pxvrpf_UseVectorRenderer		=	$04
  );

  TPDFXViewerRotation = (vrRotateNone, vrRotate90, vrRotate180, vrRotate270);

  {The object wrapper to the Tracker PDF Viewer API... see Tracker documentation for details.}
  TPDFXView = class(TObject)
  private
    FLastErrorMessage: string;
    FPageCount: Integer;
  protected
    pDocument :PXVDocument;
    function CheckErrorAndUpdateMessage(hr: HRESULT): boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    {Unlocks the Tracer Software API... Ideally, this should be called before loading a file,
     as calling it will unload any loaded file.}
    function Unlock(LicenseKey: string; DeveloperCode: string): boolean;

    function LoadFile(const PDFFilename: string; Password: string = ''): boolean;
    function UnloadFile: boolean;
    function PageDimensions(PageNumber: integer; out width: Double; out height: Double): boolean;
	  function DrawPageToDC(
      hDC: HDC;
      PageNumber: integer;
      PageRect: TRect;
      DrawRect: TRect;
      Rotation: TPDFXViewerRotation = vrRotateNone;
      UseVectorRendering: boolean = False;
      RenderMode: TPXCV_RenderMode = pxvrm_Viewing): boolean;

    {Still to implement this function
    function DrawPageToDIBSection(PageNumber: integer; hDC: HDC;
      Rotation: TTrackerPDFViewerRotation = tpdfvrRotateNone; UseVectorRendering: boolean = False;
      hBaseDC: HDC; backcolor: COLORREF; pResDIBSection: PHBitmap; hSection: THandle; dwOffset: DWORD): HRESULT;
    }

    {LastErrorMessage
     This is the last error or warning/info message as produced by the CheckErrorOk function (
     See tracker documentation on Error handling)}
    property LastErrorMessage: string read FLastErrorMessage;

    property PageCount: Integer read FPageCount;
  end;

{==================================================================================================}

implementation

{--------------------------------------------------------------------------------------------------}
constructor TPDFXView.Create;
begin
  inherited Create;
end;

{--------------------------------------------------------------------------------------------------}
destructor TPDFXView.Destroy;
begin
  {Make sure we have unloaded}
  if pDocument <> 0 then begin
    UnloadFile;
  end;
  inherited Destroy;
end;

{--------------------------------------------------------------------------------------------------}
function TPDFXView.DrawPageToDC(
  hDC: HDC;
  PageNumber: integer;
  PageRect: TRect;
  DrawRect: TRect;
  Rotation: TPDFXViewerRotation;
  UseVectorRendering: boolean;
  RenderMode: TPXCV_RenderMode): boolean;
var
  PDFResult: HResult;
	Param: PXV_CommonRenderParameters;
begin
  Param.WholePageRect := @PageRect;
  Param.DrawRect := @DrawRect;

  case Rotation of
    vrRotateNone: Param.Flags := cardinal(pxvrpf_None);
    vrRotate90:   Param.Flags := cardinal(pxvrpf_Rotate_Rotate90CW);
    vrRotate180:  Param.Flags := cardinal(pxvrpf_Rotate_Rotate180);
    vrRotate270:  Param.Flags := cardinal(pxvrpf_Rotate_Rotate90CCW);
  else
    Param.Flags := cardinal(pxvrpf_None);
  end;

  {Not sure if we are supposed to Or this}
  if UseVectorRendering then Param.Flags := (Param.Flags or cardinal(pxvrpf_UseVectorRenderer));

  Param.RenderTarget := cardinal(RenderMode);

	PDFResult := PXCV_DrawPageToDC(pDocument, PageNumber, hDC, @Param);
	result := CheckErrorAndUpdateMessage(PDFResult);
end;

{--------------------------------------------------------------------------------------------------}
function TPDFXView.LoadFile(const PDFFilename: string; Password: string = ''): boolean;
var
  PDFResult: HResult;
begin
  result := True;

  if pDocument = 0 then begin
    {If we get here, then it is likley that unlock has not been called, so we shall try and init with no
     license Info...}
    PDFResult := PXCV_Init(@pDocument, nil, nil);
    result := CheckErrorAndUpdateMessage(PDFResult);

    if not result then FLastErrorMessage := 'Could not initialise PDF for reading with no license information.';
  end;

  if result then begin
    PDFResult := PXCV_ReadDocumentW(pDocument, PWChar(WideString(PDFFilename)), 0);

    if (PDFResult = HResult(PS_ERR_DocEncrypted)) then	begin
      PDFResult := PXCV_CheckPassword(pDocument, PByte(PChar(Password)), Length(Password));
      result := CheckErrorAndUpdateMessage(PDFResult);
      if result then begin
        PDFResult := PXCV_FinishReadDocument(pDocument, 0);
      end;
    end;

    result := result and CheckErrorAndUpdateMessage(PDFResult);
    if result then begin
      PDFResult := PXCV_GetPagesCount(pDocument, @FPageCount);
      result := CheckErrorAndUpdateMessage(PDFResult);
    end;

    if not result then begin
      UnloadFile;
    end;
  end;
end;

{--------------------------------------------------------------------------------------------------}
function TPDFXView.PageDimensions(PageNumber: integer; out width, height: Double): boolean;
var
  PDFResult: HResult;
begin
  if pDocument = 0 then begin
    FLastErrorMessage := 'Document not initialised or loaded in getting PageDimensions.';
    result := False;
  end else begin
  	PDFResult := PXCV_GetPageDimensions(pDocument, PageNumber, @width, @height);
    result := CheckErrorAndUpdateMessage(PDFResult);
  end;
end;

{--------------------------------------------------------------------------------------------------}
function TPDFXView.UnloadFile: boolean;
var
  PDFResult: HResult;
begin
  PDFResult := PXCV_Delete(pDocument);

	result := CheckErrorAndUpdateMessage(PDFResult);

  if result then begin
    pDocument := 0;
    FPageCount := 0;
  end;
end;

{--------------------------------------------------------------------------------------------------}
function TPDFXView.Unlock(LicenseKey, DeveloperCode: string): boolean;
var
	PDFResult: HResult;
begin
  if pDocument <> 0 then begin
    PDFResult := PXCV_Delete(pDocument);
    pDocument := 0;
    FPageCount := 0;
    {We wont check the return value, if it fails to delete, we shall continue and init...}
  end;

	PDFResult := PXCV_Init(@pDocument, PAnsiChar(LicenseKey), PAnsiChar(DeveloperCode));
	result := CheckErrorAndUpdateMessage(PDFResult);
end;

{--------------------------------------------------------------------------------------------------}
function TPDFXView.CheckErrorAndUpdateMessage(hr: HRESULT): boolean;
var
	severityLen, facilityLen, descriptionLen: Integer;
	pBuf: array of Char;
	sMessage: string;
begin
	Result := true;

	if (IS_DS_ERROR(hr) or IS_DS_WARNING(hr)) then begin
		sMessage := '';
		severityLen := PXCV_Err_FormatSeverity(hr, nil, 0);
		facilityLen := PXCV_Err_FormatFacility(hr, nil, 0);
		descriptionLen := PXCV_Err_FormatErrorCode(hr, nil, 0);

		if (severityLen > 0) then	begin
			SetLength(pBuf, severityLen + 1);
			PXCV_Err_FormatSeverity(hr, PAnsiChar(pBuf), severityLen);
			sMessage := sMessage + PChar(pBuf);
		end;

		sMessage := sMessage + ' [';
		if (facilityLen > 0) then	begin
			SetLength(pBuf, facilityLen + 1);
			PXCV_Err_FormatFacility(hr, PAnsiChar(pBuf), facilityLen);
			sMessage := sMessage + PChar(pBuf);
		end;

		sMessage := sMessage + ']: ';
		if (descriptionLen > 0) then begin
			SetLength(pBuf, descriptionLen + 1);
			PXCV_Err_FormatErrorCode(hr, PAnsiChar(pBuf), descriptionLen);
			sMessage := sMessage + PChar(pBuf);
		end;

		pBuf := nil;
    FLastErrorMessage := sMessage;

		if (IS_DS_ERROR(hr)) then	Result := false;
	end;
end;

end.
