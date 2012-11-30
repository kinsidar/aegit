Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

' Ref: http://www.di-mgt.com.au/cl_Simple.html
'
'=======================================================================
' Author:   Peter F. Ennis
' Date:     February 24, 2011
' Comment:  Create class for revision control
' History:  See comment details, basChangeLog, commit messages on githib
'=======================================================================

Private Const VERSION As String = "0.1.7"
Private Const VERSION_DATE As String = "Nov 29, 2012"
Private Const THE_DRIVE As String = "C"
'
'20121129 v017  Output error messages to the immediate window when debug is turned on
'               Pass Fail test results and debug output cleanup
'20121128 v016  Use strSourceLocation to allow custom path and test for error,
'               Cleanup debug messages code
'               Include GetReferences from aeladdin (tm) and fix it
'20121127 v015  Update version, export using OASIS and commit to github
'               Reverse order of version comments so newest is at the top
'               Skip ~TMP* names for scripts (macros)
'20110303 v014  Make class PublicNotCreatable, project name aegitClassProvider
'               http://support.microsoft.com/kb/555159
'20110303 v013  Initialize class using Private Type
'20110303 v012  Fix bug in skip export of all zzz objects, must use doc.Name
'20110303 v011  Skip export of all zzz objects, create module basTESTaegitClass
'20110303 v010  Add Option blnDebug to ReadDocDatabase property
'20110302 v010  Delete basRevisionControl
'20110302 v009  Skip export of ~TMP queries, debug message output singular and plural
'20110302 v008  Move other finctions from basRevisionControl to asgitClass
'20110302 v007  Add private function aeDocumentTheDatabase from DocumentTheDatabase
'               Test with updated aegitClassTest
'20110226 v006  TEST_FOLDER=>THE_FOLDER, TEST_DRIVE=>THE_DRIVE, BuildTestDirectory=>BuildTheDirectory
'               Objects have obj prefix, use For Each qdf, output "Macros EXPORTED" (not Scripts)
'20110222 v004  Create aegitClass shell and basTestRevisionControl
'               Use ?aegitClassTest of basTestRevisionControl in the immediate window to check basic operation
'

Private Type mySetupType
    SourceFolder As String
    TestFolder As String
End Type

Private aegitType As mySetupType
Private aegitSourceFolder As String
Private aegitblnCustomSourceFolder As Boolean
Private strSourceLocation As String
'

Private Sub Class_Initialize()
' Ref: http://www.cadalyst.com/cad/autocad/programming-with-class-part-1-5050
' Ref: http://www.bigresource.com/Tracker/Track-vb-cyJ1aJEyKj/
' Ref: http://stackoverflow.com/questions/1731052/is-there-a-way-to-overload-the-constructor-initialize-procedure-for-a-class-in
    
    ' provide a default value for the SourceFolder property
    aegitSourceFolder = "default"
    aegitType.SourceFolder = "C:\ae\aegit\aerc\src\"
    aegitType.TestFolder = "C:\ae\aegit\aerc\tst\"
    
    Debug.Print "Class_Initialize"
    Debug.Print , "Default for aegitSourceFolder=" & aegitSourceFolder
    Debug.Print , "Default for aegitType.SourceFolder=" & aegitType.SourceFolder
    Debug.Print , "Default for aegitType.TestFolder=" & aegitType.TestFolder

End Sub

Property Get SourceFolder() As String
    SourceFolder = aegitSourceFolder
End Property

Property Let SourceFolder(ByVal strSourceFolder As String)
    ' Ref: http://www.techrepublic.com/article/build-your-skills-using-class-modules-in-an-access-database-solution/5031814
    ' Ref: http://www.utteraccess.com/wiki/index.php/Classes
    aegitSourceFolder = strSourceFolder
End Property

Property Get TestFolder() As String
    TestFolder = aegitType.TestFolder
End Property

Property Get DocumentTheDatabase(Optional DebugTheCode As Variant) As Boolean
    If IsMissing(DebugTheCode) Then
        Debug.Print "Get DocumentTheDatabase"
        Debug.Print , "DebugTheCode IS missing so no parameter is passed to aeDocumentTheDatabase"
        Debug.Print , "DEBUGGING IS OFF"
        aeDocumentTheDatabase
    Else
        Debug.Print "Get DocumentTheDatabase"
        Debug.Print , "DebugTheCode IS NOT missing so a variant parameter is passed to aeDocumentTheDatabase"
        Debug.Print , "DEBUGGING TURNED ON"
        aeDocumentTheDatabase (DebugTheCode)
    End If
