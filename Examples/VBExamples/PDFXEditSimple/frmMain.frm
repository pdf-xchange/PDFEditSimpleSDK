VERSION 5.00
Begin VB.Form frmMain 
   BackColor       =   &H80000005&
   Caption         =   "PDF-XChange Editor Simple SDK VB Demo sample"
   ClientHeight    =   5265
   ClientLeft      =   225
   ClientTop       =   870
   ClientWidth     =   6360
   LinkTopic       =   "Form1"
   ScaleHeight     =   5265
   ScaleWidth      =   6360
   StartUpPosition =   3  'Windows Default
   Begin VB.HScrollBar HScroll 
      Height          =   255
      Left            =   0
      TabIndex        =   1
      Top             =   4920
      Width           =   6015
   End
   Begin VB.VScrollBar VScroll 
      Height          =   4935
      Left            =   6000
      TabIndex        =   0
      Top             =   0
      Width           =   255
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H8000000B&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   255
      Left            =   6000
      Top             =   4920
      Width           =   255
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuFileOpen 
         Caption         =   "Open"
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuFilePrint 
         Caption         =   "Print..."
      End
      Begin VB.Menu mnuFileSep 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu mnuActions 
      Caption         =   "Actions"
      Begin VB.Menu mnuActionsFirstPage 
         Caption         =   "First page"
         Shortcut        =   ^F
      End
      Begin VB.Menu mnuActionsPrevPage 
         Caption         =   "Previous page"
         Shortcut        =   ^P
      End
      Begin VB.Menu mnuActionsNextPage 
         Caption         =   "Next page"
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuActionsLastPage 
         Caption         =   "Last page"
         Shortcut        =   ^L
      End
      Begin VB.Menu mnuActionsSep 
         Caption         =   "-"
      End
      Begin VB.Menu mnuActionsActualSize 
         Caption         =   "Actual size"
         Shortcut        =   ^A
      End
      Begin VB.Menu mnuActionsZoomIn 
         Caption         =   "Zoom In"
         Shortcut        =   ^Z
      End
      Begin VB.Menu mnuActionsZoomOut 
         Caption         =   "Zoom Out"
         Shortcut        =   ^X
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "About"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_Doc As Long
Private m_Page As Long
Private m_PagesCount As Long
Private m_DCX As Long
Private m_DCY As Long
Private m_ZoomLevel As Double
Private m_OldZoom As Double
Private m_MinZoom As Double
Private m_MaxZoom As Double
Private m_PageWidth As Double
Private m_PageHeight As Double

Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
Private Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Private Declare Function PrintDlg Lib "comdlg32.dll" Alias "PrintDlgA" (pPrintdlg As tPRINTDLG) As Long
Private Declare Function StartDoc Lib "gdi32" Alias "StartDocA" (ByVal hdc As Long, lpdi As DOCINFO) As Long
Private Declare Function StartPage Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function EndDoc Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function EndPage Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function CopyRect Lib "user32" (lpDestRect As RECT, lpSourceRect As RECT) As Long
Private Declare Function CopyRect2 Lib "user32" Alias "CopyRect" (ByVal lpDestRect As Long, lpSourceRect As RECT) As Long


Private Declare Function GetLastError Lib "kernel32" () As Long

Private Declare Function GetOpenFileName Lib "comdlg32.dll" Alias _
		"GetOpenFileNameA" (pOpenfilename As OPENFILENAME) As Long

Private Declare Function GetSaveFileName Lib "comdlg32.dll" Alias _
		"GetSaveFileNameA" (pOpenfilename As OPENFILENAME) As Long


Private Type OPENFILENAME
		lStructSize As Long
		hwndOwner As Long
		hInstance As Long
		lpstrFilter As String
		lpstrCustomFilter As String
		nMaxCustFilter As Long
		nFilterIndex As Long
		lpstrFile As String
		nMaxFile As Long
		lpstrFileTitle As String
		nMaxFileTitle As Long
		lpstrInitialDir As String
		lpstrTitle As String
		flags As Long
		nFileOffset As Integer
		nFileExtension As Integer
		lpstrDefExt As String
		lCustData As Long
		lpfnHook As Long
		lpTemplateName As String
