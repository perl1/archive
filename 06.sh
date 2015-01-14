#! /bin/sh

# Make a new directory for the perl sources, cd to it, and run kits 1
# thru 10 through sh.  When all 10 kits have been run, read README.

echo "This is perl 1.0 kit 6 (of 10).  If kit 6 is complete, the line"
echo '"'"End of kit 6 (of 10)"'" will echo at the end.'
echo ""
export PATH || (echo "You didn't use sh, you clunch." ; kill $$)
mkdir t 2>/dev/null
echo Extracting Configure
sed >Configure <<'!STUFFY!FUNK!' -e 's/X//'
X#! /bin/sh
X#
X# If these # comments don't work, trim them.  Don't worry about any other
X# shell scripts, Configure will trim # comments from them for you.
X#
X# (If you are trying to port this package to a machine without sh, I would
X# suggest you cut out the prototypical config.h from the end of Configure
X# and edit it to reflect your system.  Some packages may include samples
X# of config.h for certain machines, so you might look for one of those.)
X#
X# $Header: Configure,v 1.0 87/12/18 15:05:56 root Exp $
X#
X# Yes, you may rip this off to use in other distribution packages.
X# (Note: this Configure script was generated automatically.  Rather than
X# working with this copy of Configure, you may wish to get metaconfig.)
X
X: sanity checks
XPATH='.:/bin:/usr/bin:/usr/local/bin:/usr/ucb:/usr/local:/usr/lbin:/etc'
Xexport PATH || (echo "OOPS, this isn't sh.  Desperation time.  I will feed myself to sh."; sh $0; kill $$)
X
Xif test ! -t 0; then
X    echo "Say 'sh Configure', not 'sh <Configure'"
X    exit 1
Xfi
X
X(alias) >/dev/null 2>&1 && \
X    echo "(I see you are using the Korn shell.  Some ksh's blow up on Configure," && \
X    echo "especially on exotic machines.  If yours does, try the Bourne shell instead.)"
X
Xif test ! -d ../UU; then
X    if test ! -d UU; then
X        mkdir UU
X    fi
X    cd UU
Xfi
X
Xd_eunice=''
Xeunicefix=''
Xdefine=''
Xloclist=''
Xexpr=''
Xsed=''
Xecho=''
Xcat=''
Xrm=''
Xmv=''
Xcp=''
Xtail=''
Xtr=''
Xmkdir=''
Xsort=''
Xuniq=''
Xgrep=''
Xtrylist=''
Xtest=''
Xinews=''
Xegrep=''
Xmore=''
Xpg=''
XMcc=''
Xvi=''
Xmailx=''
Xmail=''
XLog=''
XHeader=''
Xbin=''
Xcc=''
Xcontains=''
Xcpp=''
Xd_charsprf=''
Xd_index=''
Xd_strctcpy=''
Xd_vfork=''
Xlibc=''
Xlibnm=''
Xmansrc=''
Xmanext=''
Xmodels=''
Xsplit=''
Xsmall=''
Xmedium=''
Xlarge=''
Xhuge=''
Xccflags=''
Xldflags=''
Xn=''
Xc=''
Xpackage=''
Xspitshell=''
Xshsharp=''
Xsharpbang=''
Xstartsh=''
Xvoidflags=''
Xdefvoidused=''
XCONFIG=''
X
X: set package name
Xpackage=perl
X
Xecho " "
Xecho "Beginning of configuration questions for $package kit."
X: Eunice requires " " instead of "", can you believe it
Xecho " "
X
Xdefine='define'
Xundef='/*undef'
Xlibpth='/usr/lib /usr/local/lib /lib'
Xsmallmach='pdp11 i8086 z8000 i80286 iAPX286'
Xrmlist='kit[1-9]isdone kit[1-9][0-9]isdone'
Xtrap 'echo " "; rm -f $rmlist; exit 1' 1 2 3
Xattrlist="mc68000 sun gcos unix ibm gimpel interdata tss os mert pyr"
Xattrlist="$attrlist vax pdp11 i8086 z8000 u3b2 u3b5 u3b20 u3b200"
Xattrlist="$attrlist ns32000 ns16000 iAPX286"
Xpth="/usr/ucb /bin /usr/bin /usr/local /usr/local/bin /usr/lbin /etc /usr/lib"
Xdefvoidused=7
X
X: some greps do not return status, grrr.
Xecho "grimblepritz" >grimble
Xif grep blurfldyick grimble >/dev/null 2>&1 ; then
X    contains=contains
Xelif grep grimblepritz grimble >/dev/null 2>&1 ; then
X    contains=grep
Xelse
X    contains=contains
Xfi
Xrm -f grimble
X: the following should work in any shell
Xcase "$contains" in
Xcontains*)
X    echo " "
X    echo "AGH!  Grep doesn't return a status.  Attempting remedial action."
X    cat >contains <<'EOSS'
Xgrep "$1" "$2" >.greptmp && cat .greptmp && test -s .greptmp
XEOSS
Xchmod 755 contains
Xesac
X
X: first determine how to suppress newline on echo command
Xecho "Checking echo to see how to suppress newlines..."
X(echo "hi there\c" ; echo " ") >.echotmp
Xif $contains c .echotmp >/dev/null 2>&1 ; then
X    echo "...using -n."
X    n='-n'
X    c=''
Xelse
X    cat <<'EOM'
X...using \c
XEOM
X    n=''
X    c='\c'
Xfi
Xecho $n "Type carriage return to continue.  Your cursor should be here-->$c"
Xread ans
Xrm -f .echotmp
X
X: now set up to do reads with possible shell escape and default assignment
Xcat <<EOSC >myread
Xans='!'
Xwhile expr "X\$ans" : "X!" >/dev/null; do
X    read ans
X    case "\$ans" in
X    !)
X        sh
X        echo " "
X        echo $n "\$rp $c"
X        ;;
X    !*)
X        set \`expr "X\$ans" : "X!\(.*\)\$"\`
X        sh -c "\$*"
X        echo " "
X        echo $n "\$rp $c"
X        ;;
X    esac
Xdone
Xrp='Your answer:'
Xcase "\$ans" in
X'') ans="\$dflt";;
Xesac
XEOSC
X
X: general instructions
Xcat <<EOH
X 
XThis installation shell script will examine your system and ask you questions
Xto determine how the $package package should be installed.  If you get stuck
Xon a question, you may use a ! shell escape to start a subshell or execute
Xa command.  Many of the questions will have default answers in square
Xbrackets--typing carriage return will give you the default.
X
XOn some of the questions which ask for file or directory names you are
Xallowed to use the ~name construct to specify the login directory belonging
Xto "name", even if you don't have a shell which knows about that.  Questions
Xwhere this is allowed will be marked "(~name ok)".
X
XEOH
Xrp="[Type carriage return to continue]"
Xecho $n "$rp $c"
X. myread
Xcat <<EOH
X
XMuch effort has been expended to ensure that this shell script will run
Xon any Unix system.  If despite that it blows up on you, your best bet is
Xto edit Configure and run it again. Also, let me (lwall@sdcrdcf.UUCP) know
Xhow I blew it.  If you can't run Configure for some reason, you'll have
Xto generate a config.sh file by hand.
X
XThis installation script affects things in two ways: 1) it may do direct
Xvariable substitutions on some of the files included in this kit, and
X2) it builds a config.h file for inclusion in C programs.  You may edit
Xany of these files as the need arises after running this script.
X
XIf you make a mistake on a question, there is no easy way to back up to it
Xcurrently.  The easiest thing to do is to edit config.sh and rerun all the
XSH files.  Configure will offer to let you do this before it runs the SH files.
X
XEOH
Xrp="[Type carriage return to continue]"
Xecho $n "$rp $c"
X. myread
X
X: get old answers, if there is a config file out there
Xif test -f ../config.sh; then
X    echo " "
X    dflt=y
X    rp="I see a config.sh file.  Did Configure make it on THIS system? [$dflt]"
X    echo $n "$rp $c"
X    . myread
X    case "$ans" in
X    n*) echo "OK, I'll ignore it.";;
X    *)  echo "Fetching default answers from your old config.sh file..."
X        tmp="$n"
X        ans="$c"
X        . ../config.sh
X        n="$tmp"
X        c="$ans"
X        ;;
X    esac
Xfi
X
X: find out where common programs are
Xecho " "
Xecho "Locating common programs..."
Xcat <<EOSC >loc
X$startsh
Xcase \$# in
X0) exit 1;;
Xesac
Xthing=\$1
Xshift
Xdflt=\$1
Xshift
Xfor dir in \$*; do
X    case "\$thing" in
X    .)
X        if test -d \$dir/\$thing; then
X            echo \$dir
X            exit 0
X        fi
X        ;;
X    *)
X        if test -f \$dir/\$thing; then
X            echo \$dir/\$thing
X            exit 0
X        fi
X        ;;
X    esac
Xdone
Xecho \$dflt
Xexit 1
XEOSC
Xchmod 755 loc
X$eunicefix loc
Xloclist="
Xexpr
Xsed
Xecho
Xcat
Xrm
Xmv
Xcp
Xtr
Xmkdir
Xsort
Xuniq
Xgrep
X"
Xtrylist="
Xtest
Xegrep
XMcc
X"
Xfor file in $loclist; do
X    xxx=`loc $file $file $pth`
X    eval $file=$xxx
X    eval _$file=$xxx
X    case "$xxx" in
X    /*)
X        echo $file is in $xxx.
X        ;;
X    *)
X        echo "I don't know where $file is.  I hope it's in everyone's PATH."
X        ;;
X    esac
Xdone
Xecho " "
Xecho "Don't worry if any of the following aren't found..."
Xans=offhand
Xfor file in $trylist; do
X    xxx=`loc $file $file $pth`
X    eval $file=$xxx
X    eval _$file=$xxx
X    case "$xxx" in
X    /*)
X        echo $file is in $xxx.
X        ;;
X    *)
X        echo "I don't see $file out there, $ans."
X        ans=either
X        ;;
X    esac
Xdone
Xcase "$egrep" in
Xegrep)
X    echo "Substituting grep for egrep."
X    egrep=$grep
X    ;;
Xesac
Xcase "$test" in
Xtest)
X    echo "Hopefully test is built into your sh."
X    ;;
X/bin/test)
X    echo " "
X    dflt=n
X    rp="Is your "'"'"test"'"'" built into sh? [$dflt] (OK to guess)"
X    echo $n "$rp $c"
X    . myread
X    case "$ans" in
X    y*) test=test ;;
X    esac
X    ;;
X*)
X    test=test
X    ;;
Xesac
Xcase "$echo" in
Xecho)
X    echo "Hopefully echo is built into your sh."
X    ;;
X/bin/echo)
X    echo " "
X    echo "Checking compatibility between /bin/echo and builtin echo (if any)..."
X    $echo $n "hi there$c" >foo1
X    echo $n "hi there$c" >foo2
X    if cmp foo1 foo2 >/dev/null 2>&1; then
X        echo "They are compatible.  In fact, they may be identical."
X    else
X        case "$n" in
X        '-n') n='' c='\c' ans='\c' ;;
X        *) n='-n' c='' ans='-n' ;;
X        esac
X        cat <<FOO
XThey are not compatible!  You are probably running ksh on a non-USG system.
XI'll have to use /bin/echo instead of the builtin, since Bourne shell doesn't
Xhave echo built in and we may have to run some Bourne shell scripts.  That
Xmeans I'll have to use $ans to suppress newlines now.  Life is ridiculous.
X
XFOO
X        rp="Your cursor should be here-->"
X        $echo $n "$rp$c"
X        . myread
X    fi
X    $rm -f foo1 foo2
X    ;;
X*)
X    : cross your fingers
X    echo=echo
X    ;;
Xesac
Xrmlist="$rmlist loc"
X
X: get list of predefined functions in a handy place
Xecho " "
Xif test -f /lib/libc.a; then
X    echo "Your C library is in /lib/libc.a.  You're normal."
X    libc=/lib/libc.a
Xelse
X    ans=`loc libc.a blurfl/dyick $libpth`
X    if test -f $ans; then
X        echo "Your C library is in $ans, of all places."
X        libc=ans
X    else
X        if test -f "$libc"; then
X            echo "Your C library is in $libc, like you said before."
X        else
X            cat <<EOM
X 
XI can't seem to find your C library.  I've looked in the following places:
X
X        $libpth
X
XNone of these seems to contain your C library.  What is the full name
XEOM
X            dflt=None
X            $echo $n "of your C library? $c"
X            rp='C library full name?'
X            . myread
X            libc="$ans"
X        fi
X    fi
Xfi
Xecho " "
X$echo $n "Extracting names from $libc for later perusal...$c"
Xif ar t $libc > libc.list; then
X    echo "done"
Xelse
X    echo " "
X    echo "The archiver doesn't think $libc is a reasonable library."
X    echo "Trying nm instead..."
X    if nm -g $libc > libc.list; then
X        echo "Done.  Maybe this is Unicos, or an Apollo?"
X    else
X        echo "That didn't work either.  Giving up."
X        exit 1
X    fi
Xfi
Xrmlist="$rmlist libc.list"
X
X: make some quick guesses about what we are up against
Xecho " "
X$echo $n "Hmm...  $c"
Xif $contains SIGTSTP /usr/include/signal.h >/dev/null 2>&1 ; then
X    echo "Looks kind of like a BSD system, but we'll see..."
X    echo exit 0 >bsd
X    echo exit 1 >usg
X    echo exit 1 >v7
Xelif $contains fcntl libc.list >/dev/null 2>&1 ; then
X    echo "Looks kind of like a USG system, but we'll see..."
X    echo exit 1 >bsd
X    echo exit 0 >usg
X    echo exit 1 >v7
Xelse
X    echo "Looks kind of like a version 7 system, but we'll see..."
X    echo exit 1 >bsd
X    echo exit 1 >usg
X    echo exit 0 >v7
Xfi
Xif $contains vmssystem libc.list >/dev/null 2>&1 ; then
X    cat <<'EOI'
XThere is, however, a strange, musty smell in the air that reminds me of
Xsomething...hmm...yes...I've got it...there's a VMS nearby, or I'm a Blit.
XEOI
X    echo "exit 0" >eunice
X    eunicefix=unixtovms
X    d_eunice="$define"
X: it so happens the Eunice I know will not run shell scripts in Unix format
Xelse
X    echo " "
X    echo "Congratulations.  You aren't running Eunice."
X    eunicefix=':'
X    d_eunice="$undef"
X    echo "exit 1" >eunice
Xfi
Xif test -f /xenix; then
X    echo "Actually, this looks more like a XENIX system..."
X    echo "exit 0" >xenix
Xelse
X    echo " "
X    echo "It's not Xenix..."
X    echo "exit 1" >xenix
Xfi
Xchmod 755 xenix
Xif test -f /venix; then
X    echo "Actually, this looks more like a VENIX system..."
X    echo "exit 0" >venix
Xelse
X    echo " "
X    if xenix; then
X        : null
X    else
X        echo "Nor is it Venix..."
X    fi
X    echo "exit 1" >venix
Xfi
Xchmod 755 bsd usg v7 eunice venix xenix
X$eunicefix bsd usg v7 eunice venix xenix
Xrmlist="$rmlist bsd usg v7 eunice venix xenix"
X
X: see if sh knows # comments
Xecho " "
Xecho "Checking your sh to see if it knows about # comments..."
Xif sh -c '#' >/dev/null 2>&1 ; then
X    echo "Your sh handles # comments correctly."
X    shsharp=true
X    spitshell=cat
X    echo " "
X    echo "Okay, let's see if #! works on this system..."
X    echo "#!/bin/echo hi" > try
X    $eunicefix try
X    chmod 755 try
X    try > today
X    if test -s today; then
X        echo "It does."
X        sharpbang='#!'
X    else
X        echo "#! /bin/echo hi" > try
X        $eunicefix try
X        chmod 755 try
X        try > today
X        if test -s today; then
X            echo "It does."
X            sharpbang='#! '
X        else
X            echo "It doesn't."
X            sharpbang=': use '
X        fi
X    fi
Xelse
X    echo "Your sh doesn't grok # comments--I will strip them later on."
X    shsharp=false
X    echo "exec grep -v '^#'" >spitshell
X    chmod 755 spitshell
X    $eunicefix spitshell
X    spitshell=`pwd`/spitshell
X    echo "I presume that if # doesn't work, #! won't work either!"
X    sharpbang=': use '
Xfi
X
X: figure out how to guarantee sh startup
Xecho " "
Xecho "Checking out how to guarantee sh startup..."
Xstartsh=$sharpbang'/bin/sh'
Xecho "Let's see if '$startsh' works..."
Xcat >try <<EOSS
X$startsh
Xset abc
Xtest "$?abc" != 1
XEOSS
X
Xchmod 755 try
X$eunicefix try
Xif try; then
X    echo "Yup, it does."
Xelse
X    echo "Nope.  You may have to fix up the shell scripts to make sure sh runs them."
Xfi
Xrm -f try today
X
X: see if sprintf is declared as int or pointer to char
Xecho " "
Xif $contains 'char.*sprintf' /usr/include/stdio.h >/dev/null 2>&1 ; then
X    echo "Your sprintf() returns (char*)."
X    d_charsprf="$define"
Xelse
X    echo "Your sprintf() returns (int)."
X    d_charsprf="$undef"
Xfi
X
X: index or strcpy
Xecho " "
Xdflt=y
Xif $contains index libc.list >/dev/null 2>&1 ; then
X    echo "Your system appears to use index() and rindex() rather than strchr()"
X    $echo $n "and strrchr().  Is this correct? [$dflt] $c"
X    rp='index() rather than strchr()? [$dflt]'
X    . myread
X    case "$ans" in
X        n*|f*) d_index="$define" ;;
X        *)     d_index="$undef" ;;
X    esac
Xelse
X    echo "Your system appears to use strchr() and strrchr() rather than index()"
X    $echo $n "and rindex().  Is this correct? [$dflt] $c"
X    rp='strchr() rather than index()? [$dflt]'
X    . myread
X    case "$ans" in
X        n*|f*) d_index="$undef" ;;
X        *)     d_index="$define" ;;
X    esac
Xfi
X
X: check for structure copying
Xecho " "
Xecho "Checking to see if your C compiler can copy structs..."
X$cat >try.c <<'EOCP'
Xmain()
X{
X        struct blurfl {
X            int dyick;
X        } foo, bar;
X
X        foo = bar;
X}
XEOCP
Xif cc -c try.c >/dev/null 2>&1 ; then
X    d_strctcpy="$define"
X    echo "Yup, it can."
Xelse
X    d_strctcpy="$undef"
X    echo "Nope, it can't."
Xfi
X$rm -f try.*
X
X: see if there is a vfork
Xecho " "
Xif $contains vfork libc.list >/dev/null 2>&1 ; then
X    echo "vfork() found."
X    d_vfork="$undef"
Xelse
X    echo "No vfork() found--will use fork() instead."
X    d_vfork="$define"
Xfi
X
X: check for void type
Xecho " "
X$cat <<EOM
XChecking to see how well your C compiler groks the void type...
X
X  Support flag bits are:
X    1: basic void declarations.
X    2: arrays of pointers to functions returning void.
X    4: operations between pointers to and addresses of void functions.
X
XEOM
Xcase "$voidflags" in
X'')
X    $cat >try.c <<'EOCP'
X#if TRY & 1
Xvoid main() {
X#else
Xmain() {
X#endif
X        extern void *moo();
X        void (*goo)();
X#if TRY & 2
X        void (*foo[10])();
X#endif
X
X#if TRY & 4
X        if(goo == moo) {
X                exit(0);
X        }
X#endif
X        exit(0);
X}
XEOCP
X    if cc -S -DTRY=7 try.c >.out 2>&1 ; then
X        voidflags=7
X        echo "It appears to support void fully."
X        if $contains warning .out >/dev/null 2>&1; then
X            echo "However, you might get some warnings that look like this:"
X            $cat .out
X        fi
X    else
X        echo "Hmm, you compiler has some difficulty with void.  Checking further..."
X        if cc -S -DTRY=1 try.c >/dev/null 2>&1 ; then
X            echo "It supports 1..."
X            if cc -S -DTRY=3 try.c >/dev/null 2>&1 ; then
X                voidflags=3
X                echo "And it supports 2 but not 4."
X            else
X                echo "It doesn't support 2..."
X                if cc -S -DTRY=3 try.c >/dev/null 2>&1 ; then
X                    voidflags=5
X                    echo "But it supports 4."
X                else
X                    voidflags=1
X                    echo "And it doesn't support 4."
X                fi
X            fi
X        else
X            echo "There is no support at all for void."
X            voidflags=0
X        fi
X    fi
Xesac
Xdflt="$voidflags";
Xrp="Your void support flags add up to what? [$dflt]"
X$echo $n "$rp $c"
X. myread
Xvoidflags="$ans"
X$rm -f try.* .out
X
X: preserve RCS keywords in files with variable substitution, grrr
XLog='$Log'
XHeader='$Header'
X
X: set up shell script to do ~ expansion
Xcat >filexp <<EOSS
X$startsh
X: expand filename
Xcase "\$1" in
X ~/*|~)
X    echo \$1 | $sed "s|~|\${HOME-\$LOGDIR}|"
X    ;;
X ~*)
X    if $test -f /bin/csh; then
X        /bin/csh -f -c "glob \$1"
X        echo ""
X    else
X        name=\`$expr x\$1 : '..\([^/]*\)'\`
X        dir=\`$sed -n -e "/^\${name}:/{s/^[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:\([^:]*\).*"'\$'"/\1/" -e p -e q -e '}' </etc/passwd\`
X        if $test ! -d "\$dir"; then
X            me=\`basename \$0\`
X            echo "\$me: can't locate home directory for: \$name" >&2
X            exit 1
X        fi
X        case "\$1" in
X        */*)
X            echo \$dir/\`$expr x\$1 : '..[^/]*/\(.*\)'\`
X            ;;
X        *)
X            echo \$dir
X            ;;
X        esac
X    fi
X    ;;
X*)
X    echo \$1
X    ;;
Xesac
XEOSS
Xchmod 755 filexp
X$eunicefix filexp
X
X: determine where public executables go
Xcase "$bin" in
X'')
X    dflt=`loc . /bin /usr/local/bin /usr/lbin /usr/local /usr/bin`
X    ;;
X*)  dflt="$bin"
X    ;;
Xesac
Xcont=true
Xwhile $test "$cont" ; do
X    echo " "
X    rp="Where do you want to put the public executables? [$dflt]"
X    $echo $n "$rp $c"
X    . myread
X    bin="$ans"
X    bin=`filexp $bin`
X    if test -d $bin; then
X        cont=''
X    else
X        dflt=n
X        rp="Directory $bin doesn't exist.  Use that name anyway? [$dflt]"
X        $echo $n "$rp $c"
X        . myread
X        dflt=''
X        case "$ans" in
X        y*) cont='';;
X        esac
X    fi
Xdone
X
X: determine where manual pages go
Xcase "$mansrc" in
X'')
X    dflt=`loc . /usr/man/man1 /usr/man/mann /usr/man/local/man1 /usr/man/u_man/man1 /usr/man/man1`
X    ;;
X*)  dflt="$mansrc"
X    ;;
Xesac
Xcont=true
Xwhile $test "$cont" ; do
X    echo " "
X    rp="Where do the manual pages (source) go? [$dflt]"
X    $echo $n "$rp $c"
X    . myread
X    mansrc=`filexp "$ans"`
X    if test -d $mansrc; then
X        cont=''
X    else
X        dflt=n
X        rp="Directory $mansrc doesn't exist.  Use that name anyway? [$dflt]"
X        $echo $n "$rp $c"
X        . myread
X        dflt=''
X        case "$ans" in
X        y*) cont='';;
X        esac
X    fi
Xdone
Xcase "$mansrc" in
X*l)
X    manext=l
X    ;;
X*n)
X    manext=n
X    ;;
X*)
X    manext=1
X    ;;
Xesac
X
X: see how we invoke the C preprocessor
Xecho " "
Xecho "Checking to see how your C preprocessor is invoked..."
Xcat <<'EOT' >testcpp.c
X#define ABC abc
X#define XYZ xyz
XABC.XYZ
XEOT
Xecho 'Maybe "cc -E" will work...'
Xcc -E testcpp.c >testcpp.out 2>&1
Xif $contains 'abc.xyz' testcpp.out >/dev/null 2>&1 ; then
X    echo "Yup, it does."
X    cpp='cc -E'
Xelse
X    echo 'Nope...maybe "cc -P" will work...'
X    cc -P testcpp.c >testcpp.out 2>&1
X    if $contains 'abc.xyz' testcpp.out >/dev/null 2>&1 ; then
X        echo "Yup, that does."
X        cpp='cc -P'
X    else
X        echo 'Nixed again...maybe "/lib/cpp" will work...'
X        /lib/cpp testcpp.c >testcpp.out 2>&1
X        if $contains 'abc.xyz' testcpp.out >/dev/null 2>&1 ; then
X            echo "Hooray, it works!  I was beginning to wonder."
X            cpp='/lib/cpp'
X        else
X            echo 'Hmm...maybe you already told me...'
X            case "$cpp" in
X            '') ;;
X            *) $cpp testcpp.c >testcpp.out 2>&1;;
X            esac
X            if $contains 'abc.xyz' testcpp.out >/dev/null 2>&1 ; then
X                echo "Hooray, you did!  I was beginning to wonder."
X            else
X                dflt=blurfl
X                $echo $n "Nope. I can't find a C preprocessor.  Name one: $c"
X                rp='Name a C preprocessor:'
X                . myread
X                cpp="$ans"
X                $cpp testcpp.c >testcpp.out 2>&1
X                if $contains 'abc.xyz' testcpp.out >/dev/null 2>&1 ; then
X                    echo "OK, that will do."
X                else
X                    echo "Sorry, I can't get that to work.  Go find one."
X                    exit 1
X                fi
X            fi
X        fi
X    fi
Xfi
Xrm -f testcpp.c testcpp.out
X
X: get C preprocessor symbols handy
Xecho " "
Xecho $attrlist | $tr '[ ]' '[\012]' >Cppsym.know
X$cat <<EOSS >Cppsym
X$startsh
Xcase "\$1" in
X-l) list=true
X    shift
X    ;;
Xesac
Xunknown=''
Xcase "\$list\$#" in
X1|2)
X    for sym do
X        if $contains "^\$1$" Cppsym.true >/dev/null 2>&1; then
X            exit 0
X        elif $contains "^\$1$" Cppsym.know >/dev/null 2>&1; then
X                :
X        else
X            unknown="\$unknown \$sym"
X        fi
X    done
X    set X \$unknown
X    shift
X    ;;
Xesac
Xcase \$# in
X0) exit 1;;
Xesac
Xecho \$* | $tr '[ ]' '[\012]' | $sed -e 's/\(.*\)/\\
X#ifdef \1\\
Xexit 0; _ _ _ _\1\\         \1\\
X#endif\\
X/' >/tmp/Cppsym\$\$
Xecho exit 1 >>/tmp/Cppsym\$\$
X$cpp /tmp/Cppsym\$\$ >/tmp/Cppsym2\$\$
Xcase "\$list" in
Xtrue) awk '\$6 != "" {print substr(\$6,2,100)}' </tmp/Cppsym2\$\$ ;;
X*)
X    sh /tmp/Cppsym2\$\$
X    status=\$?
X    ;;
Xesac
X$rm -f /tmp/Cppsym\$\$ /tmp/Cppsym2\$\$
Xexit \$status
XEOSS
Xchmod 755 Cppsym
X$eunicefix Cppsym
Xecho "Your C preprocessor defines the following symbols:"
XCppsym -l $attrlist >Cppsym.true
Xcat Cppsym.true
Xrmlist="$rmlist Cppsym Cppsym.know Cppsym.true"
X
X: see what memory models we can support
Xcase "$models" in
X'')
X    if Cppsym pdp11; then
X        dflt='unsplit split'
X    else
X        ans=`loc . X /lib/small /lib/large /usr/lib/small /usr/lib/large /lib/medium /usr/lib/medium /lib/huge`
X        case "$ans" in
X        X) dflt='none';;
X        *)  if $test -d /lib/small || $test -d /usr/lib/small; then
X                dflt='small'
X            else
X                dflt=''
X            fi
X            if $test -d /lib/medium || $test -d /usr/lib/medium; then
X                dflt="$dflt medium"
X            fi
X            if $test -d /lib/large || $test -d /usr/lib/large; then
X                dflt="$dflt large"
X            fi
X            if $test -d /lib/huge || $test -d /usr/lib/huge; then
X                dflt="$dflt huge"
X            fi
X        esac
X    fi
X    ;;
X*)  dflt="$models" ;;
Xesac
X$cat <<EOM
X 
XSome systems have different model sizes.  On most systems they are called
Xsmall, medium, large, and huge.  On the PDP11 they are called unsplit and
Xsplit.  If your system doesn't support different memory models, say "none".
XIf you wish to force everything to one memory model, say "none" here and
Xput the appropriate flags later when it asks you for other cc and ld flags.
XVenix systems may wish to put "none" and let the compiler figure things out.
X(In the following question multiple model names should be space separated.)
X
XEOM
Xrp="Which models are supported? [$dflt]"
X$echo $n "$rp $c"
X. myread
Xmodels="$ans"
X
Xcase "$models" in
Xnone)
X    small=''
X    medium=''
X    large=''
X    huge=''
X    unsplit=''
X    split=''
X    ;;
X*split)
X    case "$split" in
X    '') 
X        if $contains '-i' $mansrc/ld.1 >/dev/null 2>&1 || \
X           $contains '-i' $mansrc/cc.1 >/dev/null 2>&1; then
X            dflt='-i'
X        else
X            dflt='none'
X        fi
X        ;;
X    *) dflt="$split";;
X    esac
X    rp="What flag indicates separate I and D space? [$dflt]"
X    $echo $n "$rp $c"
X    . myread
X    case "$ans" in
X    none) ans='';;
X    esac
X    split="$ans"
X    unsplit=''
X    ;;
X*large*|*small*|*medium*|*huge*)
X    case "$model" in
X    *large*)
X        case "$large" in
X        '') dflt='-Ml';;
X        *) dflt="$large";;
X        esac
X        rp="What flag indicates large model? [$dflt]"
X        $echo $n "$rp $c"
X        . myread
X        case "$ans" in
X        none) ans='';
X        esac
X        large="$ans"
X        ;;
X    *) large='';;
X    esac
X    case "$model" in
X    *huge*)
X        case "$huge" in
X        '') dflt='-Mh';;
X        *) dflt="$huge";;
X        esac
X        rp="What flag indicates huge model? [$dflt]"
X        $echo $n "$rp $c"
X        . myread
X        case "$ans" in
X        none) ans='';
X        esac
X        huge="$ans"
X        ;;
X    *) huge="$large";;
X    esac
X    case "$model" in
X    *medium*)
X        case "$medium" in
X        '') dflt='-Mm';;
X        *) dflt="$medium";;
X        esac
X        rp="What flag indicates medium model? [$dflt]"
X        $echo $n "$rp $c"
X        . myread
X        case "$ans" in
X        none) ans='';
X        esac
X        medium="$ans"
X        ;;
X    *) medium="$large";;
X    esac
X    case "$model" in
X    *small*)
X        case "$small" in
X        '') dflt='none';;
X        *) dflt="$small";;
X        esac
X        rp="What flag indicates small model? [$dflt]"
X        $echo $n "$rp $c"
X        . myread
X        case "$ans" in
X        none) ans='';
X        esac
X        small="$ans"
X        ;;
X    *) small='';;
X    esac
X    ;;
X*)
X    echo "Unrecognized memory models--you may have to edit Makefile.SH"
X    ;;
Xesac
X
Xcase "$ccflags" in
X'') dflt='none';;
X*) dflt="$ccflags";;
Xesac
Xecho " "
Xrp="Any additional cc flags? [$dflt]"
X$echo $n "$rp $c"
X. myread
Xcase "$ans" in
Xnone) ans='';
Xesac
Xccflags="$ans"
X
Xcase "$ldflags" in
X'') if venix; then
X        dflt='-i -z'
X    else
X        dflt='none'
X    fi
X    ;;
X*) dflt="$ldflags";;
Xesac
Xecho " "
Xrp="Any additional ld flags? [$dflt]"
X$echo $n "$rp $c"
X. myread
Xcase "$ans" in
Xnone) ans='';
Xesac
Xldflags="$ans"
X
X: see if we need a special compiler
Xecho " "
Xif usg; then
X    case "$cc" in
X    '')
X        case "$Mcc" in
X        /*) dflt='Mcc'
X            ;;
X        *)
X            case "$large" in
X            -M*)
X                dflt='cc'
X                ;;
X            *)
X                if $contains '\-M' $mansrc/cc.1 >/dev/null 2>&1 ; then
X                    dflt='cc -M'
X                else
X                    dflt='cc'
X                fi
X                ;;
X            esac
X            ;;
X        esac
X        ;;
X    *)  dflt="$cc";;
X    esac
X    $cat <<'EOM'
X 
XOn some systems the default C compiler will not resolve multiple global
Xreferences that happen to have the same name.  On some such systems the
X"Mcc" command may be used to force these to be resolved.  On other systems
Xa "cc -M" command is required.  (Note that the -M flag on other systems
Xindicates a memory model to use!)  What command will force resolution on
XEOM
X    $echo $n "this system? [$dflt] $c"
X    rp="Command to resolve multiple refs? [$dflt]"
X    . myread
X    cc="$ans"
Xelse
X    echo "Not a USG system--assuming cc can resolve multiple definitions."
X    cc=cc
Xfi
X
X: see if we should include -lnm
Xecho " "
Xif $test -r /usr/lib/libnm.a || $test -r /usr/local/lib/libnm.a ; then
X    echo "New math library found."
X    libnm='-lnm'
Xelse
X    ans=`loc libtermlib.a x $libpth`
X    case "$ans" in
X    x)
X        echo "No nm library found--the normal math library will have to do."
X        libnm=''
X        ;;
X    *)
X        echo "New math library found in $ans."
X        libnm="$ans"
X        ;;
X    esac
Xfi
X
Xecho " "
Xecho "End of configuration questions."
Xecho " "
X
X: create config.sh file
Xecho " "
Xif test -d ../UU; then
X    cd ..
Xfi
Xecho "Creating config.sh..."
X$spitshell <<EOT >config.sh
X$startsh
X# config.sh
X# This file was produced by running the Configure script.
X
Xd_eunice='$d_eunice'
Xeunicefix='$eunicefix'
Xdefine='$define'
Xloclist='$loclist'
Xexpr='$expr'
Xsed='$sed'
Xecho='$echo'
Xcat='$cat'
Xrm='$rm'
Xmv='$mv'
Xcp='$cp'
Xtail='$tail'
Xtr='$tr'
Xmkdir='$mkdir'
Xsort='$sort'
Xuniq='$uniq'
Xgrep='$grep'
Xtrylist='$trylist'
Xtest='$test'
Xinews='$inews'
Xegrep='$egrep'
Xmore='$more'
Xpg='$pg'
XMcc='$Mcc'
Xvi='$vi'
Xmailx='$mailx'
Xmail='$mail'
XLog='$Log'
XHeader='$Header'
Xbin='$bin'
Xcc='$cc'
Xcontains='$contains'
Xcpp='$cpp'
Xd_charsprf='$d_charsprf'
Xd_index='$d_index'
Xd_strctcpy='$d_strctcpy'
Xd_vfork='$d_vfork'
Xlibc='$libc'
Xlibnm='$libnm'
Xmansrc='$mansrc'
Xmanext='$manext'
Xmodels='$models'
Xsplit='$split'
Xsmall='$small'
Xmedium='$medium'
Xlarge='$large'
Xhuge='$huge'
Xccflags='$ccflags'
Xldflags='$ldflags'
Xn='$n'
Xc='$c'
Xpackage='$package'
Xspitshell='$spitshell'
Xshsharp='$shsharp'
Xsharpbang='$sharpbang'
Xstartsh='$startsh'
Xvoidflags='$voidflags'
Xdefvoidused='$defvoidused'
XCONFIG=true
XEOT
X 
XCONFIG=true
X
Xecho " "
Xdflt=''
Xecho "If you didn't make any mistakes, then just type a carriage return here."
Xrp="If you need to edit config.sh, do it as a shell escape here:"
X$echo $n "$rp $c"
X. UU/myread
Xcase "$ans" in
X'') ;;
X*) : in case they cannot read
X    eval $ans;;
Xesac
X
Xecho " "
Xecho "Doing variable substitutions on .SH files..."
Xset `$grep '\.SH' <MANIFEST | awk '{print $1}'`
Xfor file in $*; do
X    case "$file" in
X    */*)
X        dir=`$expr X$file : 'X\(.*\)/'`
X        file=`$expr X$file : 'X.*/\(.*\)'`
X        (cd $dir && . $file)
X        ;;
X    *)
X        . $file
X        ;;
X    esac
Xdone
Xif test -f config.h.SH; then
X    if test ! -f config.h; then
X        : oops, they left it out of MANIFEST, probably, so do it anyway.
X        . config.h.SH
X    fi
Xfi
X
Xif $contains '^depend:' Makefile >/dev/null 2>&1; then
X    dflt=n
X    $cat <<EOM
X
XNow you need to generate make dependencies by running "make depend".
XYou might prefer to run it in background: "make depend > makedepend.out &"
XIt can take a while, so you might not want to run it right now.
X
XEOM
X    rp="Run make depend now? [$dflt]"
X    $echo $n "$rp $c"
X    . UU/myread
X    case "$ans" in
X    y*) make depend
X        echo "Now you must run a make."
X        ;;
X    *)  echo "You must run 'make depend' then 'make'."
X        ;;
X    esac
Xelif test -f Makefile; then
X    echo " "
X    echo "Now you must run a make."
Xelse
X    echo "Done."
Xfi
X
X$rm -f kit*isdone
Xcd UU && $rm -f $rmlist
X: end of Configure
!STUFFY!FUNK!
echo Extracting search.c
sed >search.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: search.c,v 1.0 87/12/18 13:05:59 root Exp $
X *
X * $Log:        search.c,v $
X * Revision 1.0  87/12/18  13:05:59  root
X * Initial revision
X * 
X */
X
X/* string search routines */
X 
X#include <stdio.h>
X#include <ctype.h>
X
X#include "EXTERN.h"
X#include "handy.h"
X#include "util.h"
X#include "INTERN.h"
X#include "search.h"
X
X#define VERBOSE
X#define FLUSH
X#define MEM_SIZE int
X
X#ifndef BITSPERBYTE
X#define BITSPERBYTE 8
X#endif
X
X#define BMAPSIZ (127 / BITSPERBYTE + 1)
X
X#define        CHAR        0                /*        a normal character */
X#define        ANY        1                /* .        matches anything except newline */
X#define        CCL        2                /* [..]        character class */
X#define        NCCL        3                /* [^..]negated character class */
X#define BEG        4                /* ^        beginning of a line */
X#define        END        5                /* $        end of a line */
X#define        LPAR        6                /* (        begin sub-match */
X#define        RPAR        7                /* )        end sub-match */
X#define        REF        8                /* \N        backreference to the Nth submatch */
X#define WORD        9                /* \w        matches alphanumeric character */
X#define NWORD        10                /* \W        matches non-alphanumeric character */
X#define WBOUND        11                /* \b        matches word boundary */
X#define NWBOUND        12                /* \B        matches non-boundary  */
X#define        FINIS        13                /*        the end of the pattern */
X 
X#define CODEMASK 15
X
X/* Quantifiers: */
X
X#define MINZERO 16                /* minimum is 0, not 1 */
X#define MAXINF        32                /* maximum is infinity, not 1 */
X 
X#define ASCSIZ 0200
Xtypedef char        TRANSTABLE[ASCSIZ];
X
Xstatic        TRANSTABLE trans = {
X0000,0001,0002,0003,0004,0005,0006,0007,
X0010,0011,0012,0013,0014,0015,0016,0017,
X0020,0021,0022,0023,0024,0025,0026,0027,
X0030,0031,0032,0033,0034,0035,0036,0037,
X0040,0041,0042,0043,0044,0045,0046,0047,
X0050,0051,0052,0053,0054,0055,0056,0057,
X0060,0061,0062,0063,0064,0065,0066,0067,
X0070,0071,0072,0073,0074,0075,0076,0077,
X0100,0101,0102,0103,0104,0105,0106,0107,
X0110,0111,0112,0113,0114,0115,0116,0117,
X0120,0121,0122,0123,0124,0125,0126,0127,
X0130,0131,0132,0133,0134,0135,0136,0137,
X0140,0141,0142,0143,0144,0145,0146,0147,
X0150,0151,0152,0153,0154,0155,0156,0157,
X0160,0161,0162,0163,0164,0165,0166,0167,
X0170,0171,0172,0173,0174,0175,0176,0177,
X};
Xstatic bool folding = FALSE;
X
Xstatic int err;
X#define NOERR 0
X#define BEGFAIL 1
X#define FATAL 2
X
Xstatic char *FirstCharacter;
Xstatic char *matchend;
Xstatic char *matchtill;
X
Xvoid
Xsearch_init()
X{
X#ifdef UNDEF
X    register int    i;
X    
X    for (i = 0; i < ASCSIZ; i++)
X        trans[i] = i;
X#else
X    ;
X#endif
X}
X
Xvoid
Xinit_compex(compex)
Xregister COMPEX *compex;
X{
X    /* the following must start off zeroed */
X
X    compex->precomp = Nullch;
X    compex->complen = 0;
X    compex->subbase = Nullch;
X}
X
X#ifdef NOTUSED
Xvoid
Xfree_compex(compex)
Xregister COMPEX *compex;
X{
X    if (compex->complen) {
X        safefree(compex->compbuf);
X        compex->complen = 0;
X    }
X    if (compex->subbase) {
X        safefree(compex->subbase);
X        compex->subbase = Nullch;
X    }
X}
X#endif
X
Xstatic char *gbr_str = Nullch;
Xstatic int gbr_siz = 0;
X
Xchar *
Xgetparen(compex,n)
Xregister COMPEX *compex;
Xint n;
X{
X    int length = compex->subend[n] - compex->subbeg[n];
X
X    if (!n &&
X        (!compex->numsubs || n > compex->numsubs || !compex->subend[n] || length<0))
X        return "";
X    growstr(&gbr_str, &gbr_siz, length+1);
X    safecpy(gbr_str, compex->subbeg[n], length+1);
X    return gbr_str;
X}
X
Xvoid
Xcase_fold(which)
Xint which;
X{
X    register int i;
X
X    if (which != folding) {
X        if (which) {
X            for (i = 'A'; i <= 'Z'; i++)
X                trans[i] = tolower(i);
X        }
X        else {
X            for (i = 'A'; i <= 'Z'; i++)
X                trans[i] = i;
X        }
X        folding = which;
X    }
X}
X
X/* Compile the regular expression into internal form */
X
Xchar *
Xcompile(compex, sp, regex, fold)
Xregister COMPEX *compex;
Xregister char   *sp;
Xint regex;
Xint fold;
X{
X    register int c;
X    register char  *cp;
X    char   *lastcp;
X    char    paren[MAXSUB],
X           *parenp;
X    char **alt = compex->alternatives;
X    char *retmes = "Badly formed search string";
X 
X    case_fold(compex->do_folding = fold);
X    if (compex->precomp)
X        safefree(compex->precomp);
X    compex->precomp = savestr(sp);
X    if (!compex->complen) {
X        compex->compbuf = safemalloc(84);
X        compex->complen = 80;
X    }
X    cp = compex->compbuf;                /* point at compiled buffer */
X    *alt++ = cp;                        /* first alternative starts here */
X    parenp = paren;                        /* first paren goes here */
X    if (*sp == 0) {                        /* nothing to compile? */
X#ifdef NOTDEF
X        if (*cp == 0)                        /* nothing there yet? */
X            return "Null search string";
X#endif
X        if (*cp)
X            return Nullch;                        /* just keep old expression */
X    }
X    compex->numsubs = 0;                        /* no parens yet */
X    lastcp = 0;
X    for (;;) {
X        if (cp - compex->compbuf >= compex->complen) {
X            char *ocompbuf = compex->compbuf;
X
X            grow_comp(compex);
X            if (ocompbuf != compex->compbuf) {        /* adjust pointers? */
X                char **tmpalt;
X
X                cp = compex->compbuf + (cp - ocompbuf);
X                if (lastcp)
X                    lastcp = compex->compbuf + (lastcp - ocompbuf);
X                for (tmpalt = compex->alternatives; tmpalt < alt; tmpalt++)
X                    if (*tmpalt)
X                        *tmpalt = compex->compbuf + (*tmpalt - ocompbuf);
X            }
X        }
X        c = *sp++;                        /* get next char of pattern */
X        if (c == 0) {                        /* end of pattern? */
X            if (parenp != paren) {        /* balanced parentheses? */
X#ifdef VERBOSE
X                retmes = "Missing right parenthesis";
X#endif
X                goto badcomp;
X            }
X            *cp++ = FINIS;                /* append a stopper */
X            *alt++ = 0;                        /* terminate alternative list */
X            /*
X            compex->complen = cp - compex->compbuf + 1;
X            compex->compbuf = saferealloc(compex->compbuf,compex->complen+4); */
X            return Nullch;                /* return success */
X        }
X        if (c != '*' && c != '?' && c != '+')
X            lastcp = cp;
X        if (!regex) {                        /* just a normal search string? */
X            *cp++ = CHAR;                /* everything is a normal char */
X            *cp++ = trans[c];
X        }
X        else                                /* it is a regular expression */
X            switch (c) {
X 
X                default:
X                  normal_char:
X                    *cp++ = CHAR;
X                    *cp++ = trans[c];
X                    continue;
X
X                case '.':
X                    *cp++ = ANY;
X                    continue;
X 
X                case '[': {                /* character class */
X                    register int i;
X                    
X                    if (cp - compex->compbuf >= compex->complen - BMAPSIZ) {
X                        char *ocompbuf = compex->compbuf;
X
X                        grow_comp(compex);        /* reserve bitmap */
X                        if (ocompbuf != compex->compbuf) {/* adjust pointers? */
X                            char **tmpalt;
X
X                            cp = compex->compbuf + (cp - ocompbuf);
X                            if (lastcp)
X                                lastcp = compex->compbuf + (lastcp - ocompbuf);
X                            for (tmpalt = compex->alternatives; tmpalt < alt;
X                              tmpalt++)
X                                if (*tmpalt)
X                                    *tmpalt =
X                                        compex->compbuf + (*tmpalt - ocompbuf);
X                        }
X                    }
X                    for (i = BMAPSIZ; i; --i)
X                        cp[i] = 0;
X                    
X                    if ((c = *sp++) == '^') {
X                        c = *sp++;
X                        *cp++ = NCCL;        /* negated */
X                    }
X                    else
X                        *cp++ = CCL;        /* normal */
X                    
X                    i = 0;                /* remember oldchar */
X                    do {
X                        if (c == '\0') {
X#ifdef VERBOSE
X                            retmes = "Missing ]";
X#endif
X                            goto badcomp;
X                        }
X                        if (c == '\\' && *sp) {
X                            switch (*sp) {
X                            default:
X                                c = *sp++;
X                                break;
X                            case '0': case '1': case '2': case '3':
X                            case '4': case '5': case '6': case '7':
X                                c = *sp++ - '0';
X                                if (index("01234567",*sp)) {
X                                    c <<= 3;
X                                    c += *sp++ - '0';
X                                }
X                                if (index("01234567",*sp)) {
X                                    c <<= 3;
X                                    c += *sp++ - '0';
X                                }
X                                break;
X                            case 'b':
X                                c = '\b';
X                                sp++;
X                                break;
X                            case 'n':
X                                c = '\n';
X                                sp++;
X                                break;
X                            case 'r':
X                                c = '\r';
X                                sp++;
X                                break;
X                            case 'f':
X                                c = '\f';
X                                sp++;
X                                break;
X                            case 't':
X                                c = '\t';
X                                sp++;
X                                break;
X                            }
X                        }
X                        if (*sp == '-' && *(++sp))
X                            i = *sp++;
X                        else
X                            i = c;
X                        while (c <= i) {
X                            cp[c / BITSPERBYTE] |= 1 << (c % BITSPERBYTE);
X                            if (fold && isalpha(c))
X                                cp[(c ^ 32) / BITSPERBYTE] |=
X                                    1 << ((c ^ 32) % BITSPERBYTE);
X                                        /* set the other bit too */
X                            c++;
X                        }
X                    } while ((c = *sp++) != ']');
X                    if (cp[-1] == NCCL)
X                        cp[0] |= 1;
X                    cp += BMAPSIZ;
X                    continue;
X                }
X 
X                case '^':
X                    if (cp != compex->compbuf && cp[-1] != FINIS)
X                        goto normal_char;
X                    *cp++ = BEG;
X                    continue;
X 
X                case '$':
X                    if (isdigit(*sp)) {
X                        *cp++ = REF;
X                        *cp++ = *sp - '0';
X                        break;
X                    }
X                    if (*sp && *sp != '|')
X                        goto normal_char;
X                    *cp++ = END;
X                    continue;
X 
X                case '*': case '?': case '+':
X                    if (lastcp == 0 ||
X                        (*lastcp & (MINZERO|MAXINF)) ||
X                        *lastcp == LPAR ||
X                        *lastcp == RPAR ||
X                        *lastcp == BEG ||
X                        *lastcp == END ||
X                        *lastcp == WBOUND ||
X                        *lastcp == NWBOUND )
X                        goto normal_char;
X                    if (c != '+')
X                        *lastcp |= MINZERO;
X                    if (c != '?')
X                        *lastcp |= MAXINF;
X                    continue;
X 
X                case '(':
X                    if (compex->numsubs >= MAXSUB) {
X#ifdef VERBOSE
X                        retmes = "Too many parens";
X#endif
X                        goto badcomp;
X                    }
X                    *parenp++ = ++compex->numsubs;
X                    *cp++ = LPAR;
X                    *cp++ = compex->numsubs;
X                    break;
X                case ')':
X                    if (parenp <= paren) {
X#ifdef VERBOSE
X                        retmes = "Unmatched right paren";
X#endif
X                        goto badcomp;
X                    }
X                    *cp++ = RPAR;
X                    *cp++ = *--parenp;
X                    break;
X                case '|':
X                    if (parenp>paren) {
X#ifdef VERBOSE
X                        retmes = "No | in subpattern";        /* Sigh! */
X#endif
X                        goto badcomp;
X                    }
X                    *cp++ = FINIS;
X                    if (alt - compex->alternatives >= MAXALT) {
X#ifdef VERBOSE
X                        retmes = "Too many alternatives";
X#endif
X                        goto badcomp;
X                    }
X                    *alt++ = cp;
X                    break;
X                case '\\':                /* backslashed thingie */
X                    switch (c = *sp++) {
X                    case '0': case '1': case '2': case '3': case '4':
X                    case '5': case '6': case '7': case '8': case '9':
X                        *cp++ = REF;
X                        *cp++ = c - '0';
X                        break;
X                    case 'w':
X                        *cp++ = WORD;
X                        break;
X                    case 'W':
X                        *cp++ = NWORD;
X                        break;
X                    case 'b':
X                        *cp++ = WBOUND;
X                        break;
X                    case 'B':
X                        *cp++ = NWBOUND;
X                        break;
X                    default:
X                        *cp++ = CHAR;
X                        if (c == '\0')
X                            goto badcomp;
X                        switch (c) {
X                        case 'n':
X                            c = '\n';
X                            break;
X                        case 'r':
X                            c = '\r';
X                            break;
X                        case 'f':
X                            c = '\f';
X                            break;
X                        case 't':
X                            c = '\t';
X                            break;
X                        }
X                        *cp++ = c;
X                        break;
X                    }
X                    break;
X            }
X    }
Xbadcomp:
X    compex->compbuf[0] = 0;
X    compex->numsubs = 0;
X    return retmes;
X}
X
Xvoid
Xgrow_comp(compex)
Xregister COMPEX *compex;
X{
X    compex->complen += 80;
X    compex->compbuf = saferealloc(compex->compbuf, (MEM_SIZE)compex->complen + 4);
X}
X
Xchar *
Xexecute(compex, addr, beginning, minend)
Xregister COMPEX *compex;
Xchar *addr;
Xbool beginning;
Xint minend;
X{
X    register char *p1 = addr;
X    register char *trt = trans;
X    register int c;
X    register int scr;
X    register int c2;
X 
X    if (addr == Nullch)
X        return Nullch;
X    if (compex->numsubs) {                        /* any submatches? */
X        for (c = 0; c <= compex->numsubs; c++)
X            compex->subbeg[c] = compex->subend[c] = Nullch;
X    }
X    case_fold(compex->do_folding);        /* make sure table is correct */
X    if (beginning)
X        FirstCharacter = p1;                /* for ^ tests */
X    else {
X        if (multiline || compex->alternatives[1] || compex->compbuf[0] != BEG)
X            FirstCharacter = Nullch;
X        else
X            return Nullch;                /* can't match */
X    }
X    matchend = Nullch;
X    matchtill = addr + minend;
X    err = 0;
X    if (compex->compbuf[0] == CHAR && !compex->alternatives[1]) {
X        if (compex->do_folding) {
X            c = compex->compbuf[1];        /* fast check for first character */
X            do {
X                if (trt[*p1] == c && try(compex, p1, compex->compbuf))
X                    goto got_it;
X            } while (*p1++ && !err);
X        }
X        else {
X            c = compex->compbuf[1];        /* faster check for first character */
X            if (compex->compbuf[2] == CHAR)
X                c2 = compex->compbuf[3];
X            else
X                c2 = 0;
X            do {
X              false_alarm:
X                while (scr = *p1++, scr && scr != c) ;
X                if (!scr)
X                    break;
X                if (c2 && *p1 != c2)        /* and maybe even second character */
X                    goto false_alarm;
X                if (try(compex, p1, compex->compbuf+2)) {
X                    p1--;
X                    goto got_it;
X                }
X            } while (!err);
X        }
X        return Nullch;
X    }
X    else {                        /* normal algorithm */
X        do {
X            register char **alt = compex->alternatives;
X            while (*alt) {
X                if (try(compex, p1, *alt++))
X                    goto got_it;
X            }
X        } while (*p1++ && err < FATAL);
X        return Nullch;
X    }
X
Xgot_it:
X    if (compex->numsubs) {                        /* any parens? */
X        trt = savestr(addr);                /* in case addr is not static */
X        if (compex->subbase)
X            safefree(compex->subbase);        /* (may be freeing addr!) */
X        compex->subbase = trt;
X        scr = compex->subbase - addr;
X        p1 += scr;
X        matchend += scr;
X        for (c = 0; c <= compex->numsubs; c++) {
X            if (compex->subend[c]) {
X                compex->subbeg[c] += scr;
X                compex->subend[c] += scr;
X            }
X        }
X    }
X    compex->subend[0] = matchend;
X    compex->subbeg[0] = p1;
X    return p1;
X}
X 
Xbool
Xtry(compex, sp, cp)
XCOMPEX *compex;
Xregister char *cp;
Xregister char *sp;
X{
X    register char *basesp;
X    register char *trt = trans;
X    register int i;
X    register int backlen;
X    register int code;
X 
X    while (*sp || (*cp & MAXINF) || *cp == BEG || *cp == RPAR ||
X        *cp == WBOUND || *cp == NWBOUND) {
X        switch ((code = *cp++) & CODEMASK) {
X 
X            case CHAR:
X                basesp = sp;
X                i = *cp++;
X                if (code & MAXINF)
X                    while (*sp && trt[*sp] == i) sp++;
X                else
X                    if (*sp && trt[*sp] == i) sp++;
X                backlen = 1;
X                goto backoff;
X 
X          backoff:
X                while (sp > basesp) {
X                    if (try(compex, sp, cp))
X                        goto right;
X                    sp -= backlen;
X                }
X                if (code & MINZERO)
X                    continue;
X                goto wrong;
X 
X            case ANY:
X                basesp = sp;
X                if (code & MAXINF)
X                    while (*sp && *sp != '\n') sp++;
X                else
X                    if (*sp && *sp != '\n') sp++;
X                backlen = 1;
X                goto backoff;
X
X            case CCL:
X                basesp = sp;
X                if (code & MAXINF)
X                    while (*sp && cclass(cp, *sp, 1)) sp++;
X                else
X                    if (*sp && cclass(cp, *sp, 1)) sp++;
X                cp += BMAPSIZ;
X                backlen = 1;
X                goto backoff;
X 
X            case NCCL:
X                basesp = sp;
X                if (code & MAXINF)
X                    while (*sp && cclass(cp, *sp, 0)) sp++;
X                else
X                    if (*sp && cclass(cp, *sp, 0)) sp++;
X                cp += BMAPSIZ;
X                backlen = 1;
X                goto backoff;
X 
X            case END:
X                if (!*sp || *sp == '\n') {
X                    matchtill--;
X                    continue;
X                }
X                goto wrong;
X 
X            case BEG:
X                if (sp == FirstCharacter || (
X                    *sp && sp[-1] == '\n') ) {
X                    matchtill--;
X                    continue;
X                }
X                if (!multiline)                /* no point in advancing more */
X                    err = BEGFAIL;
X                goto wrong;
X 
X            case WORD:
X                basesp = sp;
X                if (code & MAXINF)
X                    while (*sp && isalnum(*sp)) sp++;
X                else
X                    if (*sp && isalnum(*sp)) sp++;
X                backlen = 1;
X                goto backoff;
X 
X            case NWORD:
X                basesp = sp;
X                if (code & MAXINF)
X                    while (*sp && !isalnum(*sp)) sp++;
X                else
X                    if (*sp && !isalnum(*sp)) sp++;
X                backlen = 1;
X                goto backoff;
X 
X            case WBOUND:
X                if ((sp == FirstCharacter || !isalnum(sp[-1])) !=
X                        (!*sp || !isalnum(*sp)) )
X                    continue;
X                goto wrong;
X 
X            case NWBOUND:
X                if ((sp == FirstCharacter || !isalnum(sp[-1])) ==
X                        (!*sp || !isalnum(*sp)))
X                    continue;
X                goto wrong;
X 
X            case FINIS:
X                goto right;
X 
X            case LPAR:
X                compex->subbeg[*cp++] = sp;
X                continue;
X 
X            case RPAR:
X                i = *cp++;
X                compex->subend[i] = sp;
X                compex->lastparen = i;
X                continue;
X 
X            case REF:
X                if (compex->subend[i = *cp++] == 0) {
X                    fputs("Bad subpattern reference\n",stdout) FLUSH;
X                    err = FATAL;
X                    goto wrong;
X                }
X                basesp = sp;
X                backlen = compex->subend[i] - compex->subbeg[i];
X                if (code & MAXINF)
X                    while (*sp && subpat(compex, i, sp)) sp += backlen;
X                else
X                    if (*sp && subpat(compex, i, sp)) sp += backlen;
X                goto backoff;
X 
X            default:
X                fputs("Botched pattern compilation\n",stdout) FLUSH;
X                err = FATAL;
X                return -1;
X        }
X    }
X    if (*cp == FINIS || *cp == END) {
Xright:
X        if (matchend == Nullch || sp > matchend)
X            matchend = sp;
X        return matchend >= matchtill;
X    }
Xwrong:
X    matchend = Nullch;
X    return FALSE;
X}
X 
Xbool
Xsubpat(compex, i, sp)
Xregister COMPEX *compex;
Xregister int i;
Xregister char *sp;
X{
X    register char *bp;
X 
X    bp = compex->subbeg[i];
X    while (*sp && *bp == *sp) {
X        bp++;
X        sp++;
X        if (bp >= compex->subend[i])
X            return TRUE;
X    }
X    return FALSE;
X}
X
Xbool
Xcclass(set, c, af)
Xregister char  *set;
Xregister int c;
X{
X    c &= 0177;
X#if BITSPERBYTE == 8
X    if (set[c >> 3] & 1 << (c & 7))
X#else
X    if (set[c / BITSPERBYTE] & 1 << (c % BITSPERBYTE))
X#endif
X        return af;
X    return !af;
X}
!STUFFY!FUNK!
echo Extracting array.c
sed >array.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: array.c,v 1.0 87/12/18 13:04:42 root Exp $
X *
X * $Log:        array.c,v $
X * Revision 1.0  87/12/18  13:04:42  root
X * Initial revision
X * 
X */
X
X#include <stdio.h>
X#include "EXTERN.h"
X#include "handy.h"
X#include "util.h"
X#include "search.h"
X#include "perl.h"
X
XSTR *
Xafetch(ar,key)
Xregister ARRAY *ar;
Xint key;
X{
X    if (key < 0 || key > ar->ary_max)
X        return Nullstr;
X    return ar->ary_array[key];
X}
X
Xbool
Xastore(ar,key,val)
Xregister ARRAY *ar;
Xint key;
XSTR *val;
X{
X    bool retval;
X
X    if (key < 0)
X        return FALSE;
X    if (key > ar->ary_max) {
X        int newmax = key + ar->ary_max / 5;
X
X        ar->ary_array = (STR**)saferealloc((char*)ar->ary_array,
X            (newmax+1) * sizeof(STR*));
X        bzero((char*)&ar->ary_array[ar->ary_max+1],
X            (newmax - ar->ary_max) * sizeof(STR*));
X        ar->ary_max = newmax;
X    }
X    if (key > ar->ary_fill)
X        ar->ary_fill = key;
X    retval = (ar->ary_array[key] != Nullstr);
X    if (retval)
X        str_free(ar->ary_array[key]);
X    ar->ary_array[key] = val;
X    return retval;
X}
X
Xbool
Xadelete(ar,key)
Xregister ARRAY *ar;
Xint key;
X{
X    if (key < 0 || key > ar->ary_max)
X        return FALSE;
X    if (ar->ary_array[key]) {
X        str_free(ar->ary_array[key]);
X        ar->ary_array[key] = Nullstr;
X        return TRUE;
X    }
X    return FALSE;
X}
X
XARRAY *
Xanew()
X{
X    register ARRAY *ar = (ARRAY*)safemalloc(sizeof(ARRAY));
X
X    ar->ary_array = (STR**) safemalloc(5 * sizeof(STR*));
X    ar->ary_fill = -1;
X    ar->ary_max = 4;
X    bzero((char*)ar->ary_array, 5 * sizeof(STR*));
X    return ar;
X}
X
Xvoid
Xafree(ar)
Xregister ARRAY *ar;
X{
X    register int key;
X
X    if (!ar)
X        return;
X    for (key = 0; key <= ar->ary_fill; key++)
X        str_free(ar->ary_array[key]);
X    safefree((char*)ar->ary_array);
X    safefree((char*)ar);
X}
X
Xbool
Xapush(ar,val)
Xregister ARRAY *ar;
XSTR *val;
X{
X    return astore(ar,++(ar->ary_fill),val);
X}
X
XSTR *
Xapop(ar)
Xregister ARRAY *ar;
X{
X    STR *retval;
X
X    if (ar->ary_fill < 0)
X        return Nullstr;
X    retval = ar->ary_array[ar->ary_fill];
X    ar->ary_array[ar->ary_fill--] = Nullstr;
X    return retval;
X}
X
Xaunshift(ar,num)
Xregister ARRAY *ar;
Xregister int num;
X{
X    register int i;
X    register STR **sstr,**dstr;
X
X    if (num <= 0)
X        return;
X    astore(ar,ar->ary_fill+num,(STR*)0);        /* maybe extend array */
X    sstr = ar->ary_array + ar->ary_fill;
X    dstr = sstr + num;
X    for (i = ar->ary_fill; i >= 0; i--) {
X        *dstr-- = *sstr--;
X    }
X    bzero((char*)(ar->ary_array), num * sizeof(STR*));
X}
X
XSTR *
Xashift(ar)
Xregister ARRAY *ar;
X{
X    STR *retval;
X
X    if (ar->ary_fill < 0)
X        return Nullstr;
X    retval = ar->ary_array[0];
X    bcopy((char*)(ar->ary_array+1),(char*)ar->ary_array,
X      ar->ary_fill * sizeof(STR*));
X    ar->ary_array[ar->ary_fill--] = Nullstr;
X    return retval;
X}
X
Xlong
Xalen(ar)
Xregister ARRAY *ar;
X{
X    return (long)ar->ary_fill;
X}
X
Xvoid
Xajoin(ar,delim,str)
Xregister ARRAY *ar;
Xchar *delim;
Xregister STR *str;
X{
X    register int i;
X    register int len;
X    register int dlen;
X
X    if (ar->ary_fill < 0) {
X        str_set(str,"");
X        STABSET(str);
X        return;
X    }
X    dlen = strlen(delim);
X    len = ar->ary_fill * dlen;                /* account for delimiters */
X    for (i = ar->ary_fill; i >= 0; i--)
X        len += str_len(ar->ary_array[i]);
X    str_grow(str,len);                        /* preallocate for efficiency */
X    str_sset(str,ar->ary_array[0]);
X    for (i = 1; i <= ar->ary_fill; i++) {
X        str_ncat(str,delim,dlen);
X        str_scat(str,ar->ary_array[i]);
X    }
X    STABSET(str);
X}
!STUFFY!FUNK!
echo Extracting t/op.sleep
sed >t/op.sleep <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.sleep,v 1.0 87/12/18 13:14:17 root Exp $
X
Xprint "1..1\n";
X
X$x = sleep 2;
Xif ($x == 2) {print "ok 1\n";} else {print "not ok 1\n";}
!STUFFY!FUNK!
echo ""
echo "End of kit 6 (of 10)"
cat /dev/null >kit6isdone
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