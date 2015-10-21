/*
 */
package de.nordakademie.ticket.validation

import static de.nordakademie.ticket.ticket.TicketPackage.Literals.*
import de.nordakademie.ticket.ticket.Transition
import org.eclipse.xtext.validation.Check
import de.nordakademie.ticket.ticket.Workflow
import de.nordakademie.ticket.ticket.Role
//import de.nordakademie.ticket.ticket.Date
//import de.nordakademie.ticket.ticket.ComboField

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class TicketValidator extends AbstractTicketValidator {

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
	def checkWorkflowContainsTransition (Workflow workflow) {
		if (workflow.transitions.empty){
			error('Workflow must contain at least one Transition', WORKFLOW__NAME)
		}
	}
	
	@Check
	def checkRoleContainsTransition (Role role) {
		if (role.transitions.empty){
			error('Role must contain at least one Transition', ROLE__NAME)
		}
	}
	
//	@Check 
//	def checkComboFieldEntriesFilled (ComboField combo) {
//		if (combo.entries.empty) {
//			error('Entries must not be empty', FIELD__NAME)
//		}
//	} 
//
//	@Check
//	def checkDate(Date date) {
////	Switch-Case funktioniert nicht wie gewünscht mit Mehrfachauswahl
//			
//		if (date.month == 1 || date.month == 3 || date.month == 5 || date.month == 7 || date.month == 8
//			|| date.month == 10 || date.month == 12) {
//				if (date.day < 1 || date.day > 31){
//					error('Enter correct Day', DATE__DAY)
//				}
//		} else if (date.month == 4 || date.month == 6 || date.month == 9 || date.month == 11) {
//				if (date.day < 1 || date.day > 30){
//					error('Enter correct Day', DATE__DAY)
//				}
//		} else if (date.month == 2) {
//				if (date.year % 4 == 0 && ( (date.year % 100 != 0) || (date.year % 400 == 0) ) ){
//					if (date.day < 1 || date.day > 29){
//						error('Enter correct Day', DATE__DAY)
//					}
//				} else if (date.day < 1 || date.day > 28){
//					error('Enter correct Day', DATE__DAY)
//				}
//		} else {
//				error('Enter correct Month', DATE__MONTH)
//		} 
//		
//		if (! ((date.year > 1900 && date.year < 2100 ) || (date.year > 0 && date.year < 100)) ){
//				error('Enter correct Year', DATE__YEAR)
//		}
//		
//	}
}
