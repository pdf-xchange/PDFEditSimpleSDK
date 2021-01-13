unit MainFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PDFXEditSimple, ComCtrls, ExtCtrls, StdCtrls, ToolWin, Menus,
  StdActns, ActnList, ImgList, System.ImageList, System.Actions;

type
  TForm1 = class(TForm)
	StatusBar1: TStatusBar;
	MainMenu1: TMainMenu;
	File1: TMenuItem;
	Open1: TMenuItem;
	Exit1: TMenuItem;
	Actions1: TMenuItem;
	Close1: TMenuItem;
	N1: TMenuItem;
	FirstPage1: TMenuItem;
	PrevPage1: TMenuItem;
	NextPage1: TMenuItem;
	LastPage1: TMenuItem;
	N2: TMenuItem;
	ActualSize1: TMenuItem;
	ZoomIn1: TMenuItem;
	ZoomOut1: TMenuItem;
	ActionList1: TActionList;
	FileClose: TAction;
	aFirstPage: TAction;
	FileExit: TFileExit;
	FileOpen: TFileOpen;
	aPrevPage: TAction;
	aNextPage: TAction;
	aLastPage: TAction;
	aActualSize: TAction;
	aZoomIn: TAction;
	aZoomOut: TAction;
	ToolBar1: TToolBar;
	PaintBox1: TPaintBox;
	ToolButton1: TToolButton;
	ImageList1: TImageList;
	ToolButton2: TToolButton;
	ToolButton3: TToolButton;
	ToolButton4: TToolButton;
	ToolButton5: TToolButton;
	ToolButton6: TToolButton;
	ToolButton7: TToolButton;
	ToolButton8: TToolButton;
	ToolButton9: TToolButton;
	ToolButton10: TToolButton;
	aFitPage: TAction;
	ToolButton11: TToolButton;
	FitPage1: TMenuItem;
	sbHorizontal: TScrollBar;
	sbVertical: TScrollBar;
    Print1: TMenuItem;
    PrintDlg1: TPrintDlg;
	procedure FormCreate(Sender: TObject);
	procedure FormClose(Sender: TObject; var Action: TCloseAction);
	procedure FileOpenBeforeExecute(Sender: TObject);
	procedure FileCloseExecute(Sender: TObject);
	procedure FileOpenAccept(Sender: TObject);
	procedure PaintBox1Paint(Sender: TObject);
	procedure FormResize(Sender: TObject);
	procedure aFirstPageExecute(Sender: TObject);
	procedure aPrevPageExecute(Sender: TObject);
	procedure aNextPageExecute(Sender: TObject);
	procedure aLastPageExecute(Sender: TObject);
	procedure aFitPageExecute(Sender: TObject);
	procedure aActualSizeExecute(Sender: TObject);
	procedure aZoomInExecute(Sender: TObject);
	procedure aZoomOutExecute(Sender: TObject);
    procedure sbHorizontalChange(Sender: TObject);
    procedure sbVerticalChange(Sender: TObject);
    procedure PrintDlg1BeforeExecute(Sender: TObject);
    procedure PrintDlg1Accept(Sender: TObject);
  private
	{ Private declarations }
	m_pDocument :PXVDocument;
	m_nPagesCount: DWORD;
	m_nCurPage: DWORD;
	m_nWidthPage, m_nHeightPage: Double;
	m_rWholePage: TRect;
	m_rDrawPage: TRect;
	m_bFitPage: boolean;
	m_nZoomFactor: Integer;
	m_ScrollPos: TPoint;
  public
	{ Public declarations }
	function ErrorCheck(hr: HRESULT; bErrorOnly: BOOL = false): boolean;
	procedure RecalcLayout;
	procedure UpdatePageInfo;
  end;

var
  Form1: TForm1;

implementation

uses PasswdDlg, Types, Printers;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
	m_pDocument := 0;
	m_nPagesCount := 0;
	m_nCurPage := 0;
	m_bFitPage := True;
	m_nZoomFactor := 100;
	aFitPage.Checked := m_bFitPage;
	m_ScrollPos.X := 0;
	m_ScrollPos.Y := 0;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	FileCloseExecute(Sender);
end;

