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
		
	print "<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.0//EN\" \"http://www.wapforum.org/DTD/xhtml-mobile10.dtd\">\n";
	print "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>BatchSubmit.com (Beta)</title>\n";

	print "<STYLE type=text/css>H2 {FONT-SIZE: 18px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
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

      if ($usrid ne "") {
         print "           <TR><TD colspan=5 align=left><img src=\"image/user.png\" border=0> User: $usrid \n";
         print "           <INPUT TYPE=\"submit\" name=\"action\" value=\"Logout\"></TD></TR>\n";
      }
      else
      {
         print "           <TR><TD colspan=5 align=left>User not logged in</TD></TR>\n";
      }

      print "           <tr><td height=8 colspan=5 bgcolor=EAF9FF></td></tr>\n";

      print "           <TR bgColor=#99bcd8><TD colspan=5 align=left><font color=\"white\"><b>MENU</b></font></TD></TR>\n";
      print "           <TR><TD align=center><a href=\"m.main2.cgi?curdir=\"><img src=\"image/landmark.png\" border=0> Main</a></TD>\n";
	  print "           <TD align=center><a href=\"m.main2.cgi?curdir=/Users/$usrid\"><img src=\"image/home.png\" border=0> Home</a></TD>\n";	  
      print "           <TD align=center><a href=\"m.task2.cgi\"><img src=\"image/task.png\" border=0> Task</a></TD>\n";
      print "           <TD align=center><a href=\"m.help2.cgi\"><img src=\"image/help_book.png\" border=0> Help</a></TD>\n";
      print "           <TD align=center><a href=\"main2.cgi?curdir=\"><img src=\"image/desktop.png\" border=0> PC</a></TD></TR>\n";	  

      print "           <tr><td height=8 colspan=5 bgcolor=EAF9FF></td></tr>\n";

#      print "           <TR bgColor=#99bcd8><TD colspan=4 align=left><font color=\"white\"><b>INFO</b></font></TD></TR>\n";
#      print "           <TR><TD colspan=4>$info</TD></TR>\n";

      print "       </TABLE>\n";
      print "       </FORM>\n";
      print "     </td>\n";
      print "     </tr>\n";	
#      print "     <tr>\n";	  	  
#      print "     </tr>\n";	  	  
#      print "     <td width=8><br></td>\n";
#      print "     </tr>\n";	 	  
      print "     <tr>\n";	  	  
  
      print "     <TD valign=top width=100% bgColor=#dbe6e0>\n";
      print "       <TABLE cellSpacing=0 cellPadding=4 width=100% border=0>\n";
      print "       <tr bgColor=#99bcd8><td colspan=2 width=100%><font color=white>Help</font></td></tr>\n";
      print "       <tr><td align=left><a href=\"javascript:history.go(-1)\"><img src=\"image/GreenBack.png\" border=0></a></td><td align=right><a href=\"javascript:history.go(0)\"><img src=\"image/refresh.gif\" border=0></a></td></tr>\n";
	  
	my($curdir) = $FORM{"curdir"};
	my($filename) = $FORM{"task"};

	print "<tr><td align=left colspan=2>\n";
	
	print "<iframe width=100% scrolling=\"auto\" frameborder=\"0\" src=\"help.html\"></iframe>\n";

	print "</td></tr>\n";

      print "       </table>\n";
      print "     </td>\n";
      print "  </tr>\n";
      print "</Table><br>\n";

      print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
      print "    <tr><td bgcolor=#dbe6e0 align=center><br>Open Source Code</td></tr>\n";
      print "    <tr><td bgcolor=#dbe6e0 align=center><br></td></tr>\n";
      print "</table>\n";
      print "</center>\n";

	print "</body></html>\n";
}





