Imports System.Runtime.InteropServices

Public Class frmMain

	Private m_Doc As IntPtr
	Private m_Page As Integer
    Private m_PagesCount As Integer
    Private m_DCX As Integer
    Private m_DCY As Integer
    Private m_ZoomLevel As Double
    Private m_OldZoom As Double
    Private m_MinZoom As Double
    Private m_MaxZoom As Double
    Private m_PageWidth As Double
    Private m_PageHeight As Double
    Private m_BgBrush As SolidBrush
    Private m_bInit As Boolean

    Private m_Parameters As PXCE_Lib.PXV_CommonRenderParameters = _
         New PXCE_Lib.PXV_CommonRenderParameters()

    Private m_PrintedPageCount As Integer
    Private m_PagesCountToPrint As Integer

    Private WithEvents m_DocToPrint As System.Drawing.Printing.PrintDocument = _
            New System.Drawing.Printing.PrintDocument()


    Private Declare Function GetDC Lib "user32" (ByVal hWnd As IntPtr) As IntPtr
    Private Declare Function ReleaseDC Lib "user32" (ByVal hWnd As IntPtr, ByVal hDC As IntPtr) As Integer
    Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Integer, ByVal nIndex As Integer) As Integer

    Public Enum DeviceCap
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

    Private Sub OpenPDF()
        Dim res As Integer
        Dim password(255) As Byte
        Dim spassword As String
        Dim pass_len As Integer
        Dim process As Boolean
        Dim fname As String
        process = True

        res = 0

        If (DialogResult.OK = openDlg.ShowDialog()) Then
            fname = openDlg.FileName
            ClosePDF()
			res = PXCE_Lib.PXCV_Init(m_Doc, (""), "")
			If (PXCE_Errors.IS_DS_FAILED(res)) Then
                PXCE_Errors.ShowDSError(res)
                Exit Sub
            End If
            res = PXCE_Lib.PXCV_ReadDocumentW(m_Doc, fname, 0)
            If res = PXCE_Errors.PS_ERR_DocEncrypted Then
                ' ask password
                While process
                    pass_len = 0
                    Dim passDlg As frmPassword = New frmPassword()
                    If passDlg.ShowDialog(Me) = DialogResult.OK Then
                        ' password was supplied, check it
                        spassword = passDlg.GetPassword()
                        PXCE_Helper.StringToBytes(password, spassword)
                        pass_len = Len(spassword)
                        res = PXCE_Lib.PXCV_CheckPassword(m_Doc, password, pass_len)
                        If (PXCE_Errors.IS_DS_SUCCESSFUL(res)) Then Exit While
                    Else
                        ' Cancel button was pressed, skip document opening
                        res = PXCE_Errors.PS_ERR_INTERNAL
                        process = False
                    End If
                End While
                If (PXCE_Errors.IS_DS_SUCCESSFUL(res)) Then
                    res = PXCE_Lib.PXCV_FinishReadDocument(m_Doc, 0)
                End If
            End If
            If (PXCE_Errors.IS_DS_FAILED(res)) Then
                ClosePDF()
                PXCE_Errors.ShowDSError(res)
                Exit Sub
            End If
        End If
    End Sub

    Private Sub ClosePDF()
        If m_Doc <> 0 Then
            PXCE_Lib.PXCV_Delete(m_Doc)
            m_Doc = 0
        End If
    End Sub

    Private Sub GetPageInfo(ByVal page As Integer)
        Dim res As Integer = 0
        res = PXCE_Lib.PXCV_GetPageDimensions(m_Doc, page, m_PageWidth, m_PageHeight)
        res = PXCE_Lib.PXCV_GetPagesCount(m_Doc, m_PagesCount)
        SetScrolls()
    End Sub

    Private Sub ShowPDF()
        Dim res As Integer
        Dim wpr As PXCE_Helper.RECT
        Dim dr As PXCE_Helper.RECT

        Dim page_width_in_pixels As Integer
        Dim page_height_in_pixels As Integer

        wpr.Left = -hScrollBar.Value
        wpr.Top = -vScrollBar.Value + 20

        page_width_in_pixels = CInt(m_PageWidth / 72 * m_DCX * m_ZoomLevel)
        page_height_in_pixels = CInt(m_PageHeight / 72 * m_DCY * m_ZoomLevel)

        wpr.Right = wpr.Left + page_width_in_pixels
        wpr.Bottom = wpr.Top + page_height_in_pixels

        dr.Left = 0
        dr.Top = 20
        dr.Right = dr.Left + Width - vScrollBar.Width - 8
        dr.Bottom = dr.Top + Height - hScrollBar.Height - 51

        Marshal.StructureToPtr(wpr, m_Parameters.WholePageRect, False)
        Marshal.StructureToPtr(dr, m_Parameters.DrawRect, False)
        m_Parameters.flags = 0
        m_Parameters.RenderTarget = PXCE_Lib.PXCV_RenderMode.pxvrm_Viewing

        Dim hdc As IntPtr = GetDC(Handle)
        res = PXCE_Lib.PXCV_DrawPageToDC(m_Doc, m_Page, hdc, m_Parameters)
        ReleaseDC(Handle, hdc)
    End Sub

    Private Sub SetScrolls()
        If (Not m_bInit) Then Exit Sub
        vScrollBar.Maximum = CInt((m_PageHeight / 72) * m_DCY * m_ZoomLevel)
        hScrollBar.Maximum = CInt((m_PageWidth / 72) * m_DCX * m_ZoomLevel)

        vScrollBar.Value = CInt((vScrollBar.Value / m_OldZoom) * m_ZoomLevel)
        hScrollBar.Value = CInt((hScrollBar.Value / m_OldZoom) * m_ZoomLevel)

        If (Me.Height > 0) Then
            Dim h As Integer
            h = CInt(Me.Height - hScrollBar.Height - 51)
            If h > 0 Then vScrollBar.LargeChange = h
        End If
        If (Me.Width > 0) Then
            Dim w As Integer
            w = CInt(Me.Width - vScrollBar.Width - 8)
            If w > 0 Then hScrollBar.LargeChange = w
        End If
        If ((m_PageHeight * m_ZoomLevel / 72) <= ((Me.Height - hScrollBar.Height) / m_DCY)) Then
            vScrollBar.Visible = False
        Else
            vScrollBar.Visible = True
        End If
        If ((m_PageWidth * m_ZoomLevel / 72) <= ((Me.Width - vScrollBar.Width) / m_DCX)) Then
            hScrollBar.Visible = False
        Else
            hScrollBar.Visible = True
        End If
    End Sub

    Private Sub ReleasePage(ByVal page As Integer)
        If (page <> m_Page) Then
            PXCE_Lib.PXCV_ReleasePageCachedData(m_Doc, m_Page, _
                CInt(PXCE_Lib.PXCV_ReleaseCachedDataFlags.pxvrcd_ReleaseDocumentImages))
        End If
    End Sub


    Private Sub mnuFileOpen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuFileOpen.Click
        OpenPDF()
        GetPageInfo(0)
        SetScrolls()
        Refresh()
    End Sub

    Protected Overrides Sub OnPaint(ByVal e As PaintEventArgs)
        If (m_Doc <> 0) Then
            e.Graphics.FillRectangle(m_BgBrush, 0, 20, Me.Width - vScrollBar.Width - 8, _
                Me.Height - hScrollBar.Height - 49)
            ShowPDF()
        Else
            Me.BackColor = Color.FromKnownColor(KnownColor.AppWorkspace)
        End If
    End Sub

    Private Sub mnuFileExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuFileExit.Click
        ClosePDF()
        Me.Close()
    End Sub

    Private Sub mnuActionsFirst_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuActionsFirst.Click
        If (m_Page > 0) Then
            ReleasePage(0)
            m_Page = 0
            GetPageInfo(m_Page)
            Refresh()
        End If
    End Sub

    Private Sub mnuActionsPrev_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuActionsPrev.Click
        If (m_Page > 0) Then
            ReleasePage(m_Page)
            m_Page -= 1
            GetPageInfo(m_Page)
            Refresh()
        End If
    End Sub

    Private Sub mnuActionsNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuActionsNext.Click
        If (m_PagesCount > (m_Page + 1)) Then
            ReleasePage(m_Page)
            m_Page += 1
            GetPageInfo(m_Page)
            Refresh()
        End If
    End Sub

    Private Sub mnuActionsLast_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuActionsLast.Click
        If (m_Page < (m_PagesCount - 1)) Then
            ReleasePage(m_Page)
            m_Page = m_PagesCount - 1
            GetPageInfo(m_Page)
            Refresh()
        End If
    End Sub

    Private Sub mnuActionsActualSize_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuActionsActualSize.Click
        If (m_ZoomLevel <> 1) Then
            m_OldZoom = m_ZoomLevel
            m_ZoomLevel = 1
            Refresh()
        End If
    End Sub

    Private Sub mnuActionsZoomIn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuActionsZoomIn.Click
        Dim zoom As Double
        zoom = m_ZoomLevel * 2
        If (m_ZoomLevel < m_MaxZoom) Then
            m_OldZoom = m_ZoomLevel
            m_ZoomLevel = zoom
            GetPageInfo(m_Page)
            Refresh()
        End If
    End Sub

    Private Sub mnuActionsZoomOut_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuActionsZoomOut.Click
        Dim zoom As Double
        zoom = m_ZoomLevel / 2
        If (m_ZoomLevel > m_MinZoom) Then
            m_OldZoom = m_ZoomLevel
            m_ZoomLevel = zoom
            GetPageInfo(m_Page)
            Refresh()
        End If
    End Sub

    Private Sub mnuHelpAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuHelpAbout.Click
        Dim about As frmAbout = New frmAbout()
        about.ShowDialog()
    End Sub

    Private Sub frmMain_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_BgBrush = New SolidBrush(Color.White)
        m_Parameters.DrawRect = Marshal.AllocHGlobal(Marshal.SizeOf(GetType(PXCE_Helper.RECT)))
        m_Parameters.WholePageRect = Marshal.AllocHGlobal(Marshal.SizeOf(GetType(PXCE_Helper.RECT)))

        m_ZoomLevel = 1
        m_OldZoom = m_ZoomLevel
        m_MinZoom = 0.03
        m_MaxZoom = 64
        Dim hdc As IntPtr
        hdc = GetDC(Handle)
        m_DCX = GetDeviceCaps(hdc, DeviceCap.LOGPIXELSX)
        m_DCY = GetDeviceCaps(hdc, DeviceCap.LOGPIXELSY)
        ReleaseDC(Me.Handle, hdc)
        vScrollBar.Visible = False
        hScrollBar.Visible = False
        m_bInit = True
    End Sub

    Private Sub frmMain_FormClosed(ByVal sender As System.Object, ByVal e As System.Windows.Forms.FormClosedEventArgs) Handles MyBase.FormClosed
        If (m_Parameters.DrawRect <> IntPtr.Zero) Then
            Marshal.FreeHGlobal(m_Parameters.DrawRect)
        End If
        If (m_Parameters.WholePageRect <> IntPtr.Zero) Then
            Marshal.FreeHGlobal(m_Parameters.WholePageRect)
        End If
    End Sub

    Private Sub frmMain_Resize(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Resize
        Refresh()
    End Sub

    Private Sub vScrollBar_Scroll(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ScrollEventArgs) Handles vScrollBar.Scroll
        Refresh()
    End Sub

    Private Sub hScrollBar_Scroll(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ScrollEventArgs) Handles hScrollBar.Scroll
        Refresh()
    End Sub

    Private Sub MakeProp(ByRef w As Integer, ByRef h As Integer, ByVal ppage_w As Integer, ByVal ppage_h As Integer, ByVal dpage_w As Double, ByVal dpage_h As Double)
        Dim kw As Double = Convert.ToDouble(ppage_w) / dpage_w
        Dim kh As Double = Convert.ToDouble(ppage_h) / dpage_h

        If (kw > kh) Then
            kw = kh
        End If
        w = CInt(dpage_w * kw)
        h = CInt(dpage_h * kw)
    End Sub


    Private Sub m_DocToPrint_PrintPage(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintPageEventArgs) Handles m_DocToPrint.PrintPage
        Dim hdc As IntPtr = e.Graphics.GetHdc()
        m_PrintedPageCount = m_PrintedPageCount + 1
        Dim nPrintPageNum As Integer = m_PrintedPageCount - 1

        Dim doc_page_w As Double = 0.0
        Dim doc_page_h As Double
        Dim res As Integer = 0

        res = PXCE_Lib.PXCV_GetPageDimensions(m_Doc, nPrintPageNum, doc_page_w, doc_page_h)
        If (PXCE_Errors.IS_DS_FAILED(res)) Then
            PXCE_Errors.ShowDSError(res)
            Return
        End If

        Dim physicalSize As System.Drawing.Size
        Dim margin As System.Drawing.Size
        Dim printigSize As System.Drawing.Size

        physicalSize.Width = GetDeviceCaps(hdc, DeviceCap.PHYSICALWIDTH)
        physicalSize.Height = GetDeviceCaps(hdc, DeviceCap.PHYSICALHEIGHT)
        margin.Width = GetDeviceCaps(hdc, DeviceCap.PHYSICALOFFSETX)
        margin.Height = GetDeviceCaps(hdc, DeviceCap.PHYSICALOFFSETY)
        printigSize.Width = GetDeviceCaps(hdc, DeviceCap.HORZRES)
        printigSize.Height = GetDeviceCaps(hdc, DeviceCap.VERTRES)
        '
        Dim or_prect As System.Drawing.Rectangle
        or_prect.X = margin.Width
        or_prect.Width = or_prect.Left + printigSize.Width
        or_prect.Y = margin.Height
        or_prect.Height = or_prect.Y + printigSize.Height
        Dim crp As PXCE_Lib.PXV_CommonRenderParameters

        crp.flags = CInt(PXCE_Lib.PXV_CommonRenderParametersFlags.pxvrpf_UseVectorRenderer)
        crp.RenderTarget = PXCE_Lib.PXCV_RenderMode.pxvrm_Printing
        crp.DrawRect = IntPtr.Zero
        crp.WholePageRect = IntPtr.Zero

        Dim pw As Integer = 0, ph As Integer = 0
        Dim pr As PXCE_Helper.RECT
        MakeProp(pw, ph, or_prect.Right - or_prect.Left, or_prect.Bottom - or_prect.Top, doc_page_w, doc_page_h)
        pr.Left = or_prect.Left + (or_prect.Right - or_prect.Left - pw) / 2
        pr.Right = pr.Left + pw
        pr.Top = or_prect.Top + (or_prect.Bottom - or_prect.Top - ph) / 2
        pr.Bottom = pr.Top + ph

        Dim sz As Integer = Marshal.SizeOf(pr)
        crp.WholePageRect = Marshal.AllocHGlobal(sz)
        Marshal.StructureToPtr(pr, crp.WholePageRect, False)
        res = PXCE_Lib.PXCV_DrawPageToDC(m_Doc, nPrintPageNum, hdc, crp)
        Marshal.FreeHGlobal(crp.WholePageRect)
        '
        e.HasMorePages = m_PrintedPageCount < m_PagesCountToPrint
    End Sub


    Private Sub PrintPdfFile(ByVal hParentWnd As IntPtr)
        Dim hr As Integer = PXCE_Lib.PXCV_GetPagesCount(m_Doc, m_PagesCountToPrint)
        If (PXCE_Errors.IS_DS_FAILED(hr)) Then Return

        m_PrintedPageCount = 0
        m_DocToPrint.DocumentName = "PXC-View PDF Print"
        printDlg.AllowSomePages = True
        printDlg.ShowHelp = True
        printDlg.Document = m_DocToPrint
        printDlg.Document.PrinterSettings.FromPage = 1
        printDlg.Document.PrinterSettings.MinimumPage = 1
        printDlg.Document.PrinterSettings.ToPage = 1
        printDlg.Document.PrinterSettings.Copies = 1

        Dim result As DialogResult = printDlg.ShowDialog()
        If (result = DialogResult.OK) Then
            m_DocToPrint.Print()
        End If
    End Sub

    Private Sub mnuFilePrint_Click(ByVal sender As Object, ByVal e As EventArgs) Handles mnuFilePrint.Click
        PrintPdfFile(Me.Handle)
    End Sub

    
End Class
