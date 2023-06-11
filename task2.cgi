#!c:\perl\bin\perl.exe
##
##  task2 -- CGI program that display tasks
##

###########################################################################
# Get Form Information
&parse_form;

# Read Main Page
&main_page;

# Handle Error
#&error;

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
   print "updating...\n";
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

	open(UPW, "pswd2.cgi") || &error;
    	while (<UPW>)
    	{
			chop();
			
			($usrnamef, $usrpwdf, $usrtypef, $usremailf, $usrpathf) = split(/:/);	
#			$usrpwdf{$usrnamef} = crypt($usrpwdf, substr($usrnamef,0,2));					
			$usrpwdf{$usrnamef} = $usrpwdf;
			$usrtypef{$usrnamef} = $usrtypef;
			$usremailf{$usrnamef} = $usremailf;
			$usrpathf{$usrnamef} = $usrpathf;
    	}    
    close(UPW);	

	print "<html><head><title>BatchSubmit.com (Beta)</title>\n";

	print "<STYLE type=text/css>H2 {FONT-SIZE: 16px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TH {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TD {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "LI {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TEXTAREA {WIDTH: 100%}\n";		
	print "INPUT {FONT-SIZE: 14px}\n";
	print "</STYLE>\n";
      print "</head>\n";

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

#      if ($usrid ne "") {
#	  if ($usrid ne "" && $usrpwdf{$usrid} eq $usrkey) {
	  if ($usrid ne "" && $usrpwdf{$usrid} eq crypt($usrkey, substr($usrid,0,2))) {		  
         print "           <TR><TD colspan=2 align=left><img src=\"image/user.png\" border=0> User: $usrid</TD></TR>\n";
         print "           <TR><TD colspan=2 align=center><INPUT TYPE=\"submit\" name=\"action\" value=\"Logout\"></TD></TR>\n";
      }
      else
      {	  
#         print "           <TR><TD align=left>User not logged in</TD></TR>\n";
		 print "<meta http-equiv=\"refresh\" content=\"0; URL=main2.cgi\">\n";
		 print "<a href=\"main2.cgi\">You must logon from BatchSubmit.com main page</a>\n";		 
      }

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
      print "       <tr bgColor=#99bcd8><td colspan=2><font color=white>Tasks</font></td></tr>\n";
      print "       <tr><td align=left><a href=\"javascript:history.go(-1)\"><img src=\"image/GreenBack.png\" border=0></a></td><td align=right><a href=\"javascript:history.go(0)\"><img src=\"image/refresh.gif\" border=0></a></td></tr>\n";
	  
	my($curdir) = $FORM{"curdir"};
	my($filename) = $FORM{"task"};

	print "<tr><td align=left colspan=2><br>\n";
	print "<form>\n";

	print "executing<br>\n";

	print "<textarea readonly rows=5 wrap=off>\n";

	if (-e "busy.xml") {
		open(FLE, "busy.xml") || &error;
			foreach $line (<FLE>)
			{
				my($taskcount, $user, $caller, $path, $cmnd) = split(/:/,$line);
				if ($usrid eq $user or $usrid eq "admin") {print "running: $user:/$path> $cmnd";}
			}
		close(FLE);	
	}

	if (-e "task.xml") {
		open(FLE, "task.xml") || &error;
			foreach $line (<FLE>)
			{
				my($taskcount, $user, $caller, $path, $cmnd) = split(/:/,$line);
				if ($usrid eq $user or $usrid eq "admin") {print "pending: $user:/$path> $cmnd"};
			}
		close(FLE);	
	}

	print "</textarea>\n";
	print "<br>\n";
	print "completed<br>\n";

	print "<textarea readonly rows=25 wrap=off>\n";

	open(FLE, "hist.xml") || &error;
	
	@lines = (<FLE>);

	close(FLE);

	@linesr = reverse(@lines);

	foreach $line (@linesr)
	{
		if ((($usrid ne "") and ($line =~ /^\d\d\-\d\d-\d\d \d\d:\d\d:\d\d $usrid:/)) or $usrid eq "admin") {print "$line"};
	}

	print "</textarea>\n";
	print "</form>\n";

	print "</td></tr>\n";

      print "       </table>\n";
      print "     </td>\n";
      print "  </tr>\n";
      print "</Table><br>\n";

      print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
      print "    <tr><td bgcolor=#dbe6e0 align=center><br>All Rights Reserved</td></tr>\n";
      print "    <tr><td bgcolor=#dbe6e0 align=center><br></td></tr>\n";
      print "</table>\n";
      print "</center>\n";

	print "</body></html>\n";
}



