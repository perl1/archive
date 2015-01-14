#! /bin/sh

# Make a new directory for the perl sources, cd to it, and run kits 1
# thru 10 through sh.  When all 10 kits have been run, read README.

echo "This is perl 1.0 kit 5 (of 10).  If kit 5 is complete, the line"
echo '"'"End of kit 5 (of 10)"'" will echo at the end.'
echo ""
export PATH || (echo "You didn't use sh, you clunch." ; kill $$)
mkdir t 2>/dev/null
echo Extracting perl.man.1
sed >perl.man.1 <<'!STUFFY!FUNK!' -e 's/X//'
X.rn '' }`
X''' $Header: perl.man.1,v 1.0 87/12/18 16:18:16 root Exp $
X''' 
X''' $Log:        perl.man.1,v $
X''' Revision 1.0  87/12/18  16:18:16  root
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
X.TH PERL 1 LOCAL
X.SH NAME
Xperl - Practical Extraction and Report Language
X.SH SYNOPSIS
X.B perl [options] filename args
X.SH DESCRIPTION
X.I Perl
Xis a interpreted language optimized for scanning arbitrary text files,
Xextracting information from those text files, and printing reports based
Xon that information.
XIt's also a good language for many system management tasks.
XThe language is intended to be practical (easy to use, efficient, complete)
Xrather than beautiful (tiny, elegant, minimal).
XIt combines (in the author's opinion, anyway) some of the best features of C,
X\fIsed\fR, \fIawk\fR, and \fIsh\fR,
Xso people familiar with those languages should have little difficulty with it.
X(Language historians will also note some vestiges of \fIcsh\fR, Pascal, and
Xeven BASIC-PLUS.)
XExpression syntax corresponds quite closely to C expression syntax.
XIf you have a problem that would ordinarily use \fIsed\fR
Xor \fIawk\fR or \fIsh\fR, but it
Xexceeds their capabilities or must run a little faster,
Xand you don't want to write the silly thing in C, then
X.I perl
Xmay be for you.
XThere are also translators to turn your sed and awk scripts into perl scripts.
XOK, enough hype.
X.PP
XUpon startup,
X.I perl
Xlooks for your script in one of the following places:
X.Ip 1. 4 2
XSpecified line by line via
X.B \-e
Xswitches on the command line.
X.Ip 2. 4 2
XContained in the file specified by the first filename on the command line.
X(Note that systems supporting the #! notation invoke interpreters this way.)
X.Ip 3. 4 2
XPassed in via standard input.
X.PP
XAfter locating your script,
X.I perl
Xcompiles it to an internal form.
XIf the script is syntactically correct, it is executed.
X.Sh "Options"
XNote: on first reading this section won't make much sense to you.  It's here
Xat the front for easy reference.
X.PP
XA single-character option may be combined with the following option, if any.
XThis is particularly useful when invoking a script using the #! construct which
Xonly allows one argument.  Example:
X.nf
X
X.ne 2
X        #!/bin/perl -spi.bak        # same as -s -p -i.bak
X        .\|.\|.
X
X.fi
XOptions include:
X.TP 5
X.B \-D<number>
Xsets debugging flags.
XTo watch how it executes your script, use
X.B \-D14.
X(This only works if debugging is compiled into your
X.IR perl .)
X.TP 5
X.B \-e commandline
Xmay be used to enter one line of script.
XMultiple
X.B \-e
Xcommands may be given to build up a multi-line script.
XIf
X.B \-e
Xis given,
X.I perl
Xwill not look for a script filename in the argument list.
X.TP 5
X.B \-i<extension>
Xspecifies that files processed by the <> construct are to be edited
Xin-place.
XIt does this by renaming the input file, opening the output file by the
Xsame name, and selecting that output file as the default for print statements.
XThe extension, if supplied, is added to the name of the
Xold file to make a backup copy.
XIf no extension is supplied, no backup is made.
XSaying \*(L"perl -p -i.bak -e "s/foo/bar/;" ... \*(R" is the same as using
Xthe script:
X.nf
X
X.ne 2
X        #!/bin/perl -pi.bak
X        s/foo/bar/;
X
Xwhich is equivalent to
X
X.ne 14
X        #!/bin/perl
X        while (<>) {
X                if ($ARGV ne $oldargv) {
X                        rename($ARGV,$ARGV . '.bak');
X                        open(ARGVOUT,">$ARGV");
X                        select(ARGVOUT);
X                        $oldargv = $ARGV;
X                }
X                s/foo/bar/;
X        }
X        continue {
X            print;        # this prints to original filename
X        }
X        select(stdout);
X
X.fi
Xexcept that the \-i form doesn't need to compare $ARGV to $oldargv to know when
Xthe filename has changed.
XIt does, however, use ARGVOUT for the selected filehandle.
XNote that stdout is restored as the default output filehandle after the loop.
X.TP 5
X.B \-I<directory>
Xmay be used in conjunction with
X.B \-P
Xto tell the C preprocessor where to look for include files.
XBy default /usr/include and /usr/lib/perl are searched.
X.TP 5
X.B \-n
Xcauses
X.I perl
Xto assume the following loop around your script, which makes it iterate
Xover filename arguments somewhat like \*(L"sed -n\*(R" or \fIawk\fR:
X.nf
X
X.ne 3
X        while (<>) {
X                ...                # your script goes here
X        }
X
X.fi
XNote that the lines are not printed by default.
XSee
X.B \-p
Xto have lines printed.
X.TP 5
X.B \-p
Xcauses
X.I perl
Xto assume the following loop around your script, which makes it iterate
Xover filename arguments somewhat like \fIsed\fR:
X.nf
X
X.ne 5
X        while (<>) {
X                ...                # your script goes here
X        } continue {
X                print;
X        }
X
X.fi
XNote that the lines are printed automatically.
XTo suppress printing use the
X.B \-n
Xswitch.
X.TP 5
X.B \-P
Xcauses your script to be run through the C preprocessor before
Xcompilation by
X.I perl.
X(Since both comments and cpp directives begin with the # character,
Xyou should avoid starting comments with any words recognized
Xby the C preprocessor such as \*(L"if\*(R", \*(L"else\*(R" or \*(L"define\*(R".)
X.TP 5
X.B \-s
Xenables some rudimentary switch parsing for switches on the command line
Xafter the script name but before any filename arguments.
XAny switch found there will set the corresponding variable in the
X.I perl
Xscript.
XThe following script prints \*(L"true\*(R" if and only if the script is
Xinvoked with a -x switch.
X.nf
X
X.ne 2
X        #!/bin/perl -s
X        if ($x) { print "true\en"; }
X
X.fi
X.Sh "Data Types and Objects"
X.PP
XPerl has about two and a half data types: strings, arrays of strings, and
Xassociative arrays.
XStrings and arrays of strings are first class objects, for the most part,
Xin the sense that they can be used as a whole as values in an expression.
XAssociative arrays can only be accessed on an association by association basis;
Xthey don't have a value as a whole (at least not yet).
X.PP
XStrings are interpreted numerically as appropriate.
XA string is interpreted as TRUE in the boolean sense if it is not the null
Xstring or 0.
XBooleans returned by operators are 1 for true and '0' or '' (the null
Xstring) for false.
X.PP
XReferences to string variables always begin with \*(L'$\*(R', even when referring
Xto a string that is part of an array.
XThus:
X.nf
X
X.ne 3
X    $days        \h'|2i'# a simple string variable
X    $days[28]        \h'|2i'# 29th element of array @days
X    $days{'Feb'}\h'|2i'# one value from an associative array
X
Xbut entire arrays are denoted by \*(L'@\*(R':
X
X    @days        \h'|2i'# ($days[0], $days[1],\|.\|.\|. $days[n])
X
X.fi
X.PP
XAny of these four constructs may be assigned to (in compiler lingo, may serve
Xas an lvalue).
X(Additionally, you may find the length of array @days by evaluating
X\*(L"$#days\*(R", as in
X.IR csh .
X[Actually, it's not the length of the array, it's the subscript of the last element, since there is (ordinarily) a 0th element.])
X.PP
XEvery data type has its own namespace.
XYou can, without fear of conflict, use the same name for a string variable,
Xan array, an associative array, a filehandle, a subroutine name, and/or
Xa label.
XSince variable and array references always start with \*(L'$\*(R'
Xor \*(L'@\*(R', the \*(L"reserved\*(R" words aren't in fact reserved
Xwith respect to variable names.
X(They ARE reserved with respect to labels and filehandles, however, which
Xdon't have an initial special character.)
XCase IS significant\*(--\*(L"FOO\*(R", \*(L"Foo\*(R" and \*(L"foo\*(R" are all
Xdifferent names.
XNames which start with a letter may also contain digits and underscores.
XNames which do not start with a letter are limited to one character,
Xe.g. \*(L"$%\*(R" or \*(L"$$\*(R".
X(Many one character names have a predefined significance to
X.I perl.
XMore later.)
X.PP
XString literals are delimited by either single or double quotes.
XThey work much like shell quotes:
Xdouble-quoted string literals are subject to backslash and variable
Xsubstitution; single-quoted strings are not.
XThe usual backslash rules apply for making characters such as newline, tab, etc.
XYou can also embed newlines directly in your strings, i.e. they can end on
Xa different line than they begin.
XThis is nice, but if you forget your trailing quote, the error will not be
Xreported until perl finds another line containing the quote character, which
Xmay be much further on in the script.
XVariable substitution inside strings is limited (currently) to simple string variables.
XThe following code segment prints out \*(L"The price is $100.\*(R"
X.nf
X
X.ne 2
X    $Price = '$100';\h'|3.5i'# not interpreted
X    print "The price is $Price.\e\|n";\h'|3.5i'# interpreted
X
X.fi
X.PP
XArray literals are denoted by separating individual values by commas, and
Xenclosing the list in parentheses.
XIn a context not requiring an array value, the value of the array literal
Xis the value of the final element, as in the C comma operator.
XFor example,
X.nf
X
X    @foo = ('cc', '\-E', $bar);
X
Xassigns the entire array value to array foo, but
X
X    $foo = ('cc', '\-E', $bar);
X
X.fi
Xassigns the value of variable bar to variable foo.
XArray lists may be assigned to if and only if each element of the list
Xis an lvalue:
X.nf
X
X    ($a, $b, $c) = (1, 2, 3);
X
X    ($map{'red'}, $map{'blue'}, $map{'green'}) = (0x00f, 0x0f0, 0xf00);
X
X.fi
X.PP
XNumeric literals are specified in any of the usual floating point or
Xinteger formats.
X.PP
XThere are several other pseudo-literals that you should know about.
XIf a string is enclosed by backticks (grave accents), it is interpreted as
Xa command, and the output of that command is the value of the pseudo-literal,
Xjust like in any of the standard shells.
XThe command is executed each time the pseudo-literal is evaluated.
XUnlike in \f2csh\f1, no interpretation is done on the
Xdata\*(--newlines remain newlines.
X.PP
XEvaluating a filehandle in angle brackets yields the next line
Xfrom that file (newline included, so it's never false until EOF).
XOrdinarily you must assign that value to a variable,
Xbut there is one situation where in which an automatic assignment happens.
XIf (and only if) the input symbol is the only thing inside the conditional of a
X.I while
Xloop, the value is
Xautomatically assigned to the variable \*(L"$_\*(R".
X(This may seem like an odd thing to you, but you'll use the construct
Xin almost every
X.I perl
Xscript you write.)
XAnyway, the following lines are equivalent to each other:
X.nf
X
X.ne 3
X    while ($_ = <stdin>) {
X    while (<stdin>) {
X    for (\|;\|<stdin>;\|) {
X
X.fi
XThe filehandles
X.IR stdin ,
X.I stdout
Xand
X.I stderr
Xare predefined.
XAdditional filehandles may be created with the
X.I open
Xfunction.
X.PP
XThe null filehandle <> is special and can be used to emulate the behavior of
X\fIsed\fR and \fIawk\fR.
XInput from <> comes either from standard input, or from each file listed on
Xthe command line.
XHere's how it works: the first time <> is evaluated, the ARGV array is checked,
Xand if it is null, $ARGV[0] is set to '-', which when opened gives you standard
Xinput.
XThe ARGV array is then processed as a list of filenames.
XThe loop
X.nf
X
X.ne 3
X        while (<>) {
X                .\|.\|.                        # code for each line
X        }
X
X.ne 10
Xis equivalent to
X
X        unshift(@ARGV, '\-') \|if \|$#ARGV < $[;
X        while ($ARGV = shift) {
X                open(ARGV, $ARGV);
X                while (<ARGV>) {
X                        .\|.\|.                # code for each line
X                }
X        }
X
X.fi
Xexcept that it isn't as cumbersome to say.
XIt really does shift array ARGV and put the current filename into
Xvariable ARGV.
XIt also uses filehandle ARGV internally.
XYou can modify @ARGV before the first <> as long as you leave the first
Xfilename at the beginning of the array.
X.PP
XIf you want to set @ARGV to you own list of files, go right ahead.
XIf you want to pass switches into your script, you can
Xput a loop on the front like this:
X.nf
X
X.ne 10
X        while ($_ = $ARGV[0], /\|^\-/\|) {
X                shift;
X            last if /\|^\-\|\-$\|/\|;
X                /\|^\-D\|(.*\|)/ \|&& \|($debug = $1);
X                /\|^\-v\|/ \|&& \|$verbose++;
X                .\|.\|.                # other switches
X        }
X        while (<>) {
X                .\|.\|.                # code for each line
X        }
X
X.fi
XThe <> symbol will return FALSE only once.
XIf you call it again after this it will assume you are processing another
X@ARGV list, and if you haven't set @ARGV, will input from stdin.
X.Sh "Syntax"
X.PP
XA
X.I perl
Xscript consists of a sequence of declarations and commands.
XThe only things that need to be declared in
X.I perl
Xare report formats and subroutines.
XSee the sections below for more information on those declarations.
XAll objects are assumed to start with a null or 0 value.
XThe sequence of commands is executed just once, unlike in
X.I sed
Xand
X.I awk
Xscripts, where the sequence of commands is executed for each input line.
XWhile this means that you must explicitly loop over the lines of your input file
X(or files), it also means you have much more control over which files and which
Xlines you look at.
X(Actually, I'm lying\*(--it is possible to do an implicit loop with either the
X.B \-n
Xor
X.B \-p
Xswitch.)
X.PP
XA declaration can be put anywhere a command can, but has no effect on the
Xexecution of the primary sequence of commands.
XTypically all the declarations are put at the beginning or the end of the script.
X.PP
X.I Perl
Xis, for the most part, a free-form language.
X(The only exception to this is format declarations, for fairly obvious reasons.)
XComments are indicated by the # character, and extend to the end of the line.
XIf you attempt to use /* */ C comments, it will be interpreted either as
Xdivision or pattern matching, depending on the context.
XSo don't do that.
X.Sh "Compound statements"
XIn
X.IR perl ,
Xa sequence of commands may be treated as one command by enclosing it
Xin curly brackets.
XWe will call this a BLOCK.
X.PP
XThe following compound commands may be used to control flow:
X.nf
X
X.ne 4
X        if (EXPR) BLOCK
X        if (EXPR) BLOCK else BLOCK
X        if (EXPR) BLOCK elsif (EXPR) BLOCK ... else BLOCK
X        LABEL while (EXPR) BLOCK
X        LABEL while (EXPR) BLOCK continue BLOCK
X        LABEL for (EXPR; EXPR; EXPR) BLOCK
X        LABEL BLOCK continue BLOCK
X
X.fi
X(Note that, unlike C and Pascal, these are defined in terms of BLOCKs, not
Xstatements.
XThis means that the curly brackets are \fIrequired\fR\*(--no dangling statements allowed.
XIf you want to write conditionals without curly brackets there are several
Xother ways to do it.
XThe following all do the same thing:
X.nf
X
X.ne 5
X    if (!open(foo)) { die "Can't open $foo"; }
X    die "Can't open $foo" unless open(foo);
X    open(foo) || die "Can't open $foo";        # foo or bust!
X    open(foo) ? die "Can't open $foo" : 'hi mom';
X
X.fi
Xthough the last one is a bit exotic.)
X.PP
XThe
X.I if
Xstatement is straightforward.
XSince BLOCKs are always bounded by curly brackets, there is never any
Xambiguity about which
X.I if
Xan
X.I else
Xgoes with.
XIf you use
X.I unless
Xin place of
X.IR if ,
Xthe sense of the test is reversed.
X.PP
XThe
X.I while
Xstatement executes the block as long as the expression is true
X(does not evaluate to the null string or 0).
XThe LABEL is optional, and if present, consists of an identifier followed by
Xa colon.
XThe LABEL identifies the loop for the loop control statements
X.IR next ,
X.I last
Xand
X.I redo
X(see below).
XIf there is a
X.I continue
XBLOCK, it is always executed just before
Xthe conditional is about to be evaluated again, similarly to the third part
Xof a
X.I for
Xloop in C.
XThus it can be used to increment a loop variable, even when the loop has
Xbeen continued via the
X.I next
Xstatement (similar to the C \*(L"continue\*(R" statement).
X.PP
XIf the word
X.I while
Xis replaced by the word
X.IR until ,
Xthe sense of the test is reversed, but the conditional is still tested before
Xthe first iteration.
X.PP
XIn either the
X.I if
Xor the
X.I while
Xstatement, you may replace \*(L"(EXPR)\*(R" with a BLOCK, and the conditional
Xis true if the value of the last command in that block is true.
X.PP
XThe
X.I for
Xloop works exactly like the corresponding
X.I while
Xloop:
X.nf
X
X.ne 12
X        for ($i = 1; $i < 10; $i++) {
X                .\|.\|.
X        }
X
Xis the same as
X
X        $i = 1;
X        while ($i < 10) {
X                .\|.\|.
X        } continue {
X                $i++;
X        }
X.fi
X.PP
XThe BLOCK by itself (labeled or not) is equivalent to a loop that executes
Xonce.
XThus you can use any of the loop control statements in it to leave or
Xrestart the block.
XThe
X.I continue
Xblock is optional.
XThis construct is particularly nice for doing case structures.
X.nf
X
X.ne 6
X        foo: {
X                if (/abc/) { $abc = 1; last foo; }
X                if (/def/) { $def = 1; last foo; }
X                if (/xyz/) { $xyz = 1; last foo; }
X                $nothing = 1;
X        }
X
X.fi
X.Sh "Simple statements"
XThe only kind of simple statement is an expression evaluated for its side
Xeffects.
XEvery expression (simple statement) must be terminated with a semicolon.
XNote that this is like C, but unlike Pascal (and
X.IR awk ).
X.PP
XAny simple statement may optionally be followed by a
Xsingle modifier, just before the terminating semicolon.
XThe possible modifiers are:
X.nf
X
X.ne 4
X        if EXPR
X        unless EXPR
X        while EXPR
X        until EXPR
X
X.fi
XThe
X.I if
Xand
X.I unless
Xmodifiers have the expected semantics.
XThe
X.I while
Xand
X.I unless
Xmodifiers also have the expected semantics (conditional evaluated first),
Xexcept when applied to a do-BLOCK command,
Xin which case the block executes once before the conditional is evaluated.
XThis is so that you can write loops like:
X.nf
X
X.ne 4
X        do {
X                $_ = <stdin>;
X                .\|.\|.
X        } until $_ \|eq \|".\|\e\|n";
X
X.fi
X(See the
X.I do
Xoperator below.  Note also that the loop control commands described later will
XNOT work in this construct, since loop modifiers don't take loop labels.
XSorry.)
X.Sh "Expressions"
XSince
X.I perl
Xexpressions work almost exactly like C expressions, only the differences
Xwill be mentioned here.
X.PP
XHere's what
X.I perl
Xhas that C doesn't:
X.Ip (\|) 8 3
XThe null list, used to initialize an array to null.
X.Ip . 8
XConcatenation of two strings.
X.Ip .= 8
XThe corresponding assignment operator.
X.Ip eq 8
XString equality (== is numeric equality).
XFor a mnemonic just think of \*(L"eq\*(R" as a string.
X(If you are used to the
X.I awk
Xbehavior of using == for either string or numeric equality
Xbased on the current form of the comparands, beware!
XYou must be explicit here.)
X.Ip ne 8
XString inequality (!= is numeric inequality).
X.Ip lt 8
XString less than.
X.Ip gt 8
XString greater than.
X.Ip le 8
XString less than or equal.
X.Ip ge 8
XString greater than or equal.
X.Ip =~ 8 2
XCertain operations search or modify the string \*(L"$_\*(R" by default.
XThis operator makes that kind of operation work on some other string.
XThe right argument is a search pattern, substitution, or translation.
XThe left argument is what is supposed to be searched, substituted, or
Xtranslated instead of the default \*(L"$_\*(R".
XThe return value indicates the success of the operation.
X(If the right argument is an expression other than a search pattern,
Xsubstitution, or translation, it is interpreted as a search pattern
Xat run time.
XThis is less efficient than an explicit search, since the pattern must
Xbe compiled every time the expression is evaluated.)
XThe precedence of this operator is lower than unary minus and autoincrement/decrement, but higher than everything else.
X.Ip !~ 8
XJust like =~ except the return value is negated.
X.Ip x 8
XThe repetition operator.
XReturns a string consisting of the left operand repeated the
Xnumber of times specified by the right operand.
X.nf
X
X        print '-' x 80;                # print row of dashes
X        print '-' x80;                # illegal, x80 is identifier
X
X        print "\et" x ($tab/8), ' ' x ($tab%8);        # tab over
X
X.fi
X.Ip x= 8
XThe corresponding assignment operator.
X.Ip .. 8
XThe range operator, which is bistable.
XIt is false as long as its left argument is false.
XOnce the left argument is true, it stays true until the right argument is true,
XAFTER which it becomes false again.
X(It doesn't become false till the next time it's evaluated.
XIt can become false on the same evaluation it became true, but it still returns
Xtrue once.)
XThe .. operator is primarily intended for doing line number ranges after
Xthe fashion of \fIsed\fR or \fIawk\fR.
XThe precedence is a little lower than || and &&.
XThe value returned is either the null string for false, or a sequence number
X(beginning with 1) for true.
XThe sequence number is reset for each range encountered.
XThe final sequence number in a range has the string 'E0' appended to it, which
Xdoesn't affect its numeric value, but gives you something to search for if you
Xwant to exclude the endpoint.
XYou can exclude the beginning point by waiting for the sequence number to be
Xgreater than 1.
XIf either argument to .. is static, that argument is implicitly compared to
Xthe $. variable, the current line number.
XExamples:
X.nf
X
X.ne 5
X    if (101 .. 200) { print; }        # print 2nd hundred lines
X
X    next line if (1 .. /^$/);        # skip header lines
X
X    s/^/> / if (/^$/ .. eof());        # quote body
X
X.fi
X.PP
XHere is what C has that
X.I perl
Xdoesn't:
X.Ip "unary &" 12
XAddress-of operator.
X.Ip "unary *" 12
XDereference-address operator.
X.PP
XLike C,
X.I perl
Xdoes a certain amount of expression evaluation at compile time, whenever
Xit determines that all of the arguments to an operator are static and have
Xno side effects.
XIn particular, string concatenation happens at compile time between literals that don't do variable substitution.
XBackslash interpretation also happens at compile time.
XYou can say
X.nf
X
X.ne 2
X        'Now is the time for all' . "\|\e\|n" .
X        'good men to come to.'
X
X.fi
Xand this all reduces to one string internally.
X.PP
XAlong with the literals and variables mentioned earlier,
Xthe following operations can serve as terms in an expression:
X.Ip "/PATTERN/" 8 4
XSearches a string for a pattern, and returns true (1) or false ('').
XIf no string is specified via the =~ or !~ operator,
Xthe $_ string is searched.
X(The string specified with =~ need not be an lvalue\*(--it may be the result of an expression evaluation, but remember the =~ binds rather tightly.)
XSee also the section on regular expressions.
X.Sp
XIf you prepend an `m' you can use any pair of characters as delimiters.
XThis is particularly useful for matching Unix path names that contain `/'.
X.Sp
XExamples:
X.nf
X
X.ne 4
X    open(tty, '/dev/tty');
X    <tty> \|=~ \|/\|^[Yy]\|/ \|&& \|do foo(\|);        # do foo if desired
X
X    if (/Version: \|*\|([0-9.]*\|)\|/\|) { $version = $1; }
X
X    next if m#^/usr/spool/uucp#;
X
X.fi
X.Ip "?PATTERN?" 8 4
XThis is just like the /pattern/ search, except that it matches only once between
Xcalls to the
X.I reset
Xoperator.
XThis is a useful optimization when you only want to see the first occurence of
Xsomething in each of a set of files, for instance.
X.Ip "chdir EXPR" 8 2
XChanges the working director to EXPR, if possible.
XReturns 1 upon success, 0 otherwise.
XSee example under die().
X.Ip "chmod LIST" 8 2
XChanges the permissions of a list of files.
XThe first element of the list must be the numerical mode.
XLIST may be an array, in which case you may wish to use the unshift()
Xcommand to put the mode on the front of the array.
XReturns the number of files successfully changed.
XNote: in order to use the value you must put the whole thing in parentheses.
X.nf
X
X        $cnt = (chmod 0755,'foo','bar');
X
X.fi
X.Ip "chop(VARIABLE)" 8 5
X.Ip "chop" 8
XChops off the last character of a string and returns it.
XIt's used primarily to remove the newline from the end of an input record,
Xbut is much more efficient than s/\en// because it neither scans nor copies
Xthe string.
XIf VARIABLE is omitted, chops $_.
XExample:
X.nf
X
X.ne 5
X        while (<>) {
X                chop;        # avoid \en on last field
X                @array = split(/:/);
X                .\|.\|.
X        }
X
X.fi
X.Ip "chown LIST" 8 2
XChanges the owner (and group) of a list of files.
XLIST may be an array.
XThe first two elements of the list must be the NUMERICAL uid and gid, in that order.
XReturns the number of files successfully changed.
XNote: in order to use the value you must put the whole thing in parentheses.
X.nf
X
X        $cnt = (chown $uid,$gid,'foo');
X
X.fi
XHere's an example of looking up non-numeric uids:
X.nf
X
X.ne 16
X        print "User: ";
X        $user = <stdin>;
X        open(pass,'/etc/passwd') || die "Can't open passwd";
X        while (<pass>) {
X                ($login,$pass,$uid,$gid) = split(/:/);
X                $uid{$login} = $uid;
X                $gid{$login} = $gid;
X        }
X        @ary = ('foo','bar','bie','doll');
X        if ($uid{$user} eq '') {
X                die "$user not in passwd file";
X        }
X        else {
X                unshift(@ary,$uid{$user},$gid{$user});
X                chown @ary;
X        }
X
X.fi
X.Ip "close(FILEHANDLE)" 8 5
X.Ip "close FILEHANDLE" 8
XCloses the file or pipe associated with the file handle.
XYou don't have to close FILEHANDLE if you are immediately going to
Xdo another open on it, since open will close it for you.
X(See
X.IR open .)
XHowever, an explicit close on an input file resets the line counter ($.), while
Xthe implicit close done by
X.I open
Xdoes not.
XAlso, closing a pipe will wait for the process executing on the pipe to complete,
Xin case you want to look at the output of the pipe afterwards.
XExample:
X.nf
X
X.ne 4
X        open(output,'|sort >foo');        # pipe to sort
X        ...        # print stuff to output
X        close(output);                # wait for sort to finish
X        open(input,'foo');        # get sort's results
X
X.fi
X.Ip "crypt(PLAINTEXT,SALT)" 8 6
XEncrypts a string exactly like the crypt() function in the C library.
XUseful for checking the password file for lousy passwords.
XOnly the guys wearing white hats should do this.
X.Ip "die EXPR" 8 6
XPrints the value of EXPR to stderr and exits with a non-zero status.
XEquivalent examples:
X.nf
X
X.ne 3
X        die "Can't cd to spool." unless chdir '/usr/spool/news';
X
X        (chdir '/usr/spool/news') || die "Can't cd to spool." 
X
X.fi
XNote that the parens are necessary above due to precedence.
XSee also
X.IR exit .
X.Ip "do BLOCK" 8 4
XReturns the value of the last command in the sequence of commands indicated
Xby BLOCK.
XWhen modified by a loop modifier, executes the BLOCK once before testing the
Xloop condition.
X(On other statements the loop modifiers test the conditional first.)
X.Ip "do SUBROUTINE (LIST)" 8 3
XExecutes a SUBROUTINE declared by a
X.I sub
Xdeclaration, and returns the value
Xof the last expression evaluated in SUBROUTINE.
X(See the section on subroutines later on.)
X.Ip "each(ASSOC_ARRAY)" 8 6
XReturns a 2 element array consisting of the key and value for the next
Xvalue of an associative array, so that you can iterate over it.
XEntries are returned in an apparently random order.
XWhen the array is entirely read, a null array is returned (which when
Xassigned produces a FALSE (0) value).
XThe next call to each() after that will start iterating again.
XThe iterator can be reset only by reading all the elements from the array.
XThe following prints out your environment like the printenv program, only
Xin a different order:
X.nf
X
X.ne 3
X        while (($key,$value) = each(ENV)) {
X                print "$key=$value\en";
X        }
X
X.fi
XSee also keys() and values().
X.Ip "eof(FILEHANDLE)" 8 8
X.Ip "eof" 8
XReturns 1 if the next read on FILEHANDLE will return end of file, or if
XFILEHANDLE is not open.
XIf (FILEHANDLE) is omitted, the eof status is returned for the last file read.
XThe null filehandle may be used to indicate the pseudo file formed of the
Xfiles listed on the command line, i.e. eof() is reasonable to use inside
Xa while (<>) loop.
XExample:
X.nf
X
X.ne 7
X        # insert dashes just before last line
X        while (<>) {
X                if (eof()) {
X                        print "--------------\en";
X                }
X                print;
X        }
X
X.fi
X.Ip "exec LIST" 8 6
XIf there is more than one argument in LIST,
Xcalls execvp() with the arguments in LIST.
XIf there is only one argument, the argument is checked for shell metacharacters.
XIf there are any, the entire argument is passed to /bin/sh -c for parsing.
XIf there are none, the argument is split into words and passed directly to
Xexecvp(), which is more efficient.
XNote: exec (and system) do not flush your output buffer, so you may need to
Xset $| to avoid lost output.
X.Ip "exit EXPR" 8 6
XEvaluates EXPR and exits immediately with that value.
XExample:
X.nf
X
X.ne 2
X        $ans = <stdin>;
X        exit 0 \|if \|$ans \|=~ \|/\|^[Xx]\|/\|;
X
X.fi
XSee also
X.IR die .
X.Ip "exp(EXPR)" 8 3
XReturns e to the power of EXPR.
X.Ip "fork" 8 4
XDoes a fork() call.
XReturns the child pid to the parent process and 0 to the child process.
XNote: unflushed buffers remain unflushed in both processes, which means
Xyou may need to set $| to avoid duplicate output.
X.Ip "gmtime(EXPR)" 8 4
XConverts a time as returned by the time function to a 9-element array with
Xthe time analyzed for the Greenwich timezone.
XTypically used as follows:
X.nf
X
X.ne 3
X    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)
X       = gmtime(time);
X
X.fi
XAll array elements are numeric.
X''' End of part 1
!STUFFY!FUNK!
echo Extracting perl.y
sed >perl.y <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: perl.y,v 1.0 87/12/18 15:48:59 root Exp $
X *
X * $Log:        perl.y,v $
X * Revision 1.0  87/12/18  15:48:59  root
X * Initial revision
X * 
X */
X
X%{
X#include "handy.h"
X#include "EXTERN.h"
X#include "search.h"
X#include "util.h"
X#include "INTERN.h"
X#include "perl.h"
Xchar *tokename[] = {
X"256",
X"word",
X"append","open","write","select","close","loopctl",
X"using","format","do","shift","push","pop","chop",
X"while","until","if","unless","else","elsif","continue","split","sprintf",
X"for", "eof", "tell", "seek", "stat",
X"function(no args)","function(1 arg)","function(2 args)","function(3 args)","array function",
X"join", "sub",
X"format lines",
X"register","array_length", "array",
X"s","pattern",
X"string","y",
X"print", "unary operation",
X"..",
X"||",
X"&&",
X"==","!=", "EQ", "NE",
X"<=",">=", "LT", "GT", "LE", "GE",
X"<<",">>",
X"=~","!~",
X"unary -",
X"++", "--",
X"???"
X};
X
X%}
X
X%start prog
X
X%union {
X    int        ival;
X    char *cval;
X    ARG *arg;
X    CMD *cmdval;
X    struct compcmd compval;
X    STAB *stabval;
X    FCMD *formval;
X}
X
X%token <cval> WORD
X%token <ival> APPEND OPEN WRITE SELECT CLOSE LOOPEX
X%token <ival> USING FORMAT DO SHIFT PUSH POP CHOP
X%token <ival> WHILE UNTIL IF UNLESS ELSE ELSIF CONTINUE SPLIT SPRINTF
X%token <ival> FOR FEOF TELL SEEK STAT 
X%token <ival> FUNC0 FUNC1 FUNC2 FUNC3 STABFUN
X%token <ival> JOIN SUB
X%token <formval> FORMLIST
X%token <stabval> REG ARYLEN ARY
X%token <arg> SUBST PATTERN
X%token <arg> RSTRING TRANS
X
X%type <ival> prog decl format
X%type <stabval>
X%type <cmdval> block lineseq line loop cond sideff nexpr else
X%type <arg> expr sexpr term
X%type <arg> condmod loopmod cexpr
X%type <arg> texpr print
X%type <cval> label
X%type <compval> compblock
X
X%nonassoc <ival> PRINT
X%left ','
X%nonassoc <ival> UNIOP
X%right '='
X%right '?' ':'
X%nonassoc DOTDOT
X%left OROR
X%left ANDAND
X%left '|' '^'
X%left '&'
X%nonassoc EQ NE SEQ SNE
X%nonassoc '<' '>' LE GE SLT SGT SLE SGE
X%left LS RS
X%left '+' '-' '.'
X%left '*' '/' '%' 'x'
X%left MATCH NMATCH 
X%right '!' '~' UMINUS
X%nonassoc INC DEC
X%left '('
X
X%% /* RULES */
X
Xprog        :        lineseq
X                        { main_root = block_head($1); }
X        ;
X
Xcompblock:        block CONTINUE block
X                        { $$.comp_true = $1; $$.comp_alt = $3; }
X        |        block else
X                        { $$.comp_true = $1; $$.comp_alt = $2; }
X        ;
X
Xelse        :        /* NULL */
X                        { $$ = Nullcmd; }
X        |        ELSE block
X                        { $$ = $2; }
X        |        ELSIF '(' expr ')' compblock
X                        { $$ = make_ccmd(C_IF,$3,$5); }
X        ;
X
Xblock        :        '{' lineseq '}'
X                        { $$ = block_head($2); }
X        ;
X
Xlineseq        :        /* NULL */
X                        { $$ = Nullcmd; }
X        |        lineseq line
X                        { $$ = append_line($1,$2); }
X        ;
X
Xline        :        decl
X                        { $$ = Nullcmd; }
X        |        label cond
X                        { $$ = add_label($1,$2); }
X        |        loop        /* loops add their own labels */
X        |        label ';'
X                        { if ($1 != Nullch) {
X                              $$ = add_label(make_acmd(C_EXPR, Nullstab,
X                                  Nullarg, Nullarg) );
X                            } else
X                              $$ = Nullcmd; }
X        |        label sideff ';'
X                        { $$ = add_label($1,$2); }
X        ;
X
Xsideff        :        expr
X                        { $$ = make_acmd(C_EXPR, Nullstab, $1, Nullarg); }
X        |        expr condmod
X                        { $$ = addcond(
X                               make_acmd(C_EXPR, Nullstab, Nullarg, $1), $2); }
X        |        expr loopmod
X                        { $$ = addloop(
X                               make_acmd(C_EXPR, Nullstab, Nullarg, $1), $2); }
X        ;
X
Xcond        :        IF '(' expr ')' compblock
X                        { $$ = make_ccmd(C_IF,$3,$5); }
X        |        UNLESS '(' expr ')' compblock
X                        { $$ = invert(make_ccmd(C_IF,$3,$5)); }
X        |        IF block compblock
X                        { $$ = make_ccmd(C_IF,cmd_to_arg($2),$3); }
X        |        UNLESS block compblock
X                        { $$ = invert(make_ccmd(C_IF,cmd_to_arg($2),$3)); }
X        ;
X
Xloop        :        label WHILE '(' texpr ')' compblock
X                        { $$ = wopt(add_label($1,
X                            make_ccmd(C_WHILE,$4,$6) )); }
X        |        label UNTIL '(' expr ')' compblock
X                        { $$ = wopt(add_label($1,
X                            invert(make_ccmd(C_WHILE,$4,$6)) )); }
X        |        label WHILE block compblock
X                        { $$ = wopt(add_label($1,
X                            make_ccmd(C_WHILE, cmd_to_arg($3),$4) )); }
X        |        label UNTIL block compblock
X                        { $$ = wopt(add_label($1,
X                            invert(make_ccmd(C_WHILE, cmd_to_arg($3),$4)) )); }
X        |        label FOR '(' nexpr ';' texpr ';' nexpr ')' block
X                        /* basically fake up an initialize-while lineseq */
X                        {   yyval.compval.comp_true = $10;
X                            yyval.compval.comp_alt = $8;
X                            $$ = append_line($4,wopt(add_label($1,
X                                make_ccmd(C_WHILE,$6,yyval.compval) ))); }
X        |        label compblock        /* a block is a loop that happens once */
X                        { $$ = add_label($1,make_ccmd(C_BLOCK,Nullarg,$2)); }
X        ;
X
Xnexpr        :        /* NULL */
X                        { $$ = Nullcmd; }
X        |        sideff
X        ;
X
Xtexpr        :        /* NULL means true */
X                        {   scanstr("1"); $$ = yylval.arg; }
X        |        expr
X        ;
X
Xlabel        :        /* empty */
X                        { $$ = Nullch; }
X        |        WORD ':'
X        ;
X
Xloopmod :        WHILE expr
X                        { $$ = $2; }
X        |        UNTIL expr
X                        { $$ = make_op(O_NOT,1,$2,Nullarg,Nullarg,0); }
X        ;
X
Xcondmod :        IF expr
X                        { $$ = $2; }
X        |        UNLESS expr
X                        { $$ = make_op(O_NOT,1,$2,Nullarg,Nullarg,0); }
X        ;
X
Xdecl        :        format
X                        { $$ = 0; }
X        |        subrout
X                        { $$ = 0; }
X        ;
X
Xformat        :        FORMAT WORD '=' FORMLIST '.' 
X                        { stabent($2,TRUE)->stab_form = $4; safefree($2); }
X        |        FORMAT '=' FORMLIST '.'
X                        { stabent("stdout",TRUE)->stab_form = $3; }
X        ;
X
Xsubrout        :        SUB WORD block
X                        { stabent($2,TRUE)->stab_sub = $3; }
X        ;
X
Xexpr        :        print
X        |        cexpr
X        ;
X
Xcexpr        :        sexpr ',' cexpr
X                        { $$ = make_op(O_COMMA, 2, $1, $3, Nullarg,0); }
X        |        sexpr
X        ;
X
Xsexpr        :        sexpr '=' sexpr
X                        {   $1 = listish($1);
X                            if ($1->arg_type == O_LIST)
X                                $3 = listish($3);
X                            $$ = l(make_op(O_ASSIGN, 2, $1, $3, Nullarg,1)); }
X        |        sexpr '*' '=' sexpr
X                        { $$ = l(make_op(O_MULTIPLY, 2, $1, $4, Nullarg,0)); }
X        |        sexpr '/' '=' sexpr
X                        { $$ = l(make_op(O_DIVIDE, 2, $1, $4, Nullarg,0)); }
X        |        sexpr '%' '=' sexpr
X                        { $$ = l(make_op(O_MODULO, 2, $1, $4, Nullarg,0)); }
X        |        sexpr 'x' '=' sexpr
X                        { $$ = l(make_op(O_REPEAT, 2, $1, $4, Nullarg,0)); }
X        |        sexpr '+' '=' sexpr
X                        { $$ = l(make_op(O_ADD, 2, $1, $4, Nullarg,0)); }
X        |        sexpr '-' '=' sexpr
X                        { $$ = l(make_op(O_SUBTRACT, 2, $1, $4, Nullarg,0)); }
X        |        sexpr LS '=' sexpr
X                        { $$ = l(make_op(O_LEFT_SHIFT, 2, $1, $4, Nullarg,0)); }
X        |        sexpr RS '=' sexpr
X                        { $$ = l(make_op(O_RIGHT_SHIFT, 2, $1, $4, Nullarg,0)); }
X        |        sexpr '&' '=' sexpr
X                        { $$ = l(make_op(O_BIT_AND, 2, $1, $4, Nullarg,0)); }
X        |        sexpr '^' '=' sexpr
X                        { $$ = l(make_op(O_XOR, 2, $1, $4, Nullarg,0)); }
X        |        sexpr '|' '=' sexpr
X                        { $$ = l(make_op(O_BIT_OR, 2, $1, $4, Nullarg,0)); }
X        |        sexpr '.' '=' sexpr
X                        { $$ = l(make_op(O_CONCAT, 2, $1, $4, Nullarg,0)); }
X
X
X        |        sexpr '*' sexpr
X                        { $$ = make_op(O_MULTIPLY, 2, $1, $3, Nullarg,0); }
X        |        sexpr '/' sexpr
X                        { $$ = make_op(O_DIVIDE, 2, $1, $3, Nullarg,0); }
X        |        sexpr '%' sexpr
X                        { $$ = make_op(O_MODULO, 2, $1, $3, Nullarg,0); }
X        |        sexpr 'x' sexpr
X                        { $$ = make_op(O_REPEAT, 2, $1, $3, Nullarg,0); }
X        |        sexpr '+' sexpr
X                        { $$ = make_op(O_ADD, 2, $1, $3, Nullarg,0); }
X        |        sexpr '-' sexpr
X                        { $$ = make_op(O_SUBTRACT, 2, $1, $3, Nullarg,0); }
X        |        sexpr LS sexpr
X                        { $$ = make_op(O_LEFT_SHIFT, 2, $1, $3, Nullarg,0); }
X        |        sexpr RS sexpr
X                        { $$ = make_op(O_RIGHT_SHIFT, 2, $1, $3, Nullarg,0); }
X        |        sexpr '<' sexpr
X                        { $$ = make_op(O_LT, 2, $1, $3, Nullarg,0); }
X        |        sexpr '>' sexpr
X                        { $$ = make_op(O_GT, 2, $1, $3, Nullarg,0); }
X        |        sexpr LE sexpr
X                        { $$ = make_op(O_LE, 2, $1, $3, Nullarg,0); }
X        |        sexpr GE sexpr
X                        { $$ = make_op(O_GE, 2, $1, $3, Nullarg,0); }
X        |        sexpr EQ sexpr
X                        { $$ = make_op(O_EQ, 2, $1, $3, Nullarg,0); }
X        |        sexpr NE sexpr
X                        { $$ = make_op(O_NE, 2, $1, $3, Nullarg,0); }
X        |        sexpr SLT sexpr
X                        { $$ = make_op(O_SLT, 2, $1, $3, Nullarg,0); }
X        |        sexpr SGT sexpr
X                        { $$ = make_op(O_SGT, 2, $1, $3, Nullarg,0); }
X        |        sexpr SLE sexpr
X                        { $$ = make_op(O_SLE, 2, $1, $3, Nullarg,0); }
X        |        sexpr SGE sexpr
X                        { $$ = make_op(O_SGE, 2, $1, $3, Nullarg,0); }
X        |        sexpr SEQ sexpr
X                        { $$ = make_op(O_SEQ, 2, $1, $3, Nullarg,0); }
X        |        sexpr SNE sexpr
X                        { $$ = make_op(O_SNE, 2, $1, $3, Nullarg,0); }
X        |        sexpr '&' sexpr
X                        { $$ = make_op(O_BIT_AND, 2, $1, $3, Nullarg,0); }
X        |        sexpr '^' sexpr
X                        { $$ = make_op(O_XOR, 2, $1, $3, Nullarg,0); }
X        |        sexpr '|' sexpr
X                        { $$ = make_op(O_BIT_OR, 2, $1, $3, Nullarg,0); }
X        |        sexpr DOTDOT sexpr
X                        { $$ = make_op(O_FLIP, 4,
X                            flipflip($1),
X                            flipflip($3),
X                            Nullarg,0);}
X        |        sexpr ANDAND sexpr
X                        { $$ = make_op(O_AND, 2, $1, $3, Nullarg,0); }
X        |        sexpr OROR sexpr
X                        { $$ = make_op(O_OR, 2, $1, $3, Nullarg,0); }
X        |        sexpr '?' sexpr ':' sexpr
X                        { $$ = make_op(O_COND_EXPR, 3, $1, $3, $5,0); }
X        |        sexpr '.' sexpr
X                        { $$ = make_op(O_CONCAT, 2, $1, $3, Nullarg,0); }
X        |        sexpr MATCH sexpr
X                        { $$ = mod_match(O_MATCH, $1, $3); }
X        |        sexpr NMATCH sexpr
X                        { $$ = mod_match(O_NMATCH, $1, $3); }
X        |        term INC
X                        { $$ = addflags(1, AF_POST|AF_UP,
X                            l(make_op(O_ITEM,1,$1,Nullarg,Nullarg,0))); }
X        |        term DEC
X                        { $$ = addflags(1, AF_POST,
X                            l(make_op(O_ITEM,1,$1,Nullarg,Nullarg,0))); }
X        |        INC term
X                        { $$ = addflags(1, AF_PRE|AF_UP,
X                            l(make_op(O_ITEM,1,$2,Nullarg,Nullarg,0))); }
X        |        DEC term
X                        { $$ = addflags(1, AF_PRE,
X                            l(make_op(O_ITEM,1,$2,Nullarg,Nullarg,0))); }
X        |        term
X                        { $$ = $1; }
X        ;
X
Xterm        :        '-' term %prec UMINUS
X                        { $$ = make_op(O_NEGATE, 1, $2, Nullarg, Nullarg,0); }
X        |        '!' term
X                        { $$ = make_op(O_NOT, 1, $2, Nullarg, Nullarg,0); }
X        |        '~' term
X                        { $$ = make_op(O_COMPLEMENT, 1, $2, Nullarg, Nullarg,0);}
X        |        '(' expr ')'
X                        { $$ = make_list(hide_ary($2)); }
X        |        '(' ')'
X                        { $$ = make_list(Nullarg); }
X        |        DO block        %prec '('
X                        { $$ = cmd_to_arg($2); }
X        |        REG        %prec '('
X                        { $$ = stab_to_arg(A_STAB,$1); }
X        |        REG '[' expr ']'        %prec '('
X                        { $$ = make_op(O_ARRAY, 2,
X                                $3, stab_to_arg(A_STAB,aadd($1)), Nullarg,0); }
X        |        ARY         %prec '('
X                        { $$ = make_op(O_ARRAY, 1,
X                                stab_to_arg(A_STAB,$1),
X                                Nullarg, Nullarg, 1); }
X        |        REG '{' expr '}'        %prec '('
X                        { $$ = make_op(O_HASH, 2,
X                                $3, stab_to_arg(A_STAB,hadd($1)), Nullarg,0); }
X        |        ARYLEN        %prec '('
X                        { $$ = stab_to_arg(A_ARYLEN,$1); }
X        |        RSTRING        %prec '('
X                        { $$ = $1; }
X        |        PATTERN        %prec '('
X                        { $$ = $1; }
X        |        SUBST        %prec '('
X                        { $$ = $1; }
X        |        TRANS        %prec '('
X                        { $$ = $1; }
X        |        DO WORD '(' expr ')'
X                        { $$ = make_op(O_SUBR, 2,
X                                make_list($4),
X                                stab_to_arg(A_STAB,stabent($2,TRUE)),
X                                Nullarg,1); }
X        |        DO WORD '(' ')'
X                        { $$ = make_op(O_SUBR, 2,
X                                make_list(Nullarg),
X                                stab_to_arg(A_STAB,stabent($2,TRUE)),
X                                Nullarg,1); }
X        |        LOOPEX
X                        { $$ = make_op($1,0,Nullarg,Nullarg,Nullarg,0); }
X        |        LOOPEX WORD
X                        { $$ = make_op($1,1,cval_to_arg($2),
X                            Nullarg,Nullarg,0); }
X        |        UNIOP
X                        { $$ = make_op($1,1,Nullarg,Nullarg,Nullarg,0); }
X        |        UNIOP sexpr
X                        { $$ = make_op($1,1,$2,Nullarg,Nullarg,0); }
X        |        WRITE
X                        { $$ = make_op(O_WRITE, 0,
X                            Nullarg, Nullarg, Nullarg,0); }
X        |        WRITE '(' ')'
X                        { $$ = make_op(O_WRITE, 0,
X                            Nullarg, Nullarg, Nullarg,0); }
X        |        WRITE '(' WORD ')'
X                        { $$ = l(make_op(O_WRITE, 1,
X                            stab_to_arg(A_STAB,stabent($3,TRUE)),
X                            Nullarg, Nullarg,0)); safefree($3); }
X        |        WRITE '(' expr ')'
X                        { $$ = make_op(O_WRITE, 1, $3, Nullarg, Nullarg,0); }
X        |        SELECT '(' WORD ')'
X                        { $$ = l(make_op(O_SELECT, 1,
X                            stab_to_arg(A_STAB,stabent($3,TRUE)),
X                            Nullarg, Nullarg,0)); safefree($3); }
X        |        SELECT '(' expr ')'
X                        { $$ = make_op(O_SELECT, 1, $3, Nullarg, Nullarg,0); }
X        |        OPEN WORD        %prec '('
X                        { $$ = make_op(O_OPEN, 2,
X                            stab_to_arg(A_STAB,stabent($2,TRUE)),
X                            stab_to_arg(A_STAB,stabent($2,TRUE)),
X                            Nullarg,0); }
X        |        OPEN '(' WORD ')'
X                        { $$ = make_op(O_OPEN, 2,
X                            stab_to_arg(A_STAB,stabent($3,TRUE)),
X                            stab_to_arg(A_STAB,stabent($3,TRUE)),
X                            Nullarg,0); }
X        |        OPEN '(' WORD ',' expr ')'
X                        { $$ = make_op(O_OPEN, 2,
X                            stab_to_arg(A_STAB,stabent($3,TRUE)),
X                            $5, Nullarg,0); }
X        |        CLOSE '(' WORD ')'
X                        { $$ = make_op(O_CLOSE, 1,
X                            stab_to_arg(A_STAB,stabent($3,TRUE)),
X                            Nullarg, Nullarg,0); }
X        |        CLOSE WORD        %prec '('
X                        { $$ = make_op(O_CLOSE, 1,
X                            stab_to_arg(A_STAB,stabent($2,TRUE)),
X                            Nullarg, Nullarg,0); }
X        |        FEOF '(' WORD ')'
X                        { $$ = make_op(O_EOF, 1,
X                            stab_to_arg(A_STAB,stabent($3,TRUE)),
X                            Nullarg, Nullarg,0); }
X        |        FEOF '(' ')'
X                        { $$ = make_op(O_EOF, 0,
X                            stab_to_arg(A_STAB,stabent("ARGV",TRUE)),
X                            Nullarg, Nullarg,0); }
X        |        FEOF
X                        { $$ = make_op(O_EOF, 0,
X                            Nullarg, Nullarg, Nullarg,0); }
X        |        TELL '(' WORD ')'
X                        { $$ = make_op(O_TELL, 1,
X                            stab_to_arg(A_STAB,stabent($3,TRUE)),
X                            Nullarg, Nullarg,0); }
X        |        TELL
X                        { $$ = make_op(O_TELL, 0,
X                            Nullarg, Nullarg, Nullarg,0); }
X        |        SEEK '(' WORD ',' sexpr ',' expr ')'
X                        { $$ = make_op(O_SEEK, 3,
X                            stab_to_arg(A_STAB,stabent($3,TRUE)),
X                            $5, $7,1); }
X        |        PUSH '(' WORD ',' expr ')'
X                        { $$ = make_op($1, 2,
X                            make_list($5),
X                            stab_to_arg(A_STAB,aadd(stabent($3,TRUE))),
X                            Nullarg,1); }
X        |        PUSH '(' ARY ',' expr ')'
X                        { $$ = make_op($1, 2,
X                            make_list($5),
X                            stab_to_arg(A_STAB,$3),
X                            Nullarg,1); }
X        |        POP WORD        %prec '('
X                        { $$ = make_op(O_POP, 1,
X                            stab_to_arg(A_STAB,aadd(stabent($2,TRUE))),
X                            Nullarg, Nullarg,0); }
X        |        POP '(' WORD ')'
X                        { $$ = make_op(O_POP, 1,
X                            stab_to_arg(A_STAB,aadd(stabent($3,TRUE))),
X                            Nullarg, Nullarg,0); }
X        |        POP ARY        %prec '('
X                        { $$ = make_op(O_POP, 1,
X                            stab_to_arg(A_STAB,$2),
X                            Nullarg,
X                            Nullarg,
X                            0); }
X        |        POP '(' ARY ')'
X                        { $$ = make_op(O_POP, 1,
X                            stab_to_arg(A_STAB,$3),
X                            Nullarg,
X                            Nullarg,
X                            0); }
X        |        SHIFT WORD        %prec '('
X                        { $$ = make_op(O_SHIFT, 1,
X                            stab_to_arg(A_STAB,aadd(stabent($2,TRUE))),
X                            Nullarg, Nullarg,0); }
X        |        SHIFT '(' WORD ')'
X                        { $$ = make_op(O_SHIFT, 1,
X                            stab_to_arg(A_STAB,aadd(stabent($3,TRUE))),
X                            Nullarg, Nullarg,0); }
X        |        SHIFT ARY        %prec '('
X                        { $$ = make_op(O_SHIFT, 1,
X                            stab_to_arg(A_STAB,$2), Nullarg, Nullarg,0); }
X        |        SHIFT '(' ARY ')'
X                        { $$ = make_op(O_SHIFT, 1,
X                            stab_to_arg(A_STAB,$3), Nullarg, Nullarg,0); }
X        |        SHIFT        %prec '('
X                        { $$ = make_op(O_SHIFT, 1,
X                            stab_to_arg(A_STAB,aadd(stabent("ARGV",TRUE))),
X                            Nullarg, Nullarg,0); }
X        |        SPLIT        %prec '('
X                        { scanpat("/[ \t\n]+/");
X                            $$ = make_split(defstab,yylval.arg); }
X        |        SPLIT '(' WORD ')'
X                        { scanpat("/[ \t\n]+/");
X                            $$ = make_split(stabent($3,TRUE),yylval.arg); }
X        |        SPLIT '(' WORD ',' PATTERN ')'
X                        { $$ = make_split(stabent($3,TRUE),$5); }
X        |        SPLIT '(' WORD ',' PATTERN ',' sexpr ')'
X                        { $$ = mod_match(O_MATCH,
X                            $7,
X                            make_split(stabent($3,TRUE),$5) ); }
X        |        SPLIT '(' sexpr ',' sexpr ')'
X                        { $$ = mod_match(O_MATCH, $5, make_split(defstab,$3) ); }
X        |        SPLIT '(' sexpr ')'
X                        { $$ = mod_match(O_MATCH,
X                            stab_to_arg(A_STAB,defstab),
X                            make_split(defstab,$3) ); }
X        |        JOIN '(' WORD ',' expr ')'
X                        { $$ = make_op(O_JOIN, 2,
X                            $5,
X                            stab_to_arg(A_STAB,aadd(stabent($3,TRUE))),
X                            Nullarg,0); }
X        |        JOIN '(' sexpr ',' expr ')'
X                        { $$ = make_op(O_JOIN, 2,
X                            $3,
X                            make_list($5),
X                            Nullarg,2); }
X        |        SPRINTF '(' expr ')'
X                        { $$ = make_op(O_SPRINTF, 1,
X                            make_list($3),
X                            Nullarg,
X                            Nullarg,1); }
X        |        STAT '(' WORD ')'
X                        { $$ = l(make_op(O_STAT, 1,
X                            stab_to_arg(A_STAB,stabent($3,TRUE)),
X                            Nullarg, Nullarg,0)); }
X        |        STAT '(' expr ')'
X                        { $$ = make_op(O_STAT, 1, $3, Nullarg, Nullarg,0); }
X        |        CHOP
X                        { $$ = l(make_op(O_CHOP, 1,
X                            stab_to_arg(A_STAB,defstab),
X                            Nullarg, Nullarg,0)); }
X        |        CHOP '(' expr ')'
X                        { $$ = l(make_op(O_CHOP, 1, $3, Nullarg, Nullarg,0)); }
X        |        FUNC0
X                        { $$ = make_op($1, 0, Nullarg, Nullarg, Nullarg,0); }
X        |        FUNC1 '(' expr ')'
X                        { $$ = make_op($1, 1, $3, Nullarg, Nullarg,0); }
X        |        FUNC2 '(' sexpr ',' expr ')'
X                        { $$ = make_op($1, 2, $3, $5, Nullarg, 0); }
X        |        FUNC3 '(' sexpr ',' sexpr ',' expr ')'
X                        { $$ = make_op($1, 3, $3, $5, $7, 0); }
X        |        STABFUN '(' WORD ')'
X                        { $$ = make_op($1, 1,
X                                stab_to_arg(A_STAB,hadd(stabent($3,TRUE))),
X                                Nullarg,
X                                Nullarg, 0); }
X        ;
X
Xprint        :        PRINT
X                        { $$ = make_op($1,2,
X                                stab_to_arg(A_STAB,defstab),
X                                stab_to_arg(A_STAB,Nullstab),
X                                Nullarg,0); }
X        |        PRINT expr
X                        { $$ = make_op($1,2,make_list($2),
X                                stab_to_arg(A_STAB,Nullstab),
X                                Nullarg,1); }
X        |        PRINT WORD
X                        { $$ = make_op($1,2,
X                                stab_to_arg(A_STAB,defstab),
X                                stab_to_arg(A_STAB,stabent($2,TRUE)),
X                                Nullarg,1); }
X        |        PRINT WORD expr
X                        { $$ = make_op($1,2,make_list($3),
X                                stab_to_arg(A_STAB,stabent($2,TRUE)),
X                                Nullarg,1); }
X        ;
X
X%% /* PROGRAM */
X#include "perly.c"
!STUFFY!FUNK!
echo Extracting t/io.fs
sed >t/io.fs <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: io.fs,v 1.0 87/12/18 13:12:48 root Exp $
X
Xprint "1..18\n";
X
Xchdir '/tmp';
X`/bin/rm -rf a b c x`;
X
Xumask(022);
X
Xif (umask(0) == 022) {print "ok 1\n";} else {print "not ok 1\n";}
Xopen(fh,'>x') || die "Can't create x";
Xclose(fh);
Xopen(fh,'>a') || die "Can't create a";
Xclose(fh);
X
Xif (link('a','b')) {print "ok 2\n";} else {print "not ok 2\n";}
X
Xif (link('b','c')) {print "ok 3\n";} else {print "not ok 3\n";}
X
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat('c');
X
Xif ($nlink == 3) {print "ok 4\n";} else {print "not ok 4\n";}
Xif (($mode & 0777) == 0666) {print "ok 5\n";} else {print "not ok 5\n";}
X
Xif ((chmod 0777,'a') == 1) {print "ok 6\n";} else {print "not ok 6\n";}
X
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat('c');
Xif (($mode & 0777) == 0777) {print "ok 7\n";} else {print "not ok 7\n";}
X
Xif ((chmod 0700,'c','x') == 2) {print "ok 8\n";} else {print "not ok 8\n";}
X
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat('c');
Xif (($mode & 0777) == 0700) {print "ok 9\n";} else {print "not ok 9\n";}
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat('x');
Xif (($mode & 0777) == 0700) {print "ok 10\n";} else {print "not ok 10\n";}
X
Xif ((unlink 'b','x') == 2) {print "ok 11\n";} else {print "not ok 11\n";}
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat('b');
Xif ($ino == 0) {print "ok 12\n";} else {print "not ok 12\n";}
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat('x');
Xif ($ino == 0) {print "ok 13\n";} else {print "not ok 13\n";}
X
Xif (rename('a','b')) {print "ok 14\n";} else {print "not ok 14\n";}
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat('a');
Xif ($ino == 0) {print "ok 15\n";} else {print "not ok 15\n";}
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat('b');
Xif ($ino) {print "ok 16\n";} else {print "not ok 16\n";}
X
Xif ((unlink 'b') == 1) {print "ok 17\n";} else {print "not ok 17\n";}
X($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,
X    $blksize,$blocks) = stat('b');
Xif ($ino == 0) {print "ok 18\n";} else {print "not ok 18\n";}
Xunlink 'c';
!STUFFY!FUNK!
echo ""
echo "End of kit 5 (of 10)"
cat /dev/null >kit5isdone
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