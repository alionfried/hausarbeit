/*
 * generated by Xtext
 */
package de.nordakademie.ticket.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import de.nordakademie.ticket.ticket.ModelIssue
import de.nordakademie.ticket.ticket.IssueType

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class TicketGenerator implements IGenerator {
	
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
		                <button type="button" class="btn btn-primary">Create</button>				
		            </div>			
				</div>	    
			
				
		        <div id="secondDiv" class="container theme-showcase" role="main">
		            <button id="btnHide" type="button" class="btn btn-default">Hide</button>
		            <br />
		            <button id="btnShow" type="button" class="btn btn-default">Show</button>
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
	  ['optionCreateNewIssue', false, true, false,true]
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
	
	//$('#btnListCreateIssues').click(function(){
	//    var sReturn = this.value;    
	//    alert(sReturn);
	//});
	
	$(".selectpicker").change(function () {
	
	    var sReturn = this.options(this.selectedIndex).value;
	
	    alert(sReturn);
	
	});
	
	function selectedItem() {
	    var sReturn = this.options(this.selectedIndex).value;
	
	    alert(sReturn);
	
	}
	
	$("#btnHide").click(function () {    
	    einAusblendenDIV(3, 100);
	});
	
	$("#btnShow").click(function () {
	    einAusblendenDIV(4, 300);
	});
	
	$("#aShow").click(function () {
	    einAusblendenDIV(1, 1000);
	});
	
	$("#btnCreateNewIssue").click(function () {
	    einAusblendenDIV(2, 3000);
	});
	
	$(function () {
	    einAusblendenDIV(1,10);
	});
	'''
	
}

