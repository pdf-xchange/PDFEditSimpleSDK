<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmMain
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
		Me.mnuActionsZoomIn = New System.Windows.Forms.ToolStripMenuItem()
		Me.mnuActionsZoomOut = New System.Windows.Forms.ToolStripMenuItem()
		Me.toolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator()
		Me.mnuActionsActualSize = New System.Windows.Forms.ToolStripMenuItem()
		Me.mnuHelp = New System.Windows.Forms.ToolStripMenuItem()
		Me.mnuHelpAbout = New System.Windows.Forms.ToolStripMenuItem()
		Me.vScrollBar = New System.Windows.Forms.VScrollBar()
		Me.hScrollBar = New System.Windows.Forms.HScrollBar()
		Me.openDlg = New System.Windows.Forms.OpenFileDialog()
		Me.mnuActionsLast = New System.Windows.Forms.ToolStripMenuItem()
		Me.mnuFileOpen = New System.Windows.Forms.ToolStripMenuItem()
		Me.toolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator()
		Me.menuStrip = New System.Windows.Forms.MenuStrip()
		Me.mnuFile = New System.Windows.Forms.ToolStripMenuItem()
		Me.mnuFilePrint = New System.Windows.Forms.ToolStripMenuItem()
		Me.mnuFileExit = New System.Windows.Forms.ToolStripMenuItem()
		Me.mnuFileActions = New System.Windows.Forms.ToolStripMenuItem()
		Me.mnuActionsFirst = New System.Windows.Forms.ToolStripMenuItem()
		Me.mnuActionsPrev = New System.Windows.Forms.ToolStripMenuItem()
		Me.mnuActionsNext = New System.Windows.Forms.ToolStripMenuItem()
		Me.printDlg = New System.Windows.Forms.PrintDialog()
		Me.menuStrip.SuspendLayout()
		Me.SuspendLayout()
		'
		'mnuActionsZoomIn
		'
		Me.mnuActionsZoomIn.Name = "mnuActionsZoomIn"
		Me.mnuActionsZoomIn.ShortcutKeys = CType((System.Windows.Forms.Keys.Control Or System.Windows.Forms.Keys.I), System.Windows.Forms.Keys)
		Me.mnuActionsZoomIn.Size = New System.Drawing.Size(211, 22)
		Me.mnuActionsZoomIn.Text = "Zoom In"
		'
		'mnuActionsZoomOut
		'
		Me.mnuActionsZoomOut.Name = "mnuActionsZoomOut"
		Me.mnuActionsZoomOut.ShortcutKeys = CType((System.Windows.Forms.Keys.Control Or System.Windows.Forms.Keys.O), System.Windows.Forms.Keys)
		Me.mnuActionsZoomOut.Size = New System.Drawing.Size(211, 22)
		Me.mnuActionsZoomOut.Text = "Zoom Out"
		'
		'toolStripSeparator2
		'
		Me.toolStripSeparator2.Name = "toolStripSeparator2"
		Me.toolStripSeparator2.Size = New System.Drawing.Size(208, 6)
		'
		'mnuActionsActualSize
		'
		Me.mnuActionsActualSize.Name = "mnuActionsActualSize"
		Me.mnuActionsActualSize.ShortcutKeys = CType((System.Windows.Forms.Keys.Control Or System.Windows.Forms.Keys.U), System.Windows.Forms.Keys)
		Me.mnuActionsActualSize.Size = New System.Drawing.Size(211, 22)
		Me.mnuActionsActualSize.Text = "Actual size"
		'
		'mnuHelp
		'
		Me.mnuHelp.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuHelpAbout})
		Me.mnuHelp.Name = "mnuHelp"
		Me.mnuHelp.Size = New System.Drawing.Size(44, 20)
		Me.mnuHelp.Text = "Help"
		'
		'mnuHelpAbout
		'
		Me.mnuHelpAbout.Name = "mnuHelpAbout"
		Me.mnuHelpAbout.Size = New System.Drawing.Size(116, 22)
		Me.mnuHelpAbout.Text = "About..."
		'
		'vScrollBar
		'
		Me.vScrollBar.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
			Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
		Me.vScrollBar.Location = New System.Drawing.Point(674, 25)
		Me.vScrollBar.Name = "vScrollBar"
		Me.vScrollBar.Size = New System.Drawing.Size(15, 405)
		Me.vScrollBar.TabIndex = 6
		'
		'hScrollBar
		'
		Me.hScrollBar.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
			Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
		Me.hScrollBar.Location = New System.Drawing.Point(0, 430)
		Me.hScrollBar.Name = "hScrollBar"
		Me.hScrollBar.Size = New System.Drawing.Size(676, 14)
		Me.hScrollBar.TabIndex = 5
		'
		'openDlg
		'
		Me.openDlg.Filter = "PDF files (*.pdf)|*.pdf"
		'
		'mnuActionsLast
		'
		Me.mnuActionsLast.Name = "mnuActionsLast"
		Me.mnuActionsLast.ShortcutKeys = CType((System.Windows.Forms.Keys.Control Or System.Windows.Forms.Keys.[End]), System.Windows.Forms.Keys)
		Me.mnuActionsLast.Size = New System.Drawing.Size(211, 22)
		Me.mnuActionsLast.Text = "Last page"
		'
		'mnuFileOpen
		'
		Me.mnuFileOpen.Name = "mnuFileOpen"
		Me.mnuFileOpen.ShortcutKeys = CType((System.Windows.Forms.Keys.Control Or System.Windows.Forms.Keys.O), System.Windows.Forms.Keys)
		Me.mnuFileOpen.Size = New System.Drawing.Size(146, 22)
		Me.mnuFileOpen.Text = "Open"
		'
		'toolStripSeparator1
		'
		Me.toolStripSeparator1.Name = "toolStripSeparator1"
		Me.toolStripSeparator1.Size = New System.Drawing.Size(143, 6)
		'
		'menuStrip
		'
		Me.menuStrip.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None
		Me.menuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuFile, Me.mnuFileActions, Me.mnuHelp})
		Me.menuStrip.Location = New System.Drawing.Point(0, 0)
		Me.menuStrip.Name = "menuStrip"
		Me.menuStrip.Size = New System.Drawing.Size(688, 24)
		Me.menuStrip.TabIndex = 4
		Me.menuStrip.Text = "menuStrip"
		'
		'mnuFile
		'
		Me.mnuFile.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuFileOpen, Me.mnuFilePrint, Me.toolStripSeparator1, Me.mnuFileExit})
		Me.mnuFile.Name = "mnuFile"
		Me.mnuFile.Size = New System.Drawing.Size(37, 20)
		Me.mnuFile.Text = "File"
		'
		'mnuFilePrint
		'
		Me.mnuFilePrint.Name = "mnuFilePrint"
		Me.mnuFilePrint.Size = New System.Drawing.Size(146, 22)
		Me.mnuFilePrint.Text = "Print..."
		'
		'mnuFileExit
		'
		Me.mnuFileExit.Name = "mnuFileExit"
		Me.mnuFileExit.ShortcutKeys = CType((System.Windows.Forms.Keys.Alt Or System.Windows.Forms.Keys.X), System.Windows.Forms.Keys)
		Me.mnuFileExit.Size = New System.Drawing.Size(146, 22)
		Me.mnuFileExit.Text = "Exit"
		'
		'mnuFileActions
		'
		Me.mnuFileActions.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.mnuActionsFirst, Me.mnuActionsPrev, Me.mnuActionsNext, Me.mnuActionsLast, Me.toolStripSeparator2, Me.mnuActionsActualSize, Me.mnuActionsZoomIn, Me.mnuActionsZoomOut})
		Me.mnuFileActions.Name = "mnuFileActions"
		Me.mnuFileActions.Size = New System.Drawing.Size(59, 20)
		Me.mnuFileActions.Text = "Actions"
		'
		'mnuActionsFirst
		'
		Me.mnuActionsFirst.Name = "mnuActionsFirst"
		Me.mnuActionsFirst.ShortcutKeys = CType((System.Windows.Forms.Keys.Control Or System.Windows.Forms.Keys.Home), System.Windows.Forms.Keys)
		Me.mnuActionsFirst.Size = New System.Drawing.Size(211, 22)
		Me.mnuActionsFirst.Text = "First page"
		'
		'mnuActionsPrev
		'
		Me.mnuActionsPrev.Name = "mnuActionsPrev"
		Me.mnuActionsPrev.ShortcutKeys = CType((System.Windows.Forms.Keys.Control Or System.Windows.Forms.Keys.PageUp), System.Windows.Forms.Keys)
		Me.mnuActionsPrev.Size = New System.Drawing.Size(211, 22)
		Me.mnuActionsPrev.Text = "Previous page"
		'
		'mnuActionsNext
		'
		Me.mnuActionsNext.Name = "mnuActionsNext"
		Me.mnuActionsNext.ShortcutKeys = CType((System.Windows.Forms.Keys.Control Or System.Windows.Forms.Keys.[Next]), System.Windows.Forms.Keys)
		Me.mnuActionsNext.Size = New System.Drawing.Size(211, 22)
		Me.mnuActionsNext.Text = "Next page"
		'
		'printDlg
		'
		Me.printDlg.UseEXDialog = True
		'
		'frmMain
		'
		Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
		Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		Me.ClientSize = New System.Drawing.Size(688, 444)
		Me.Controls.Add(Me.vScrollBar)
		Me.Controls.Add(Me.hScrollBar)
		Me.Controls.Add(Me.menuStrip)
		Me.Name = "frmMain"
		Me.Text = "PDF-XChange Editor Simple SDK VB.net Demo Sample"
		Me.menuStrip.ResumeLayout(False)
		Me.menuStrip.PerformLayout()
		Me.ResumeLayout(False)
		Me.PerformLayout()

	End Sub
	Private WithEvents mnuActionsZoomIn As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents mnuActionsZoomOut As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents toolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Private WithEvents mnuActionsActualSize As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents mnuHelp As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents mnuHelpAbout As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents vScrollBar As System.Windows.Forms.VScrollBar
    Private WithEvents hScrollBar As System.Windows.Forms.HScrollBar
    Private WithEvents openDlg As System.Windows.Forms.OpenFileDialog
    Private WithEvents mnuActionsLast As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents mnuFileOpen As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents toolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Private WithEvents menuStrip As System.Windows.Forms.MenuStrip
    Private WithEvents mnuFile As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents mnuFileExit As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents mnuFileActions As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents mnuActionsFirst As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents mnuActionsPrev As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents mnuActionsNext As System.Windows.Forms.ToolStripMenuItem
    Private WithEvents printDlg As System.Windows.Forms.PrintDialog
    Friend WithEvents mnuFilePrint As System.Windows.Forms.ToolStripMenuItem

End Class
