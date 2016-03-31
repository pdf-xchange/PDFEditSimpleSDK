unit PDFXScrollBox;
{------------------------------------------------------------------------------------------
  Defines TPDFScrollBox, a component that descends from TScrollingWinControl and uses the
  Docu-track PDF view DLL facilities, to provide an easy to use PDF viewer which can then
  be imbedded into other applications.

  Author: C Fraser, Hill Laboratories

  This file is free to use and refine as necessary. It has been provided to Tracker Software
  as a better Delphi Example for them to use as they see fit.

  If you refine it/bug fix it, I would really appreciate an update (email IT@hill-labs.co.nz)
 ------------------------------------------------------------------------------------------}
interface

uses
  Windows, Controls, Types, Classes, Messages, Graphics, Forms, ExtCtrls, PDFXEdit;

type
{==================================================================================================}
  TPDFScrollBoxZoomMode = (zmPercent,
                           zmFullPage,
                           zmPageWidth,
                           zmPageHeight);

  {:TPDFScrollBox
    This is the control that wraps the TPDFXView object (which itself is a wrapper for the Docu-Track
    viewer DLL.
    We have decided to inherit from TScrollingWinControl rather than TScrollBox so we can hide some
    unneeded properties that, for some reason were exposed in TScrollBox, even though they don't work
    properly (eg. the Bevel properties)}
  TPDFScrollBox = class(TScrollingWinControl)
  private
    FCenterPageVertically: Boolean;
    FCenterPageHorizontally: Boolean;
    FPageCount: integer;
    FCurrentPage: integer;
    FFocusFrameColorFocused: TColor;
    FFocusFrameColorNonFocused: TColor;
    FFocusFrameWidth: Integer;
    FLastErrorMessage: string;
    FPDFUserPassword: string;
    FPDFLoaded: Boolean;
    FUnlockDeveloperCode: string;
    FUnlocked: Boolean;
    FUnlockLicenseKey: string;
    FZoomMode: TPDFScrollBoxZoomMode;
    FZoomPercent: Integer;
    FZoomPercentMax: Integer;
    FZoomPercentMin: Integer;
    FBorderStyle: TBorderStyle;
    FContinuousPageMode: Boolean;
    {:FDocumentRect
      This is in screen pixels, but does not include zoom factor (ie. is 100%)}
    FDocumentRect: TRect;
    FDoubleBufferFullRepaints: Boolean;
    FOnCurrentPageChange: TNotifyEvent;
    FOnZoomChange: TNotifyEvent;
    FPageBorder: Integer;
    {:FPageMaxHeight
      The width of the document is the max width of all pages, this the max height of all the pages}
    FPageMaxHeight: Integer;
    {:FPageRects
      This is in screen pixels, but does not include zoom factor (ie. is 100%)}
    FPageRects: array of TRect;
    FPageSeparation: Integer;
    FPreciseZoomPercent: Double; {Integer rounding is not good enough for what we are doing}
    function RectHeight(Rect: TRect): integer;
    procedure CheckUnlock;
    procedure ScrollImageBottom;
    procedure ScrollImageDownLine;
    procedure ScrollImageDownPage;
    procedure ScrollImageLeft;
    procedure ScrollImageRight;
    procedure ScrollImageTop;
    procedure ScrollImageUpLine;
    procedure ScrollImageUpPage;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure SetCenterPageVertically(const Value: Boolean);
    procedure SetCenterPageHorizontally(const Value: Boolean);
    procedure SetCurrentPage(const Value: integer);
    procedure SetFocusFrameColorFocused(const Value: TColor);
    procedure SetFocusFrameColorNonFocused(const Value: TColor);
    procedure SetFocusFrameWidth(const Value: Integer);
    procedure SetUnlockDeveloperCode(const Value: string);
    procedure SetUnlockLicenseKey(const Value: string);
    procedure SetZoomMode(const Value: TPDFScrollBoxZoomMode);
    procedure SetZoomPercent(const Value: Integer);
    procedure SetZoomPercentMax(const Value: Integer);
    procedure SetZoomPercentMin(const Value: Integer);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure WMNCHitTest(var Message: TMessage); message WM_NCHITTEST;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure SetContinuousPageMode(const Value: Boolean);
    procedure SetPageBorder(const Value: Integer);
    procedure SetPageSeparation(const Value: Integer);
    function RectWidth(Rect: TRect): integer;
    procedure TranslatePageRectToViewRect(var PageRect: TRect);
    procedure ScaleRectToZoom(var Rect: TRect);
  protected
    FPDFXView: TPDFXView;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DrawNonClientArea;
    procedure RecalculateZoomAndScrollbars;

    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMPaint(var Message: TMessage); message WM_PAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure GotoFirstPage;
    procedure GotoPreviousPage;
    procedure GotoPage(PageNum: integer);
    procedure GotoNextPage;
    procedure GotoLastPage;

    procedure UnloadPDF;
    function LoadPDFFile(PDFFileName: string): boolean;

    property PageCount: integer read FPageCount;

    {:TPDFScrollBox.CurrentPage
      This is the current page in a 1 based index. Note that the private PageRects var and the Docu-Track
      view DLL are zero based... (we may change this later to avoid confusion!)}
    property CurrentPage: integer read FCurrentPage write SetCurrentPage;

    {:TPDFScrollBox.LastErrorMessage
      The last error message reported from the Docu-Track view DLL}
    property LastErrorMessage: string read FLastErrorMessage;

    {:TPDFScrollBox.PDFLoaded
      True if a PDF document has successfully been loaded}
    property PDFLoaded: Boolean read FPDFLoaded;

    {:TPDFScrollBox.Print
      This is a farily simple print funcionality, it prints to the current printer in the Delphi
      Printer unit, using the previously setup bins, etc.}
    function Print(StartPage: integer = 1; EndPage: integer = 0): boolean;
  published
    property CenterPageHorizontally: Boolean read FCenterPageHorizontally write SetCenterPageHorizontally default True;
    property CenterPageVertically: Boolean read FCenterPageVertically write SetCenterPageVertically default True;
    property FocusFrameColorFocused: TColor read FFocusFrameColorFocused write SetFocusFrameColorFocused default clSkyBlue;
    property FocusFrameColorNonFocused: TColor read FFocusFrameColorNonFocused write
        SetFocusFrameColorNonFocused default clBtnFace;

    {:TPDFScrollBox.FocusFrameWidth
      If you want to indicate to the user that the control has focus, you can set this to a
      value > zero. If you don't want to show the user that this has focus (eg. it is the one and
      only control, the main window for example, then you probably want to set this to zero.}
    property FocusFrameWidth: Integer read FFocusFrameWidth write SetFocusFrameWidth default 2;

    property PDFUserPassword: string read FPDFUserPassword write FPDFUserPassword;

    {:TPDFScrollBox.ZoomPercent
      This is the zoom percent rounded to an integer... we may change this to a float in the future.}
    property ZoomPercent: Integer read FZoomPercent write SetZoomPercent;

    property ZoomPercentMax: Integer read FZoomPercentMax write SetZoomPercentMax default 1000;
    property ZoomPercentMin: Integer read FZoomPercentMin write SetZoomPercentMin default 10;
    property UnlockDeveloperCode: string read FUnlockDeveloperCode write SetUnlockDeveloperCode;
    // Can't tell if we unlocked succefully or if we are in demo mode... so we wan't use this property
    // property Unlocked: Boolean read FUnlocked;
    property UnlockLicenseKey: string read FUnlockLicenseKey write SetUnlockLicenseKey;
    property ZoomMode: TPDFScrollBoxZoomMode read FZoomMode write SetZoomMode;

    {:TPDFScrollBox.ContinuousPageMode
      If True, shows the pages one after the other. Allows the user to easly scroll through the document.
      If False, one page at a time is shown.}
    property ContinuousPageMode: Boolean read FContinuousPageMode write SetContinuousPageMode default true;

    {:TPDFScrollBox.DoubleBufferFullRepaints
      Just an attempt to reduce flicker, particulaly when resizing a window.
      When off, you may get better draw performance.}
    property DoubleBufferFullRepaints: Boolean read FDoubleBufferFullRepaints write
        FDoubleBufferFullRepaints default False;

    {:TPDFScrollBox.PageBorder
      Gap between drawn page and client window.}
    property PageBorder: Integer read FPageBorder write SetPageBorder default 4;

    {:TPDFScrollBox.PageSeparation
      Gap between pages, only relevant in Continuous mode.}
    property PageSeparation: Integer read FPageSeparation write SetPageSeparation default 8;

    property OnCurrentPageChange: TNotifyEvent read FOnCurrentPageChange write FOnCurrentPageChange;
    property OnZoomChange: TNotifyEvent read FOnZoomChange write FOnZoomChange;

    property Align;
    property Anchors;
    property AutoScroll default True;
    property BiDiMode;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsNone;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Color default clAppWorkSpace;
    property Ctl3D;
    //property Padding; //not exist in 7.0 yet
    property ParentBiDiMode;
    property ParentBackground default False;
    property ParentColor;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    //property OnMouseActivate; //not exist in 7.0 yet
    property OnMouseDown;
    //property OnMouseEnter; //not exist in 7.0 yet
    //property OnMouseLeave; //not exist in 7.0 yet
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;
{==================================================================================================}
procedure Register;

implementation

uses
  SysUtils, Math, Printers;

{==================================================================================================}
procedure Register;
begin
  RegisterComponents('Miscellaneous', [TPDFScrollBox]);
end;
{==================================================================================================}

{ TPDFImageScrollBox }
{==================================================================================================}
procedure TPDFScrollBox.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then RecreateWnd;
  {Need to cause a resize so the NC area can be sized correctly}
  inherited;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;

  // We want to handle the arrow keys ourselves
  if Msg.CharCode in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN] then Msg.Result := 1;
