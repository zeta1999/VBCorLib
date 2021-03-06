VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CorStringTests"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'
' CorStringTests
'
Option Explicit
Implements ITestCaseSource
Implements ICategorizable

Private Sub ICategorizable_Categorize(ByVal Cat As SimplyVBComp.CategoryCollector)
    Cat.ForFixture "System"
End Sub

Private Sub ITestCaseSource_GetTestCases(ByVal Test As SimplyVBComp.TestCaseCollector)
    Select Case Test.MethodName
        Case "ToCharArray_WithString_ReturnsArrayOfCharacters"
            Test.Use "Hello", NewIntegers(Asc("H"), Asc("e"), Asc("l"), Asc("l"), Asc("o"))
            Test.Use "", NewIntegers()
            
        Case "NewString_WithArrayOfCharacters_ReturnsExpected"
            Test.Use NewIntegers(Asc("H"), Asc("e"), Asc("l"), Asc("l"), Asc("o")), "Hello"
            Test.Use NewIntegers(), ""
        
        Case "IsNullOrWhitespace_WithValues_ReturnsExpected"
            Test.Use "", True
            Test.Use "a", False
            Test.Use " ", True
            Test.Use " a ", False
            Test.Use WhiteSpaces, True
            
        Case "TrimStart_WithDefaultWhiteSpace_TrimsWhiteSpaceFromStart"
            Test.Use "", ""
            Test.Use WhiteSpaces, ""
            Test.Use "hello" & WhiteSpaces, "hello" & WhiteSpaces
            Test.Use WhiteSpaces & "hello", "hello"
        
        Case "TrimStart_WithValues_ReturnsExpected"
            Test.Use "", WhiteSpaces, ""
            Test.Use WhiteSpaces & "hello" & WhiteSpaces, WhiteSpaces, "hello" & WhiteSpaces
            Test.Use "hello" & WhiteSpaces, "helo", WhiteSpaces
            Test.Use "hello" & WhiteSpaces, NewIntegers(104, 101, 108, 111), WhiteSpaces
            Test.Use "hello", "helo", ""
            Test.Use "hello", NewIntegers(104, 101, 108, 111), ""
            Test.Use "hello", WhiteSpaces, "hello"
            Test.Use WhiteSpaces & "hello", "", WhiteSpaces & "hello"
            
        Case "TrimEnd_WithDefaultWhiteSpace_TrimsWhiteSpaceFromEnd"
            Test.Use "", ""
            Test.Use WhiteSpaces, ""
            Test.Use "hello" & WhiteSpaces, "hello"
            Test.Use WhiteSpaces & "hello", WhiteSpaces & "hello"
        
        Case "TrimEnd_WithValues_ReturnsExpected"
            Test.Use "", WhiteSpaces, ""
            Test.Use WhiteSpaces & "hello" & WhiteSpaces, WhiteSpaces, WhiteSpaces & "hello"
            Test.Use WhiteSpaces & "hello", "helo", WhiteSpaces
            Test.Use WhiteSpaces & "hello", NewIntegers(104, 101, 108, 111), WhiteSpaces
            Test.Use "hello", "helo", ""
            Test.Use "hello", NewIntegers(104, 101, 108, 111), ""
            Test.Use "hello", WhiteSpaces, "hello"
            Test.Use "hello" & WhiteSpaces, "", "hello" & WhiteSpaces
        
        Case "Trim_WithDefaultWhiteSpace_TrimsWhiteSpace"
            Test.Use "", ""
            Test.Use WhiteSpaces, ""
            Test.Use "hello" & WhiteSpaces, "hello"
            Test.Use WhiteSpaces & "hello", "hello"
            
        Case "Trim_WithValues_ReturnsExpected"
            Test.Use "", WhiteSpaces, ""
            Test.Use WhiteSpaces & "hello" & WhiteSpaces, WhiteSpaces, "hello"
            Test.Use WhiteSpaces & "hello" & WhiteSpaces, WhiteSpaceChars, "hello"
            Test.Use "hello" & WhiteSpaces, "helo", WhiteSpaces
            Test.Use WhiteSpaces & "hello", "helo", WhiteSpaces
            Test.Use "hello", "helo", ""
            Test.Use "hello", NewIntegers(104, 101, 108, 111), ""
            Test.Use "hello", WhiteSpaces, "hello"
            
        Case "Remove_WithValues_RemovesExpected"
            Test.Use 0, 10, ""
            Test.Use 1, 9, "1"
            Test.Use 0, 9, "0"
            Test.Use 1, 8, "10"
            Test.Use 1, 0, "1234567890"
            
        Case "Remove_WithStartIndex_ReturnsExpected"
            Test.Use 0, ""
            Test.Use 1, "1"
            Test.Use 9, "123456789"
            Test.Use 10, "1234567890"
            
        Case "Join_WithLongsSubset_ReturnsJoined"
            Test.Use 0, 10, "1,2,3,4,5,6,7,8,9,0"
            Test.Use 1, 9, "2,3,4,5,6,7,8,9,0"
            Test.Use 0, 9, "1,2,3,4,5,6,7,8,9"
            Test.Use 1, 8, "2,3,4,5,6,7,8,9"
            
        Case "Join_WithEnumerableObject_ReturnsJoinedElements"
            Test.Use NewCollection(1, "hi", 2), "1,hi,2"
            Test.Use NewArrayList(Source:=Array(1, "hi", 2)), "1,hi,2"
            
        Case "Insert_WithValueAndIndex_ReturnsExpected"
            Test.Use 0, "ab", "ab1234567890"
            Test.Use 1, "ab", "1ab234567890"
            Test.Use 9, "ab", "123456789ab0"
            Test.Use 10, "ab", "1234567890ab"
            
        Case "IndexOfAny_WithValue_ReturnsExpected"
            Test.Use "1", 0
            Test.Use "0", 9
            Test.Use "675", 4
            Test.Use "ab5", 4
            Test.Use "abc", -1
            Test.Use NewChars("1"), 0
            Test.Use NewChars("0"), 9
            Test.Use NewChars("a", "b", "5"), 4
            Test.Use NewChars("a", "b", "c"), -1
            
        Case "IndexOfAny_WithStartIndex_ReturnsExpected"
            Test.Use "1", 1, 10
            Test.Use "0", 10, 19
            
        Case "LastIndexOfAny_WithValue_ReturnsExpected"
            Test.Use "5", 9
            Test.Use "1", 5
            Test.Use "ab1", 5
            Test.Use "6", -1
            Test.Use NewChars("1"), 5
            Test.Use NewChars("5"), 9
            Test.Use NewChars("a", "b", "1"), 5
            
        Case "LastIndexOfAny_WithStartIndexAndCount_ReturnsExpected"
            Test.Use "23", 7
            Test.Use "34", 7
            Test.Use "24", 6
            Test.Use "4", 3
            Test.Use "5", 4
            Test.Use NewChars("2", "3"), 7
            Test.Use NewChars("3", "4"), 7
            Test.Use NewChars("4"), 3
            Test.Use NewChars("5"), 4
            
        Case "LastIndexOfAny_WithStartIndex_ReturnsExpected"
            Test.Use "54", 6, 4
            Test.Use "14", 6, 5
            Test.Use "2", 6, 6
            Test.Use "3", 6, 2
        
        Case "Equals_WithValues_ReturnsExpected"
            Test.Use "a", "a", StringComparison.Ordinal, True
            Test.Use "b", "a", StringComparison.Ordinal, False
            Test.Use "a", "b", StringComparison.Ordinal, False
            Test.Use "A", "a", StringComparison.Ordinal, False
            Test.Use "a", "A", StringComparison.Ordinal, False
            Test.Use "a", "a", StringComparison.OrdinalIgnoreCase, True
            Test.Use "A", "a", StringComparison.OrdinalIgnoreCase, True
            Test.Use "a", "A", StringComparison.OrdinalIgnoreCase, True
            Test.Use "b", "a", StringComparison.OrdinalIgnoreCase, False
            Test.Use "a", "b", StringComparison.OrdinalIgnoreCase, False
            Test.Use Space$(10), Space$(10), StringComparison.Ordinal, True
            Test.Use Space$(10) & "a", Space$(10) & "b", StringComparison.Ordinal, False
            Test.Use "aa", "a", StringComparison.Ordinal, False
            Test.Use String$(10, "a"), String$(10, "A"), StringComparison.OrdinalIgnoreCase, True
            Test.Use Space$(10) & "a", Space$(10) & "b", StringComparison.OrdinalIgnoreCase, False
            Test.Use "aa", "a", StringComparison.OrdinalIgnoreCase, False
            Test.Use "", "", StringComparison.Ordinal, True
            Test.Use vbNullString, "", StringComparison.Ordinal, True
            Test.Use "", vbNullString, StringComparison.Ordinal, True
            Test.Use vbNullString, vbNullString, StringComparison.Ordinal, True
            
        Case "StartsWith_WithValues_ReturnsExpected"
            Test.Use "", "", True
            Test.Use vbNullString, vbNullString, True
            Test.Use "abc", "abc", True
            Test.Use "abcdef", "ab", True
            Test.Use "abcdef", "a", True
            Test.Use "abcdef", "", True
            Test.Use "abcdef", vbNullString, True
            Test.Use "abc", "b", False
            
        Case "StartsWith_WithValuesWhenIgnoringCase_ReturnsExpected"
            Test.Use "", "", True
            Test.Use vbNullString, vbNullString, True
            Test.Use "ABC", "abc", True
            Test.Use "abc", "AbC", True
            Test.Use "abcdef", "aB", True
            Test.Use "abcdef", "A", True
            Test.Use "abcdef", "a", True
            Test.Use "abcdef", "", True
            Test.Use "abcdef", vbNullString, True
            Test.Use "abc", "B", False
            Test.Use "abc", "b", False
        
        Case "EndsWith_WithValues_ReturnsExpected"
            Test.Use "", "", True
            Test.Use vbNullString, vbNullString, True
            Test.Use "abc", "abc", True
            Test.Use "abcdef", "ef", True
            Test.Use "abcdef", "f", True
            Test.Use "abcdef", "", True
            Test.Use "abcdef", vbNullString, True
            Test.Use "abc", "b", False
            
        Case "EndsWith_WithValuesWhenIgnoringCase_ReturnsExpected"
            Test.Use "", "", True
            Test.Use vbNullString, vbNullString, True
            Test.Use "ABC", "abc", True
            Test.Use "abc", "AbC", True
            Test.Use "abcdef", "Ef", True
            Test.Use "abcdef", "F", True
            Test.Use "abcdef", "f", True
            Test.Use "abcdef", "", True
            Test.Use "abcdef", vbNullString, True
            Test.Use "abc", "B", False
            Test.Use "abc", "b", False
        
        Case "Split_WithStringSeparators_ReturnsExpected"
            Test.Use "abc", NewStrings("b"), NewStrings("a", "c")
            Test.Use "abc", NewStrings("a"), NewStrings("", "bc")
            Test.Use "abc", NewStrings("c"), NewStrings("ab", "")
            Test.Use "abc", NewStrings("ab"), NewStrings("", "c")
            Test.Use "abc", NewStrings("bc"), NewStrings("a", "")
            Test.Use "abc", NewStrings("abc"), NewStrings("", "")
            Test.Use "abc", NewStrings("d"), NewStrings("abc")
            Test.Use "abc", NewStrings("a", "c"), NewStrings("", "b", "")
            Test.Use "abc", NewStrings("abcd"), NewStrings("abc")
            Test.Use "abcabc", NewStrings("b"), NewStrings("a", "ca", "c")
            Test.Use "abccda", NewStrings("c"), NewStrings("ab", "", "da")
            Test.Use "abccda", NewStrings("c", "d"), NewStrings("ab", "", "", "a")
            Test.Use "abcd", NewStrings(), NewStrings("abcd")
            Test.Use "abcd", NullStrings, NewStrings("abcd")
            Test.Use "abcd", NewStrings("ce"), NewStrings("abcd")
            Test.Use "abcd", NewStrings("de"), NewStrings("abcd")
            Test.Use "", NewStrings("b"), NewStrings("")
            Test.Use "", NewStrings(""), NewStrings("")
            Test.Use "", NewStrings(), NewStrings("")
            Test.Use vbNullString, NewStrings("b"), NewStrings("")
            Test.Use vbNullString, NewStrings(""), NewStrings("")
            Test.Use "a b c", NewStrings(), NewStrings("a", "b", "c")
            Test.Use "a b c", NullStrings, NewStrings("a", "b", "c")
            
        Case "Split_WithRemoveEmptyEntries_ReturnsFilledStringsOnly"
            Test.Use "abbc", NewStrings("b"), NewStrings("a", "c")
            Test.Use "abbc", NewStrings("a"), NewStrings("bbc")
            Test.Use "abbc", NewStrings("c"), NewStrings("abb")
            Test.Use "abbc", NewStrings("d"), NewStrings("abbc")
            Test.Use "abcd", NewStrings(), NewStrings("abcd")
            Test.Use "abcd", NullStrings, NewStrings("abcd")
            Test.Use "abcd", NewStrings("ce"), NewStrings("abcd")
            Test.Use "abcd", NewStrings("de"), NewStrings("abcd")
            Test.Use "", NewStrings("b"), NewStrings()
            Test.Use "", NewStrings(""), NewStrings()
            
        Case "Split_WithCount_ReturnsLimitedNumberOfSubstrings"
            Test.Use "abc", NewStrings("b"), 2, NewStrings("a", "c")
            Test.Use "abc", NewStrings("b"), 3, NewStrings("a", "c")
            Test.Use "abc", NewStrings("b"), 1, NewStrings("abc")
            Test.Use "abc", NewStrings("b"), 0, NewStrings()
            Test.Use "", NewStrings("b"), 1, NewStrings("")
            Test.Use "", NewStrings("b"), 0, NewStrings()
            Test.Use "", NewStrings(""), 5, NewStrings("")
            
        Case "Split_WithCharSeparators_ReturnsExpected"
            Test.Use "abc", NewChars("b"), NewStrings("a", "c")
            Test.Use "abc", NewChars("a"), NewStrings("", "bc")
            Test.Use "abc", NewChars("c"), NewStrings("ab", "")
            Test.Use "abc", NewChars("d"), NewStrings("abc")
            Test.Use "abc", NewChars("a", "c"), NewStrings("", "b", "")
            Test.Use "abcabc", NewChars("b"), NewStrings("a", "ca", "c")
            Test.Use "abccda", NewChars("c"), NewStrings("ab", "", "da")
            Test.Use "abccda", NewChars("c", "d"), NewStrings("ab", "", "", "a")
            Test.Use "abcd", NewChars(), NewStrings("abcd")
            Test.Use "abcd", NullChars, NewStrings("abcd")
            Test.Use "", NewChars("b"), NewStrings("")
            Test.Use vbNullString, NewChars("b"), NewStrings("")
            
    End Select
