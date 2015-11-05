/*
 */
package de.nordakademie.ticket.validation

import de.nordakademie.ticket.ticket.ComboField
import de.nordakademie.ticket.ticket.Date
import de.nordakademie.ticket.ticket.Field
import de.nordakademie.ticket.ticket.IssueScreen
import de.nordakademie.ticket.ticket.IssueType
import de.nordakademie.ticket.ticket.ModelIssue
import de.nordakademie.ticket.ticket.Person
import de.nordakademie.ticket.ticket.Role
import de.nordakademie.ticket.ticket.Transition
import de.nordakademie.ticket.ticket.Workflow
import java.util.ArrayList
import java.util.List
import org.eclipse.xtext.validation.Check

import static de.nordakademie.ticket.ticket.TicketPackage.Literals.*
import de.nordakademie.ticket.constantsAndNames.Constants
import de.nordakademie.ticket.constantsAndNames.Names_EN
import de.nordakademie.ticket.ticket.Status
import org.eclipse.emf.ecore.EObject

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class TicketValidator extends AbstractTicketValidator implements Constants 
	,Names_EN 
//	,Names_DE
{

	
	
	
	@Check
	def checkAllRulesCreated (ModelIssue modelIssue) {
		switch (true){
		case modelIssue.issueType.empty: 
			error(M_RULE_NEEDED_1 + S_ISSUE_TYPE + M_RULE_NEEDED_2,
				MODEL_ISSUE__ISSUE_SCREEN,
				MISSING_RULE,
				ISSUE_TYPE)
		case modelIssue.person.empty:
			error(M_RULE_NEEDED_1 + S_PERSON + M_RULE_NEEDED_2,
				MODEL_ISSUE__ISSUE_SCREEN,
				MISSING_RULE,
				PERSON)
		case modelIssue.role.empty:
			error(M_RULE_NEEDED_1 + S_ROLE + M_RULE_NEEDED_2,
				MODEL_ISSUE__ISSUE_SCREEN,
				MISSING_RULE,
				ROLE)
		case modelIssue.status.empty:
			error(M_RULE_NEEDED_1 + S_STATUS + M_RULE_NEEDED_2,
				MODEL_ISSUE__ISSUE_SCREEN,
				MISSING_RULE,
				STATUS)
		case modelIssue.transition.empty:
			error(M_RULE_NEEDED_1 + S_TRANSITION + M_RULE_NEEDED_2,
				MODEL_ISSUE__ISSUE_SCREEN,
				MISSING_RULE,
				TRANSITION)
		case modelIssue.workflow.empty:
			error(M_RULE_NEEDED_1 + S_WORKFLOW + M_RULE_NEEDED_2,
				MODEL_ISSUE__ISSUE_SCREEN,
				MISSING_RULE,
				WORKFLOW)
		}
	}
	
	
//	@Check
//	def checkStatusAlreadyExists (Status status){
//		val container = status.eContainer
//		if (container instanceof ModelIssue){
//			var list = (container as ModelIssue).status
//		}
//		
//		
////		)
//		var List<String> names = new ArrayList<String>
//		for (rule : modelIssue.status){
//			if (names.contains(rule.name)){
//				error(S_STATUS + M_SAME_NAME,
//					STATUS__NAME,
//					DUPLICATED_RULE_NAME,
//					STATUS
//				)
//			} else {
//				names.add(rule.name)
//			}
//		}
//		names.clear
//		for (rule : modelIssue.issueType){
//			if (names.contains(rule.name)){
//				error(S_ISSUE_TYPE + M_SAME_NAME,
//					ISSUE_TYPE__NAME,
//					DUPLICATED_RULE_NAME,
//					ISSUE_TYPE
//				)
//			} else {
//				names.add(rule.name)
//			}
//		}
//		names.clear
//		for (rule : modelIssue.person){
//			if (names.contains(rule.name)){
//				error(S_PERSON + M_SAME_NAME,
//					PERSON__NAME,
//					DUPLICATED_RULE_NAME,
//					PERSON
//				)
//			} else {
//				names.add(rule.name)
//			}
//		}
//		names.clear
//		for (rule : modelIssue.fields){
//			if (names.contains(rule.name)){
//				error(S_FIELD + M_SAME_NAME,
//					FIELD__NAME,
//					DUPLICATED_RULE_NAME,
//					FIELD
//				)
//			} else {
//				names.add(rule.name)
//			}
//		}
//		names.clear
//		for (rule : modelIssue.role){
//			if (names.contains(rule.name)){
//				error(S_ROLE + M_SAME_NAME,
//					ROLE__NAME,
//					DUPLICATED_RULE_NAME,
//					ROLE
//				)
//			} else {
//				names.add(rule.name)
//			}
//		}
//		names.clear
//		for (rule : modelIssue.transition){
//			if (names.contains(rule.name)){
//				error(S_TRANSITION + M_SAME_NAME,
//					TRANSITION__NAME,
//					DUPLICATED_RULE_NAME,
//					TRANSITION
//				)
//			} else {
//				names.add(rule.name)
//			}
//		}
//		names.clear
//		for (rule : modelIssue.workflow){
//			if (names.contains(rule.name)){
//				error(S_WORKFLOW + M_SAME_NAME,
//					WORKFLOW__NAME,
//					DUPLICATED_RULE_NAME,
//					WORKFLOW
//				)
//			} else {
//				names.add(rule.name)
//			}
//		}
//	}

	@Check
	def checkTransitionHasSameStatus (Transition transition) {
		if (transition.start == transition.ziel){
			error(M_SAME_BEGIN_AND_END_STATUS, 
				TRANSITION__ZIEL,
				DUPLICATED_TRANSITION_STATUS,
				transition.name
			)
		}
	}

	@Check
	def checkTransitionTitleIsEmpty (Transition transition) {
		if (transition.title.empty){
			error(M_EMPTY_TITLE, 
				TRANSITION__TITLE,
				EMPTY_STRING,
				TITLE, S_TITLE, S_TO + transition.ziel.name.toFirstUpper
			)
		}
	}
	
	@Check
	def checkWorkflowHasDuplicatedTransitions (Workflow workflow){
		if (this.listHasDuplicates(workflow.transitions)){
			error(M_SAME_WORKFLOW_TRANSITIONS, 
				WORKFLOW__TRANSITIONS, 
				ELEMENT_CONTAINS_LIST_WITH_DUPLICATES,
				workflow.name, S_TRANSITIONS
			)
		}
	}
	
	
	@Check
	def checkRoleContainsNoTransition (Role role) {
		if (role.transitions.empty && !role.openIssue){
			error(M_NO_ROLE_TRANSITIONS, 
				ROLE__NAME,
				EMPTY_ROLE,
				role.name
			)
		}
	}
	
	@Check
	def checkRoleHasDuplicatedTransitions (Role role){
		if (this.listHasDuplicates(role.transitions)){
			error(M_SAME_ROLE_TRANSITIONS, 
				ROLE__TRANSITIONS,
				ELEMENT_CONTAINS_LIST_WITH_DUPLICATES,
				role.name, S_TRANSITIONS
			)
		}
	}
	
	@Check
	def checkPersonHasDuplicatedRoles (Person person){
		if (this.listHasDuplicates(person.roles)){
			error(M_SAME_PERSON_ROLES, 
				PERSON__ROLES,
				ELEMENT_CONTAINS_LIST_WITH_DUPLICATES,
				person.name, S_ROLES
			)
		}
	}
	
	@Check
	def checkPersonNameIsEmpty (Person person) {
		if (person.shownName.empty){
			error(M_EMPTY_NAME, 
				PERSON__SHOWN_NAME,
				EMPTY_STRING,
				PERSON, S_PERSON, person.name.toFirstUpper
			)
		}
	}
	
	@Check
	def checkDate(Date date) {
//	Switch-Case funktioniert nicht wie gewünscht mit Mehrfachauswahl
		var name = KEY_EMPTY
		
		if (date.eContainer instanceof Field){
			name = (date.eContainer as Field).name
		}
		
		if (date.month == 1 || date.month == 3 || date.month == 5 || date.month == 7 || date.month == 8
			|| date.month == 10 || date.month == 12) {
				if (date.day < 1 || date.day > 31){
					error(M_INVALIDE_DAY, 
						DATE__DAY,
						INVALID_DAY,
						name
					)
				}
		} else if (date.month == 4 || date.month == 6 || date.month == 9 || date.month == 11) {
				if (date.day < 1 || date.day > 30){
					error(M_INVALIDE_DAY, 
						DATE__DAY,
						INVALID_DAY,
						name
					)
				}
		} else if (date.month == 2) {
				if (date.year % 4 == 0 && ( (date.year % 100 != 0) || (date.year % 400 == 0) ) ){
					if (date.day < 1 || date.day > 29){
						error(M_INVALIDE_DAY, 
							DATE__DAY,
							INVALID_DAY,
							name
						)
					}
				} else if (date.day < 1 || date.day > 28){
					error(M_INVALIDE_DAY, 
						DATE__DAY,
						INVALID_DAY,
						name
					)
				}
		} else {
				error(M_INVALIDE_MONTH, 
					DATE__MONTH,
					INVALID_MONTH,
					name
				)
		} 
		
		if (! ((date.year >= 1900 && date.year < 2100) || (date.year == 9999) || (date.year >= 0 && date.year < 100)) ){
				error(M_INVALIDE_YEAR, 
					DATE__YEAR,
					INVALID_YEAR,
					name
				)
		}
		
	}
	
	@Check
	def checkIssueTypeHasDuplicatedFields (IssueType issueType){
		if (this.listHasDuplicates(issueType.fields)){
			error(M_SAME_ISSUE_TYPE_FIELDS, 
				ISSUE_TYPE__FIELDS,
				ELEMENT_CONTAINS_LIST_WITH_DUPLICATES,
				issueType.name, S_FIELDS
			)
		}
	}
	
	@Check
	def checkIssueScreenHasDublicatedFields (IssueScreen issueScreen){
		if (this.listHasDuplicates(issueScreen.fields)){
			error(M_SAME_ISSUE_SCREEN_FIELDS, 
				ISSUE_SCREEN__FIELDS,
				ELEMENT_CONTAINS_LIST_WITH_DUPLICATES,
				issueScreen.name, S_FIELDS
			)
		}
	}
	
	@Check
	def checkFieldDescriptionIsEmpty (Field field){
		if (field.description.empty){
			error(M_EMPTY_DESCRIPTION, 
				FIELD__DESCRIPTION,
				EMPTY_STRING,
				DESCRIPTION, S_DESCRIPTION, field.name.toFirstUpper
			)
		}
	}
	
	@Check
	def checkComboFieldList (ComboField combo){
		if (this.listHasDuplicates(combo.^default)){
			error(M_SAME_COMBO_ENTRIES, 
				COMBO_FIELD__DEFAULT,
				ELEMENT_CONTAINS_LIST_WITH_DUPLICATES,
				combo.name, S_ENTRIES
			)
		}
		
		for (String string : combo.^default){
			if (string.empty){
				error(M_EMPTY_ENTRIES, 
					COMBO_FIELD__DEFAULT,
					EMPTY_STRING,
					ENTRY, S_ALL_ENTRIES, S_ENTRY
				)
			}
		}
	}
	
	def boolean listHasDuplicates (List<?> list){
		var List<Object> checkList = new ArrayList<Object>
		
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
