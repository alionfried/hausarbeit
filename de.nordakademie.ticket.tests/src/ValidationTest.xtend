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
	
//Transition Validations
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
			Transition myTransition named "" { same to different }
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
	
	
//Workflow Validations	
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
	
	
//Role Validations	
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
	
	
//Person Validation	
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
	
	
//Date Validation
//Day-Validation
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
	
	
//IssueType Validation
	@Test
	def void testIssueTypeSameFieldsValidation() {
		'''
			Workflow workflow { }
			StringField field1 as "String"
			IssueType follows workflow { field1 field1 }
		'''.parse.assertNoErrors(Literals.ISSUE_TYPE, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
	@Test
	def void testIssueTypeSameFieldsValidationOK() {
		'''
			Workflow workflow { }
			StringField field1 as "String"
			IssueType follows workflow { field1 }
		'''.parse.assertNoErrors(Literals.ISSUE_TYPE, ELEMENT_CONTAINS_LIST_WITH_DUPLICATES)
	}
	
}