procedure TForm1.FileOpenBeforeExecute(Sender: TObject);
begin
	FileCloseExecute(Sender);
end;

procedure TForm1.FileCloseExecute(Sender: TObject);
begin
	if(m_pDocument <> 0)then
		PXCV_Delete(m_pDocument);
	m_pDocument := 0;
	m_nPagesCount := 0;
end;

procedure TForm1.FileOpenAccept(Sender: TObject);
var
	sKey, sDevCode: PAnsiChar;
	Res: HResult;
begin
	FileCloseExecute(Sender);
	sKey := '<Enter here valid key>';
	sDevCode := '<Enter here valid developer''s code>';
	Res := PXCV_Init(@m_pDocument, PAnsiChar(sKey), PAnsiChar(sDevCode));
	if(not ErrorCheck(Res))then
		Exit;

	Res := PXCV_ReadDocumentW(m_pDocument, PWChar(WideString(FileOpen.Dialog.FileName)), 0);
	if(Res = Hresult(PS_ERR_DocEncrypted)) then
	begin
		Application.CreateForm(TPasswordDlg, PasswordDlg);
		if(PasswordDlg.ShowModal = mrOK) then
		begin
			Res := PXCV_CheckPassword(m_pDocument, PByte(PChar(PasswordDlg.Password.Text)), Length(PasswordDlg.Password.Text));
			if(not ErrorCheck(Res))then
			begin
				FileCloseExecute(Sender);
				Exit;
			end;
			Res := PXCV_FinishReadDocument(m_pDocument, 0);
		end;
		PasswordDlg.Free;
		PasswordDlg := nil;
	end;
	if(not ErrorCheck(Res))then
	begin
		FileCloseExecute(Sender);
		Exit;
	end;

	res := PXCV_GetPagesCount(m_pDocument, @m_nPagesCount);
	if(not ErrorCheck(Res))then
	begin
		FileCloseExecute(Sender);
		Exit;
	end;

	m_nCurPage := 0;
	UpdatePageInfo;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

function TForm1.ErrorCheck(hr: HRESULT; bErrorOnly: BOOL): boolean;
var
	sevLen, facLen, descLen: Integer;
	pBuf: array of Char;
	sMess: string;
begin
	Result := true;
	if(IS_DS_ERROR(hr) or IS_DS_WARNING(hr))then
	begin
		sMess := '';
		sevLen := PXCV_Err_FormatSeverity(hr, nil, 0);
		facLen := PXCV_Err_FormatFacility(hr, nil, 0);
		descLen := PXCV_Err_FormatErrorCode(hr, nil, 0);

		if(sevLen > 0)then
		begin
			SetLength(pBuf, sevLen + 1);
			PXCV_Err_FormatSeverity(hr, PAnsiChar(pBuf), sevLen);
			sMess := sMess + PChar(pBuf);
		end;

		sMess := sMess + ' [';
		if(facLen > 0)then
		begin
			SetLength(pBuf, facLen + 1);
			PXCV_Err_FormatFacility(hr, PAnsiChar(pBuf), facLen);
			sMess := sMess + PChar(pBuf);
		end;

		sMess := sMess + ']: ';
		if(descLen > 0)then
		begin
			SetLength(pBuf, descLen + 1);
			PXCV_Err_FormatErrorCode(hr, PAnsiChar(pBuf), descLen);
			sMess := sMess + PChar(pBuf);
		end;
		pBuf := nil;

		StatusBar1.Panels[0].Text := sMess;

		if(IS_DS_ERROR(hr))then
			Result := false;
		Exit;
	end;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
	Res: HResult;
	Param: PXV_CommonRenderParameters;
begin
	if(m_pDocument = 0) then
		Exit;

	Param.WholePageRect := @m_rWholePage;
	if(m_bFitPage)then
		Param.DrawRect := nil
	else
		Param.DrawRect := @m_rDrawPage;

	Param.RenderTarget := 0;
	Param.Flags := 0;

	with m_rWholePage do
		PaintBox1.Canvas.Rectangle(Left - 1, Top - 1, Right + 1, Bottom + 1);
	Res := PXCV_DrawPageToDC(m_pDocument, m_nCurPage, PaintBox1.Canvas.Handle, @Param);
	ErrorCheck(Res);