End Property

Property Get Exists(strAccObjType As String, _
                        strAccObjName As String, _
                        Optional DebugTheCode As Variant) As Boolean
    If IsMissing(DebugTheCode) Then
        Debug.Print "Get Exists"
        Debug.Print , "DebugTheCode IS missing so no parameter is passed to aeExists"
        Debug.Print , "DEBUGGING IS OFF"
        Exists = aeExists(strAccObjType, strAccObjName)
    Else
        Debug.Print "Get Exists"
        Debug.Print , "DebugTheCode IS NOT missing so a variant parameter is passed to aeExists"
        Debug.Print , "DEBUGGING TURNED ON"
        Exists = aeExists(strAccObjType, strAccObjName, DebugTheCode)
    End If
End Property

Property Get ReadDocDatabase(Optional DebugTheCode As Variant) As Boolean
    If IsMissing(DebugTheCode) Then
        Debug.Print "Get ReadDocDatabase"
        Debug.Print , "DebugTheCode IS missing so no parameter is passed to aeReadDocDatabase"
        Debug.Print , "DEBUGGING IS OFF"
        ReadDocDatabase = aeReadDocDatabase
    Else
        Debug.Print "Get ReadDocDatabase"
        Debug.Print , "DebugTheCode IS NOT missing so a variant parameter is passed to aeReadDocDatabase"
        Debug.Print , "DEBUGGING TURNED ON"
        ReadDocDatabase = aeReadDocDatabase(DebugTheCode)
    End If
End Property

Property Get GetReferences(Optional DebugTheCode As Variant) As Boolean
    If IsMissing(DebugTheCode) Then
        Debug.Print "Get GetReferences"
        Debug.Print , "DebugTheCode IS missing so no parameter is passed to aeGetReferences"
        Debug.Print , "DEBUGGING IS OFF"
        GetReferences = aeGetReferences
    Else
        Debug.Print "Get GetReferences"
        Debug.Print , "DebugTheCode IS NOT missing so a variant parameter is passed to aeGetReferences"
        Debug.Print , "DEBUGGING TURNED ON"
        GetReferences = aeGetReferences(DebugTheCode)
    End If
End Property

Private Function aeGetReferences(Optional varDebug As Variant) As Boolean
' Ref: http://vbadud.blogspot.com/2008/04/get-references-of-vba-project.html
' Ref: http://www.pcreview.co.uk/forums/type-property-reference-object-vbulletin-project-t3793816.html
' Ref: http://www.cpearson.com/excel/missingreferences.aspx
' Ref: http://allenbrowne.com/ser-38.html
' Ref: http://access.mvps.org/access/modules/mdl0022.htm (References Wizard)
' Ref: http://www.accessmvp.com/djsteele/AccessReferenceErrors.html
'
'====================================================================
' Author:   Peter F. Ennis
' Date:     November 28, 2012
' Comment:  Added and adapted from aeladdin (tm) code
' Updated:
'====================================================================

    Dim i As Integer
    Dim RefName As String
    Dim RefDesc As String
    Dim blnRefBroken As Boolean
    Dim blnDebug As Boolean

    Dim vbaProj As Object
    Set vbaProj = Application.VBE.ActiveVBProject

    On Error GoTo aeGetReferences_Error

    Debug.Print "aegitGetReferences"
    If IsMissing(varDebug) Then
        blnDebug = False
        Debug.Print , "varDebug IS missing so blnDebug of aeGetReferences is set to False"
        Debug.Print , "DEBUGGING IS OFF"
    Else
        blnDebug = True
        Debug.Print , "varDebug IS NOT missing so blnDebug of aeGetReferences is set to True"
        Debug.Print , "NOW DEBUGGING..."
    End If

