Option Explicit
'*********************************************************
' ORACLE KEYWORDS
'*********************************************************
Class OracleKeyword
	
	'*********************************************************
	' Purpose:  Run the action linked to a Oracle Keyword
	' Inputs:   
	'           strKeyword:       the keyword linked to the function to run
	'           strBrowserID:    the id of the Browser in the ObjectRepository
	'           strPageID:         the id of the Page in the ObjectRepository
	'           strObjectID:       the id of the object in the ObjectRepository
	'           strParam1:        first parameter to pass to the function to run (optional)
	'           strParam2:        second parameter to pass to the function to run (optional)
	'           strParam3:        third parameter to pass to the function to run (optional)
	' Returns:  The return code of the keyword function. 
	'           If the keyword hasn't been found, returns 1 and raise an error.
	'*********************************************************
	Public Function runKeyword (ByVal strKeyword,ByVal strBrowserID,ByVal strPageID,ByVal strObjectID,ByVal strParam1,ByVal strParam2,ByVal strParam3) ' As Integer
		On Error Resume Next
		Err.Clear
	
		Dim arrReturn ' Array containing the result of the keyword function call
		Dim objCurrent
		Dim strObjectType
	
		'Retrieve Object Type
		strObjectType = getObjectTypeFromKeyword(strKeyword)
	
		'Run Keyword
		Select Case strKeyword
		Case "oracle_oracleapplications_activate"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_activate(objCurrent, True)
		Case "oracle_oracleapplications_exist"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oracleapplications_exist(objCurrent, True, 60)
		Case "oracle_oraclelogon_activate"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_activate(objCurrent, True)
		Case "oracle_oraclelogon_close"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oraclelogon_close(objCurrent)
		Case "oracle_oraclelogon_logon"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oraclelogon_logon(objCurrent, strParam1, strParam2)
		Case "oracle_oraclelistofvalues_set"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_select(objCurrent, strParam1)
		Case "oracle_oraclenavigator_set"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oraclenavigator_set(objCurrent, strParam1)
		Case "oracle_oraclenotification_clickapprove"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oraclenotification_clickapprove(objCurrent)
		Case "oracle_oraclenotification_clickcancel"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oraclenotification_clickcancel(objCurrent)
		Case "oracle_oraclenotification_exist"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_exist(objCurrent, True)
		Case "oracle_oraclenotification_get"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_get(objCurrent, strParam1, "message")
		Case "oracle_oraclewindow_exist"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_exist(objCurrent, True)
		Case "oracle_oraclewindow_activate"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_activate(objCurrent, True)
		Case "oracle_oracletabbedregion_activate"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oracletabbedregion_activate(objCurrent)
		Case "oracle_oraclebutton_click"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_click(objCurrent)
		Case "oracle_oraclecheckbox_get"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_get(objCurrent, strParam1, "checked")
		Case "oracle_oraclecheckbox_set"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oraclecheckbox_set(objCurrent, strParam1)
		Case "oracle_oraclelist_get"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_get(objCurrent, strParam1, "value")
		Case "oracle_oraclelist_set"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_select(objCurrent, strParam1)
		Case "oracle_oracleradiogroup_get"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_get(objCurrent, strParam1, "value")
		Case "oracle_oracleradiogroup_set"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_select(objCurrent, strParam1)
		Case "oracle_oraclestatusline_get"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_get(objCurrent, strParam1, "message")
		Case "oracle_oracletable_getcell"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oracletable_getcell(objCurrent, strParam1, strParam2, strParam3)
		Case "oracle_oracletable_setcell"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oracletable_setcell(objCurrent, strParam1, strParam2, strParam3)
		Case "oracle_oracletable_setrow"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oracletable_setrow(objCurrent, strParam1)
		Case "oracle_oracletextfield_get"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = generic_object_get(objCurrent, strParam1, "value")
		Case "oracle_oracletextfield_set"
			Set objCurrent = getQTPObject(strObjectType, strBrowserID, strPageID, strObjectID) 
			arrReturn = oracle_oracletextfield_set(objCurrent, strParam1)
		Case Else
			Err.Raise 1, "OracleKeyword", strKeyword & " keyword not found"
			arrReturn = Array(1, "", Err.Description)
		End Select
		Set objCurrent = Nothing
	
		runKeyword = arrReturn
	End Function
	
	'*********************************************************
	' Object Repository search
	'*********************************************************
	Private Function getQTPObject(ByVal strObjectType,ByVal strBrowserID,ByVal strPageID,ByVal strObjectID) ' As Object
		On Error Resume Next
		Err.Clear
		Set getQTPObject = Nothing

		'############# For Non Window related objects
		If strObjectType = "oracleapplications" Then
			Set getQTPObject  = OracleApplications(strObjectID)
		ElseIf strObjectType = "oraclelogon" Then
			Set getQTPObject  = OracleLogon(strObjectID)
		ElseIf strObjectType = "oraclelistofvalues" Then
			Set getQTPObject  = OracleListOfValues(strObjectID)
		ElseIf strObjectType = "oraclenavigator" Then
			Set getQTPObject  = OracleNavigator(strObjectID)
		ElseIf strObjectType = "oraclenotification" Then
			Set getQTPObject  = OracleNotification(strObjectID)
		Else
			'########### For Window related objects

			Dim objPage
			'Identify if the Page is a OracleFormWindow  (Form prefix) or a OracleFlexWindow (Flex prefix)
			If LCase(Left(strBrowserID, 4)) = "form" Then
				Set objPage = OracleFormWindow(strBrowserID)
			Else
				Set objPage = OracleFlexWindow(strBrowserID)
			End If

			'##### Manage the case of types "JavaFormWindow", "JavaFlexWindow" and "OracleTabbedRegion"
			If strObjectType = "oraclewindow" Then
				Set getQTPObject  = objPage
			ElseIf strObjectType = "oracletabbedregion" Then
				Set getQTPObject  = objPage.OracleTabbedRegion(strObjectID)
			Else

				'If a TabbedRegion ID has been documented in the Page_ID column
				If strPageID <> "" Then
					Set objPage = objPage.OracleTabbedRegion(strPageID)
				End If

				Select Case strObjectType
				Case "oracletabbedregion"
					Set getQTPObject  = objPage
				Case "oraclebutton"
					Set getQTPObject  = objPage.OracleButton(strObjectID)
				Case "oraclecheckbox"
					Set getQTPObject  = objPage.OracleCheckbox(strObjectID)
				Case "oraclelist"
					Set getQTPObject  = objPage.OracleList(strObjectID)
				Case "oracleradiogroup"
					Set getQTPObject  = objPage.OracleRadioGroup(strObjectID)
				Case "oraclestatusline"
					Set getQTPObject  = objPage.OracleStatusLine(strObjectID)
				Case "oracletable"
					Set getQTPObject  = objPage.OracleTable(strObjectID)
				Case "oracletextfield"
					Set getQTPObject  = objPage.OracleTextField(strObjectID)
   				End Select
			End If
		End If
		On Error GoTo 0
		If getQTPObject Is Nothing Then
			Err.Raise 1, "OracleKeyword", strObjectID & " Object of type " & strObjectType & " not found in the Object Repository"
		End If
	End Function
	
	'*********************************************************
	' Keyword implementations
	'*********************************************************
	Private Function oracle_oracleapplications_exist(ByRef objObject, ByVal intTimeOut)
		objObject.Sync intTimeOut
		If objObject.Exist(4) = False Then
			Dim strErrorDescription
			strErrorDescription = objObject.GetROPRoperty("micClass") & " not found"
			If blnAbordTest Then
				Err.Raise 1, "Error", strErrorDescription
			End If
			oracle_oracleapplications_exist = Array (1, "", strErrorDescription)
		Else
			oracle_oracleapplications_exist = Array (0, "", "Application successfully loaded.")
		End If
	End Function

	Private Function oracle_oraclelogon_close(ByRef objObject)
		objObject.CloseForm
		oracle_oraclelogon_close = Array (0, "", "Close the Form")
	End Function
	Private Function oracle_oraclelogon_logon(ByRef objObject, ByVal strUserName, ByVal strPassword)
		objObject.Logon strUserName, strPassword
		oracle_oraclelogon_logon = Array (0, "", "Logon to Oracle with the user '" & strUserName & "'")
	End Function

	Private Function oracle_oraclenavigator_set(ByRef objObject, ByVal strValue)
		objObject.SelectFunction strValue
		oracle_oraclenavigator_set = Array (0, "", "Select the function '" & strValue & "'")
	End Function

	Private Function oracle_oraclenotification_clickapprove(ByRef objObject)
		objObject.Approve
		oracle_oraclenotification_clickapprove = Array (0, "", "Click on the OK button of the Notification.")
	End Function
	Private Function oracle_oraclenotification_clickcancel(ByRef objObject)
		objObject.Cancel
		oracle_oraclenotification_clickcancel = Array (0, "", "Click on the Cancel button of the Notification.")
	End Function

	Private Function oracle_oracletabbedregion_activate(ByRef objObject)
	   objObject.Select
		oracle_oracletabbedregion_activate = Array (0, "", "Activate the Tabbed Region.")
	End Function

	Private Function oracle_oraclecheckbox_set(ByRef objObject, ByVal strValue)
		If strValue = "ON" Then
            objObject.Select    'Select
		Else
			objObject.Clear       'Unselect
		End If
		oracle_oraclecheckbox_set = Array (0, "", "Value '" & strValue & "' set in the " & objObject.GetROPRoperty("micClass") & " field")
	End Function

	Private Function java_javatable_getcell(ByRef objTable, ByVal intRow, ByVal intColumn, ByVal strValueID)
		Dim strValue
		strValue = objTable.GetFieldValue(intRow,  intColumn)
		Call saveRunValue (strValueID, strValue)
		 java_javatable_getcell = Array (0, "", "Value '" & strValue & "' saved with the ValueID '" & strValueID & "'")
	End Function
	Private Function oracle_oracletable_setcell(ByRef objTable, ByVal intRow, ByVal intColumn, ByVal strValue)
		objTable.EnterField intRow,  intColumn, strValue
		oracle_oracletable_setcell = Array (0, "", "Value '" & strValue & "' set in the Cell(" & intRow & ", " & intColumn & ").")
	End Function
	Private Function oracle_oracletable_setrow(ByRef objTable, ByVal intRow)
		objTable.ActivateRecord intRow - 1
		oracle_oracletable_setrow = Array (0, "", "Row '" & intRow & "' selected in the JavaTable.")
	End Function

	Private Function oracle_oracletextfield_set(ByRef objObject, ByVal strValue)
		objObject.Enter strValue
		oracle_oracletextfield_set = Array (0, "", "Value '" & strValue & "' set in the " & objObject.GetROPRoperty("micClass") & " field")
	End Function
	
End Class