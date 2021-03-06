VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ResourceManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'The MIT License (MIT)
'Copyright (c) 2019 Kelly Ethridge
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
' Module: ResourceManager
'

''
' Provides convenient access to culture-specific resources at runtime.
'
' @remarks A ResourceManager contains all resources for all of the cultures found
' using an IResourceReader object or a .RES filename.
' <p>To load the resources from multiple .RES files, use <b>ResourceManager.CreateFileBasedResourceManager</b>.</p>
' @see Constructors
' @see ResourceManagerStatic
' @see ResourceReader
' @see WinResourceReader
' @see IResourceReader
' @see Win32Resource
'
Option Explicit
Implements IObject
Implements IEnumerable


Private mResourceSets           As Hashtable
Private mFiles()                As String
Private mFallbackResourceSet    As ResourceSet



''
' Returns a resource from the specified culture.
'
' @param ResourceName The resource identifier.
' @param ResourceType The type of resource to search for.
' @param CultureID A CultureInfo object or Culture ID. The current culture is used if this parameter is missing.
' @return The resource value, or Empty if the resourse was not found.
'
Public Function GetObject(ByRef ResourceName As Variant, ByRef ResourceType As Variant, Optional ByRef CultureID As Variant) As Variant
    Dim LangID As Long
    LangID = GetLanguageID(CultureID)
    
    Dim rs As ResourceSet
    Set rs = InternalGetResourceSet(LangID, False)
    
    If rs Is Nothing Then
        Dim c As CultureInfo
        Set c = Cor.NewCultureInfo(LangID)
        Set c = c.Parent
        
        ' Search parent cultures for a ResourceSet.
        Do While (Not c.Equals(CultureInfo.InvariantCulture)) And (Not c.IsNeutralCulture)
            If mResourceSets.Contains(c.LCID) Then
                Set rs = mResourceSets(c.LCID)
                Exit Do
            End If
            Set c = c.Parent
        Loop
    End If
    
    If Not rs Is Nothing Then
        ' We have found a ResourceSet for the specific culture.
        ' So we won't search any other sets, even if the
        ' specific value doesn't exist in this one, because
        ' the culture was actually specificed.
        Helper.MoveVariant GetObject, rs.GetObject(ResourceName, ResourceType)
    ElseIf ResourceType = ResourceTypes.StringResource Then
        GetObject = GetFallbackString(ResourceName)
    Else
        ' If we aren't looking for a string, then we will
        ' iterate through all ResourceSets looking for the
        ' first value that matches the resource Name and Type.
        Dim InvariantCultureKey As ResourceKey
        Set InvariantCultureKey = Cor.NewResourceKey(ResourceName, ResourceType, INVARIANT_LCID)
        
        For Each rs In mResourceSets
            Dim Entry As DictionaryEntry
            For Each Entry In rs
                If InvariantCultureKey.Equals(Entry.Key) Then
                    Helper.MoveVariant GetObject, Entry.Value
                    Exit Function
                End If
            Next Entry
        Next rs
    End If
End Function

''
' Returns a resource string for the specific culture.
'
' @param ResourceName The resource ID.
' @param CultureID A CultureInfo object or Culture ID. The current culture is used if this parameter is missing.
' @return The resource as a String, or an empty string if the resource was not found.
'
Public Function GetString(ByRef ResourceName As Variant, Optional ByRef CultureID As Variant) As String
    On Error Resume Next
    GetString = GetObject(ResourceName, StringResource, CultureID)
End Function

''
' Returns a set of resources for a specific culture.
'
' @param CultureID A CultureInfo object or Culture ID. The current culture is used if this parameter is missing.
' @return A set of resources for a specific culture, or Nothing if not found.
'
Public Function GetResourceSet(ByRef CultureID As Variant) As ResourceSet
    Set GetResourceSet = InternalGetResourceSet(GetLanguageID(CultureID), False)
End Function

''
' Releases all resources.
'
Public Sub ReleaseAllResources()
    Set mResourceSets = Nothing
End Sub

''
' Returns an enumerator used to iterate through all resources for all cultures.
'
' @return An IDictionaryEnumerator object.
' @remarks The enumerator returns <b>DictionaryEntry</b> objects. The <i>Key</i>
' contains the Culture ID. The <i>Value</i> contains the <b>ResourceSet</b> for
' that specific culture.
'
Public Function GetEnumerator() As IDictionaryEnumerator
    If mResourceSets Is Nothing Then
        LoadResources
    End If
    
    Set GetEnumerator = mResourceSets.GetEnumerator
End Function

''
' Returns an enumerator used to iterate through all resources for all cultures.
'
' @return An IDictionaryEnumerator object.
' @remarks The enumerator returns <b>DictionaryEntry</b> objects. The <i>Key</i>
' contains the Culture ID. The <i>Value</i> contains the <b>ResourceSet</b> for
' that specific culture.
'
Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    Set NewEnum = CreateEnumerator(GetEnumerator)
End Function

''
' Returns a string representation of this object instance.
'
' @return String representing this instance.
Public Function ToString() As String
    ToString = MyBase.ToString(Me, App)
End Function

