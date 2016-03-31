program PDFXScrollBoxDelphi;

uses
  Forms,
  MainFrame in 'MainFrame.pas' {MainFrm},
  PDFXScrollBox in 'PDFXScrollBox.pas',
  PDFXEdit in 'PDFXEdit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'PDFScrollBox Delphi 3.6 Demo';
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