end;

{--------------------------------------------------------------------------------------------------}
constructor TPDFScrollBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents, csSetCaption, csDoubleClicks];//, csPannable]; //not exist in 7.0 yet
  AutoScroll := True;
  Width := 180;
  Height := 180;
  FBorderStyle := bsNone;

  VertScrollBar.Tracking := True;
  HorzScrollBar.Tracking := True;
  VertScrollBar.Visible := True;
  HorzScrollBar.Visible := True;

  FPageCount := 0;
  FCurrentPage := 0;
  FLastErrorMessage := '';

  FZoomPercent := 100;
  FZoomPercentMin := 10;
  FZoomPercentMax := 1000;

  FFocusFrameColorFocused := clSkyBlue;
  FFocusFrameColorNonFocused := clBtnFace;
  FFocusFrameWidth := 2;

  FCenterPageHorizontally := True;
  FCenterPageVertically := True;
  FContinuousPageMode := True;

  FPageSeparation := 8;
  FPageBorder := 4;

  Color := clAppWorkSpace;

  TabStop := True;

  FPDFXView := TPDFXView.Create;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;

{--------------------------------------------------------------------------------------------------}
destructor TPDFScrollBox.Destroy;
begin
  UnloadPDF;
  FPDFXView.Free;

  inherited;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.CheckUnlock;
