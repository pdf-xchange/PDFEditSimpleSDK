Imports System.Runtime.InteropServices

Module PXCE_Lib
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
	Private Const DLLName As String = "PDFXEditSimple.x64.dll"
#Else
	Private Const DLLName As String = "PDFXEditSimple.x86.dll"
#End If

	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_Init(ByRef Doc As IntPtr, Key As String, DevCode As String) As Integer
	End Function
	' Deinitialize PDF Object
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_Delete(ByVal Doc As IntPtr) As Integer
	End Function
	' Set callback function
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_SetCallBack(ByVal Doc As IntPtr, ByVal pProc As IntPtr, ByVal UserData As IntPtr) As Integer
	End Function

	' Read document
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_ReadDocumentW(ByVal Doc As IntPtr, <MarshalAs(UnmanagedType.LPWStr)> ByVal fname As String, ByVal flags As Integer) As Integer
	End Function
	' Check the password for encrypted document
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_CheckPassword(ByVal Doc As IntPtr, ByVal password() As Byte, ByVal passlen As Integer) As Integer
	End Function
	' Continue reading document after checking password
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_FinishReadDocument(ByVal Doc As IntPtr, ByVal flags As Integer) As Integer
	End Function
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_GetPagesCount(ByVal Doc As IntPtr, ByRef count As Integer) As Integer
	End Function
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_GetPageDimensions(ByVal Doc As IntPtr, ByVal page_num As Integer, ByRef width As Double, ByRef height As Double) As Integer
	End Function
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_GetPageRotation(ByVal Doc As IntPtr, ByVal page_num As Integer, ByRef angle As Integer) As Integer
	End Function
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_DrawPageToDC(ByVal Doc As IntPtr, ByVal page_num As Integer, ByVal hdc As IntPtr, ByRef parameters As PXV_CommonRenderParameters) As Integer
	End Function
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_DrawPageToDIBSection(ByVal Doc As IntPtr, ByVal page_num As Integer, ByRef parameters As PXV_CommonRenderParameters, ByVal hBaseDC As IntPtr, ByVal backcolor As Integer, ByRef pResDIBSection As IntPtr, ByVal hSection As IntPtr, ByVal dwOffset As Integer) As Integer
	End Function
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_ReleasePageCachedData(ByVal Doc As IntPtr, ByVal page_num As Integer, ByVal flags As Integer) As Integer
	End Function
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_ReleaseCachedData(ByVal Doc As IntPtr, ByVal flags As Integer) As Integer
	End Function
	' Error descriptions API
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_Err_FormatSeverity(ByVal errorcode As Integer, ByVal buf() As Byte, ByVal maxlen As Integer) As Integer
	End Function
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_Err_FormatFacility(ByVal errorcode As Integer, ByVal buf() As Byte, ByVal maxlen As Integer) As Integer
	End Function
	<DllImport(DLLName, CharSet:=CharSet.Auto)>
	Public Function PXCV_Err_FormatErrorCode(ByVal errorcode As Integer, ByVal buf() As Byte, ByVal maxlen As Integer) As Integer
	End Function

End Module
