package de.nordakademie.ticket.tests

import com.google.inject.Inject
import de.nordakademie.ticket.TicketInjectorProvider
import de.nordakademie.ticket.constantsAndNames.Constants
import de.nordakademie.ticket.ticket.ModelIssue
import de.nordakademie.ticket.ticket.TicketPackage.Literals
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(TicketInjectorProvider)
class ValidationTest implements Constants{
	
	@Inject extension ParseHelper<ModelIssue> 
	@Inject extension ValidationTestHelper 
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//Transition Validations
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testTransitionStatusValidation() {
		'''
			Status same
			Transition myTransition named "Title" { same to same }
		'''.parse.assertError(Literals.TRANSITION, DUPLICATED_TRANSITION_STATUS)
	}
	
	@Test
	def void testTransitionStatusValidationOK() {
		'''
			Status same
			Status different
			Transition myTransition named "Title" { same to different }
		'''.parse.assertNoErrors(Literals.TRANSITION, DUPLICATED_TRANSITION_STATUS)
	}
	
	@Test
	def void testTransitionTitleValidation() {
		'''
			Status same
			Status different
			Transition myTransition named "  " { same to different }
		'''.parse.assertError(Literals.TRANSITION, EMPTY_STRING)
	}
	
	
	@Test
	def void testTransitionTitleValidationOK() {
		'''
			Status same
			Status different
			Transition myTransition named "a" { same to different }
		'''.parse.assertNoErrors(Literals.TRANSITION, EMPTY_STRING)
	}
	
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//Workflow Validations	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testWorkflowSameTransitionsValidation() {
		'''
			Status same
			Status different
			Transition myTransition1 named "Title" { same to different }
			Transition myTransition2 named "Title" { same to different }
			Transition myTransition3 named "Title" { same to different }
			Transition myTransition4 named "Title" { same to different }
			Workflow workflow { myTransition1 myTransition2 myTransition1 myTransition3 myTransition4 }
		'''.parse.assertError(Literals.WORKFLOW, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testWorkflowTransitionsValidationOK1() {
		'''
			Workflow workflow { }
		'''.parse.assertNoErrors(Literals.WORKFLOW, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testWorkflowTransitionsValidationOK2() {
		'''
			Status same
			Status different
			Transition myTransition1 named "Title" { same to different }
			Transition myTransition2 named "Title" { same to different }
			Transition myTransition3 named "Title" { same to different }
			Transition myTransition4 named "Title" { same to different }
			Workflow workflow { myTransition1 myTransition2 myTransition3 myTransition4 }
		'''.parse.assertNoErrors(Literals.WORKFLOW, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//Role Validations	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testRoleNoTransitionValidation() {
		'''
			Role emptyRole { }
		'''.parse.assertError(Literals.ROLE, EMPTY_ROLE)
	}
	
	@Test
	def void testRoleNoTransitionValidationOK1() {
		'''
			Role role { create Issue }
		'''.parse.assertNoErrors(Literals.ROLE, EMPTY_ROLE)
	}
	
	@Test
	def void testRoleNoTransitionsValidationOK2() {
		'''
			Status same
			Status different
			Transition myTransition named "Title" { same to different }
			Role role { myTransition }
		'''.parse.assertNoErrors(Literals.ROLE, EMPTY_ROLE)
	}
	
	@Test
	def void testRoleNoTransitionsValidationOK3() {
		'''
			Status same
			Status different
			Transition myTransition named "Title" { same to different }
			Role role { create Issue myTransition }
		'''.parse.assertNoErrors(Literals.ROLE, EMPTY_ROLE)
	}
	
	@Test
	def void testRoleSameTransitionsValidation() {
		'''
			Status same
			Status different
			Transition myTransition1 named "Title" { same to different }
			Transition myTransition2 named "Title" { same to different }
			Transition myTransition3 named "Title" { same to different }
			Role role { myTransition1 myTransition2 myTransition2 myTransition3 }
		'''.parse.assertError(Literals.ROLE, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testRoleSameTransitionsValidationOK1() {
		'''
			Status same
			Status different
			Transition myTransition1 named "Title" { same to different }
			Transition myTransition2 named "Title" { same to different }
			Transition myTransition3 named "Title" { same to different }
			Role role { myTransition1 myTransition2 myTransition3 }
		'''.parse.assertNoErrors(Literals.ROLE, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testRoleSameTransitionsValidationOK2() {
		'''
			Role role { }
		'''.parse.assertNoErrors(Literals.ROLE, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//Person Validation	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testPersonNameValidation() {
		'''
			Person person called "" { }
		'''.parse.assertError(Literals.PERSON, EMPTY_STRING)
	}
	
	@Test
	def void testPersonNameValidationOK() {
		'''
			Person person called "John Doe" { }
		'''.parse.assertNoErrors(Literals.PERSON, EMPTY_STRING)
	}
	
	@Test
	def void testPersonSameRolesValidation() {
		'''
			Role role1 { }
			Role role2 { }
			Role role3 { }
			Role role4 { }
			Role role5 { }
			Role role6 { }
			Person myPerson called "John Doe" { role1 role2 role3 role4 role5 role3 role6}
		'''.parse.assertError(Literals.PERSON, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testPersonSameRolesValidationOK1() {
		'''
			Role role1 { }
			Role role2 { }
			Role role3 { }
			Role role4 { }
			Role role5 { }
			Role role6 { }
			Person myPerson called "John Doe" { role1 role2 role3 role4 role5 role6 }
		'''.parse.assertNoErrors(Literals.PERSON, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testPersonSameRolesValidationOK2() {
		'''
			Person myPerson called "John Doe" { }
		'''.parse.assertNoErrors(Literals.PERSON, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////		
//Date Validation
//Day-Validation
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testDateDayValidationHigh1() {
		'''
			DateField field as "Date" {	default 32.01.2001 }
		'''.parse.assertError(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationHigh1OK() {
		'''
			DateField field as "Date" {	default 31.01.2001 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationHigh2() {
		'''
			DateField field as "Date" {	default 32.08.2001 }
		'''.parse.assertError(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationHigh2OK() {
		'''
			DateField field as "Date" {	default 31.08.2001 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_DAY)
	}
	
	
	@Test
	def void testDateDayValidationHigh3() {
		'''
			DateField field as "Date" {	default 30.02.2000 }
		'''.parse.assertError(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationHigh3OK1() {
		'''
			DateField field as "Date" {	default 29.02.2000 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationHigh3OK2() {
		'''
			DateField field as "Date" {	default 29.02.2004 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationHigh4() {
		'''
			DateField field as "Date" {	default 31.06.2001 }
		'''.parse.assertError(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationHigh4OK() {
		'''
			DateField field as "Date" {	default 30.06.2001 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationLow1() {
		'''
			DateField field as "Date" {	default 0.4.2001 }
		'''.parse.assertError(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationLow1OK() {
		'''
			DateField field as "Date" {	default 1.6.2001 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationLow2() {
		'''
			DateField field as "Date" {	default 0.2.2004 }
		'''.parse.assertError(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationLow2OK() {
		'''
			DateField field as "Date" {	default 1.2.2004 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationLow3() {
		'''
			DateField field as "Date" {	default 0.4.2001 }
		'''.parse.assertError(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationLow3OK() {
		'''
			DateField field as "Date" {	default 1.4.2001 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_DAY)
	}
	
	@Test
	def void testDateDayValidationMiddleOK() {
		'''
			DateField field as "Date" {	default 16.6.2001 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_DAY)
	}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//Month Validation
	@Test
	def void testDateMonthValidationHigh() {
		'''
			DateField field as "Date" {	default 11.13.2001 }
		'''.parse.assertError(Literals.DATE, INVALID_MONTH)
	}
	
	@Test
	def void testDateMonthValidationHighOK() {
		'''
			DateField field as "Date" {	default 1.12.2001 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_MONTH)
	}
	
	@Test
	def void testDateMonthValidationLow() {
		'''
			DateField field as "Date" {	default 11.00.2001 }
		'''.parse.assertError(Literals.DATE, INVALID_MONTH)
	}
	
	@Test
	def void testDateMonthValidationLowOK() {
		'''
			DateField field as "Date" {	default 11.01.2001 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_MONTH)
	}
	
	@Test
	def void testDateMonthValidationMiddleOK() {
		'''
			DateField field as "Date" {	default 22.07.2001 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_MONTH)
	}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//Year Validation
	@Test
	def void testDateYearValidationLowHigh() {
		'''
			DateField field as "Date" {	default 11.01.100 }
		'''.parse.assertError(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationLowOK1() {
		'''
			DateField field as "Date" {	default 11.04.00 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationLowOK2() {
		'''
			DateField field as "Date" {	default 11.01.99 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationLowOK3() {
		'''
			DateField field as "Date" {	default 11.01.01 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationLowOK4() {
		'''
			DateField field as "Date" {	default 11.01.45 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationHigh1() {
		'''
			DateField field as "Date" {	default 11.01.1899 }
		'''.parse.assertError(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationHigh1OK() {
		'''
			DateField field as "Date" {	default 11.01.1900 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationHigh2() {
		'''
			DateField field as "Date" {	default 11.01.2100 }
		'''.parse.assertError(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationHigh2OK() {
		'''
			DateField field as "Date" {	default 11.01.2099 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationHigh3() {
		'''
			DateField field as "Date" {	default 11.01.9998}
		'''.parse.assertError(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationHigh3OK() {
		'''
			DateField field as "Date" {	default 11.01.9999 }
		'''.parse.assertNoErrors(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationHigh4() {
		'''
			DateField field as "Date" {	default 11.01.10000}
		'''.parse.assertError(Literals.DATE, INVALID_YEAR)
	}
	
	@Test
	def void testDateYearValidationHigh5() {
		'''
			DateField field as "Date" {	default 11.01.3456}
		'''.parse.assertError(Literals.DATE, INVALID_YEAR)
	}
	
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//IssueType Validation
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testIssueTypeSameFieldsValidation() {
		'''
			Status status1
			Status status2
			Transition trans named "1to2" { status1 to status2 }
			Workflow workflow { trans }
			StringField field1 as "String" {}
			IssueType iType follows workflow { field1 field1 }
		'''.parse.assertError(Literals.ISSUE_TYPE, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testIssueTypeSameFieldsValidationOK() {
		'''
			Status status1
			Status status2
			Transition trans named "1to2" { status1 to status2 }
			Workflow workflow { trans }
			StringField field1 as "String" {}
			IssueType iType follows workflow { field1 }
		'''.parse.assertNoErrors(Literals.ISSUE_TYPE, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//IssueScreen Validation
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testIssueScreenSameFieldsValidation() {
		'''
			Status status
			DateField field1 as "Date" {}
			DateField field2 as "Begin" {}
			PersonField field3 as "Person"{}
			
			IssueScreen issueScreen {
				StatusField statusField {default status}

				SummaryField beschreibung { }
				field1 field2 field2 field3
			}
		'''.parse.assertError(Literals.ISSUE_SCREEN, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testIssueScreenSameFieldsValidationOK() {
		'''
			Status status
			DateField field1 as "Date"{}
			DateField field2 as "Begin"{}
			PersonField field3 as "Person"{}
			
			IssueScreen issueScreen {
				StatusField statusField {default status}
				
				SummaryField beschreibung { }
				field1 field2 field3
			}
		'''.parse.assertNoErrors(Literals.ISSUE_SCREEN, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//Field Valitation
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testEmptyFieldDescription1 (){
		'''
			DateField field1 as "          " { default today }
		'''.parse.assertError(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription2 (){
		'''
			StringField field1 as " " { }
		'''.parse.assertError(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription3 (){
		'''
			CheckField field1 as "   " { }
		'''.parse.assertError(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription4 (){
		'''
			MailField field1 as "  " { }
		'''.parse.assertError(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription5 (){
		'''
			ComboField field1 as "" { }
		'''.parse.assertError(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription6 (){
		'''
			Person pers called "Balu" {}
			PersonField field1 as "" { default pers }
		'''.parse.assertError(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription1OK (){
		'''
			DateField field1 as "Date" { default today }
		'''.parse.assertNoErrors(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription2OK (){
		'''
			StringField field1 as "aAAS" { }
		'''.parse.assertNoErrors(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription3OK (){
		'''
			CheckField field1 as "_ASD_" { }
		'''.parse.assertNoErrors(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription4OK (){
		'''
			MailField field1 as "4567" { }
		'''.parse.assertNoErrors(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription5OK (){
		'''
			ComboField field1 as "asd" { }
		'''.parse.assertNoErrors(Literals.FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyFieldDescription6OK (){
		'''
			Person pers called "Balu" {}
			PersonField field1 as "Field" { default pers }
		'''.parse.assertNoErrors(Literals.FIELD, EMPTY_STRING)
	}

	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//Validation ComboField
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testDuplicatedComboEntries (){
		'''
			ComboField field as "Combo" {
				default { "entry1", "entry2", "entry3", "entry2" }
			}
		'''.parse.assertError(Literals.COMBO_FIELD, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testDuplicatedComboEntriesOK (){
		'''
			ComboField field as "Combo" {
				default { "entry1", "entry2", "entry3", "entry4" }
			}
		'''.parse.assertNoErrors(Literals.COMBO_FIELD, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testEmptyComboEntries (){
		'''
			ComboField field as "Combo" {
				default { "    ", "filled" }
			}
		'''.parse.assertError(Literals.COMBO_FIELD, EMPTY_STRING)
	}
	
	@Test
	def void testEmptyComboEntriesOK (){
		'''
			ComboField field as "Combo" {
				default { "_", "entry3", "entry2" }
			}
		'''.parse.assertNoErrors(Literals.COMBO_FIELD, EMPTY_STRING)
	}

	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//MailField Validation
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testInvalidMail (){
		'''
			MailField field as "Mail" {
				default "#@%^%#$@#$@#.com"
			}
		'''.parse.assertError(Literals.MAIL_FIELD, INVALID_MAIL)
	}
	
	@Test
	def void testInvalidMail2 (){
		'''
			MailField field as "Mail" {
				default ".email@example.com"
			}
		'''.parse.assertError(Literals.MAIL_FIELD, INVALID_MAIL)
	}
	
	@Test
	def void testInvalidMail3 (){
		'''
			MailField field as "Mail" {
				default "あいうえお@example.com"
			}
		'''.parse.assertError(Literals.MAIL_FIELD, INVALID_MAIL)
	}
	
	@Test
	def void testInvalidMail4 (){
		'''
			MailField field as "Mail" {
				default "email@example"
			}
		'''.parse.assertError(Literals.MAIL_FIELD, INVALID_MAIL)
	}
	
	@Test
	def void testInvalidMail5 (){
		'''
			MailField field as "Mail" {
				default "email@111.222.333.44444"
			}
		'''.parse.assertError(Literals.MAIL_FIELD, INVALID_MAIL)
	}
	
	@Test
	def void testInvalidMail6 (){
		'''
			MailField field as "Mail" {
				default "email@example..com"
			}
		'''.parse.assertError(Literals.MAIL_FIELD, INVALID_MAIL)
	}
	
	@Test
	def void testInvalidMailOK (){
		'''
			MailField field as "Mail" {
				default "_______@example.com"
			}
		'''.parse.assertNoErrors(Literals.MAIL_FIELD, INVALID_MAIL)
	}
	
	@Test
	def void testInvalidMailOK2 (){
		'''
			MailField field as "Mail" {
				default "firstname+lastname@example.com"
			}
		'''.parse.assertNoErrors(Literals.MAIL_FIELD, INVALID_MAIL)
	}
	@Test
	def void testInvalidMailOK3 (){
		'''
			MailField field as "Mail" {
				default "email@subdomain.example.com"
			}
		'''.parse.assertNoErrors(Literals.MAIL_FIELD, INVALID_MAIL)
	}
	@Test
	def void testInvalidMailOK4 (){
		'''
			MailField field as "Mail" {
				default "email@example-one.com"
			}
		'''.parse.assertNoErrors(Literals.MAIL_FIELD, INVALID_MAIL)
	}


///////////////////////////////////////////////////////////////////////////////////////////////////////	
//Duplicated Rule Validation
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testDuplicatedStatus (){
		'''
			Status a
			Status b
			Status c
			Status b
		'''.parse.assertError(Literals.NAME_OBJECT, DUPLICATED_RULE_NAME)
	}
	
	@Test
	def void testDuplicatedField (){
		'''
			MailField mail as "Mail" {}
			DateField field as "F" {}
			DateField date as "D" {}
			StringField field as "String" {}
		'''.parse.assertError(Literals.NAME_OBJECT, DUPLICATED_RULE_NAME)
	}
	
	@Test
	def void testDuplicatedWorkflow (){
		'''
			Status status1
			Status status2
			Transition trans named "1to2" { status1 to status2 }
			Workflow workflow1 { trans }
			Workflow workflow2 { trans }
			Workflow workflow1 { trans }
		'''.parse.assertError(Literals.NAME_OBJECT, DUPLICATED_RULE_NAME)
	}	
	
	@Test
	def void testDuplicatedIssueType (){
		'''
			Status status1
			Status status2
			Transition trans named "1to2" { status1 to status2 }
			Workflow workflow { trans }
			IssueType i1 follows workflow { }
			IssueType i2 follows workflow { }
			IssueType issueType follows workflow { }
			IssueType i1 follows workflow { }
		'''.parse.assertError(Literals.NAME_OBJECT, DUPLICATED_RULE_NAME)
	}	
	
	@Test
	def void testDuplicatedTransition (){
		'''
			Status a
			Status b
			Status c
			Transition t1 named "Trans" {a to b}
			Transition t1 named "Trans" {a to b}
			Transition t2 named "Trans" {a to b}
			Transition t3 named "Trans" {a to b}
		'''.parse.assertError(Literals.NAME_OBJECT, DUPLICATED_RULE_NAME)
	}	
	
	@Test
	def void testDuplicatedRole (){
		'''
			Status a
			Status b
			Transition t1 named "Trans" {a to b}
			Role role1 { create Issue }
			Role role1 { t1 }
		'''.parse.assertError(Literals.NAME_OBJECT, DUPLICATED_RULE_NAME)
	}	
	
	@Test
	def void testDuplicatedPerson (){
		'''
			Person p1 called "Wambo"  {}
			Person p2 called "Rambo"  { }
			Person p2 called "Bambi"  { }
		'''.parse.assertError(Literals.NAME_OBJECT, DUPLICATED_RULE_NAME)
	}	
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//MissingRule Test
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testMissingRuleStatus() {
		'''
			Transition trans named "1to2" { status1 to status2 }
			Workflow workflow { trans }
			StringField field1 as "String" {}
			IssueType iType follows workflow { field1 }
			Role role1 { create Issue }
			Person john called "Johnny" { role1 }
			IssueScreen issueScreen {StatusField statusField { default status1 } SummaryField sum {} }
		'''.parse.assertError(Literals.MODEL_ISSUE, MISSING_RULE)
	}
	
	@Test
	def void testMissingRuleTransition() {
		'''
			Status status1
			Status status2
			Workflow workflow { trans }
			StringField field1 as "String" {}
			IssueType iType follows workflow { field1 }
			Role role1 { create Issue }
			Person john called "Johnny" { role1 }
			IssueScreen issueScreen {StatusField statusField { default status1 } SummaryField sum {} }
		'''.parse.assertError(Literals.MODEL_ISSUE, MISSING_RULE)
	}
	
	@Test
	def void testMissingWorkflow() {
		'''
			Status status1
			Status status2
			Transition trans named "1to2" { status1 to status2 }
			StringField field1 as "String" {}
			IssueType iType follows workflow { field1 }
			Role role1 { create Issue }
			Person john called "Johnny" { role1 }
			IssueScreen issueScreen {StatusField statusField { default status1 } SummaryField sum {} }
		'''.parse.assertError(Literals.MODEL_ISSUE, MISSING_RULE)
	}
	
	@Test
	def void testMissingField() {
		'''
			Status status1
			Status status2
			Transition trans named "1to2" { status1 to status2 }
			Workflow workflow { trans }
			Role role1 { create Issue }
			Person john called "Johnny" { role1 }
			IssueScreen issueScreen {StatusField statusField { default status1 } SummaryField sum {} }
		'''.parse.assertError(Literals.MODEL_ISSUE, MISSING_RULE)
	}
	@Test
	def void testMissingIssueType() {
		'''
			Status status1
			Status status2
			Transition trans named "1to2" { status1 to status2 }
			Workflow workflow { trans }
			StringField field1 as "String" {}
			Role role1 { create Issue }
			Person john called "Johnny" { role1 }
			IssueScreen issueScreen {StatusField statusField { default status1 } SummaryField sum {} }
		'''.parse.assertError(Literals.MODEL_ISSUE, MISSING_RULE)
	}
	@Test
	def void testMissingRole() {
		'''
			Status status1
			Status status2
			Transition trans named "1to2" { status1 to status2 }
			Workflow workflow { trans }
			StringField field1 as "String" {}
			IssueType iType follows workflow { field1 }
			Person john called "Johnny" { }
			IssueScreen issueScreen {StatusField statusField { default status1 } SummaryField sum {} }
		'''.parse.assertError(Literals.MODEL_ISSUE, MISSING_RULE)
	}
	
	@Test
	def void testMissingPerson() {
		'''
			Status status1
			Status status2
			Transition trans named "1to2" { status1 to status2 }
			Workflow workflow { trans }
			StringField field1 as "String" {}
			IssueType iType follows workflow { field1 }
			Role role1 { create Issue }
			IssueScreen issueScreen {StatusField statusField { default status1 } SummaryField sum {} }
		'''.parse.assertError(Literals.MODEL_ISSUE, MISSING_RULE)
	}
	
	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
//Valid Document	
///////////////////////////////////////////////////////////////////////////////////////////////////////	
	@Test
	def void testOK() {
		'''
			IssueScreen issueScreen {StatusField statusField { default status1 } SummaryField sum {} }
			Status status1
			IssueType iType follows workflow { field1 }
			Transition trans named "1to2" { status1 to status2 }
			Workflow workflow { trans }
			StringField field1 as "String" {}
			Status status2
			Person john called "Johnny" { role1 }
			Role role1 { create Issue }
		'''.parse.assertNoErrors
	}
	
	def void testOK2() {
		'''
			Status status1
			Status status2
			Transition trans1 named "1to2" { status1 to status2 }
			Transition trans2 named "1to2" { status1 to status2 }
			Workflow workflow1 { trans }
			Workflow workflow2 { trans }
			IssueScreen issueScreen {StatusField statusField { default status1 } SummaryField sum {} }
			StringField field1 as "String" {}
			IssueType iType follows workflow { field1 }
			IssueType iType2 follows workflow { field1 }
			Person john called "Johnny" { role1 }
			Person john2 called "Johnny" { role1 }
			Role role1 { create Issue }
		'''.parse.assertNoErrors
	}
}