End Sub

Public Sub IsNullOrWhitespace_WithValues_ReturnsExpected(ByVal s As String, ByVal Expected As Boolean)
    Dim Actual As Boolean

    Actual = CorString.IsNullOrWhiteSpace(s)

    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Format_WithOnePlaceHolder_ReturnsPlaceHolderReplacedWithParameter()
    Dim Actual As String
    
    Actual = CorString.Format("hel{0}o", "l")
    
    Assert.That Actual, Iz.EqualTo("hello")
End Sub

Public Sub Format_WithOneDuplicatePlaceHolder_ReplacesBothPlaceHoldersWithParameter()
    Dim Actual As String
    
    Actual = CorString.Format("he{0}{0}o", "l")
    
    Assert.That Actual, Iz.EqualTo("hello")
End Sub

Public Sub ToCharArray_WithString_ReturnsArrayOfCharacters(ByVal StringToConvert As String, ByRef Expected() As Integer)
    Dim Actual() As Integer
    
    Actual = CorString.ToCharArray(StringToConvert)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub ToCharArray_WithSubstringSpecified_ReturnsSubPortion()
    Dim Actual() As Integer
    
    Actual = CorString.ToCharArray("hello", 1, 3)
    
    Assert.That Actual, Iz.EqualTo(NewIntegers(101, 108, 108))