end;

procedure TForm1.UpdatePageInfo;
var
	s: String;
begin
	if(m_pDocument = 0) then
		Exit;
	PXCV_GetPageDimensions(m_pDocument, m_nCurPage, @m_nWidthPage, @m_nHeightPage);

	s := 'Page ' + IntToStr(m_nCurPage + 1) + ' of ' + IntToStr(m_nPagesCount);
	StatusBar1.Panels[1].Text := s;

	aFirstPage.Enabled := not (m_nCurPage <= 0);
	aPrevPage.Enabled := not (m_nCurPage <= 0);
	aNextPage.Enabled := not (m_nCurPage + 1 >= m_nPagesCount);
	aLastPage.Enabled := not (m_nCurPage + 1 >= m_nPagesCount);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
	if(Width > 110) then
		StatusBar1.Panels[0].Width := Width - 150;
	RecalcLayout;
end;

procedure TForm1.aFirstPageExecute(Sender: TObject);
begin
	m_nCurPage := 0;
	UpdatePageInfo;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

procedure TForm1.aPrevPageExecute(Sender: TObject);
begin
	if(m_nCurPage = 0) then
		Exit;
	m_nCurPage := m_nCurPage - 1;
	UpdatePageInfo;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

procedure TForm1.aNextPageExecute(Sender: TObject);
begin
	if(m_nCurPage + 1 >= m_nPagesCount) then
		Exit;
	m_nCurPage := m_nCurPage + 1;
	UpdatePageInfo;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

procedure TForm1.aLastPageExecute(Sender: TObject);
begin
	if(m_nPagesCount = 0)then
		Exit;
	m_nCurPage := m_nPagesCount - 1;
	UpdatePageInfo;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

procedure TForm1.aFitPageExecute(Sender: TObject);
begin
	m_bFitPage := not m_bFitPage;
	aFitPage.Checked := m_bFitPage;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

procedure TForm1.aActualSizeExecute(Sender: TObject);
begin
	m_bFitPage := false;
	aFitPage.Checked := m_bFitPage;
	m_nZoomFactor := 100;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

procedure TForm1.aZoomInExecute(Sender: TObject);
begin
	m_bFitPage := false;
	aFitPage.Checked := m_bFitPage;

	m_nZoomFactor := (m_nZoomFactor + 1) div 10 * 3 div 2 * 10;
	if(m_nZoomFactor > 1600) then
		m_nZoomFactor := 1600;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

procedure TForm1.aZoomOutExecute(Sender: TObject);
begin
	m_bFitPage := false;
	aFitPage.Checked := m_bFitPage;

	m_nZoomFactor := m_nZoomFactor div 10 * 3 div 4 * 10;
	if(m_nZoomFactor < 25) then
		m_nZoomFactor := 25;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

procedure TForm1.RecalcLayout;
var
	k: Double;
	w,h: Integer;
