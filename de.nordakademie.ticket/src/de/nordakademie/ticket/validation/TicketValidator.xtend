/*
 * generated by Xtext
 */
package de.nordakademie.ticket.validation

import static de.nordakademie.ticket.ticket.TicketPackage.Literals.*
import de.nordakademie.ticket.ticket.Transition
import org.eclipse.xtext.validation.Check
import de.nordakademie.ticket.ticket.Workflow
import de.nordakademie.ticket.ticket.Role
import de.nordakademie.ticket.ticket.Issue

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
	
	@Check
	def checkIssueSummaryIsEmpty (Issue issue) {
		if (issue.summary.empty){
			error('Summary must not be empty', ISSUE__SUMMARY)
		}
	}

//  public static val INVALID_NAME = 'invalidName'
//
//	@Check
//	def checkGreetingStartsWithCapital(Greeting greeting) {
//		if (!Character.isUpperCase(greeting.name.charAt(0))) {
//			warning('Name should start with a capital', 
//					MyDslPackage.Literals.GREETING__NAME,
//					INVALID_NAME)
//		}
//	}
}