End Sub

Public Sub ToCharArray_WithStartIndexLessThanZero_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.ToCharArray "hello", -1, 1
    
    AssertArgumentOutOfRangeException Err, "StartIndex"
End Sub

Public Sub ToCharArray_WithLengthLessThanZero_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.ToCharArray "hello", 0, -1
    
    AssertArgumentOutOfRangeException Err, "Length"
End Sub

Public Sub ToCharArray_WithStartIndexAndLengthGreaterThanTheSizeOfCharsArray_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.ToCharArray "hello", 1, 5
    
    AssertArgumentOutOfRangeException Err
End Sub

Public Sub NewString_WithArrayOfCharacters_ReturnsExpected(ByRef CharactersToConvert() As Integer, ByVal Expected As String)
    Dim Actual As String
    
    Actual = Cor.NewString(CharactersToConvert)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub NewString_WithIndexLessThanLBound_ThrowsArgumentOutOfRangeException()
    Dim Chars(1 To 10) As Integer
    
    On Error Resume Next
    NewString Chars, 0, 1
    
    AssertArgumentOutOfRangeException Err, "StartIndex"
End Sub

Public Sub NewString_WithCountLessThanZero_ThrowsArgumentOutOfRangeException()
    Dim Chars(0) As Integer
    
    On Error Resume Next
    NewString Chars, 0, -1
    
    AssertArgumentOutOfRangeException Err, "Length"
