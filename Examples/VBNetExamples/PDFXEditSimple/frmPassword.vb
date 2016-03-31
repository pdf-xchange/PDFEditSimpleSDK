Public Class frmPassword
    Private m_password As String

    Public Function GetPassword() As String
        Return m_password
    End Function

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        m_password = txtPassword.Text
        Close()
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        m_password = ""
        Close()
    End Sub
End Class