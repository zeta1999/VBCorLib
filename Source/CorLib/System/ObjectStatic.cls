VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ObjectStatic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'The MIT License (MIT)
'Copyright (c) 2015 Kelly Ethridge
'
'Permission is hereby granted, free of charge, to any person obtaining a copy
'of this software and associated documentation files (the "Software"), to deal
'in the Software without restriction, including without limitation the rights to
'use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
'the Software, and to permit persons to whom the Software is furnished to do so,
'subject to the following conditions:
'
'The above copyright notice and this permission notice shall be included in all
'copies or substantial portions of the Software.
'
'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
'INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
'PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
'FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
'OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
'DEALINGS IN THE SOFTWARE.
'
'
' Module: ObjectStatic
'

''
' Provides default implementations of the IObject interface.
'
Option Explicit
Private mDateAsDateTime As CorDateTime
Private mCharBuffer As SafeArray1d
Private mChars()    As Integer


''
' Returns a default hashcode for the specific value.
'
' @param Value The value to generate the hashcode for.
' @return The hashcode value.
' @remarks An object should never pass itself into this
' function. Instead, the object should implement the default
' hashcode by using MyBase.
' <pre>
' Public Function GetHashCode As Long
'     GetHashCode = MyBase.GetHashCode(Me)
' End Function
' </pre>
Public Function GetHashCode(ByRef Value As Variant) As Long
    Select Case VarType(Value)
        Case vbLong, vbInteger, vbByte, vbBoolean
            GetHashCode = CLng(Value)
        Case vbString
            GetHashCode = HashString(Value)
        Case vbDouble
            With AsDLong(CDbl(Value))
                GetHashCode = .LoDWord Xor .HiDWord
            End With
        Case vbSingle
            GetHashCode = AsLong(CSng(Value))
        Case vbDate
            With AsDLong(CDate(Value))
                GetHashCode = .LoDWord Xor .HiDWord
            End With
        Case vbCurrency
            With AsDLong(CCur(Value))
                GetHashCode = .LoDWord Xor .HiDWord
            End With
        Case vbObject, vbDataObject
            If Value Is Nothing Then
                Exit Function
            End If
            
            If TypeOf Value Is IObject Then
                Dim Obj As IObject
                Set Obj = Value
                GetHashCode = Obj.GetHashCode
            Else
                GetHashCode = ObjPtr(CUnk(Value))
            End If
        Case vbDecimal
            With AsDWord(Value)
                GetHashCode = .HiWord
            End With
            With MemDLong(VarPtr(Value) + 8)
                GetHashCode = GetHashCode Xor .LoDWord Xor .HiDWord
            End With
        Case vbUserDefinedType
            GetHashCode = HashUdt(Value)
    End Select
End Function

''
' Checks the equality of the two values.
'
' @param ObjA The first value to compare with.
' @param ObjB The second value to compare.
' @return <b>True</b> if the value and the object are the same instance; <b>False</b> otherwise.
' @remarks The two values must be of the same data-type to successfully be compared. For example
' a <b>vbLong</b> value of 1 will not be considered equal to a <b>vbInteger</b> value of 1.
Public Function Equals(ByRef ObjA As Variant, ByRef ObjB As Variant) As Boolean
    Dim Obj As IObject
    
    Select Case VarType(ObjA)
        Case vbString
            If VarType(ObjB) = vbString Then
                Equals = CorString.EqualsV(ObjA, ObjB)
            End If
        Case vbDate
            Equals = Statics.CorDateTime.Equals(ObjA, ObjB)
        Case vbObject
            If ObjA Is Nothing Then
                If IsObject(ObjB) Then
                    Equals = (ObjB Is Nothing)
                End If
            ElseIf TypeOf ObjA Is IObject Then
                Set Obj = ObjA
                Equals = Obj.Equals(ObjB)
            ElseIf IsObject(ObjB) Then
                If ObjB Is Nothing Then
                    Exit Function
                End If
                
                If TypeOf ObjB Is IObject Then
                    Set Obj = ObjB
                    Equals = Obj.Equals(ObjA)
                Else
                    Equals = (ObjA Is ObjB)
                End If
            End If
        Case vbUserDefinedType
            If VarType(ObjB) = vbUserDefinedType Then
                Equals = UdtEquals(ObjA, ObjB)
            End If
        Case vbNull
            Equals = IsNull(ObjB)
        Case vbEmpty
            Equals = IsEmpty(ObjB)
        Case VarType(ObjB)
            Equals = (ObjA = ObjB)
    End Select
End Function