End Sub

Public Sub NewString_WithIndexAndCountBeyondUBound_ThrowsArgumentExceptin()
    Dim Chars(0 To 5) As Integer
    
    On Error Resume Next
    NewString Chars, 1, 6
    
    AssertArgumentException Err
End Sub

Public Sub NewString_WithNullArray_ThrowsArgumentNullException()
    Dim NullChars() As Integer
    
    On Error Resume Next
    NewString NullChars
    
    AssertArgumentNullException Err, "Value"
End Sub

Public Sub NewString_WithMultiDimArray_ThrowsRankException()
    Dim MultiDim(0, 0) As Integer
    
    On Error Resume Next
    NewString MultiDim
    
    AssertRankException Err
End Sub

Public Sub PadLeft_UsingDefaultPaddingChar_ReturnsStringPaddedWithSpaces()
    Dim Actual As String
    
    Actual = CorString.PadLeft("abc", 6)
    
    Assert.That Actual, Iz.EqualTo("   abc")
End Sub

Public Sub PadLeft_UsingPeriodPaddingChar_ReturnsStringPaddedWithPeriods()
    Dim Actual As String
    
    Actual = CorString.PadLeft("abc", 6, ".")
        
    Assert.That Actual, Iz.EqualTo("...abc")
End Sub

