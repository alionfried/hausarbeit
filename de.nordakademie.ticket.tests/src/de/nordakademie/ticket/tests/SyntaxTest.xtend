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
import org.eclipse.xtext.diagnostics.Diagnostic

@RunWith(XtextRunner)
@InjectWith(TicketInjectorProvider)
class SyntaxTest implements Constants{
	
	@Inject extension ParseHelper<ModelIssue> 
	@Inject extension ValidationTestHelper 
	
	
	@Test
	def void testEmptyCombo (){
		'''
			ComboField field as "Combo" {
				default {  }
			}
		'''.parse.assertError(Literals.COMBO_FIELD, Diagnostic.SYNTAX_DIAGNOSTIC)
	}
	
	@Test
	def void testEntriesNotCommaSeparated (){
		'''
			ComboField field as "Combo" {
				default { "Entry1" "Entry2" "Entry3" }
			}
		'''.parse.assertError(Literals.COMBO_FIELD, Diagnostic.SYNTAX_DIAGNOSTIC)
	}
	
	@Test
	def void testEndWithComma (){
		'''
			ComboField field as "Combo" {
				default { "Entry1", "Entry2", "Entry3", }
			}
		'''.parse.assertError(Literals.COMBO_FIELD, Diagnostic.SYNTAX_DIAGNOSTIC)
	}
	
	@Test
	def void testStringAsID (){
		'''
			ComboField field as Combo {}
		'''.parse.assertError(Literals.COMBO_FIELD, Diagnostic.SYNTAX_DIAGNOSTIC)
	}
	
	@Test
	def void testKeyWordAsString (){
		'''
			ComboField field "as" Combo {}
		'''.parse.assertError(Literals.COMBO_FIELD, Diagnostic.SYNTAX_DIAGNOSTIC)
	}
	
	@Test
	def void testComboOK (){
		'''
			ComboField field as "Combo" {
				default { "Entry1", "Entry2", "Entry3" }
			}
		'''.parse.assertNoErrors(Literals.COMBO_FIELD, Diagnostic.SYNTAX_DIAGNOSTIC)
	}
}