'1    Debug.Print "<@_@>"
'2    i = 0
'3    Dim refCurr As Reference
'4    For Each refCurr In Application.References
'5        i = i + 1
'6        Debug.Print , "ref " & i, refCurr.Name, refCurr.FullPath
'7    Next
'8    Debug.Print "<*_*>"

    If blnDebug Then
        Debug.Print ">==> aeGetReferences >==>"
        Debug.Print , "vbaProj.Name = " & vbaProj.Name
        Debug.Print , "vbaProj.Type = '" & vbaProj.Type & "'"
        ' Display the versions of Access, ADO and DAO
        Debug.Print , "Access version = " & Application.VERSION
        Debug.Print , "ADO (ActiveX Data Object) version = " & CurrentProject.Connection.VERSION
        Debug.Print , "DAO (DbEngine)  version = " & Application.DBEngine.VERSION
        Debug.Print , "DAO (CodeDb)    version = " & Application.CodeDb.VERSION
        Debug.Print , "DAO (CurrentDb) version = " & Application.CurrentDb.VERSION
        Debug.Print , "<@_@>"
        Debug.Print , "References:"
    End If

    For i = 1 To vbaProj.References.Count

        blnRefBroken = False

        ' Get the Name of the Reference
        RefName = vbaProj.References(i).Name

        ' Get the Description of Reference
        RefDesc = vbaProj.References(i).Description

        If blnDebug Then Debug.Print , , vbaProj.References(i).Name, vbaProj.References(i).Description
        If blnDebug Then Debug.Print , , , vbaProj.References(i).FullPath

        ' Returns a Boolean value indicating whether or not the Reference object points to a valid reference in the registry. Read-only.
        If Application.VBE.ActiveVBProject.References(i).IsBroken = True Then
              blnRefBroken = True
              If blnDebug Then Debug.Print , , vbaProj.References(i).Name, "blnRefBroken=" & blnRefBroken
        End If
    Next
    If blnDebug Then Debug.Print , "<*_*>"
    If blnDebug Then Debug.Print "<==<"

    On Error GoTo 0
    aeGetReferences = True
    Exit Function

aeGetReferences_Error:

    MsgBox "Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure aeGetReferences of Class aegitClass"
    If blnDebug Then Debug.Print ">>>Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure aeGetReferences of Class aegitClass"

End Function

