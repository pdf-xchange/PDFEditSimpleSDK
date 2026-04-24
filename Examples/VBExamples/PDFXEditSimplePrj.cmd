@echo off
cd  PDFXEditSimple

rem C:\Users\root\AppData\Local\Temp\RarSFX1\AutoPlay\Docs\Portable.VB6\Vb6.exe /m D:\Project\Repos.github\PDFEditSimpleSDK\Examples\VBExamples\PDFXEditSimple\PDFXEditSimplePrj.vbp /outdir bin

set LINKMY=C:\Users\root\AppData\Local\Temp\RarSFX1\AutoPlay\Docs\Portable.VB6\Link.exe
%LINKMY% /OUT:PDFXEditSimplePrj.exe AboutDlg.OBJ frmMain.OBJ frmPassword.OBJ PDFXEditSimpleLib.OBJ PXCXErrors.OBJ

