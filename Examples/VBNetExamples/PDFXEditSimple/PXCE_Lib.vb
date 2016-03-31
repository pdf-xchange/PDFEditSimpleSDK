Imports System.Runtime.InteropServices

Public Class PXCE_Lib
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

	Public Enum PXV_CommonRenderParametersFlags
		pxvrpf_None = &H0
		pxvrpf_Rotate_NoRotate = &H0
		pxvrpf_Rotate_Rotate90CW = &H1
		pxvrpf_Rotate_Rotate180 = &H2
		pxvrpf_Rotate_Rotate90CCW = &H3
		pxvrpf_Rotate_RotateMask = &H3
		pxvrpf_UseVectorRenderer = &H4
	End Enum

	<StructLayout(LayoutKind.Sequential, Pack:=1)>
	Structure PXV_CommonRenderParameters
		Public WholePageRect As IntPtr
		Public DrawRect As IntPtr
		Public flags As Integer
		Public RenderTarget As PXCV_RenderMode
	End Structure

#If Win64 Then
	Public Declare Function PXCV_Init Lib "PDFXEditSimple.x64" (ByRef Doc As Integer, ByVal Key As String, ByVal DevCode As String) As Integer
	' Deinitialize PDF Object
	Public Declare Function PXCV_Delete Lib "PDFXEditSimple.x64" (ByVal Doc As Integer) As Integer
	' Set callback function
	Public Declare Function PXCV_SetCallBack Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, ByVal pProc As Integer, ByVal UserData As Integer) As Integer
	' Read document
	Public Declare Function PXCV_ReadDocumentW Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, <MarshalAs(UnmanagedType.LPWStr)> ByVal fname As String, ByVal flags As Integer) As Integer
	' Check the password for encrypted document
	Public Declare Function PXCV_CheckPassword Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, ByVal password() As Byte, ByVal passlen As Integer) As Integer
	' Continue reading document after checking password
	Public Declare Function PXCV_FinishReadDocument Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, ByVal flags As Integer) As Integer

	Public Declare Function PXCV_GetPagesCount Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, ByRef count As Integer) As Integer

	Public Declare Function PXCV_GetPageDimensions Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, ByVal page_num As Integer, ByRef width As Double, ByRef height As Double) As Integer

	Public Declare Function PXCV_GetPageRotation Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, ByVal page_num As Integer, ByRef angle As Integer) As Integer

	Public Declare Function PXCV_DrawPageToDC Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, ByVal page_num As Integer, ByVal hdc As IntPtr, ByRef parameters As PXV_CommonRenderParameters) As Integer

	Public Declare Function PXCV_DrawPageToDIBSection Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, ByVal page_num As Integer, ByRef parameters As PXV_CommonRenderParameters, ByVal hBaseDC As Integer, ByVal backcolor As Integer, ByRef pResDIBSection As Integer, ByVal hSection As Integer, ByVal dwOffset As Integer) As Integer

	Public Declare Function PXCV_ReleasePageCachedData Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, ByVal page_num As Integer, ByVal flags As Integer) As Integer

	Public Declare Function PXCV_ReleaseCachedData Lib "PDFXEditSimple.x64" (ByVal Doc As Integer, ByVal flags As Integer) As Integer
	' Error descriptions API
	Public Declare Function PXCV_Err_FormatSeverity Lib "PDFXEditSimple.x64" (ByVal errorcode As Integer, ByVal buf() As Byte, ByVal maxlen As Integer) As Integer
	Public Declare Function PXCV_Err_FormatFacility Lib "PDFXEditSimple.x64" (ByVal errorcode As Integer, ByVal buf() As Byte, ByVal maxlen As Integer) As Integer
	Public Declare Function PXCV_Err_FormatErrorCode Lib "PDFXEditSimple.x64" (ByVal errorcode As Integer, ByVal buf() As Byte, ByVal maxlen As Integer) As Integer
#Else
	Public Declare Function PXCV_Init Lib "PDFXEditSimple.x86" (ByRef Doc As Integer, ByVal Key As String, ByVal DevCode As String) As Integer
	' Deinitialize PDF Object
	Public Declare Function PXCV_Delete Lib "PDFXEditSimple.x86" (ByVal Doc As Integer) As Integer
	' Set callback function
	Public Declare Function PXCV_SetCallBack Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, ByVal pProc As Integer, ByVal UserData As Integer) As Integer
	' Read document
	Public Declare Function PXCV_ReadDocumentW Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, <MarshalAs(UnmanagedType.LPWStr)> ByVal fname As String, ByVal flags As Integer) As Integer
	' Check the password for encrypted document
	Public Declare Function PXCV_CheckPassword Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, ByVal password() As Byte, ByVal passlen As Integer) As Integer
	' Continue reading document after checking password
	Public Declare Function PXCV_FinishReadDocument Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, ByVal flags As Integer) As Integer

	Public Declare Function PXCV_GetPagesCount Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, ByRef count As Integer) As Integer

	Public Declare Function PXCV_GetPageDimensions Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, ByVal page_num As Integer, ByRef width As Double, ByRef height As Double) As Integer

	Public Declare Function PXCV_GetPageRotation Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, ByVal page_num As Integer, ByRef angle As Integer) As Integer

	Public Declare Function PXCV_DrawPageToDC Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, ByVal page_num As Integer, ByVal hdc As IntPtr, ByRef parameters As PXV_CommonRenderParameters) As Integer

	Public Declare Function PXCV_DrawPageToDIBSection Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, ByVal page_num As Integer, ByRef parameters As PXV_CommonRenderParameters, ByVal hBaseDC As Integer, ByVal backcolor As Integer, ByRef pResDIBSection As Integer, ByVal hSection As Integer, ByVal dwOffset As Integer) As Integer

	Public Declare Function PXCV_ReleasePageCachedData Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, ByVal page_num As Integer, ByVal flags As Integer) As Integer

	Public Declare Function PXCV_ReleaseCachedData Lib "PDFXEditSimple.x86" (ByVal Doc As Integer, ByVal flags As Integer) As Integer
	' Error descriptions API
	Public Declare Function PXCV_Err_FormatSeverity Lib "PDFXEditSimple.x86" (ByVal errorcode As Integer, ByVal buf() As Byte, ByVal maxlen As Integer) As Integer
	Public Declare Function PXCV_Err_FormatFacility Lib "PDFXEditSimple.x86" (ByVal errorcode As Integer, ByVal buf() As Byte, ByVal maxlen As Integer) As Integer
	Public Declare Function PXCV_Err_FormatErrorCode Lib "PDFXEditSimple.x86" (ByVal errorcode As Integer, ByVal buf() As Byte, ByVal maxlen As Integer) As Integer
#End If


End Class