Private Function aeDocumentTheDatabase(Optional varDebug As Variant) As Boolean
' Based on sample code from Arvin Meyer (MVP) June 2, 1999
' Ref: http://www.accessmvp.com/Arvin/DocDatabase.txt
' Ref: http://www.tek-tips.com/faqs.cfm?fid=6905
'====================================================================
' Author:   Peter F. Ennis
' Date:     February 8, 2011
' Comment:  Uses the undocumented [Application.SaveAsText] syntax
'           To reload use the syntax [Application.LoadFromText]
'           Add explicit references for DAO
' Updated:
' 20121128: Use strSourceLocation to allow custom path and test for error,
'           Cleanup debug messages code
' 20121127: Reverse comment order, newest at top
'           Skip export of ~TMP macros
' 20110303: Add Optional blnDebug parameter
'           Skip export of all zzz objects (using doc.Name)
' 20110302: Skip export of ~TMP queries
'           debug message output singular and plural
' 20110302: Change to aeDocumentTheDatabase for use in aegitClass
' 20110226: Skip export of MSys (hiddem system queries) and
'           ~sq_ (hidden ODBC queries) objects
'           Add count of objects in debug output
' 20110224: Make this a function. Add optional debug flag
' 20110218: Forms->frm, Reports->rpt, Scripts->mac
'           Modules->bas, Queries->qry
'           Error handler
'====================================================================
'

    Dim dbs As DAO.Database
    Dim cnt As DAO.Container
    Dim doc As DAO.Document
    Dim qdf As DAO.QueryDef
    Dim i As Integer

    Dim blnDebug As Boolean

    On Error GoTo aeDocumentTheDatabase_Error

    Debug.Print "aeDocumentTheDatabase"
    If IsMissing(varDebug) Then
        blnDebug = False
        Debug.Print , "varDebug IS missing so blnDebug of aeDocumentTheDatabase is set to False"
        Debug.Print , "DEBUGGING IS OFF"
    Else
        blnDebug = True
        Debug.Print , "varDebug IS NOT missing so blnDebug of aeDocumentTheDatabase is set to True"
        Debug.Print , "NOW DEBUGGING..."
    End If
    
    If aegitSourceFolder = "default" Then
        strSourceLocation = aegitType.SourceFolder
    Else
        strSourceLocation = aegitSourceFolder
    End If
    
    If blnDebug Then
        Debug.Print , ">==> aeDocumentTheDatabase >==>"
        Debug.Print , "SourceFolder=" & strSourceLocation
        Debug.Print , "TestFolder=" & strSourceLocation
    End If

    Set dbs = CurrentDb() ' use CurrentDb() to refresh Collections

    '=============
    ' FORMS
    '=============
    i = 0
    Set cnt = dbs.Containers("Forms")
    If blnDebug Then Debug.Print "FORMS"
    
    For Each doc In cnt.Documents
        If blnDebug Then Debug.Print , doc.Name
        If Not (Left(doc.Name, 3) = "zzz") Then
            i = i + 1
            Application.SaveAsText acForm, doc.Name, strSourceLocation & doc.Name & ".frm"
        End If
    Next doc
    
    If blnDebug Then
        If i = 1 Then
            Debug.Print , "1 Form EXPORTED!"
        Else
            Debug.Print , i & " Forms EXPORTED!"
        End If
        
        If cnt.Documents.Count = 1 Then
            Debug.Print , "1 Form EXISTING!"
        Else
            Debug.Print , cnt.Documents.Count & " Forms EXISTING!"
        End If
    End If
    
    '=============
    ' REPORTS
    '=============
    i = 0
    Set cnt = dbs.Containers("Reports")
    If blnDebug Then Debug.Print "REPORTS"
    
    For Each doc In cnt.Documents
        If blnDebug Then Debug.Print , doc.Name
        If Not (Left(doc.Name, 3) = "zzz") Then
            i = i + 1
            Application.SaveAsText acReport, doc.Name, strSourceLocation & doc.Name & ".rpt"
        End If
    Next doc
    
    If blnDebug Then
        If i = 1 Then
            Debug.Print , "1 Report EXPORTED!"
        Else
            Debug.Print , i & " Reports EXPORTED!"
        End If
        
        If cnt.Documents.Count = 1 Then
            Debug.Print , "1 Report EXISTING!"
        Else
            Debug.Print , cnt.Documents.Count & " Reports EXISTING!"
        End If
    End If

    '=============
    ' MACROS
    '=============
    i = 0
    Set cnt = dbs.Containers("Scripts")
    If blnDebug Then Debug.Print "MACROS"
    
    For Each doc In cnt.Documents
        If blnDebug Then Debug.Print , doc.Name
        If Not (Left(doc.Name, 3) = "zzz" Or Left(doc.Name, 4) = "~TMP") Then
            i = i + 1
            Application.SaveAsText acMacro, doc.Name, strSourceLocation & doc.Name & ".mac"
        End If
    Next doc
    
    If blnDebug Then
        If i = 1 Then
            Debug.Print , "1 Macro EXPORTED!"
        Else
            Debug.Print , i & " Macros EXPORTED!"
        End If
        
        If cnt.Documents.Count = 1 Then
            Debug.Print , "1 Macro EXISTING!"
        Else
            Debug.Print , cnt.Documents.Count & " Macros EXISTING!"
        End If
    End If

    '=============
    ' MODULES
    '=============
    i = 0
    Set cnt = dbs.Containers("Modules")
    If blnDebug Then Debug.Print "MODULES"
    
    For Each doc In cnt.Documents
        If blnDebug Then Debug.Print , doc.Name
        If Not (Left(doc.Name, 3) = "zzz") Then
            i = i + 1
            Application.SaveAsText acModule, doc.Name, strSourceLocation & doc.Name & ".bas"
        End If
    Next doc
    
    If blnDebug Then
        If i = 1 Then
            Debug.Print , "1 Module EXPORTED!"
        Else
            Debug.Print , i & " Modules EXPORTED!"
        End If
        
        If cnt.Documents.Count = 1 Then
            Debug.Print , "1 Module EXISTING!"
        Else
            Debug.Print , cnt.Documents.Count & " Modules EXISTING!"
        End If
    End If

    '=============
    ' QUERIES
    '=============
    i = 0
    If blnDebug Then Debug.Print "QUERIES"
    
    For Each qdf In CurrentDb.QueryDefs
        If blnDebug Then Debug.Print , qdf.Name
        If Not (Left(qdf.Name, 4) = "MSys" Or Left(qdf.Name, 4) = "~sq_" _
                        Or Left(qdf.Name, 4) = "~TMP" _
                        Or Left(qdf.Name, 3) = "zzz") Then
            i = i + 1
            Application.SaveAsText acQuery, qdf.Name, strSourceLocation & qdf.Name & ".qry"
        End If
    Next qdf
    
    If blnDebug Then
        If i = 1 Then
            Debug.Print , "1 Query EXPORTED!"
        Else
            Debug.Print , i & " Queries EXPORTED!"
        End If
        
        If CurrentDb.QueryDefs.Count = 1 Then
            Debug.Print , "1 Query EXISTING!"
        Else
            Debug.Print , CurrentDb.QueryDefs.Count & " Queries EXISTING!"
        End If
    End If

    Set doc = Nothing
    Set cnt = Nothing
    Set dbs = Nothing
    Set qdf = Nothing

    On Error GoTo 0
    aeDocumentTheDatabase = True
    Exit Function

