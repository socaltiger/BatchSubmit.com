#!c:\perl\bin\perl.exe
##
##  upld2.cgi -- upload file to server
##

use File::Path;
use CGI;

###########################################################################
# Read Main Page
&main_page;

#######################
# Handle Error

sub error {
   print "error...\n";
}

########################
# Get Basename

sub GetBasename {
	my $fullname = shift;

	my(@parts);
	# check which way our slashes go.
	if ( $fullname =~ /(\\)/ ) {
		@parts = split(/\\/, $fullname);
	} else {
		@parts = split(/\//, $fullname);
	}

	return(pop(@parts));
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
	print "H2 {FONT-SIZE: 18px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "H3 {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";	     
	print "TH {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TD {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "LI {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
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
      print "           <TR><TD align=center><a href=\"m.main2.cgi?curdir=\"><img src=\"image/landmark.png\" border=0> Main</a></TD>\n";
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

		my $cgi = new CGI();	
		
		$CGI::POST_MAX = 1024 * 5000;

		my $curdir = $cgi->param('curdir');
		my $task = $cgi->param('task');
		my $action = $cgi->param('action');
		
	if ($action eq "upfile") {
	
			my $upfile = $cgi->param('upfile');
			
			if ( !$upfile )
			{
				print "There was a problem uploading your file(try a smaller file).";
				exit;
			}			
					
			my $basename = GetBasename($upfile);
			
			my $safe_filename_characters = "a-zA-Z0-9_.-";
			
			$basename =~ tr/ /_/;
			$basename =~ s/[^$safe_filename_characters]//g;
			
			if ($basename =~ /\.php$/i || $basename =~ /\.cgi$/i || $basename =~ /\.pl$/i || $basename =~ /\.exe$/i) {
				print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>You have no permission to upload this file type.</b></font></td></tr>\n";
			}	
			elsif (!($basename =~ /^([$safe_filename_characters]+)$/)) {
				print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name contains invalid characters.</b></font></td></tr>\n";				
			}			
			else
			{
				$basename = $1;
	
				my $ufh = $cgi->upload('upfile');
			
				open(UPL, ">Main/$curdir/$basename") || &error;
												
				binmode UPL;

				while (<$ufh>) {
					print UPL;
				}

				close(UPL);			
						
				print "\n";
				
				print "<tr bgColor=#99bcd8><td width=600><font color=\"white\"><b>File has been uploaded.</b></font></td></tr>\n";	
			
			}
			
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";	
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



