Option Compare Database
Option Explicit

Private mintSubFolderLevel As Integer
Private Const OUTPUT_FILE As String = "C:\TEMP\OutputListOfFoldersFiles.txt"
Private fle As Integer
'

Public Sub TestListFileSystemRecursively()
    'Const TEST_FILE_PATH As String = "C:\"
    Const TEST_FILE_PATH As String = "C:\TEMP\"
    'Const TEST_FILE_PATH As String = "C:\PFE\"
    'Const TEST_FILE_PATH As String = "C:\Users\"
    Dim strStartPath As String
    strStartPath = TEST_FILE_PATH
    mintSubFolderLevel = 1
    ListFileSystemRecursively strStartPath, varDebug:="DebugIt"
End Sub

Private Sub ListFileSystemRecursively(strRootPathName As String, _
                Optional varListFiles As Variant, _
                Optional varDebug As Variant)
' Ref: http://blogs.msdn.com/b/gstemp/archive/2004/08/10/212113.aspx
'==============================================================================
' Purpose:  List File System Recursively
' Author:   Peter Ennis
' Date:     February 10, 2011
' Comment:  Fix to work in VBA. Based on MSDN sample for WScript
' Requires: Late binding does not need reference to Microsoft Scripting Runtime
'==============================================================================

    Dim strFolder As String
    Dim objFSO As Object
    Dim objFolder As Object
    Dim objFile As Object
    Dim colFiles As Object

    fle = FreeFile()
    Open OUTPUT_FILE For Output As #fle

    strFolder = strRootPathName

    ' Create needed objects
    Dim wsh As Object  ' As Object if late-bound
    Set wsh = CreateObject("WScript.Shell")
    
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFolder = objFSO.GetFolder(strFolder)

    Debug.Print ">" & objFolder.Path

    Set colFiles = objFolder.Files

    If Not IsMissing(varListFiles) Then
        'Debug.Print "ListFileSystemRecursively varListFiles=" & varListFiles
        For Each objFile In colFiles
            Debug.Print "objFile.Path = " & objFile.Path
        Next
        ShowSubFolders objFolder, varListFiles
    Else
        'Debug.Print "ListFileSystemRecursively varListFiles IS MISSING"
        Debug.Print "Top Level = " & mintSubFolderLevel
        Print #fle, "Top Level = " & mintSubFolderLevel & " > " & objFolder.Path
        ShowSubFolders objFolder, varListFilesShow:=varListFiles, varDebugShow:=varDebug
    End If
    Debug.Print "DONE !!!"

    Close fle
    Set wsh = Nothing
    Set objFSO = Nothing
    Set objFolder = Nothing
    Set colFiles = Nothing

End Sub
 
Private Sub ShowSubFolders(objFolder As Object, _
                Optional varListFilesShow As Variant, _
                Optional varDebugShow As Variant)
' Ref: http://blogs.msdn.com/b/gstemp/archive/2004/08/10/212113.aspx

    On Error GoTo PROC_ERR

    Dim objFile As Object
    Dim objSubFolder As Object
    Dim colFiles As Object
    
    Dim colFolders As Object
    Set colFolders = objFolder.SubFolders

    Dim wsh As Object  ' As Object if late-bound
    Set wsh = CreateObject("WScript.Shell")

    Debug.Print mintSubFolderLevel
    For Each objSubFolder In colFolders

        Set colFiles = objSubFolder.Files

        If Not IsMissing(varListFilesShow) Then
            'Debug.Print "ShowSubFolders varListFilesShow=" & varListFilesShow
            For Each objFile In colFiles
                Debug.Print "objFile.Path = " & objFile.Path
            Next
            ShowSubFolders objSubFolder, varListFilesShow:=varListFilesShow, varDebugShow:=varDebugShow
        Else
            'Debug.Print "ShowSubFolders varListFilesShow IS MISSING"
            mintSubFolderLevel = mintSubFolderLevel + 1
            If Not IsMissing(varDebugShow) Then Debug.Print "Sub Level = " & mintSubFolderLevel & " >> " & objSubFolder.Path
            Print #fle, "Sub Level = " & mintSubFolderLevel & " >> " & objSubFolder.Path
            ShowSubFolders objSubFolder, varListFilesShow:=varListFilesShow, varDebugShow:=varDebugShow
        End If
        mintSubFolderLevel = mintSubFolderLevel - 1
    Next

PROC_EXIT:
    Set wsh = Nothing
    Set colFolders = Nothing
    'PopCallStack
    Exit Sub

PROC_ERR:
    If Err = 70 Then        ' Permission denied
        Err.Clear
        Resume PROC_EXIT
    Else
        MsgBox "Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure ShowSubFolders of Module aefs"
        'If blnDebug Then Debug.Print ">>>Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure ShowSubFolders of Module aefs"
        'GlobalErrHandler
        Resume PROC_EXIT
    End If
End Sub