End Type

Private Enum DeviceCap
    DRIVERVERSION = 0
    TECHNOLOGY = 2
    HORZSIZE = 4
    VERTSIZE = 6
    HORZRES = 8
    VERTRES = 10
    BITSPIXEL = 12
    PLANES = 14
    NUMBRUSHES = 16
    NUMPENS = 18
    NUMMARKERS = 20
    NUMFONTS = 22
    NUMCOLORS = 24
    PDEVICESIZE = 26
    CURVECAPS = 28
    LINECAPS = 30
    POLYGONALCAPS = 32
    TEXTCAPS = 34
    CLIPCAPS = 36
    RASTERCAPS = 38
    ASPECTX = 40
    ASPECTY = 42
    ASPECTXY = 44

    LOGPIXELSX = 88
    LOGPIXELSY = 90

    SIZEPALETTE = 104
    NUMRESERVED = 106
    COLORRES = 108

    ' Printing related DeviceCaps. These replace the appropriate Escapes
    PHYSICALWIDTH = 110
    PHYSICALHEIGHT = 111
    PHYSICALOFFSETX = 112
    PHYSICALOFFSETY = 113
    SCALINGFACTORX = 114
    SCALINGFACTORY = 115
End Enum
    
Private Const COLOR_INACTIVEBORDER = 11
Private Const COLOR_WINDOW = 5

Private Const PD_PAGENUMS = &H2
Private Const PD_NOSELECTION = &H4
Private Const PD_RETURNDC = &H100

Private Type tPRINTDLG
        lStructSize As Long
        hwndOwner As Long
        hDevMode As Long
        hDevNames As Long
        hdc As Long
        flags As Long
        nFromPage As Integer
        nToPage As Integer
        nMinPage As Integer
        nMaxPage As Integer
        nCopies As Integer
        hInstance As Long
        lCustData As Long
        lpfnPrintHook As Long
        lpfnSetupHook As Long
        lpPrintTemplateName As String
        lpSetupTemplateName As String
        hPrintTemplate As Long
        hSetupTemplate As Long
End Type

Private Type DOCINFO
        cbSize As Long
        lpszDocName As String
        lpszOutput As String
End Type

Private Type Size
        cx As Long
        cy As Long
End Type



Private Sub OpenPDF()
    Dim res As Long
    Dim password(255) As Byte
    Dim spassword As String
    Dim pass_len As Long
    Dim process As Boolean
    Dim fname As String
    process = True
        
    On Error GoTo err
    res = 0
    
    Dim sFilter As String
    Dim OpenFile As OPENFILENAME
    OpenFile.lStructSize = Len(OpenFile)
    sFilter = "PDF Files (*.pdf)" & Chr(0) & "*.pdf" & Chr(0)
    OpenFile.lpstrFilter = sFilter
    OpenFile.nFilterIndex = 1
    OpenFile.lpstrFile = String(257, 0)
    OpenFile.nMaxFile = Len(OpenFile.lpstrFile) - 1
    OpenFile.lpstrFileTitle = OpenFile.lpstrFile
    OpenFile.nMaxFileTitle = OpenFile.nMaxFile
    OpenFile.lpstrInitialDir = "C:\"
    OpenFile.lpstrTitle = "Choose MS Word Document"
    OpenFile.lpstrDefExt = "doc"
    OpenFile.flags = 0

    Dim lReturn As Long
    lReturn = GetSaveFileName(OpenFile)
	If (lReturn) Then
		 fname = Trim$(Left$(OpenFile.lpstrFile, Len(OpenFile.lpstrFile) - 2))
	End If
	
    ClosePDF
    res = PXCV_Init(m_Doc, "", "")
    If (IS_DS_FAILED(res)) Then
        ShowDSError res
        Exit Sub
    End If
    res = PXCV_VB_ReadDocumentW(m_Doc, fname, 0)
    If res = PS40_ERR_DocEncrypted Then
        ' ask password
        While process
            pass_len = 0
            frmPassword.Show vbModal
            If frmPassword.IsOK Then
                ' password was supplied, check it
                spassword = frmPassword.GetPassword
                StringToBytes password, spassword
                pass_len = Len(spassword)
                res = PXCV_CheckPassword(m_Doc, password(0), pass_len)
                If (IS_DS_SUCCESSFUL(res)) Then
                    process = False
                End If
            Else
                ' Cancel button was pressed, skip document opening
                res = PS40_ERR_INTERNAL
                process = False
            End If
        Wend
        If (IS_DS_SUCCESSFUL(res)) Then
            res = PXCV_FinishReadDocument(m_Doc, 0)
        End If
    End If