Public Sub PadLeft_WithTotalWidthLessThanLengthStringToPad_ReturnsOriginalString()
    Dim Actual As String
    
    Actual = CorString.PadLeft("abc", 2)
    
    Assert.That Actual, Iz.EqualTo("abc")
End Sub

Public Sub PadRight_UsingDefaultPaddingChar_ReturnsStringPaddedWithSpaces()
    Dim Actual As String
    
    Actual = CorString.PadRight("abc", 6)
    
    Assert.That Actual, Iz.EqualTo("abc   ")
End Sub

Public Sub PadRight_UsingPeriodPaddingChar_ReturnsStringPaddedWithPeriods()
    Dim Actual As String
    
    Actual = CorString.PadRight("abc", 6, ".")
    
    Assert.That Actual, Iz.EqualTo("abc...")
End Sub

Public Sub PadRight_WithTotalWidthLessThanLengthOfStringToPad_ReturnsOriginalString()
    Dim Actual As String
    
    Actual = CorString.PadRight("abc", 2)
    
    Assert.That Actual, Iz.EqualTo("abc")
End Sub

Public Sub TrimStart_WithDefaultWhiteSpace_TrimsWhiteSpaceFromStart(ByVal s As String, ByVal Expected As String)
    Dim Actual As String
    
    Actual = CorString.TrimStart(s)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub TrimStart_WithValues_ReturnsExpected(ByVal s As String, ByRef TrimChars As Variant, ByVal Expected As String)
    Dim Actual As String
    
    Actual = CorString.TrimStart(s, TrimChars)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub TrimEnd_WithDefaultWhiteSpace_TrimsWhiteSpaceFromEnd(ByVal s As String, ByVal Expected As String)
    Dim Actual As String
    
    Actual = CorString.TrimEnd(s)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub TrimEnd_WithValues_ReturnsExpected(ByVal s As String, ByRef TrimChars As Variant, ByVal Expected As String)
    Dim Actual As String
    
    Actual = CorString.TrimEnd(s, TrimChars)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Trim_WithDefaultWhiteSpace_TrimsWhiteSpace(ByVal s As String, ByVal Expected As String)
    Dim Actual As String
    
    Actual = CorString.Trim(s)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Trim_WithValues_ReturnsExpected(ByVal s As String, ByRef TrimChars As Variant, ByVal Expected As String)
    Dim Actual As String
    
    Actual = CorString.Trim(s, TrimChars)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Join_WhenCalled_ReturnsDelimitedString()
    Dim Value() As String
    Value = NewStrings("a", "b", "c")
    
    Dim Actual As String
    Actual = CorString.Join(",", Value)
    
    Assert.That Actual, Iz.EqualTo("a,b,c")
End Sub

Public Sub Join_WithSubset_ReturnsDelimitedSubset()
    Dim Value() As String
    Value = NewStrings("a", "b", "c", "d")
    
    Dim Actual As String
    Actual = CorString.Join(",", Value, 1, 2)
    
    Assert.That Actual, Iz.EqualTo("b,c")
End Sub

Public Sub Join_WithStartIndexBelowLBound_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.Join ",", Array(1, 1), -1, 2
    
    AssertArgumentOutOfRangeException Err, "StartIndex"
End Sub

Public Sub Join_WithNegativeCount_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.Join ",", Array(1, 1), 0, -1
    
    AssertArgumentOutOfRangeException Err, "Count"
End Sub

Public Sub Join_WithStartIndexPlusCountIsInvalid_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.Join ",", Array(1, 2), 0, 3
    
    AssertArgumentOutOfRangeException Err
End Sub