''
' Returns a default string representation of an object.
'
' @param Value The value to create a string representation of.
' @param Format Will be applied if the value implements <em>IFormattable</em>.
' @param Provider Will be applied if the value implements <em>IFormattable</em>.
' @return A string representation of the value.
' @see IFormattable
' @see IFormatProvider
Public Function ToString(ByRef Value As Variant, Optional ByRef Format As String, Optional ByVal Provider As IFormatProvider) As String
    Dim ValueType As VbVarType
    
    ValueType = VarType(Value)
    
    If ValueType = vbVariant Then
        ' when the datatype is a variant, it contains a reference to the
        ' actual value, so we must dereference again to that value to
        ' get the actual datatype.
        ValueType = MemLong(DataPtr(Value)) And &HFF
    End If
    
    Select Case ValueType
        Case vbLong, vbInteger, vbByte, vbDouble, vbSingle, vbDecimal
            ToString = NumberFormatter.Format(Value, Format, Provider)
        Case vbDate
            Dim DateFormatter As DateTimeFormatInfo
            Set DateFormatter = DateTimeFormatInfo.GetInstance(Provider)
            mDateAsDateTime.InitFromDate Value, UnspecifiedKind
            ToString = DateFormatter.Format(mDateAsDateTime, Format)
        Case vbObject
            If Not Value Is Nothing Then
                If TypeOf Value Is IFormattable Then
                    Dim Formattable As IFormattable
                    Set Formattable = Value
                    ToString = Formattable.ToString(Format, Provider)
                ElseIf TypeOf Value Is IObject Then
                    Dim Obj As IObject
                    Set Obj = Value
                    ToString = Obj.ToString
                Else
                    ToString = TypeName(Value)
                End If
            End If
        Case vbUserDefinedType
            If IsInt64(Value) Then
                ToString = CallFunc_T_T_T_String(AddressOf Int64ToString, DataPtr(Value), VarPtr(Format), VarPtr(Provider))
            Else
                ToString = TypeName(Value)
            End If
        Case vbEmpty
            ToString = "Empty"
        Case vbNull
            ToString = "Null"
        Case vbMissing
        Case Else
            ToString = Value
    End Select
End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   Helpers
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Function HashString(ByRef Value As Variant) As Long
    mCharBuffer.cElements = Len(Value)
    mCharBuffer.pvData = StrPtr(Value)
    
    Dim i As Long
    For i = 0 To UBound(mChars)
        HashString = (HashString And &H3FFFFFF) * vbShift4Bits + mChars(i)
    Next
End Function

Private Function HashUdt(ByRef Value As Variant) As Long
    Dim Record As IRecordInfo
    Dim FieldNameCount  As Long
    Dim Result As Long
    
    Set Record = GetRecordInfo(Value)
    Record.GetFieldNames FieldNameCount, ByVal vbNullPtr
    
    If FieldNameCount > 0 Then
        Dim FieldNames()    As String
        Dim ValuePtr        As Long
        
        ReDim FieldNames(0 To FieldNameCount - 1)
        Record.GetFieldNames FieldNameCount, FieldNames(0)
        ValuePtr = DataPtr(Value)
                                
        Dim i As Long
        For i = 0 To FieldNameCount - 1
            Result = Result Xor GetHashCode(Record.GetField(ValuePtr, FieldNames(i)))
        Next
    End If
    
    HashUdt = Result
End Function

Private Function UdtEquals(ByRef ObjA As Variant, ByRef ObjB As Variant) As Boolean
    Dim ObjARecord As IRecordInfo
    Dim ObjBRecord As IRecordInfo
    
    Set ObjARecord = GetRecordInfo(ObjA)
    Set ObjBRecord = GetRecordInfo(ObjB)
    
    If ObjARecord.IsMatchingType(ObjBRecord) Then
        Dim FieldNameCount  As Long

        ObjARecord.GetFieldNames FieldNameCount, ByVal vbNullPtr
        
        If FieldNameCount > 0 Then
            Dim FieldNames()    As String
            Dim ObjAPtr         As Long
            Dim ObjBPtr         As Long
            
            ReDim FieldNames(0 To FieldNameCount - 1)
            ObjARecord.GetFieldNames FieldNameCount, FieldNames(0)
            ObjAPtr = DataPtr(ObjA)
            ObjBPtr = DataPtr(ObjB)

            Dim i As Long
            For i = 0 To FieldNameCount - 1
                If Not Equals(ObjARecord.GetField(ObjAPtr, FieldNames(i)), ObjARecord.GetField(ObjBPtr, FieldNames(i))) Then
                    Exit Function
                End If
            Next
        End If
        
        UdtEquals = True
    End If
End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   Constructors
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Sub Class_Initialize()
    With mCharBuffer
        .cDims = 1
        .cbElements = 2
    End With
    
    SAPtr(mChars) = VarPtr(mCharBuffer)
    Set mDateAsDateTime = New CorDateTime
End Sub

Private Sub Class_Terminate()
    SAPtr(mChars) = vbNullPtr
End Sub