err:
    If (IS_DS_FAILED(res)) Then
        ClosePDF
        ShowDSError res
        Exit Sub
    End If
End Sub

Private Sub ClosePDF()
    If m_Doc <> 0 Then
        PXCV_Delete m_Doc
        m_Doc = 0
    End If
End Sub

Private Sub ShowPDF(ByVal page As Long)
    Dim params As PXV_CommonRenderParameters
    Dim res As Long
    Dim wpr As RECT
    Dim dr As RECT
    Dim pw As Double
    Dim ph As Double
    Dim page_width_in_pixels As Long
    Dim page_height_in_pixels As Long
    
    wpr.Left = -HScroll.Value
    wpr.Top = -VScroll.Value
    
    page_width_in_pixels = (m_PageWidth / 72) * m_DCX * m_ZoomLevel
    page_height_in_pixels = (m_PageHeight / 72) * m_DCY * m_ZoomLevel
    
    wpr.Right = wpr.Left + page_width_in_pixels
    wpr.Bottom = wpr.Top + page_height_in_pixels
    
    dr.Left = 0
    dr.Top = 0
    dr.Right = (Me.ScaleWidth / 1440) * m_DCX
    dr.Bottom = (Me.ScaleHeight / 1440) * m_DCY
               
    params.WholePageRect = VarPtr(wpr)
    params.DrawRect = VarPtr(dr)
    params.flags = 0
    params.RenderTarget = pxvrm_Viewing
    
    res = FillRect(Me.hdc, dr, COLOR_WINDOW + 1)
        
    
    res = PXCV_DrawPageToDC(m_Doc, page, Me.hdc, params)
End Sub

Private Sub ReleasePage(ByVal page As Long)
    If (page <> m_Page) Then
        PXCV_ReleasePageCachedData m_Doc, m_Page, pxvrcd_ReleaseDocumentImages
    End If
End Sub

Private Sub SetScrolls()
    If (Me.ScaleHeight > 0) Then
        VScroll.LargeChange = ((Me.ScaleHeight - 220) / 1440) * m_DCY * m_ZoomLevel
    End If
    If (Me.ScaleWidth > 0) Then
        HScroll.LargeChange = ((Me.ScaleWidth - 220) / 1440) * m_DCX * m_ZoomLevel
    End If
    
    HScroll.Max = (((m_PageWidth / 72) * m_DCX) * m_ZoomLevel) - HScroll.LargeChange
    VScroll.Max = (((m_PageHeight / 72) * m_DCY) * m_ZoomLevel) - VScroll.LargeChange
    
    VScroll.Value = (VScroll.Value / m_OldZoom) * m_ZoomLevel
    HScroll.Value = (HScroll.Value / m_OldZoom) * m_ZoomLevel
    
    
    If (m_PageHeight * m_ZoomLevel / 72) <= ((Me.ScaleHeight - HScroll.height) / 1440) Then
        VScroll.Visible = False
    Else
        VScroll.Visible = True
    End If
    
    If (m_PageWidth * m_ZoomLevel / 72) <= ((Me.ScaleWidth - VScroll.width) / 1440) Then
        HScroll.Visible = False
    Else
        HScroll.Visible = True
    End If
End Sub

Private Sub SetupPageDim(ByVal page As Long)
    Dim res As Long
    res = PXCV_GetPageDimensions(m_Doc, page, m_PageWidth, m_PageHeight)
    SetScrolls
    res = PXCV_GetPagesCount(m_Doc, m_PagesCount)
End Sub