begin
  if (FUnlockLicenseKey <> '') and (FUnlockDeveloperCode <> '') then begin
    //Try and unlock the PDF Viewer API
    FUnlocked := FPDFXView.Unlock(FUnlockLicenseKey, FUnlockDeveloperCode);
    FLastErrorMessage := FPDFXView.LastErrorMessage;
  end;
end;

{--------------------------------------------------------------------------------------------------}
function TPDFScrollBox.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  result := inherited DoMouseWheelDown(Shift, MousePos);

  if not result then ScrollImageDownLine;

  result := True; {Setting this to true stops a double scroll from occuring.}
end;

{--------------------------------------------------------------------------------------------------}
function TPDFScrollBox.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  result := inherited DoMouseWheelUp(Shift, MousePos);

  if not result then ScrollImageUpLine;

  result := True; {Setting this to true stops a double scroll from occuring.}
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.ScrollImageUpLine;
var
  OldHorizScroll: integer;
begin
  if VertScrollBar.Position = 0 then begin
    if FPDFLoaded and (FCurrentPage > 1) then begin
      OldHorizScroll := HorzScrollBar.Position;
      GotoPreviousPage;
      HorzScrollBar.Position := OldHorizScroll;
      Perform(WM_VSCROLL, SB_BOTTOM, 0);
    end;
  end else begin
    Perform(WM_VSCROLL, SB_LINEUP, 0);
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.ScrollImageDownLine;
var
  OldHorizScroll: integer;
begin
  if VertScrollBar.Position >= VertScrollBar.Range - ClientHeight then begin
    if FPDFLoaded and (FCurrentPage < FPageCount) then begin
      OldHorizScroll := HorzScrollBar.Position;
      GotoNextPage;
      HorzScrollBar.Position := OldHorizScroll;
      Perform(WM_VSCROLL, SB_TOP, 0);
    end;
  end else begin
    Perform(WM_VSCROLL, SB_LINEDOWN, 0);
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.ScrollImageLeft;
begin
  if HorzScrollBar.Position > 0 then begin
    Perform(WM_HSCROLL, SB_LINELEFT, 0);
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.ScrollImageRight;
begin
  if HorzScrollBar.Position < HorzScrollBar.Range - ClientWidth then begin
    Perform(WM_HSCROLL, SB_LINERIGHT, 0);
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.ScrollImageDownPage;
var
  OldHorizScroll: integer;
begin
  if VertScrollBar.Position >= VertScrollBar.Range - ClientHeight then begin
    if FPDFLoaded and (FCurrentPage < FPageCount) then begin
      OldHorizScroll := HorzScrollBar.Position;
      GotoNextPage;
      HorzScrollBar.Position := OldHorizScroll;
      Perform(WM_VSCROLL, SB_TOP, 0);
    end;
  end else begin
    Perform(WM_VSCROLL, SB_PAGEDOWN, 0);
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.ScrollImageUpPage;
var
  OldHorizScroll: integer;
begin
  if VertScrollBar.Position = 0 then begin
    if FPDFLoaded and (FCurrentPage > 1) then begin
      OldHorizScroll := HorzScrollBar.Position;
      GotoPreviousPage;
      HorzScrollBar.Position := OldHorizScroll;
      Perform(WM_VSCROLL, SB_BOTTOM, 0);
    end;
  end else begin
    Perform(WM_VSCROLL, SB_PAGEUP, 0);
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.ScrollImageTop;
begin
  Perform(WM_VSCROLL, SB_TOP, 0);
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.ScrollImageBottom;
begin
  Perform(WM_VSCROLL, SB_BOTTOM, 0);
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_UP:     ScrollImageUpLine;
    VK_DOWN:   ScrollImageDownLine;
    VK_LEFT:   ScrollImageLeft;
    VK_RIGHT:  ScrollImageRight;
    VK_NEXT:   ScrollImageDownPage;
    VK_PRIOR:  ScrollImageUpPage;
    VK_HOME:   if FPDFLoaded then GotoFirstPage
                             else ScrollImageTop;
    VK_END:    if FPDFLoaded then GotoLastPage
                             else ScrollImageBottom;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.GotoFirstPage;
begin
  if FPageCount > 0 then begin
    CurrentPage := 1;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.GotoPage(PageNum: integer);
begin
  if (PageNum > 0) and (PageNum <= FPageCount) then begin
    CurrentPage := PageNum;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.GotoLastPage;
begin
  if FPageCount > 0 then begin
    CurrentPage := FPageCount;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.GotoNextPage;
begin
  if (FPageCount > 0) and (FCurrentPage < FPageCount) then begin
    CurrentPage := CurrentPage + 1;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.GotoPreviousPage;