aeDocumentTheDatabase_Error:

    If Err = 2950 Then
        MsgBox "Erl=" & Erl & " Err=2950 " & " cannot find path " & strSourceLocation & " in procedure aeDocumentTheDatabase of Class aegitClass"
        If blnDebug Then Debug.Print ">>>Trap>>>Erl=" & Erl & " Err=2950 " & " cannot find path " & strSourceLocation & " in procedure aeDocumentTheDatabase of Class aegitClass"
    Else
        MsgBox "Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure aeDocumentTheDatabase of Class aegitClass"
        If blnDebug Then Debug.Print ">>>Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure aeDocumentTheDatabase of Class aegitClass"
    End If
    
End Function

Private Function BuildTheDirectory(FSO As Scripting.FileSystemObject, _
                                        Optional varDebug As Variant) As Boolean
' Ref: http://msdn.microsoft.com/en-us/library/ebkhfaaz(v=vs.85).aspx
'====================================================================
' Author:   Peter F. Ennis
' Date:     February 8, 2011
' Comment:  Add optional debug parameter
' Requires: Reference to Microsoft Scripting Runtime
' 20110302: Add error handler and include in aegitClass
'====================================================================

    Dim objTestFolder As Object
    Dim blnDebug As Boolean
    
    On Error GoTo BuildTheDirectory_Error

    Debug.Print "BuildTheDirectory"
    If IsMissing(varDebug) Then
        blnDebug = False
        Debug.Print , "varDebug IS missing so blnDebug of BuildTheDirectory is set to False"
        Debug.Print , "DEBUGGING IS OFF"
    Else
        blnDebug = True
        Debug.Print , "varDebug IS NOT missing so blnDebug of BuildTheDirectory is set to True"
        Debug.Print , "NOW DEBUGGING..."
    End If

    If blnDebug Then Debug.Print , ">==> BuildTheDirectory >==>"

    ' Bail out if (a) the drive does not exist, or if (b) the directory already exists.

    If blnDebug Then Debug.Print , , "THE_DRIVE = " & THE_DRIVE
    If blnDebug Then Debug.Print , , "FSO.DriveExists(THE_DRIVE) = " & FSO.DriveExists(THE_DRIVE)
    If Not FSO.DriveExists(THE_DRIVE) Then
        If blnDebug Then Debug.Print , , "FSO.DriveExists(THE_DRIVE) = FALSE - The drive DOES NOT EXIST !!!"
        BuildTheDirectory = False
        Exit Function
    End If
    If blnDebug Then Debug.Print , , "The drive EXISTS !!!"

    If blnDebug Then Debug.Print , , "The test folder is: " & aegitType.TestFolder
    If FSO.FolderExists(aegitType.TestFolder) Then
        If blnDebug Then Debug.Print , , "FSO.FolderExists(aegitType.TestFolder) = TRUE - The directory EXISTS !!!"
        BuildTheDirectory = False
        Exit Function
    End If
    If blnDebug Then Debug.Print , , "The test directory does NOT EXIST !!!"

    Set objTestFolder = FSO.CreateFolder(aegitType.TestFolder)
    If blnDebug Then Debug.Print , , aegitType.TestFolder & " has been CREATED !!!"

    Set objTestFolder = Nothing

    On Error GoTo 0
    BuildTheDirectory = True
    Exit Function

BuildTheDirectory_Error:

    MsgBox "Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure BuildTheDirectory of Class Module aegitClass"
    If blnDebug Then Debug.Print ">>>Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure BuildTheDirectory of Class Module aegitClass"

End Function

