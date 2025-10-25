#!c:\perl\bin\perl.exe
##
##  main2 -- CGI program that display the content of SAS task directory
##

#use Net::LDAP;
#use Net::LDAP::Util qw(ldap_error_text);

use File::Find;

###########################################################################
# Get Form Information
&parse_form;

my($usrid);
@sharedfolders = ();

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
   print "error... $! \n";
}

#######################
# Shared Folders

sub sharedfolders
{
	our $usrid;
    our @sharedfolders;	
	
    if ($_ eq ".sharefolder") {

		$shareddir = $File::Find::dir;
			
		open (SHA, ".sharefolder") || die $!;
		
		foreach $sharedline (<SHA>) {
		
			$sharedline =~ s/^\s+|\s$//g;
			
			if (lc($sharedline) eq $usrid || lc($sharedline) eq "all" ) {
				push(@sharedfolders, $shareddir);
				
				last;
			}
		}
		
#		print @sharedfolders;
		
		close SHA;
	}
}

###############################
# Main Page Subroutine

sub main_page {

	our $usrid;
    our @sharedfolders;	

   	open(BAS, "base.txt") || &error;
    	while (<BAS>)
    	{
		chop();
		($basedir, $info) = split(/\|/);	
    	}    
    	close(BAS);

	print "Content-type: text/html; charset=iso-8859-1\n";

      	$usrid = $ENV{'HTTP_COOKIE'};
      	$usrid =~ /usrid=([^;]*)/;
      	$usrid = $1;

      	$usremail = $ENV{'HTTP_COOKIE'};
      	$usremail =~ /usremail=([^;]*)/;
      	$usremail = $1;
		
      	$usrkey = $ENV{'HTTP_COOKIE'};
      	$usrkey =~ /usrkey=([^;]*)/;
      	$usrkey = $1;	

	$user = $FORM{'USER'}; 
	
	$user = lc($user);
	
	$pass = $FORM{'PASS'};

   	open(UPW, "pswd2.cgi") || &error;
    	while (<UPW>)
    	{
		chop();
		($usrnamef, $usrpwdf, $usrtypef, $usremailf, $usrpathf) = split(/:/);	
#		$usrpwdf{$usrnamef} = crypt($usrpwdf, substr($usrnamef,0,2));	
		$usrpwdf{$usrnamef} = $usrpwdf;	
		$usrtypef{$usrnamef} = $usrtypef;
		$usremailf{$usrnamef} = $usremailf;
		$usrpathf{$usrnamef} = $usrpathf;

    	}    
    	close(UPW);

#	if ($usrid ne "") {
#	if ($usrid ne "" && $usrpwdf{$usrid} eq $usrkey) {	
	if ($usrid ne "" && $usrpwdf{$usrid} eq crypt($usrkey, substr($usrid,0,2))) {	
		$loginsuccess = 'Y';
	}
	elsif ($user eq "" || $pass eq "") {
		$loginsuccess = 'N';
	}
#	elsif ($usrpwdf{$user} ne "LDAP" && $usrpwdf{$user} eq $pass) {		
	elsif ($usrpwdf{$user} ne "LDAP" && $usrpwdf{$user} eq crypt($pass, substr($user,0,2))) {

		$loginsuccess = 'Y';
	}
	elsif ($usrpwdf{$user} eq "LDAP") {

		$ldap = Net::LDAP->new('ldap.amgen.com') || &error;

		# search for uniqueidentifier

		$mesg  = $ldap->bind;

		my $filter = "uid=" . $user;

		$mesg  = $ldap->search(base => "ou=People, dc=Enterprise, dc=amgen, dc=com",
				       filter => $filter
				);

		$mesg->code && &error;

		foreach $entry ($mesg->entries) {
			$cn = ${$entry->get('cn')}[0];
			$uid = ${$entry->get('uid')}[0]; 
			$uniqueidentifier = ${$entry->get('uniqueidentifier')}[0]; 
		}

		# authenticate using uniqueidentifier and password

		my $binddn = "uniqueidentifier=" . $uniqueidentifier . ", ou=People, dc=Enterprise, dc=amgen, dc=com";

		my $result  = $ldap->bind(dn => $binddn, password => $pass);

		if ($result->code)
		{
			$loginsuccess = 'N';
		}
		else
		{
			$loginsuccess = 'Y';
		}
	}
	else {
		$loginsuccess = 'N';
	}

	if ($FORM{"action"} eq "Login" || $FORM{"action"} eq "Take a Tour") {
	    if ($loginsuccess eq 'Y') {
			print "Set-Cookie: usrid=$user;\n";
			print "Set-Cookie: usremail=$usremailf{$user};\n";
#			print "Set-Cookie: usrkey=$usrpwdf{$user};\n\n";
			print "Set-Cookie: usrkey=$pass;\n\n";				
	    }
	    else
	    {
        	print "Set-Cookie: usrid=$user; expires=Thu, 31-Dec-2000 00:00:00 GMT;\n";
        	print "Set-Cookie: usremail=$usremailf{$user}; expires=Thu, 31-Dec-2000 00:00:00 GMT;\n";
#        	print "Set-Cookie: usrkey=$usrpwdf{$user}; expires=Thu, 31-Dec-2000 00:00:00 GMT;\n\n";	
        	print "Set-Cookie: usrkey=$pass; expires=Thu, 31-Dec-2000 00:00:00 GMT;\n\n";					
	    }
    }
    elsif ($FORM{"action"} eq "Logout") {
        print "Set-Cookie: usrid=$user; expires=Thu, 31-Dec-2000 00:00:00 GMT;\n";
        print "Set-Cookie: usremail=$usremailf{$user}; expires=Thu, 31-Dec-2000 00:00:00 GMT;\n";
#        print "Set-Cookie: usrkey=$usrpwdf{$user}; expires=Thu, 31-Dec-2000 00:00:00 GMT;\n\n";
        print "Set-Cookie: usrkey=$pass; expires=Thu, 31-Dec-2000 00:00:00 GMT;\n\n";							
	}
	else {
		print "Set-Cookie: usrid=$usrid;\n";
		print "Set-Cookie: usremail=$usremail;\n";
		print "Set-Cookie: usrkey=$usrkey;\n\n";
	}
 
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
      if ($FORM{"action"} eq "Logout") {

		$loginsuccess = 'N';

      		print "           <TR><TD colspan=2 align=center><font face=\"Courier\">username:</font> <INPUT TYPE=\"TEXT\" NAME=\"USER\" VALUE=\"$user\" SIZE=12><BR>\n";
      		print "           <font face=\"Courier\">password:</font> <INPUT TYPE=\"PASSWORD\" NAME=\"PASS\" VALUE=\"\" SIZE=12></TD></TR>\n";
      		print "           <TR><TD colspan=2 align=center><INPUT TYPE=\"submit\" name=\"action\" value=\"Login\"></TD></TR>\n";
      		print "           <TR><TD colspan=2 align=center><a href=\"rgst2.cgi?task=newuser\">sign up new account</a></TD></TR>\n";			
      }
      elsif ($FORM{"action"} eq "Login" || $FORM{"action"} eq "Take a Tour") {
	   if ($loginsuccess eq 'Y') {
      		print "           <TR><TD colspan=2 align=left><img src=\"image/user.png\" border=0> User: $user</TD></TR>\n";
      		print "           <TR><TD colspan=2 align=center><INPUT TYPE=\"submit\" name=\"action\" value=\"Logout\"></TD></TR>\n";
	   }
	   else
	   {
      		print "           <TR><TD colspan=2 align=center>login failed, try again!<br><br><font face=\"Courier\">username:</font> <INPUT TYPE=\"TEXT\" NAME=\"USER\" VALUE=\"$user\" SIZE=12><BR>\n";
      		print "           <font face=\"Courier\">password:</font> <INPUT TYPE=\"PASSWORD\" NAME=\"PASS\" VALUE=\"\" SIZE=12></TD></TR>\n";
      		print "           <TR><TD colspan=2 align=center><INPUT TYPE=\"submit\" name=\"action\" value=\"Login\"></TD></TR>\n";
      		print "           <TR><TD colspan=2 align=center><a href=\"rgst2.cgi?task=newuser\">sign up new account</a></TD></TR>\n";				
	   }
      }
      elsif ($usrid eq "") {

      		print "           <TR><TD colspan=2 align=center><font face=\"Courier\">username:</font> <INPUT TYPE=\"TEXT\" NAME=\"USER\" VALUE=\"$user\" SIZE=12><BR>\n";
      		print "           <font face=\"Courier\">password:</font> <INPUT TYPE=\"PASSWORD\" NAME=\"PASS\" VALUE=\"\" SIZE=12></TD></TR>\n";
      		print "           <TR><TD colspan=2 align=center><INPUT TYPE=\"submit\" name=\"action\" value=\"Login\"></TD></TR>\n";
      		print "           <TR><TD colspan=2 align=center><a href=\"rgst2.cgi?task=newuser\">sign up new account</a></TD></TR>\n";				
      }
      else {
      		print "           <TR><TD colspan=2 align=left><img src=\"image/user.png\" border=0> User: $usrid</TD></TR>\n";
      		print "           <TR><TD colspan=2 align=center><INPUT TYPE=\"submit\" name=\"action\" value=\"Logout\"></TD></TR>\n";
      }
      print "           <tr><td colspan=2 height=8 bgcolor=EAF9FF></td></tr>\n";


      print "           <TR bgColor=#99bcd8><TD colspan=2 align=left><font color=\"white\"><b>MENU</b></font></TD></TR>\n";
      print "           <TR><TD align=left><a href=\"main2.cgi?curdir=\"><img src=\"image/landmark.png\" border=0> Main</a></TD>\n";	

	  if ($usrid ne "") { 
			print "           <TD align=left><a href=\"main2.cgi?curdir=/Users/$usrid\"><img src=\"image/home.png\" border=0> Home</a></TD></TR>\n";
	  }
	  elsif ($user ne ""){ 
			print "           <TD align=left><a href=\"main2.cgi?curdir=/Users/$user\"><img src=\"image/home.png\" border=0> Home</a></TD></TR>\n";
	  }
	  else { 
			print "           <TD align=left><a href=\"main2.cgi?curdir=/Users\"><img src=\"image/home.png\" border=0> Home</a></TD></TR>\n";
	  }	  
	  
	  print "           <TR><TD align=left><a href=\"task2.cgi\"><img src=\"image/task.png\" border=0> Task</a></TD>\n";
      print "           <TD align=left><a href=\"YaBB_2.5.2/cgi-bin/yabb2/YaBB.pl?board=rfp\"><img src=\"image/auction.png\" border=0> RFP</a></TD></TR>\n";	
      print "           <TR><TD align=left><a href=\"YaBB_2.5.2/cgi-bin/yabb2/YaBB.pl\"><img src=\"image/bulletin_board.png\" border=0> Board</a></TD>\n";	  		  
      print "           <TD align=left><a href=\"YaBB_2.5.2/cgi-bin/yabb2/YaBB.pl?action=search\"><img src=\"image/Find.png\" border=0> Search</a></TD></TR>\n";		  	  
      print "           <TR><TD align=left><a href=\"m.main2.cgi?curdir=\"><img src=\"image/iphone.png\" border=0> Mobile</a></TD>\n";	  		  
      print "           <TD align=left><a href=\"help2.cgi\"><img src=\"image/help_book.png\" border=0> Help</a></TD></TR>\n";  
	  

      print "           <tr><td colspan=2 height=8 bgcolor=EAF9FF></td></tr>\n";

#      print "           <TR bgColor=#99bcd8><TD colspan=2 align=left><font color=\"white\"><b>INFO</b></font></TD></TR>\n";
#      print "           <TR><TD colspan=2>$info</TD></TR>\n";

#      print "       </TABLE>\n";
#      print "       </FORM>\n";
#      print "     </td>\n";
#      print "     <td width=8><br></td>\n";
#      print "     <TD valign=top bgColor=#dbe6e0>\n";
#      print "       <TABLE cellSpacing=0 cellPadding=4 width=100% border=0>\n";

  if ($loginsuccess eq "Y") {

	my($curdir) = $FORM{"curdir"};
	my($taskdir) = "Main$curdir";
	
      print "           <TR bgColor=#99bcd8><TD colspan=2 align=left><font color=\"white\"><b>INFO</b></font></TD></TR>\n";
#      print "           <TR><TD colspan=2>$info</TD></TR>\n";
	  
	  
	  if (-e "$taskdir/index.html") 
	  {
			print "<tr><td colspan=2 align=left><iframe width=\"100%\" scrolling=\"auto\" frameborder=\"0\" src=\"$taskdir/index.html\"></iframe></td></tr>\n";
	  }
	  elsif (-e "$taskdir/index.htm") 
	  {
			print "<tr><td colspan=2 align=left><iframe width=\"100%\" scrolling=\"auto\" frameborder=\"0\" src=\"$taskdir/index.htm\"></iframe></td></tr>\n";
	  }	  
	  else
	  {
			print "<tr><td colspan=2 align=left><br></td></tr>\n";
	  }	  
	  
      print "       </TABLE>\n";
      print "       </FORM>\n";
      print "     </td>\n";
      print "     <td width=8><br></td>\n";
      print "     <TD valign=top bgColor=#dbe6e0>\n";
      print "       <TABLE cellSpacing=0 cellPadding=4 width=100% border=0>\n";    
    
	if ($FORM{"curdir"} eq "") {

		$curdirl = "Main";

	 	print "       <tr bgColor=#99bcd8><td colspan=3 width=100%><font color=\"white\">/Main</font></td></tr>\n";
	}
	else {

		$curdirl = "Main$FORM{\"curdir\"}";

		$_ = $FORM{"curdir"};
		s/\//\/<wbr>/g;
	 	print "       <tr bgColor=#99bcd8><td colspan=3 width=100%><font color=\"white\">/Main$_</font></td></tr>\n";

	}

	
	
	if ($curdir =~ /\/\.\./) {last;}	

	opendir(TASK, "$taskdir");
		@allfiles = readdir(TASK);
	closedir(TASK);

	@allfiles = sort @allfiles;
	
	find(\&sharedfolders, "Main");		
	
#	print @sharedfolders;

	foreach $filename (@allfiles)
	{
		next if ($filename eq ".");
		
		next if ($filename =~ /^\./ && $filename ne "..");

		next if (!($loginsuccess ne "N" || $filename eq ".."));
		
		my($usrpathfufg1) = 0;
		my(@usrpathfu1) = split(/,/, $usrpathf{$user});
	
		foreach $usrpathfu1 (@usrpathfu1)
		{	
			next if (!("$usrpathfu1\/" =~ /$curdirl\// && $usrpathfu1 ne "" || 
				   "$curdirl\/" =~ /$usrpathfu1\// && $usrpathfu1 ne ""));

			$usrpathfufg1 = 1;
			
			last;
		}
		
		my($usrpathfufg2) = 0;		
		
		foreach $usrpathfu2 (@usrpathfu1)
		{	
			next if (!("$curdirl\/" =~ /$usrpathfu2\// && $usrpathfu2 ne ""));
				
			$usrpathfufg2 = 1;
			last;
		}		

		my($usrpathfifg1) = 0;
		my(@usrpathfi1) = split(/,/, $usrpathf{$usrid});
		
		@usrpathfi1c = @usrpathfi1;
		
		@usrpathfi1 = (@usrpathfi1, @sharedfolders);		
	
		foreach $usrpathfi1 (@usrpathfi1)
		{
			next if (!("$curdirl\/" =~ /$usrpathfi1\// && $usrpathfi1 ne "" || 
				   "$usrpathfi1\/" =~ /$curdirl\// && $usrpathfi1 ne ""));

			$usrpathfifg1 = 1;

			last;
		}
		
		my($usrpathfifg2) = 0;		
		
		foreach $usrpathfi2 (@usrpathfi1c)
		{	
			next if (!("$curdirl\/" =~ /$usrpathfi2\// && $usrpathfi2 ne ""));
				
			$usrpathfifg2 = 1;
			last;
		}		

		next if ($usrpathfufg1 == 0 && $usrpathfifg1 == 0 && $filename ne "..");
		

#		next if (!($usrpathf{$user} =~ $curdirl && $usrpathf{$user} ne "" || 
#			   $curdirl =~ $usrpathf{$user}  && $usrpathf{$user} ne "" ||
#			   $curdirl =~ $usrpathf{$usrid}  && $usrpathf{$usrid} ne "" || 
#			   $usrpathf{$usrid} =~ $curdirl  && $usrpathf{$usrid} ne "" || $filename eq ".."));

		if ($filename eq "..") {
			@curdir1 = split(/\//, $curdir);
			pop(@curdir1);
			$curdir1 = join("/", @curdir1);			
					
			print "<tr><td colspan=1><a href=\"main2.cgi?curdir=$curdir1\"><img src=\"image/folderup.gif\" border=0></a>\n";
			print "<a href=\"main2.cgi?curdir=$curdir1\">$filename</a></td><td colspan=2 align=right>\n";
			print "<a href=\"javascript:history.go(0)\"><img src=\"image/refresh.gif\" title=\"refresh\" border=0></a> \n";
				
			if  (($usrtypef{$usrid} == 0 or $usrtypef{$usrid} == 1) && ($usrpathfufg2 == 1 or $usrpathfifg2 == 1)) {
				print "<a href=\"file2.cgi?curdir=$curdir&task=new&action=newnote\"><img src=\"image/hot_post_sticky.gif\" title=\"new note\" border=0></a> \n";			
				print "<a href=\"file2.cgi?curdir=$curdir&task=new&action=newfile\"><img src=\"image/new01.png\" title=\"new file\" border=0></a> \n";
				print "<a href=\"file2.cgi?curdir=$curdir&task=new&action=upfile\"><img src=\"image/upload.png\" title=\"upload file\" border=0></a> \n";				
				print "<a href=\"view2.cgi?curdir=$curdir&task=share&action=sharefolder\"><img src=\"image/shared.gif\" title=\"share folder\" border=0></a> \n"; 
				print "<a href=\"file2.cgi?curdir=$curdir&task=new&action=newfolder\"><img src=\"image/folder_new.png\" title=\"new folder\" border=0></a> \n";
				print "<a href=\"file2.cgi?curdir=$curdir&task=new&action=delfolder\"><img src=\"image/folder_del.png\" title=\"delete folder\" border=0></a>\n";
			}
			
			print "</td></tr>\n";
		}
		elsif (-d "$taskdir/$filename") {

			my($subdirl) = "$curdirl/$filename";

			my($usrpathfuflag) = 0;
			my(@usrpathfu) = split(/,/, $usrpathf{$user});
	
			foreach $usrpathfu (@usrpathfu)
			{
		
				next if (!("$usrpathfu\/" =~ /$subdirl\// && $usrpathfu ne "" || 
					   "$subdirl\/" =~ /$usrpathfu\// && $usrpathfu ne ""));

				$usrpathfuflag = 1;
				last;
			}

			my($usrpathfiflag) = 0;
			my(@usrpathfi) = split(/,/, $usrpathf{$usrid});
			
			@usrpathfi = (@usrpathfi, @sharedfolders);
	
			foreach $usrpathfi (@usrpathfi)
			{

				next if (!("$subdirl\/" =~ /$usrpathfi\// && $usrpathfi ne "" || 
					   "$usrpathfi\/" =~ /$subdirl\// && $usrpathfi ne ""));

				$usrpathfiflag = 1;
				last;
			}

			next if ($usrpathfuflag == 0 && $usrpathfiflag == 0);

# 			next if (!($usrpathf{$user} =~ $subdirl && $usrpathf{$user} ne "" || 
#				   $subdirl =~ $usrpathf{$user} && $usrpathf{$user} ne "" || 
#				   $subdirl =~ $usrpathf{$usrid} && $usrpathf{$usrid} ne "" || 
#				   $usrpathf{$usrid} =~ $subdirl && $usrpathf{$usrid} ne ""));

			next if (!(-r "$taskdir/$filename"));

#			open(DIR, "$taskdir/$filename") || &error;
#				my($zzdev, $zzino, $zzmode, $zznlink, $zzuid, $zzgid, $zzrdev, $zzsize, $zzatime, $zzmtime, $zzctime, $zzblksize, $zzblocks) = stat(DIR);		
#			close(DIR);
			
#			my($zysec, $zymin, $zyhour, $zyday, $zymon, $zyyear, $zywday, $zyyday, $zyisdst) = localtime($zzmtime);	

#			$zyyear =$zyyear%100;

#  			if ($zysec < 10) { $zysec = "0$zysec";}
#   			if ($zymin < 10) { $zymin = "0$zymin";}
#   			if ($zyhour < 10) { $zyhour = "0$zyhour";}
#   			if ($zyday < 10) { $zyday = "0$zyday";}
#			$zymon =$zymon + 1;
#   			if ($zymon < 10) { $zymon = "0$zymon";}
#   			if ($zyyear < 10) { $zyyear = "0$zyyear";}
	
#			print "<tr><td><a href=\"main2.cgi?curdir=$curdir/$filename\"><img src=\"../casper2/image/folder.gif\" border=0></a> <a href=\"main2.cgi?curdir=$curdir/$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";

			print "<tr><td><a href=\"main2.cgi?curdir=$curdir/$filename\"><img src=\"image/folder.gif\" border=0></a> <a href=\"main2.cgi?curdir=$curdir/$filename\">$filename</a></td><td align=right><br></td><td align=right><br></td></tr>\n";
			
		}
		else {
			next if (!(-r "$taskdir/$filename"));

			open(FLE, "$taskdir/$filename") || &error;
				my($zzdev, $zzino, $zzmode, $zznlink, $zzuid, $zzgid, $zzrdev, $zzsize, $zzatime, $zzmtime, $zzctime, $zzblksize, $zzblocks) = stat(FLE);		
			close(FLE);
			
			my($zysec, $zymin, $zyhour, $zyday, $zymon, $zyyear, $zywday, $zyyday, $zyisdst) = localtime($zzmtime);	

			$zyyear =$zyyear%100;

  			if ($zysec < 10) { $zysec = "0$zysec";}
   			if ($zymin < 10) { $zymin = "0$zymin";}
   			if ($zyhour < 10) { $zyhour = "0$zyhour";}
   			if ($zyday < 10) { $zyday = "0$zyday";}
			$zymon =$zymon + 1;
   			if ($zymon < 10) { $zymon = "0$zymon";}
   			if ($zyyear < 10) { $zyyear = "0$zyyear";}

			if ($filename =~ /\.spf$/i) {
				print "<tr><td><a href=\"ctrl2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/input.png\" border=0></a> <a href=\"ctrl2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}
			elsif ($filename =~ /\.log$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/log_icon.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 
			elsif ($filename =~ /\.txt$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/icon-text.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 
			elsif ($filename =~ /\.msg$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/hot_post_sticky.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 			
			elsif ($filename =~ /\.dat$/i || $filename =~ /\.data$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/objects067.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 			
			elsif ($filename =~ /\.out$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/icon-text.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 			
			elsif ($filename =~ /\.rout$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/icon-text.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 			
			elsif ($filename =~ /\.lst$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/icon-text.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 
			elsif ($filename =~ /\.htm$/i || $filename =~ /\.html$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/internet_explorer.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 
			elsif ($filename =~ /\.php$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/php.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 			
			elsif ($filename =~ /\.csv$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/csv.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 
			elsif ($filename =~ /\.xls$/i || $filename =~ /\.xlsx$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/xls.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 			
			elsif ($filename =~ /\.rtf$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/rtf2.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 
			elsif ($filename =~ /\.doc$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/word.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}
			elsif ($filename =~ /\.pdf$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/pdf.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}
			elsif ($filename =~ /\.sas$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/sasimg2.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}
			elsif ($filename =~ /\.sas7bdat$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/dataset.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}
			elsif ($filename =~ /\.r$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/r_blue.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}	
			elsif ($filename =~ /\.rpf$/i) {
				print "<tr><td><a href=\"ctrl2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/input.png\" border=0></a> <a href=\"ctrl2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}	
			elsif ($filename =~ /\.pl$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/perl.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}	
			elsif ($filename =~ /\.py$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/python.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}	
			elsif ($filename =~ /\.par$/i) {
				print "<tr><td><a href=\"ctrl2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/input.png\" border=0></a> <a href=\"ctrl2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}			
			elsif ($filename =~ /\.jpg$/i || $filename =~ /\.jpeg$/i || $filename =~ /\.png$/i || $filename =~ /\.gif$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/chart.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}
			elsif ($filename =~ /\.gz$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/gz.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}	
			elsif ($filename =~ /\.err$/i) {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/bug.png\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			}				
#			elsif ($filename =~ /\.cgi$/i || $filename =~ /\.pl$/i || $filename =~ /\.py$/i) {
#				print "<tr><td><img src=\"image/unknwfile.gif\" border=0> $filename</td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
#			} 			
			else {
				print "<tr><td><a href=\"view2.cgi?curdir=$curdir&task=$filename\"><img src=\"image/unknwfile.gif\" border=0></a> <a href=\"view2.cgi?curdir=$curdir&task=$filename\">$filename</a></td><td align=right>$zzsize</td><td align=right>$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec</td></tr>\n";
			} 
		}
	}
  }
  else {
      print "           <TR bgColor=#99bcd8><TD colspan=2 align=left><font color=\"white\"><b>INFO</b></font></TD></TR>\n";
      print "           <TR><TD colspan=2>$info</TD></TR>\n";

      print "       </TABLE>\n";
      print "       </FORM>\n";
      print "     </td>\n";
      print "     <td width=8><br></td>\n";
      print "     <TD valign=top bgColor=#dbe6e0>\n";
      print "       <TABLE cellSpacing=0 cellPadding=4 width=100% border=0>\n";  
  
	 	print "<tr bgColor=#99bcd8><td colspan=3 width=100%><font color=\"white\">Portal</font></td></tr>\n"; 
	 	print "<tr bgColor=#ddffdd><td colspan=2 width=50% align=left>\n";
	 	print "<FORM method=POST ACTION=\"main2.cgi\">\n";
	 	print "<INPUT TYPE=\"hidden\" NAME=\"USER\" VALUE=\"guest\">\n";
	 	print "<INPUT TYPE=\"hidden\" NAME=\"PASS\" VALUE=\"guest\">\n";
	 	print "<INPUT TYPE=\"submit\" name=\"action\" value=\"Take a Tour\">\n";
#	 	print "<INPUT TYPE=\"image\" src=\"image/feet.png\" ALT=\"submit\" name=\"action\" value=\"Take a Tour\"> Take a Tour!\n";
	 	print "</FORM>\n";	
		print "</td><td width=50% align=right valign=top><a title=\"shopify analytics\" href=\"http://statcounter.com/shopify/\" target=\"_blank\"><img src=\"//c.statcounter.com/11088640/0/4559fd98/0/\" alt=\"shopify analytics\" style=\"border:none;\"></a></td></tr>\n"; 		
		print "<tr><td colspan=3 width=100% align=center><iframe width=\"100%\" height=\"620\" scrolling=\"auto\" frameborder=\"0\" src=\"portal.html\"></iframe></td></tr>\n";
		
  }

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



