using System;
using System.Runtime.InteropServices;

namespace PDFXEditSimpleLib
{
	public class PXCE_Helper
    {
        public static string BytesToString(byte[] bytes, int len)
        {
            string ret = "";
            for (int i = 0; i < len; i++)
            {
                if (bytes[i] == 0)
                    break;
                ret += (char)bytes[i];
            }
            return ret;
        }

        public static byte[] StringToBytes(string text)
        {
            byte[] bytes = new byte[text.Length];
            for (int i = 0; i < text.Length; i++)
            {
                bytes[i] = (byte)text[i];
            }
            return bytes;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct RECT
        {
            public Int32 left;
            public Int32 top;
            public Int32 right;
            public Int32 bottom;
        }
        /*
        public struct PRINTDLG
        {
            int lStructSize;
            int hwndOwner;
            int hDevMode;
            int hDevNames;
            int hDC;
            int Flags;
            int nFromPage;
            int nToPage;
            int nMinPage;
            int nMaxPage;
            int nCopies;
            int hInstance;
            int lCustData;
            int lpfnPrintHook;
            int lpfnSetupHook;
            int lpPrintTemplateName;
            int lpSetupTemplateName;
            int hPrintTemplate;
            int hSetupTemplate;
        }
        */


    }
}
