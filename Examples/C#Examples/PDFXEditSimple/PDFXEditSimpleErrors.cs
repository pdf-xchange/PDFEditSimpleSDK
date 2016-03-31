using System.Windows.Forms;
using System.Runtime.InteropServices;
using System;

namespace PDFXEditSimpleLib
{
	public class PXCE_Error
	{
		public static bool IS_DS_SUCCESSFUL(int x)
		{
			return (((x) & 0x80000000) == 0);
		}
		public static bool IS_DS_FAILED(int x)
		{
			return (((x) & 0x80000000) != 0);
		}

        //unchecked 
    
		public const int PS_ERR_NOTIMPLEMENTED          = unchecked((int)0x821404b0); // Not implemented 
        public const int PS_ERR_INVALID_ARG             = unchecked((int)0x82140001); // Invalid argument 
        public const int PS_ERR_MEMALLOC                = unchecked((int)0x821403e8); // Insufficient memory 
        public const int PS_ERR_USER_BREAK              = unchecked((int)0x821401f4); // Operation aborted by user 
        public const int PS_ERR_INTERNAL                = unchecked((int)0x82140011); // Internal error 
        public const int PS_ERR_INVALID_FILE_FORMAT     = unchecked((int)0x82140002); // Invalid file format 
        public const int PS_ERR_REQUIRED_PROP_NOT_SET   = unchecked((int)0x82142716); // Required property is not set 
        public const int PS_ERR_INVALID_PROP_TYPE       = unchecked((int)0x82142717); // Invalid property type 
        public const int PS_ERR_INVALID_PROP_VALUE      = unchecked((int)0x82142718); // Invalid property value 
        public const int PS_ERR_INVALID_OBJECT_NUM      = unchecked((int)0x82142719); // Invalid object number 
        public const int PS_ERR_INVALID_PS_OPERATOR     = unchecked((int)0x8214271c); // Invalid PS operator  
        public const int PS_ERR_UNKNOWN_OPERATOR        = unchecked((int)0x82142787); // Unknown operator 
        public const int PS_ERR_INVALID_CONTENT_STATE   = unchecked((int)0x82142788); // Invalid content state 
        public const int PS_ERR_NoPassword              = unchecked((int)0x821427a8); // No password 
        public const int PS_ERR_UnknowCryptFlt          = unchecked((int)0x821427a9); // Unknown crypt filter 
        public const int PS_ERR_WrongPassword           = unchecked((int)0x821427aa); // Wrong password 
        public const int PS_ERR_InvlaidObjStruct        = unchecked((int)0x821427ab); // Invalid object structure 
        public const int PS_ERR_WrongEncryptDict        = unchecked((int)0x821427ac); // Invalid encryption dictionary 
        public const int PS_ERR_DocEncrypted            = unchecked((int)0x821427ad); // Document encrypted 
        public const int PS_ERR_DocNOTEncrypted         = unchecked((int)0x821427ae); // Document not encrypted 
        public const int PS_ERR_WrongObjStream          = unchecked((int)0x821427af); // Invalid object stream 
        public const int PS_ERR_WrongTrailer            = unchecked((int)0x821427b0); // Invalid document trailer 
        public const int PS_ERR_WrongXRef               = unchecked((int)0x821427b1); // Invalid xref table 
        public const int PS_ERR_WrongDecodeParms        = unchecked((int)0x821427b2); // Invalid decode parameter(s) 
        public const int PS_ERR_XRefNotFounded          = unchecked((int)0x821427b3); // xref table is not foud 
        public const int PS_ERR_DocAlreadyRead          = unchecked((int)0x821427b4); // Document is already read 
        public const int PS_ERR_DocNotRead              = unchecked((int)0x821427b5); // Document is not read 

    
		public static void ShowDSErrorString(IWin32Window owner, int x)	
		{
			int sevLen = 0;
			int facLen = 0;
			int descLen = 0;

            byte[] sevBuf = null;
			byte[] facBuf = null;
			byte[] descBuf = null;

            sevLen = PDFXEdit.PXCV_Err_FormatSeverity(x, sevBuf, 0);
            facLen = PDFXEdit.PXCV_Err_FormatFacility(x, facBuf, 0);
            descLen = PDFXEdit.PXCV_Err_FormatErrorCode(x, descBuf, 0);
			
			sevBuf = new byte[sevLen];
			facBuf = new byte[facLen];
			descBuf = new byte[descLen];
			
			string s = "";
            if (PDFXEdit.PXCV_Err_FormatSeverity(x, sevBuf, sevLen) > 0)
				s = PXCE_Helper.BytesToString(sevBuf, sevLen);
			s += " [";
            if (PDFXEdit.PXCV_Err_FormatFacility(x, facBuf, facLen) > 0)
                s += PXCE_Helper.BytesToString(facBuf, facLen);
			s += "]: ";
            if (PDFXEdit.PXCV_Err_FormatErrorCode(x, descBuf, descLen) > 0)
                s += PXCE_Helper.BytesToString(descBuf, descLen);
			MessageBox.Show(owner, s, "PXCV36 Demo");
		}

	}
}