Private Function aeReadDocDatabase(Optional varDebug As Variant) As Boolean
' VBScript makes use of ADOX (Microsoft's Active Data Objects Extensions for Data Definition Language and Security)
' to create a query on a Microsoft Access database
' Ref: http://stackoverflow.com/questions/859530/alternative-to-application-loadfromtext-for-ms-access-queries
' Microsoft Access Stored Queries and VBscript: How to Create and Edit a Stored Database Query
' Ref: http://www.suite101.com/content/microsoft-access-stored-queries-and-vbscript-a87978#ixzz1D32Vqbso
' Using WScript
' Ref: http://www.codeforexcelandoutlook.com/vba/shell-scripting-using-vba-and-the-windows-script-host-object-model/
' vbscript get file extension
' Ref: http://www.experts-exchange.com/Programming/Languages/Visual_Basic/Q_24297896.html
'
'====================================================================
' Author:   Peter F. Ennis
' Date:     February 8, 2011
' Comment:  Add explicit references for objects, wscript, fso
' Requires: Reference to Microsoft Scripting Runtime
' Updated:
' 20121128: Fix debugging output
' 20110303: Add Debug.Print output for Skipping: message
'           Output VERSION and VERSION_DATE for debug
' 20110302: Change to aeReadDocDatabase for use in aegitClass
'           Add Skipping: to MsgBox for existing objects
' 20110224: Make this a function
'====================================================================
'

    Dim blnDebug As Boolean
    
    On Error GoTo aeReadDocDatabase_Error
    
    Debug.Print "aeReadDocDatabase"
    If IsMissing(varDebug) Then
        blnDebug = False
        Debug.Print , "varDebug IS missing so blnDebug of aeReadDocDatabase is set to False"
        Debug.Print , "DEBUGGING IS OFF"
    Else
        blnDebug = True
        Debug.Print , "varDebug IS NOT missing so blnDebug of aeReadDocDatabase is set to True"
        Debug.Print , "NOW DEBUGGING..."
    End If
    
    Const acQuery = 1

    Dim myFile As Object
    Dim strFileType As String
    Dim strFileBaseName As String
    Dim bln As Boolean

    If blnDebug Then
        Debug.Print ">==> aeReadDocDatabase >==>"
        Debug.Print , "aegit VERSION: " & VERSION
        Debug.Print , "aegit VERSION_DATE: " & VERSION_DATE
        Debug.Print , "aegitType.SourceFolder=" & aegitType.SourceFolder
        Debug.Print , "aegitType.TestFolder=" & aegitType.TestFolder
    End If

    '''''''''' Create needed objects
    Dim wsh As Object  ' As Object if late-bound
    Set wsh = CreateObject("WScript.Shell")
        If blnDebug Then Debug.Print , "wsh.CurrentDirectory=" & wsh.CurrentDirectory
        ' CurDir Function
        If blnDebug Then Debug.Print , "CurDir=" & CurDir
    
    Dim FSO As Scripting.FileSystemObject
    Set FSO = CreateObject("Scripting.FileSystemObject")

    If blnDebug Then
        bln = BuildTheDirectory(FSO, "WithDebugging")
        Debug.Print , "<==<"
    Else
        bln = BuildTheDirectory(FSO)
    End If

    Dim objFolder As Object
    Set objFolder = FSO.GetFolder(aegitType.TestFolder)

    For Each myFile In objFolder.Files
        If blnDebug Then Debug.Print "myFile = " & myFile
        If blnDebug Then Debug.Print "myFile.Name = " & myFile.Name
        strFileBaseName = FSO.GetBaseName(myFile.Name)
        strFileType = FSO.GetExtensionName(myFile.Name)
        If blnDebug Then Debug.Print strFileBaseName & " (" & strFileType & ")"

        If (strFileType = "frm") Then
            If Exists("FORMS", strFileBaseName) Then
                MsgBox "Skipping: FORM " & strFileBaseName & " exists in the current database.", vbInformation, "EXISTENCE IS REAL !!!"
                If blnDebug Then Debug.Print "Skipping: FORM " & strFileBaseName & " exists in the current database.", "EXISTENCE IS REAL !!!"
            Else
                Application.LoadFromText acForm, strFileBaseName, myFile.Path
            End If
        ElseIf (strFileType = "rpt") Then
            If Exists("REPORTS", strFileBaseName) Then
                MsgBox "Skipping: REPORT " & strFileBaseName & " exists in the current database.", vbInformation, "EXISTENCE IS REAL !!!"
                If blnDebug Then Debug.Print "Skipping: REPORT " & strFileBaseName & " exists in the current database.", "EXISTENCE IS REAL !!!"
            Else
                Application.LoadFromText acReport, strFileBaseName, myFile.Path
            End If
        ElseIf (strFileType = "bas") Then
            If Exists("MODULES", strFileBaseName) Then
                MsgBox "Skipping: MODULE " & strFileBaseName & " exists in the current database.", vbInformation, "EXISTENCE IS REAL !!!"
                If blnDebug Then Debug.Print "Skipping: MODULE " & strFileBaseName & " exists in the current database.", "EXISTENCE IS REAL !!!"
            Else
                Application.LoadFromText acModule, strFileBaseName, myFile.Path
            End If
        ElseIf (strFileType = "mac") Then
            If Exists("MACROS", strFileBaseName) Then
                MsgBox "Skipping: MACRO " & strFileBaseName & " exists in the current database.", vbInformation, "EXISTENCE IS REAL !!!"
                If blnDebug Then Debug.Print "Skipping: MACRO " & strFileBaseName & " exists in the current database.", "EXISTENCE IS REAL !!!"
            Else
                Application.LoadFromText acMacro, strFileBaseName, myFile.Path
            End If
        ElseIf (strFileType = "qry") Then
            If Exists("QUERIES", strFileBaseName) Then
                MsgBox "Skipping: QUERY " & strFileBaseName & " exists in the current database.", vbInformation, "EXISTENCE IS REAL !!!"
                If blnDebug Then Debug.Print "Skipping: QUERY " & strFileBaseName & " exists in the current database.", "EXISTENCE IS REAL !!!"
            Else
                Application.LoadFromText acQuery, strFileBaseName, myFile.Path
            End If
        End If
    Next

    If blnDebug Then Debug.Print "<==<"
    'Debug.Print "DONE !!!"

    On Error GoTo 0
    aeReadDocDatabase = True
    Exit Function

aeReadDocDatabase_Error:

    MsgBox "Erl=" & " Error " & Err.Number & " (" & Err.Description & ") in procedure aeReadDocDatabase of Class aegitClass"
    If blnDebug Then Debug.Print ">>>Erl=" & " Error " & Err.Number & " (" & Err.Description & ") in procedure aeReadDocDatabase of Class aegitClass"

End Function

Private Function aeExists(strAccObjType As String, _
                        strAccObjName As String, Optional varDebug As Variant) As Boolean
'
'====================================================================
' Author:     Peter F. Ennis
' Date:       February 18, 2011
' Comment:    Return True if the object exists
' Parameters:
'             strAccObjType: "Tables", "Queries", "Forms",
'                            "Reports", "Macros", "Modules"
'             strAccObjName: The name of the object
' Updated:
' 20121128:   Fix debugging output
' 20110302:   Make aeExists private in aegitClass
'====================================================================

    Dim objType As Object
    Dim obj As Variant
    Dim blnDebug As Boolean
    
    On Error GoTo aeExists_Error

    Debug.Print "aeExists"
    If IsMissing(varDebug) Then
        blnDebug = False
        Debug.Print , "varDebug IS missing so blnDebug of aeExists is set to False"
        Debug.Print , "DEBUGGING IS OFF"
    Else
        blnDebug = True
        Debug.Print , "varDebug IS NOT missing so blnDebug of aeExists is set to True"
        Debug.Print , "NOW DEBUGGING..."
    End If

    aeExists = False

    Select Case strAccObjType
        Case "Tables"
            Set objType = CurrentDb.TableDefs
        Case "Queries"
            Set objType = CurrentDb.QueryDefs
        Case "Forms"
            Set objType = CurrentProject.AllForms
        Case "Reports"
            Set objType = CurrentProject.AllReports
        Case "Macros"
            Set objType = CurrentProject.AllMacros
        Case "Modules"
            Set objType = CurrentProject.AllModules
        Case Else
            MsgBox "Wrong option!", vbCritical, "in procedure aeExists of Class aegitClass"
    End Select

    For Each obj In objType
        If obj.Name = strAccObjName Then
            aeExists = True
            Exit For ' Found it!
        End If
    Next

    On Error GoTo 0
    Set obj = Nothing
    Exit Function

aeExists_Error:

    MsgBox "Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure aeExists of Class aegitClass"
    If blnDebug Then Debug.Print ">>>Erl=" & Erl & " Error " & Err.Number & " (" & Err.Description & ") in procedure aeExists of Class aegitClass"

End Function