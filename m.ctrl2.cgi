#!c:\perl\bin\perl.exe
##
##  ctrl2 -- CGI program that display the front end for SAS program
##

###########################################################################
# Get Form Information
&parse_form;

# Read Main Page
&main_page;

#######################
# Parse Form Subroutine

sub parse_form {

   $req=$ENV{'REQUEST_METHOD'};

   # Get the input

   if ($ENV{'REQUEST_METHOD'} eq "GET")
   {
        $buffer = $ENV{'QUERY_STRING'};
   }
   else
   {
	read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
   }

   # Split the name-value pairs
   @pairs = split(/&/, $buffer);

   foreach $pair (@pairs) {
      ($name, $value) = split(/=/, $pair);

      # Un-Webify plus signs and %-encoding
      $value =~ tr/+/ /;
      $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
      $value =~ s/<!--(.|\n)*-->//g;

      if ($allow_html != 1) {
         $value =~ s/<([^>]|\n)*>//g;
      }
      else {
         unless ($name eq 'body') {
         $value =~ s/<([^>]|\n)*>//g;
         }
      }

      $FORM{$name} = $value;
   }
}

#######################
# Handle Error

sub error {
   print "error...\n";
}

###############################
# Main Page Subroutine

sub main_page {

   	open(BAS, "base.txt") || &error;
    while (<BAS>)
    {
		chop();
		($basedir, $info) = split(/\|/);	
    }    
    close(BAS);
		
	open(UPW, "pswd2.cgi") || &error;
    	
	while (<UPW>) {
	
		chop();
		my($usrnamef, $usrpwdf, $usrtypef, $usremailf, $usrpathf) = split(/:/);	
#		$usrpwdf{$usrnamef} = crypt($usrpwdf, substr($usrnamef,0,2));
		$usrpwdf{$usrnamef} = $usrpwdf;			
		$usrtypef{$usrnamef} = $usrtypef;
		$usremailf{$usrnamef} = $usremailf;
		$usrpathf{$usrnamef} = $usrpathf;

    }    
	
    close(UPW);	

	print "Content-type: text/html; charset=iso-8859-1\n\n";

      	$usrid = $ENV{'HTTP_COOKIE'};
      	$usrid =~ /usrid=([^;]*)/;
      	$usrid = $1;
		
      	$usremail = $ENV{'HTTP_COOKIE'};
      	$usremail =~ /usremail=([^;]*)/;
      	$usremail = $1;
		
      	$usrkey = $ENV{'HTTP_COOKIE'};
      	$usrkey =~ /usrkey=([^;]*)/;
      	$usrkey = $1;			

#   if ($usrid eq "" or $usrpwdf{$usrid} ne $usrkey) 
   if ($usrid eq "" or $usrpwdf{$usrid} ne crypt($usrkey, substr($usrid,0,2)))      
   {
	print "<meta http-equiv=\"refresh\" content=\"0; URL=m.main2.cgi\">\n";
	print "<a href=\"m.main2.cgi\">You must logon from BatchSubmit main page</a>\n";

   } 
   else
   {

	print "<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.0//EN\" \"http://www.wapforum.org/DTD/xhtml-mobile10.dtd\">\n";
	print "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>BatchSubmit.com (Beta)</title>\n";

	print "<STYLE type=text/css>\n";
#	print "H2 {FONT-SIZE: 18px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
#	print "H3 {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";	

	print "body,td,input {\n";
	print "font-family: Courier;\n";
	print "FONT-SIZE: 12px;\n";
	print "}\n";

	print "H1 {\n";
	print "font-family: Verdana, Arial, Helvetica, sans-serif, \"Trebuchet MS\";\n";
	print "FONT-SIZE: 32px;\n";
	print "}\n";
	print "H2 {\n";
	print "font-family: Verdana, Arial, Helvetica, sans-serif, \"Trebuchet MS\";\n";
	print "FONT-SIZE: 18px;\n";
	print "}\n";
	print "H3 {\n";
	print "font-family: Verdana, Arial, Helvetica, sans-serif, \"Trebuchet MS\";\n";
	print "FONT-SIZE: 12px;\n";
	print "}\n";

	print "</style>\n";
	
    print "</head>\n";
	  
	print "<body bgColor=#eaf9ff><center>\n";

      print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
      print "  <tr><td bgcolor=white align=center background=\"image/cloud.jpg\"><h2>BatchSubmit.com (Beta)</h2>\n";	  
      print "  <h3>Cloud Computing for SAS, R and Python Scripts</h3></td></tr>\n";
      print "</table><br>\n";

      print "<Table cellSpacing=0 cellPadding=0 width=100% border=0>\n";
      print "  <tr>\n";
      print "     <td valign=top width=100% bgcolor=#dbe6e0>\n";
      print "       <FORM method=POST ACTION=\"m.main2.cgi\">\n";
      print "       <TABLE cellSpacing=0 cellPadding=4 width=100% border=0>\n";

      print "           <TR bgColor=#99bcd8><TD colspan=5 align=left><font color=\"white\"><b>USER</b></font></TD></TR>\n";
      print "           <TR><TD colspan=5 align=left><img src=\"image/user.png\" border=0> User: $usrid \n";
      print "           <INPUT TYPE=\"submit\" name=\"action\" value=\"Logout\"></TD></TR>\n";
      print "           <tr><td colspan=5 height=8 bgcolor=EAF9FF></td></tr>\n";

      print "           <TR bgColor=#99bcd8><TD colspan=5 align=left><font color=\"white\"><b>MENU</b></font></TD></TR>\n";
      print "           <TR><TD align=left><a href=\"m.main2.cgi?curdir=\"><img src=\"image/landmark.png\" border=0> Main</a></TD>\n";
	  print "           <TD align=left><a href=\"m.main2.cgi?curdir=/Users/$usrid\"><img src=\"image/home.png\" border=0> Home</a></TD>\n";	  	  
      print "           <TD align=left><a href=\"m.task2.cgi\"><img src=\"image/task.png\" border=0> Task</a></TD>\n";
      print "           <TD align=center><a href=\"m.help2.cgi\"><img src=\"image/help_book.png\" border=0> Help</a></TD>\n";
      print "           <TD align=center><a href=\"main2.cgi?curdir=\"><img src=\"image/desktop.png\" border=0> PC</a></TD></TR>\n";	 	  

      print "           <tr><td colspan=5 height=8 bgcolor=EAF9FF></td></tr>\n";

#      print "           <TR bgColor=#99bcd8><TD align=left><font color=\"white\"><b>INFO</b></font></TD></TR>\n";
#      print "           <TR><TD>$info</TD></TR>\n";

      print "       </TABLE>\n";
      print "       </FORM>\n";
      print "     </td>\n";
      print "     </tr>\n";	  	  
#      print "     <td width=8><br></td>\n";
      print "     <tr>\n";	 
      print "     <TD valign=top width=100% bgColor=#dbe6e0>\n";
      print "       <TABLE cellSpacing=0 cellPadding=4 width=100% border=0>\n";
#      print "       <tr bgColor=#99bcd8><td width=600><font color=\"white\"><b>Execute SAS Task: $FORM{\"task\"}</b></font></td></tr>\n";

	$_ = $FORM{"curdir"};
	s/\//\/<wbr>/g;
	
		$curdirl = "Main$FORM{\"curdir\"}";
	
		my(@usrpathfi1c) = split(/,/, $usrpathf{$usrid});	
	
		my($usrpathfifg2) = 0;		
		
		foreach $usrpathfi2 (@usrpathfi1c)
		{	
			next if (!($curdirl =~ $usrpathfi2 && $usrpathfi2 ne ""));
				
			$usrpathfifg2 = 1;
			last;
		}		

      print "       <tr align=left bgColor=#99bcd8><td width=100% colspan=2><font color=\"white\">/Main$_/<wbr>$FORM{\"task\"}</font></td></tr>\n";

      print "       <tr><td align=left><a href=\"javascript:history.go(-1)\"><img src=\"image/GreenBack.png\" border=0></a></td><td align=right>\n";
      print "		<a href=\"javascript:history.go(0)\"><img src=\"image/arrow_undo.png\" border=0></a> \n";

	  if (($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) && ($usrpathfifg2 == 1)){	  	  
#	  if ($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) {			  
		print "	  	<a href=\"m.view2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=editfile\"><img src=\"image/gtk_edit.png\" border=0></a> \n";	  
		print "		<a href=\"m.view2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=sharefile\"><img src=\"image/page_gear.png\" border=0></a> \n"; 
		print "		<a href=\"m.file2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=copyfile\"><img src=\"image/copy.png\" title=\"copy\" border=0></a> \n"; 						
		print "		<a href=\"m.file2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=renamefile\"><img src=\"image/rename.png\" title=\"rename\" border=0></a> \n"; 		
		print "		<a href=\"m.file2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=movefile\"><img src=\"image/move.gif\" title=\"move\" border=0></a> \n"; 							
		print "	  	<a href=\"m.file2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=delfile\"><img src=\"image/trash.png\" border=0></a></td></tr>\n";
	  }
	  
	my($curdir) = $FORM{"curdir"};
	my($taskdir) = "Main/$curdir";

    $task = $FORM{"task"};

	print "<tr><td align=left colspan=2><form method=POST action=\"m.exec2.cgi\">\n";
	print "<input type=\"hidden\" name=\"curdir\" value=\"$curdir\">\n";
	print "<input type=\"hidden\" name=\"task\" value=\"$task\">\n";	
	
#	print "<br><h3>User Input:</h3>\n";
	print "<br>\n";

      open(TASK,"$taskdir/$task") || &error;

      foreach $line (<TASK>) {
		($wwwid, $wwwlabel, $wwwtype, $wwwname, $wwwvalue, $wwwsize, $wwwbreak) = split(/\|/, $line);

		if ($wwwtype eq "text") {
			print $wwwlabel;
 			print "<input type=\"$wwwtype\"";
	      	print " name=\"$wwwname\"";
 			print " value=\"$wwwvalue\"";
	      	print " size=\"$wwwsize\">";
	      	print " $wwwbreak\n";
		}
		elsif ($wwwtype eq "select") {
			print $wwwlabel;
 			print "<select";
	      	print " name=\"$wwwname\"";
	      	print " size=\"$wwwsize\">";

			@wwwoptions = split(/:/, $wwwvalue);

   			foreach $wwwoption (@wwwoptions) {
				if ($wwwoption =~ /#/) {
					$wwwoption =~ s/#//;
      				print "<option selected>$wwwoption";
				}
				else {
					print "<option>$wwwoption";
				}
			}

	      	print "</select>";
	      	print " $wwwbreak\n";

		}
		elsif ($wwwtype eq "radio") {
			print $wwwlabel;

			@wwwoptions = split(/:/, $wwwvalue);

   			foreach $wwwoption (@wwwoptions) {
				if ($wwwoption =~ /#/) {
					$wwwoption =~ s/#//;

 					print "<input type=\"radio\"";
	      			print " name=\"$wwwname\"";
      				print " value=\"$wwwoption\" CHECKED>";
					print "$wwwoption ";
				}
				else {
 					print "<input type=\"radio\"";
	      			print " name=\"$wwwname\"";
					print " value=\"$wwwoption\">";
					print "$wwwoption ";
				}
			}

	      	print " $wwwbreak\n";
		}
		elsif ($wwwtype eq "checkbox") {
			print $wwwlabel;

			if ($wwwvalue =~ /#/) {
				$wwwvalue =~ s/#//;

 				print "<input type=\"checkbox\"";
	      		print " name=\"$wwwname\"";
      			print " value=\"$wwwvalue\" CHECKED>";
			}
			else {
 				print "<input type=\"checkbox\"";
	      		print " name=\"$wwwname\"";
      			print " value=\"$wwwvalue\">";
			}
			
	      	print " $wwwbreak\n";
		}				
		elsif ($wwwtype ne "") {
			print $wwwlabel;
 			print "<input type=\"$wwwtype\"";
	      	print " name=\"$wwwname\"";
 			print " value=\"$wwwvalue\"";
	      	print " size=\"$wwwsize\">";
	      	print " $wwwbreak\n";
		}
      }
	  
	  print "<input type=\"submit\" name=\"action\" value=\"submit\" size=\"\">\n";
	  print "<input type=\"reset\" name=\"\" value=\"reset\" size=\"\"> <P>\n";
	  
		my($allowedit) = 0;	
			
		if ($usrtypef{$usrid} == 0) {
				$allowedit = 1;
		}
		elsif ("Main$curdir" =~ /Main\/Users\/$usrid/){
				$allowedit = 1;
		}
		elsif (-e "Main$curdir/\.attr\.$task") {
			
			open(SHA, "Main$curdir/\.attr\.$task") || die $!;
			
			foreach $ln (<SHA>) {
				
			$ln =~ s/^\s+|\s$//g;
					
			if (lc($ln) eq $usrid || lc($ln) eq "all") {						
				$allowedit = 1;
			}
			}
				
			close(SHA);	
		
		}
		else {
				$allowedit = 0;
		}
		
		if (($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) && ($usrpathfifg2 == 1 or $allowedit == 1)){				
			print "save as<font color=#dbe6e0></font>: <input type=\"text\" name=\"saveas\" value=\"$task\" size=\"20\">\n";
			print "<input type=\"submit\" name=\"action\" value=\"save\" size=\"\"><BR>\n";
		}
		
      close(TASK);

	print "</form>\n";

      print "</td></tr></table>\n";
	print "</table><br>\n";

	print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
      print "    <tr><td bgcolor=#dbe6e0 align=center><br>Open Source Code</td></tr>\n";
      print "    <tr><td bgcolor=#dbe6e0 align=center><br></td></tr>\n";
      print "</table>\n";
      print "</center>\n";

	print "</body></html>\n";
   }
}




