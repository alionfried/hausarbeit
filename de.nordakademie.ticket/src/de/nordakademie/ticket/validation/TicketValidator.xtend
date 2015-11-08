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
import de.nordakademie.ticket.ticket.NameObject
import org.eclipse.emf.common.util.EList
import java.util.regex.Pattern
import de.nordakademie.ticket.ticket.MailField
import org.eclipse.xtext.nodemodel.util.NodeModelUtils

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
		val to = NodeModelUtils.getNode(modelIssue).endOffset
		val from = NodeModelUtils.getNode(modelIssue).text.lastIndexOf(KEY_NEW_LINE) + KEY_NEW_LINE.length
		switch (true){
		case modelIssue.issueType.empty: 
			acceptError(M_RULE_NEEDED_1 + S_ISSUE_TYPE + M_RULE_NEEDED_2,
				modelIssue, 
				from,
				to - from,
				MISSING_RULE,
				ISSUE_TYPE)
		case modelIssue.person.empty:
			acceptError(M_RULE_NEEDED_1 + S_PERSON + M_RULE_NEEDED_2,
				modelIssue, 
				from,
				to - from,
				MISSING_RULE,
				PERSON)
		case modelIssue.role.empty:
			acceptError(M_RULE_NEEDED_1 + S_ROLE + M_RULE_NEEDED_2,
				modelIssue, 
				from,
				to - from,
				MISSING_RULE,
				ROLE)
		case modelIssue.status.empty:
			acceptError(M_RULE_NEEDED_1 + S_STATUS + M_RULE_NEEDED_2,
				modelIssue, 
				from,
				to - from, 
				MISSING_RULE, 
				STATUS
			)
		case modelIssue.transition.empty:
			acceptError(M_RULE_NEEDED_1 + S_TRANSITION + M_RULE_NEEDED_2,
				modelIssue, 
				from,
				to - from,
				MISSING_RULE,
				TRANSITION)
		case modelIssue.workflow.empty:
			acceptError(M_RULE_NEEDED_1 + S_WORKFLOW + M_RULE_NEEDED_2,
				modelIssue, 
				from,
				to - from,
				MISSING_RULE,
				WORKFLOW)
		}
	}
	
	

	@Check
	def checkNameObjectAlreadyExists (NameObject object){
		var container = object.eContainer
		while (container != null && !(container instanceof ModelIssue)){
			container = container.eContainer
		}
		
		
		if (container instanceof ModelIssue) {
			switch (true){
			case object instanceof Status:
			 	if (this.listHasSameNamedElement((container as ModelIssue).status, object)){
					error(S_STATUS + M_SAME_NAME,
						NAME_OBJECT__NAME,
						DUPLICATED_RULE_NAME,
						STATUS, object.name
					)
				}
			case object instanceof Person:
			 	if (this.listHasSameNamedElement((container as ModelIssue).person, object)){
					error(S_PERSON + M_SAME_NAME,
						NAME_OBJECT__NAME,
						DUPLICATED_RULE_NAME,
						PERSON, object.name
					)
				} 
			case object instanceof Role:
			 	if (this.listHasSameNamedElement((container as ModelIssue).role, object)){
					error(S_ROLE + M_SAME_NAME,
						NAME_OBJECT__NAME,
						DUPLICATED_RULE_NAME,
						ROLE, object.name
					)
				} 
			case object instanceof Transition:
			 	if (this.listHasSameNamedElement((container as ModelIssue).transition, object)){
					error(S_TRANSITION + M_SAME_NAME,
						NAME_OBJECT__NAME,
						DUPLICATED_RULE_NAME,
						TRANSITION, object.name
					)
				} 
			case object instanceof IssueType:
			 	if (this.listHasSameNamedElement((container as ModelIssue).issueType, object)){
					error(S_ISSUE_TYPE + M_SAME_NAME,
						NAME_OBJECT__NAME,
						DUPLICATED_RULE_NAME,
						ISSUE_TYPE, object.name
					)
				} 
			case object instanceof Workflow:
			 	if (this.listHasSameNamedElement((container as ModelIssue).workflow, object)){
					error(S_WORKFLOW + M_SAME_NAME,
						NAME_OBJECT__NAME,
						DUPLICATED_RULE_NAME,
						WORKFLOW, object.name
					)
				} 
			case object instanceof Field:
			 	if (this.listHasSameNamedElement((container as ModelIssue).fields, object)){
					error(S_FIELD + M_SAME_NAME,
						NAME_OBJECT__NAME,
						DUPLICATED_RULE_NAME,
						FIELD, object.name
					)
				} 
			 
		 	}
		}
	}
	
	@Check
	def checkAlreadyExists (Status status){
		var container = status.eContainer
		while (container != null && !(container instanceof ModelIssue)){
			container = container.eContainer
		}
		
		if (container instanceof ModelIssue && this.listHasSameNamedElement((container as ModelIssue).status, status)){
			error(S_STATUS + M_SAME_NAME,
				NAME_OBJECT__NAME,
				DUPLICATED_RULE_NAME,
				STATUS, status.name
			)
		}
	}
		

	@Check
	def checkTransitionHasSameStatus (Transition transition) {
		if (transition.from == transition.to){
			error(M_SAME_BEGIN_AND_END_STATUS, 
				TRANSITION__FROM,
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
				TITLE, S_TITLE, S_TO + transition.to.name.toFirstUpper
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
				NAME_OBJECT__NAME,
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
					error(M_INVALID_DAY, 
						DATE__DAY,
						INVALID_DAY,
						name
					)
				}
		} else if (date.month == 4 || date.month == 6 || date.month == 9 || date.month == 11) {
				if (date.day < 1 || date.day > 30){
					error(M_INVALID_DAY, 
						DATE__DAY,
						INVALID_DAY,
						name
					)
				}
		} else if (date.month == 2) {
				if (date.year % 4 == 0 && ( (date.year % 100 != 0) || (date.year % 400 == 0) ) ){
					if (date.day < 1 || date.day > 29){
						error(M_INVALID_DAY, 
							DATE__DAY,
							INVALID_DAY,
							name
						)
					}
				} else if (date.day < 1 || date.day > 28){
					error(M_INVALID_DAY, 
						DATE__DAY,
						INVALID_DAY,
						name
					)
				}
		} else {
				error(M_INVALID_MONTH, 
					DATE__MONTH,
					INVALID_MONTH,
					name
				)
		} 
		
		if (! ((date.year >= 1900 && date.year < 2100) || (date.year == 9999) || (date.year >= 0 && date.year < 100)) ){
				error(M_INVALID_YEAR, 
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
	
	@Check
	def checkMailFieldMail (MailField mailField){
		val pattern = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
				+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
		if (! Pattern.matches(pattern, mailField.^default))	{
			error(M_INVALID_MAIL, 
				MAIL_FIELD__DEFAULT,
				INVALID_MAIL,
				mailField.^default
			)
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
	
	def boolean listHasSameNamedElement (EList<?> list, NameObject obj){
	var i = 0;
	for (entry : list){
		if (entry instanceof NameObject && (entry as NameObject).name == obj.name){
			i++
		}
	}
	
	if (i > 1){
		return true
	}
	return false
}
}
