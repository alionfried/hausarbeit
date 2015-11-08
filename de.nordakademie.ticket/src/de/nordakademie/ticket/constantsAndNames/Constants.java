package de.nordakademie.ticket.constantsAndNames;

public interface Constants {
//path
	public static String PATH = "de.nordakademie.ticket.";
	
//errors

	public static String DUPLICATED_RULE_NAME = PATH + "duplicatedRuleName";

	public static String DUPLICATED_TRANSITION_STATUS = PATH + "duplicatedTransitionStatus";
	public static String ELEMENT_CONTAINS_LIST_WITH_DUPLICATES = PATH + "elementContainsListWithDuplicates" ;
	public static String EMPTY_ROLE = PATH + "emptyRole" ;
	public static String EMPTY_STRING = PATH + "emptyString" ;
	public static String INVALID_DAY = PATH + "invalidDay";
	public static String INVALID_MAIL = PATH + "invalidMail";

	public static String INVALID_MONTH = PATH + "invalidMonth";
	public static String INVALID_YEAR = PATH + "invalidYear";
	public static String MISSING_RULE = PATH + "missingRule";
	
	public static String E_LINKING_DIAGNOSTIC_MESSAGE_1 = "Couldn't resolve reference to ";

	
//element-constants
	public static String DESCRIPTION = PATH + "description";
	public static String ENTRY = PATH + "entry";
	public static String FIELD = PATH + "field";
	public static String ISSUE_SCREEN = PATH + "issueScreen";
	public static String ISSUE_TYPE = PATH + "issueType";
	public static String NAME = PATH + "name";
	public static String PERSON = PATH + "person";
	public static String ROLE = PATH + "role";
	public static String STATUS = PATH + "status";
	public static String STATUS_FIELD = PATH + "statusField";
	public static String SUMMAY_FIELD = PATH + "summaryField";
	public static String TITLE = PATH + "title";
	public static String TRANSITION = PATH + "transition";
	public static String WORKFLOW = PATH + "workflow";
	
	
//keys
	public static String KEY_APOST = "'";
	public static String KEY_EMPTY = "";
	public static String KEY_MINUS = "-";
	public static String KEY_NEW_LINE = "\r\n";
	public static String KEY_POINT = ".";
	public static String KEY_SPACE = " ";
	public static String KEY_TAB = "\t";
	
//value constants	
	public static String C_MAIL_PATTERN = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
			+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
	public static int C_LAST_YEAR = 9999;
	
	
	
}
