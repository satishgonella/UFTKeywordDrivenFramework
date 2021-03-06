Option Explicit
'*********************************************************
' DRIVER CLASS
'*********************************************************
Class Driver

	'*********************************************************
	' ATTRIBUTS
	'*********************************************************
	'Variable for Test Cases Management
	 Private mTestCases
	 Private mTestSteps
	'Variable for Test Data
	Private mTestDataPath
	'QTP Report
	Private mQTPReport
	'RunLog Report
	Private mRunLogReport

	'*********************************************************
	' Initialize/Terminate METHODS
	'*********************************************************
	
	'*********************************************************
	' Purpose:  Initializes the Driver object
	' Inputs:   Nothing.
	' Returns:  Nothing.
	'*********************************************************
	Sub Class_Initialize() 
		Set mTestCases = Nothing
		Set mTestSteps = Nothing
		mTestDataPath = ""
		Set mQTPReport = Nothing
		Set mRunLogReport = Nothing
	End Sub

	'*********************************************************
	' Purpose:  Terminates a Driver instance
	' Inputs:   Nothing.
	' Returns:  Nothing.
	'*********************************************************
	Sub Class_Terminate()
		Set mTestCases = Nothing
		Set mTestSteps = Nothing
		mTestDataPath = ""
		Set mQTPReport = Nothing
		Set mRunLogReport = Nothing
	End Sub
	
	'*********************************************************
	' PRIVATE METHODS
	'*********************************************************
				
	'*********************************************************
	' Purpose:  Retrieves data from external data or environment datasheet
	' Inputs:   strData:         the data string to analyse (e.g. "#Data(Query,Search)", "#Env(URL)", "5")
	' Returns:  The data from datasheet if Data/Env macro, otherwise returns the strData value. 
	'           If the data hasn't been found in the datasheet, returns "" and raise an error.
	'*********************************************************
	Private Function getData(ByVal strData) ' As String
		On Error Resume Next
		Err.Clear

		Dim objTestData
		Dim strTestDataID

		getData = ""
		Dim strTmpData, arrTmpSplit, strSheetName, strParam
		If Left(strData,6) = "#Data(" Then
			'If the data comes from an external datasheet "#Data()"
			strTmpData = Mid(strData, 7 ,Len(strData)-7)
			arrTmpSplit = Split(strTmpData, ",")
			strSheetName = Trim(arrTmpSplit (0))
			strParam = Trim(arrTmpSplit (1))
			'Retrieve the data id
			strTestDataID = mTestCases.Data(strSheetName)
            'Retrieve the data from a Datasheet
			Set objTestData = NewTestData(mTestDataPath, strSheetName)
			objTestData.SetCurrentData strTestDataID
			getData = objTestData.Data(strParam)
			Set objTestData = Nothing
			If getData = "" Then
				Err.Raise 1, "Datasheet", strParam & " Column not found in " & strSheetName & " datasheet"
			End If
		ElseIf  Left(strData,7) = "#Value(" Then
			'If the data comes from a temporary value "#Value()"
			strParam = Trim(Mid(strData, 8 ,Len(strData)-8))
			getData = Environment.Value("temp_" & strParam)
		ElseIf  Left(strData,5) = "#Env(" Then
			'If the data comes from Environment Configuration "#Env()"
			strParam = Trim(Mid(strData, 6 ,Len(strData)-6))
			strSheetName = "Environment"
			'Retrieve the data id
			strTestDataID = mTestCases.Environment
			'Retrieve the data from the Environment Datasheet
			Set objTestData = NewTestData(mTestDataPath, strSheetName)
			objTestData.SetCurrentData strTestDataID
			getData = objTestData.Data(strParam)
			Set objTestData = Nothing
			If getData = "" Then
				Err.Raise 1, "Datasheet", strParam & " Column not found in " & strSheetName & " datasheet"
			End If
		Else
			'Otherwise the data is directly used
			getData = strData
		End If
	End Function

	'*********************************************************
	' PUBLIC METHODS
	'*********************************************************
	
	'*********************************************************
	' Purpose:  Initialize the driver objects
	' Inputs:   strFrameworkFolderPath path to the folder concaining the keyword driven framework
	' Returns:  Nothing.
	' @TODO:    Change the Excel file config
	'*********************************************************
	Public Sub Init(ByVal strTestCasesFullPath, ByVal strTestDataFullPath) 
		mTestDataPath = strTestDataFullPath
		Set mTestCases = NewTestCases(strTestCasesFullPath,"TestCases")
		Set mTestSteps = NewTestSteps(strTestCasesFullPath,"TestSteps")
		Set mQTPReport = NewQTPReport()
		Set mRunLogReport = NewRunLogReport(strTestCasesFullPath,"RunLog")
	End Sub

	'*********************************************************
	' Purpose:  Run the steps of the test with the strTestId id
	' Inputs:   Nothing.
	' Returns:  Nothing.
	'*********************************************************
	Public Sub RunTest(ByVal strTestId)
		'Select the Test Case
		If mTestCases.ExistTest(strTestId) = False Then
			' If the test doesn't exist, stop the execution
			MsgBox "The test '" &strTestId & "' doesn't exist.", vbOK, "Error: Test not found"
			Exit Sub
		End If
		mTestCases.SetCurrentTest strTestId

		'Start the Test Case
		mQTPReport.TestBegin mTestCases.TestID, mTestCases.TestName
		mRunLogReport.TestBegin mTestCases.TestID, mTestCases.TestName, mTestCases.TestDescription
		'Loop on the SubTest
		Dim i
		For i = 1 to mTestCases.GetSubTestCount()
			Call runCurrentSubTest()
			If mTestCases.Status = "Aborted" Then
				Exit For
			End If
			mTestCases.SetNextSubTest()
		Next
		'End the Test Case
		mQTPReport.TestEnd
		mRunLogReport.TestEnd

	End Sub

	'*********************************************************
	' Purpose:  Run the steps of the current sub test
	' Inputs:   Nothing.
	' Returns:  Nothing
	'*********************************************************
	Private Sub runCurrentSubTest()

		'*********************************************************
		' SUBTEST START
		'*********************************************************   
		'Start the SubTest
		mQTPReport.SubTestBegin mTestCases.SubTestID, mTestCases.TestDescription
		mTestCases.StartDateTime = Date & " " & Time

		' If the sub test is not to be run
        If mTestCases.Execution = "N" Then
			mQTPReport.SubTestEnd
			mTestCases.EndDateTime = Date & " " & Time
			mTestCases.Status = "Skipped"
			Exit Sub
		End If

		mTestCases.Status = "In Progress"

		' If there are steps for this SubTest, Loop on the test steps
		If mTestSteps.ExistTest(mTestCases.SubTestID) Then
			'Select the first Test Step
			mTestSteps.SetCurrentSubTest(mTestCases.SubTestID)

			'Loop on the Test Steps
			Dim i, arrReturn
			Dim varParam1, varParam2, varParam3, strTestStatus
			strTestStatus = "Passed" 

			For i = 1 to mTestSteps.GetStepCount()
		'*********************************************************
		' STEP START
		'*********************************************************
				mTestSteps.StartDateTime = Date & " " & Time
				mQTPReport.StepBegin mTestSteps.StepID, mTestSteps.StepDescription, mTestSteps.ObjectID, mTestSteps.Keyword
				mRunLogReport.StepBegin mTestSteps.SubTestID, mTestSteps.SubTestDescription, mTestSteps.StepID, mTestSteps.StepDescription, _
                                                    mTestSteps.Keyword, mTestSteps.BrowserID, mTestSteps.PageID, mTestSteps.ObjectID, _
                                                    mTestSteps.Param(1), mTestSteps.Param(2), mTestSteps.Param(3), _
                                                    mTestSteps.Execution, mTestSteps.Status, mTestSteps.StartDateTime

				Select Case mTestSteps.Execution
				Case "B"
					'Test Step with a Breakpoint
					mTestSteps.Status = "Break"
					strTestStatus = "Break" 
					mTestSteps.EndDateTime = Date & " " & Time
					mRunLogReport.StepEnd mTestSteps.Status, mTestSteps.EndDateTime, "", "", ""			
					Exit For
				Case "N"
					'Test Step to skip
					mTestSteps.Status = "Skipped"
					mTestSteps.EndDateTime = Date & " " & Time
					mRunLogReport.StepEnd mTestSteps.Status, mTestSteps.EndDateTime, "", "", ""	
				Case "Y"
					'Test Step to execute
	   	
					' Retrieve the parameters value
					varParam1 = getData(mTestSteps.Param(1))
					If Err.Number <> 0 Then
						mQTPReport.StepEnd Err.Number, "", Err.Description, "N"
						mRunLogReport.StepEnd mTestSteps.Status, mTestSteps.EndDateTime, "", "", mTestSteps.Error
						Exit For
					End If
					varParam2 = getData(mTestSteps.Param(2))
					If Err.Number <> 0 Then
						mQTPReport.StepEnd Err.Number, "", Err.Description, "N"
						mRunLogReport.StepEnd mTestSteps.Status, mTestSteps.EndDateTime, "", "", mTestSteps.Error
						Exit For
					End If
					varParam3 = getData(mTestSteps.Param(3))
					If Err.Number <> 0 Then
						mQTPReport.StepEnd Err.Number, "", Err.Description, "N"
						mRunLogReport.StepEnd mTestSteps.Status, mTestSteps.EndDateTime, "", "", mTestSteps.Error
						Exit For
					End If
					mRunLogReport.UpdateKeywordParameters varParam1, varParam2, varParam3
	
					' Run the keyword
					arrReturn = runKeyword (mTestSteps.Keyword, mTestSteps.BrowserID, mTestSteps.PageID, mTestSteps.ObjectID,  varParam1, varParam2, varParam3)

		'*********************************************************
		' STEP END
		'*********************************************************
					mTestSteps.EndDateTime = Date & " " & Time
					If Err.Number <> 0 Then
						'If an exception occured
						mQTPReport.StepEnd Err.Number, "", Err.Description, "Y"
                        mTestSteps.Status = "Aborted"
						strTestStatus = "Aborted" 
						mTestSteps.Error = "Error " & Err.Number & ": " & Err.Description
						mTestCases.Error = "Error " & Err.Number & ": " & Err.Description
						mRunLogReport.StepEnd mTestSteps.Status, mTestSteps.EndDateTime, "", "", mTestSteps.Error
						Exit For
					Else
						' If keyword run without rising exceptions
						mQTPReport.StepEnd arrReturn(0), arrReturn(1), arrReturn(2), mTestSteps.Screenshot
						If arrReturn(0) = 0 Then
							mTestSteps.Status = "Passed"
						Else
							mTestSteps.Status = "Failed"
							strTestStatus = "Failed" 
						End If
						mTestSteps.Return = arrReturn(2)
						mRunLogReport.StepEnd mTestSteps.Status, mTestSteps.EndDateTime,  arrReturn(1),  arrReturn(2), ""
					End If
					
				End Select

				' Next test step
				'mTestSteps.SetNextStep
				'@TODO: fix this
				datatable.GetSheet("dTestSteps").SetNextRow

			Next

		'*********************************************************
		' SUBTEST END
		'*********************************************************
			mQTPReport.SubTestEnd
			mTestCases.EndDateTime = Date & " " & Time
			mTestCases.Status = strTestStatus
		End If

	End Sub

End Class

'*********************************************************
' CONSTRUCTION FUNCTION
'*********************************************************
Public Function NewDriver(ByVal strTestCasesFullPath, ByVal strTestDataFullPath) 
    Set NewDriver = new Driver
    Call NewDriver.Init(strTestCasesFullPath, strTestDataFullPath)
End Function
