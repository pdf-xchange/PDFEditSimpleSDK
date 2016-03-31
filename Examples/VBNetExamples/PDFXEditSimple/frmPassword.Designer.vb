<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmPassword
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
		Me.btnCancel = New System.Windows.Forms.Button()
		Me.btnOK = New System.Windows.Forms.Button()
		Me.txtPassword = New System.Windows.Forms.TextBox()
		Me.label1 = New System.Windows.Forms.Label()
		Me.SuspendLayout()
		'
		'btnCancel
		'
		Me.btnCancel.Location = New System.Drawing.Point(283, 33)
		Me.btnCancel.Name = "btnCancel"
		Me.btnCancel.Size = New System.Drawing.Size(75, 23)
		Me.btnCancel.TabIndex = 7
		Me.btnCancel.Text = "Cancel"
		Me.btnCancel.UseVisualStyleBackColor = True
		'
		'btnOK
		'
		Me.btnOK.Location = New System.Drawing.Point(202, 33)
		Me.btnOK.Name = "btnOK"
		Me.btnOK.Size = New System.Drawing.Size(75, 23)
		Me.btnOK.TabIndex = 6
		Me.btnOK.Text = "OK"
		Me.btnOK.UseVisualStyleBackColor = True
		'
		'txtPassword
		'
		Me.txtPassword.Location = New System.Drawing.Point(76, 7)
		Me.txtPassword.Name = "txtPassword"
		Me.txtPassword.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
		Me.txtPassword.Size = New System.Drawing.Size(282, 20)
		Me.txtPassword.TabIndex = 5
		'
		'label1
		'
		Me.label1.AutoSize = True
		Me.label1.Location = New System.Drawing.Point(12, 10)
		Me.label1.Name = "label1"
		Me.label1.Size = New System.Drawing.Size(56, 13)
		Me.label1.TabIndex = 4
		Me.label1.Text = "Password:"
		'
		'frmPassword
		'
		Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
		Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		Me.ClientSize = New System.Drawing.Size(370, 71)
		Me.Controls.Add(Me.btnCancel)
		Me.Controls.Add(Me.btnOK)
		Me.Controls.Add(Me.txtPassword)
		Me.Controls.Add(Me.label1)
		Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
		Me.MaximizeBox = False
		Me.Name = "frmPassword"
		Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
		Me.Text = "PDF-XChange Editor Simple SDK VB.net Demo"
		Me.ResumeLayout(False)
		Me.PerformLayout()

	End Sub
	Private WithEvents btnCancel As System.Windows.Forms.Button
    Private WithEvents btnOK As System.Windows.Forms.Button
    Private WithEvents txtPassword As System.Windows.Forms.TextBox
    Private WithEvents label1 As System.Windows.Forms.Label
End Class
