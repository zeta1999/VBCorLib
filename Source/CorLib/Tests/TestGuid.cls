VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TestGuid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'
' TestGuid
'
Option Explicit

Private Const TEST_GUID As String = "{C200E360-38C5-11CE-AE62-08002B2B79EF}"
Private Const TEST_GUID_LOWER As String = "{C200E360-38C5-11CE-AE62-08002B2B79EE}"
Private Const TEST_GUID_UPPER As String = "{C200E360-38C5-11CE-AE62-08002B2B79FF}"


Public Sub TestToString()
    Dim s As String
    Dim G As VBCorLib.Guid
    
    Set G = Guid.Parse(TEST_GUID)
    
    Assert.AreEqual "{C200E360-38C5-11CE-AE62-08002B2B79EF}", G.ToString
    Assert.AreEqual "{C200E360-38C5-11CE-AE62-08002B2B79EF}", G.ToString("B")
    Assert.AreEqual "(C200E360-38C5-11CE-AE62-08002B2B79EF)", G.ToString("P")
    Assert.AreEqual "C200E360-38C5-11CE-AE62-08002B2B79EF", G.ToString("D")
    Assert.AreEqual "C200E36038C511CEAE6208002B2B79EF", G.ToString("N")
    
End Sub

Public Sub TestParse()
    Dim G As VBCorLib.Guid
    
    Set G = Guid.Parse("{C200E360-38C5-11CE-AE62-08002B2B79EF}")
    Assert.AreEqual TEST_GUID, G.ToString
    
    Set G = Guid.Parse("(C200E360-38C5-11CE-AE62-08002B2B79EF)")
    Assert.AreEqual TEST_GUID, G.ToString
    
    Set G = Guid.Parse("C200E360-38C5-11CE-AE62-08002B2B79EF")
    Assert.AreEqual TEST_GUID, G.ToString
    
    Set G = Guid.Parse("C200E36038C511CEAE6208002B2B79EF")
    Assert.AreEqual TEST_GUID, G.ToString

End Sub

Public Sub TestEquals()
    Dim G1 As VBCorLib.Guid
    Dim G2 As VBCorLib.Guid
    
    Set G1 = Guid.Parse(TEST_GUID)
    Set G2 = Guid.Parse(TEST_GUID)
    
    Assert.IsTrue G1.Equals(G2)
End Sub

Public Sub TestNotEquals()
    Dim G1 As VBCorLib.Guid
    Dim G2 As VBCorLib.Guid
    
    Set G1 = Guid.NewGuid
    Set G2 = Guid.Parse(TEST_GUID)
    
    Assert.IsFalse G1.Equals(G2)
End Sub

Public Sub TestCompareToEqual()
    Dim G1 As VBCorLib.Guid
    Dim G2 As VBCorLib.Guid
    
    Set G1 = Guid.Parse(TEST_GUID)
    Set G2 = Guid.Parse(TEST_GUID)
    
    Assert.AreEqual 0, G1.CompareTo(G2)
    Assert.AreEqual 0, G2.CompareTo(G1)
End Sub

Public Sub TestCompareTo()
    Dim lo As VBCorLib.Guid
    Dim hi As VBCorLib.Guid
    
    Set lo = Guid.Parse(TEST_GUID_LOWER)
    Set hi = Guid.Parse(TEST_GUID_UPPER)
    
    Assert.IsTrue lo.CompareTo(hi) < 0
    Assert.IsTrue hi.CompareTo(lo) > 0
End Sub

Public Sub TestGetHashCode()
    Dim G1 As VBCorLib.Guid
    Set G1 = Guid.Parse(TEST_GUID)
    
    Dim G2 As VBCorLib.Guid
    Set G2 = Guid.Parse(TEST_GUID)
    
    Dim G3 As VBCorLib.Guid
    Set G3 = Guid.NewGuid
    
    Assert.AreEqual G1.GetHashCode, G2.GetHashCode
    Assert.That G1.GetHashCode, Iz.Not.EqualTo(G3.GetHashCode)
End Sub

Public Sub TestToByteArray()
    Dim G As VBCorLib.Guid
    Dim b() As Byte
    
    Set G = Guid.Parse(TEST_GUID)
    b = G.ToByteArray
    Assert.AreEqual &H60, b(0)
    Assert.AreEqual &HE3, b(1)
    Assert.AreEqual 0, b(2)
    Assert.AreEqual &HC2, b(3)
    Assert.AreEqual &HC5, b(4)
    Assert.AreEqual &H38, b(5)
    Assert.AreEqual &HCE, b(6)
    Assert.AreEqual &H11, b(7)
    Assert.AreEqual &HAE, b(8)
    Assert.AreEqual &H62, b(9)
    Assert.AreEqual &H8, b(10)
    Assert.AreEqual &H0, b(11)
    Assert.AreEqual &H2B, b(12)
    Assert.AreEqual &H2B, b(13)
    Assert.AreEqual &H79, b(14)
    Assert.AreEqual &HEF, b(15)
End Sub

Public Sub TestFromByteArray()
    Dim G As VBCorLib.Guid
    Dim b() As Byte
    
    b = cArray.NewArray(ciByte, &H60, &HE3, &H0, &HC2, &HC5, &H38, &HCE, &H11, &HAE, &H62, &H8, &H0, &H2B, &H2B, &H79, &HEF)
    
    Set G = Guid.FromByteArray(b)
    
    Assert.AreEqual "{C200E360-38C5-11CE-AE62-08002B2B79EF}", G.ToString
End Sub

Public Sub TestPersistence()
    Dim G1 As VBCorLib.Guid
    Dim G2 As VBCorLib.Guid
    Dim pp1 As New PropertyBag
    Dim pp2 As New PropertyBag
    
    Set G1 = Guid.NewGuid
    pp1.WriteProperty "g", G1
    pp2.Contents = pp1.Contents
    
    Set G2 = pp2.ReadProperty("g")
    
    Assert.IsTrue G2.Equals(G1), "Guids should be equal."
    
End Sub

Public Sub TestEmpty()
    Assert.AreEqual "{00000000-0000-0000-0000-000000000000}", Guid.EmptyGuid.ToString
End Sub