namespace PDFXEditSimple
{
    partial class frmMain
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
			this.menuStrip = new System.Windows.Forms.MenuStrip();
			this.mnuFile = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuFileOpen = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
			this.mnuFilePrint = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuFileExit = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuFileActions = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuActionsFirst = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuActionsPrev = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuActionsNext = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuActionsLast = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
			this.mnuActionsActualSize = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuActionsZoomIn = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuActionsZoomOut = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuHelp = new System.Windows.Forms.ToolStripMenuItem();
			this.mnuHelpAbout = new System.Windows.Forms.ToolStripMenuItem();
			this.openDlg = new System.Windows.Forms.OpenFileDialog();
			this.printDlg = new System.Windows.Forms.PrintDialog();
			this.pdfViewCtl1 = new PDFViewCtl();
			this.vScrollBar1 = new System.Windows.Forms.VScrollBar();
			this.hScrollBar1 = new System.Windows.Forms.HScrollBar();
			this.menuStrip.SuspendLayout();
			this.SuspendLayout();
			// 
			// menuStrip
			// 
			this.menuStrip.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
			this.menuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuFile,
            this.mnuFileActions,
            this.mnuHelp});
			this.menuStrip.Location = new System.Drawing.Point(0, 0);
			this.menuStrip.Name = "menuStrip";
			this.menuStrip.Size = new System.Drawing.Size(781, 24);
			this.menuStrip.TabIndex = 1;
			this.menuStrip.Text = "menuStrip";
			// 
			// mnuFile
			// 
			this.mnuFile.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuFileOpen,
            this.toolStripMenuItem1,
            this.toolStripSeparator1,
            this.mnuFilePrint,
            this.mnuFileExit});
			this.mnuFile.Name = "mnuFile";
			this.mnuFile.Size = new System.Drawing.Size(37, 20);
			this.mnuFile.Text = "File";
			// 
			// mnuFileOpen
			// 
			this.mnuFileOpen.Name = "mnuFileOpen";
			this.mnuFileOpen.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.O)));
			this.mnuFileOpen.Size = new System.Drawing.Size(165, 22);
			this.mnuFileOpen.Text = "Open...";
			this.mnuFileOpen.Click += new System.EventHandler(this.mnuFileOpen_Click);
			// 
			// toolStripMenuItem1
			// 
			this.toolStripMenuItem1.Name = "toolStripMenuItem1";
			this.toolStripMenuItem1.Size = new System.Drawing.Size(165, 22);
			this.toolStripMenuItem1.Text = "Open from URL...";
			this.toolStripMenuItem1.Click += new System.EventHandler(this.mnuOpenFromURL_Click);
			// 
			// toolStripSeparator1
			// 
			this.toolStripSeparator1.Name = "toolStripSeparator1";
			this.toolStripSeparator1.Size = new System.Drawing.Size(162, 6);
			// 
			// mnuFilePrint
			// 
			this.mnuFilePrint.Name = "mnuFilePrint";
			this.mnuFilePrint.Size = new System.Drawing.Size(165, 22);
			this.mnuFilePrint.Text = "Print...";
			this.mnuFilePrint.Click += new System.EventHandler(this.mnuFilePrint_Click);
			// 
			// mnuFileExit
			// 
			this.mnuFileExit.Name = "mnuFileExit";
			this.mnuFileExit.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Alt | System.Windows.Forms.Keys.X)));
			this.mnuFileExit.Size = new System.Drawing.Size(165, 22);
			this.mnuFileExit.Text = "Exit";
			this.mnuFileExit.Click += new System.EventHandler(this.mnuFileExit_Click);
			// 
			// mnuFileActions
			// 
			this.mnuFileActions.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuActionsFirst,
            this.mnuActionsPrev,
            this.mnuActionsNext,
            this.mnuActionsLast,
            this.toolStripSeparator2,
            this.mnuActionsActualSize,
            this.mnuActionsZoomIn,
            this.mnuActionsZoomOut});
			this.mnuFileActions.Name = "mnuFileActions";
			this.mnuFileActions.Size = new System.Drawing.Size(59, 20);
			this.mnuFileActions.Text = "Actions";
			// 
			// mnuActionsFirst
			// 
			this.mnuActionsFirst.Name = "mnuActionsFirst";
			this.mnuActionsFirst.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Home)));
			this.mnuActionsFirst.Size = new System.Drawing.Size(211, 22);
			this.mnuActionsFirst.Text = "First page";
			this.mnuActionsFirst.Click += new System.EventHandler(this.mnuActionsFirst_Click);
			// 
			// mnuActionsPrev
			// 
			this.mnuActionsPrev.Name = "mnuActionsPrev";
			this.mnuActionsPrev.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.PageUp)));
			this.mnuActionsPrev.Size = new System.Drawing.Size(211, 22);
			this.mnuActionsPrev.Text = "Previous page";
			this.mnuActionsPrev.Click += new System.EventHandler(this.mnuActionsPrev_Click);
			// 
			// mnuActionsNext
			// 
			this.mnuActionsNext.Name = "mnuActionsNext";
			this.mnuActionsNext.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Next)));
			this.mnuActionsNext.Size = new System.Drawing.Size(211, 22);
			this.mnuActionsNext.Text = "Next page";
			this.mnuActionsNext.Click += new System.EventHandler(this.mnuActionsNext_Click);
			// 
			// mnuActionsLast
			// 
			this.mnuActionsLast.Name = "mnuActionsLast";
			this.mnuActionsLast.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.End)));
			this.mnuActionsLast.Size = new System.Drawing.Size(211, 22);
			this.mnuActionsLast.Text = "Last page";
			this.mnuActionsLast.Click += new System.EventHandler(this.mnuActionsLast_Click);
			// 
			// toolStripSeparator2
			// 
			this.toolStripSeparator2.Name = "toolStripSeparator2";
			this.toolStripSeparator2.Size = new System.Drawing.Size(208, 6);
			// 
			// mnuActionsActualSize
			// 
			this.mnuActionsActualSize.Name = "mnuActionsActualSize";
			this.mnuActionsActualSize.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.U)));
			this.mnuActionsActualSize.Size = new System.Drawing.Size(211, 22);
			this.mnuActionsActualSize.Text = "Actual size";
			this.mnuActionsActualSize.Click += new System.EventHandler(this.mnuActionsActualSize_Click);
			// 
			// mnuActionsZoomIn
			// 
			this.mnuActionsZoomIn.Name = "mnuActionsZoomIn";
			this.mnuActionsZoomIn.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.I)));
			this.mnuActionsZoomIn.Size = new System.Drawing.Size(211, 22);
			this.mnuActionsZoomIn.Text = "Zoom In";
			this.mnuActionsZoomIn.Click += new System.EventHandler(this.mnuActionsZoomIn_Click);
			// 
			// mnuActionsZoomOut
			// 
			this.mnuActionsZoomOut.Name = "mnuActionsZoomOut";
			this.mnuActionsZoomOut.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.O)));
			this.mnuActionsZoomOut.Size = new System.Drawing.Size(211, 22);
			this.mnuActionsZoomOut.Text = "Zoom Out";
			this.mnuActionsZoomOut.Click += new System.EventHandler(this.mnuActionsZoomOut_Click);
			// 
			// mnuHelp
			// 
			this.mnuHelp.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuHelpAbout});
			this.mnuHelp.Name = "mnuHelp";
			this.mnuHelp.Size = new System.Drawing.Size(44, 20);
			this.mnuHelp.Text = "Help";
			// 
			// mnuHelpAbout
			// 
			this.mnuHelpAbout.Name = "mnuHelpAbout";
			this.mnuHelpAbout.Size = new System.Drawing.Size(116, 22);
			this.mnuHelpAbout.Text = "About...";
			this.mnuHelpAbout.Click += new System.EventHandler(this.mnuHelpAbout_Click);
			// 
			// openDlg
			// 
			this.openDlg.Filter = "PDF files (*.pdf)|*.pdf";
			// 
			// printDlg
			// 
			this.printDlg.UseEXDialog = true;
			// 
			// pdfViewCtl1
			// 
			this.pdfViewCtl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.pdfViewCtl1.Location = new System.Drawing.Point(0, 24);
			this.pdfViewCtl1.Margin = new System.Windows.Forms.Padding(0);
			this.pdfViewCtl1.Name = "pdfViewCtl1";
			this.pdfViewCtl1.OffsetX = 0;
			this.pdfViewCtl1.OffsetY = 0;
			this.pdfViewCtl1.PageNumber = 0;
			this.pdfViewCtl1.Size = new System.Drawing.Size(764, 587);
			this.pdfViewCtl1.TabIndex = 4;
			this.pdfViewCtl1.Zoom = 1D;
			this.pdfViewCtl1.Resize += new System.EventHandler(this.pdfViewCtl1_Resize);
			// 
			// vScrollBar1
			// 
			this.vScrollBar1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.vScrollBar1.Location = new System.Drawing.Point(764, 24);
			this.vScrollBar1.Name = "vScrollBar1";
			this.vScrollBar1.Size = new System.Drawing.Size(17, 588);
			this.vScrollBar1.TabIndex = 5;
			this.vScrollBar1.Scroll += new System.Windows.Forms.ScrollEventHandler(this.vScrollBar1_Scroll);
			// 
			// hScrollBar1
			// 
			this.hScrollBar1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.hScrollBar1.Location = new System.Drawing.Point(0, 611);
			this.hScrollBar1.Name = "hScrollBar1";
			this.hScrollBar1.Size = new System.Drawing.Size(765, 17);
			this.hScrollBar1.TabIndex = 6;
			this.hScrollBar1.Scroll += new System.Windows.Forms.ScrollEventHandler(this.hScrollBar1_Scroll);
			// 
			// frmMain
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(781, 628);
			this.Controls.Add(this.hScrollBar1);
			this.Controls.Add(this.vScrollBar1);
			this.Controls.Add(this.pdfViewCtl1);
			this.Controls.Add(this.menuStrip);
			this.MainMenuStrip = this.menuStrip;
			this.Name = "frmMain";
			this.Text = "PDF-XChange Editor Simple SDK C# Demo Sample";
			this.menuStrip.ResumeLayout(false);
			this.menuStrip.PerformLayout();
			this.ResumeLayout(false);
			this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip;
        private System.Windows.Forms.ToolStripMenuItem mnuFile;
        private System.Windows.Forms.ToolStripMenuItem mnuFileOpen;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripMenuItem mnuFileExit;
        private System.Windows.Forms.ToolStripMenuItem mnuFileActions;
        private System.Windows.Forms.ToolStripMenuItem mnuActionsFirst;
        private System.Windows.Forms.ToolStripMenuItem mnuActionsPrev;
        private System.Windows.Forms.ToolStripMenuItem mnuActionsNext;
        private System.Windows.Forms.ToolStripMenuItem mnuActionsLast;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripMenuItem mnuActionsActualSize;
        private System.Windows.Forms.ToolStripMenuItem mnuActionsZoomIn;
        private System.Windows.Forms.ToolStripMenuItem mnuActionsZoomOut;
        private System.Windows.Forms.ToolStripMenuItem mnuHelp;
        private System.Windows.Forms.ToolStripMenuItem mnuHelpAbout;
        private System.Windows.Forms.OpenFileDialog openDlg;
        private System.Windows.Forms.PrintDialog printDlg;
        private System.Windows.Forms.ToolStripMenuItem mnuFilePrint;
        private PDFViewCtl pdfViewCtl1;
        private System.Windows.Forms.VScrollBar vScrollBar1;
        private System.Windows.Forms.HScrollBar hScrollBar1;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem1;
    }
}

