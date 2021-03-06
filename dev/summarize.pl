#!/usr/bin/env perl

BEGIN {
    use Fcntl ':flock';
    our $SEMAPHOREFH;
    exit 1 unless(open($SEMAPHOREFH, "<$0"));
    exit 1 unless(flock($SEMAPHOREFH, LOCK_EX|LOCK_NB));
}

require "CGI.pm";
require "../curl.pm";
require "ccwarn.pm";

opendir(DIR, "inbox");
my @logs = grep { /^build.*log$/ } readdir(DIR);
closedir(DIR);

my $prefix ="table";
my $tprefix ="tmptable";

my %combo;
my $buildnum;

my $onlydo = 600; # limit the amount of log parsings to this amount

my $file = "${tprefix}.t";

open(TABLE, ">$file");

sub tabletop {
    my ($date)=@_;

    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/) {
        ($year, $month, $day) = ($1, $2, $3);
    }

    print TABLE stitle("$year-$month-$day");
    print TABLE join("",
                     "<table cellspacing=\"0\" class=\"compile\" width=\"100%\"><tr>",
                     "<th>Time</th>",
                     "<th>Test</th>",
                     "<th>Warn</th>",
                     "<th>Options</th>",
                     "<th>Description</th>",
                     "<th>Name</th>",
                     "</tr>\n");
}

sub tablebot() {
    print TABLE "</table>\n";
}

sub summary {
    open(SUM, ">summary.t");

    printf SUM ("<p>%d builds during %d days provided by %d persons with %d different OS+option combinations\n",
                $buildnum,
                scalar(@logs),
                scalar(keys %who),
                scalar(keys %oscombocount));

    printf SUM ("<p> The average build gave %d warnings and ran %d tests. %d builds (%d%%) built warning-free.\n",
                $totalwarn/$buildnum, $totalfine/($buildnum-$totallink),
                $warnfree, $warnfree*100/$buildnum);

    printf SUM ("<p> %d builds (%d%%) failed to link, %d builds (%d%%) failed one or more tests, %d builds ran no tests",
                $totallink,
                $totallink*100/$buildnum,
                $totalfail,
                $totalfail*100/$buildnum,
                $untestedtotal);

    printf SUM ("<p><table><tr valign=\"top\"><td><b>%d option combos</b><br>\n",
                scalar(keys %combo));

    foreach $cb (sort {$combo{$b} <=> $combo{$a}} keys %combo) {
        printf SUM ("%s<span class=\"mini\">%s</span></a> %d times<br>\n",
                    $combolink{$cb}?$combolink{$cb}:"<a>",
                    $cb,
                    $combo{$cb});
    }
    printf SUM "<td><td><b>%d host combos</b>\n", scalar(keys %oses);
    foreach $os (sort {$oses{$b} <=> $oses{$a}} keys %oses) {
        printf SUM ("<p>%s<span class=\"mini\">%s</span></a> %d times\n",
                    $oslink{$os}?$oslink{$os}:"<a>",
                    $os,
                    $oses{$os});
        my $cb = $oscombo{$os};
        foreach $s (sort {$oscombo{$os}{$b} <=> $oscombo{$os}{$a}} keys %$cb) {
            printf SUM ("<br><span class=\"mini\">$s</span> %d times\n",
                        $oscombo{$os}{$s});
        }
    }

    print SUM "</td></tr></table>\n";
    close(SUM);
}

&initwarn();

my @data;

if(!@logs) {
    print TABLE "No build logs available at this time";
}
else {
    @data = "";
    for(reverse sort @logs) {
        my $f="inbox/$_";
        print STDERR "Parse $f ($onlydo left)\n";
        my $sz = -s $f;
        if($sz < 1000) {
            print STDERR " - only $sz bytes, skip it\n";
            next;
        }

        if ( -s "$f.out") {
            open(IN, "<$f.out");
            my @in = <IN>;
            close(IN);

            # make it a single line
            @data = join("", @in);
        }
        else {
            singlefile("$f");
            open(OUT, ">$f.out");
            print OUT @data;
            close(OUT);
        }
        push @more, @data;
        @data = "";
        if(!$onlydo--) {
            last;
        }
    }
    #summary(); - does not yet work with the quick method

    @data = @more;

    my $prevdate;
    if(@data) {
        my $i;
        for(reverse sort @data) {
            my ($lyear, $lmonth, $lday);
            my $l = $_;
            my $class= $i&1?"even":"odd";
            if(s/<tr>/<tr class=\"$class\">/) {
                $i++;
            }
            if($l =~ /\<\!-- (\d\d\d\d)(\d\d)(\d\d)/) {
                ($lyear, $lmonth, $lday) = ($1, $2, $3);
            }
            else {
                next;
            }
            
            if("$lyear$lmonth$lday" ne $prevdate) {
                if($prevdate) {
                    tablebot();
                }
                tabletop("$lyear$lmonth$lday");
            }
            
            $prevdate ="$lyear$lmonth$lday";
            
            print TABLE $_;
        }
        tablebot();
    }

    close(TABLE);
}

