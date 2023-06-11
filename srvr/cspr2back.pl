#!c:\perl\bin\perl.exe
##
##  cspr -- Perl program that executes submitted sas jobs
##

use File::Copy;
use Fcntl;

#######################
# Handle Error

sub error {
   print "error... $! \n";
}

#######################
# Main Loop

while (1 == 1) {

	if (-e "cspr2.flg") {goto SLEEP;}

    open (LOCK, ">C:\\Apache\\htdocs\\casper2\\lock.xml") || die $!;

    if (flock(LOCK,2)) {

	open(TASKREAD, "C:\\Apache\\htdocs\\casper2\\task.xml") || die $!;

	@alltasks = <TASKREAD>;

	my($zzdev, $zzino, $zzmode, $zznlink, $zzuid, $zzgid, $zzrdev, $zzsize, $zzatime, $zzmtime, $zzctime, $zzblksize, $zzblocks) = stat(TASKREAD);
	
	my($zysec, $zymin, $zyhour, $zyday, $zymon, $zyyear, $zywday, $zyyday, $zyisdst) = localtime($zzmtime);	

	$zyyear =$zyyear%100;

  	if ($zysec < 10) { $zysec = "0$zysec";}
   	if ($zymin < 10) { $zymin = "0$zymin";}
   	if ($zyhour < 10) { $zyhour = "0$zyhour";}
   	if ($zyday < 10) { $zyday = "0$zyday";}
	$zymon =$zymon + 1;
   	if ($zymon < 10) { $zymon = "0$zymon";}
   	if ($zyyear < 10) { $zyyear = "0$zyyear";}

	close(TASKREAD);

	$basedir = "C:\\Apache\\htdocs\\casper2";

	open(TASK, ">$basedir\\task.xml") || die $!;

	my($linecount) = 0;
	my($taskflag) = 0;
	my($line1);

	foreach $line (@alltasks) {
	  		$linecount++;

	   	if ($linecount == 1) {
			$line1 = $line;
			chop($line);
			($taskcount, $user, $caller, $upath, $cmnd) = split(/:/,$line);

			$wpath = $upath;
			$wpath =~ tr/\//\\/;
			
			
			if ($cmnd =~ /R\.exe/) {
				($rexe, $rcmd, $rbatch, $rsave, $rrestore, $program, $printfile) = split(/ /,$cmnd); 			
			}
			elsif ($cmnd =~ /python\.exe/) {
				($pyexe, $program, $printfile, $errorfile) = split(/ /,$cmnd); 				
			}
			else {
				($sasexe, $noautoexec, $sysin, $program, $log, $logfile, $print, $printfile) = split(/ /,$cmnd); 
			}
			
			$taskflag = 1;
	   	}
	   	else {
			print TASK $line;
	   	}
	}
	close(TASK);

	if ($taskflag == 1) {

			open(BUSY, ">$basedir\\busy.xml") || die $!;
			print BUSY $line1;
        	close(BUSY);
				
			my ($tpath, $tprog) = $program =~ m|^(.*[\/])([^/\/]+?)$|;	
			
			$tprogram = "$tpath\.$tprog";
			
			$tprogram =~ tr/\//\\/;
			
			$program =~ tr/\//\\/;
			
			if ($caller eq "PAR") { 
				if ($cmnd =~ /R\.exe/) {
				
					my($chkflag) = 0;
					my(@chkfound) = ();
					my(@linescopy) = ();
					
					if (-e "$basedir$program") {
								
					  open(CHK, "$basedir$program") || &error;
					  
					  my(@lines) = <CHK>;					  
					  
					  @linescopy = @lines;
					
					  foreach $line (@lines)
					  {					
						if ($line =~ /^\s*system\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\s+system\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}		
						elsif ($line =~ /^\s*list\.dirs\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}						
						elsif ($line =~ /\s+list\.dirs\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /^\s*list\.files\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}						
						elsif ($line =~ /\s+list\.files\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
#						elsif ($line =~ /^\s*install\.packages\b/i) {
#								push(@chkfound, $line);
#								$chkflag = 1;
#						}						
#						elsif ($line =~ /\s+intsall\.packages\b/i) {
#								push(@chkfound, $line);
#								$chkflag = 1;
#						}	
						elsif ($line =~ /YaBB_2\.5\.2/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\b(main2|view2|task2|help2|file2|exec2|ctrl2|actn2|upld2|pswd2|rgst2|help2)\.cgi\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}						
						elsif ($line =~ /\bcspr2\.pl\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\bcsprfm\.php\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}							
						elsif ($line =~ /\bfile\.choose\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bchoose\.files\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bdir\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}		
						elsif ($line =~ /\bshell\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\bfile\.remove\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bfile\.copy\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bfile\.rename\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bfile\.append\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bfile\.symlink\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bfile\.link\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\bsource\s*\((.*)\burl\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bsource\s*\((.*)\bsocketConnection\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bsource\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}							
					
					  }	
 
					  close(CHK);
					  
					}										
					
					if ($chkflag == 1) {
						open(CLG, ">$basedir\\$wpath\\$printfile") || &error;	
						
						print CLG "Your code contains statements that may cause harm to the server, the task has been aborted.\n\n";
						print CLG "Details:\n\n";
						print CLG @chkfound;
						print CLG "\n";						
						
						close(CLG);
						
						goto ABORT;						
					}	
					elsif (!(-e "$basedir$program")) {
						open(CLG, ">$basedir\\$wpath\\$printfile") || &error;	
						
						print CLG "Program name $basedir$program specified in the .par file does not exist.\n\n";				
						
						close(CLG);
						
						goto ABORT;								
					}					
					else {
#						my($rpath) = "C:\\Program Files\\R\\R-2.14.0\\bin";		
						my($rpath) = "C:\\Program Files\\R\\R-3.5.2\\bin";								
						$cmndw = "\"$rpath\\$rexe\" $rcmd $rbatch $rsave $rrestore \"$basedir$program\" \"$basedir\\$wpath\\$printfile\"";							
					}				
			
				}
				elsif ($cmnd =~ /python\.exe/) {
				
					my($chkflag) = 0;
					my(@chkfound) = ();
					my(@linescopy) = ();					
					
					if (-e "$basedir$program") {
								
					  open(CHK, "$basedir$program") || &error;					  
					  
					  my(@lines) = <CHK>;				  
					  @linescopy = @lines;
			  		  
					  foreach $line (@lines)					  
					  {						
						if ($line =~ /YaBB_2\.5\.2/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\b(main2|view2|task2|help2|file2|exec2|ctrl2|actn2|upld2|pswd2|rgst2|help2)\.cgi\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}						
						elsif ($line =~ /\bcspr2\.pl\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\bcsprfm\.php\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bwalk\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\blistdir\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bscandir\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\bcopy_tree\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\brmtree\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\brmdir\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}	
						elsif ($line =~ /\bremove\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\brename\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\bunlink\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\bsubprocess\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\bpopen\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\bos\.system\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}	
						elsif ($line =~ /\bfrom\s+os\s+import\s+system\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}						
					  }	
 
					  close(CHK);
					  
					}			
										
					if (!(-e "$basedir$program")) {
										
						open(CLG, ">$basedir\\$wpath\\$errorfile") || &error;	
						
						print CLG "Program name $basedir$program specified in the .par file does not exist.\n\n";				
						
						close(CLG);
						
						goto ABORT;								
					}		
#					elsif (!(-e "$basedir$tprogram")) {
#						open(CLG, ">$basedir\\$wpath\\$errorfile") || &error;	
#						
#						print CLG "Program name $basedir$program specified in the .par file needs to be resaved before execution.\n\n";				
#						
#						close(CLG);
#					}
					elsif ($chkflag == 1) {
						open(CLG, ">$basedir\\$wpath\\$errorfile") || &error;	
						
						print CLG "Your code contains statements that may cause harm to the server, the task has been aborted.\n\n";
						print CLG "Details:\n\n";
						print CLG @chkfound;
						print CLG "\n";						
						
						close(CLG);
						
						goto ABORT;
					}						
					else {
						my($pypath) = "C:\\Users\\Dad\\AppData\\Local\\Programs\\Python\\Python37";	
						
						$basediru = $basedir;
						$basediru =~ tr/\\/\//;		
						
						$taskdirl = "$basediru/$upath";						

						$taskerrl = "$taskdirl\/$errorfile";												
						
						open(CHD, ">$basedir$tprogram") || &error;
						
						print CHD "import os\n";
						print CHD "import sys\n";	
						print CHD "os.chdir(\"$taskdirl\")\n";						
						print CHD "sys.stdin = open(\"nul\", \"r\")\n";
						print CHD "sys.stderr = open(\"$taskerrl\", \"w\")\n";							
						print CHD "sys.path.insert(0,\"$basediru\/srvr\")\n";
						print CHD "import parm\n\n";							
											
						print CHD @linescopy;
						
						close(CHD);							
						
						$cmndw = "\"$pypath\\$pyexe\" \"$basedir$tprogram\" > \"$basedir\\$wpath\\$printfile\"";					
					}				
			
				}				
				
				else {
				
					my($chkflag) = 0;
					my(@chkfound) = ();
					my(@linescopy) = ();				
					
					if (-e "$basedir$program") {					
								
					  open(CHK, "$basedir$program") || &error;
						
					  my(@lines) = <CHK>;				  
					  @linescopy = @lines;						
									
						foreach $line (@lines)
						{					
							if ($line =~ /^\s*x\s+(\'|\")/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}
							elsif ($line =~ /\s*;\s*x\s+(\'|\")/i) {							
								push(@chkfound, $line);
								$chkflag = 1;								
							}	
							elsif ($line =~ /\s*call\s+system\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;								
							}	
							elsif ($line =~ /\s*systask\s+/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
							}		
							elsif ($line =~ /\(\s*dopen\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}	
							elsif ($line =~ /=\s*dopen\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}	
							elsif ($line =~ /YaBB_2\.5\.2/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}								
							elsif ($line =~ /\b(main2|view2|task2|help2|file2|exec2|ctrl2|actn2|upld2|pswd2|rgst2|help2)\.cgi\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}															
							elsif ($line =~ /\bcspr2\.pl\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}		
							elsif ($line =~ /\bcsprfm\.php\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}								
						}	
					
						close(CHK);
					}	
					
					if ($chkflag == 1) {
						open(CLG, ">$basedir\\$wpath\\$logfile") || &error;	
						
						print CLG "Your code contains statements that may cause harm to the server, the task has been aborted.\n\n";
						print CLG "Details:\n\n";
						print CLG @chkfound;
						print CLG "\n";						
						
						close(CLG);
						
						goto ABORT;						
					}
					elsif (!(-e "$basedir$program")) {
						open(CLG, ">$basedir\\$wpath\\$logfile") || &error;	
						
						print CLG "Program name $basedir$program specified in the .par file does not exist.\n\n";				
						
						close(CLG);
						
						goto ABORT;								
					}					
					else {
					
#						my($spath) = "C:\\Program Files\\SASHome\\x86\\SASFoundation\\9.4";						
#						my($spath) = "C:\\Program Files\\SASHome2\\SASFoundation\\9.3";	
						my($spath) = "C:\\Program Files\\SASHome\\SASFoundation\\9.4";							
						
						open(CHD, ">$basedir$tprogram") || &error;
						print CHD "x 'chdir \"$basedir\\$wpath\"';\n\n";
						print CHD @linescopy;
						
						close(CHD);		

						$cmndw = "\"$spath\\$sasexe\" $noautoexec -noxwait -initstmt '%include \"parm.inc\";' $sysin $basedir$tprogram $log $basedir\\$wpath\\$logfile $print $basedir\\$wpath\\$printfile";		

						}							
				}
			}	
			else {
			
				if ($cmnd =~ /R\.exe/) {
				
					my($chkflag) = 0;
					my(@chkfound) = ();
					
					if (!(-e "$basedir$tprogram")) {				
						$chkflag = 2;
					}									
					else {
					
					  open(CHK, "$basedir$tprogram") || &error;
					
					  foreach $line (<CHK>)
					  {					
						if ($line =~ /^\s*system\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\s+system\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}		
						elsif ($line =~ /^\s*list\.dirs\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}						
						elsif ($line =~ /\s+list\.dirs\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /^\s*list\.files\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}						
						elsif ($line =~ /\s+list\.files\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}			
#						elsif ($line =~ /^\s*install\.packages\b/i) {
#								push(@chkfound, $line);
#								$chkflag = 1;
#						}						
#						elsif ($line =~ /\s+install\.packages\b/i) {
#								push(@chkfound, $line);
#								$chkflag = 1;
#						}	
						elsif ($line =~ /YaBB_2\.5\.2/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}							
						elsif ($line =~ /\b(main2|view2|task2|help2|file2|exec2|ctrl2|actn2|upld2|pswd2|rgst2|help2)\.cgi\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bcspr2\.pl\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bcsprfm\.php\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}							
						elsif ($line =~ /\bfile\.choose\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bchoose\.files\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bdir\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bshell\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bfile\.remove\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}							
						elsif ($line =~ /\bfile\.copy\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}				
						elsif ($line =~ /\bfile\.rename\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bfile\.append\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bfile\.symlink\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bfile\.link\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bsource\s*\((.*)\burl\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bsource\s*\((.*)\bsocketConnection\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\bsource\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}							
					  }	
					
					  close(CHK);
					}
					
					if ($chkflag == 2) {
						open(CLG, ">$basedir\\$wpath\\$printfile") || &error;							
						print CLG "Same task has appeared multiple times in the queue, only one is executed.\n\n";										
						close(CLG);		

						open(CHD, ">$basedir$tprogram") || &error;						
						print CHD "message (\"Error: Same task has appeared multiple times in the queue, this may cause conflict.\")\n";						

						close(CHD);		
						
						goto ABORT;								
						
					}
					elsif ($chkflag == 1) {
						open(CLG, ">$basedir\\$wpath\\$printfile") || &error;	
						
						print CLG "Your code contains statements that may cause harm to the server, the task has been aborted.\n\n";
						print CLG "Details:\n\n";
						print CLG @chkfound;
						print CLG "\n";						
						
						close(CLG);
						
						goto ABORT;						
					}
					else {
#						my($rpath) = "C:\\Program Files\\R\\R-2.14.0\\bin";		
						my($rpath) = "C:\\Program Files\\R\\R-3.5.2\\bin";	
						
						$cmndw = "\"$rpath\\$rexe\" $rcmd $rbatch $rsave $rrestore \"$basedir$tprogram\" \"$basedir\\$wpath\\$printfile\"";
					}				
				}
				elsif ($cmnd =~ /python\.exe/) {
				
					my($chkflag) = 0;
					my(@chkfound) = ();		

					if (!(-e "$basedir$tprogram")) {				
						$chkflag = 2;
					}						
					else {			
					  open(CHK, "$basedir$tprogram") || &error;
					  	
					  my(@lines) = <CHK>;
					  
					  @linescopy = @lines;
			  		  
					  foreach $line (@lines)
					  {		
						if ($line =~ /YaBB_2\.5\.2/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\b(main2|view2|task2|help2|file2|exec2|ctrl2|actn2|upld2|pswd2|rgst2|help2)\.cgi\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}						
						elsif ($line =~ /\bcspr2\.pl\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\bcsprfm\.php\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\bwalk\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}	
						elsif ($line =~ /\blistdir\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\bscandir\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
						}
						elsif ($line =~ /\bcopy_tree\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}	
						elsif ($line =~ /\brmtree\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\brmdir\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}	
						elsif ($line =~ /\bremove\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\brename\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\bunlink\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\bsubprocess\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\bpopen\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}
						elsif ($line =~ /\bos\.system\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}	
						elsif ($line =~ /\bfrom\s+os\s+import\s+system\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
						}							
					  }	
					
					  close(CHK);
					}
					
					if ($chkflag == 2) {
						open(CLG, ">$basedir\\$wpath\\$errorfile") || &error;							
						print CLG "Same task has appeared multiple times in the queue, only one is executed.\n\n";										
						close(CLG);	
						
						goto ABORT;		
						
					}					
					elsif ($chkflag == 1) {
						open(CLG, ">$basedir\\$wpath\\$errorfile") || &error;	
						
						print CLG "Your code contains statements that may cause harm to the server, the task has been aborted.\n\n";
						print CLG "Details:\n\n";
						print CLG @chkfound;
						print CLG "\n";						
						
						close(CLG);
						
						goto ABORT;
					}
					else {					
						my($pypath) = "C:\\Users\\Dad\\AppData\\Local\\Programs\\Python\\Python37";	
												
						$basediru = $basedir;
						$basediru =~ tr/\\/\//;		
						
						$taskdirl = "$basediru/$upath";						

						$taskerrl = "$taskdirl\/$errorfile";												
						
						open(CHD, ">$basedir$tprogram") || &error;
						
						print CHD "import os\n";
						print CHD "import sys\n";	
						print CHD "os.chdir(\"$taskdirl\")\n";						
						print CHD "sys.stdin = open(\"nul\", \"r\")\n";
						print CHD "sys.stderr = open(\"$taskerrl\", \"w\")\n";							
						print CHD "sys.path.insert(0,\"$basediru\/srvr\")\n";
						print CHD "import parm\n\n";							
											
						print CHD @linescopy;
						
						close(CHD);								
												
						$cmndw = "\"$pypath\\$pyexe\" \"$basedir$tprogram\" > \"$basedir\\$wpath\\$printfile\"";
					}
					
				}											
				else {
				
					my($chkflag) = 0;
					my(@chkfound) = ();
					my(@linescopy) = ();
					
					if (!(-e "$basedir$tprogram")) {				
						$chkflag = 2;
					}						
					else {			
					  open(CHK, "$basedir$tprogram") || &error;
					
					  my(@lines) = <CHK>;
					  
					  @linescopy = @lines;
										
					  foreach $line (@lines)
					  {					
							if ($line =~ /^\s*x\s+(\'|\")/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}
							elsif ($line =~ /\s*;\s*x\s+(\'|\")/i) {							
								push(@chkfound, $line);
								$chkflag = 1;								
							}	
							elsif ($line =~ /\s*call\s+system\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;								
							}	
							elsif ($line =~ /\s*systask\s+/i) {
								push(@chkfound, $line);
								$chkflag = 1;									
							}						
							elsif ($line =~ /\(\s*dopen\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}	
							elsif ($line =~ /=\s*dopen\s*\(/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}	
							elsif ($line =~ /YaBB_2\.5\.2/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}								
							elsif ($line =~ /\b(main2|view2|task2|help2|file2|exec2|ctrl2|actn2|upld2|pswd2|rgst2|help2)\.cgi\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}						
							elsif ($line =~ /\bcspr2\.pl\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}	
							elsif ($line =~ /\bcsprfm\.php\b/i) {
								push(@chkfound, $line);
								$chkflag = 1;
							}	
							
					  }	
					
					  close(CHK);	
					}						
					
					if ($chkflag == 2) {
						open(CLG, ">$basedir\\$wpath\\$logfile") || &error;							
						print CLG "Same task has appeared multiple times in the queue, only one is executed.\n\n";										
						close(CLG);	

						goto ABORT;		
						
					}						
					elsif ($chkflag == 1) {
						open(CLG, ">$basedir\\$wpath\\$logfile") || &error;	
						
						print CLG "Your code contains statements that may cause harm to the server, the task has been aborted.\n\n";
						print CLG "Details:\n\n";
						print CLG @chkfound;
						print CLG "\n";						
						
						close(CLG);
						
						goto ABORT;						
					}
					else {
					
#						my($spath) = "C:\\Program Files\\SASHome\\x86\\SASFoundation\\9.4";	
#						my($spath) = "C:\\Program Files\\SASHome2\\SASFoundation\\9.3";	
						my($spath) = "C:\\Program Files\\SASHome\\SASFoundation\\9.4";							
						
						open(CHD, ">$basedir$tprogram") || &error;
						print CHD "x 'chdir \"$basedir\\$wpath\"';\n\n";
						print CHD @linescopy;
						close(CHD);		
						
						$cmndw = "\"$spath\\$sasexe\" $noautoexec -noxwait -initstmt '%include \"parm.inc\";' $sysin $basedir$tprogram $log $basedir\\$wpath\\$logfile $print $basedir\\$wpath\\$printfile";

					}
				}			
			}
			
			move("$basedir\\parm$taskcount.xml", "parm.inc");
			
			if ($cmnd =~ /python\.exe/) {
				move("parm.inc", "parm.py");			
			}

			flock(LOCK, 8);
    			close (LOCK);

#			print "execute $cmndw\n";	
				
			system($cmndw);
			
			ABORT: 			
			
			if (-e "$basedir$tprogram") {							
				unlink "$basedir$tprogram";	
			}

			if (-e ".RData") {
				unlink ".RData";
			}

			if (-e "parm.inc") {
				unlink "parm.inc";
			}
			
			if (-e "parm.py") {
				unlink "parm.py";
			}		

			if ($cmnd =~ /python\.exe/) {			
				if (-e "$basedir\\$wpath\\$errorfile") {	
					my($errsize) = -s "$basedir\\$wpath\\$errorfile";
					if ($errsize == 0) {
						unlink "$basedir\\$wpath\\$errorfile";
					}
				}
				if (-e "$basedir\\$wpath\\$printfile") {	
					my($prnsize) = -s "$basedir\\$wpath\\$printfile";
					if ($prnsize == 0) {
						unlink "$basedir\\$wpath\\$printfile";
					}
				}					
			}			

			open(HIST, ">>$basedir\\hist.xml") || die $!;
			print HIST "$zyyear-$zymon-$zyday $zyhour:$zymin:$zysec $user:/$upath> $cmnd\n";
			close(HIST);

			if (-e "$basedir\\busy.xml") {
				unlink "$basedir\\busy.xml";
			}
		}
		else {
			flock(LOCK, 8);
    			close (LOCK);
		}

  	}
	else {
    		close (LOCK);
	}

	SLEEP: 
	
	sleep(5);

}
