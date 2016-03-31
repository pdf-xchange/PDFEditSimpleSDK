Attribute VB_Name = "PXCVLib"
Option Explicit

Enum PXV36_CallbackStage
    PXCVClb_Start = 1
    PXCVClb_Processing
    PXCVClb_Finish
End Enum

Enum PXCV_RenderMode
    pxvrm_Viewing = 0
    pxvrm_Printing
    pxvrm_Exporting
End Enum

Enum PXCV_ReleaseCachedDataFlags
    pxvrcd_ReleaseDocumentImages = &H1
    pxvrcd_ReleaseDocumentFonts = &H2
    pxvrcd_ReleaseGlobalFonts = &H4
End Enum

Enum PXV_CommonRenderParametersFlags
    pxvrpf_None = &H0
    pxvrpf_Rotate_NoRotate = &H0
    pxvrpf_Rotate_Rotate90CW = &H1
    pxvrpf_Rotate_Rotate180 = &H2
    pxvrpf_Rotate_Rotate90CCW = &H3
    pxvrpf_Rotate_RotateMask = &H3
    pxvrpf_UseVectorRenderer = &H4
End Enum

Type PXV_CommonRenderParameters
     WholePageRect As Long
     DrawRect As Long
     flags As Long
     RenderTarget As Long
End Type

Public Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

#Const Win64 = False

#If Win64 Then
    Public Declare Function PXCV_Init Lib "PDFXEditSimple.x64.dll" (ByRef Doc As Long, ByVal Key As String, ByVal DevCode As String) As Long
    ' Deinitialize PDF Object
    Public Declare Function PXCV_Delete Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long) As Long
    ' Set callback function
    Public Declare Function PXCV_SetCallBack Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByVal pProc As Long, ByVal UserData As Long) As Long
    ' Read document
    Public Declare Function PXCV_ReadDocumentW Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByVal fname As String, ByVal flags As Long) As Long
    ' Check the password for encrypted document
    Public Declare Function PXCV_CheckPassword Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByRef password As Byte, ByVal passlen As Long) As Long
    ' Continue reading document after checking password
    Public Declare Function PXCV_FinishReadDocument Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByVal flags As Long) As Long
    
    Public Declare Function PXCV_GetPagesCount Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByRef count As Long) As Long
    
    Public Declare Function PXCV_GetPageDimensions Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByVal page_num As Long, ByRef width As Double, ByRef height As Double) As Long
    
    Public Declare Function PXCV_GetPageRotation Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByVal page_num As Long, ByRef angle As Long) As Long
    
    Public Declare Function PXCV_DrawPageToDC Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByVal page_num As Long, ByVal hdc As Long, parameters As PXV_CommonRenderParameters) As Long
    
    Public Declare Function PXCV_DrawPageToDIBSection Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByVal page_num As Long, parameters As PXV_CommonRenderParameters, ByVal hBaseDC As Long, ByVal backcolor As Long, ByRef pResDIBSection As Long, ByVal hSection As Long, ByVal dwOffset As Long) As Long
    
    Public Declare Function PXCV_ReleasePageCachedData Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByVal page_num As Long, ByVal flags As Long) As Long
    
    Public Declare Function PXCV_ReleaseCachedData Lib "PDFXEditSimple.x64.dll" (ByVal Doc As Long, ByVal flags As Long) As Long
    ' Error descriptions API
    Public Declare Function PXCV_Err_FormatSeverity Lib "PDFXEditSimple.x64.dll" (ByVal errorcode As Long, ByVal buf As Long, ByVal maxlen As Long) As Long
    Public Declare Function PXCV_Err_FormatFacility Lib "PDFXEditSimple.x64.dll" (ByVal errorcode As Long, ByVal buf As Long, ByVal maxlen As Long) As Long
    Public Declare Function PXCV_Err_FormatErrorCode Lib "PDFXEditSimple.x64.dll" (ByVal errorcode As Long, ByVal buf As Long, ByVal maxlen As Long) As Long
