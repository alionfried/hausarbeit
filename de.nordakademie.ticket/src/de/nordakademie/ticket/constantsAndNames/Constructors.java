package de.nordakademie.ticket.constantsAndNames;

public interface Constructors extends Constants{
//Variables
	public static String V_ISSUE_TYPE__WORKFLOW = "<ISSUE_TYPE__WORKFLOW>";
	public static String V_PERSON__SHWON_NAME = "<PERSON__SHWON_NAME>";
	public static String V_RULE__NAME = "<RULE__NAME>";
	public static String V_STATUS_FIELD__NAME = "<STATUS_FIELD__NAME>";
	public static String V_SUMMARY_FIELD__NAME = "<SUMMARY_FIELD__NAME>";
	public static String V_TRANSITION__END = "<TRANSITION__END>";
	public static String V_TRANSITION__START = "<TRANSITION__START>";
	public static String V_TRANSITION__TITLE = "<TRANSITION__TITLE>";
	public static String V_WORKFLOW__TRANSITIONS = "<WORKFLOW__TRANSITIONS>";
	
	
//single used constructors
	public static String NEW_ISSUE_SCRREN = 
			"IssueScreen " + V_RULE__NAME + " {" + KEY_NEW_LINE + 
			KEY_TAB + "StatusField " + V_STATUS_FIELD__NAME + " {" + KEY_NEW_LINE + KEY_TAB + KEY_NEW_LINE + "}" + KEY_NEW_LINE +
			KEY_TAB + "SummaryField " + V_SUMMARY_FIELD__NAME + " {" + KEY_NEW_LINE + KEY_TAB + KEY_NEW_LINE + "}" + KEY_NEW_LINE + "}";
	public static String NEW_ISSUE_TYPE = 
			"IssueType " + V_RULE__NAME + " follows " + V_ISSUE_TYPE__WORKFLOW + " {" + KEY_NEW_LINE + KEY_TAB + KEY_NEW_LINE + "}";
	
	public static String NEW_PERSON = 
			"Person " + V_RULE__NAME + " called \"" + V_PERSON__SHWON_NAME + "\" {" + KEY_NEW_LINE + KEY_TAB + KEY_NEW_LINE + "}";
	
	public static String NEW_ROLE = 
			"Role " + V_RULE__NAME + " {" + KEY_NEW_LINE +
			KEY_TAB + "create Issue" + KEY_NEW_LINE + "}";
			
	public static String NEW_STATUS = 
			"Status " + V_RULE__NAME;
	
	public static String NEW_TRANSITION = 
			"Transition " + V_RULE__NAME + " named \"" + V_TRANSITION__TITLE + "\" {" + KEY_NEW_LINE + 
			KEY_TAB + V_TRANSITION__START + " to " + V_TRANSITION__END + KEY_NEW_LINE + "}"; 
	
	public static String NEW_WORKFLOW = 
			"Workflow " + V_RULE__NAME + " {" + KEY_NEW_LINE + 
			KEY_TAB + V_WORKFLOW__TRANSITIONS + KEY_NEW_LINE + "}"; 
	
}