Public Sub Join_WithLongs_ReturnsLongsJoined()
    Dim Actual As String
    
    Actual = CorString.Join(",", Array(1, 2, 3, 4))
    
    Assert.That Actual, Iz.EqualTo("1,2,3,4")
End Sub

Public Sub Join_WithIObjects_ReturnsJoined()
    Dim Objs(0 To 1) As Variant
    Set Objs(0) = NewInt32(32)
    Set Objs(1) = NewInt32(1)
    
    Dim Actual As String
    Actual = CorString.Join(",", Objs)
    
    Assert.That Actual, Iz.EqualTo("32,1")
End Sub

Public Sub Join_WithLongArray_ReturnsJoined()
    Dim Longs() As Long
    Longs = NewLongs(1, 2, 3, 4)
    
    Dim Actual As String
    Actual = CorString.Join(",", Longs)
    
    Assert.That Actual, Iz.EqualTo("1,2,3,4")
End Sub

Public Sub Join_WithLongsSubset_ReturnsJoined(ByVal StartIndex As Long, ByVal Count As Long, ByVal Expected As String)
    Dim Longs() As Long
    Longs = NewLongs(1, 2, 3, 4, 5, 6, 7, 8, 9, 0)
    
    Dim Actual As String
    Actual = CorString.Join(",", Longs, StartIndex, Count)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Join_WithEnumerableObject_ReturnsJoinedElements(ByVal Value As Variant, ByVal Expected As String)
    Dim Actual As String
    
    Actual = CorString.Join(",", Value)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Join_WithNothing_ThrowsArgumentNullException()
    On Error Resume Next
    
    CorString.Join ",", Nothing
    
    AssertArgumentNullException Err, "Value"
End Sub

Public Sub Join_WithNonEnumerableObject_ThrowsArgumentException()
    On Error Resume Next
    
    CorString.Join ",", Me
    
    AssertArgumentException Err, "Value"
End Sub

Public Sub Remove_WithValues_RemovesExpected(ByVal Index As Long, ByVal Count As Long, ByVal Expected As String)
    Dim Actual As String
    
    Actual = CorString.Remove("1234567890", Index, Count)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Remove_WithStartIndexLessThanZero_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.Remove "a", -1, 1
    
    AssertArgumentOutOfRangeException Err, "StartIndex"
End Sub

Public Sub Remove_WithCountLessThanZero_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.Remove "a", 0, -1
    
    AssertArgumentOutOfRangeException Err, "Count"
End Sub

Public Sub Remove_WithStartIndexAndCountInvalidPosition_ThrowsArgumentException()
    On Error Resume Next
    
    CorString.Remove "a", 0, 2
    
    AssertArgumentOutOfRangeException Err
End Sub

Public Sub Remove_WithStartIndex_ReturnsExpected(ByVal StartIndex As Long, ByVal Expected As String)
    Dim Actual As String
    
    Actual = CorString.Remove("1234567890", StartIndex)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Insert_WithValueAndIndex_ReturnsExpected(ByVal StartIndex As Long, ByVal Value As String, ByVal Expected As String)
    Dim Actual As String
    
    Actual = CorString.Insert("1234567890", StartIndex, Value)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Insert_WithStartIndexLessThanZero_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.Insert "ab", -1, "a"
    
    AssertArgumentOutOfRangeException Err, "StartIndex"
End Sub

Public Sub Insert_WithStartIndexAfterLengthOfString_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.Insert "ab", 3, "a"
    
    AssertArgumentOutOfRangeException Err, "StartIndex"
End Sub

Public Sub IndexOfAny_WithValue_ReturnsExpected(ByRef OfAny As Variant, ByVal Expected As Long)
    Dim Actual As Long
    
    Actual = CorString.IndexOfAny("1234567890", OfAny)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub IndexOfAny_WithStartIndex_ReturnsExpected(ByRef OfAny As Variant, ByVal StartIndex As Long, ByVal Expected As Long)
    Dim Actual As Long
    
    Actual = CorString.IndexOfAny("12345678901234567890", OfAny, StartIndex)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub IndexOfAny_WithStartIndexAndCount_ReturnsExpected()
    Dim Actual As Long
    
    Actual = CorString.IndexOfAny("12345678901234567890", "5", 0, 10)
    
    Assert.That Actual, Iz.EqualTo(4)
End Sub

Public Sub IndexOfAny_WithStartIndexMissingAndHasCount_ThrowsArgumentException()
    On Error Resume Next
    
    CorString.IndexOfAny "a", "a", Count:=1
    
    AssertArgumentException Err, "StartIndex"
End Sub

