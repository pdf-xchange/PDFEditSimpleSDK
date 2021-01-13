Attribute VB_Name = "PXCVErrors"
Option Explicit

Public Const PS40_ERR_NOTIMPLEMENTED = &H821404B0 'Not implemented
Public Const PS40_ERR_INVALID_ARG = &H82140001 'Invalid argument
Public Const PS40_ERR_MEMALLOC = &H821403E8 'Insufficient memory
Public Const PS40_ERR_USER_BREAK = &H821401F4 'Operation aborted by user
Public Const PS40_ERR_INTERNAL = &H82140011 'Internal error
Public Const PS40_ERR_INVALID_FILE_FORMAT = &H82140002 'Invalid file format
Public Const PS40_ERR_REQUIRED_PROP_NOT_SET = &H82142716 'Required property is not set
Public Const PS40_ERR_INVALID_PROP_TYPE = &H82142717 'Invalid property type
Public Const PS40_ERR_INVALID_PROP_VALUE = &H82142718 'Invalid property value
Public Const PS40_ERR_INVALID_OBJECT_NUM = &H82142719 'Invalid object number
Public Const PS40_ERR_INVALID_PS_OPERATOR = &H8214271C 'Invalid PS operator
Public Const PS40_ERR_UNKNOWN_OPERATOR = &H82142787 'Unknown operator
Public Const PS40_ERR_INVALID_CONTENT_STATE = &H82142788 'Invalid content state
Public Const PS40_ERR_NoPassword = &H821427A8 'No password
Public Const PS40_ERR_UnknowCryptFlt = &H821427A9 'Unknown crypt filter
Public Const PS40_ERR_WrongPassword = &H821427AA 'Wrong password
Public Const PS40_ERR_InvlaidObjStruct = &H821427AB 'Invalid object structure
Public Const PS40_ERR_WrongEncryptDict = &H821427AC 'Invalid encryption dictionary
Public Const PS40_ERR_DocEncrypted = &H821427AD 'Document encrypted
Public Const PS40_ERR_DocNOTEncrypted = &H821427AE 'Document not encrypted
Public Const PS40_ERR_WrongObjStream = &H821427AF 'Invalid object stream
Public Const PS40_ERR_WrongTrailer = &H821427B0 'Invalid document trailer
Public Const PS40_ERR_WrongXRef = &H821427B1 'Invalid xref table
Public Const PS40_ERR_WrongDecodeParms = &H821427B2 'Invalid decode parameter(s)
Public Const PS40_ERR_XRefNotFounded = &H821427B3 'xref table is not foud
Public Const PS40_ERR_DocAlreadyRead = &H821427B4 'Document is already read
Public Const PS40_ERR_DocNotRead = &H821427B5 'Document is not read

Public Function IS_DS_SUCCESSFUL(ByVal x As Long) As Long
    IS_DS_SUCCESSFUL = ((x And &H80000000) = 0)
End Function

Public Function IS_DS_FAILED(ByVal x As Long) As Long
    IS_DS_FAILED = ((x And &H80000000) <> 0)
End Function

Public Sub ShowDSError(ByVal x As Long)
    Dim sevLen As Long
    Dim facLen As Long
    Dim descLen As Long
    
    Dim sevBuf() As Byte
    Dim facBuf() As Byte
    Dim descBuf() As Byte
    
    sevLen = PXCV_Err_FormatSeverity(x, 0, 0)
    facLen = PXCV_Err_FormatFacility(x, 0, 0)
    descLen = PXCV_Err_FormatErrorCode(x, 0, 0)
    
    ReDim sevBuf(sevLen)
    ReDim facBuf(facLen)
    ReDim descBuf(descLen)
        
    Dim s As String
    If (PXCV_Err_FormatSeverity(x, VarPtr(sevBuf(1)), sevLen) > 0) Then
        s = BytesToString(sevBuf)
    End If
    s = s + " ["
    If (PXCV_Err_FormatFacility(x, VarPtr(facBuf(1)), facLen) > 0) Then
        s = s + BytesToString(facBuf)
    End If
    s = s + "]: "
    If (PXCV_Err_FormatErrorCode(x, VarPtr(descBuf(1)), descLen) > 0) Then
        s = s + BytesToString(descBuf)
    End If
    MsgBox s
End Sub

