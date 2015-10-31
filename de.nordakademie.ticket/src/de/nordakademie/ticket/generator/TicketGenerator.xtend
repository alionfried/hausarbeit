/*
 * generated by Xtext
 */
package de.nordakademie.ticket.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import de.nordakademie.ticket.ticket.ModelIssue
import de.nordakademie.ticket.ticket.IssueType
import org.eclipse.emf.mwe.core.issues.Issues
import de.nordakademie.ticket.ticket.DateField
import java.util.Calendar
import de.nordakademie.ticket.ticket.PersonField
import de.nordakademie.ticket.ticket.StatusField
import de.nordakademie.ticket.ticket.MailField
import de.nordakademie.ticket.ticket.CheckField

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class TicketGenerator implements IGenerator {
	
	Calendar today
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
	fsa.generateFile(
			'issuetracker.html',
			//resource.URI.trimFileExtension.lastSegment + '.html',
			resource.contents.filter(ModelIssue).head.toHtml			
		)
	fsa.generateFile(
			'issuetracker.js',
			//resource.URI.trimFileExtension.lastSegment + '.js',
			resource.contents.filter(ModelIssue).head.tojs			
		)					
	fsa.generateFile(
			'standardInput.html',
			resource.contents.filter(ModelIssue).head.standardInput			
		)		
	fsa.generateFile(
			'individualInput.html',
			resource.contents.filter(ModelIssue).head.individualInput			
		)						
	}


	
	def CharSequence toHtml(ModelIssue modelIssue)'''
	<!DOCTYPE html>
		<html lang="en">
		  <head>	
		    <meta charset="utf-8">    
		    <meta name="viewport" content="width=device-width, initial-scale=1">
		    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
		    <title>Issue Tracker</title>
			<meta name="description" content="">
		    <meta name="author" content="">
		    <link rel="icon" href="../../favicon.ico">
			
		    <!-- Latest compiled and minified CSS -->
			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
		
			<!-- Optional theme -->
			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">
		
			<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
		    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
			
			<!-- Latest compiled and minified JavaScript -->
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>				    
		      
		  </head>			
			<body id="issueBody" role="document">
		        <header>
		            <nav class="navbar navbar-default">
		                <div class="container">
		                    <div class="navbar-header">
		                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
		                            <span class="sr-only">Toggle navigation</span>
		                            <span class="icon-bar"></span>
		                            <span class="icon-bar"></span>
		                            <span class="icon-bar"></span>
		                        </button>
		                        <a id="aShow" class="navbar-brand" href="#">Issue Tracker</a>
		                    </div>
		                    <div class="navbar-collapse collapse">
		                        <ul class="nav navbar-nav">
		                            <li><a id="btnCreateNewIssue" data-toggle="modal" data-target="#ChooseIssueType">Create New Issue</a></li>
		                            <li>
		                                <form class="navbar-form navbar-left" role="search">
		                                    <div class="form-group">
		                                        <input type="text" class="form-control" placeholder="Search">
		                                    </div>
		                                    <button type="submit" class="btn btn-default">Search Issues</button>
		                                </form>
		                            </li>
		                            <li class="dropdown">
		                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Assignee<span class="caret"></span></a>
		                                <ul class="dropdown-menu">
		                                	«FOR person : modelIssue.person»
		                                	<li><a>«person.name»</a></li>
		                                	«ENDFOR»		                                	
		                                </ul>
		                            </li>
		                        </ul>
		                        <ul class="nav navbar-nav navbar-right">
									<li><a id="navRigth">Singed in with Person:</a></li>                                                        
								</ul>
		                    </div><!--/.nav-collapse -->
		                </div>
		            </nav>
		        </header>
		
				<div id="mainDiv" class="container theme-showcase" role="main">			
					
				  <!-- Main jumbotron for a primary marketing message or call to action -->
					<div class="jumbotron">
						<h1>Issue Tracker Information</h1>
						<p>The issue tracker start page. You can see a ticket overview.</p>
					</div>				
		            <div id="issueOverview">
		                <div class="page-header">
		                    <h1>Issue Overview</h1>
		                </div>
		                <div class="alert alert-warning" role="alert">
		                    <strong id="strong">Warning! Has to create automaticlly.</strong>
		                </div>
		                <div class="col-md-6">
		                    <table class="table table-striped">
		                        <thead>
		                            <tr>
		                                <th>#</th>
		                                <th>Assignee</th>
		                                <th>Description</th>
		                            </tr>
		                        </thead>
		                        <tbody>
		                            <tr>
		                                <td>1</td>
		                                <td>Alfred Otto</td>
		                                <td>Problem with log in</td>
		                            </tr>
		                            <tr>
		                                <td>2</td>
		                                <td>Jacob Thom</td>
		                                <td>Problem with reomte control</td>
		                            </tr>
		                            <tr>
		                                <td>3</td>
		                                <td>Larry Greeds</td>
		                                <td>forgot password for sap</td>
		                            </tr>
		                        </tbody>
		                    </table>
		                </div>
		            </div>				
		            <div id="optionCreateNewIssue" class="modal-body">
		                Here you choose the Issuetype you want to create.<br />
		                <select id="btnListCreateIssues" class="selectpicker">
		                «FOR issueType : modelIssue.issueType»
		                	<option value="«issueType.name»">«issueType.name» </option>		                	
		                «ENDFOR»		                    
		                </select>		                				
		            </div>			
				</div>	    					
		        <div id="secondDiv" class="container theme-showcase" role="main">
		            <button id="btnCreateIssue" type="button" class="btn btn-primary">Create</button>
		        </div>
		            <script src="issuetracker.js"></script>
		</body>
	</html>
	
	
	'''
	
	def CharSequence tojs(ModelIssue modelIssue)'''
//Status für aDIV
// 1 := onLoad / Ready  (Seite fertig gealden / Button Issue...
// 2 := optionCreateNewIssue
// 3 := btnHide
// 4 := btnShow

var aDiv = [
  ['mainDiv'             , true, true, false,true],
  ['issueOverview'       , true, false, false,true],
  ['optionCreateNewIssue', false, true, false, false],
  ['secondDiv'           , false, true, false, false]
];

function einAusblendenDIV(nStatus, nTime) {
    for (var i = 0; i < aDiv.length; i++) {
        var tmpDiv = "#" + aDiv[i][0];
        if (aDiv[i][nStatus]) {
            $(tmpDiv).show(nTime);
        } else {
            $(tmpDiv).hide(nTime);
        }
    }
}

//Hier muss mit der Datenbank gearbeitet werden
function checkpermission(personname) {
    //String Name der Person erhalten und dann über Datenbank abfragen, ob die Aktion durchgeführt werden darf
    return true;
}

function changeNavRigth(namePerson) {    
    $("#navRigth").text("Signed in as: " + namePerson);    
}

//$('#btnListCreateIssues').click(function(){
//    var sReturn = this.value;    
//    alert(sReturn);
//});

$(".selectpicker").change(function () {

    var sReturn = this.options(this.selectedIndex).value;

    alert(sReturn);

});

function selectedItem() {
    //var sReturn = this.options(this.selectedIndex).value;
    var sReturn = $(".selectpicker").change(function () {

        var sReturn = this.options(this.selectedIndex).value;

        alert(sReturn);

    });

    alert(sReturn);

}

$("#aShow").click(function () {
    einAusblendenDIV(1, 1000);
});

$("#btnCreateNewIssue").click(function () {
    einAusblendenDIV(2, 3000);
});

$("#btnCreateIssue").click(function () {    
    getReturn = (checkpermission("alli"))
    var sReturn;        
        sReturn = $("#optionCreateNewIssue option");//$(this).options($(this).selectedIndex).value;        
        var length = sReturn.length;
        var selectedObject;
        var isSelected = false;
        var returnObjekt;
        var i = 0;
        while (isSelected == false && i < length) {
                if (sReturn[i].selected == true) {
                    isSelected = true;
                    returnObjekt = sReturn[i];
                }
                i++;            
        }
        selectedObject = returnObjekt.value;
        //alert(selectedObject);                

    if (getReturn == true) {
        alert("Input Option for Type: " + selectedObject);
    }
    else {
        alert("You don't have the permissons for this action.")
    }
    changeNavRigth(selectedObject);
})



$(function () {
    einAusblendenDIV(1,10);
});
'''
	
	def CharSequence standardInput(ModelIssue modelIssue)'''
	<form class="form-horizontal">
		<div id="standardInput">						
			<div class="form-group">
				<label for="«modelIssue.issueScreen.statusfield.name»" class="col-sm-2 control-label">«modelIssue.issueScreen.statusfield.name»</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" id="«modelIssue.issueScreen.statusfield.name»" value="«modelIssue.issueScreen.statusfield.^default.name»">
			    </div>
			</div>
			<div class="form-group">
				<label for="«modelIssue.issueScreen.summaryfield.name»" class="col-sm-2 control-label">«modelIssue.issueScreen.summaryfield.name»</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" id="«modelIssue.issueScreen.summaryfield.name»" value="«modelIssue.issueScreen.summaryfield.^default»">
			    </div>
			</div>
		
		«FOR fields :  modelIssue.issueScreen.fields»			
			«IF fields.eClass.instanceClassName.equals("de.nordakademie.ticket.ticket.MailField")»	
			  <div class="form-group">
			    <label for="«fields.name»" class="col-sm-2 control-label">«fields.description»</label>
			    <div class="col-sm-10">
			      <input type="email" class="form-control" id="«fields.name»" placeholder="«(fields as MailField).^default»">
			    </div>
			  </div>
		  	«ENDIF»  	
		  	«IF fields.eClass.instanceClassName.equals("de.nordakademie.ticket.ticket.DateField")»		
			  	«IF (fields as DateField).today == true»
		  			<div class="form-group">
			  			<label for="«(fields as DateField).description»" class="col-sm-2 control-label">Date</label>
			  			<div class="col-sm-10">
			  			«today = Calendar.getInstance()»
			  			«today.set(Calendar.HOUR_OF_DAY, 0)»			  			
		  					<input type="text" class="form-control" id="«(fields as DateField).name»" value="«today.toString»">
			 			</div>
		 			</div>	  		  			    
		 	 	«ENDIF»		
		  	«ENDIF»
		  	«IF fields.eClass.instanceClassName.equals("de.nordakademie.ticket.ticket.PersonField")»				  	
		  		<div class="form-group">
			  		<label for="«(fields as PersonField).description»" class="col-sm-2 control-label">Person</label>
			  		<div class="col-sm-10">
		  				<input type="text" class="form-control" id="«(fields as PersonField).name»" value="«(fields as PersonField).description»">
			 		</div>
		 		</div>
		  	«ENDIF»
		«ENDFOR»  	  
		  <div class="form-group">
		    <div class="col-sm-offset-2 col-sm-10">
		      <button id="submitStandard" type="submit" class="btn btn-default">Submit</button>
		    </div>
		  </div>
		</div> 
	</form>	
	'''
	
	def CharSequence individualInput(ModelIssue modelIssue)'''	
	<div>	
	«FOR issueType : modelIssue.issueType»
		<form>		
		<div id="«issueType.name»" class="form-group">
			<a>«issueType.name»</a>
			«FOR fields : modelIssue.fields»
				«IF fields.eClass.instanceClassName.equals("de.nordakademie.ticket.ticket.MailField")»
			    	<label for="«fields.name»" class="col-sm-2 control-label">«fields.description»</label>
			    	<div class="col-sm-10">
			      		<input type="email" class="form-control" id="«fields.name»" placeholder="«(fields as MailField).^default»">
			   		 </div>
			    «ENDIF»			    
			    «IF fields.eClass.instanceClassName.equals("de.nordakademie.ticket.ticket.CheckField")»
			    	«IF (fields as CheckField).^default.booleanValue == true»
			    		<label for="«fields.name»" class="col-sm-2 control-label">«fields.description»</label>
			    		<div class="col-sm-10">
			      			<input type="checkbox" id="«fields.name»" value="«(fields as CheckField).description»" checked>
			   			 </div>
			   		 «ELSE»
			   		 	<label for="«fields.name»" class="col-sm-2 control-label">«fields.description»</label>
			    		<div class="col-sm-10">
			      			<input type="checkbox" id="«fields.name»" value="«(fields as CheckField).description»">
			   			 </div>
			   		 «ENDIF»
			    «ENDIF»
			«ENDFOR»    
		</div>
		<div class="form-group">
		    <div class="col-sm-offset-2 col-sm-10">
		      <button type="submit" class="btn btn-default">Submit</button>
		    </div>
		</div>
		</form>
	«ENDFOR»
	</div>
	'''
}