Public Sub IndexOfAny_WithStartIndexLessThanZero_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.IndexOfAny "a", "a", -1
    
    AssertArgumentOutOfRangeException Err, "StartIndex"
End Sub

Public Sub IndexOfAny_WithCountLessThanZero_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.IndexOfAny "a", "a", 0, -1
    
    AssertArgumentOutOfRangeException Err, "Count"
End Sub

Public Sub IndexOfAny_WithStartIndexGreaterThanTheLengthOfStringToSearch_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.IndexOfAny "a", "a", 2
    
    AssertArgumentOutOfRangeException Err, "StartIndex"
End Sub

Public Sub IndexOfAny_WithStartIndexPlusCountGreaterThanLengthOfString_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.IndexOfAny "a", "a", 0, 2
    
    AssertArgumentOutOfRangeException Err
End Sub

Public Sub IndexOfAny_WithEmptyStringAndNegativeStartIndex_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.IndexOfAny "", "a", -1
    
    AssertArgumentOutOfRangeException Err, "StartIndex"
End Sub

Public Sub IndexOfAny_WithEmptyStringAndNegativeCount_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.IndexOfAny "", "a", 0, -1
    
    AssertArgumentOutOfRangeException Err, "Count"
End Sub

Public Sub LastIndexOfAny_WithValue_ReturnsExpected(ByRef OfAny As Variant, ByVal Expected As Long)
    Dim Actual As Long
    
    Actual = CorString.LastIndexOfAny("1234512345", OfAny)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub LastIndexOfAny_WithStartIndexAndCount_ReturnsExpected(ByVal Value As Variant, ByVal Expected As Long)
    Dim Actual As Long
    
    Actual = CorString.LastIndexOfAny("1234512345", Value, 7, 5)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub LastIndexOfAny_WithStartIndex_ReturnsExpected(ByRef OfAny As Variant, ByVal StartIndex As Long, ByVal Expected As Long)
    Dim Actual As Long
    
    Actual = CorString.LastIndexOfAny("1234512345", OfAny, StartIndex)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub LastIndexOfAny_WithNegativeStartIndex_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.LastIndexOfAny "a", "a", -1
    
    AssertArgumentOutOfRangeException Err, "StartIndex"
End Sub

Public Sub LastIndexOfAny_WithNegativeCount_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.LastIndexOfAny "a", "a", 0, -1
    
    AssertArgumentOutOfRangeException Err, "Count"
End Sub

Public Sub LastIndexOfAny_WithStartIndexPlusCountIsLessThanZero_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.LastIndexOfAny "a", "a", 0, 2
    
    AssertArgumentOutOfRangeException Err
End Sub

Public Sub Equals_WithValues_ReturnsExpected(ByVal a As String, ByVal b As String, ByVal ComparisonType As StringComparison, ByVal Expected As Boolean)
    Dim Actual As Boolean
    
    Actual = CorString.Equals(a, b, ComparisonType)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub CopyTo_WithNullDestination_ThrowsArgumentNullException()
    On Error Resume Next
    
    CorString.CopyTo "", 0, NullChars, 0, 0
    
    AssertArgumentNullException Err, "Destination"
End Sub

Public Sub CopyTo_WithSourceIndexLessThanZero_ThrowsArgumentOutOfRangeException()
    On Error Resume Next
    
    CorString.CopyTo "", -1, NewChars(), 0, 0
    
    AssertArgumentOutOfRangeException Err, "SourceIndex"
End Sub

Public Sub CopyTo_WithDestinationIndexLessThanLBound_ThrowsArgumentOutOfRangeException()
    Dim Dest(1 To 2) As Integer
    On Error Resume Next
    
    CorString.CopyTo "a", 0, Dest, 0, 1
    
    AssertArgumentOutOfRangeException Err, "DestinationIndex"
End Sub

Public Sub CopyTo_WithCountLessThanZero_ThrowsArgumentOutOfRangeException()
    Dim Dest(0) As Integer
    On Error Resume Next
    
    CorString.CopyTo "a", 0, Dest, 0, -1
    
    AssertArgumentOutOfRangeException Err, "Count"
End Sub

Public Sub CopyTo_WithStartIndexPlusCountPassedEndOfString_ThrowsArgumentOutOfRangeException()
    Dim Dest(10) As Integer
    On Error Resume Next
    
    CorString.CopyTo "123", 0, Dest, 0, 4
    
    AssertArgumentOutOfRangeException Err, "SourceIndex"
End Sub

Public Sub CopyTo_WithDestinationIndexPlusCountPassedEndOfArray_ThrowsArgumentOutOfRangeException()
    Dim Dest(10) As Integer
    On Error Resume Next
    
    CorString.CopyTo "123", 0, Dest, 9, 3
    
    AssertArgumentOutOfRangeException Err, "DestinationIndex"