''
' Returns a boolean indicating if the value and this object
' instance are the same instance.
'
' @param value The value to compare equalit to.
' @return Boolean indicating equality.
Public Function Equals(ByRef Value As Variant) As Boolean
    Equals = MyBase.Equals(Me, Value)
End Function

''
' Returns a pseudo-unique number identifying this instance.
'
' @return Pseudo-unique number identifying this instance.
Public Function GetHashCode() As Long
    GetHashCode = MyBase.GetHashCode(Me)
End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   Constructors
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Friend Sub InitFromFile(ByRef FileName As String)
    mFiles = Cor.NewStrings(FileName)
End Sub

Friend Sub InitFromFolder(ByRef SearchPattern As String, ByRef ResourceDir As String)
    mFiles = Directory.GetFiles(ResourceDir, SearchPattern)
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   Helpers
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Sub LoadResources()
    Set mResourceSets = New Hashtable
    
    ' We iterate through all of the files and attempt
    ' to load the resources from each, one by one.
    Dim i As Long
    For i = 0 To UBound(mFiles)
        LoadResource GetResourceReader(mFiles(i))
    Next i
End Sub

Private Sub LoadResource(ByVal Reader As IResourceReader)
    ' An error may be thrown here because the readers
    ' files do not validate their source file until
    ' the first attempt at iterating resources.
    On Error GoTo Finally
    
    ' Iterate the reader and load the resources locally.
    ' The resources are separated into individual resource
    ' sets based on the Language ID of the resource.
    Dim Entry As DictionaryEntry
    For Each Entry In Reader
        Dim Key As ResourceKey
        Set Key = Entry.Key
        With InternalGetResourceSet(Key.LanguageID, True)
            .AddResource Key, Entry.Value
        End With
    Next Entry
        
Finally:
    Reader.CloseReader
End Sub

''
' This attempts to get 1 of 2 possible resource readers based on the file.
'
Private Function GetResourceReader(ByRef FileName As String) As IResourceReader
    Dim Handle As Long
    
    ' Attempt to load the file as an EXE, DLL, or OCX.
    Handle = LoadLibraryA(FileName)
    
    ' If we succeeded loading the file that way, then
    ' we will use a WinResourceReader to read the
    ' resources within the executable file.
    If Handle <> NULL_HANDLE Then
        Dim WinRes As New WinResourceReader
        WinRes.InitFromHandle Handle
        Set GetResourceReader = WinRes
    Else
        ' We believe we have a file of the .RES format.
        Set GetResourceReader = Cor.NewResourceReader(FileName)
    End If
End Function

Private Function InternalGetResourceSet(ByVal LangID As Long, ByVal AddMissing As Boolean) As ResourceSet
    If mResourceSets Is Nothing Then
        LoadResources
    End If
    
    If mResourceSets.Contains(LangID) Then
        Set InternalGetResourceSet = mResourceSets(LangID)
    ElseIf AddMissing Then
        Set InternalGetResourceSet = New ResourceSet
        InternalGetResourceSet.LanguageID = LangID
        mResourceSets.Add LangID, InternalGetResourceSet
    End If
End Function

''
' We fallback and iterate through the resource sets
' looking for the first string resource of the specified
' name. Once we have found it, then that resource set
' will always be used for the fall back. If the resource set
' does not contain the next string, then Empty will be returned.
'
Private Function GetFallbackString(ByRef ResourceName As Variant) As Variant
    ' Check if we need to find a fallback resource set.
    If mFallbackResourceSet Is Nothing Then
        ' We do need a fallback set, so lets iterate
        ' through all the resource sets looking for
        ' a string of the same ID.
        Dim Entry As DictionaryEntry
        For Each Entry In mResourceSets
            Dim rs As ResourceSet
            Set rs = Entry.Value
            
            ' Ask the resource set for the string value.
            ' We use the GetObject method because if the
            ' value does not exist, then Empty is returned.
            GetFallbackString = rs.GetObject(ResourceName, ResourceTypes.StringResource)
            
            ' If the value is not Empty, then we have found
            ' a resource set with the ID we requested. Now
            ' that resource set will become our fallback set.
            If Not IsEmpty(GetFallbackString) Then
                Set mFallbackResourceSet = rs
                
                ' We've already retrieved the value, so just exit.
                Exit Function
            End If
        Next Entry
        
        ' We never found a resource set with the ID specified,
        ' so we return Empty indicating failure.
        Exit Function
    End If
    
    ' Use our fallback resource set to find the value.
    ' If the value does not exist, then Empty is returned.
    GetFallbackString = mFallbackResourceSet.GetObject(ResourceName, ResourceTypes.StringResource)
End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   IObject
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Function IObject_Equals(Value As Variant) As Boolean
    IObject_Equals = Equals(Value)
End Function

Private Function IObject_GetHashCode() As Long
    IObject_GetHashCode = GetHashCode
End Function

Private Function IObject_ToString() As String
    IObject_ToString = ToString
End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   IEnumerable
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Function IEnumerable_GetEnumerator() As IEnumerator
    Set IEnumerable_GetEnumerator = GetEnumerator
End Function

Private Function IEnumerable_NewEnum() As stdole.IUnknown
    Set IEnumerable_NewEnum = NewEnum
End Function
