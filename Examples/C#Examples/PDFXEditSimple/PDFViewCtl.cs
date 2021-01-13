using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using PDFXEditSimpleLib;

namespace PDFXEditSimple
{
	public struct PageDimension
	{
		public double w;
		public double h;
	}

	public partial class PDFViewCtl : UserControl
	{
		private PDFDoc m_PDFDoc = null;
		private int m_PageNumber = 0;
		private double m_Zoom = 1.0;
		private Point m_Offset = new Point(0, 0);

		public PDFViewCtl()
		{
			InitializeComponent();
		}

		public void Attach(PDFDoc aPDFDoc)
		{
			if (m_PDFDoc != null)
				throw new ApplicationException("PDFViewCtl.Attach");

			m_PDFDoc = aPDFDoc;
			m_PageNumber = 0;
			m_Zoom = 1.0;
			m_Offset.X = 0;
			m_Offset.Y = 0;
		}

		public PDFDoc Detach()
		{
			PDFDoc aPDFDoc = m_PDFDoc;

			m_PDFDoc = null;

			return aPDFDoc;
		}

		public bool IsAttached
		{
			get
			{
				return (m_PDFDoc != null);
			}
		}

		public int OffsetX
		{
			get
			{
				return m_Offset.X;
			}

			set
			{
				m_Offset.X = value;
			}
		}

		public int OffsetY
		{
			get
			{
				return m_Offset.Y;
			}

			set
			{
				m_Offset.Y = value;
			}
		}

		public int PageNumber
		{
			get
			{
				return m_PageNumber;
			}
			set
			{
				m_PageNumber = value;
			}
		}

		public double Zoom
		{
			get
			{
				return m_Zoom;
			}
			set
			{
				m_Zoom = value;
			}
		}

		protected override void OnPaint(PaintEventArgs e)
		{
			Graphics aGraphics = e.Graphics;

			if (m_PDFDoc == null)
			{
				aGraphics.FillRectangle(Brushes.Gray, e.ClipRectangle);
				return;
			}
			IntPtr p1 = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(PXCE_Helper.RECT)));
			IntPtr p2 = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(PXCE_Helper.RECT)));
			PageDimension aPageDim;
			Size aPageSize = Size.Empty;
			Size aControlSize = this.ClientSize;
			PXCE_Helper.RECT aWholePage = new PXCE_Helper.RECT();
			PXCE_Helper.RECT aDrawRect = new PXCE_Helper.RECT();
			PDFXEdit.PXV_CommonRenderParameters aCommonRenderParam = new PDFXEdit.PXV_CommonRenderParameters();

			try
			{
				m_PDFDoc.GetPageDimensions(m_PageNumber, out aPageDim.w, out aPageDim.h);
				aPageSize.Width = (int)((aPageDim.w / 72.0 * aGraphics.DpiX) * m_Zoom);
				aPageSize.Height = (int)((aPageDim.h / 72.0 * aGraphics.DpiY) * m_Zoom);
				Region rgn1 = new Region(new Rectangle(-m_Offset.X, -m_Offset.Y,
					aPageSize.Width, aPageSize.Height));
				rgn1.Complement(new Rectangle(0, 0, aControlSize.Width, aControlSize.Height));
				aWholePage.left = -m_Offset.X;
				aWholePage.top = -m_Offset.Y;
				aWholePage.right = aWholePage.left + (int)((aPageDim.w / 72.0 * aGraphics.DpiX) * m_Zoom);
				aWholePage.bottom = aWholePage.top + (int)((aPageDim.h / 72.0 * aGraphics.DpiY) * m_Zoom);
				aDrawRect.left = 0;
				aDrawRect.top = 0;
				aDrawRect.right = aControlSize.Width;
				aDrawRect.bottom = aControlSize.Height;
				Marshal.StructureToPtr(aWholePage, p1, false);
				Marshal.StructureToPtr(aDrawRect, p2, false);
				aCommonRenderParam.WholePageRect = p1;
				aCommonRenderParam.DrawRect = p2;
				aCommonRenderParam.RenderTarget = PDFXEdit.PXCV_RenderMode.pxvrm_Viewing;
				aCommonRenderParam.Flags = 0;
				Rectangle rc = new Rectangle(0, 0, aControlSize.Width, aControlSize.Height);
				rc.Intersect(new Rectangle(-m_Offset.X, -m_Offset.Y, aPageSize.Width, aPageSize.Height));
				aGraphics.FillRectangle(Brushes.White, rc);
				aGraphics.FillRegion(Brushes.Gray, rgn1);
				rgn1.Dispose();
				m_PDFDoc.DrawPageToDC(aGraphics.GetHdc(), m_PageNumber, aCommonRenderParam);
				aGraphics.ReleaseHdc();
			}
			finally
			{
				Marshal.FreeHGlobal(p1);
				Marshal.FreeHGlobal(p2);
			}
		}
	}
}
