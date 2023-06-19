#!/usr/local/bin/perl
##
##  cron -- Perl program that executes cron jobs
##

$basedir = $ARGV[0];

open(DIR, "/usr/bin/find /Apache/htdocs/Casper2/Main -name '*.par' |");
@dir = sort <DIR>;
close(DIR);

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

$year =$year%100;
if ($mday < 10) { $mday = "0$mday";}
$mon =$mon + 1;
if ($mon < 10) { $mon = "0$mon";}
if ($year < 10) { $year = "0$year";}

open (LOG, ">/usr/bin/find /Apache/htdocs/Casper2/cronlog/cron$year$mon$mday.log") || die $!;

foreach $spf (@dir) {

    chop($spf);
 
    open (PAR, "$par") || die $!;
    @par = <PAR>;
    close (PAR);

    foreach $line (@par) {

	($wwwid, $wwwlabel, $wwwtype, $wwwname, $wwwvalue, $wwwsize, $wwwbreak) = split(/\|/, $line);

	if ($wwwtype eq "text" && $wwwname eq "cron" ) {

	    @wwwcron = split(/,/, $wwwvalue);

	    foreach $cronday (@wwwcron) {

		if ($cronday == $mday) {
 			
            	    open (PAR, ">parm.xml");

	            print PAR "%let usrid=admin;\n";
	            print PAR "%let usremail=admin\@batchsubmit.com;\n";

		    foreach $line2 (@par) {

			($wwwid, $wwwlabel, $wwwtype, $wwwname, $wwwvalue, $wwwsize, $wwwbreak) = split(/\|/, $line2);

	    		if ($wwwtype eq "hidden" && $wwwname eq "program") {
			    $program = $wwwvalue;
	    		}

	    		if ($wwwtype eq "text") {
			    if ($wwwname =~ m/^parm/i) {
		   	 	print PAR "%let $wwwname=$wwwvalue;\n";	
			    }
	    		}

	    		if ($wwwtype eq "select" || $wwwtype eq "radio") {

			    @wwwoptions = split(/:/, $wwwvalue);

   			    foreach $wwwoption (@wwwoptions) {

				if ($wwwoption =~ /#/) {
				    $wwwoption =~ s/#//;
				    print PAR "%let $wwwname=$wwwoption;\n";
				};				
			    }

	 		}
		    }

 		    close(PAR);

		    $_ = $par;
		    s/par/log/;
		    $tasklog = $_;

		    $_ = $par;
	   	    s/par/txt/;
		    $tasktxt = $_;

		    system("/usr/local/bin/sas -9.1.4 -noterminal -sysin /$basedir/html/departments/cdm/casper/program/$program -log $tasklog -print $tasktxt");

		    print LOG "$par\n";	

		    if (-e "parm.xml") {
			unlink "parm.xml";
		    }

		    sleep(10);
 		}
	    }
	}

	if ($wwwtype eq "text" && $wwwname eq "cronwk" ) {

	    @wwwcron = split(/,/, $wwwvalue);

	    foreach $cronday (@wwwcron) {

		if ($cronday == $wday) {
 			
            	    open (PAR, ">parm.xml");

	            print PAR "%let usrid=admin;\n";
	            print PAR "%let usremail=admin\@batchsubmit.com;\n";

		    foreach $line2 (@par) {

			($wwwid, $wwwlabel, $wwwtype, $wwwname, $wwwvalue, $wwwsize, $wwwbreak) = split(/\|/, $line2);

	    		if ($wwwtype eq "hidden" && $wwwname eq "program") {
			    $program = $wwwvalue;
	    		}

	    		if ($wwwtype eq "text") {
			    if ($wwwname =~ m/^parm/i) {
		   	 	print PAR "%let $wwwname=$wwwvalue;\n";	
			    }
	    		}

	    		if ($wwwtype eq "select" || $wwwtype eq "radio") {

			    @wwwoptions = split(/:/, $wwwvalue);

   			    foreach $wwwoption (@wwwoptions) {

				if ($wwwoption =~ /#/) {
				    $wwwoption =~ s/#//;
				    print PAR "%let $wwwname=$wwwoption;\n";
				};				
			    }

	 		}
		    }

 		    close(PAR);

		    $_ = $par;
		    s/par/log/;
		    $tasklog = $_;

		    $_ = $par;
	   	    s/par/txt/;
		    $tasktxt = $_;

		    system("/usr/local/bin/sas -9.1.4 -noterminal -sysin /$basedir/html/departments/cdm/casper/program/$program -log $tasklog -print $tasktxt");

		    print LOG "$spf\n";	

		    if (-e "parm.xml") {
			unlink "parm.xml";
		    }

		    sleep(10);
 		}
	    }
	}

    }
}

close (LOG);