# rename outputs to their final names
print STDERR "rename $tprefix.t => $prefix.t\n";
rename "$tprefix.t", "$prefix.t";

exit 0;

my $warning=0;

sub endofsingle {
    my ($file) = @_; # the single build file name

    my $escname = CGI::escape($name);
    my $escdate = CGI::escape($date);

    my $libver;
    my $sslver;
    my $zlibver;
    my $ipv6="-";
    my $krb4="-";
    my $zlib="-";
    my $gss="-";
    my $idn="-";

    if($libcurl =~ /libcurl\/([^ ]*)/) {
        $libver = $1;
    }
    if($libcurl =~ /OpenSSL\/([^ ]*)/i) {
        $openssl = 1;
        $sslver = $1;
        $ssl = 1;
    }
    if($libcurl =~ /WinSSL/i) {
        $schannel = 1;
        $ssl = 1;
    }
    if($libcurl =~ /zlib\/([^ ]*)/i) {
        $zlibver = $1;
    }
    if($libcurl =~ /libidn\/([^ ]*)/i) {
        $libidn = $1;
    }
    if($libcurl =~ /libssh2\/([^ ]*)/i) {
        $libssh2 = $1;
    }
    if($krb4enabled) {
        $krb4 = "K";
    }
    if($ipv6enabled) {
        $ipv6 = "6";
    }
    if($gssapi) {
        $gss = "G";
    }
    if($libidn) {
        $idn = "I";
    }
    if($zlibver || $libz) {
        $zlib = "Z";
    }

    $showdate = $date;
   # $showdate =~ s/2003//g;
   # $showdate =~ s/(GMT|UTC|Mon|Tue|Wed|Thu|Fri|Sat|Sun)//ig;
    $showdate =~ s/.*(\d\d):(\d\d):(\d\d).*/$1:$2/;
    if (!$showdate) {
        $showdate ='--:--';
    }

    # prefer the date from the actual log file, it might have been from
    # another day
    $logdate=`date --utc --date "$date" "+%Y-%m-%d" 2>/dev/null`;
    if($logdate =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/) {
        ($lyear, $lmonth, $lday) = ($1, $2, $3);
    }
    else {
        ($lyear, $lmonth, $lday) = ($year, $month, $day);
    }

    my $a;
    if($buildid =~ /^(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)-(\d+)/) {
        my ($byear, $bmon, $bday, $bhour, $bmin, $bsec, $bpid)=
            ($1, $2, $3, $4, $5, $6, $7);
        $a = "<a href=\"log.cgi?id=$buildid\">";
    }
    else {
        $a = "<a href=\"#internal-error\">";
    }

    my $res = join("",
                   "<!-- $lyear$lmonth$lday $showdate --><tr>\n",
                   "<td>$a$showdate</a></td>\n");
    if($fail || !$linkfine || !$fine || $nospaceleft) {
        $res .= "<td class=\"buildfail\">";
        if($nospaceleft) {
            $res .= "no&nbsp;space";
        }
        elsif(!$linkfine) {
            if($cvsfail) {
                $res .= "CVS";
            }
            elsif(!$buildconf) {
                $res .= "buildconf";
            }
            elsif($configure) {
                # true if configure failed
                $res .= "configure";
            }
            else {
                $totallink++;
                $res .= "link";
            }
        }
        elsif($fail) {
            $res .= $failamount;
            $totalfail++;
        }
        else {
            $res .= "fail";
        }
        $res .= "</td>\n";
    }
    else {
        $totalfine += $testfine;
        if(0 == $testfine) {
            $untestedtotal++;
        }
        $testfine = 0 + $testfine; # to force it numeric
        $res .= "<td class=\"buildfine\">$testfine";

        if($skipped) {
            #$res .= "+$skipped";
        }
        $res .= "</td>\n";
    }

    my $sfail="";
    if(keys %serverfail) {
        $sfail = sprintf("<span class='buildserverprob'>%s</a>",
                         join(", ", keys %serverfail));
    }
    $totalwarn += $warning;
    if($warning>0) {
        $res .= "<td class=\"buildfail\">$warning</td>";
    }
    else {
        $warnfree++;
        $res .= "<td>0</td>\n";
    }
    undef %serverfail;

    $showdebug=($debug?"D":"-").($trackmem?"M":"-").($valgrind?"V":"-");
    $https=($openssl)?"S":($gnutls?"T":($nss?"N":($polarssl?"O":($axtls?"X":($schannel?"L":($darwinssl?"R":"-"))))));
    my $showres=($asynch)?($ares?"A":"H"):"-";
    $sspi=$sspi?"P":"-";
    my $ssh=$libssh2?"2":"-";
    my $metalink=$libmetalink?"E":"-";

    my $o = "$krb4$ipv6$showdebug$https$showres$zlib$gss$idn$sspi$ssh$metalink";

    if(!$desc) {
        $desc = $os;
    }

    $res .= "<td class=\"mini\">$o</td>\n<td>$desc $sfail</td>\n<td>$name</td></tr>\n";

    $combo{$o}++;
    $desc{$desc}++;
    $who{$name}++;
    if(!$os) {
        $os="unknown";
    }
    if(!$oslink{$os}) {
        # the first one we found for this OS, preserve link
        $oslink{$os}=$a;
    }
    if(!$combolink{$o}) {
        # the first one we found for this optioncombo, preserve link
        $combolink{$o}=$a;
    }
    $oses{$os}++;
    $oscombo{$os}{$o}++;
    $oscombocount{$os.$o}++;

    $buildnum++;

    $fail=$name=$email=$desc=$date=$libcurl=$uname="";
    $fine=0;
    $testfine=0;
    $linkfine=0;
    $warning=0;
    $skipped=0;
    $buildconf=0;
    $configure=0;
    $debug=0;
    $trackmem=0;
    $valgrind=0;

    $openssl=$gnutls=$nss=$axtls=$polarssl=$schannel=$darwinssl=0;

    $libmetalink=0;
    $libssh2=0;
    $ssl=0;
    $cvsfail=0;
    $nospaceleft=0;
    $asynch=0;
    $ares=0;
    $sspi=0;
    $buildid="";
    $failamount=0;
    $ipv6enabled=0;
    $krb4enabled=0;
    $gssapi=0;
    $os="";
    $libidn=0;
    $libz=0;

    return $res;
}

