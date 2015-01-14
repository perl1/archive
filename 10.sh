#! /bin/sh

# Make a new directory for the perl sources, cd to it, and run kits 1
# thru 10 through sh.  When all 10 kits have been run, read README.

echo "This is perl 1.0 kit 10 (of 10).  If kit 10 is complete, the line"
echo '"'"End of kit 10 (of 10)"'" will echo at the end.'
echo ""
export PATH || (echo "You didn't use sh, you clunch." ; kill $$)
mkdir t 2>/dev/null
mkdir x2p 2>/dev/null
echo Extracting x2p/s2p.man
sed >x2p/s2p.man <<'!STUFFY!FUNK!' -e 's/X//'
X.rn '' }`
X''' $Header: s2p.man,v 1.0 87/12/18 17:37:16 root Exp $
X''' 
X''' $Log:        s2p.man,v $
X''' Revision 1.0  87/12/18  17:37:16  root
X''' Initial revision
X''' 
X''' 
X.de Sh
X.br
X.ne 5
X.PP
X\fB\\$1\fR
X.PP
X..
X.de Sp
X.if t .sp .5v
X.if n .sp
X..
X.de Ip
X.br
X.ie \\n.$>=3 .ne \\$3
X.el .ne 3
X.IP "\\$1" \\$2
X..
X'''
X'''     Set up \*(-- to give an unbreakable dash;
X'''     string Tr holds user defined translation string.
X'''     Bell System Logo is used as a dummy character.
X'''
X.tr \(bs-|\(bv\*(Tr
X.ie n \{\
X.ds -- \(bs-
X.if (\n(.H=4u)&(1m=24u) .ds -- \(bs\h'-12u'\(bs\h'-12u'-\" diablo 10 pitch
X.if (\n(.H=4u)&(1m=20u) .ds -- \(bs\h'-12u'\(bs\h'-8u'-\" diablo 12 pitch
X.ds L" ""
X.ds R" ""
X.ds L' '
X.ds R' '
X'br\}
X.el\{\
X.ds -- \(em\|
X.tr \*(Tr
X.ds L" ``
X.ds R" ''
X.ds L' `
X.ds R' '
X'br\}
X.TH S2P 1 NEW
X.SH NAME
Xs2p - Sed to Perl translator
X.SH SYNOPSIS
X.B s2p [options] filename
X.SH DESCRIPTION
X.I S2p
Xtakes a sed script specified on the command line (or from standard input)
Xand produces a comparable
X.I perl
Xscript on the standard output.
X.Sh "Options"
XOptions include:
X.TP 5
X.B \-D<number>
Xsets debugging flags.
X.TP 5
X.B \-n
Xspecifies that this sed script was always invoked with a sed -n.
XOtherwise a switch parser is prepended to the front of the script.
X.TP 5
X.B \-p
Xspecifies that this sed script was never invoked with a sed -n.
XOtherwise a switch parser is prepended to the front of the script.
X.Sh "Considerations"
XThe perl script produced looks very sed-ish, and there may very well be
Xbetter ways to express what you want to do in perl.
XFor instance, s2p does not make any use of the split operator, but you might
Xwant to.
X.PP
XThe perl script you end up with may be either faster or slower than the original
Xsed script.
XIf you're only interested in speed you'll just have to try it both ways.
XOf course, if you want to do something sed doesn't do, you have no choice.
X.SH ENVIRONMENT
XS2p uses no environment variables.
X.SH AUTHOR
XLarry Wall <lw...@jpl-devvax.Jpl.Nasa.Gov>
X.SH FILES
X.SH SEE ALSO
Xperl        The perl compiler/interpreter
X.br
Xa2p        awk to perl translator
X.SH DIAGNOSTICS
X.SH BUGS
X.rn }` ''
!STUFFY!FUNK!
echo Extracting stab.h
sed >stab.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: stab.h,v 1.0 87/12/18 13:06:18 root Exp $
X *
X * $Log:        stab.h,v $
X * Revision 1.0  87/12/18  13:06:18  root
X * Initial revision
X * 
X */
X
Xstruct stab {
X    struct stab *stab_next;
X    char        *stab_name;
X    STR                *stab_val;
X    struct stio *stab_io;
X    FCMD        *stab_form;
X    ARRAY        *stab_array;
X    HASH        *stab_hash;
X    CMD                *stab_sub;
X    char        stab_flags;
X};
X
X#define SF_VMAGIC 1                /* call routine to dereference STR val */
X
Xstruct stio {
X    FILE        *fp;
X    long        lines;
X    long        page;
X    long        page_len;
X    long        lines_left;
X    char        *top_name;
X    STAB        *top_stab;
X    char        *fmt_name;
X    STAB        *fmt_stab;
X    char        type;
X    char        flags;
X};
X
X#define IOF_ARGV 1        /* this fp iterates over ARGV */
X#define IOF_START 2        /* check for null ARGV and substitute '-' */
X#define IOF_FLUSH 4        /* this fp wants a flush after write op */
X
X#define Nullstab Null(STAB*)
X
X#define STAB_STR(s) (tmpstab = (s), tmpstab->stab_flags & SF_VMAGIC ? stab_str(tmpstab) : tmpstab->stab_val)
X#define STAB_GET(s) (tmpstab = (s), str_get(tmpstab->stab_flags & SF_VMAGIC ? stab_str(tmpstab) : tmpstab->stab_val))
X#define STAB_GNUM(s) (tmpstab = (s), str_gnum(tmpstab->stab_flags & SF_VMAGIC ? stab_str(tmpstab) : tmpstab->stab_val))
X
XEXT STAB *tmpstab;
X
XEXT STAB *stab_index[128];
X
XEXT char *envname;        /* place for ENV name being assigned--gross cheat */
XEXT char *signame;        /* place for SIG name being assigned--gross cheat */
X
XEXT int statusvalue;
XEXT int subsvalue;
X
XSTAB *aadd();
XSTAB *hadd();
!STUFFY!FUNK!
echo Extracting makedir.SH
sed >makedir.SH <<'!STUFFY!FUNK!' -e 's/X//'
Xcase $CONFIG in
X'')
X    if test ! -f config.sh; then
X        ln ../config.sh . || \
X        ln ../../config.sh . || \
X        ln ../../../config.sh . || \
X        (echo "Can't find config.sh."; exit 1)
X    fi
X    . config.sh
X    ;;
Xesac
Xcase "$0" in
X*/*) cd `expr X$0 : 'X\(.*\)/'` ;;
Xesac
Xecho "Extracting makedir (with variable substitutions)"
X$spitshell >makedir <<!GROK!THIS!
X$startsh
X# $Header: makedir.SH,v 1.0 87/12/18 13:05:32 root Exp $
X# 
X# $Log:        makedir.SH,v $
X# Revision 1.0  87/12/18  13:05:32  root
X# Initial revision
X# 
X# Revision 4.3.1.1  85/05/10  11:35:14  lwall
X# Branch for patches.
X# 
X# Revision 4.3  85/05/01  11:42:31  lwall
X# Baseline for release with 4.3bsd.
X# 
X
Xexport PATH || (echo "OOPS, this isn't sh.  Desperation time.  I will feed myself to sh."; sh \$0; kill \$\$)
X
Xcase \$# in
X  0)
X    $echo "makedir pathname filenameflag"
X    exit 1
X    ;;
Xesac
X
X: guarantee one slash before 1st component
Xcase \$1 in
X  /*) ;;
X  *)  set ./\$1 \$2 ;;
Xesac
X
X: strip last component if it is to be a filename
Xcase X\$2 in
X  X1) set \`$echo \$1 | $sed 's:\(.*\)/[^/]*\$:\1:'\` ;;
X  *)  set \$1 ;;
Xesac
X
X: return reasonable status if nothing to be created
Xif $test -d "\$1" ; then
X    exit 0
Xfi
X
Xlist=''
Xwhile true ; do
X    case \$1 in
X    */*)
X        list="\$1 \$list"
X        set \`echo \$1 | $sed 's:\(.*\)/:\1 :'\`
X        ;;
X    *)
X        break
X        ;;
X    esac
Xdone
X
Xset \$list
X
Xfor dir do
X    $mkdir \$dir >/dev/null 2>&1
Xdone
X!GROK!THIS!
X$eunicefix makedir
Xchmod 755 makedir
!STUFFY!FUNK!
echo Extracting t/cmd.subval
sed >t/cmd.subval <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: cmd.subval,v 1.0 87/12/18 13:12:12 root Exp $
X
Xsub foo1 {
X    'true1';
X    if ($_[0]) { 'true2'; }
X}
X
Xsub foo2 {
X    'true1';
X    if ($_[0]) { 'true2'; } else { 'true3'; }
X}
X
Xsub foo3 {
X    'true1';
X    unless ($_[0]) { 'true2'; }
X}
X
Xsub foo4 {
X    'true1';
X    unless ($_[0]) { 'true2'; } else { 'true3'; }
X}
X
Xsub foo5 {
X    'true1';
X    'true2' if $_[0];
X}
X
Xsub foo6 {
X    'true1';
X    'true2' unless $_[0];
X}
X
Xprint "1..12\n";
X
Xif (do foo1(0) eq '') {print "ok 1\n";} else {print "not ok 1\n";}
Xif (do foo1(1) eq 'true2') {print "ok 2\n";} else {print "not ok 2\n";}
Xif (do foo2(0) eq 'true3') {print "ok 3\n";} else {print "not ok 3\n";}
Xif (do foo2(1) eq 'true2') {print "ok 4\n";} else {print "not ok 4\n";}
X
Xif (do foo3(0) eq 'true2') {print "ok 5\n";} else {print "not ok 5\n";}
Xif (do foo3(1) eq '') {print "ok 6\n";} else {print "not ok 6\n";}
Xif (do foo4(0) eq 'true2') {print "ok 7\n";} else {print "not ok 7\n";}
Xif (do foo4(1) eq 'true3') {print "ok 8\n";} else {print "not ok 8\n";}
X
Xif (do foo5(0) eq '') {print "ok 9\n";} else {print "not ok 9\n";}
Xif (do foo5(1) eq 'true2') {print "ok 10\n";} else {print "not ok 10\n";}
Xif (do foo6(0) eq 'true2') {print "ok 11\n";} else {print "not ok 11\n";}
Xif (do foo6(1) eq '') {print "ok 12\n";} else {print "not ok 12\n";}
!STUFFY!FUNK!
echo Extracting t/TEST
sed >t/TEST <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: TEST,v 1.0 87/12/18 13:11:34 root Exp $
X
X# This is written in a peculiar style, since we're trying to avoid
X# most of the constructs we'll be testing for.
X
Xif ($ARGV[0] eq '-v') {
X    $verbose = 1;
X    shift;
X}
X
Xif ($ARGV[0] eq '') {
X    @ARGV = split(/[ \n]/,`echo base.* comp.* cmd.* io.* op.*`);
X}
X
X$bad = 0;
Xwhile ($test = shift) {
X    print "$test...";
X    open(results,"$test|") || (print "can't run.\n");
X    $ok = 0;
X    while (<results>) {
X        if ($verbose) {
X            print $_;
X        }
X        unless (/^#/) {
X            if (/^1\.\.([0-9]+)/) {
X                $max = $1;
X                $next = 1;
X                $ok = 1;
X            } else {
X                if (/^ok (.*)/ && $1 == $next) {
X                    $next = $next + 1;
X                } else {
X                    $ok = 0;
X                }
X            }
X        }
X    }
X    $next = $next - 1;
X    if ($ok && $next == $max) {
X        print "ok\n";
X    } else {
X        $next += 1;
X        print "FAILED on test $next\n";
X        $bad = $bad + 1;
X        $_ = $test;
X        if (/^base/) {
X            die "Failed a basic test--cannot continue.";
X        }
X    }
X}
X
Xif ($bad == 0) {
X    if ($ok) {
X        print "All tests successful.\n";
X    } else {
X        die "FAILED--no tests were run for some reason.";
X    }
X} else {
X    if ($bad == 1) {
X        die "Failed 1 test.";
X    } else {
X        die "Failed $bad tests.";
X    }
X}
X($user,$sys,$cuser,$csys) = times;
Xprint sprintf("u=%g  s=%g  cu=%g  cs=%g\n",$user,$sys,$cuser,$csys);
!STUFFY!FUNK!
echo Extracting t/op.list
sed >t/op.list <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.list,v 1.0 87/12/18 13:13:50 root Exp $
X
Xprint "1..11\n";
X
X@foo = (1, 2, 3, 4);
Xif ($foo[0] == 1 && $foo[3] == 4) {print "ok 1\n";} else {print "not ok 1\n";}
X
X$_ = join(foo,':');
Xif ($_ eq '1:2:3:4') {print "ok 2\n";} else {print "not ok 2\n";}
X
X($a,$b,$c,$d) = (1,2,3,4);
Xif ("$a;$b;$c;$d" eq '1;2;3;4') {print "ok 3\n";} else {print "not ok 3\n";}
X
X($c,$b,$a) = split(/ /,"111 222 333");
Xif ("$a;$b;$c" eq '333;222;111') {print "ok 4\n";} else {print "not ok 4\n";}
X
X($a,$b,$c) = ($c,$b,$a);
Xif ("$a;$b;$c" eq '111;222;333') {print "ok 5\n";} else {print "not ok 5\n";}
X
X($a, $b) = ($b, $a);
Xif ("$a;$b;$c" eq '222;111;333') {print "ok 6\n";} else {print "not ok 6\n";}
X
X($a, $b[1], $c{2}, $d) = (1, 2, 3, 4);
Xif ($a eq 1) {print "ok 7\n";} else {print "not ok 7\n";}
Xif ($b[1] eq 2) {print "ok 8\n";} else {print "not ok 8\n";}
Xif ($c{2} eq 3) {print "ok 9\n";} else {print "not ok 9\n";}
Xif ($d eq 4) {print "ok 10\n";} else {print "not ok 10\n";}
X
X@foo = (1,2,3,4,5,6,7,8);
X($a, $b, $c, $d) = @foo;
Xprint "#11        $a;$b;$c;$d eq 1;2;3;4\n";
Xif ("$a;$b;$c;$d" eq '1;2;3;4') {print "ok 11\n";} else {print "not ok 11\n";}
!STUFFY!FUNK!
echo Extracting t/io.tell
sed >t/io.tell <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: io.tell,v 1.0 87/12/18 13:13:02 root Exp $
X
Xprint "1..13\n";
X
Xopen(tst, '../Makefile') || (die "Can't open ../Makefile");
X
Xif (eof(tst)) { print "not ok 1\n"; } else { print "ok 1\n"; }
X
X$firstline = <tst>;
X$secondpos = tell;
X
X$x = 0;
Xwhile (<tst>) {
X    if (eof) {$x++;}
X}
Xif ($x == 1) { print "ok 2\n"; } else { print "not ok 2\n"; }
X
X$lastpos = tell;
X
Xunless (eof) { print "not ok 3\n"; } else { print "ok 3\n"; }
X
Xif (seek(tst,0,0)) { print "ok 4\n"; } else { print "not ok 4\n"; }
X
Xif (eof) { print "not ok 5\n"; } else { print "ok 5\n"; }
X
Xif ($firstline eq <tst>) { print "ok 6\n"; } else { print "not ok 6\n"; }
X
Xif ($secondpos == tell) { print "ok 7\n"; } else { print "not ok 7\n"; }
X
Xif (seek(tst,0,1)) { print "ok 8\n"; } else { print "not ok 8\n"; }
X
Xif (eof) { print "not ok 9\n"; } else { print "ok 9\n"; }
X
Xif ($secondpos == tell) { print "ok 10\n"; } else { print "not ok 10\n"; }
X
Xif (seek(tst,0,2)) { print "ok 11\n"; } else { print "not ok 11\n"; }
X
Xif ($lastpos == tell) { print "ok 12\n"; } else { print "not ok 12\n"; }
X
Xunless (eof) { print "not ok 13\n"; } else { print "ok 13\n"; }
!STUFFY!FUNK!
echo Extracting search.h
sed >search.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: search.h,v 1.0 87/12/18 13:06:06 root Exp $
X *
X * $Log:        search.h,v $
X * Revision 1.0  87/12/18  13:06:06  root
X * Initial revision
X * 
X */
X
X#ifndef MAXSUB
X#define        MAXSUB        10                /* how many sub-patterns are allowed */
X#define MAXALT        10                /* how many alternatives are allowed */
X 
Xtypedef struct {        
X    char *precomp;                /* the original pattern, for debug output */
X    char *compbuf;                /* the compiled pattern */
X    int complen;                /* length of compbuf */
X    char *alternatives[MAXALT];        /* list of alternatives */
X    char *subbeg[MAXSUB];        /* subpattern start list */
X    char *subend[MAXSUB];        /* subpattern end list */
X    char *subbase;                /* saved match string after execute() */
X    char lastparen;                /* which subpattern matched last */
X    char numsubs;                /* how many subpatterns the compiler saw */
X    bool do_folding;                /* fold upper and lower case? */
X} COMPEX;
X
XEXT int multiline INIT(0);
X
Xvoid        search_init();
Xvoid        init_compex();
Xvoid        free_compex();
Xchar        *getparen();
Xvoid        case_fold();
Xchar        *compile(); 
Xvoid        grow_comp();
Xchar        *execute(); 
Xbool        try();
Xbool        subpat(); 
Xbool        cclass(); 
X#endif
!STUFFY!FUNK!
echo Extracting hash.h
sed >hash.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: hash.h,v 1.0 87/12/18 13:05:20 root Exp $
X *
X * $Log:        hash.h,v $
X * Revision 1.0  87/12/18  13:05:20  root
X * Initial revision
X * 
X */
X
X#define FILLPCT 60                /* don't make greater than 99 */
X
X#ifdef DOINIT
Xchar coeff[] = {
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1};
X#else
Xextern char coeff[];
X#endif
X
Xtypedef struct hentry HENT;
X
Xstruct hentry {
X    HENT        *hent_next;
X    char        *hent_key;
X    STR                *hent_val;
X    int                hent_hash;
X};
X
Xstruct htbl {
X    HENT        **tbl_array;
X    int                tbl_max;
X    int                tbl_fill;
X    int                tbl_riter;        /* current root of iterator */
X    HENT        *tbl_eiter;        /* current entry of iterator */
X};
X
XSTR *hfetch();
Xbool hstore();
Xbool hdelete();
XHASH *hnew();
Xint hiterinit();
XHENT *hiternext();
Xchar *hiterkey();
XSTR *hiterval();
!STUFFY!FUNK!
echo Extracting x2p/hash.h
sed >x2p/hash.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: hash.h,v 1.0 87/12/18 13:07:23 root Exp $
X *
X * $Log:        hash.h,v $
X * Revision 1.0  87/12/18  13:07:23  root
X * Initial revision
X * 
X */
X
X#define FILLPCT 60                /* don't make greater than 99 */
X
X#ifdef DOINIT
Xchar coeff[] = {
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1,
X                61,59,53,47,43,41,37,31,29,23,17,13,11,7,3,1};
X#else
Xextern char coeff[];
X#endif
X
Xtypedef struct hentry HENT;
X
Xstruct hentry {
X    HENT        *hent_next;
X    char        *hent_key;
X    STR                *hent_val;
X    int                hent_hash;
X};
X
Xstruct htbl {
X    HENT        **tbl_array;
X    int                tbl_max;
X    int                tbl_fill;
X    int                tbl_riter;        /* current root of iterator */
X    HENT        *tbl_eiter;        /* current entry of iterator */
X};
X
XSTR *hfetch();
Xbool hstore();
Xbool hdelete();
XHASH *hnew();
Xint hiterinit();
XHENT *hiternext();
Xchar *hiterkey();
XSTR *hiterval();
!STUFFY!FUNK!
echo Extracting t/op.time
sed >t/op.time <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.time,v 1.0 87/12/18 13:14:33 root Exp $
X
Xprint "1..5\n";
X
X($beguser,$begsys) = times;
X
X$beg = time;
X
Xwhile (($now = time) == $beg) {}
X
Xif ($now > $beg && $now - $beg < 10){print "ok 1\n";} else {print "not ok 1\n";}
X
Xfor ($i = 0; $i < 100000; $i++) {
X    ($nowuser, $nowsys) = times;
X    $i = 200000 if $nowuser > $beguser && $nowsys > $begsys;
X    last if time - $beg > 20;
X}
X
Xif ($i >= 200000) {print "ok 2\n";} else {print "not ok 2\n";}
X
X($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($beg);
X($xsec,$foo) = localtime($now);
X$localyday = $yday;
X
Xif ($sec != $xsec && $yday && $wday && $year)
X    {print "ok 3\n";}
Xelse
X    {print "not ok 3\n";}
X
X($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($beg);
X($xsec,$foo) = localtime($now);
X
Xif ($sec != $xsec && $yday && $wday && $year)
X    {print "ok 4\n";}
Xelse
X    {print "not ok 4\n";}
X
Xif (index(" :0:1:-1:365:366:-365:-366:",':' . ($localyday - $yday) . ':') > 0)
X    {print "ok 5\n";}
Xelse
X    {print "not ok 5\n";}
!STUFFY!FUNK!
echo Extracting t/op.subst
sed >t/op.subst <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.subst,v 1.0 87/12/18 13:14:30 root Exp $
X
Xprint "1..7\n";
X
X$x = 'foo';
X$_ = "x";
Xs/x/\$x/;
Xprint "#1\t:$_: eq :\$x:\n";
Xif ($_ eq '$x') {print "ok 1\n";} else {print "not ok 1\n";}
X
X$_ = "x";
Xs/x/$x/;
Xprint "#2\t:$_: eq :foo:\n";
Xif ($_ eq 'foo') {print "ok 2\n";} else {print "not ok 2\n";}
X
X$_ = "x";
Xs/x/\$x $x/;
Xprint "#3\t:$_: eq :\$x foo:\n";
Xif ($_ eq '$x foo') {print "ok 3\n";} else {print "not ok 3\n";}
X
X$a = 'abcdef';
X$b = 'cd';
X$a =~ s'(b${b}e)'\n$1';
Xprint "#4\t:$1: eq :bcde:\n";
Xprint "#4\t:$a: eq :a\\n\$1f:\n";
Xif ($1 eq 'bcde' && $a eq 'a\n$1f') {print "ok 4\n";} else {print "not ok 4\n";}
X
X$a = 'abacada';
Xif (($a =~ s/a/x/g) == 4 && $a eq 'xbxcxdx')
X    {print "ok 5\n";} else {print "not ok 5\n";}
X
Xif (($a =~ s/a/y/g) == 0 && $a eq 'xbxcxdx')
X    {print "ok 6\n";} else {print "not ok 6\n";}
X
Xif (($a =~ s/b/y/g) == 1 && $a eq 'xyxcxdx')
X    {print "ok 7\n";} else {print "not ok 7\n";}
!STUFFY!FUNK!
echo Extracting str.h
sed >str.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: str.h,v 1.0 87/12/18 13:06:26 root Exp $
X *
X * $Log:        str.h,v $
X * Revision 1.0  87/12/18  13:06:26  root
X * Initial revision
X * 
X */
X
Xstruct string {
X    char *        str_ptr;        /* pointer to malloced string */
X    double        str_nval;        /* numeric value, if any */
X    int                str_len;        /* allocated size */
X    int                str_cur;        /* length of str_ptr as a C string */
X    union {
X        STR *str_next;                /* while free, link to next free str */
X        STAB *str_magic;        /* while in use, ptr to magic stab, if any */
X    } str_link;
X    char        str_pok;        /* state of str_ptr */
X    char        str_nok;        /* state of str_nval */
X};
X
X#define Nullstr Null(STR*)
X
X/* the following macro updates any magic values this str is associated with */
X
X#define STABSET(x) (x->str_link.str_magic && stabset(x->str_link.str_magic,x))
X
XEXT STR **tmps_list;
XEXT long tmps_max INIT(-1);
X
Xchar *str_2ptr();
Xdouble str_2num();
XSTR *str_static();
XSTR *str_make();
XSTR *str_nmake();
!STUFFY!FUNK!
echo Extracting t/op.repeat
sed >t/op.repeat <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.repeat,v 1.0 87/12/18 13:14:14 root Exp $
X
Xprint "1..11\n";
X
X# compile time
X
Xif ('-' x 5 eq '-----') {print "ok 1\n";} else {print "not ok 1\n";}
Xif ('-' x 1 eq '-') {print "ok 2\n";} else {print "not ok 2\n";}
Xif ('-' x 0 eq '') {print "ok 3\n";} else {print "not ok 3\n";}
X
Xif ('ab' x 3 eq 'ababab') {print "ok 4\n";} else {print "not ok 4\n";}
X
X# run time
X
X$a = '-';
Xif ($a x 5 eq '-----') {print "ok 5\n";} else {print "not ok 5\n";}
Xif ($a x 1 eq '-') {print "ok 6\n";} else {print "not ok 6\n";}
Xif ($a x 0 eq '') {print "ok 7\n";} else {print "not ok 7\n";}
X
X$a = 'ab';
Xif ($a x 3 eq 'ababab') {print "ok 8\n";} else {print "not ok 8\n";}
X
X$a = 'xyz';
X$a x= 2;
Xif ($a eq 'xyzxyz') {print "ok 9\n";} else {print "not ok 9\n";}
X$a x= 1;
Xif ($a eq 'xyzxyz') {print "ok 10\n";} else {print "not ok 10\n";}
X$a x= 0;
Xif ($a eq '') {print "ok 11\n";} else {print "not ok 11\n";}
X
!STUFFY!FUNK!
echo Extracting t/op.each
sed >t/op.each <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.each,v 1.0 87/12/18 13:13:23 root Exp $
X
Xprint "1..2\n";
X
X$h{'abc'} = 'ABC';
X$h{'def'} = 'DEF';
X$h{'jkl'} = 'JKL';
X$h{'xyz'} = 'XYZ';
X$h{'a'} = 'A';
X$h{'b'} = 'B';
X$h{'c'} = 'C';
X$h{'d'} = 'D';
X$h{'e'} = 'E';
X$h{'f'} = 'F';
X$h{'g'} = 'G';
X$h{'h'} = 'H';
X$h{'i'} = 'I';
X$h{'j'} = 'J';
X$h{'k'} = 'K';
X$h{'l'} = 'L';
X$h{'m'} = 'M';
X$h{'n'} = 'N';
X$h{'o'} = 'O';
X$h{'p'} = 'P';
X$h{'q'} = 'Q';
X$h{'r'} = 'R';
X$h{'s'} = 'S';
X$h{'t'} = 'T';
X$h{'u'} = 'U';
X$h{'v'} = 'V';
X$h{'w'} = 'W';
X$h{'x'} = 'X';
X$h{'y'} = 'Y';
X$h{'z'} = 'Z';
X
X@keys = keys(h);
X@values = values(h);
X
Xif ($#keys == 29 && $#values == 29) {print "ok 1\n";} else {print "not ok 1\n";}
X
Xwhile (($key,$value) = each(h)) {
X    if ($key eq $keys[$i] && $value eq $values[$i] && $key gt $value) {
X        $key =~ y/a-z/A-Z/;
X        $i++ if $key eq $value;
X    }
X}
X
Xif ($i == 30) {print "ok 2\n";} else {print "not ok 2\n";}
!STUFFY!FUNK!
echo Extracting t/io.argv
sed >t/io.argv <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: io.argv,v 1.0 87/12/18 13:12:44 root Exp $
X
Xprint "1..5\n";
X
Xopen(try, '>Io.argv.tmp') || (die "Can't open temp file.");
Xprint try "a line\n";
Xclose try;
X
X$x = `./perl -e 'while (<>) {print \$.,\$_;}' Io.argv.tmp Io.argv.tmp`;
X
Xif ($x eq "1a line\n2a line\n") {print "ok 1\n";} else {print "not ok 1\n";}
X
X$x = `echo foo|./perl -e 'while (<>) {print $_;}' Io.argv.tmp -`;
X
Xif ($x eq "a line\nfoo\n") {print "ok 2\n";} else {print "not ok 2\n";}
X
X$x = `echo foo|./perl -e 'while (<>) {print $_;}'`;
X
Xif ($x eq "foo\n") {print "ok 3\n";} else {print "not ok 3\n";}
X
X@ARGV = ('Io.argv.tmp', 'Io.argv.tmp', '/dev/null', 'Io.argv.tmp');
Xwhile (<>) {
X    $y .= $. . $_;
X    if (eof) {
X        if ($. == 3) {print "ok 4\n";} else {print "not ok 4\n";}
X    }
X}
X
Xif ($y eq "1a line\n2a line\n3a line\n")
X    {print "ok 5\n";}
Xelse
X    {print "not ok 5\n";}
X
X`/bin/rm -f Io.argv.tmp`;
!STUFFY!FUNK!
echo Extracting t/comp.term
sed >t/comp.term <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: comp.term,v 1.0 87/12/18 13:12:40 root Exp $
X
X# tests that aren't important enough for base.term
X
Xprint "1..9\n";
X
X$x = "\\n";
Xprint "#1\t:$x: eq " . ':\n:' . "\n";
Xif ($x eq '\n') {print "ok 1\n";} else {print "not ok 1\n";}
X
X$x = "#2\t:$x: eq :\\n:\n";
Xprint $x;
Xunless (index($x,'\\\\')>0) {print "ok 2\n";} else {print "not ok 2\n";}
X
Xif (length('\\\\') == 2) {print "ok 3\n";} else {print "not ok 3\n";}
X
X$one = 'a';
X
Xif (length("\\n") == 2) {print "ok 4\n";} else {print "not ok 4\n";}
Xif (length("\\\n") == 2) {print "ok 5\n";} else {print "not ok 5\n";}
Xif (length("$one\\n") == 3) {print "ok 6\n";} else {print "not ok 6\n";}
Xif (length("$one\\\n") == 3) {print "ok 7\n";} else {print "not ok 7\n";}
Xif (length("\\n$one") == 3) {print "ok 8\n";} else {print "not ok 8\n";}
Xif (length("\\\n$one") == 3) {print "ok 9\n";} else {print "not ok 9\n";}
X
!STUFFY!FUNK!
echo Extracting x2p/str.h
sed >x2p/str.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: str.h,v 1.0 87/12/18 13:07:30 root Exp $
X *
X * $Log:        str.h,v $
X * Revision 1.0  87/12/18  13:07:30  root
X * Initial revision
X * 
X */
X
Xstruct string {
X    char *        str_ptr;        /* pointer to malloced string */
X    double        str_nval;        /* numeric value, if any */
X    int                str_len;        /* allocated size */
X    int                str_cur;        /* length of str_ptr as a C string */
X    union {
X        STR *str_next;                /* while free, link to next free str */
X    } str_link;
X    char        str_pok;        /* state of str_ptr */
X    char        str_nok;        /* state of str_nval */
X};
X
X#define Nullstr Null(STR*)
X
X/* the following macro updates any magic values this str is associated with */
X
X#define STABSET(x) (x->str_link.str_magic && stabset(x->str_link.str_magic,x))
X
XEXT STR **tmps_list;
XEXT long tmps_max INIT(-1);
X
Xchar *str_2ptr();
Xdouble str_2num();
XSTR *str_static();
XSTR *str_make();
XSTR *str_nmake();
Xchar *str_gets();
!STUFFY!FUNK!
echo Extracting t/op.stat
sed >t/op.stat <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.stat,v 1.0 87/12/18 13:14:27 root Exp $
X
Xprint "1..4\n";
X
Xopen(foo, ">Op.stat.tmp");
X
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat(foo);
Xif ($nlink == 1) {print "ok 1\n";} else {print "not ok 1\n";}
Xif ($mtime && $mtime == $ctime) {print "ok 2\n";} else {print "not ok 2\n";}
X
Xprint foo "Now is the time for all good men to come to.\n";
Xclose(foo);
X
X$base = time;
Xwhile (time == $base) {}
X
X`rm -f Op.stat.tmp2; ln Op.stat.tmp Op.stat.tmp2; chmod 644 Op.stat.tmp`;
X
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat('Op.stat.tmp');
X
Xif ($nlink == 2) {print "ok 3\n";} else {print "not ok 3\n";}
Xif ($mtime && $mtime != $ctime) {print "ok 4\n";} else {print "not ok 4\n";}
Xprint "#4        :$mtime: != :$ctime:\n";
X
X`rm -f Op.stat.tmp Op.stat.tmp2`;
!STUFFY!FUNK!
echo Extracting spat.h
sed >spat.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: spat.h,v 1.0 87/12/18 13:06:10 root Exp $
X *
X * $Log:        spat.h,v $
X * Revision 1.0  87/12/18  13:06:10  root
X * Initial revision
X * 
X */
X
Xstruct scanpat {
X    SPAT        *spat_next;                /* list of all scanpats */
X    COMPEX        spat_compex;                /* compiled expression */
X    ARG                *spat_repl;                /* replacement string for subst */
X    ARG                *spat_runtime;                /* compile pattern at runtime */
X    STR                *spat_first;                /* for a fast bypass of execute() */
X    bool        spat_flags;
X    char        spat_flen;
X};
X
X#define SPAT_USED 1                        /* spat has been used once already */
X#define SPAT_USE_ONCE 2                        /* use pattern only once per article */
X#define SPAT_SCANFIRST 4                /* initial constant not anchored */
X#define SPAT_SCANALL 8                        /* initial constant is whole pat */
X
XEXT SPAT *spat_root;                /* list of all spats */
XEXT SPAT *curspat;                /* what to do \ interps from */
X
X#define Nullspat Null(SPAT*)
!STUFFY!FUNK!
echo Extracting t/op.do
sed >t/op.do <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.do,v 1.0 87/12/18 13:13:20 root Exp $
Xsub foo1
X{
X    print $_[0];
X    'value';
X}
X
Xsub foo2
X{
X    shift(_);
X    print $_[0];
X    $x = 'value';
X    $x;
X}
X
Xprint "1..8\n";
X
X$_[0] = "not ok 1\n";
X$result = do foo1("ok 1\n");
Xprint "#2\t:$result: eq :value:\n";
Xif ($result EQ 'value') { print "ok 2\n"; } else { print "not ok 2\n"; }
Xif ($_[0] EQ "not ok 1\n") { print "ok 3\n"; } else { print "not ok 3\n"; }
X
X$_[0] = "not ok 4\n";
X$result = do foo2("not ok 4\n","ok 4\n","not ok 4\n");
Xprint "#5\t:$result: eq :value:\n";
Xif ($result EQ 'value') { print "ok 5\n"; } else { print "not ok 5\n"; }
Xif ($_[0] EQ "not ok 4\n") { print "ok 6\n"; } else { print "not ok 6\n"; }
X
X$result = do{print "ok 7\n"; 'value';};
Xprint "#8\t:$result: eq :value:\n";
Xif ($result EQ 'value') { print "ok 8\n"; } else { print "not ok 8\n"; }
!STUFFY!FUNK!
echo Extracting t/base.term
sed >t/base.term <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: base.term,v 1.0 87/12/18 13:11:59 root Exp $
X
Xprint "1..6\n";
X
X# check "" interpretation
X
X$x = "\n";
Xif ($x lt ' ') {print "ok 1\n";} else {print "not ok 1\n";}
X
X# check `` processing
X
X$x = `echo hi there`;
Xif ($x eq "hi there\n") {print "ok 2\n";} else {print "not ok 2\n";}
X
X# check $#array
X
X$x[0] = 'foo';
X$x[1] = 'foo';
X$tmp = $#x;
Xprint "#3\t:$tmp: == :1:\n";
Xif ($#x == '1') {print "ok 3\n";} else {print "not ok 3\n";}
X
X# check numeric literal
X
X$x = 1;
Xif ($x == '1') {print "ok 4\n";} else {print "not ok 4\n";}
X
X# check <> pseudoliteral
X
Xopen(try, "/dev/null") || (die "Can't open /dev/null.");
Xif (<try> eq '') {print "ok 5\n";} else {print "not ok 5\n";}
X
Xopen(try, "/etc/termcap") || (die "Can't open /etc/termcap.");
Xif (<try> ne '') {print "ok 6\n";} else {print "not ok 6\n";}
!STUFFY!FUNK!
echo Extracting t/comp.multiline
sed >t/comp.multiline <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: comp.multiline,v 1.0 87/12/18 13:12:31 root Exp $
X
Xprint "1..5\n";
X
Xopen(try,'>Comp.try') || (die "Can't open temp file.");
X
X$x = 'now is the time
Xfor all good men
Xto come to.
X';
X
X$y = 'now is the time' . "\n" .
X'for all good men' . "\n" .
X'to come to.' . "\n";
X
Xif ($x eq $y) {print "ok 1\n";} else {print "not ok 1\n";}
X
Xprint try $x;
Xclose try;
X
Xopen(try,'Comp.try') || (die "Can't reopen temp file.");
X$count = 0;
X$z = '';
Xwhile (<try>) {
X    $z .= $_;
X    $count = $count + 1;
X}
X
Xif ($z eq $y) {print "ok 2\n";} else {print "not ok 2\n";}
X
Xif ($count == 3) {print "ok 3\n";} else {print "not ok 3\n";}
X
X$_ = `cat Comp.try`;
X
Xif (/.*\n.*\n.*\n$/) {print "ok 4\n";} else {print "not ok 4\n";}
X`/bin/rm -f Comp.try`;
X
Xif ($_ eq $y) {print "ok 5\n";} else {print "not ok 5\n";}
!STUFFY!FUNK!
echo Extracting t/comp.cpp
sed >t/comp.cpp <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl -P
X
X# $Header: comp.cpp,v 1.0 87/12/18 13:12:22 root Exp $
X
Xprint "1..3\n";
X
X#this is a comment
X#define MESS "ok 1\n"
Xprint MESS;
X
X#If you capitalize, it's a comment.
X#ifdef MESS
X        print "ok 2\n";
X#else
X        print "not ok 2\n";
X#endif
X
Xopen(try,">Comp.cpp.tmp") || die "Can't open temp perl file.";
Xprint try '$ok = "not ok 3\n";'; print try "\n";
Xprint try "#include <Comp.cpp.inc>\n";
Xprint try "#ifdef OK\n";
Xprint try '$ok = OK;'; print try "\n";
Xprint try "#endif\n";
Xprint try 'print $ok;'; print try "\n";
Xclose try;
X
Xopen(try,">Comp.cpp.inc") || (die "Can't open temp include file.");
Xprint try '#define OK "ok 3\n"'; print try "\n";
Xclose try;
X
X$pwd=`pwd`;
X$pwd =~ s/\n//;
X$x = `./perl -P -I$pwd Comp.cpp.tmp`;
Xprint $x;
X`/bin/rm -f Comp.cpp.tmp Comp.cpp.inc`;
!STUFFY!FUNK!
echo Extracting t/op.exp
sed >t/op.exp <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.exp,v 1.0 87/12/18 13:13:29 root Exp $
X
Xprint "1..6\n";
X
X# compile time evaluation
X
X$s = sqrt(2);
Xif (substr($s,0,5) eq '1.414') {print "ok 1\n";} else {print "not ok 1\n";}
X
X$s = exp(1);
Xif (substr($s,0,7) eq '2.71828') {print "ok 2\n";} else {print "not ok 2\n";}
X
Xif (exp(log(1)) == 1) {print "ok 3\n";} else {print "not ok 3\n";}
X
X# run time evaluation
X
X$x1 = 1;
X$x2 = 2;
X$s = sqrt($x2);
Xif (substr($s,0,5) eq '1.414') {print "ok 4\n";} else {print "not ok 4\n";}
X
X$s = exp($x1);
Xif (substr($s,0,7) eq '2.71828') {print "ok 5\n";} else {print "not ok 5\n";}
X
Xif (exp(log($x1)) == 1) {print "ok 6\n";} else {print "not ok 6\n";}
!STUFFY!FUNK!
echo Extracting handy.h
sed >handy.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: handy.h,v 1.0 87/12/18 13:05:14 root Exp $
X *
X * $Log:        handy.h,v $
X * Revision 1.0  87/12/18  13:05:14  root
X * Initial revision
X * 
X */
X
X#define Null(type) ((type)0)
X#define Nullch Null(char*)
X#define Nullfp Null(FILE*)
X
X#define bool char
X#define TRUE (1)
X#define FALSE (0)
X
X#define Ctl(ch) (ch & 037)
X
X#define strNE(s1,s2) (strcmp(s1,s2))
X#define strEQ(s1,s2) (!strcmp(s1,s2))
X#define strLT(s1,s2) (strcmp(s1,s2) < 0)
X#define strLE(s1,s2) (strcmp(s1,s2) <= 0)
X#define strGT(s1,s2) (strcmp(s1,s2) > 0)
X#define strGE(s1,s2) (strcmp(s1,s2) >= 0)
X#define strnNE(s1,s2,l) (strncmp(s1,s2,l))
X#define strnEQ(s1,s2,l) (!strncmp(s1,s2,l))
!STUFFY!FUNK!
echo Extracting x2p/handy.h
sed >x2p/handy.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: handy.h,v 1.0 87/12/18 13:07:15 root Exp $
X *
X * $Log:        handy.h,v $
X * Revision 1.0  87/12/18  13:07:15  root
X * Initial revision
X * 
X */
X
X#define Null(type) ((type)0)
X#define Nullch Null(char*)
X#define Nullfp Null(FILE*)
X
X#define bool char
X#define TRUE (1)
X#define FALSE (0)
X
X#define Ctl(ch) (ch & 037)
X
X#define strNE(s1,s2) (strcmp(s1,s2))
X#define strEQ(s1,s2) (!strcmp(s1,s2))
X#define strLT(s1,s2) (strcmp(s1,s2) < 0)
X#define strLE(s1,s2) (strcmp(s1,s2) <= 0)
X#define strGT(s1,s2) (strcmp(s1,s2) > 0)
X#define strGE(s1,s2) (strcmp(s1,s2) >= 0)
X#define strnNE(s1,s2,l) (strncmp(s1,s2,l))
X#define strnEQ(s1,s2,l) (!strncmp(s1,s2,l))
!STUFFY!FUNK!
echo Extracting x2p/util.h
sed >x2p/util.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: util.h,v 1.0 87/12/18 13:07:37 root Exp $
X *
X * $Log:        util.h,v $
X * Revision 1.0  87/12/18  13:07:37  root
X * Initial revision
X * 
X */
X
X/* is the string for makedir a directory name or a filename? */
X
X#define MD_DIR 0
X#define MD_FILE 1
X
Xvoid        util_init();
Xint        doshell();
Xchar        *safemalloc();
Xchar        *saferealloc();
Xchar        *safecpy();
Xchar        *safecat();
Xchar        *cpytill();
Xchar        *cpy2();
Xchar        *instr();
X#ifdef SETUIDGID
X    int                eaccess();
X#endif
Xchar        *getwd();
Xvoid        cat();
Xvoid        prexit();
Xchar        *get_a_line();
Xchar        *savestr();
Xint        makedir();
Xvoid        setenv();
Xint        envix();
Xvoid        notincl();
Xchar        *getval();
Xvoid        growstr();
Xvoid        setdef();
!STUFFY!FUNK!
echo Extracting util.h
sed >util.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: util.h,v 1.0 87/12/18 13:06:33 root Exp $
X *
X * $Log:        util.h,v $
X * Revision 1.0  87/12/18  13:06:33  root
X * Initial revision
X * 
X */
X
X/* is the string for makedir a directory name or a filename? */
X
X#define MD_DIR 0
X#define MD_FILE 1
X
Xvoid        util_init();
Xint        doshell();
Xchar        *safemalloc();
Xchar        *saferealloc();
Xchar        *safecpy();
Xchar        *safecat();
Xchar        *cpytill();
Xchar        *instr();
X#ifdef SETUIDGID
X    int                eaccess();
X#endif
Xchar        *getwd();
Xvoid        cat();
Xvoid        prexit();
Xchar        *get_a_line();
Xchar        *savestr();
Xint        makedir();
Xvoid        setenv();
Xint        envix();
Xvoid        notincl();
Xchar        *getval();
Xvoid        growstr();
Xvoid        setdef();
!STUFFY!FUNK!
echo Extracting t/op.goto
sed >t/op.goto <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.goto,v 1.0 87/12/18 13:13:40 root Exp $
X
Xprint "1..3\n";
X
Xwhile (0) {
X    $foo = 1;
X  label1:
X    $foo = 2;
X    goto label2;
X} continue {
X    $foo = 0;
X    goto label4;
X  label3:
X    $foo = 4;
X    goto label4;
X}
Xgoto label1;
X
X$foo = 3;
X
Xlabel2:
Xprint "#1\t:$foo: == 2\n";
Xif ($foo == 2) {print "ok 1\n";} else {print "not ok 1\n";}
Xgoto label3;
X
Xlabel4:
Xprint "#2\t:$foo: == 4\n";
Xif ($foo == 4) {print "ok 2\n";} else {print "not ok 2\n";}
X
X$x = `./perl -e 'goto foo;' 2>&1`;
Xprint "#3\t/label/ in :$x";
Xif ($x =~ /label/) {print "ok 3\n";} else {print "not ok 3\n";}
!STUFFY!FUNK!
echo Extracting t/op.flip
sed >t/op.flip <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.flip,v 1.0 87/12/18 13:13:34 root Exp $
X
Xprint "1..8\n";
X
X@a = (1,2,3,4,5,6,7,8,9,10,11,12);
X
Xwhile ($_ = shift(a)) {
X    if ($x = /4/../8/) { $z = $x; print "ok ", $x + 0, "\n"; }
X    $y .= /1/../2/;
X}
X
Xif ($z eq '5E0') {print "ok 6\n";} else {print "not ok 6\n";}
X
Xif ($y eq '12E0123E0') {print "ok 7\n";} else {print "not ok 7\n";}
X
X@a = ('a','b','c','d','e','f','g');
X
Xopen(of,'/etc/termcap');
Xwhile (<of>) {
X    (3 .. 5) && $foo .= $_;
X}
X$x = ($foo =~ y/\n/\n/);
X
Xif ($x eq 3) {print "ok 8\n";} else {print "not ok 8 $x:$foo:\n";}
!STUFFY!FUNK!
echo Extracting t/op.split
sed >t/op.split <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.split,v 1.0 87/12/18 13:14:20 root Exp $
X
Xprint "1..4\n";
X
X$FS = ':';
X
X$_ = 'a:b:c';
X
X($a,$b,$c) = split($FS,$_);
X
Xif (join(';',$a,$b,$c) eq 'a;b;c') {print "ok 1\n";} else {print "not ok 1\n";}
X
X@ary = split(/:b:/);
Xif (join("$_",@ary) eq 'aa:b:cc') {print "ok 2\n";} else {print "not ok 2\n";}
X
X$_ = "abc\n";
X@ary = split(//);
Xif (join(".",@ary) eq "a.b.c.\n") {print "ok 3\n";} else {print "not ok 3\n";}
X
X$_ = "a:b:c::::";
X@ary = split(/:/);
Xif (join(".",@ary) eq "a.b.c") {print "ok 4\n";} else {print "not ok 4\n";}
!STUFFY!FUNK!
echo Extracting t/cmd.mod
sed >t/cmd.mod <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: cmd.mod,v 1.0 87/12/18 13:12:09 root Exp $
X
Xprint "1..6\n";
X
Xprint "ok 1\n" if 1;
Xprint "not ok 1\n" unless 1;
X
Xprint "ok 2\n" unless 0;
Xprint "not ok 2\n" if 0;
X
X1 && (print "not ok 3\n") if 0;
X1 && (print "ok 3\n") if 1;
X0 || (print "not ok 4\n") if 0;
X0 || (print "ok 4\n") if 1;
X
X$x = 0;
Xdo {$x[$x] = $x;} while ($x++) < 10;
Xif (join(' ',@x) eq '0 1 2 3 4 5 6 7 8 9 10') {
X        print "ok 5\n";
X} else {
X        print "not ok 5\n";
X}
X
X$x = 15;
X$x = 10 while $x < 10;
Xif ($x == 15) {print "ok 6\n";} else {print "not ok 6\n";}
!STUFFY!FUNK!
echo Extracting t/README
sed >t/README <<'!STUFFY!FUNK!' -e 's/X//'
XThis is the perl test library.  To run all the tests, just type 'TEST'.
X
XTo add new tests, just look at the current tests and do likewise.
X
XIf a test fails, run it by itself to see if it prints any informative
Xdiagnostics.  If not, modify the test to print informative diagnostics.
XIf you put out extra lines with a '#' character on the front, you don't
Xhave to worry about removing the extra print statements later since TEST
Xignores lines beginning with '#'.
X
XIf you come up with new tests, send them to lw...@jpl-devvax.jpl.nasa.gov.
!STUFFY!FUNK!
echo Extracting t/op.magic
sed >t/op.magic <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.magic,v 1.0 87/12/18 13:13:54 root Exp $
X
Xprint "1..4\n";
X
X$| = 1;                # command buffering
X
X$ENV{'foo'} = 'hi there';
Xif (`echo \$foo` eq "hi there\n") {print "ok 1\n";} else {print "not ok 1\n";}
X
X$! = 0;
Xopen(foo,'ajslkdfpqjsjfkslkjdflksd');
Xif ($! == 2) {print "ok 2\n";} else {print "not ok 2\n";}
X
X$SIG{'INT'} = 'ok3';
Xkill 2,$$;
X$SIG{'INT'} = 'IGNORE';
Xkill 2,$$;
Xprint "ok 4\n";
X$SIG{'INT'} = 'DEFAULT';
Xkill 2,$$;
Xprint "not ok\n";
X
Xsub ok3 {
X    print "ok 3\n" if pop(@_) eq 'INT';
X}
!STUFFY!FUNK!
echo Extracting t/comp.script
sed >t/comp.script <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: comp.script,v 1.0 87/12/18 13:12:36 root Exp $
X
Xprint "1..3\n";
X
X$x = `./perl -e 'print "ok\n";'`;
X
Xif ($x eq "ok\n") {print "ok 1\n";} else {print "not ok 1\n";}
X
Xopen(try,">Comp.script") || (die "Can't open temp file.");
Xprint try 'print "ok\n";'; print try "\n";
Xclose try;
X
X$x = `./perl Comp.script`;
X
Xif ($x eq "ok\n") {print "ok 2\n";} else {print "not ok 2\n";}
X
X$x = `./perl <Comp.script`;
X
Xif ($x eq "ok\n") {print "ok 3\n";} else {print "not ok 3\n";}
X
X`/bin/rm -f Comp.script`;
!STUFFY!FUNK!
echo Extracting t/cmd.elsif
sed >t/cmd.elsif <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: cmd.elsif,v 1.0 87/12/18 13:12:02 root Exp $
X
Xsub foo {
X    if ($_[0] == 1) {
X        1;
X    }
X    elsif ($_[0] == 2) {
X        2;
X    }
X    elsif ($_[0] == 3) {
X        3;
X    }
X    else {
X        4;
X    }
X}
X
Xprint "1..4\n";
X
Xif (($x = do foo(1)) == 1) {print "ok 1\n";} else {print "not ok 1\n";}
Xif (($x = do foo(2)) == 2) {print "ok 2\n";} else {print "not ok 2\n";}
Xif (($x = do foo(3)) == 3) {print "ok 3\n";} else {print "not ok 3\n";}
Xif (($x = do foo(4)) == 4) {print "ok 4\n";} else {print "not ok 4\n";}
!STUFFY!FUNK!
echo Extracting t/comp.decl
sed >t/comp.decl <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: comp.decl,v 1.0 87/12/18 13:12:27 root Exp $
X
X# check to see if subroutine declarations work everwhere
X
Xsub one {
X    print "ok 1\n";
X}
Xformat one =
Xok 5
X.
X
Xprint "1..7\n";
X
Xdo one();
Xdo two();
X
Xsub two {
X    print "ok 2\n";
X}
Xformat two =
X@<<<
X$foo
X.
X
Xif ($x eq $x) {
X    sub three {
X        print "ok 3\n";
X    }
X    do three();
X}
X
Xdo four();
X$~ = 'one';
Xwrite;
X$~ = 'two';
X$foo = "ok 6";
Xwrite;
X$~ = 'three';
Xwrite;
X
Xformat three =
Xok 7
X.
X
Xsub four {
X    print "ok 4\n";
X}
!STUFFY!FUNK!
echo Extracting form.h
sed >form.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: form.h,v 1.0 87/12/18 13:05:10 root Exp $
X *
X * $Log:        form.h,v $
X * Revision 1.0  87/12/18  13:05:10  root
X * Initial revision
X * 
X */
X
X#define F_NULL 0
X#define F_LEFT 1
X#define F_RIGHT 2
X#define F_CENTER 3
X#define F_LINES 4
X
Xstruct formcmd {
X    struct formcmd *f_next;
X    ARG *f_expr;
X    char *f_pre;
X    short f_presize;
X    short f_size;
X    char f_type;
X    char f_flags;
X};
X
X#define FC_CHOP 1
X#define FC_NOBLANK 2
X#define FC_MORE 4
X
X#define Nullfcmd Null(FCMD*)
!STUFFY!FUNK!
echo Extracting t/op.append
sed >t/op.append <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.append,v 1.0 87/12/18 13:13:05 root Exp $
X
Xprint "1..3\n";
X
X$a = 'ab' . 'c';        # compile time
X$b = 'def';
X
X$c = $a . $b;
Xprint "#1\t:$c: eq :abcdef:\n";
Xif ($c eq 'abcdef') {print "ok 1\n";} else {print "not ok 1\n";}
X
X$c .= 'xyz';
Xprint "#2\t:$c: eq :abcdefxyz:\n";
Xif ($c eq 'abcdefxyz') {print "ok 2\n";} else {print "not ok 2\n";}
X
X$_ = $a;
X$_ .= $b;
Xprint "#3\t:$_: eq :abcdef:\n";
Xif ($_ eq 'abcdef') {print "ok 3\n";} else {print "not ok 3\n";}
!STUFFY!FUNK!
echo Extracting t/base.lex
sed >t/base.lex <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: base.lex,v 1.0 87/12/18 13:11:51 root Exp $
X
Xprint "1..4\n";
X
X$ # this is the register <space>
X= 'x';
X
Xprint "#1        :$ : eq :x:\n";
Xif ($  eq 'x') {print "ok 1\n";} else {print "not ok 1\n";}
X
X$x = $#;        # this is the register $#
X
Xif ($x eq '') {print "ok 2\n";} else {print "not ok 2\n";}
X
X$x = $#x;
X
Xif ($x eq '-1') {print "ok 3\n";} else {print "not ok 3\n";}
X
X$x = '\\'; # ';
X
Xif (length($x) == 1) {print "ok 4\n";} else {print "not ok 4\n";}
!STUFFY!FUNK!
echo Extracting t/cmd.for
sed >t/cmd.for <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: cmd.for,v 1.0 87/12/18 13:12:05 root Exp $
X
Xprint "1..2\n";
X
Xfor ($i = 0; $i <= 10; $i++) {
X    $x[$i] = $i;
X}
X$y = $x[10];
Xprint "#1        :$y: eq :10:\n";
X$y = join(' ', @x);
Xprint "#1        :$y: eq :0 1 2 3 4 5 6 7 8 9 10:\n";
Xif (join(' ', @x) eq '0 1 2 3 4 5 6 7 8 9 10') {
X        print "ok 1\n";
X} else {
X        print "not ok 1\n";
X}
X
X$i = $c = 0;
Xfor (;;) {
X        $c++;
X        last if $i++ > 10;
X}
Xif ($c == 12) {print "ok 2\n";} else {print "not ok 2\n";}
!STUFFY!FUNK!
echo Extracting t/io.inplace
sed >t/io.inplace <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl -i.bak
X
X# $Header: io.inplace,v 1.0 87/12/18 13:12:51 root Exp $
X
Xprint "1..2\n";
X
X@ARGV = ('.a','.b','.c');
X`echo foo | tee .a .b .c`;
Xwhile (<>) {
X    s/foo/bar/;
X}
Xcontinue {
X    print;
X}
X
Xif (`cat .a .b .c` eq "bar\nbar\nbar\n") {print "ok 1\n";} else {print "not ok 1\n";}
Xif (`cat .a.bak .b.bak .c.bak` eq "foo\nfoo\nfoo\n") {print "ok 2\n";} else {print "not ok 2\n";}
X
Xunlink '.a', '.b', '.c', '.a.bak', '.b.bak', '.c.bak';
!STUFFY!FUNK!
echo Extracting t/op.int
sed >t/op.int <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.int,v 1.0 87/12/18 13:13:43 root Exp $
X
Xprint "1..4\n";
X
X# compile time evaluation
X
Xif (int(1.234) == 1) {print "ok 1\n";} else {print "not ok 1\n";}
X
Xif (int(-1.234) == -1) {print "ok 2\n";} else {print "not ok 2\n";}
X
X# run time evaluation
X
X$x = 1.234;
Xif (int($x) == 1) {print "ok 3\n";} else {print "not ok 3\n";}
Xif (int(-$x) == -1) {print "ok 4\n";} else {print "not ok 4\n";}
!STUFFY!FUNK!
echo Extracting t/base.cond
sed >t/base.cond <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: base.cond,v 1.0 87/12/18 13:11:41 root Exp $
X
X# make sure conditional operators work
X
Xprint "1..4\n";
X
X$x = '0';
X
X$x eq $x && (print "ok 1\n");
X$x ne $x && (print "not ok 1\n");
X$x eq $x || (print "not ok 2\n");
X$x ne $x || (print "ok 2\n");
X
X$x == $x && (print "ok 3\n");
X$x != $x && (print "not ok 3\n");
X$x == $x || (print "not ok 4\n");
X$x != $x || (print "ok 4\n");
!STUFFY!FUNK!
echo Extracting t/io.print
sed >t/io.print <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: io.print,v 1.0 87/12/18 13:12:55 root Exp $
X
Xprint "1..11\n";
X
Xprint stdout "ok 1\n";
Xprint "ok 2\n","ok 3\n","ok 4\n","ok 5\n";
X
Xopen(foo,">-");
Xprint foo "ok 6\n";
X
Xprintf "ok %d\n",7;
Xprintf("ok %d\n",8);
X
X@a = ("ok %d%c",9,ord("\n"));
Xprintf @a;
X
X$a[1] = 10;
Xprintf stdout @a;
X
X$, = ' ';
X$\ = "\n";
X
Xprint "ok","11";
!STUFFY!FUNK!
echo Extracting array.h
sed >array.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: array.h,v 1.0 87/12/18 13:04:46 root Exp $
X *
X * $Log:        array.h,v $
X * Revision 1.0  87/12/18  13:04:46  root
X * Initial revision
X * 
X */
X
Xstruct atbl {
X    STR        **ary_array;
X    int        ary_max;
X    int        ary_fill;
X};
X
XSTR *afetch();
Xbool astore();
Xbool adelete();
XSTR *apop();
XSTR *ashift();
Xbool apush();
Xlong alen();
XARRAY *anew();
!STUFFY!FUNK!
echo Extracting t/op.join
sed >t/op.join <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.join,v 1.0 87/12/18 13:13:46 root Exp $
X
Xprint "1..3\n";
X
X@x = (1, 2, 3);
Xif (join(':',@x) eq '1:2:3') {print "ok 1\n";} else {print "not ok 1\n";}
X
Xif (join('',1,2,3) eq '123') {print "ok 2\n";} else {print "not ok 2\n";}
X
Xif (join(':',split(/ /,"1 2 3")) eq '1:2:3') {print "ok 3\n";} else {print "not ok 3\n";}
!STUFFY!FUNK!
echo Extracting t/op.crypt
sed >t/op.crypt <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.crypt,v 1.0 87/12/18 13:13:17 root Exp $
X
Xprint "1..2\n";
X
X# this evaluates entirely at compile time!
Xif (crypt('uh','oh') eq 'ohPnjpYtoi1NU') {print "ok 1\n";} else {print "not ok 1\n";}
X
X# this doesn't.
X$uh = 'uh';
Xif (crypt($uh,'oh') eq 'ohPnjpYtoi1NU') {print "ok 2\n";} else {print "not ok 2\n";}
!STUFFY!FUNK!
echo Extracting t/op.chop
sed >t/op.chop <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.chop,v 1.0 87/12/18 13:13:11 root Exp $
X
Xprint "1..2\n";
X
X# optimized
X
X$_ = 'abc';
X$c = do foo();
Xif ($c . $_ eq 'cab') {print "ok 1\n";} else {print "not ok 1\n";}
X
X# unoptimized
X
X$_ = 'abc';
X$c = chop($_);
Xif ($c . $_ eq 'cab') {print "ok 2\n";} else {print "not ok 2\n";}
X
Xsub foo {
X    chop;
X}
!STUFFY!FUNK!
echo Extracting version.c
sed >version.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: version.c,v 1.0 87/12/18 13:06:41 root Exp $
X *
X * $Log:        version.c,v $
X * Revision 1.0  87/12/18  13:06:41  root
X * Initial revision
X * 
X */
X
X#include "patchlevel.h"
X
X/* Print out the version number. */
X
Xversion()
X{
X    extern char rcsid[];
X
X    printf("%s\r\nPatch level: %d\r\n", rcsid, PATCHLEVEL);
X}
!STUFFY!FUNK!
echo Extracting t/op.unshift
sed >t/op.unshift <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.unshift,v 1.0 87/12/18 13:14:37 root Exp $
X
Xprint "1..2\n";
X
X@a = (1,2,3);
X$cnt1 = unshift(a,0);
X
Xif (join(' ',@a) eq '0 1 2 3') {print "ok 1\n";} else {print "not ok 1\n";}
X$cnt2 = unshift(a,3,2,1);
Xif (join(' ',@a) eq '3 2 1 0 1 2 3') {print "ok 2\n";} else {print "not ok 2\n";}
X
X
!STUFFY!FUNK!
echo Extracting t/op.oct
sed >t/op.oct <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.oct,v 1.0 87/12/18 13:13:57 root Exp $
X
Xprint "1..3\n";
X
Xif (oct('01234') == 01234) {print "ok 1\n";} else {print "not ok 1\n";}
Xif (oct('0x1234') == 0x1234) {print "ok 2\n";} else {print "not ok 2\n";}
Xif (hex('01234') == 0x1234) {print "ok 3\n";} else {print "not ok 3\n";}
!STUFFY!FUNK!
echo Extracting t/op.ord
sed >t/op.ord <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.ord,v 1.0 87/12/18 13:14:01 root Exp $
X
Xprint "1..2\n";
X
X# compile time evaluation
X
Xif (ord('A') == 65) {print "ok 1\n";} else {print "not ok 1\n";}
X
X# run time evaluation
X
X$x = 'ABC';
Xif (ord($x) == 65) {print "ok 2\n";} else {print "not ok 2\n";}
!STUFFY!FUNK!
echo Extracting t/op.exec
sed >t/op.exec <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.exec,v 1.0 87/12/18 13:13:26 root Exp $
X
X$| = 1;                                # flush stdout
Xprint "1..4\n";
X
Xsystem "echo ok \\1";                # shell interpreted
Xsystem "echo ok 2";                # split and directly called
Xsystem "echo", "ok", "3";        # directly called
X
Xexec "echo","ok","4";
!STUFFY!FUNK!
echo Extracting t/op.fork
sed >t/op.fork <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.fork,v 1.0 87/12/18 13:13:37 root Exp $
X
X$| = 1;
Xprint "1..2\n";
X
Xif ($cid = fork) {
X    sleep 2;
X    if ($result = (kill 9, $cid)) {print "ok 2\n";} else {print "not ok 2 $result\n";}
X}
Xelse {
X    $| = 1;
X    print "ok 1\n";
X    sleep 10;
X}
!STUFFY!FUNK!
echo Extracting t/base.if
sed >t/base.if <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: base.if,v 1.0 87/12/18 13:11:45 root Exp $
X
Xprint "1..2\n";
X
X# first test to see if we can run the tests.
X
X$x = 'test';
Xif ($x eq $x) { print "ok 1\n"; } else { print "not ok 1\n";}
Xif ($x ne $x) { print "not ok 2\n"; } else { print "ok 2\n";}
!STUFFY!FUNK!
echo Extracting t/base.pat
sed >t/base.pat <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: base.pat,v 1.0 87/12/18 13:11:56 root Exp $
X
Xprint "1..2\n";
X
X# first test to see if we can run the tests.
X
X$_ = 'test';
Xif (/^test/) { print "ok 1\n"; } else { print "not ok 1\n";}
Xif (/^foo/) { print "not ok 2\n"; } else { print "ok 2\n";}
!STUFFY!FUNK!
echo Extracting t/op.cond
sed >t/op.cond <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.cond,v 1.0 87/12/18 13:13:14 root Exp $
X
Xprint "1..4\n";
X
Xprint 1 ? "ok 1\n" : "not ok 1\n";        # compile time
Xprint 0 ? "not ok 2\n" : "ok 2\n";
X
X$x = 1;
Xprint $x ? "ok 3\n" : "not ok 3\n";        # run time
Xprint !$x ? "not ok 4\n" : "ok 4\n";
!STUFFY!FUNK!
echo Extracting t/op.sprintf
sed >t/op.sprintf <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.sprintf,v 1.0 87/12/18 13:14:24 root Exp $
X
Xprint "1..1\n";
X
X$x = sprintf("%3s %-4s foo %5d%c%3.1f","hi",123,456,65,3.0999);
Xif ($x eq ' hi 123  foo   456A3.1') {print "ok 1\n";} else {print "not ok 1\n";}
!STUFFY!FUNK!
echo Extracting EXTERN.h
sed >EXTERN.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: EXTERN.h,v 1.0 87/12/18 13:02:26 root Exp $
X *
X * $Log:        EXTERN.h,v $
X * Revision 1.0  87/12/18  13:02:26  root
X * Initial revision
X * 
X */
X
X#undef EXT
X#define EXT extern
X
X#undef INIT
X#define INIT(x)
X
X#undef DOINIT
!STUFFY!FUNK!
echo Extracting x2p/EXTERN.h
sed >x2p/EXTERN.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: EXTERN.h,v 1.0 87/12/18 13:06:44 root Exp $
X *
X * $Log:        EXTERN.h,v $
X * Revision 1.0  87/12/18  13:06:44  root
X * Initial revision
X * 
X */
X
X#undef EXT
X#define EXT extern
X
X#undef INIT
X#define INIT(x)
X
X#undef DOINIT
!STUFFY!FUNK!
echo Extracting INTERN.h
sed >INTERN.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: INTERN.h,v 1.0 87/12/18 13:02:39 root Exp $
X *
X * $Log:        INTERN.h,v $
X * Revision 1.0  87/12/18  13:02:39  root
X * Initial revision
X * 
X */
X
X#undef EXT
X#define EXT
X
X#undef INIT
X#define INIT(x) = x
X
X#define DOINIT
!STUFFY!FUNK!
echo Extracting x2p/INTERN.h
sed >x2p/INTERN.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: INTERN.h,v 1.0 87/12/18 13:06:48 root Exp $
X *
X * $Log:        INTERN.h,v $
X * Revision 1.0  87/12/18  13:06:48  root
X * Initial revision
X * 
X */
X
X#undef EXT
X#define EXT
X
X#undef INIT
X#define INIT(x) = x
X
X#define DOINIT
!STUFFY!FUNK!
echo Extracting Wishlist
sed >Wishlist <<'!STUFFY!FUNK!' -e 's/X//'
Xdate support
Xcase statement
Xioctl() support
Xrandom numbers
Xdirectory reading via <>
!STUFFY!FUNK!
echo ""
echo "End of kit 10 (of 10)"
cat /dev/null >kit10isdone
config=true
for iskit in 1 2 3 4 5 6 7 8 9 10; do
    if test -f kit${iskit}isdone; then
        echo "You have run kit ${iskit}."
    else
        echo "You still need to run kit ${iskit}."
        config=false
    fi
done
case $config in
    true)
        echo "You have run all your kits.  Please read README and then type Configure."
        chmod 755 Configure
        ;;
esac
: Someone might mail this, so...
exit