begin
  if (FPageCount > 0) and (FCurrentPage > 1) then begin
    CurrentPage := CurrentPage - 1;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.RecalculateZoomAndScrollbars;
var
  PreciseZoomPercentFitWidth: Double;
  PreciseZoomPercentFitHeight: Double;
  NewZoom: integer;
begin
  if FPDFLoaded then begin
    {We adjust the zoom percent based on the ZoomMode settings...}
    if ZoomMode = zmPercent then begin
      FPreciseZoomPercent := ZoomPercent;
    end else begin
      if ContinuousPageMode then begin
        {In Continuous mode we zoom based on the largest page size.}
        PreciseZoomPercentFitWidth  := ClientWidth / FDocumentRect.Right * 100;
        PreciseZoomPercentFitHeight := ClientHeight / FPageMaxHeight * 100;
      end else begin
        PreciseZoomPercentFitWidth  := (ClientWidth / (RectWidth(FPageRects[FCurrentPage - 1]) + 2 * FPageBorder)) * 100;
        PreciseZoomPercentFitHeight := (ClientHeight / (RectHeight(FPageRects[FCurrentPage - 1]) + 2 * FPageBorder)) * 100;
      end;

      if      ZoomMode = zmPageWidth  then FPreciseZoomPercent := PreciseZoomPercentFitWidth
      else if ZoomMode = zmPageHeight then FPreciseZoomPercent := PreciseZoomPercentFitHeight
      else                                 FPreciseZoomPercent := Min(PreciseZoomPercentFitWidth, PreciseZoomPercentFitHeight);

      {Set the integer Zoom percent in case it is used for display purposes...}
      NewZoom := Round(FPreciseZoomPercent);
      if NewZoom <> FZoomPercent  then begin
        FZoomPercent := NewZoom;
        if Assigned(FOnZoomChange) then FOnZoomChange(self);
      end;
    end;

    if ContinuousPageMode then begin
      VertScrollBar.Range := Round(FDocumentRect.Bottom * FPreciseZoomPercent / 100);
      HorzScrollBar.Range := Round(FDocumentRect.Right * FPreciseZoomPercent / 100);
    end else begin
      {The pageRect is already indented by the PageBorder}
      VertScrollBar.Range := Round((RectHeight(FPageRects[FCurrentPage - 1]) + 2 * FPageBorder) * FPreciseZoomPercent / 100);
      HorzScrollBar.Range := Round((FPageRects[FCurrentPage - 1].Right + FPageBorder) * FPreciseZoomPercent / 100);
    end;

    VertScrollBar.Increment := ClientHeight div 10; {10 seems to be about right...}
  end else begin
    VertScrollBar.Range := 0;
    HorzScrollBar.Range := 0;
  end;
end;

{--------------------------------------------------------------------------------------------------}
function TPDFScrollBox.RectHeight(Rect: TRect): integer;
begin
  result := Rect.Bottom - Rect.Top + 1;
end;

{--------------------------------------------------------------------------------------------------}
function TPDFScrollBox.RectWidth(Rect: TRect): integer;
begin
  result := Rect.Right - Rect.Left + 1;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.UnloadPDF;
begin
  FPDFXView.UnloadFile;
  FLastErrorMessage := FPDFXView.LastErrorMessage;

  Invalidate;
  FPDFLoaded := False;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.DrawNonClientArea;
var
  DC: HDC;
  WindowRect: TRect;
  DrawRect: TRect;
  OldBrushColor: TColor;
  ClientRect: TRect;
  WinStyle: Longint;
  VertScrollBarWidth: integer;
  HorizScrollBarHieght: integer;
begin
  DC := GetWindowDC(Handle);

  try
    OldBrushColor := Brush.Color;

    if Focused then Brush.Color := FFocusFrameColorFocused
               else Brush.Color := FFocusFrameColorNonFocused;

    Windows.GetClientRect(Handle, ClientRect);
    GetWindowRect(Handle, WindowRect);
    MapWindowPoints(0, Handle, WindowRect, 2);
    OffsetRect(ClientRect, -WindowRect.Left, -WindowRect.Top);
    ExcludeClipRect(DC, ClientRect.Left, ClientRect.Top, ClientRect.Right, ClientRect.Bottom);

    InflateRect(ClientRect, FFocusFrameWidth, FFocusFrameWidth);

    VertScrollBarWidth := 0;
    HorizScrollBarHieght := 0;

    WindowRect := ClientRect;
    with WindowRect do begin
      WinStyle := GetWindowLong(Handle, GWL_STYLE);

      if (WinStyle and WS_VSCROLL) <> 0 then VertScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL);
      if (WinStyle and WS_HSCROLL) <> 0 then HorizScrollBarHieght := GetSystemMetrics(SM_CYHSCROLL);

      Inc(Right, VertScrollBarWidth);
      Inc(Bottom, HorizScrollBarHieght);
    end;

    DrawRect := WindowRect;
    DrawRect.Bottom := DrawRect.Top + FFocusFrameWidth;
    FillRect(DC, DrawRect, Brush.Handle);

    DrawRect := WindowRect;
    DrawRect.Left := DrawRect.Right - FFocusFrameWidth;
    FillRect(DC, DrawRect, Brush.Handle);

    DrawRect := WindowRect;
    DrawRect.Top := DrawRect.Bottom - FFocusFrameWidth;
    FillRect(DC, DrawRect, Brush.Handle);

    DrawRect := WindowRect;
    DrawRect.Right := DrawRect.Left + FFocusFrameWidth;
    FillRect(DC, DrawRect, Brush.Handle);

    {We seem to need to paint the area below the vert and right of the horiz scroll bars}
    Brush.Color := clBtnFace;
    DrawRect := WindowRect;
    DrawRect.Left := DrawRect.Right - VertScrollBarWidth;
    DrawRect.Top := DrawRect.Bottom - HorizScrollBarHieght;
    OffsetRect(DrawRect, -FFocusFrameWidth, -FocusFrameWidth);
    FillRect(DC, DrawRect, Brush.Handle);

    Brush.Color := OldBrushColor;
  finally
    ReleaseDC(Handle, DC);
  end;
