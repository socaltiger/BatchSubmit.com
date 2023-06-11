#!c:\perl\bin\perl.exe
##
##  rgst2 -- CGI program that user registration
##

use File::Copy;

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
   
   $mon = $mon + 1;
   
   if ($mon < 10) {
      $mon = "0$mon";
   }
   if ($year < 10) {
      $year = "0$year";
   }
   if ($mday < 10) {
      $mday = "0$mday";
   }

   $date = "$hour\:$min\:$sec $mon/$mday/$year";

   chop($date) if ($date =~ /\n$/);
   
    $min_name_length = 2;
	$min_pass_length = 4;
	
    $max_name_length = 20;
	$max_pass_length = 20;	


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

#   if ($usrid ne "" && $usrpwdf{$usrid} eq $usrkey) 
   if ($usrid ne "" && $usrpwdf{$usrid} eq crypt($usrkey, substr($usrid,0,2))) 	    
   {
		print "<meta http-equiv=\"refresh\" content=\"0; URL=m.main2.cgi\">\n";
		print "<a href=\"m.main2.cgi\">You have an account and already logon.</a>\n";
   } 
   else
   {

	print "<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.0//EN\" \"http://www.wapforum.org/DTD/xhtml-mobile10.dtd\">\n";
	print "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>BatchSubmit.com.com (Beta)</title>\n";
	
	print "<STYLE type=text/css>H2 {FONT-SIZE: 18px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "H3 {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";	
	print "TH {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "TD {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "LI {FONT-SIZE: 12px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif}\n";
	print "INPUT {FONT-SIZE: 14px}\n";
	print "</STYLE>\n";	
	
	print "<body bgColor=#eaf9ff><center>\n";

      print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
      print "  <tr><td bgcolor=white align=center background=\"image/cloud.jpg\"><h2>BatchSubmit.com (Beta)</h2>\n";	  
      print "  <h3>Cloud Computing for SAS, R and Python Scripts</h3></td></tr>\n";
      print "</table><br>\n";

      print "<Table cellSpacing=0 cellPadding=0 width=100% border=0>\n";
      print "  <tr>\n";
      print "     <td valign=top width=100% bgcolor=#dbe6e0>\n";
      print "       <FORM method=POST ACTION=\"m.main2.cgi\">\n";
      print "       <TABLE cellSpacing=0 cellPadding=5 width=100% border=0>\n";

      print "           <TR bgColor=#99bcd8><TD colspan=5 align=left><font color=\"white\"><b>USER</b></font></TD></TR>\n";
      print "           <TR><TD colspan=5 align=left><img src=\"image/user.png\" border=0> User sign up</TD></TR>\n";
      print "           <tr><td colspan=5 height=8 bgcolor=EAF9FF></td></tr>\n";
      print "           <TR bgColor=#99bcd8><TD colspan=5 align=left><font color=\"white\"><b>MENU</b></font></TD></TR>\n";
      print "           <TR><TD align=left><a href=\"m.main2.cgi?curdir=\"><img src=\"image/landmark.png\" border=0> Main</a></TD>\n"; 
	  print "           <TD align=left><a href=\"m.main2.cgi?curdir=/Users/$usrid\"><img src=\"image/home.png\" border=0> Home</a></TD>\n";	  	  
	  print "           <TD align=left><a href=\"m.task2.cgi\"><img src=\"image/task.png\" border=0> Task</a></TD>\n";
      print "           <TD align=left><a href=\"m.help2.cgi\"><img src=\"image/help_book.png\" border=0> Help</a></TD>\n";	
      print "           <TD align=center><a href=\"main2.cgi?curdir=\"><img src=\"image/desktop.png\" border=0> PC</a></TD></TR>\n";	 		  
	  
#     print "           <tr><td colspan=2 height=8 bgcolor=EAF9FF></td></tr>\n";

#      print "           <TR bgColor=#99bcd8><TD colspan=2 align=left><font color=\"white\"><b>INFO</b></font></TD></TR>\n";
#      print "           <TR><TD colspan=2>$info</TD></TR>\n";

      print "       </TABLE>\n";
      print "       </FORM>\n";
      print "     </td>\n";
      print "     </tr>\n";	  	  
#      print "     <td width=8><br></td>\n";
      print "     <tr>\n";	  
      print "     <TD valign=top width=100% bgColor=#dbe6e0>\n";
      print "       <TABLE cellSpacing=0 cellPadding=4 width=100% border=0>\n";
     print "           <tr><td colspan=2 height=8 bgcolor=EAF9FF></td></tr>\n";	  
      print "       <tr bgColor=#99bcd8><td valign=top colspan=2><font color=\"white\">sign up</font></td></tr>\n";	 
	  
    $task = $FORM{"task"};
	$fail = $FORM{"fail"};

	if ($task eq "newuser") {
	
		print "<tr><td colspan=2><form method=POST action=\"m.rgst2.cgi\">\n";
		print "<input type=\"hidden\" name=\"task\" value=\"$task\">\n";	
		print "<input type=\"hidden\" name=\"fail\" value=\"yes\">\n";			

		$user = $FORM{"user"};
		$pass = $FORM{"pass"};	
		$email = $FORM{"email"};	
		$quiz = $FORM{"quiz"};	
		$quizno = $FORM{"quizno"};		
		
		my $safe_filename_characters = "a-zA-Z0-9_.-";		
				
		$user = lc($user);	
			
		my($status) = 1;
		
		if ($user eq "") {
			$require = $require . " " . "need username<br>";
			$status = 0;
		}
        elsif ($user =~ /:|"|<|>|\&|\s/) {
			$require = $require . " " . "username can not contain following chars: <, >, :, \", \&, white space<br>";		
			$status = 0;
		}	
		elsif (!($user =~ /^([$safe_filename_characters]+)$/)) {
			$require = $require . " " . "username contains invalid characters<br>";		
			$status = 0;
		}			
        elsif (length($user) > $max_name_length) {
			$require = $require . " " . "username too long, maxium: 20 chars<br>";		
			$status = 0;
		}	
        elsif (length($user) < $min_name_length) {
			$require = $require . " " . "username too short, minium: 2 chars<br>";		
			$status = 0;
		}					
		elsif ($usrpwdf{$user} ne "") {
			$require = $require . " " . "user already exists, choose another name<br>";		
			$status = 0;
		}
				
		if ($pass eq "") {
			$require = $require . " " . "need password<br>";
			$status = 0;			
		}	
        elsif ($pass =~ /:|"|<|>|\&|\s/) {
			$require = $require . " " . "passworde can not contain following chars: <, >, :, \", \&, white space<br>";		
			$status = 0;
		}				
		elsif (length($pass) > $max_pass_length) {
			$require = $require . " " . "password too long, maxium: 20 chars<br>";		
			$status = 0;
		}
		elsif (length($pass) < $min_pass_length) {
			$require = $require . " " . "password too short, maxium: 4 chars<br>";		
			$status = 0;
		}				
				
		if ($email eq "") {
			$require = $require . " " . "need email<br>";
			$status = 0;				
		}				
		elsif (!($email =~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i)) {
			$require = $require . " " . "email address incorrect<br>";
			$status = 0;				
		}
		
		open(QUZ, "pswd2.cgi.quz") || &error;
    	
		while (<QUZ>)
		{
			chop();
			my($qno, $qtxt, $qans) = split(/:/);	
			$quiztxt{$qno} = $qtxt;			
			$quizans{$qno} = $qans;
		}    
		close(QUZ);		
		
		if ($quiz eq "") {
			$require = $require . " " . "quiz not answered<br>";
			$status = 0;				
		}	
		elsif (!($quiz == $quizans{$quizno})) {
			$require = $require . " " . "quiz answer incorrect<br>";
			$status = 0;				
		}			
			
		if ($status == 0) {
		
			if ($fail eq "yes") {	
	
				print "<tr><td>Registration incomplete:</td></tr>\n";	
				print "<tr><td>$require</td></tr>\n";			
			}
			
			print "<tr><td colspan=2>username: <input type=\"input\" name=\"user\" value=\"$user\" size=10><br>\n";	
			print "password: <input type=\"input\" name=\"pass\" value=\"$pass\" size=10><br>\n";	
			print "useremail: <input type=\"input\" name=\"email\" value=\"$email\" size=20><br>\n";	
		
			print "<br>\n";

			my($quizcount) = 0;			
			
			open(QUZ, "pswd2.cgi.quz") || &error;
    		
			while (<QUZ>)
			{
				chop();
				my($qno, $qtxt, $qans) = split(/:/);	
				$quztxt{$qno} = $qtxt;			
				$quzans{$qno} = $qans;
				
				$quizcount = $quizcount + 1;
			}    
			close(QUZ);	

			my ($rint) = int(rand($quizcount)) + 1;	
			
			print "robot quiz:<p>\n";			

			print "$quztxt{$rint}: <input type=\"input\" name=\"quiz\" value=\"\" size=4><p>\n";
			print "<input type=\"hidden\" name=\"quizno\" value=\"$rint\">\n";	
				
			print "<p><input type=\"submit\" name=\"action\" value=\"submit\"><BR>\n";

		}	
		else {
		
		   if (-e "pswd2.flg" && -M "pswd2.flg" < 0.002)
			{ 
				print "<tr><td>system busy, please try again shortly.</td></tr>\n";
			}
			else {	
			
				$now = time;
				utime($now, $now, "pswd2.flg") || open(FLG, ">>pswd2.flg") || die $!;
				close(FLG);
				
				copy("pswd2.cgi","pswd2.cgi.bak/pswd2.cgi.$year$mon$mday") || die $!;						

				$cryptpass = crypt($pass, substr($user,0,2));				
				
				open(UPW, ">>pswd2.cgi") || die $!;			
				print UPW "$user:$cryptpass:1:$email:Main/Users/$user:\n";
				close(UPW);		

				mkdir("Main/Users/$user") || die $!;	

				copy("welcome.msg","Main/Users/$user/welcome.msg") || die $!;	
				copy("first.sas","Main/Users/$user/first.sas") || die $!;	
				copy("input.par","Main/Users/$user/input.par") || die $!;					
				copy("HelloWorld.r","Main/Users/$user/HelloWorld.r") || die $!;					
				copy("R_input.par","Main/Users/$user/R_input.par") || die $!;						
				copy("py_input.par","Main/Users/$user/py_input.par") || die $!;					
				copy("Simple.py","Main/Users/$user/Simple.py") || die $!;					
									
				unlink("pswd2.flg") || die $!;
				
				print "<tr><td>success!<p>username: $user<br>password: $pass<br>useremail: $email<br></td></tr>\n";
				print "<tr><td>now go to <a href=\"http://batchsubmit.com/casper2/m.main2.cgi\">main page</a> to logon for the first time.</td></tr>\n";			
			}
		}
		
		print "</form>\n";
	}
			
	print "</td></tr></table>\n";
	print "</table><br>\n";

	print "<table cellspacing=0 cellpadding=0 width=100% border=0>\n";
      print "    <tr><td bgcolor=#dbe6e0 align=center><br>All Rights Reserved</td></tr>\n";
      print "    <tr><td bgcolor=#dbe6e0 align=center><br></td></tr>\n";
      print "</table>\n";
      print "</center>\n";

	print "</body></html>\n";
   }
}



