#!c:\perl\bin\perl.exe
##
##  file2 -- CGI program that performs file management tasks
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

#      if ($allow_html != 1) {
#         $value =~ s/<([^>]|\n)*>//g;
#      }
#      else {
#         unless ($name eq 'body' || $name eq 'source') {
#         $value =~ s/<([^>]|\n)*>//g;
#         }
#      }
	  
	  if ($name ne "source") {
         $value =~ s/<([^>]|\n)*>//g;	  
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

   my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

   my($year) = $year%100;

   if ($sec < 10) {
      $sec = "0$sec";
   }
   if ($min < 10) {
      $min = "0$min";
   }
   if ($hour < 10) {
      $hour = "0$hour";
   }
   if ($mon < 10) {
      $mon = "0$mon";
   }
   if ($year < 10) {
      $year = "0$year";
   }
   if ($mday < 10) {
      $mday = "0$mday";
   }

   $month = ($mon + 1);

   $date = "$hour\:$min\:$sec $month/$mday/$year";

   chop($date) if ($date =~ /\n$/);


   	open(BAS, "base.txt") || &error;
    	while (<BAS>)
    	{
		chop();
		($basedir, $info) = split(/\|/);	
    	}    
    	close(BAS);
		
	open(UPW, "pswd2.cgi") || &error;		
		
	while (<UPW>)
    {
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
	print "<meta http-equiv=\"refresh\" content=\"0; URL=main2.cgi\">\n";
	print "<a href=\"main2.cgi\">You must logon from BatchSubmit.com main page</a>\n";
   } 
   else
   {

	print "<html><head><title>BatchSubmit.com (Beta)</title>\n";
	
#	print "<style type=\"text/css\">\n";
#	print "body,td,input {\n";
#	print "font-family: Courier;\n";
#	print "FONT-SIZE: 12px;\n";
#	print "}\n";

#	print "H1 {\n";
#	print "font-family: Verdana, Arial, Helvetica, sans-serif, \"Trebuchet MS\";\n";
#	print "FONT-SIZE: 32px;\n";
#	print "}\n";
#	print "H2 {\n";
#	print "font-family: Verdana, Arial, Helvetica, sans-serif, \"Trebuchet MS\";\n";
#	print "FONT-SIZE: 20px;\n";
#	print "}\n";
#	print "H3 {\n";
#	print "font-family: Verdana, Arial, Helvetica, sans-serif, \"Trebuchet MS\";\n";
#	print "FONT-SIZE: 16px;\n";
#	print "}\n";

#	print "</style>\n";
	
	print "<STYLE type=text/css>H2 {FONT-SIZE: 16px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TH {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TD {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "LI {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "INPUT {FONT-SIZE: 14px}\n";
	print "</STYLE>\n";	
	
	print "<body bgColor=#eaf9ff><center>\n";

      print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
      print "  <tr><td bgcolor=white align=center background=\"image/cloud.jpg\"><br><br>\n";
      print "  <h1>BatchSubmit.com (Beta)</h1>\n";
      print "  <h2>Cloud Computing for SAS, R and Python Scripts</h2><br></td></tr>\n";
      print "</table><br>\n";

      print "<Table cellSpacing=0 cellPadding=0 width=100% border=0>\n";
      print "  <tr>\n";
      print "     <td valign=top width=200 bgcolor=#dbe6e0>\n";
      print "       <FORM method=POST ACTION=\"main2.cgi\">\n";
      print "       <TABLE cellSpacing=0 cellPadding=4 width=200 border=0>\n";

      print "           <TR bgColor=#99bcd8><TD colspan=2 align=left><font color=\"white\"><b>USER</b></font></TD></TR>\n";
      print "           <TR><TD colspan=2 align=left><img src=\"image/user.png\" border=0> User: $usrid</TD></TR>\n";
      print "           <TR><TD colspan=2 align=center><INPUT TYPE=\"submit\" name=\"action\" value=\"Logout\"></TD></TR>\n";
      print "           <tr><td colspan=2 height=8 bgcolor=EAF9FF></td></tr>\n";

      print "           <TR bgColor=#99bcd8><TD colspan=2 align=left><font color=\"white\"><b>MENU</b></font></TD></TR>\n";
      print "           <TR><TD align=left><a href=\"main2.cgi?curdir=\"><img src=\"image/landmark.png\" border=0> Main</a></TD>\n"; 
	  print "           <TD align=left><a href=\"main2.cgi?curdir=/Users/$usrid\"><img src=\"image/home.png\" border=0> Home</a></TD></TR>\n";	  	  
	  print "           <TR><TD align=left><a href=\"task2.cgi\"><img src=\"image/task.png\" border=0> Task</a></TD>\n";
      print "           <TD align=left><a href=\"YaBB_2.5.2/cgi-bin/yabb2/YaBB.pl?board=rfp\"><img src=\"image/auction.png\" border=0> RFP</a></TD></TR>\n";	
      print "           <TR><TD align=left><a href=\"YaBB_2.5.2/cgi-bin/yabb2/YaBB.pl\"><img src=\"image/bulletin_board.png\" border=0> Board</a></TD>\n";		  
      print "           <TD align=left><a href=\"YaBB_2.5.2/cgi-bin/yabb2/YaBB.pl?action=search\"><img src=\"image/Find.png\" border=0> Search</a></TD></TR>\n";  
      print "           <TR><TD align=left><a href=\"m.main2.cgi?curdir=\"><img src=\"image/iphone.png\" border=0> Mobile</a></TD>\n";	  		  
      print "           <TD align=left><a href=\"help2.cgi\"><img src=\"image/help_book.png\" border=0> Help</a></TD></TR>\n";	   	  

      print "           <tr><td colspan=2 height=8 bgcolor=EAF9FF></td></tr>\n";

      print "           <TR bgColor=#99bcd8><TD colspan=2 align=left><font color=\"white\"><b>INFO</b></font></TD></TR>\n";
      print "           <TR><TD colspan=2><br></TD></TR>\n";

      print "       </TABLE>\n";
      print "       </FORM>\n";
      print "     </td>\n";
      print "     <td width=8><br></td>\n";
      print "     <TD valign=top bgColor=#dbe6e0>\n";
      print "       <TABLE cellSpacing=0 cellPadding=4 width=100% border=0>\n";

	$_ = $FORM{"curdir"};
	s/\//\/<wbr>/g;
	
	if ($FORM{"action"} eq "newfile" || $FORM{"action"} eq "newnote" || $FORM{"action"} eq "newfolder") {
		print "       <tr bgColor=#99bcd8><td colspan=2><font color=\"white\">/Main$_</font></td></tr>\n";
	}
	elsif ($FORM{"action"} eq "delfolder") {
		print "       <tr bgColor=#99bcd8><td colspan=2><font color=\"white\">/Main$_</font></td></tr>\n";
	}	
	else {
		print "       <tr bgColor=#99bcd8><td colspan=2><font color=\"white\">/Main$_/<wbr>$FORM{\"task\"}</font></td></tr>\n";
	}
    
#	print "       <tr><td align=left><a href=\"javascript:history.go(-1)\"><img src=\"image/GreenBack.png\" border=0></a></td><td><br></td></tr>\n";

	my($curdir) = $FORM{"curdir"};
	my($taskdir) = "Main$curdir";
	
    $task = $FORM{"task"};
	$action = $FORM{"action"};	

	if ($task eq "new" && $action eq "upfile") {
		print "<tr><td colspan=2><form method=POST action=\"upld2.cgi\" enctype=\"multipart/form-data\">\n";
		print "<input type=\"hidden\" name=\"curdir\" value=\"$curdir\">\n";
		print "<input type=\"hidden\" name=\"task\" value=\"$task\">\n";			
	}
	else
	{
		print "<tr><td colspan=2><form method=POST action=\"actn2.cgi\">\n";	
		print "<input type=\"hidden\" name=\"curdir\" value=\"$curdir\">\n";
		print "<input type=\"hidden\" name=\"task\" value=\"$task\">\n";	
		print "<input type=\"hidden\" name=\"action\" value=\"$action\">\n";			
	}

	
	print "<br>\n";
	
	if ($action eq "savepar") { 
		  
	    $saveas = $FORM{"saveas"};
								 
	  	if ($saveas =~ /\.par$/) {
	  
			$source = $FORM{"source"};
				
			$source =~ s/\r//g;			
	
			open(SAS, ">$taskdir/$saveas") || die $!;
				print SAS $source || die $!;
			close(SAS);
		
			print "<tr><td><b>The file has been saved</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";
			print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
			print "</tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";	
		}	
		else {
     		print "<tr><td><b>Invalid file name, please try again</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
			print "<tr>\n";
			print "</tr>\n";
		}	
	}
	elsif ($action eq "savefileattr") { 
		  
	    $saveas = $FORM{"saveas"};
				  
			$source = $FORM{"source"};
				
			$source =~ s/\r//g;			
	
			open(SAS, ">$taskdir/\.attr\.$saveas") || die $!;
				print SAS $source || die $!;
			close(SAS);
		
			print "<tr><td><b>The file has been saved</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";
			print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
			print "</tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";	
	
	}
	elsif ($action eq "savefolderattr") { 
		  
	    $saveas = $FORM{"saveas"};
				  
			$source = $FORM{"source"};
				
			$source =~ s/\r//g;			
	
			open(SAS, ">$taskdir/\.sharefolder") || die $!;
				print SAS $source || die $!;
			close(SAS);
		
			print "<tr><td><b>The file has been saved</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";
			print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
			print "</tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";	
	
	}	
	elsif ($action eq "savefeedback") { 
		  
	    $saveas = $FORM{"saveas"};
		
	  	if ($saveas =~ /\.msg$/) {
	  
			$source = $FORM{"source"};				
			$append = $FORM{"append"};			
				
			$source =~ s/\r//g;		
			$append =~ s/\r//g;					
	
			open(SAS, ">>$taskdir/$saveas") || die $!;
				print SAS "\nat $date, $usrid says:\n\n";
				print SAS $append || die $!;
				print SAS "\n\n============================================================\n";
			close(SAS);
		
			print "<tr><td><b>The feedback has been added</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";
			print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
			print "</tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";	
		}	
		else {
     		print "<tr><td><b>Something went wrong, please try again</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
			print "<tr>\n";
			print "</tr>\n";
		}	
	}	
	elsif ($action eq "save") { 
	
		$saveas = $FORM{"saveas"};
		
		$saveas =~ s/ /_/g;	
				
		my ($ext) = $task =~ /(\.[^.]+)$/;
		
		if ($saveas =~ /$ext$/i) {
	  
			$source = $FORM{"source"};
				
			$source =~ s/\r//g;			
	
			open(SAS, ">$taskdir/$saveas") || die $!;
				print SAS $source || die $!;
			close(SAS);
					
			print "<tr><td><b>The file has been saved</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";
			print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
			print "</tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";	
		}	
		else {
     		print "<tr><td><b>File type must be same as original, please try again</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
			print "<tr>\n";
			print "</tr>\n";
		}	
		
	}	
	elsif ($action eq "delfile") { 
	  print "Do you really want to delete file \"<font color=red size=+1><b>$task</b></font>\"?\n";
	  print "<p><input type=\"submit\" name=\"action\" value=\"delfile\" size=\"\"><BR>\n";
	}
	elsif ($action eq "delfolder") { 
	
		@curdir1 = split(/\//, $curdir);
		$thisfolder = pop(@curdir1);
	
		print "Do you really want to delete folder \"<font color=red size=+1><b>$thisfolder</b></font>\"?\n";
		print "<p><input type=\"submit\" name=\"action\" value=\"delfolder\" size=\"\"><BR>\n";
	}
	elsif ($action eq "copyfile") { 
			print "Please enter name:\n";	
			print "<INPUT TYPE=\"TEXT\" NAME=\"copyname\" VALUE=\"\" SIZE=30><BR>\n";
			print "<p><input type=\"submit\" name=\"action\" value=\"copyfile\" size=\"\"><BR>\n";
	}	
	elsif ($action eq "renamefile") { 
			print "Please enter name:\n";	
			print "<INPUT TYPE=\"TEXT\" NAME=\"targetname\" VALUE=\"\" SIZE=30><BR>\n";
			print "<p><input type=\"submit\" name=\"action\" value=\"renamefile\" size=\"\"><BR>\n";
	}		
	elsif ($action eq "movefile") { 
			print "Please enter target folder:\n";	
			print "<INPUT TYPE=\"TEXT\" NAME=\"targetfolder\" VALUE=\"\" SIZE=30><BR>\n";
			print "<p><input type=\"submit\" name=\"action\" value=\"movefile\" size=\"\"><BR>\n";
	}	
	elsif ($task eq "new") {
		if ($action eq "newfile") { 
			print "Please enter new file name:\n";
			print "<INPUT TYPE=\"TEXT\" NAME=\"newfilename\" VALUE=\"\" SIZE=30><BR>\n";
			print "<p><input type=\"submit\" name=\"action\" value=\"newfile\" size=\"\"><BR>\n";
		}
		elsif ($action eq "newnote") { 
			print "Please enter new note name:\n";
			print "<INPUT TYPE=\"TEXT\" NAME=\"newnotename\" VALUE=\"note.msg\" SIZE=30><BR>\n";
			print "<p><input type=\"submit\" name=\"action\" value=\"newnote\" size=\"\"><BR>\n";
		}
		elsif ($action eq "newfolder") { 
			print "Please enter new folder name:\n";
			print "<INPUT TYPE=\"TEXT\" NAME=\"newfoldername\" VALUE=\"\" SIZE=30><BR>\n";			
			print "<p><input type=\"submit\" name=\"action\" value=\"newfolder\" size=\"\"><BR>\n";
		}
		elsif ($action eq "upfile") { 
			print "Please choose file to upload:\n";
			print "<INPUT TYPE=\"FILE\" NAME=\"upfile\" VALUE=\"\" SIZE=30><BR>\n";			
			print "<p><input type=\"submit\" name=\"action\" value=\"upfile\" size=\"\"><BR>\n";
		}		
	}	

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




