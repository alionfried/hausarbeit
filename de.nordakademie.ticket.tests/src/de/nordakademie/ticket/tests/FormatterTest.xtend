package de.nordakademie.ticket.tests

import static extension org.junit.Assert.*
import org.eclipse.xtext.junit4.XtextRunner
import de.nordakademie.ticket.TicketInjectorProvider
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.InjectWith
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import de.nordakademie.ticket.ticket.ModelIssue
import org.eclipse.xtext.formatting.INodeModelFormatter
import org.junit.Test
import org.eclipse.xtext.resource.XtextResource

@RunWith(XtextRunner)
@InjectWith(TicketInjectorProvider)
class FormatterTest {
	@Inject extension ParseHelper<ModelIssue> 
	@Inject extension INodeModelFormatter
	
	
	def void assertFormattedAs (CharSequence input, CharSequence expected) {
		expected.toString.assertEquals(
			(input.parse.eResource as XtextResource).parseResult.rootNode.format(0, input.length).formattedText
		)
	}
	
	@Test
	def void testModelIssue() {
		'''
			IssueScreen issueScreen { StatusField statusField { default offen }
						SummaryField beschreibung {	}
			createDate beginnDatum assignee }
		'''.assertFormattedAs(
'''IssueScreen issueScreen {
	StatusField statusField {
		default offen
	}
	SummaryField beschreibung {
	}
	createDate beginnDatum assignee
}''')
	}
}

