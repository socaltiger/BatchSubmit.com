#!/usr/local/bin/perl
##
##  cron -- Perl program that executes cron jobs
##

$basedir = $ARGV[0];

open(DIR, "/usr/bin/find /$basedir/html/departments/cdm/casper/home -name '*.spf' |");
@dir = sort <DIR>;
close(DIR);

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

$year =$year%100;
if ($mday < 10) { $mday = "0$mday";}
$mon =$mon + 1;
if ($mon < 10) { $mon = "0$mon";}
if ($year < 10) { $year = "0$year";}

open (LOG, ">/$basedir/html/departments/cdm/casper/cronlog/cron$year$mon$mday.log") || die $!;

foreach $spf (@dir) {

    chop($spf);
 
    open (SPF, "$spf") || die $!;
    @spf = <SPF>;
    close (SPF);

    foreach $line (@spf) {

	($wwwid, $wwwlabel, $wwwtype, $wwwname, $wwwvalue, $wwwsize, $wwwbreak) = split(/\|/, $line);

	if ($wwwtype eq "text" && $wwwname eq "cron" ) {

	    @wwwcron = split(/,/, $wwwvalue);

	    foreach $cronday (@wwwcron) {

		if ($cronday == $mday) {
 			
            	    open (PAR, ">parm.xml");

	            print PAR "%let usrid=mickeyc;\n";
	            print PAR "%let usremail=mickeyc\@amgen.com;\n";

		    foreach $line2 (@spf) {

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

		    $_ = $spf;
		    s/spf/log/;
		    $tasklog = $_;

		    $_ = $spf;
	   	    s/spf/txt/;
		    $tasktxt = $_;

		    system("/usr/local/bin/sas -9.1.3 -noterminal -sysin /$basedir/html/departments/cdm/casper/program/$program -log $tasklog -print $tasktxt");

		    print LOG "$spf\n";	

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

	            print PAR "%let usrid=mickeyc;\n";
	            print PAR "%let usremail=mickeyc\@amgen.com;\n";

		    foreach $line2 (@spf) {

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

		    $_ = $spf;
		    s/spf/log/;
		    $tasklog = $_;

		    $_ = $spf;
	   	    s/spf/txt/;
		    $tasktxt = $_;

		    system("/usr/local/bin/sas -9.1.3 -noterminal -sysin /$basedir/html/departments/cdm/casper/program/$program -log $tasklog -print $tasktxt");

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
