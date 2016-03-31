VERSION 5.00
Begin VB.Form frmPassword 
   Caption         =   "Enter password"
   ClientHeight    =   1260
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4605
   LinkTopic       =   "Form1"
   ScaleHeight     =   1260
   ScaleWidth      =   4605
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   2520
      TabIndex        =   3
      Top             =   720
      Width           =   1095
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   1200
      TabIndex        =   2
      Top             =   720
      Width           =   1095
   End
   Begin VB.TextBox txtPassword 
      Height          =   285
      Left            =   960
      TabIndex        =   1
      Top             =   120
      Width           =   3495
   End
   Begin VB.Label Label1 
      Caption         =   "Password:"
      Height          =   255
      Left            =   0
      TabIndex        =   0
      Top             =   120
      Width           =   735
   End
End
Attribute VB_Name = "frmPassword"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_OK As Boolean
Private m_Password As String

Private Sub cmdCancel_Click()
    m_OK = False
    Unload Me
End Sub

Private Sub cmdOK_Click()
    m_OK = True
    m_Password = txtPassword.Text
    Unload Me
End Sub

Public Function IsOK() As Boolean
    IsOK = m_OK
End Function

Public Function GetPassword() As String
    GetPassword = m_Password
End Function

Private Sub Form_Load()
    m_OK = False
End Sub
