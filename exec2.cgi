#!c:\perl\bin\perl.exe
##
##  exec2.cgi -- create task.xml and parm.xml to be executed by cspr2.pl
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
	print "<a href=\"main2.cgi\">You must logon from BatchSubmit(Beta) main page</a>\n";
   } 
   else
   {
	print "<html><head><title>BatchSubmit.com (Beta)</title>\n";

	print "<STYLE type=text/css>H2 {FONT-SIZE: 16px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TH {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TD {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "LI {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
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


	my($curdir) = $FORM{"curdir"};
	my($taskdir) = "Main$curdir";

	$task = $FORM{"task"};
    $saveas = $FORM{"saveas"};
	$action = $FORM{"action"};
	$cron = $FORM{"cron"};
	$cronwk = $FORM{"cronwk"};	

    if ($action eq "save") {
	
	  if ($saveas =~ /\// || $saveas =~ /\\/){
	  
	    print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File can only be saved in the same directory, please try again.</b></font></td></tr>\n";
		print "<tr><td>Choose one of the following:</td></tr>\n";
		print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
		print "<tr>\n";
  		print "</tr>\n";

	  }
	  elsif ($saveas =~ /\.sas$/i || $saveas =~ /\.r$/i || $saveas =~ /\.py$/i) {

		$saveas =~ s/ /_/g;	
	  
	  	$source = $FORM{"source"};
		
		$source =~ s/\r//g;
	
		open(SAS, ">$taskdir/$saveas") || die $!;
			print SAS $source || die $!;
		close(SAS);
				
      	print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>The program has been saved</b></font></td></tr>\n";
		print "<tr><td>Choose one of the following:</td></tr>\n";
#		print "<tr>\n";
#		print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
#		print "</tr>\n";
		print "<tr>\n";		
		print "<td><h3><a href=\"main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
  		print "</tr>\n";		
	  }
	  elsif ($saveas =~ /\.par$/i) {

     		open(TAS,"$taskdir/$task") ||  die $!;
			@tas = <TAS>;
		close(TAS);

      	        open(SAV,">$taskdir/$saveas") || die $!;

			foreach $line (@tas) {
				($wwwid, $wwwlabel, $wwwtype, $wwwname, $wwwvalue, $wwwsize, $wwwbreak) = split(/\|/, $line);

				if ($wwwtype eq "select") {
					@wwwoptions = split(/:/, $wwwvalue);

					my $newoptions;

   					foreach $wwwoption (@wwwoptions) {
						$wwwoption =~ s/#//;
						
						if ($FORM{"$wwwname"} eq $wwwoption) {
							$newoptions .= "#";
							$newoptions .= $wwwoption;
							$newoptions .= ":";
						}
						else {
							$newoptions .= $wwwoption;
							$newoptions .= ":";
						}		
					}

					chop($newoptions);
					print SAV "$wwwid|$wwwlabel|$wwwtype|$wwwname|$newoptions|$wwwsize|$wwwbreak|\n";
				}
				elsif ($wwwtype eq "radio") {
					@wwwoptions = split(/:/, $wwwvalue);

					my $newoptions;

   					foreach $wwwoption (@wwwoptions) {
						$wwwoption =~ s/#//;
												
						if ($FORM{"$wwwname"} eq $wwwoption) {
							$newoptions .= "#";
							$newoptions .= $wwwoption;
							$newoptions .= ":";
						}
						else {
							$newoptions .= $wwwoption;
							$newoptions .= ":";
						}		
					}

					chop($newoptions);
					print SAV "$wwwid|$wwwlabel|$wwwtype|$wwwname|$newoptions|$wwwsize|$wwwbreak|\n";
				}
				elsif ($wwwtype eq "checkbox") {

					my $newvalue;

					$wwwvalue =~ s/#//;
												
					if ($FORM{"$wwwname"} ne "") {
							$newvalue .= "#";
							$newvalue .= $wwwvalue;
					}
					else {
							$newvalue .= $wwwvalue;
					}		
				
					print SAV "$wwwid|$wwwlabel|$wwwtype|$wwwname|$newvalue|$wwwsize|$wwwbreak|\n";
				}				
				else {
					if ($wwwname eq "saveas") {print SAV "$wwwid|$wwwlabel|$wwwtype|$wwwname|$saveas|$wwwsize|$wwwbreak|\n";}
					elsif ($wwwname eq "task") {print SAV "$wwwid|$wwwlabel|$wwwtype|$wwwname|$saveas|$wwwsize|$wwwbreak|\n";}
					elsif ($wwwname eq "cron") {print SAV "$wwwid|$wwwlabel|$wwwtype|$wwwname|$cron|$wwwsize|$wwwbreak|\n";}
					elsif ($wwwname eq "cronwk") {print SAV "$wwwid|$wwwlabel|$wwwtype|$wwwname|$cronwk|$wwwsize|$wwwbreak|\n";}					
					elsif ($wwwname =~ m/^parm/i) {print SAV "$wwwid|$wwwlabel|$wwwtype|$wwwname|$FORM{$wwwname}|$wwwsize|$wwwbreak|\n";}
					else { print SAV $line;}
				}
			}

		close(SAV);

      		print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>The program has been saved</b></font></td></tr>\n";
#      		print "<tr><td><h3>File saved!</h3></td></tr>\n";
		print "<tr><td>Choose one of the following:</td></tr>\n";
#		print "<tr>\n";
#		print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
#  		print "</tr>\n";
		print "<tr>\n";
		print "<td><h3><a href=\"main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
  		print "</tr>\n";
	  }
	  else {

      		print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>Invalid file name, please try again</b></font></td></tr>\n";
#      		print "<tr><td><h3>File saved!</h3></td></tr>\n";
		print "<tr><td>Choose one of the following:</td></tr>\n";
#		print "<tr>\n";
		print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
#  		print "</tr>\n";
		print "<tr>\n";
#		print "<td><h3><a href=\"main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
  		print "</tr>\n";

	  }
      	}
 	else {
	
   		if ($task =~ /\.par$/i || $task =~ /\.sas$/i || $task =~ /\.r$/i || $task =~ /\.py$/i){
      		print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>The program has been submitted for execution</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
   	   		print "<tr>\n";
			print "<td><h3><a href=\"task2.cgi\">monitor task progress</a></h3></td>\n";
			print "</tr>\n";
			print "<tr>\n";
			print "<td><h3><a href=\"javascript:history.go(-1)\">return to previous task</a></h3></td>\n";
  	    	print "</tr>\n";
			print "<tr>\n";
			print "<td><h3><a href=\"main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
  	    	print "</tr>\n";				
				
			if ($task =~ /\.sas$/i || $task =~ /\.r$/i || $task =~ /\.py$/i){
			
				$source = $FORM{"source"};
				$source =~ s/\r//g;
				
				open(SAS, ">$taskdir/\.$task") || die $!;				
					print SAS $source || die $!;
				close(SAS);
			}			
			
			$program = $FORM{"program"};

			if ($program =~ /\.sas$/i){
				$_ = $task;
				s/\.par/\.log/i;
				s/\.sas/\.log/i;
				$tasklog = $_;

				$_ = $task;		
				s/\.par/\.lst/i;		
				s/\.sas/\.lst/i;							
				$tasktxt = $_;
			}
			elsif ($program =~ /\.r$/i){
						
				$_ = $task;		
				s/\.par/\.out/i;		
				s/\.r/\.out/i;					
				$taskout = $_;
			}
			elsif ($program =~ /\.py$/i){
						
				$_ = $task;		
				s/\.par/\.out/i;		
				s/\.py/\.out/i;					
				$taskout = $_;		

				$_ = $task;		
				s/\.par/\.err/i;		
				s/\.py/\.err/i;					
				$taskerr = $_;					
			}				
					
			open (LOCK, ">lock.xml") || die $!;

			my($lockcount) = 0;
			until (flock(LOCK,2)) {
				sleep(0.1);
				if(++$lockcount > 50) { die $!; }			
			}

   	   		open(TASKREAD,"task.xml") || die $!;
			@alltasks = <TASKREAD>;
			close(TASKREAD);

			my($TASKCOUNT) = 0;
   	   		open(TASK,">task.xml") || die $!;
			foreach $taskline (@alltasks)
			{			
				print TASK $taskline;
				($TASKCOUNT,$dummy1,$dummy2) =split(/:/, $taskline);
			}

			$TASKCOUNT++;

			if ($task =~ /\.par$/i) {
				if ($program =~ /\.sas$/i){
					print TASK "$TASKCOUNT:$usrid:PAR:$taskdir:sas.exe -noterminal -sysin $program -log $tasklog -print $tasktxt\n"; 
				}
				elsif ($program =~ /\.r$/i){
					print TASK "$TASKCOUNT:$usrid:PAR:$taskdir:R.exe CMD BATCH --no-save --no-restore $program $taskout\n"; 
				}
				elsif ($program =~ /\.py$/i){
					print TASK "$TASKCOUNT:$usrid:PAR:$taskdir:python.exe $program $taskout $taskerr\n"; 
				}				
			}	
			else {
				if ($program =~ /\.sas$/i){
					print TASK "$TASKCOUNT:$usrid:SAS:$taskdir:sas.exe -noterminal -sysin $program -log $tasklog -print $tasktxt\n"; 
				}
				elsif ($program =~ /\.r$/i){
					print TASK "$TASKCOUNT:$usrid:RRR:$taskdir:R.exe CMD BATCH --no-save --no-restore $program $taskout\n"; 
				}	
				elsif ($program =~ /\.py$/i){
					print TASK "$TASKCOUNT:$usrid:PYN:$taskdir:python.exe $program $taskout $taskerr\n"; 
				}					
			}
			
			close(TASK);

			chmod 0666, "task.xml";

   	   		open(PARM,">parm$TASKCOUNT.xml") ||  die $!;;

			if ($program =~ /\.sas$/i){
			
#				print PARM "options nodate;\n";				
				print PARM "%let usrid=$usrid;\n";
				print PARM "%let usremail=$usremail;\n";
				
				$basedir1 = $basedir;
				chop($basedir1);
				
				print PARM "%let basedir=$basedir1;\n";
			
				while (($parmname, $parmvalue) = each(%FORM)) {
					if ($parmname =~ m/^parm/i) {
						print PARM "%let $parmname=$FORM{$parmname};\n"; 			
					}
				}
			}
			elsif ($program =~ /\.r$/i){

				print PARM "setwd(\"\.\.\/$taskdir\");\n";			
				print PARM "usrid <- \"$usrid\";\n";
				print PARM "usremail <-\"$usremail\";\n";

				while (($parmname, $parmvalue) = each(%FORM)) {
					if ($parmname =~ m/^parm/i) {
						print PARM "$parmname <- \"$FORM{$parmname}\";\n"; 			
					}
				}		
			}
			elsif ($program =~ /\.py$/i){
			
				print PARM "usrid = \"$usrid\"\n";
				print PARM "usremail = \"$usremail\"\n";				
			
				while (($parmname, $parmvalue) = each(%FORM)) {
					if ($parmname =~ m/^parm/i) {
						print PARM "$parmname=\"$FORM{$parmname}\"\n"; 			
					}
				}	
			}			
			
			close(PARM);

			chmod 0666, "parm$TASKCOUNT.xml";

			flock(LOCK, 8);
    			close (LOCK);
		}		
      }

      print "</table>\n";
	print "</table><br>\n";

	print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
      print "    <tr><td bgcolor=#dbe6e0 align=center><br>All Rights Reserved</td></tr>\n";
      print "    <tr><td bgcolor=#dbe6e0 align=center><br></td></tr>\n";
      print "</table>\n";
      print "</center>\n";

	print "</body></html>\n";
   }	
}



