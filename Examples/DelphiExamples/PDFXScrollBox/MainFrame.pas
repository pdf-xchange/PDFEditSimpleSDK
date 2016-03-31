unit MainFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, PDFXScrollBox, ImgList, ExtCtrls, StdCtrls, Spin,
  System.ImageList;

type
  TMainFrm = class(TForm)
    PDFScrollBox: TPDFScrollBox;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    PrintDialog1: TPrintDialog;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton13: TToolButton;
    cboZoomMode: TComboBox;
    chkHoriz: TCheckBox;
    chkVert: TCheckBox;
    chkDoubleBufferFullRepaints: TCheckBox;
    Panel1: TPanel;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    pnlZoom: TPanel;
    lblZoom: TLabel;
    chkContinuous: TCheckBox;
    pnlPage: TPanel;
    ToolButton6: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure cboZoomModeChange(Sender: TObject);
    procedure chkVertClick(Sender: TObject);
    procedure chkHorizClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure chkDoubleBufferFullRepaintsClick(Sender: TObject);
    procedure PDFScrollBoxZoomChange(Sender: TObject);
    procedure chkContinuousClick(Sender: TObject);
    procedure PDFScrollBoxCurrentPageChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.dfm}

procedure TMainFrm.cboZoomModeChange(Sender: TObject);
begin                       {We make sure the items in the combo are in the correct order}
  PDFScrollBox.ZoomMode := TPDFScrollBoxZoomMode(cboZoomMode.ItemIndex);
end;

procedure TMainFrm.chkContinuousClick(Sender: TObject);
begin
  PDFScrollBox.ContinuousPageMode := chkContinuous.Checked;
end;

procedure TMainFrm.chkDoubleBufferFullRepaintsClick(Sender: TObject);
begin
  PDFScrollBox.DoubleBufferFullRepaints := chkDoubleBufferFullRepaints.Checked;
end;

procedure TMainFrm.chkHorizClick(Sender: TObject);
begin
  PDFScrollBox.CenterPageHorizontally := chkHoriz.Checked
end;

procedure TMainFrm.chkVertClick(Sender: TObject);
begin
  PDFScrollBox.CenterPageVertically := chkVert.Checked
end;

procedure TMainFrm.PDFScrollBoxCurrentPageChange(Sender: TObject);
begin
  pnlPage.Caption := 'Page ' + IntToStr(PDFScrollBox.CurrentPage) + ' of ' + IntToStr(PDFScrollBox.PageCount);
end;

procedure TMainFrm.PDFScrollBoxZoomChange(Sender: TObject);
begin
  lblZoom.Caption := IntToStr(PDFScrollBox.ZoomPercent) + '%'; 
end;

procedure TMainFrm.SpinEdit1Change(Sender: TObject);
begin
  PDFScrollBox.FocusFrameWidth := SpinEdit1.Value;
end;

procedure TMainFrm.ToolButton10Click(Sender: TObject);
begin
  PDFScrollBox.ZoomMode := zmFullPage;
end;

procedure TMainFrm.ToolButton13Click(Sender: TObject);
begin
  if PrintDialog1.Execute then begin
    PDFScrollBox.Print();
  end;
end;

procedure TMainFrm.ToolButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    PDFScrollBox.LoadPDFFile(OpenDialog1.FileName);
  end;
end;

procedure TMainFrm.ToolButton2Click(Sender: TObject);
begin
  PDFScrollBox.GotoFirstPage;
end;

procedure TMainFrm.ToolButton3Click(Sender: TObject);
begin
  PDFScrollBox.GotoPreviousPage;
end;

procedure TMainFrm.ToolButton4Click(Sender: TObject);
begin
  PDFScrollBox.GotoNextPage;
end;

procedure TMainFrm.ToolButton5Click(Sender: TObject);
begin
  PDFScrollBox.GotoLastPage;
end;

procedure TMainFrm.ToolButton7Click(Sender: TObject);
begin
  PDFScrollBox.ZoomPercent := 100;
  cboZoomMode.ItemIndex := 0;
end;

procedure TMainFrm.ToolButton8Click(Sender: TObject);
begin
  PDFScrollBox.ZoomPercent := PDFScrollBox.ZoomPercent + 10;
  cboZoomMode.ItemIndex := 0;
end;

procedure TMainFrm.ToolButton9Click(Sender: TObject);
begin
  PDFScrollBox.ZoomPercent := PDFScrollBox.ZoomPercent - 10;
  cboZoomMode.ItemIndex := 0;
end;

end.
