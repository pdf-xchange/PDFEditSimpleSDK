using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace PDFXEditSimple
{
    public partial class frmPassword : Form
    {
        string m_password;

        public string GetPassword()
        {
            return m_password;
        }
               
        public frmPassword()
        {
            InitializeComponent();
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            m_password = txtPassword.Text;
            Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            m_password = "";
            Close();
        }
    }
}