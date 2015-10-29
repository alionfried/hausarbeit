/*
 */
package de.nordakademie.ticket.validation

import de.nordakademie.ticket.ticket.Date
import de.nordakademie.ticket.ticket.IssueScreen
import de.nordakademie.ticket.ticket.IssueType
import de.nordakademie.ticket.ticket.ModelIssue
import de.nordakademie.ticket.ticket.Person
import de.nordakademie.ticket.ticket.Role
import de.nordakademie.ticket.ticket.Transition
import java.util.ArrayList
import java.util.List
import org.eclipse.xtext.validation.Check

import static de.nordakademie.ticket.ticket.TicketPackage.Literals.*
import de.nordakademie.ticket.ticket.Field
import de.nordakademie.ticket.ticket.Workflow
import de.nordakademie.ticket.ticket.ComboField

//import de.nordakademie.ticket.ticket.Date

//import de.nordakademie.ticket.ticket.ComboField

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class TicketValidator extends AbstractTicketValidator {

	public static val INVALID_WORKFLOW_TRANSITIONS = "de.nordakademie.ticket.InvalidWorkflowTransitions" ;
	
	@Check
	def checkAllRulesAreCreated (ModelIssue modelIssue) {
		if (modelIssue.issueType.empty ) {
			error('At least 1 IssueType is needed', MODEL_ISSUE__ISSUE_TYPE)
		}
		
		if (modelIssue.person.empty ) {
			error('At least 1 Person is needed', MODEL_ISSUE__PERSON)
		}		 
		 
		if (modelIssue.role.empty ) {
			error('At least 1 Role is needed', MODEL_ISSUE__ROLE)
		} 
		 
		if (modelIssue.status.empty ) {
			error('At least 1 Status is needed', MODEL_ISSUE__STATUS)
		}   
		
		if (modelIssue.transition.empty ) {
			error('At least 1 Transition is needed', MODEL_ISSUE__TRANSITION)
		}   
		
		if (modelIssue.workflow.empty ) {
			error('At least 1 Workflow is needed', MODEL_ISSUE__WORKFLOW)
		} 
		
	}

	@Check
	def checkTransitionHasDifferentStatus (Transition transition) {
		if (transition.start == transition.ziel){
			error('Begin-Status and End-Status must be different', TRANSITION__ZIEL)
		}
	}

	@Check
	def checkTransitionTitleIsEmpty (Transition transition) {
		if (transition.title.empty){
			error('Title must not be empty', TRANSITION__TITLE)
		}
	}
	
	@Check
	def checkWorkflowHasDifferentTransitions (Workflow workflow){
		if (checkListForDublicates(workflow.transitions)){
			error('Workflow must have different Transitions', 
				WORKFLOW__TRANSITIONS, 
				INVALID_WORKFLOW_TRANSITIONS
			)
		}
	}
	
	@Check
	def checkPersonHasDifferentRoles (Person person){
		if (checkListForDublicates(person.roles)){
			error('A Person must have different Roles', PERSON__ROLES)
		}
	}
	
	@Check
	def checkRoleHasDifferentTransitions (Role role){
		if (checkListForDublicates(role.transitions)){
			error('Role must have different Transition', ROLE__TRANSITIONS)
		}
	}
	
	@Check
	def checkRoleContainsTransition (Role role) {
		if (role.transitions.empty && !role.openIssue){
			error('Role must contain at least one Transition', ROLE__NAME)
		}
	}
	
	@Check
	def checkPersonNameIsEmpty (Person person) {
		if (person.shownName.empty){
			error('Name must not be empty', PERSON__SHOWN_NAME)
		}
	}
	
	@Check
	def checkDate(Date date) {
//	Switch-Case funktioniert nicht wie gewünscht mit Mehrfachauswahl
			
		if (date.month == 1 || date.month == 3 || date.month == 5 || date.month == 7 || date.month == 8
			|| date.month == 10 || date.month == 12) {
				if (date.day < 1 || date.day > 31){
					error('Enter correct Day', DATE__DAY)
				}
		} else if (date.month == 4 || date.month == 6 || date.month == 9 || date.month == 11) {
				if (date.day < 1 || date.day > 30){
					error('Enter correct Day', DATE__DAY)
				}
		} else if (date.month == 2) {
				if (date.year % 4 == 0 && ( (date.year % 100 != 0) || (date.year % 400 == 0) ) ){
					if (date.day < 1 || date.day > 29){
						error('Enter correct Day', DATE__DAY)
					}
				} else if (date.day < 1 || date.day > 28){
					error('Enter correct Day', DATE__DAY)
				}
		} else {
				error('Enter correct Month', DATE__MONTH)
		} 
		
		if (! ((date.year > 1900 && date.year < 2100) || (date.year == 9999) || (date.year > 0 && date.year < 100)) ){
				error('Enter correct Year', DATE__YEAR)
		}
		
	}
	
	@Check
	def checkIssueTypeHasDifferentFields (IssueType issueType){
		if (this.checkListForDublicates(issueType.fields)){
			error('IssueType must have different Fields', ISSUE_TYPE__FIELDS)
		}
	}
	
	@Check
	def checkIssueScreenHasDifferentFields (IssueScreen issueScreen){
		if (this.checkListForDublicates(issueScreen.fields)){
			error('IssueScreen must have different Fields', ISSUE_SCREEN__FIELDS)
		}
	}
	
	@Check
	def checkFieldDescriptionIsEmpty (Field field){
		if (field.description.empty){
			error('Description must not be empty', FIELD__DESCRIPTION)
		}
	}
	
	@Check
	def checkComboFieldList (ComboField combo){
		if (this.checkListForDublicates(combo.^default)){
			error('ComboField must have different Entries', COMBO_FIELD__DEFAULT)
		}
		
		for (String string : combo.^default){
			if (string.empty){
				error('Entries must not be empty', COMBO_FIELD__DEFAULT)
			}
		}
	}
	
	List<Object> checkList = new ArrayList<Object>
	def boolean checkListForDublicates (List<?> list){
		checkList.clear 
		for (Object field : list) {
			if (checkList.contains(field)){
				return true
			} else {
				checkList.add(field)
			}
		}
		return false
	}
}
