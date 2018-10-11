using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Drawing.Printing;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;
using PDFXEditSimpleLib;

namespace PDFXEditSimple
{
    public partial class frmMain : Form
    {
        private PDFDoc m_PDFDoc = new PDFDoc();
        private int m_PageNumber;
        private const double m_MinZoom = 0.1;
        private const double m_MaxZoom = 16.0;
        private PrintDocument m_DocToPrint = new PrintDocument();
        private int m_PrintedPageCount = 0;

        public frmMain()
        {
            InitializeComponent();
            m_DocToPrint.PrintPage += new System.Drawing.Printing.PrintPageEventHandler(OnPrintPage);
        }

        private void OnChangeSize()
        {
            if (m_PDFDoc == null)
                return;

            PageDimension aPageDim;
            aPageDim.w = 0;
            aPageDim.h = 0;
            Graphics aGraphics = this.pdfViewCtl1.CreateGraphics();
            Size aControlSize;
            double aZoom = this.pdfViewCtl1.Zoom;

            try
            {
                aControlSize = this.pdfViewCtl1.ClientSize;
                try
                {
                    m_PDFDoc.GetPageDimensions(m_PageNumber, out aPageDim.w, out aPageDim.h);
                }
                catch (ApplicationException e)
                {
                    Console.WriteLine(e.Message);
                };
                this.hScrollBar1.Minimum = 0;
                this.vScrollBar1.Minimum = 0;
                this.hScrollBar1.Maximum = (int)Math.Max(0, aPageDim.w * aGraphics.DpiX / 72.0 * aZoom - aControlSize.Width);
                if (this.hScrollBar1.Maximum == 0)
                    this.hScrollBar1.Enabled = false;
                else
                {
                    this.hScrollBar1.SmallChange = 1;
                    this.hScrollBar1.LargeChange = Math.Min(this.hScrollBar1.Maximum, aControlSize.Width);
                    this.hScrollBar1.Maximum += this.hScrollBar1.LargeChange;
                    this.hScrollBar1.Enabled = true;
                }
                this.vScrollBar1.Maximum = (int)Math.Max(0, aPageDim.h * aGraphics.DpiY / 72.0 * aZoom - aControlSize.Height);
                if (this.vScrollBar1.Maximum == 0)
                    this.vScrollBar1.Enabled = false;
                else
                {
                    this.vScrollBar1.SmallChange = 1;
                    this.vScrollBar1.LargeChange = Math.Min(this.vScrollBar1.Maximum, aControlSize.Height);
                    this.vScrollBar1.Maximum += this.vScrollBar1.LargeChange;
                    this.vScrollBar1.Enabled = true;
                }
                this.hScrollBar1.Value = 0;
                this.vScrollBar1.Value = 0;
                this.pdfViewCtl1.OffsetX = this.hScrollBar1.Value;
                this.pdfViewCtl1.OffsetY = this.vScrollBar1.Value;
            }
            finally
            {
                aGraphics.Dispose();
            }
        }

		private String sKey = "KEY";

		private bool OpenPDF()
        {
            if (DialogResult.OK != openDlg.ShowDialog(this))
                return false;

            ClosePDF();
            try
            {

				m_PDFDoc.Init(sKey, String.Empty);
                m_PDFDoc.Open(openDlg.FileName);
                m_PageNumber = 0;
                this.pdfViewCtl1.Attach(m_PDFDoc);
                OnChangeSize();
                this.pdfViewCtl1.Refresh();
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message, "Application error", MessageBoxButtons.OK);
                m_PDFDoc.Delete();

                return false;
            }

            return true;
        }

        private bool OpenFromURL(IStream aIStream)
        {
            try
            {
                StringBuilder sb = new StringBuilder();

                ClosePDF();
                m_PDFDoc.Init(sKey, String.Empty);
                m_PDFDoc.OpenFromIStream(aIStream, 0);
                this.pdfViewCtl1.Attach(m_PDFDoc);
                OnChangeSize();
                this.pdfViewCtl1.Refresh();
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message, "Application error", MessageBoxButtons.OK);

                return false;
            }

