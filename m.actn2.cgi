#!c:\perl\bin\perl.exe
##
##  exec2.cgi -- create task.xml and parm.xml to be executed by cspr2.pl
##

use File::Path;
use File::Spec;
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


	my($curdir) = $FORM{"curdir"};
	my($taskdir) = "Main$curdir";
	
	$taskdir =~ tr/\//\\/;

	$task = $FORM{"task"};
	$action = $FORM{"action"};
	
	my($safe_filename_characters) = "a-zA-Z0-9_.-";		
		
    if ($action eq "delfile") {
	    $delfile = "$basedir$taskdir\\$task";
		$delattr = "$basedir$taskdir\\\.attr\.$task";
		
		if (-e $delfile) {
			unlink $delfile || die $!;
			
			if (-e $delattr) {
				unlink $delattr || die $!;
			}
			
			print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>The file has been deleted</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";	
		
		}
		else{			
			print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>The file does not exist</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";			
		}
	}
    elsif ($action eq "delfolder") {
	    $delfolder = "$basedir$taskdir";
	
		if (-e $delfolder) {
			
			opendir DDR, $delfolder;

			my ($emptyfolder) = 1;
			
			while(my $entry = readdir DDR) {
#				next if($entry =~ /^\.\.?$/);
				next if($entry =~ /^\./);
				$emptyfolder = 0;
			}
			closedir DDR;
			
			if ($emptyfolder == 1) {
			
				@curdir1 = split(/\//, $curdir);
				$thisfolder = pop(@curdir1);
				$curdir1 = join("/", @curdir1);	
				
			    rmtree $delfolder;
				
				print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>The folder $thisfolder has been deleted</b></font></td></tr>\n";
				print "<tr><td>Choose one of the following:</td></tr>\n";
				print "<tr>\n";		
				print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir1\">return to previous directory</a></h3></td>\n";
				print "</tr>\n";
			}
			else {
				print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>The folder is not empty, delete unsuccessful</b></font></td></tr>\n";
				print "<tr><td>Choose one of the following:</td></tr>\n";
				print "<tr>\n";		
				print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
				print "</tr>\n";			
			}
		
		}
		else{			
			print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>The folder does not exist</b></font></td></tr>\n";
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";			
		}
	}	
	elsif ($action eq "copyfile") {
	
			my($copyname) = $FORM{"copyname"};
			
			my($ext) = $task =~ /(\.[^.]+)$/;
			
			if ($copyname =~ /\// || $copyname =~ /\\/){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File can only be copied in the same directory, please try again.</b></font></td></tr>\n";
			}
			elsif ($copyname =~ /\s/){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name cannot contain whitespace characters, please try again.</b></font></td></tr>\n";
			}	
			elsif (!($copyname =~ /^([$safe_filename_characters]+)$/)) {
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name contains invalid characters, please try again.</b></font></td></tr>\n";				
			}
			elsif ($copyname eq $task){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name is the same as original, please try again.</b></font></td></tr>\n";
			}	
			elsif (!($copyname =~ /$ext$/i)) {
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File type must be same as original, please try again</b></font></td></tr>\n";
			}				
			else {
					copy("$taskdir\\$task", "$taskdir\\$copyname") || &error;
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File copyed</b></font></td></tr>\n";		
			}
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";				
	}
	elsif ($action eq "renamefile") {
		
			my($targetname) = $FORM{"targetname"};
			
			my($ext) = $task =~ /(\.[^.]+)$/;
								
			if ($targetname =~ /\// || $targetname =~ /\\/){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File can only be renamed in the same directory, please try again.</b></font></td></tr>\n";
			}
			elsif ($targetname =~ /\s/){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name cannot contain whitespace characters, please try again.</b></font></td></tr>\n";
			}	
			elsif (!($targetname =~ /^([$safe_filename_characters]+)$/)) {
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name contains invalid characters, please try again.</b></font></td></tr>\n";				
			}
			elsif (!($targetname =~ /$ext$/i)) {
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File type must be same as original, please try again</b></font></td></tr>\n";
			}			
			else {
					move("$taskdir\\$task", "$taskdir\\$targetname") || &error;
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File renamed</b></font></td></tr>\n";		
			}
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";				
	}		
	elsif ($action eq "movefile") {
	
			my($userdir) = "$basedir\Main\\Users\\$usrid";
		
			my($targetfolder) = "$taskdir\\$FORM{\"targetfolder\"}";
			
			my($tfreal) = File::Spec->rel2abs($targetfolder);			
					
			if (!(-e $tfreal && -d $tfreal)) {
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>Target folder does not exist, please try again.</b></font></td></tr>\n";
			}
			elsif (index(lc($tfreal),lc($userdir)) == -1) {			
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>Target folder is out of bound, please try again.</b></font></td></tr>\n";
			}
			else {
					move("$taskdir\\$task", $tfreal) || &error;
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File moved to target folder</b></font></td></tr>\n";		
			}
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";				
	}		
	elsif ($action eq "newfile") {
	
			my($newfilename) = $FORM{"newfilename"};
			
			if ($newfilename =~ /\// || $newfilename =~ /\\/){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File can only be created in the same directory, please try again.</b></font></td></tr>\n";
			}	
			elsif ($newfilename =~ /\s/){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name cannot contain whitespace characters, please try again.</b></font></td></tr>\n";
			}
			elsif (!($newfilename =~ /^([$safe_filename_characters]+)$/)) {
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name contains invalid characters, please try again.</b></font></td></tr>\n";				
			}				
			elsif ($newfilename =~ /\.php$/i || $newfilename =~ /\.cgi$/i || $newfilename =~ /\.pl$/i || $newfilename =~ /\.exe$/i)	{		
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>you have no permission to create this file type.</b></font></td></tr>\n";
			}				
			elsif (-e "$basedir$taskdir\\$newfilename") {
				print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File $newfilename already exists</b></font></td></tr>\n";			
			}
			else {
				(open FILE, ">$basedir$taskdir\\$newfilename") || die $!;
				close FILE;
				print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File $newfilename created</b></font></td></tr>\n";
			}			
			
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";				
	}
	elsif ($action eq "newnote") {
	
			my($newnotename) = $FORM{"newnotename"};
			
			if ($newnotename =~ /\// || $newnotename =~ /\\/){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File can only be created in the same directory, please try again.</b></font></td></tr>\n";
			}	
			elsif ($newnotename =~ /\s/){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name cannot contain whitespace characters, please try again.</b></font></td></tr>\n";
			}			
			elsif (!($newnotename =~ /^([$safe_filename_characters]+)$/)) {
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name contains invalid characters, please try again.</b></font></td></tr>\n";				
			}				
			elsif (!($newnotename =~ /\.msg$/i)){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File name must end with .msg, please try again.</b></font></td></tr>\n";
			}				
			elsif (-e "$basedir$taskdir\\$newnotename") {
				print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File $newnotename already exists</b></font></td></tr>\n";			
			}
			else {
				(open FILE, ">$basedir$taskdir\\$newnotename") || die $!;
				close FILE;
				print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>File $newnotename created</b></font></td></tr>\n";
			}			
			
			print "<tr><td>Choose one of the following:</td></tr>\n";
			print "<tr>\n";		
			print "<td><h3><a href=\"m.main2.cgi?curdir=$curdir\">return to previous directory</a></h3></td>\n";
			print "</tr>\n";				
	}	
	elsif ($action eq "newfolder") {
	
			my($newfoldername) = $FORM{"newfoldername"};
			
			if ($newfoldername =~ /\// || $newfoldername =~ /\\/){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>Folder can only be created in the same directory, please try again.</b></font></td></tr>\n";
			}	
			elsif ($newfoldername =~ /\s/){
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>Folder name cannot contain whitespace characters, please try again.</b></font></td></tr>\n";
			}			
			elsif (!($newfoldername =~ /^([$safe_filename_characters]+)$/)) {
					print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>Folder name contains invalid characters, please try again.</b></font></td></tr>\n";				
			}					
			elsif (-e "$basedir$taskdir\\$newfoldername") {
				print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>Folder $newfoldername already exists</b></font></td></tr>\n";			
			}
			else {
				mkdir "$basedir$taskdir\\$newfoldername";
				print "<tr bgColor=#99bcd8><td width=100%><font color=\"white\"><b>Folder $newfoldername created</b></font></td></tr>\n";
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