End Sub

Public Sub CopyTo_WhenCoveringEntireString_CopiesAllCharacters()
    Dim Dest(3) As Integer
    
    CorString.CopyTo "1234", 0, Dest, 0, 4
    
    Assert.That Dest, Iz.EqualTo(NewChars("1", "2", "3", "4"))
End Sub

Public Sub CopyTo_WhenCoveringSubString_CopiesSubStringCharacters()
    Dim Dest(3) As Integer
    
    CorString.CopyTo "1234", 1, Dest, 0, 2
    
    Assert.That Dest, Iz.EqualTo(NewChars("2", "3", 0, 0))
End Sub

Public Sub CopyTo_WhenCopyingToNonStartOfArray_CopiesToDestination()
    Dim Dest(3) As Integer
    
    CorString.CopyTo "1234", 1, Dest, 2, 2
    
    Assert.That Dest, Iz.EqualTo(NewChars(0, 0, "2", "3"))
End Sub

Public Sub StartsWith_WithValues_ReturnsExpected(ByVal Source As String, ByVal Value As String, ByVal Expected As Boolean)
    Dim Actual As Boolean
    
    Actual = CorString.StartsWith(Source, Value)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub StartsWith_WithValuesWhenIgnoringCase_ReturnsExpected(ByVal Source As String, ByVal Value As String, ByVal Expected As Boolean)
    Dim Actual As Boolean
    
    Actual = CorString.StartsWith(Source, Value, OrdinalIgnoreCase)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub EndsWith_WithValues_ReturnsExpected(ByVal Source As String, ByVal Value As String, ByVal Expected As Boolean)
    Dim Actual As Boolean
    
    Actual = CorString.EndsWith(Source, Value)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub EndsWith_WithValuesWhenIgnoringCase_ReturnsExpected(ByVal Source As String, ByVal Value As String, ByVal Expected As Boolean)
    Dim Actual As Boolean
    
    Actual = CorString.EndsWith(Source, Value, OrdinalIgnoreCase)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Split_WithStringSeparators_ReturnsExpected(ByVal StringToSplit As String, ByRef Separators() As String, ByRef Expected() As String)
    Dim Actual() As String
    
    Actual = CorString.Split(StringToSplit, Separators)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Split_WithCount_ReturnsLimitedNumberOfSubstrings(ByVal StringToSplit As String, ByRef Separators() As String, ByVal Count As Long, ByRef Expected() As String)
    Dim Actual() As String
    
    Actual = CorString.Split(StringToSplit, Separators, Count)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Split_WithRemoveEmptyEntries_ReturnsFilledStringsOnly(ByVal StringToSplit As String, ByRef Separators() As String, ByRef Expected() As String)
    Dim Actual() As String
    
    Actual = CorString.Split(StringToSplit, Separators, , StringSplitOptions.RemoveEmptyEntries)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub Split_WithCharSeparators_ReturnsExpected(ByVal StringToSplit As String, ByRef Separators() As Integer, ByRef Expected() As String)
    Dim Actual() As String
    
    Actual = CorString.Split(StringToSplit, Separators)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub


Private Property Get WhiteSpaces() As String
    WhiteSpaces = ChrW$(&H20) & ChrW$(&HD) & ChrW$(&H9) & ChrW$(&HA) & ChrW$(&HB) & ChrW$(&HC) & ChrW$(&H85) & ChrW$(&HA0) & ChrW$(&H1680) & ChrW$(&H180E) & _
        ChrW$(&H2000) & ChrW$(&H2001) & ChrW$(&H2002) & ChrW$(&H2003) & ChrW$(&H2004) & ChrW$(&H2005) & ChrW$(&H2006) & ChrW$(&H2007) & ChrW$(&H2008) & ChrW$(&H2009) & ChrW$(&H200A) & _
        ChrW$(&H2028) & ChrW$(&H2029) & ChrW$(&H202F) & ChrW$(&H205F) & _
        ChrW$(&H3000)
End Property

Private Property Get WhiteSpaceChars() As Integer()
    WhiteSpaceChars = NewIntegers(&H20, &HD, &H9, &HA, &HB, &HC, &H85, &HA0, &H1680, &H180E, _
        &H2000, &H2001, &H2002, &H2003, &H2004, &H2005, &H2006, &H2007, &H2008, &H2009, &H200A, _
        &H2028, &H2029, &H202F, &H205F, _
        &H3000)
End Property



