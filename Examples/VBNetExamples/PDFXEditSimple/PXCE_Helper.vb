Imports System.Runtime.InteropServices
Public Class PXCE_Helper
	Public Shared Function BytesToString(ByVal b() As Byte) As String
		Dim i As Integer
		Dim z As String = 0
		i = 0
		Do While (b(i) <> 0)
			z = z & Chr(b(i))
			i = i + 1
		Loop
		BytesToString = z
	End Function


	Public Shared Sub StringToBytes(ByRef a() As Byte, ByVal s As String)
		Dim i As Integer
		Dim z As String
		For i = 0 To Len(s)
			z = Mid(s, i, 1)
			a(i - 1) = Asc(z)
		Next
		a(i - 1) = 0
	End Sub

	<StructLayout(LayoutKind.Sequential, Pack:=1)>
	Public Structure RECT
		Public Left As Integer
		Public Top As Integer
		Public Right As Integer
		Public Bottom As Integer
	End Structure
End Class