            return true;
        }

        private void ClosePDF()
        {
            this.pdfViewCtl1.Detach();
            this.pdfViewCtl1.Refresh();
            if (m_PDFDoc.IsInitialized)
                m_PDFDoc.Delete();
        }

        private void ReleasePage(int pn)
        {
            m_PDFDoc.ReleasePageCachedData(pn, (int)PDFXEdit.PXCV_ReleaseCachedDataFlags.pxvrcd_ReleaseDocumentImages);
        }

        private void mnuFileOpen_Click(object sender, EventArgs e)
        {
            OpenPDF();
        }

        private void mnuOpenFromURL_Click(object sender, EventArgs e)
        {
            DlgOpenURL aDlg = new DlgOpenURL();

            aDlg.URL = "https://help.tracker-software.com/pdfxessdk7/EditorSimpleSDK_MAN.pdf";
            if (aDlg.ShowDialog() == DialogResult.OK)
            {
                WinHttp.WinHttpRequest aRequest = new WinHttp.WinHttpRequest();
                IStream aIStream;
                try
                {
                    aRequest = new WinHttp.WinHttpRequest();
                    aRequest.Open("GET", aDlg.URL, false);
                    aRequest.Send(null);
                    if (aRequest.ResponseStream is IStream)
                    {
                        aIStream = (IStream)aRequest.ResponseStream;
                        OpenFromURL(aIStream);
                    }
                }
                catch (Exception)
                {
                    MessageBox.Show("Open document error", "Application error", MessageBoxButtons.OK);
                }
            }
        }

        private void mnuActionsFirst_Click(object sender, EventArgs e)
        {
            if (this.pdfViewCtl1.PageNumber > 0)
            {
                ReleasePage(this.pdfViewCtl1.PageNumber);
                this.pdfViewCtl1.PageNumber = 0;
                OnChangeSize();
                this.pdfViewCtl1.Refresh();
            }
        }

        private void mnuActionsPrev_Click(object sender, EventArgs e)
        {
            if (this.pdfViewCtl1.PageNumber > 0)
            {
                ReleasePage(this.pdfViewCtl1.PageNumber);
                this.pdfViewCtl1.PageNumber = this.pdfViewCtl1.PageNumber - 1;
                OnChangeSize();
                this.pdfViewCtl1.Refresh();
            }
        }

        private void mnuActionsNext_Click(object sender, EventArgs e)
        {
            if (!m_PDFDoc.IsInitialized)
                return;

            int n = m_PDFDoc.GetPagesCount();
            if (this.pdfViewCtl1.PageNumber + 1 < n)
            {
                ReleasePage(this.pdfViewCtl1.PageNumber);
                this.pdfViewCtl1.PageNumber = this.pdfViewCtl1.PageNumber + 1;
                OnChangeSize();
                this.pdfViewCtl1.Refresh();
            }
        }

        private void mnuActionsLast_Click(object sender, EventArgs e)
        {
            if (!m_PDFDoc.IsInitialized)
                return;

            int n = m_PDFDoc.GetPagesCount();
            if (this.pdfViewCtl1.PageNumber + 1 < n)
            {
                ReleasePage(this.pdfViewCtl1.PageNumber);
                this.pdfViewCtl1.PageNumber = n - 1;
                OnChangeSize();
                this.pdfViewCtl1.Refresh();
            }
        }

        private void mnuActionsActualSize_Click(object sender, EventArgs e)
        {
            if (!m_PDFDoc.IsInitialized)
                return;

            this.pdfViewCtl1.Zoom = 1.0;
            OnChangeSize();
            this.pdfViewCtl1.Refresh();
        }

        private void mnuActionsZoomIn_Click(object sender, EventArgs e)
        {
            if (!m_PDFDoc.IsInitialized)
                return;

            double aZoom = this.pdfViewCtl1.Zoom;

            aZoom = Math.Min(16.0, aZoom * 2);
            this.pdfViewCtl1.Zoom = aZoom;
            OnChangeSize();
            this.pdfViewCtl1.Refresh();
        }

        private void mnuActionsZoomOut_Click(object sender, EventArgs e)
        {
            if (!m_PDFDoc.IsInitialized)
                return;

            double aZoom = this.pdfViewCtl1.Zoom;

            aZoom = Math.Max(0.1, aZoom / 2);
            this.pdfViewCtl1.Zoom = aZoom;
            OnChangeSize();
            this.pdfViewCtl1.Refresh();
        }

        private void mnuHelpAbout_Click(object sender, EventArgs e)
        {
            frmAbout about = new frmAbout();
            about.ShowDialog();
        }

        private void mnuFileExit_Click(object sender, EventArgs e)
        {
            ClosePDF();
            this.Close();
        }

        private void OnPrintPage(object sender, System.Drawing.Printing.PrintPageEventArgs e)
        {
            int nPrintPageNum = m_PrintedPageCount;

			PDFXEdit.PXV_CommonRenderParameters crp;
            IntPtr hDC = IntPtr.Zero;
            PaperSize aPaperSize = e.PageSettings.PaperSize;
            double doc_page_w;
            double doc_page_h;

            crp.WholePageRect = IntPtr.Zero;
            crp.DrawRect = IntPtr.Zero;
            try
            {
                PXCE_Helper.RECT pr;

                m_PDFDoc.GetPageDimensions(nPrintPageNum, out doc_page_w, out doc_page_h);
                doc_page_w = doc_page_w / 72.0 * 100;                   // convert points to hundredths of an inch
                doc_page_h = doc_page_h / 72.0 * 100;                   // convert points to hundredths of an inch
                double k1 = (double)aPaperSize.Width / (double)aPaperSize.Height;
                double k2 = doc_page_w / doc_page_h;

                if (k1 < k2)
                {
                    doc_page_w = Math.Min(doc_page_w, (double)aPaperSize.Width);
                    doc_page_h = doc_page_w / k2;
                }
                else
                {
                    doc_page_h = Math.Min(doc_page_h, (double)aPaperSize.Height);
                    doc_page_w = doc_page_h * k2;
                }

                pr.left = (int)(e.PageSettings.HardMarginX + (double)aPaperSize.Width - doc_page_w) / 2;
                pr.right = pr.left + (int)doc_page_w;
                pr.top = (int)(e.PageSettings.HardMarginY + (double)aPaperSize.Height - doc_page_h) / 2;
                pr.bottom = pr.top + (int)doc_page_h;

                pr.left *= e.PageSettings.PrinterResolution.X / 100;    // convert to device units
                pr.right *= e.PageSettings.PrinterResolution.X / 100;   // convert to device units
                pr.top *= e.PageSettings.PrinterResolution.Y / 100;     // convert to device units
                pr.bottom *= e.PageSettings.PrinterResolution.Y / 100;  // convert to device units

                crp.Flags = (int)PDFXEdit.PXV_CommonRenderParametersFlags.pxvrpf_UseVectorRenderer;
                crp.RenderTarget = PDFXEdit.PXCV_RenderMode.pxvrm_Printing;
                crp.WholePageRect = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(PXCE_Helper.RECT)));
                Marshal.StructureToPtr(pr, crp.WholePageRect, false);
                hDC = e.Graphics.GetHdc();
                m_PDFDoc.DrawPageToDC(hDC, nPrintPageNum, crp);
                m_PrintedPageCount++;
                e.HasMorePages = m_PrintedPageCount < m_PDFDoc.GetPagesCount();
            }
            catch (Exception)
            {
                e.HasMorePages = false;
            }
            finally
            {
                if (hDC != IntPtr.Zero)
                    e.Graphics.ReleaseHdc(hDC);
                if (crp.WholePageRect != IntPtr.Zero)
                    Marshal.FreeHGlobal(crp.WholePageRect);
            }
        }

        private void PrintPdfFile(IntPtr hParentWnd)
        {
            m_PrintedPageCount = 0;
            m_DocToPrint.DocumentName = "PXC-View PDF Print";
            printDlg.AllowSomePages = true;
            printDlg.ShowHelp = true;
            printDlg.Document = m_DocToPrint;
            printDlg.Document.PrinterSettings.FromPage = 1;
            printDlg.Document.PrinterSettings.MinimumPage = 1;
            printDlg.Document.PrinterSettings.ToPage = 1;
            printDlg.Document.PrinterSettings.Copies = 1;

            DialogResult result = printDlg.ShowDialog();
            if (result == DialogResult.OK)
            {
                m_DocToPrint.Print();
            }
        }

        private void mnuFilePrint_Click(object sender, EventArgs e)
        {
            PrintPdfFile(this.Handle);
        }

        private void vScrollBar1_Scroll(object sender, ScrollEventArgs e)
        {
            this.pdfViewCtl1.OffsetY = e.NewValue;
            this.pdfViewCtl1.Refresh();
        }

        private void hScrollBar1_Scroll(object sender, ScrollEventArgs e)
        {
            this.pdfViewCtl1.OffsetX = e.NewValue;
            this.pdfViewCtl1.Refresh();
        }

        private void pdfViewCtl1_Resize(EventArgs e)
        {
        }

        private void pdfViewCtl1_Resize(object sender, EventArgs e)
        {
            OnChangeSize();
            this.pdfViewCtl1.Refresh();
        }
    }
}