end;

{--------------------------------------------------------------------------------------------------}
function TPDFScrollBox.LoadPDFFile(PDFFileName: string): boolean;
var
  i: integer;
  wPageInPoints: Double;
  hPageInPoints: Double;
  CurrentTop: integer;
begin
  UnloadPDF;

  {if not FUnlocked then }CheckUnlock;

  result := FPDFXView.LoadFile(PDFFilename, FPDFUserPassword);
  FLastErrorMessage := FPDFXView.LastErrorMessage;

  if result then begin
    FPageCount := FPDFXView.PageCount;
    FLastErrorMessage := FPDFXView.LastErrorMessage;
    FCurrentPage := 1;
    FPDFLoaded := True;

    SetLength(FPageRects, FPageCount);
    SetRectEmpty(FDocumentRect);
    FPageMaxHeight := 0;
    CurrentTop := FPageBorder;
    for i := 0 to FPageCount - 1 do begin
      FPDFXView.PageDimensions(i, wPageInPoints, hPageInPoints);

      FPageRects[i].Left := FPageBorder; {If pages are centered, we shall reset this after knowing the full doc width}
      FPageRects[i].Right := FPageRects[i].Left + Round(Screen.PixelsPerInch * wPageInPoints / 72);
      FPageRects[i].Top := CurrentTop;
      FPageRects[i].Bottom := CurrentTop + Round(Screen.PixelsPerInch * hPageInPoints / 72);
      CurrentTop := FPageRects[i].Bottom + FPageSeparation;

      FDocumentRect.Right := max(FDocumentRect.Right, FPageRects[i].Right + FPageBorder);
      FDocumentRect.Bottom := FPageRects[i].Bottom + FPageBorder;
      FPageMaxHeight := max(FPageMaxHeight, FPageRects[i].Bottom - FPageRects[i].Top + 1 + FPageSeparation);
    end;

    RecalculateZoomAndScrollbars;
    if Assigned(FOnCurrentPageChange) then FOnCurrentPageChange(Self);
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if TabStop and not self.Focused then self.SetFocus;
end;

{--------------------------------------------------------------------------------------------------}
function TPDFScrollBox.Print(StartPage: integer = 1; EndPage: integer = 0): boolean;
var
  PageIndex: integer;
	PrintRect: TRect;
begin
  Result := true;
  if EndPage = 0 then EndPage := FPageCount;

  if (StartPage >= 1) and (StartPage <= EndPage) then begin
//    PrintRect := Printer.Canvas.ClipRect; //This scales to the print area page... below we print 'over' the print area

    PrintRect := Rect(0, 0, GetDeviceCaps(Printer.Handle, PHYSICALWIDTH), GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT));
    OffsetRect(PrintRect, -GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX), -GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY));

    Printer.BeginDoc;

    for PageIndex := StartPage to EndPage do begin
      FPDFXView.DrawPageToDC(Printer.Canvas.Handle, PageIndex - 1, PrintRect, PrintRect, vrRotateNone, True, pxvrm_Printing);
      FLastErrorMessage := FPDFXView.LastErrorMessage;
      if PageIndex < EndPage then begin
        Printer.NewPage;
      end;
    end;

    Printer.EndDoc;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetCenterPageVertically(const Value: Boolean);
begin
  FCenterPageVertically := Value;
  Invalidate;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetCenterPageHorizontally(const Value: Boolean);
begin
  FCenterPageHorizontally := Value;
  Invalidate;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetContinuousPageMode(const Value: Boolean);
begin
  FContinuousPageMode := Value;
  RecalculateZoomAndScrollbars;
  Invalidate;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetCurrentPage(const Value: integer);
var
  CurrentPageRect: TRect;
  ToPageRect: TRect;
  NewScrollPos: integer;
begin
  if FCurrentPage <> Value then begin
    if not FContinuousPageMode then begin
      FCurrentPage := Value;
      RecalculateZoomAndScrollbars;
      Invalidate;
      if Assigned(FOnCurrentPageChange) then FOnCurrentPageChange(Self);
    end else begin
      {Get the current position of the page, calculate where we should be in the scroll range
       to match the position (if we can) and move as close to it as we can.}
      CurrentPageRect := FPageRects[FCurrentPage - 1];
      TranslatePageRectToViewRect(CurrentPageRect);

      ToPageRect := FPageRects[Value - 1];
      TranslatePageRectToViewRect(ToPageRect);

      NewScrollPos := VertScrollBar.Position - (CurrentPageRect.Top - ToPageRect.Top);

      // Don't need to do this checking as the scroll bar position will set itself to the min
      // or max values anyway.
      // NewScrollPos := Max(0, NewScrollPos);
      // NewScrollPos := Min(NewScrollPos, VertScrollBar.Range - client etc...);

      VertScrollBar.Position := NewScrollPos;

      if Assigned(FOnCurrentPageChange) then FOnCurrentPageChange(Self);
    end;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetFocusFrameColorFocused(const Value: TColor);
