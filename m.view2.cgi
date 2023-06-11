#!c:\perl\bin\perl.exe
##
##  view2 -- CGI program that display the content of log or output files
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
#         unless ($name eq 'body') {
#         $value =~ s/<([^>]|\n)*>//g;
#         }
#      }
	  
	  if ($name ne "source") {
         $value =~ s/<([^>]|\n)*>//g;	  
	  }	  

      $FORM{$name} = $value;
   }
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
	print "<meta http-equiv=\"refresh\" content=\"0; URL=m.main2.cgi\">\n";
	print "<a href=\"m.main2.cgi\">You must logon from BatchSubmit.com main page</a>\n";
   } 
   else
   {
	print "<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.0//EN\" \"http://www.wapforum.org/DTD/xhtml-mobile10.dtd\">\n";
	print "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>BatchSubmit.com (Beta)</title>\n";

	print "<STYLE type=text/css>\n";
	print "H2 {FONT-SIZE: 18px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "H3 {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";	
	print "TH {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TD {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "LI {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TEXTAREA {WIDTH: 98%}\n";		
	print "INPUT {FONT-SIZE: 14px}\n";
	print "</STYLE>\n";
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
      print "           <TD align=center><a href=\"m.main2.cgi?curdir=\"><img src=\"image/landmark.png\" border=0> Main</a></TD>\n";
	  print "           <TD align=center><a href=\"m.main2.cgi?curdir=/Users/$usrid\"><img src=\"image/home.png\" border=0> Home</a></TD>\n";	  	  
      print "           <TD align=center><a href=\"m.task2.cgi\"><img src=\"image/task.png\" border=0> Task</a></TD>\n";
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

      print "       <tr bgColor=#99bcd8><td style='width:100%;text-wrap:hard-wrap ' colspan=2><font color=\"white\">/Main$_/<wbr>$FORM{\"task\"}</font></td></tr>\n";
	  print "       <tr><td align=left><a href=\"javascript:history.go(-1)\"><img src=\"image/GreenBack.png\" border=0></a></td><td align=right>\n";

	  if (($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) && ($usrpathfifg2 == 1)){
			print "		<a href=\"javascript:history.go(0)\"><img src=\"image/arrow_undo.png\" border=0></a> \n";
	  		print "	  	<a href=\"m.view2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=editfile\"><img src=\"image/gtk_edit.png\" border=0></a> \n";	  
			print "		<a href=\"m.view2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=sharefile\"><img src=\"image/page_gear.png\" border=0></a> \n"; 
			print "		<a href=\"m.file2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=copyfile\"><img src=\"image/copy.png\" title=\"copy\" border=0></a> \n"; 						
			print "		<a href=\"m.file2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=renamefile\"><img src=\"image/rename.png\" title=\"rename\" border=0></a> \n"; 		
			print "		<a href=\"m.file2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=movefile\"><img src=\"image/move.gif\" title=\"move\" border=0></a> \n"; 							
			print "		<a href=\"m.file2.cgi?curdir=$FORM{\"curdir\"}&task=$FORM{\"task\"}&action=delfile\"><img src=\"image/trash.png\" border=0></a>\n";
	  }

	  print "     </td></tr>\n";

	my($curdir) = $FORM{"curdir"};
	my($filename) = $FORM{"task"};
	my($action) = $FORM{"action"};	
	
	if ($action eq "sharefile") {
			
		if (!(-e "Main$curdir/\.attr\.$filename")) {
			open(SHA, ">Main$curdir/\.attr\.$filename") || die $!;
			close SHA;
		}
	
	  	open(FLE, "Main$curdir/\.attr\.$filename") || die $!;
		
		print "<tr><td align=left colspan=2>\n";
		print "<form method=POST action=\"m.file2.cgi\">\n";	
		
		print "<input type=\"hidden\" name=\"curdir\" value=\"$curdir\">\n";
		print "<input type=\"hidden\" name=\"program\" value=\"/Main$curdir/$filename\">\n";
		print "<input type=\"hidden\" name=\"task\" value=\"$filename\">\n";
			
		print "add or remove users allowed to edit the file, one line per user.<br>\n";		
		
		if ($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) {		
			print "<textarea name=\"source\" rows=5 cols=10 wrap=off>\n";
		}
		else {
			print "<textarea readonly name=\"source\" rows=5 cols=10 wrap=off>\n";		
		}
		
		foreach $line (<FLE>)
		{
			print "$line";
		}

		print "</textarea><br>\n";
		
		if ($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) {
			print "<input type=\"hidden\" name=\"saveas\" value=\"$filename\" width=\"100%\">\n";
			print "<input type=\"submit\" name=\"action\" value=\"savefileattr\" size=\"\"><BR>\n";
		}	
		
		print "</form>\n";

		print "</td></tr>\n";

		close(FLE);

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
	elsif ($action eq "sharefolder") {
			
		if (!(-e "Main$curdir/\.sharefolder")) {
			open(SHA, ">Main$curdir/\.sharefolder") || die $!;
			close SHA;
		}
	
	  	open(FLE, "Main$curdir/\.sharefolder") || die $!;
		
		print "<tr><td align=left colspan=2>\n";
		print "<form method=POST action=\"m.file2.cgi\">\n";	
		
		print "<input type=\"hidden\" name=\"curdir\" value=\"$curdir\">\n";
		print "<input type=\"hidden\" name=\"program\" value=\"/Main$curdir/sharefolder\">\n";
		print "<input type=\"hidden\" name=\"task\" value=\"sharefolder\">\n";
			
		print "add or remove users allowed to view this folder, one line per user.<br>\n";		
		
		if ($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) {		
			print "<textarea name=\"source\" rows=5 cols=10 wrap=off>\n";
		}
		else {
			print "<textarea readonly name=\"source\" rows=5 cols=10 wrap=off>\n";		
		}
		
		foreach $line (<FLE>)
		{
			print "$line";
		}

		print "</textarea><br>\n";
		
		if ($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) {
#			print "save as<font color=#dbe6e0></font>: <input type=\"text\" name=\"saveas\" value=\"sharefolder\" size=\"40\">\n";
			print "<input type=\"submit\" name=\"action\" value=\"savefolderattr\" size=\"\"><BR>\n";
		}	
		
		print "</form>\n";

		print "</td></tr>\n";

		close(FLE);

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
	else {	
#	  if (($filename =~ /\.htm$/i || $filename =~ /\.html$/i || $filename =~ /\.php$/i) && $action ne "editfile") {
	  if (($filename =~ /\.htm$/i || $filename =~ /\.html$/i) && $action ne "editfile") {	
		print "<tr bgcolor=eedad1><tr><td colspan=4 align=center><iframe width=100% scrolling=\"auto\" frameborder=\"0\" src=\"http://batchsubmit.com/casper2/Main$curdir/$filename\"></iframe></td></tr>\n";

		print "       </table>\n";
		print "</Table><br>\n";

		print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
		print "    <tr><td bgcolor=#dbe6e0 align=center><br>All Rights Reserved</td></tr>\n";
		print "    <tr><td bgcolor=#dbe6e0 align=center><br></td></tr>\n";
		print "</table>\n";
		print "</center>\n";
	  }
	  elsif ($filename =~ /\.pdf$/i) {
	
		print "<tr bgcolor=eedad1><tr><td colspan=4 align=center><iframe width=100% scrolling=\"auto\" frameborder=\"0\" src=\"http://batchsubmit.com/casper2/Main$curdir/$filename\"></iframe></td></tr>\n";

		print "       </table>\n";
		print "</Table><br>\n";

		print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
		print "    <tr><td bgcolor=#dbe6e0 align=center><br>All Rights Reserved</td></tr>\n";
		print "    <tr><td bgcolor=#dbe6e0 align=center><br></td></tr>\n";
		print "</table>\n";
		print "</center>\n";
	  }	  
	  elsif ($filename =~ /\.jpg$/i || $filename =~ /\.jpeg$/i || $filename =~ /\.png$/i || $filename =~ /\.gif$/i) {
	
		print "<tr bgcolor=eedad1><tr><td colspan=4 align=center><img src=\"http://batchsubmit.com/casper2/Main$curdir/$filename\"></td></tr>\n";

		print "       </table>\n";
		print "</Table><br>\n";

		print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
		print "    <tr><td bgcolor=#dbe6e0 align=center><br>All Rights Reserved</td></tr>\n";
		print "    <tr><td bgcolor=#dbe6e0 align=center><br></td></tr>\n";
		print "</table>\n";
		print "</center>\n";
	  }	
	  elsif ($filename =~ /\.par$/) {
	
	  open(FLE, "Main$curdir/$filename") || die $!;
		
		print "<tr><td align=left colspan=2>\n";
		print "<form method=POST action=\"m.file2.cgi\">\n";
		print "<input type=\"hidden\" name=\"curdir\" value=\"$curdir\">\n";
		print "<input type=\"hidden\" name=\"program\" value=\"/Main$curdir/$filename\">\n";
		print "<input type=\"hidden\" name=\"task\" value=\"$filename\">\n";

		print "<a href=\"Main$curdir/$filename\"><br>$filename</a><br>\n";

		print "<textarea name=\"source\" rows=20 cols=68 wrap=off>\n";
		
		foreach $line (<FLE>)
		{
			print "$line";
		}

		print "</textarea><p>\n";
		
		if ($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) {
			print "save as<font color=#dbe6e0></font>: <input type=\"text\" name=\"saveas\" value=\"$filename\" width=\"100%\">\n";
			print "<input type=\"submit\" name=\"action\" value=\"savepar\" size=\"\"><BR>\n";
		}	
	
		print "</form>\n";

		print "</td></tr>\n";

		close(FLE);

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
	  elsif($filename =~ /\.sas$/i || $filename =~ /\.r$/i || $filename =~ /\.py$/i) {
	
	  open(FLE, "Main$curdir/$filename") || die $!;
		
		if ($filename =~ /\.sas$/i || $filename =~ /\.r$/i || $filename =~ /\.py$/i) {
			print "<tr><td align=left colspan=2>\n";
			print "<form method=POST action=\"m.exec2.cgi\">\n";
			print "<input type=\"hidden\" name=\"curdir\" value=\"$curdir\">\n";
			print "<input type=\"hidden\" name=\"program\" value=\"/Main$curdir/$filename\">\n";
			print "<input type=\"hidden\" name=\"task\" value=\"$filename\">\n";
		}
		else {
			print "<tr><td align=left colspan=2>\n";
			print "<form>\n";			
		}
		
		print "<a href=\"Main$curdir/$filename\"><br>$filename</a><br>\n";
		
			my($allowedit) = 0;	
			
			if ($usrtypef{$usrid} == 0) {
				$allowedit = 1;
			}
			elsif ("Main$curdir" =~ /Main\/Users\/$usrid/){
				$allowedit = 1;
			}
			elsif (-e "Main$curdir/\.attr\.$filename") {
			
				open(SHA, "Main$curdir/\.attr\.$filename") || die $!;
						
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

		if ($filename =~ /\.sas$/i || $filename =~ /\.r$/i || $filename =~ /\.py$/i) {		
			if (($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) && ($usrpathfifg2 == 1 or $allowedit == 1)){
#			if (($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) && ($allowedit == 1)){			
				print "<textarea name=\"source\" rows=20 cols=68 wrap=off>\n";
			}
			else {
				print "<textarea readonly name=\"source\" rows=20 cols=68 wrap=off>\n";			
			}
		}
		else {
			if ($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) {		
				print "<textarea rows=20 cols=68 wrap=off>\n";
			}
			else {
				print "<textarea readonly rows=20 cols=68 wrap=off>\n";			
			}
		}
		
		foreach $line (<FLE>)
		{
			print "$line";
		}

		print "</textarea>\n";
		
		if ($filename =~ /\.sas$/i || $filename =~ /\.r$/i || $filename =~ /\.py$/i) {
			print "<p><input type=\"submit\" name=\"action\" value=\"run\" size=\"\">\n";
							
			if (($usrpathfifg2 == 1 or $allowedit == 1) && ($usrtypef{$usrid} < 2)) {
#			if (($allowedit == 1) && ($usrtypef{$usrid} < 2)) {					
			
				print "<input type=\"reset\" name=\"action\" value=\"reset\" size=\"\"><p>\n";
				print "\n";
				print "save as<font color=#dbe6e0></font>: <input type=\"text\" name=\"saveas\" value=\"$filename\" width=\"100%\">\n";
				print "<input type=\"submit\" name=\"action\" value=\"save\" size=\"\"><BR>\n";
			}	
		}		
		
		print "</form>\n";

		print "</td></tr>\n";

		close(FLE);

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
	  elsif ($filename =~ /\.msg$/i) {
	
	  open(FLE, "Main$curdir/$filename") || die $!;
		
		print "<tr><td align=left colspan=2>\n";
		print "<form method=POST action=\"m.file2.cgi\">\n";
		print "<input type=\"hidden\" name=\"curdir\" value=\"$curdir\">\n";
		print "<input type=\"hidden\" name=\"program\" value=\"/Main$curdir/$filename\">\n";
		print "<input type=\"hidden\" name=\"task\" value=\"$filename\">\n";

		print "<a href=\"Main$curdir/$filename\"><br>$filename</a><br>\n";

		print "<textarea readonly name=\"source\" rows=16 cols=68 wrap=off>\n";
		
		foreach $line (<FLE>)
		{
			print "$line";
		}

		print "</textarea>\n";
		print "<br>your message:\n";
		print "<textarea name=\"append\" rows=4 cols=68 wrap=off>\n";
		
		print "</textarea><p>\n";
		
		if ($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) {
			print "<font color=#dbe6e0></font><input type=\"hidden\" name=\"saveas\" value=\"$filename\" size=\"40\">\n";
			print "<input type=\"submit\" name=\"action\" value=\"savefeedback\" size=\"\"><BR>\n";
		}	
	
		print "</form>\n";

		print "</td></tr>\n";

		close(FLE);

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
	  else {
	
		open(FLE, "Main$curdir/$filename") || die $!;
		
		print "<tr><td align=left colspan=2>\n";
		print "<form method=POST action=\"m.file2.cgi\">\n";	
		
		print "<input type=\"hidden\" name=\"curdir\" value=\"$curdir\">\n";
		print "<input type=\"hidden\" name=\"program\" value=\"/Main$curdir/$filename\">\n";
		print "<input type=\"hidden\" name=\"task\" value=\"$filename\">\n";
			
		print "<a href=\"Main$curdir/$filename\"><br>$filename</a><br>\n";
		
			my($allowedit) = 0;	
			
			if ($usrtypef{$usrid} == 0) {
				$allowedit = 1;
			}
			elsif ("Main$curdir" =~ /Main\/Users\/$usrid/){
				$allowedit = 1;
			}
			elsif (-e "Main$curdir/\.attr\.$filename") {
			
				open(SHA, "Main$curdir/\.attr\.$filename") || die $!;
			
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
#		if ($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) {		
			print "<textarea name=\"source\" rows=20 wrap=off>\n";
		}
		else {
			print "<textarea readonly name=\"source\" rows=20 wrap=off>\n";		
		}
		
		my($linecnt)= 0;
		
		foreach $line (<FLE>)
		{
			print "$line";
			
			$linecnt++;
			
			if ($linecnt > 2000) {
				print "\nwarning: file exceeds 2000 lines, right click link to download.\n";
				last;
			}			
		}

		print "</textarea><p>\n";
		
		if ($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) {
			print "save as<font color=#dbe6e0></font>: <input type=\"text\" name=\"saveas\" value=\"$filename\" width=\"100%\">\n";
			print "<input type=\"submit\" name=\"action\" value=\"save\" size=\"\"><BR>\n";
		}	
		
		print "</form>\n";

		print "</td></tr>\n";

		close(FLE);

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
	}
  }
}



