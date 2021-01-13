program PDFXEditSimpleDelphi;

uses
  Forms,
  MainFrame in 'MainFrame.pas' {Form1},
  PasswdDlg in 'PasswdDlg.pas' {PasswordDlg},
  PDFXEditSimple in '..\..\..\Include\PDFXEditSimple.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'PDFXC Viewer 3.6 Demo [Delphi]';
  Application.CreateForm(TForm1, Form1);
  PasswordDlg := nil;
  Application.Run;
end.