Private Sub Form_Load()
    m_ZoomLevel = 1
    m_OldZoom = m_ZoomLevel
    m_MinZoom = 0.03
    m_MaxZoom = 64
    m_DCX = GetDeviceCaps(Me.hdc, LOGPIXELSX)
    m_DCY = GetDeviceCaps(Me.hdc, LOGPIXELSY)
    HScroll.Value = 0
    VScroll.Value = 0
End Sub

Private Sub Form_Paint()
    If (m_Doc = 0) Then
        Me.backcolor = &H8000000C
        VScroll.Visible = False
        HScroll.Visible = False
        Shape1.Visible = False
    Else
        Me.backcolor = &H80000005
        ShowPDF m_Page
    End If
    
End Sub

Private Sub Form_Resize()
    If (Me.ScaleWidth >= 220) Then
        VScroll.Left = Me.ScaleWidth - 220
        VScroll.width = 220
    End If
    If (Me.ScaleHeight >= 220) Then
        VScroll.height = Me.ScaleHeight - 220
    End If
    If (Me.ScaleHeight >= 220) Then
        HScroll.Top = Me.ScaleHeight - 220
        HScroll.height = 220
    End If
    If (Me.ScaleWidth >= 220) Then
        HScroll.width = Me.ScaleWidth - 220
    End If
    Shape1.Left = VScroll.Left
    Shape1.width = VScroll.width + 20
    Shape1.Top = HScroll.Top
    Shape1.height = HScroll.height + 20
    SetScrolls
End Sub

Private Sub mnuActionsActualSize_Click()
    If (m_ZoomLevel <> 1) Then
        m_OldZoom = m_ZoomLevel
        m_ZoomLevel = 1
        Refresh
    End If
End Sub

Private Sub mnuActionsFirstPage_Click()
    If (m_Page > 0) Then
        ReleasePage 0
        m_Page = 0
        SetupPageDim m_Page
        Refresh
    End If
End Sub

Private Sub mnuActionsLastPage_Click()
    If (m_Page < (m_PagesCount - 1)) Then
        ReleasePage m_Page
        m_Page = m_PagesCount - 1
        SetupPageDim m_Page
        Refresh
    End If
End Sub

Private Sub mnuActionsNextPage_Click()
    If (m_PagesCount > (m_Page + 1)) Then
        ReleasePage m_Page
        m_Page = m_Page + 1
        SetupPageDim m_Page
        Refresh
    End If
End Sub

Private Sub mnuActionsPrevPage_Click()
    If (m_Page > 0) Then
        ReleasePage m_Page
        m_Page = m_Page - 1
        SetupPageDim m_Page
        Refresh
    End If
End Sub

Private Sub mnuActionsZoomIn_Click()
    Dim zoom As Double
    zoom = m_ZoomLevel * 2
    If (m_ZoomLevel < m_MaxZoom) Then
        m_OldZoom = m_ZoomLevel
        m_ZoomLevel = zoom
        SetupPageDim m_Page
        Refresh
    End If
End Sub

Private Sub mnuActionsZoomOut_Click()
    Dim zoom As Double
    zoom = m_ZoomLevel / 2
    If (m_ZoomLevel > m_MinZoom) Then
        m_OldZoom = m_ZoomLevel
        m_ZoomLevel = zoom
        SetupPageDim m_Page
        Refresh
    End If
End Sub

Private Sub mnuFileExit_Click()
    Unload Me
End Sub

Private Sub mnuFileOpen_Click()
    OpenPDF
    SetupPageDim m_Page
    Refresh
End Sub

Private Sub MakeProp(ByRef w As Long, ByRef h As Long, ByVal ppage_w As Long, ByVal ppage_h As Long, _
    ByVal dpage_w As Double, ByVal dpage_h As Double)
    
    Dim kw As Double
    Dim kh As Double
    kw = CDbl(ppage_w) / dpage_w
    kh = CDbl(ppage_h) / dpage_h
    If kw > kh Then kw = kh
        
    w = CLng(dpage_w * kw)
    h = CLng(dpage_h * kw)
End Sub