begin
  FFocusFrameColorFocused := Value;
  Perform(CM_BORDERCHANGED, 0, 0);
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetFocusFrameColorNonFocused(const Value: TColor);
begin
  FFocusFrameColorFocused := Value;
  Perform(CM_BORDERCHANGED, 0, 0);
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetFocusFrameWidth(const Value: Integer);
begin
  FFocusFrameWidth := Value;
  Perform(CM_BORDERCHANGED, 0, 0);
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetPageBorder(const Value: Integer);
begin
  if FPageBorder <> Value then begin
    FPageBorder := Value;
    RecalculateZoomAndScrollbars;
    Invalidate;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetPageSeparation(const Value: Integer);
begin
  if FPageSeparation <> Value then begin
    FPageSeparation := Value;
    RecalculateZoomAndScrollbars;
    Invalidate;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetUnlockDeveloperCode(const Value: string);
begin
  FUnlockDeveloperCode := Value;
  CheckUnlock();
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetUnlockLicenseKey(const Value: string);
begin
  FUnlockLicenseKey := Value;
  CheckUnlock();
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetZoomMode(const Value: TPDFScrollBoxZoomMode);
begin
  if (FZoomMode <> Value) then begin
    FZoomMode := Value;
    if FZoomMode <> zmPercent then begin
      //If ZoomMode changes to percent, then we don't need to redraw until the ZoomPercent is set.
      RecalculateZoomAndScrollbars;
      Invalidate;
    end;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetZoomPercent(const Value: Integer);
var
  OldValue: Integer;
begin
  OldValue := FZoomPercent;
  FZoomMode := zmPercent;

  if Value <> FZoomPercent then begin
    FZoomPercent := Max(Min(FZoomPercentMax, Value), FZoomPercentMin);
    if OldValue <> Value then begin
      RecalculateZoomAndScrollbars;
      Invalidate;
      if Assigned(FOnZoomChange) then FOnZoomChange(self);
    end;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetZoomPercentMax(const Value: Integer);
begin
  FZoomPercentMax := Value;

  if ZoomPercent > FZoomPercentMax then begin
    ZoomPercent := FZoomPercentMax;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.SetZoomPercentMin(const Value: Integer);