#Else
    Public Declare Function PXCV_Init Lib "PDFXEditSimple.x86.dll" (ByRef Doc As Long, ByVal Key As String, ByVal DevCode As String) As Long
    ' Deinitialize PDF Object
    Public Declare Function PXCV_Delete Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long) As Long
    ' Set callback function
    Public Declare Function PXCV_SetCallBack Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByVal pProc As Long, ByVal UserData As Long) As Long
    ' Read document
    Public Declare Function PXCV_ReadDocumentW Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByVal fname As String, ByVal flags As Long) As Long
    ' Check the password for encrypted document
    Public Declare Function PXCV_CheckPassword Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByRef password As Byte, ByVal passlen As Long) As Long
    ' Continue reading document after checking password
    Public Declare Function PXCV_FinishReadDocument Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByVal flags As Long) As Long
    
    Public Declare Function PXCV_GetPagesCount Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByRef count As Long) As Long
    
    Public Declare Function PXCV_GetPageDimensions Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByVal page_num As Long, ByRef width As Double, ByRef height As Double) As Long
    
    Public Declare Function PXCV_GetPageRotation Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByVal page_num As Long, ByRef angle As Long) As Long
    
    Public Declare Function PXCV_DrawPageToDC Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByVal page_num As Long, ByVal hdc As Long, parameters As PXV_CommonRenderParameters) As Long
    
    Public Declare Function PXCV_DrawPageToDIBSection Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByVal page_num As Long, parameters As PXV_CommonRenderParameters, ByVal hBaseDC As Long, ByVal backcolor As Long, ByRef pResDIBSection As Long, ByVal hSection As Long, ByVal dwOffset As Long) As Long
    
    Public Declare Function PXCV_ReleasePageCachedData Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByVal page_num As Long, ByVal flags As Long) As Long
    
    Public Declare Function PXCV_ReleaseCachedData Lib "PDFXEditSimple.x86.dll" (ByVal Doc As Long, ByVal flags As Long) As Long
    ' Error descriptions API
    Public Declare Function PXCV_Err_FormatSeverity Lib "PDFXEditSimple.x86.dll" (ByVal errorcode As Long, ByVal buf As Long, ByVal maxlen As Long) As Long
    Public Declare Function PXCV_Err_FormatFacility Lib "PDFXEditSimple.x86.dll" (ByVal errorcode As Long, ByVal buf As Long, ByVal maxlen As Long) As Long
    Public Declare Function PXCV_Err_FormatErrorCode Lib "PDFXEditSimple.x86.dll" (ByVal errorcode As Long, ByVal buf As Long, ByVal maxlen As Long) As Long
#End If

'
Public Function PXCV_VB_ReadDocumentW(ByVal lPDF As Long, ByVal sFileIn As String, ByVal lFlag As Long) As Long
    On Error Resume Next
    Dim sFilename As String
    Dim lRet As Long
    sFilename = StrConv(sFileIn, vbUnicode)
    lRet = PXCV_ReadDocumentW(lPDF, sFilename, 0)
    PXCV_VB_ReadDocumentW = lRet
End Function

'

Function BytesToString(b() As Byte) As String
    Dim i As Long
    Dim z As String
    i = 1
    Do While (b(i) <> 0)
        z = z & Chr(b(i))
        i = i + 1
    Loop
    BytesToString = z
End Function


Sub StringToBytes(ByRef a() As Byte, ByVal s As String)
    Dim i As Long
    Dim z As String
    For i = 1 To Len(s)
        z = Mid(s, i, 1)
        a(i - 1) = Asc(z)
    Next
    a(i - 1) = 0
End Sub

Sub StringToBytesW(ByRef a() As Byte, ByVal s As String)
    Dim i As Long
    Dim j As Long
    Dim z As String
    For i = 1 To Len(s)
        z = Mid(s, i, 1)
        a(j) = Asc(z)
        a(j + 1) = 0
        j = j + 2
    Next
End Sub