Private Sub PrintPdfFile(ByVal hParentWnd As Long)
    If (m_Doc = 0) Then Exit Sub
    
    Dim pagescount As Long
    Dim hr As Long
    pagescount = 0
    hr = PXCV_GetPagesCount(m_Doc, pagescount)
    If IS_DS_FAILED(hr) Then Exit Sub
    '
    Dim pdlg As tPRINTDLG
    pdlg.lStructSize = 66
    '
    pdlg.hwndOwner = hParentWnd
    pdlg.flags = PD_NOSELECTION Or PD_RETURNDC
    pdlg.nMinPage = 1
    pdlg.nMaxPage = pagescount
    pdlg.nCopies = 1

    hr = PrintDlg(pdlg)
    If hr = 0 Then
        hr = GetLastError
        Exit Sub
    End If
    
    Dim nStartPage As Long
    nStartPage = 1
    Dim nEndPage As Long
    nEndPage = pagescount
    If (pdlg.flags And PD_PAGENUMS) Then
        nStartPage = pdlg.nFromPage
        nEndPage = pdlg.nToPage
    End If
    nStartPage = nStartPage - 1
    nEndPage = nEndPage - 1
    Dim i As Long
    Dim di As DOCINFO
    di.cbSize = 16
    di.lpszDocName = "PXC-View PDF Print"
    ' Now Getting Information from DC
    Dim physicalSize As Size
    Dim margin As Size
    Dim printigSize As Size
    physicalSize.cx = GetDeviceCaps(pdlg.hdc, PHYSICALWIDTH)
    physicalSize.cy = GetDeviceCaps(pdlg.hdc, PHYSICALHEIGHT)
    margin.cx = GetDeviceCaps(pdlg.hdc, PHYSICALOFFSETX)
    margin.cy = GetDeviceCaps(pdlg.hdc, PHYSICALOFFSETY)
    printigSize.cx = GetDeviceCaps(pdlg.hdc, HORZRES)
    printigSize.cy = GetDeviceCaps(pdlg.hdc, VERTRES)
    '
    Dim or_prect As RECT
    or_prect.Left = margin.cx
    or_prect.Right = or_prect.Left + printigSize.cx
    or_prect.Top = margin.cy
    or_prect.Bottom = or_prect.Top + printigSize.cy
    Dim crp As PXV_CommonRenderParameters
    Dim bRotated As Boolean
    bRotated = (physicalSize.cx > physicalSize.cy)
    crp.flags = pxvrpf_UseVectorRenderer
    crp.RenderTarget = pxvrm_Printing
    crp.DrawRect = 0
    '
    If (StartDoc(pdlg.hdc, di) > 0) Then
        For i = nStartPage To nEndPage
            StartPage pdlg.hdc
            '
            Dim doc_page_w As Double
            Dim doc_page_h As Double
            hr = PXCV_GetPageDimensions(m_Doc, i, doc_page_w, doc_page_h)
            Dim pw As Long, ph As Long
            Dim pr As RECT
            ' Fit no proportional
            CopyRect pr, or_prect
            ' Proportional fit and center
            MakeProp pw, ph, or_prect.Right - or_prect.Left, or_prect.Bottom - or_prect.Top, doc_page_w, doc_page_h
            pr.Left = or_prect.Left + (or_prect.Right - or_prect.Left - pw) / 2
            pr.Right = pr.Left + pw
            pr.Top = or_prect.Top + (or_prect.Bottom - or_prect.Top - ph) / 2
            pr.Bottom = pr.Top + ph
            '
            crp.WholePageRect = VarPtr(pr)
            hr = PXCV_DrawPageToDC(m_Doc, i, pdlg.hdc, crp)
            EndPage pdlg.hdc
        Next i
        EndDoc pdlg.hdc
    End If
    DeleteDC pdlg.hdc
End Sub

Private Sub mnuFilePrint_Click()
    PrintPdfFile Me.hWnd
End Sub

Private Sub mnuHelpAbout_Click()
    AboutDlg.Show vbModal
End Sub

Private Sub VScroll_Change()
    Me.Refresh
End Sub

Private Sub HScroll_Change()
    Me.Refresh
End Sub