begin
  FZoomPercentMin := Value;

  if ZoomPercent < FZoomPercentMin then begin
    ZoomPercent := FZoomPercentMin;
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  {We don't want to erase the background, we shall draw the whole thing in the paint.}
  Message.Result := 1;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.WMHScroll(var Message: TWMHScroll);
begin
  inherited;
  if TabStop and not self.Focused then self.SetFocus;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.WMKillFocus(var Message: TWMSetFocus);
begin
  inherited;
  Perform(CM_BORDERCHANGED, 0, 0); {This causes a repaint}
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  inherited;

  InflateRect(Message.CalcSize_Params^.rgrc[0], -FFocusFrameWidth, -FFocusFrameWidth);
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.WMNCHitTest(var Message: TMessage);
begin
  DefaultHandler(Message);
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.WMNCPaint(var Message: TMessage);
begin
  inherited;
  DrawNonClientArea;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.ScaleRectToZoom(var Rect: TRect);
begin
  Rect.Left   := Round(Rect.Left   * FPreciseZoomPercent / 100);
  Rect.Top    := Round(Rect.Top    * FPreciseZoomPercent / 100);
  Rect.Right  := Round(Rect.Right  * FPreciseZoomPercent / 100);
  Rect.Bottom := Round(Rect.Bottom * FPreciseZoomPercent / 100);
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.TranslatePageRectToViewRect(var PageRect: TRect);
var
  PageWidth: Integer;
  PageHeight: Integer;
begin
  {Before we scale, move the non contious page for the border... continuous pages are already spaced out.}
  if not ContinuousPageMode then OffsetRect(PageRect, 0, FPageBorder - PageRect.Top);

  ScaleRectToZoom(PageRect);

  PageWidth := RectWidth(PageRect) + 2 * FPageBorder; {Todo: This (and the one below) Page Border are not scaled... still seems to work Ok...}
  if FCenterPageHorizontally and (PageWidth < ClientWidth) then begin
    OffsetRect(PageRect, (ClientWidth - PageWidth) div 2, 0);
  end;

  if ContinuousPageMode then begin
    {If the whole document (all pages) will be shown, then we will center them all}
    PageHeight := Round(FDocumentRect.Bottom * FPreciseZoomPercent / 100);
  end else begin
    PageHeight := RectHeight(PageRect) + 2 * FPageBorder;
  end;

  if CenterPageVertically and (PageHeight < ClientHeight) then begin
    OffsetRect(PageRect, 0, (ClientHeight - PageHeight) div 2);
  end;

  OffsetRect(PageRect, -HorzScrollBar.Position, -VertScrollBar.Position);
end;
{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.WMPaint(var Message: TMessage);
  {------------------------------------------------------------------------------------------------}
  procedure PaintAroundPageRect(DC: HDC; PageIndex: integer; PageRectInClientCoordinates: TRect; ClipRect: TRect);
  var
    OldBrushColor: TColor;
    PaintRect: TRect;
    NextPageRect: TRect;
  begin
    OldBrushColor := Brush.Color;
    Brush.Color := Color;

//    We have kept the below, because it is useful for debugging
//    case PageIndex of
//      0: Brush.Color := clYellow;
//      1: Brush.Color := clLime;
//      2: Brush.Color := clPurple;
//      3: Brush.Color := clAqua;
//    else
//      Brush.Color := clRed;
//    end;

    {Left of Page}
//    Brush.Color := clYellow;
    PaintRect := Rect(0, PageRectInClientCoordinates.Top, PageRectInClientCoordinates.Left, PageRectInClientCoordinates.Bottom);
    IntersectRect(PaintRect, PaintRect, ClipRect);
    if not IsRectEmpty(PaintRect) then FillRect(DC, PaintRect, Brush.Handle);

    {Right of Page}
//    Brush.Color := clYellow;
    PaintRect := Rect(PageRectInClientCoordinates.Right, PageRectInClientCoordinates.Top, ClientWidth, PageRectInClientCoordinates.Bottom);
    IntersectRect(PaintRect, PaintRect, ClipRect);
    if not IsRectEmpty(PaintRect) then FillRect(DC, Rect(PaintRect.Left, PaintRect.Top, PaintRect.Right + 1, PaintRect.Bottom + 1), Brush.Handle);

    {Top of first page or all pages if not continuous}
//    Brush.Color := clLime;
    if (PageIndex = 0) or not FContinuousPageMode then begin
      PaintRect := Rect(0, 0, ClientWidth, PageRectInClientCoordinates.Top);
      IntersectRect(PaintRect, PaintRect, ClipRect);
      if not IsRectEmpty(PaintRect) then FillRect(DC, PaintRect, Brush.Handle);
    end;

    {Bottom of the last Page or all pages if not continuous}
//    Brush.Color := clPurple;
    if (PageIndex = FPageCount - 1) or not FContinuousPageMode then begin
      PaintRect := Rect(0, PageRectInClientCoordinates.Bottom, ClientWidth, ClientHeight);
      IntersectRect(PaintRect, PaintRect, ClipRect);
      if not IsRectEmpty(PaintRect) then FillRect(DC, PaintRect, Brush.Handle);
    end;

    {Gap at the end of all the pages if continuous, except the last as that is done above}
//    Brush.Color := clAqua;
//    if (PageIndex < FPageCount - 1) and FContinuousPageMode then begin
//      PaintRect := Rect(0, PageRectInClientCoordinates.Bottom, ClientWidth, PageRectInClientCoordinates.Bottom + Round(FPageSeparation * FPreciseZoomPercent / 100));
//      IntersectRect(PaintRect, PaintRect, ClipRect);
//      if not IsRectEmpty(PaintRect) then FillRect(DC, PaintRect, Brush.Handle);
//    end;

    {To get an acurate placing for the bottom of the rect, we take the rect of the next page.
     We used to scale the page separation but got very occasional rounding errors.}
//    Brush.Color := clAqua;
    if (PageIndex < FPageCount - 1) and FContinuousPageMode then begin
      NextPageRect :=  FPageRects[PageIndex + 1];

      TranslatePageRectToViewRect(NextPageRect);

      PaintRect := Rect(0, PageRectInClientCoordinates.Bottom, ClientWidth, NextPageRect.Top);
      IntersectRect(PaintRect, PaintRect, ClipRect);
      if not IsRectEmpty(PaintRect) then FillRect(DC, PaintRect, Brush.Handle);
    end;

    Brush.Color := OldBrushColor;
  end;
  {------------------------------------------------------------------------------------------------}
  procedure PaintSinglePageToDC(DC: HDC);
  var
//    OldBrushColor: TColor;
    PageRect: TRect;
    ClipRect: TRect;
    IntersectingRect: TRect;
  begin
    {We paint the whole background to AppWorkspace and then draw the page rectable on top...
     This first FillRect seems not to occur until the following Rectangle function, so no
     blue strip flashes appear...}
    GetClipBox(DC, ClipRect);

//    We have kept the below, because it is useful for debugging
//    OldBrushColor := Brush.Color;
//    Brush.Color := clRed;
//    FillRect(DC, ClipRect, Brush.Handle);
//    Brush.Color := OldBrushColor;

    PageRect := FPageRects[FCurrentPage - 1];

    TranslatePageRectToViewRect(PageRect);

    PaintAroundPageRect(DC, FCurrentPage - 1, PageRect, ClipRect);

    IntersectRect(IntersectingRect, PageRect, ClipRect);
    if not IsRectEmpty(IntersectingRect) then begin
      Rectangle(DC, PageRect.Left, PageRect.Top, PageRect.Right + 1, PageRect.Bottom + 1);
      FPDFXView.DrawPageToDC(DC, FCurrentPage - 1, PageRect, IntersectingRect, vrRotateNone, False, pxvrm_Viewing);
      FLastErrorMessage := FPDFXView.LastErrorMessage;

      {Sometimes the DrawPage draws over the top left lines of the page, seems to depend on the
       pdf document as to whether the background is transparent or not. Tried adjusting the Page and
       Intersecting Rects, but this had adverse visual effects, so we just have resorted to redrawing
       the top and left lines.}
      MoveToEx(DC, PageRect.Left, PageRect.Bottom, nil);
      LineTo(DC, PageRect.Left, PageRect.Top);
      LineTo(DC, PageRect.Right, PageRect.Top);
    end;
  end;
  {------------------------------------------------------------------------------------------------}
  procedure PaintMultiPageToDC(DC: HDC);
  var
    ClipRect: TRect;
    PageRect: TRect;
    IntersectingRect: TRect;
    i: integer;
//    ClientCenter: Integer;
    ClosestPageDistanceToCenter: Integer;
    ClosestPageToCenter: Integer;
    DistanceToCenter: Integer;
//    OldBrushColor: TColor;
  begin
    GetClipBox(DC, ClipRect);

//    We have kept the below, because it is useful for debugging
//    OldBrushColor := Brush.Color;
//    Brush.Color := clRed;
//    FillRect(DC, ClipRect, Brush.Handle);
//    Brush.Color := OldBrushColor;

//    ClientCenter := ClientHeight div 2;
    ClosestPageToCenter := FCurrentPage - 1;
    ClosestPageDistanceToCenter := MaxInt;

    for i := 0 to Length(FPageRects) - 1 do begin
      PageRect := FPageRects[i];

      TranslatePageRectToViewRect(PageRect);

      {The clip rect might not be over the page, so we still want to paint around it.}
      PaintAroundPageRect(DC, i, PageRect, ClipRect);

      {We might move this out of paint as it doesn't have much to do with painting... while we are
       here, and in Multipage mode, we shall make the 'current' page, the one that is closest to
       the client center, later we call the OnCurrentPageChange if required.}
      DistanceToCenter := Abs(PageRect.Top + RectHeight(PageRect) div 2 - ClientHeight div 2);
      if DistanceToCenter < ClosestPageDistanceToCenter then begin
        ClosestPageDistanceToCenter := DistanceToCenter;
        ClosestPageToCenter := i;
      end;

      IntersectRect(IntersectingRect, PageRect, ClipRect);
      if not IsRectEmpty(IntersectingRect) then begin
        Rectangle(DC, PageRect.Left, PageRect.Top, PageRect.Right + 1, PageRect.Bottom + 1);
        FPDFXView.DrawPageToDC(DC, i, PageRect, IntersectingRect, vrRotateNone, False, pxvrm_Viewing);
        FLastErrorMessage := FPDFXView.LastErrorMessage;

        {Sometimes the DrawPage draws over the top and left lines of the page, seems to depend on the
         pdf document as to whether the background is transparent or not. Tried adjusting the Page and
         Intersecting Rects, but this had adverse visual effects, so we have just resorted to redrawing
         the top and left lines over the top of the page.}
        MoveToEx(DC, PageRect.Left, PageRect.Bottom, nil);
        LineTo(DC, PageRect.Left, PageRect.Top);
        LineTo(DC, PageRect.Right, PageRect.Top);
      end;
    end;

    if (FCurrentPage - 1 <> ClosestPageToCenter) then begin
      FCurrentPage := ClosestPageToCenter + 1;
      if Assigned(FOnCurrentPageChange) then FOnCurrentPageChange(Self);
    end;
  end;
  {------------------------------------------------------------------------------------------------}
var
  DC: HDC;
  PS: TPaintStruct;
//  TempRect: TRect;
  MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  ClipRect: TRect;
  OldBrushColor: TColor;
begin
  DC := BeginPaint(Handle, PS);
  try
    GetClipBox(DC, ClipRect);

    if FPDFLoaded then begin
      if FDoubleBufferFullRepaints and EqualRect(ClientRect, ClipRect) then begin
        MemBitmap := CreateCompatibleBitmap(DC, ClientRect.Right, ClientRect.Bottom);
        MemDC := CreateCompatibleDC(0);
        OldBitmap := SelectObject(MemDC, MemBitmap);
        try
          Perform(WM_ERASEBKGND, MemDC, MemDC);

          if FContinuousPageMode then PaintMultiPageToDC(MemDC)
                                 else PaintSinglePageToDC(MemDC);

          BitBlt(DC, 0, 0, ClientRect.Right, ClientRect.Bottom, MemDC, 0, 0, SRCCOPY);
        finally
          SelectObject(MemDC, OldBitmap);
          DeleteDC(MemDC);
          DeleteObject(MemBitmap);
        end;
      end else begin
        if FContinuousPageMode then PaintMultiPageToDC(DC)
                               else PaintSinglePageToDC(DC);
      end;
    end else begin
      {Draw Blank Page}
      OldBrushColor := Brush.Color;
      Brush.Color := Color;
      FillRect(DC, ClipRect, Brush.Handle);
      Brush.Color := OldBrushColor;
    end;
  finally
    EndPaint(Handle, PS);
  end;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  Perform(CM_BORDERCHANGED, 0, 0); {This causes a repaint}
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.WMSize(var Message: TWMSize);
begin
  inherited;
  RecalculateZoomAndScrollbars;
  Invalidate;
end;

{--------------------------------------------------------------------------------------------------}
procedure TPDFScrollBox.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  if TabStop and not self.Focused then self.SetFocus;
end;

{==================================================================================================}

end.

