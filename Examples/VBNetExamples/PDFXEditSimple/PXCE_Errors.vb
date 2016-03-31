Public Class PXCE_Errors
	Public Const PS_ERR_NOTIMPLEMENTED As Integer = &H821404B0 'Not implemented
	Public Const PS_ERR_INVALID_ARG As Integer = &H82140001 'Invalid argument
	Public Const PS_ERR_MEMALLOC As Integer = &H821403E8 'Insufficient memory
	Public Const PS_ERR_USER_BREAK As Integer = &H821401F4 'Operation aborted by user
	Public Const PS_ERR_INTERNAL As Integer = &H82140011 'Internal error
	Public Const PS_ERR_INVALID_FILE_FORMAT As Integer = &H82140002 'Invalid file format
	Public Const PS_ERR_REQUIRED_PROP_NOT_SET As Integer = &H82142716 'Required property is not set
	Public Const PS_ERR_INVALID_PROP_TYPE As Integer = &H82142717 'Invalid property type
	Public Const PS_ERR_INVALID_PROP_VALUE As Integer = &H82142718 'Invalid property value
	Public Const PS_ERR_INVALID_OBJECT_NUM As Integer = &H82142719 'Invalid object number
	Public Const PS_ERR_INVALID_PS_OPERATOR As Integer = &H8214271C 'Invalid PS operator
	Public Const PS_ERR_UNKNOWN_OPERATOR As Integer = &H82142787 'Unknown operator
	Public Const PS_ERR_INVALID_CONTENT_STATE As Integer = &H82142788 'Invalid content state
	Public Const PS_ERR_NoPassword As Integer = &H821427A8 'No password
	Public Const PS_ERR_UnknowCryptFlt As Integer = &H821427A9 'Unknown crypt filter
	Public Const PS_ERR_WrongPassword As Integer = &H821427AA 'Wrong password
	Public Const PS_ERR_InvlaidObjStruct As Integer = &H821427AB 'Invalid object structure
	Public Const PS_ERR_WrongEncryptDict As Integer = &H821427AC 'Invalid encryption dictionary
	Public Const PS_ERR_DocEncrypted As Integer = &H821427AD 'Document encrypted
	Public Const PS_ERR_DocNOTEncrypted As Integer = &H821427AE 'Document not encrypted
	Public Const PS_ERR_WrongObjStream As Integer = &H821427AF 'Invalid object stream
	Public Const PS_ERR_WrongTrailer As Integer = &H821427B0 'Invalid document trailer
	Public Const PS_ERR_WrongXRef As Integer = &H821427B1 'Invalid xref table
	Public Const PS_ERR_WrongDecodeParms As Integer = &H821427B2 'Invalid decode parameter(s)
	Public Const PS_ERR_XRefNotFounded As Integer = &H821427B3 'xref table is not foud
	Public Const PS_ERR_DocAlreadyRead As Integer = &H821427B4 'Document is already read
	Public Const PS_ERR_DocNotRead As Integer = &H821427B5 'Document is not read

	Public Shared Function IS_DS_SUCCESSFUL(ByVal x As Long) As Long
		IS_DS_SUCCESSFUL = ((x And &H80000000) = 0)
	End Function

	Public Shared Function IS_DS_FAILED(ByVal x As Long) As Long
		IS_DS_FAILED = ((x And &H80000000) <> 0)
	End Function

	Public Shared Sub ShowDSError(ByVal x As Long)
		Dim sevLen As Long
		Dim facLen As Long
		Dim descLen As Long

		Dim sevBuf() As Byte = Nothing
		Dim facBuf() As Byte = Nothing
		Dim descBuf() As Byte = Nothing

		sevLen = PXCE_Lib.PXCV_Err_FormatSeverity(x, sevBuf, 0)
		facLen = PXCE_Lib.PXCV_Err_FormatFacility(x, facBuf, 0)
		descLen = PXCE_Lib.PXCV_Err_FormatErrorCode(x, descBuf, 0)

		ReDim sevBuf(sevLen)
		ReDim facBuf(facLen)
		ReDim descBuf(descLen)

		Dim s As String = ""
		If (PXCE_Lib.PXCV_Err_FormatSeverity(x, sevBuf, sevLen) > 0) Then
			s = PXCE_Helper.BytesToString(sevBuf)
		End If
		s = s + " ["
		If (PXCE_Lib.PXCV_Err_FormatFacility(x, facBuf, facLen) > 0) Then
			s = s + PXCE_Helper.BytesToString(facBuf)
		End If
		s = s + "]: "
		If (PXCE_Lib.PXCV_Err_FormatErrorCode(x, descBuf, descLen) > 0) Then
			s = s + PXCE_Helper.BytesToString(descBuf)
		End If
		MsgBox(s)
	End Sub
End Class