begin
	if((m_nHeightPage = 0) or (m_nWidthPage = 0))then
		Exit;

	if(m_bFitPage)then
	begin
		sbVertical.Visible := False;
		sbHorizontal.Visible := False;

		k := m_nWidthPage / m_nHeightPage;

		w := PaintBox1.Width - 2;
		h := PaintBox1.Height - 2;
		if(h < 1)then
			h := 1;
		if(k < w / h)then
			w := Round(k * h)
		else
			h := Round(w / k);
		with m_rWholePage do
		begin
			Left := (PaintBox1.Width - w) div 2;
			Top := (PaintBox1.Height - h) div 2;
			Right := Left + w;
			Bottom := Top + h;
		end;
		m_nZoomFactor := Round((w / 96) / (m_nWidthPage / 72) * 100);
	end
	else
	begin
		w := Round((m_nWidthPage / 72) * 96 * m_nZoomFactor / 100);
		h := Round((m_nHeightPage / 72) * 96 * m_nZoomFactor / 100);
		if (w + 2 <= PaintBox1.Width) then
		begin
			sbHorizontal.Visible := False;
			m_rWholePage.Left := (PaintBox1.Width - w) div 2;
			m_rWholePage.Right := m_rWholePage.Left + w;
			m_rDrawPage.Left := m_rWholePage.Left;
			m_rDrawPage.Right := m_rWholePage.Right;
			m_ScrollPos.x := 0;
		end
		else
		begin
			with sbHorizontal do
			begin
				Visible := True;
				PageSize := PaintBox1.Width - 2;
				Position := m_ScrollPos.X;
				Max := w + 2;

				if(Position + PageSize > Max)then
				begin
					Position := Max - PageSize;
					m_ScrollPos.X := Position;
				end;

				SmallChange := PaintBox1.Width div 10;
				LargeChange := PaintBox1.Width div 2;
				UpdateControlState;
			end;

			m_rWholePage.Left := -m_ScrollPos.X;
			m_rWholePage.Right := m_rWholePage.Left + w;
			m_rDrawPage.Left := 0;
			m_rDrawPage.Right := PaintBox1.Width;
		end;

		if (h + 2 <= PaintBox1.Height) then
		begin
			sbVertical.Visible := False;
			m_rWholePage.Top := (PaintBox1.Height - h) div 2;
			m_rWholePage.Bottom := m_rWholePage.Top + h;
			m_rDrawPage.Top := m_rWholePage.Top;
			m_rDrawPage.Bottom := m_rWholePage.Bottom;
			m_ScrollPos.y := 0;
		end
		else
		begin
			with sbVertical do
			begin
				Visible := True;
				PageSize := PaintBox1.Height - 2;
				Position := m_ScrollPos.Y;
				Max := h + 2;

				if(Position + PageSize > Max)then
				begin
					Position := Max - PageSize;
					m_ScrollPos.Y := Position;
				end;

				SmallChange := PaintBox1.Height div 10;
				LargeChange := PaintBox1.Height div 2;
				UpdateControlState;
			end;

			m_rWholePage.Top := -m_ScrollPos.Y;
			m_rWholePage.Bottom := m_rWholePage.Top + h;
			m_rDrawPage.Top := 0;
			m_rDrawPage.Bottom := PaintBox1.Height;
		end;
	end;

	StatusBar1.Panels[2].Text := IntToStr(m_nZoomFactor) + '%';
end;

procedure TForm1.sbHorizontalChange(Sender: TObject);
begin
	with sbHorizontal do
	begin
		if(Position + PageSize > Max) and (PageSize < Max) then
			Position := Max - PageSize;
		m_ScrollPos.X := Position;
	end;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

procedure TForm1.sbVerticalChange(Sender: TObject);
begin
	with sbVertical do
	begin
		if(Position + PageSize > Max) and (PageSize < Max) then
			Position := Max - PageSize;
		m_ScrollPos.Y := Position;
	end;
	RecalcLayout;
	PaintBox1.Invalidate;
end;

procedure TForm1.PrintDlg1BeforeExecute(Sender: TObject);
begin
  PrintDlg1.Dialog.MinPage := 1;
  PrintDlg1.Dialog.ToPage := m_nPagesCount;
  PrintDlg1.Dialog.MaxPage := m_nPagesCount;
end;

procedure TForm1.PrintDlg1Accept(Sender: TObject);
var CurrPage:DWORD;
	PrintParams:PXV_CommonRenderParameters;
	PrintRect:TRect;
begin
  Printer.BeginDoc;
  if (PrintDlg1.Dialog.PrintRange = prAllPages) then
  begin
	  PrintDlg1.Dialog.MinPage := 1;
	  PrintDlg1.Dialog.ToPage := m_nPagesCount;
  end;
  for CurrPage := PrintDlg1.Dialog.FromPage to PrintDlg1.Dialog.ToPage do
	begin
	  PrintRect := Printer.Canvas.ClipRect;
	  PrintParams.WholePageRect := @PrintRect;
	  PrintParams.DrawRect := nil;
	  PrintParams.Flags := pxvrpf_UseVectorRenderer;
	  PrintParams.RenderTarget := pxvrm_Printing;

	  PXCV_DrawPageToDC(m_pDocument, CurrPage - 1, Printer.Canvas.Handle, @PrintParams);

      if Integer(CurrPage) < PrintDlg1.Dialog.ToPage then
        Printer.NewPage;
    end;
  Printer.EndDoc;
end;

end.
