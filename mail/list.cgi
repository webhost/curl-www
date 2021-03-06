#!/usr/bin/perl

require "../date.pm";
require "../curl.pm";
require CGI;

$req = new CGI;

my $list = $req->param('list');

print "Content-Type: text/html\n\n";

sub showarchs {
    my ($num, @dirs) = @_;

    my %years;

    if($num > 0) {
        while(scalar(@dirs) > $num) {
            shift @dirs;
        }
    }

    for(@dirs) {
        if($_ =~ /(\d\d\d\d)-(\d\d)/) {
            $years{$1}=1;
        }
    }

    @syears = sort { $b <=> $a } keys %years;
    
    print "<table cellspacing=\"3\">\n";
    if(0) {
        my @he =('Year', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
    
        print "<tr> ";
        for(@he) {
            print "<th>$_</th> ";
        }
        print "</tr>\n";
    }

    for(@syears) {
        my $year=$_;
        my $pr=0;
        my $mon;

        print "<tr><td><b>$year</b></td>\n";

        foreach $m (01 .. 12) {
            my $mon = sprintf("%02d", $m);
            my $f;
            foreach $d (@dirs) {
                if($d =~ /$year-$mon$/) {
                    $f=$d;
                    last;
                }
            }
            if($f) {
                print "<td><a href=\"$f/\">".substr(&MonthNameEng($mon), 0, 3)."</a></td>\n";
            }
            else {
                print "<td>&nbsp;</td>";
            }
        }
        print "</tr>\n";
    }
    print "</table>\n";

}

sub curlmain {
    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^archive-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

    if($num <= 0 ) {
        print "<b>1999</b>\n";

        print " <a href=\"archive_pre_oct_99/\">Aug - Sep</a>\n",
        " <a href=\"archive/\">Oct - Dec</a>",
        "\n";
    }

    return "http://cool.haxx.se/mailman/listinfo/curl-users";
}


sub libcurl {
    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^lib-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

    # return subscription URL
    return "http://cool.haxx.se/mailman/listinfo/curl-library";
}

sub curlphp {

    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^curlphp-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

    # return subscription URL
    return "http://cool.haxx.se/mailman/listinfo/curl-and-php";
}

sub curlpython {

    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^curlpython-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

    # return subscription URL
    return "http://cool.haxx.se/mailman/listinfo/curl-and-python";
}

sub curltracker {

    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^tracker-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

    # return subscription URL
    return "http://cool.haxx.se/mailman/listinfo/curl-tracker";
}

sub curlpp {

    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^curlpp-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

    # return subscription URL
    return "http://groups.google.com/group/curlpp";
}

sub curlppdev {

    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^curlppdev-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

    # return subscription URL
    return "http://groups.google.com/group/curlpp-devel";
}


if($list) {
    my $subscr;
    my $none;

    &header("The $list Mailing List");

    &where("Mailing Lists", "http://curl.haxx.se/mail/", "$list archive");

    &title("The $list Mailing List Archives");

print <<MOO
<div class="relatedbox">
<b>Related:</b>
<br><a href="/mail/etiquette.html">Mailing List Etiquette</a>
</div>

MOO
    ;

    if(($list eq "curl-main") ||
       ($list eq "curl-users")) {
        $subscr = curlmain();
    }
    elsif($list eq "curl-library") {
        $subscr = libcurl();
    }
    elsif($list eq "curl-and-php") {
        $subscr = curlphp();
    }
    elsif($list eq "curl-and-python") {
        $subscr = curlpython();
    }
    elsif($list eq "curl-tracker") {
        $subscr = curltracker();
    }
    elsif($list eq "curlpp") {
        $subscr = curlpp();
    }
    elsif($list eq "curlpp-devel") {
        $subscr = curlppdev();
    }
    elsif(($list eq "curl-announce") ||
          ($list eq "curl-www-commits") ||
          ($list eq "curl-commits")) {
        $subscr = "http://cool.haxx.se/cgi-bin/mailman/listinfo/$list";
        print "There is no archive of this list.";
        $none=1;
    }
    else {
        print "$list? Are you playing with me? There's no such list!";
        $none=1;
    }

    if(!$none) {
print <<MOO
<p>
This is a web archive of mails posted to the <b>$list</b> mailing list.
MOO
;
}

    if($subscr) {
        &subtitle("Subscribe to $list");
        print "<p> <a href=\"$subscr\">subcribe to $list</a>";
    }

    &title("Other Mailing List Archives");

    my @archs=('curl-users',
               'curl-library',
               'curl-and-php',
               'curl-and-python',
               'curl-tracker',
               'curlpp',
               'curlpp-devel');

    my $n;
    for(@archs) {
        my $this=$_;
        if($list ne $this) {
            printf("%s<a href=\"list.cgi?list=$this\">$this</a>",
                   $n?", ":"");
            $n++;
        }
    }

    &title("Search This Site");

    &catfile("../sitesearch.t");

    &catfile("../foot.html");
    print "</body></html>\n";
    exit;
}


&catfile("mail.html");
&catfile("../foot.html");