my $state =0;
sub singlefile {
    my ($file) = @_;

    if($file =~ /.*(\d\d\d\d)-(\d\d)-(\d\d)/) {
        ($year, $month, $day) = ($1, $2, $3);
    }

    chmod 0644, $file;

    open(READ, "<$file");
    while(my $line = <READ>) {
        chomp $line;

 #       print "L: $state - $line\n";
        if($line =~ /^INPIPE: startsingle here ([0-9-]*)/) {
            $buildid = $1;
            print STDERR " - build $buildid\n";
        }
        # we don't check for state here to allow this to abort all
        # states
        elsif($line =~ /^testcurl: STARTING HERE/) {
            # mail headers here
            if($state) {
                push @data, endofsingle($file);
            }
            $state = 2;
        }
        elsif($state &&
              ($line =~ /^(INPIPE: endsingle here|testcurl: ENDING HERE)/) ) {
            # detect end of test in all states
            # mail headers here
            push @data, endofsingle($file);
            $state = 0;
        }
        elsif((2 == $state)) {
            # this is testcurl output
            if($line =~ /^testcurl: NAME = (.*)/) {
                $name = $1;
            }
            elsif($line =~ /^testcurl: EMAIL = (.*)/) {
                $email = $1;
            }
            elsif($line =~ /^testcurl: DESC = (.*)/) {
                $desc = $1;
            }
            elsif($line =~ /^testcurl: CONFOPTS = (.*)/) {
                my $confopts = $1;
                if($confopts =~ /--enable-debug/) {
                    $debug=1;
                }
            }
            elsif($line =~ /^testcurl: date = (.*)/) {
                $date = $1;
            }
            elsif($line =~ /^NOTICE:.*cross-compiling/) {
                $fail = 0;
                $fine = 1;
            }
            elsif($line =~ /^TESTFAIL: These test cases failed: (.*)/) {
                $fail = $1;
            }
            elsif($line =~ /^TESTDONE: (\d*) tests out of (\d*)/) {
                $testfine = 0 + $1;
                my $numtests= $2;
                if($numtests <= 0) {
                    # no tests performed, but we are fine with it
                    $testfine = 0;
                    $fine = 1;
                }
                elsif($numtests > $testfine) {
                    $failamount = ($numtests - $testfine);
                }
                else {
                    # no failures, we are coool
                    $fine = 1;
                }
            }
            elsif($line =~ /^TESTINFO: (\d*) tests were skipped/) {
                $skipped = $1;
            }
            elsif($line =~ /\) (libcurl\/.*)/) {
                $libcurl = $1;
            }
            elsif($line =~ /SKIPPED: failed starting (.*) server/) {
                $serverfail{$1}++;
            }
            elsif(($line =~ /No space left on device/) ||
                  ($line =~ /cat: Cannot write to output/) ||
                  ($line =~ /ld: I\/O error/)) {
                $nospaceleft=1;
            }
            elsif(checkwarn($line)) {
                $warning++;
            }
            elsif($line =~ /^testcurl: failed to update from CVS/) {
                $cvsfail=1;
            }
            elsif($line =~ /^testcurl: configure created/) {
                $buildconf=1;
            }
            elsif($line =~ /^testcurl: configure didn\'t work/) {
                $configure=1;
            }
            elsif($line =~ /^testcurl:.*curl was created fine/) {
                $linkfine=1;
            }
            elsif($line =~ /^\* debug build: *(ON|OFF) *track memory: *(ON|OFF)/) {
                $debug = ($1 eq "ON") ? 1 : 0;
                $trackmem = ($2 eq "ON") ? 1 : 0;
            }
            elsif($line =~ /^\* System: *(.*)/) {
                $uname = $1;
            }
            elsif($line =~ /^\* Server SSL: *(ON|OFF) *libcurl SSL: *(ON|OFF)/) {
                $ssl = ($2 eq "ON") ? 1 : 0;
            }
            elsif($line =~ /^\* valgrind: *(ON|OFF) *HTTP IPv6 *(ON|OFF)/) {
                $valgrind = ($1 eq "ON") ? 1 : 0;
            }
            elsif($line =~ /^supported_features(.*)AsynchDNS/) {
                $asynch = 1;
            }
            elsif($line =~ /^\#define USE_ARES 1/) {
                $asynch = 1;
                $ares = 1;
            }
            elsif($line =~ /^\#define USE_WINDOWS_SSPI 1/) {
                $sspi = 1;
            }
            elsif($line =~ /^\#define USE_SSLEAY 1/) {
                $openssl = 1;
            }
            elsif($line =~ /^\#define USE_GNUTLS 1/) {
                $gnutls = 1;
            }
            elsif($line =~ /^\#define USE_AXTLS 1/) {
                $axtls = 1;
            }
            elsif($line =~ /^\#define USE_POLARSSL 1/) {
                $polarssl = 1;
            }
            elsif($line =~ /^\#define USE_NSS 1/) {
                $nss = 1;
            }
            elsif($line =~ /^\#define USE_SCHANNEL 1/) {
                $schannel = 1;
            }
            elsif($line =~ /^\#define USE_DARWINSSL 1/) {
                $darwinssl = 1;
            }
            elsif($line =~ /^\#define USE_LIBSSH2 1/) {
                $libssh2 = 1;
            }
            elsif($line =~ /^\#define USE_METALINK 1/) {
                $libmetalink = 1;
            }
            elsif($line =~ /^\#define ENABLE_IPV6 1/) {
                $ipv6enabled = 1;
            }
            elsif($line =~ /^\#define HAVE_KRB4 1/) {
                $krb4enabled = 1;
            }
            elsif($line =~ /^\#define HAVE_GSSAPI 1/) {
                $gssapi=1;
            }
            elsif($line =~ /^\#define HAVE_LIBIDN 1/) {
                $libidn=1;
            }
            elsif($line =~ /^\#define HAVE_LIBZ 1/) {
                $libz=1;
            }
            elsif($line =~ /^\#define OS \"([^\"]*)\"/) {
                $os=$1;
            }
            elsif($line =~ /^Features: (.*)/) {
                my $feat = $1;
                if($feat =~ /Debug/i) {
                    $debug = 1;
                }
                if($feat =~ /AsynchDNS/i) {
                    $asynch = 1;
                }
                if($feat =~ /GSS-Negotiate/i) {
                    $gssapi = 1;
                }
                if($feat =~ /IDN/i) {
                    $libidn = $1;
                }
                if($feat =~ /IPv6/i) {
                    $ipv6enabled = 1;
                }
                if($feat =~ /SSPI/i) {
                    $sspi = 1;
                }
                if($feat =~ /libz/i) {
                    $libz = 1;
                }
                if($feat =~ /Metalink/i) {
                    $libmetalink = 1;
                }
            }
            if($line =~ / -DDEBUGBUILD /) {
                $debug=1;
            }
            if($line =~ / -DCURLDEBUG /) {
                $trackmem=1;
            }
        }
    }
    if($state) {
        # only for error-cases
        push @data, endofsingle($file);
    }
    close(READ);
}
