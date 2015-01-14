#! /bin/sh

# Make a new directory for the perl sources, cd to it, and run kits 1
# thru 10 through sh.  When all 10 kits have been run, read README.

echo "This is perl 1.0 kit 4 (of 10).  If kit 4 is complete, the line"
echo '"'"End of kit 4 (of 10)"'" will echo at the end.'
echo ""
export PATH || (echo "You didn't use sh, you clunch." ; kill $$)
echo Extracting perl.man.2
sed >perl.man.2 <<'!STUFFY!FUNK!' -e 's/X//'
X''' Beginning of part 2
X''' $Header: perl.man.2,v 1.0 87/12/18 16:18:41 root Exp $
X'''
X''' $Log:        perl.man.2,v $
X''' Revision 1.0  87/12/18  16:18:41  root
X''' Initial revision
X''' 
X'''
X.Ip "goto LABEL" 8 6
XFinds the statement labeled with LABEL and resumes execution there.
XCurrently you may only go to statements in the main body of the program
Xthat are not nested inside a do {} construct.
XThis statement is not implemented very efficiently, and is here only to make
Xthe sed-to-perl translator easier.
XUse at your own risk.
X.Ip "hex(EXPR)" 8 2
XReturns the decimal value of EXPR interpreted as an hex string.
X(To interpret strings that might start with 0 or 0x see oct().)
X.Ip "index(STR,SUBSTR)" 8 4
XReturns the position of SUBSTR in STR, based at 0, or whatever you've
Xset the $[ variable to.
XIf the substring is not found, returns one less than the base, ordinarily -1.
X.Ip "int(EXPR)" 8 3
XReturns the integer portion of EXPR.
X.Ip "join(EXPR,LIST)" 8 8
X.Ip "join(EXPR,ARRAY)" 8
XJoins the separate strings of LIST or ARRAY into a single string with fields
Xseparated by the value of EXPR, and returns the string.
XExample:
X.nf
X    
X    $_ = join(\|':', $login,$passwd,$uid,$gid,$gcos,$home,$shell);
X
X.fi
XSee
X.IR split .
X.Ip "keys(ASSOC_ARRAY)" 8 6
XReturns a normal array consisting of all the keys of the named associative
Xarray.
XThe keys are returned in an apparently random order, but it is the same order
Xas either the values() or each() function produces (given that the associative array
Xhas not been modified).
XHere is yet another way to print your environment:
X.nf
X
X.ne 5
X        @keys = keys(ENV);
X        @values = values(ENV);
X        while ($#keys >= 0) {
X                print pop(keys),'=',pop(values),"\n";
X        }
X
X.fi
X.Ip "kill LIST" 8 2
XSends a signal to a list of processes.
XThe first element of the list must be the (numerical) signal to send.
XLIST may be an array, in which case you may wish to use the unshift
Xcommand to put the signal on the front of the array.
XReturns the number of processes successfully signaled.
XNote: in order to use the value you must put the whole thing in parentheses:
X.nf
X
X        $cnt = (kill 9,$child1,$child2);
X
X.fi
X.Ip "last LABEL" 8 8
X.Ip "last" 8
XThe
X.I last
Xcommand is like the
X.I break
Xstatement in C (as used in loops); it immediately exits the loop in question.
XIf the LABEL is omitted, the command refers to the innermost enclosing loop.
XThe
X.I continue
Xblock, if any, is not executed:
X.nf
X
X.ne 4
X        line: while (<stdin>) {
X                last line if /\|^$/;        # exit when done with header
X                .\|.\|.
X        }
X
X.fi
X.Ip "localtime(EXPR)" 8 4
XConverts a time as returned by the time function to a 9-element array with
Xthe time analyzed for the local timezone.
XTypically used as follows:
X.nf
X
X.ne 3
X    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)
X       = localtime(time);
X
X.fi
XAll array elements are numeric.
X.Ip "log(EXPR)" 8 3
XReturns logarithm (base e) of EXPR.
X.Ip "next LABEL" 8 8
X.Ip "next" 8
XThe
X.I next
Xcommand is like the
X.I continue
Xstatement in C; it starts the next iteration of the loop:
X.nf
X
X.ne 4
X        line: while (<stdin>) {
X                next line if /\|^#/;        # discard comments
X                .\|.\|.
X        }
X
X.fi
XNote that if there were a
X.I continue
Xblock on the above, it would get executed even on discarded lines.
XIf the LABEL is omitted, the command refers to the innermost enclosing loop.
X.Ip "length(EXPR)" 8 2
XReturns the length in characters of the value of EXPR.
X.Ip "link(OLDFILE,NEWFILE)" 8 2
XCreates a new filename linked to the old filename.
XReturns 1 for success, 0 otherwise.
X.Ip "oct(EXPR)" 8 2
XReturns the decimal value of EXPR interpreted as an octal string.
X(If EXPR happens to start off with 0x, interprets it as a hex string instead.)
XThe following will handle decimal, octal and hex in the standard notation:
X.nf
X
X        $val = oct($val) if $val =~ /^0/;
X
X.fi
X.Ip "open(FILEHANDLE,EXPR)" 8 8
X.Ip "open(FILEHANDLE)" 8
X.Ip "open FILEHANDLE" 8
XOpens the file whose filename is given by EXPR, and associates it with
XFILEHANDLE.
XIf EXPR is omitted, the string variable of the same name as the FILEHANDLE
Xcontains the filename.
XIf the filename begins with \*(L">\*(R", the file is opened for output.
XIf the filename begins with \*(L">>\*(R", the file is opened for appending.
XIf the filename begins with \*(L"|\*(R", the filename is interpreted
Xas a command to which output is to be piped, and if the filename ends
Xwith a \*(L"|\*(R", the filename is interpreted as command which pipes
Xinput to us.
X(You may not have a command that pipes both in and out.)
XOn non-pipe opens, the filename '\-' represents either stdin or stdout, as
Xappropriate.
XOpen returns 1 upon success, '' otherwise.
XExamples:
X.nf
X    
X.ne 3
X    $article = 100;
X    open article || die "Can't find article $article";
X    while (<article>) {\|.\|.\|.
X
X    open(log, '>>/usr/spool/news/twitlog'\|);
X
X    open(article, "caeser <$article |"\|);                # decrypt article
X
X    open(extract, "|sort >/tmp/Tmp$$"\|);                # $$ is our process#
X
X.fi
X.Ip "ord(EXPR)" 8 3
XReturns the ascii value of the first character of EXPR.
X.Ip "pop ARRAY" 8 6
X.Ip "pop(ARRAY)" 8
XPops and returns the last value of the array, shortening the array by 1.
X''' $tmp = $ARRAY[$#ARRAY--]
X.Ip "print FILEHANDLE LIST" 8 9
X.Ip "print LIST" 8
X.Ip "print" 8
XPrints a string or comma-separated list of strings.
XIf FILEHANDLE is omitted, prints by default to standard output (or to the
Xlast selected output channel\*(--see select()).
XIf LIST is also omitted, prints $_ to stdout.
XLIST may also be an array value.
XTo set the default output channel to something other than stdout use the select operation.
X.Ip "printf FILEHANDLE LIST" 8 9
X.Ip "printf LIST" 8
XEquivalent to a "print FILEHANDLE sprintf(LIST)".
X.Ip "push(ARRAY,EXPR)" 8 7
XTreats ARRAY (@ is optional) as a stack, and pushes the value of EXPR
Xonto the end of ARRAY.
XThe length of ARRAY increases by 1.
XHas the same effect as
X.nf
X
X    $ARRAY[$#ARRAY+1] = EXPR;
X
X.fi
Xbut is more efficient.
X.Ip "redo LABEL" 8 8
X.Ip "redo" 8
XThe
X.I redo
Xcommand restarts the loop block without evaluating the conditional again.
XThe
X.I continue
Xblock, if any, is not executed.
XIf the LABEL is omitted, the command refers to the innermost enclosing loop.
XThis command is normally used by programs that want to lie to themselves
Xabout what was just input:
X.nf
X
X.ne 16
X        # a simpleminded Pascal comment stripper
X        # (warning: assumes no { or } in strings)
X        line: while (<stdin>) {
X                while (s|\|({.*}.*\|){.*}|$1 \||) {}
X                s|{.*}| \||;
X                if (s|{.*| \||) {
X                        $front = $_;
X                        while (<stdin>) {
X                                if (\|/\|}/\|) {        # end of comment?
X                                        s|^|$front{|;
X                                        redo line;
X                                }
X                        }
X                }
X                print;
X        }
X
X.fi
X.Ip "rename(OLDNAME,NEWNAME)" 8 2
XChanges the name of a file.
XReturns 1 for success, 0 otherwise.
X.Ip "reset EXPR" 8 3
XGenerally used in a
X.I continue
Xblock at the end of a loop to clear variables and reset ?? searches
Xso that they work again.
XThe expression is interpreted as a list of single characters (hyphens allowed
Xfor ranges).
XAll string variables beginning with one of those letters are set to the null
Xstring.
XIf the expression is omitted, one-match searches (?pattern?) are reset to
Xmatch again.
XAlways returns 1.
XExamples:
X.nf
X
X.ne 3
X    reset 'X';        \h'|2i'# reset all X variables
X    reset 'a-z';\h'|2i'# reset lower case variables
X    reset;        \h'|2i'# just reset ?? searches
X
X.fi
X.Ip "s/PATTERN/REPLACEMENT/g" 8 3
XSearches a string for a pattern, and if found, replaces that pattern with the
Xreplacement text and returns the number of substitutions made.
XOtherwise it returns false (0).
XThe \*(L"g\*(R" is optional, and if present, indicates that all occurences
Xof the pattern are to be replaced.
XAny delimiter may replace the slashes; if single quotes are used, no
Xinterpretation is done on the replacement string.
XIf no string is specified via the =~ or !~ operator,
Xthe $_ string is searched and modified.
X(The string specified with =~ must be a string variable or array element,
Xi.e. an lvalue.)
XIf the pattern contains a $ that looks like a variable rather than an
Xend-of-string test, the variable will be interpolated into the pattern at
Xrun-time.
XSee also the section on regular expressions.
XExamples:
X.nf
X
X    s/\|\e\|bgreen\e\|b/mauve/g;                # don't change wintergreen
X
X    $path \|=~ \|s|\|/usr/bin|\|/usr/local/bin|;
X
X    s/Login: $foo/Login: $bar/; # run-time pattern
X
X    s/\|([^ \|]*\|) *\|([^ \|]*\|)\|/\|$2 $1/;        # reverse 1st two fields
X
X.fi
X(Note the use of $ instead of \|\e\| in the last example.  See section
Xon regular expressions.)
X.Ip "seek(FILEHANDLE,POSITION,WHENCE)" 8 3
XRandomly positions the file pointer for FILEHANDLE, just like the fseek()
Xcall of stdio.
XReturns 1 upon success, 0 otherwise.
X.Ip "select(FILEHANDLE)" 8 3
XSets the current default filehandle for output.
XThis has two effects: first, a
X.I write
Xor a
X.I print
Xwithout a filehandle will default to this FILEHANDLE.
XSecond, references to variables related to output will refer to this output
Xchannel.
XFor example, if you have to set the top of form format for more than
Xone output channel, you might do the following:
X.nf
X
X.ne 4
X    select(report1);
X    $^ = 'report1_top';
X    select(report2);
X    $^ = 'report2_top';
X
X.fi
XSelect happens to return TRUE if the file is currently open and FALSE otherwise,
Xbut this has no effect on its operation.
X.Ip "shift(ARRAY)" 8 6
X.Ip "shift ARRAY" 8
X.Ip "shift" 8
XShifts the first value of the array off, shortening the array by 1 and
Xmoving everything down.
XIf ARRAY is omitted, shifts the ARGV array.
XSee also unshift().
X.Ip "sleep EXPR" 8 6
X.Ip "sleep" 8
XCauses the script to sleep for EXPR seconds, or forever if no EXPR.
XMay be interrupted by sending the process a SIGALARM.
XReturns the number of seconds actually slept.
X.Ip "split(/PATTERN/,EXPR)" 8 8
X.Ip "split(/PATTERN/)" 8
X.Ip "split" 8
XSplits a string into an array of strings, and returns it.
XIf EXPR is omitted, splits the $_ string.
XIf PATTERN is also omitted, splits on whitespace (/[\ \et\en]+/).
XAnything matching PATTERN is taken to be a delimiter separating the fields.
X(Note that the delimiter may be longer than one character.)
XTrailing null fields are stripped, which potential users of pop() would
Xdo well to remember.
XA pattern matching the null string will split into separate characters.
X.sp
XExample:
X.nf
X
X.ne 5
X        open(passwd, '/etc/passwd');
X        while (<passwd>) {
X.ie t \{\
X                ($login, $passwd, $uid, $gid, $gcos, $home, $shell) = split(\|/\|:\|/\|);
X'br\}
X.el \{\
X                ($login, $passwd, $uid, $gid, $gcos, $home, $shell)
X                        = split(\|/\|:\|/\|);
X'br\}
X                .\|.\|.
X        }
X
X.fi
X(Note that $shell above will still have a newline on it.  See chop().)
XSee also
X.IR join .
X.Ip "sprintf(FORMAT,LIST)" 8 4
XReturns a string formatted by the usual printf conventions.
XThe * character is not supported.
X.Ip "sqrt(EXPR)" 8 3
XReturn the square root of EXPR.
X.Ip "stat(FILEHANDLE)" 8 6
X.Ip "stat(EXPR)" 8
XReturns a 13-element array giving the statistics for a file, either the file
Xopened via FILEHANDLE, or named by EXPR.
XTypically used as follows:
X.nf
X
X.ne 3
X    ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
X       $atime,$mtime,$ctime,$blksize,$blocks)
X           = stat($filename);
X
X.fi
X.Ip "substr(EXPR,OFFSET,LEN)" 8 2
XExtracts a substring out of EXPR and returns it.
XFirst character is at offset 0, or whatever you've set $[ to.
X.Ip "system LIST" 8 6
XDoes exactly the same thing as \*(L"exec LIST\*(R" except that a fork
Xis done first, and the parent process waits for the child process to complete.
XNote that argument processing varies depending on the number of arguments.
XSee exec.
X.Ip "tell(FILEHANDLE)" 8 6
X.Ip "tell" 8
XReturns the current file position for FILEHANDLE.
XIf FILEHANDLE is omitted, assumes the file last read.
X.Ip "time" 8 4
XReturns the number of seconds since January 1, 1970.
XSuitable for feeding to gmtime() and localtime().
X.Ip "times" 8 4
XReturns a four-element array giving the user and system times, in seconds, for this
Xprocess and the children of this process.
X.sp
X    ($user,$system,$cuser,$csystem) = times;
X.sp
X.Ip "tr/SEARCHLIST/REPLACEMENTLIST/" 8 5
X.Ip "y/SEARCHLIST/REPLACEMENTLIST/" 8
XTranslates all occurences of the characters found in the search list with
Xthe corresponding character in the replacement list.
XIt returns the number of characters replaced.
XIf no string is specified via the =~ or !~ operator,
Xthe $_ string is translated.
X(The string specified with =~ must be a string variable or array element,
Xi.e. an lvalue.)
XFor
X.I sed
Xdevotees,
X.I y
Xis provided as a synonym for
X.IR tr .
XExamples:
X.nf
X
X    $ARGV[1] \|=~ \|y/A-Z/a-z/;        \h'|3i'# canonicalize to lower case
X
X    $cnt = tr/*/*/;                \h'|3i'# count the stars in $_
X
X.fi
X.Ip "umask(EXPR)" 8 3
XSets the umask for the process and returns the old one.
X.Ip "unlink LIST" 8 2
XDeletes a list of files.
XLIST may be an array.
XReturns the number of files successfully deleted.
XNote: in order to use the value you must put the whole thing in parentheses:
X.nf
X
X        $cnt = (unlink 'a','b','c');
X
X.fi
X.Ip "unshift(ARRAY,LIST)" 8 4
XDoes the opposite of a shift.
XPrepends list to the front of the array, and returns the number of elements
Xin the new array.
X.nf
X
X        unshift(ARGV,'-e') unless $ARGV[0] =~ /^-/;
X
X.fi
X.Ip "values(ASSOC_ARRAY)" 8 6
XReturns a normal array consisting of all the values of the named associative
Xarray.
XThe values are returned in an apparently random order, but it is the same order
Xas either the keys() or each() function produces (given that the associative array
Xhas not been modified).
XSee also keys() and each().
X.Ip "write(FILEHANDLE)" 8 6
X.Ip "write(EXPR)" 8
X.Ip "write(\|)" 8
XWrites a formatted record (possibly multi-line) to the specified file,
Xusing the format associated with that file.
XBy default the format for a file is the one having the same name is the
Xfilehandle, but the format for the current output channel (see
X.IR select )
Xmay be set explicitly
Xby assigning the name of the format to the $~ variable.
X.sp
XTop of form processing is handled automatically:
Xif there is insufficient room on the current page for the formatted 
Xrecord, the page is advanced, a special top-of-page format is used
Xto format the new page header, and then the record is written.
XBy default the top-of-page format is \*(L"top\*(R", but it
Xmay be set to the
Xformat of your choice by assigning the name to the $^ variable.
X.sp
XIf FILEHANDLE is unspecified, output goes to the current default output channel,
Xwhich starts out as stdout but may be changed by the
X.I select
Xoperator.
XIf the FILEHANDLE is an EXPR, then the expression is evaluated and the
Xresulting string is used to look up the name of the FILEHANDLE at run time.
XFor more on formats, see the section on formats later on.
X.Sh "Subroutines"
XA subroutine may be declared as follows:
X.nf
X
X    sub NAME BLOCK
X
X.fi
X.PP
XAny arguments passed to the routine come in as array @_,
Xthat is ($_[0], $_[1], .\|.\|.).
XThe return value of the subroutine is the value of the last expression
Xevaluated.
XThere are no local variables\*(--everything is a global variable.
X.PP
XA subroutine is called using the
X.I do
Xoperator.
X(CAVEAT: For efficiency reasons recursive subroutine calls are not currently
Xsupported.
XThis restriction may go away in the future.  Then again, it may not.)
X.nf
X
X.ne 12
XExample:
X
X        sub MAX {
X                $max = pop(@_);
X                while ($foo = pop(@_)) {
X                        $max = $foo \|if \|$max < $foo;
X                }
X                $max;
X        }
X
X        .\|.\|.
X        $bestday = do MAX($mon,$tue,$wed,$thu,$fri);
X
X.ne 21
XExample:
X
X        # get a line, combining continuation lines
X        #  that start with whitespace
X        sub get_line {
X                $thisline = $lookahead;
X                line: while ($lookahead = <stdin>) {
X                        if ($lookahead \|=~ \|/\|^[ \^\e\|t]\|/\|) {
X                                $thisline \|.= \|$lookahead;
X                        }
X                        else {
X                                last line;
X                        }
X                }
X                $thisline;
X        }
X
X        $lookahead = <stdin>;        # get first line
X        while ($_ = get_line(\|)) {
X                .\|.\|.
X        }
X
X.fi
X.nf
X.ne 6
XUse array assignment to name your formal arguments:
X
X        sub maybeset {
X                ($key,$value) = @_;
X                $foo{$key} = $value unless $foo{$key};
X        }
X
X.fi
X.Sh "Regular Expressions"
XThe patterns used in pattern matching are regular expressions such as
Xthose used by
X.IR egrep (1).
XIn addition, \ew matches an alphanumeric character and \eW a nonalphanumeric.
XWord boundaries may be matched by \eb, and non-boundaries by \eB.
XThe bracketing construct \|(\ .\|.\|.\ \|) may also be used, $<digit>
Xmatches the digit'th substring, where digit can range from 1 to 9.
X(You can also use the old standby \e<digit> in search patterns,
Xbut $<digit> also works in replacement patterns and in the block controlled
Xby the current conditional.)
X$+ returns whatever the last bracket match matched.
X$& returns the entire matched string.
XUp to 10 alternatives may given in a pattern, separated by |, with the
Xcaveat that \|(\ .\|.\|.\ |\ .\|.\|.\ \|) is illegal.
XExamples:
X.nf
X    
X        s/\|^\|([^ \|]*\|) \|*([^ \|]*\|)\|/\|$2 $1\|/;        # swap first two words
X
X.ne 5
X        if (/\|Time: \|(.\|.\|):\|(.\|.\|):\|(.\|.\|)\|/\|) {
X                $hours = $1;
X                $minutes = $2;
X                $seconds = $3;
X        }
X
X.fi
XBy default, the ^ character matches only the beginning of the string, and
X.I perl
Xdoes certain optimizations with the assumption that the string contains
Xonly one line.
XYou may, however, wish to treat a string as a multi-line buffer, such that
Xthe ^ will match after any newline within the string.
XAt the cost of a little more overhead, you can do this by setting the variable
X$* to 1.
XSetting it back to 0 makes
X.I perl
Xrevert to its old behavior.
X.Sh "Formats"
XOutput record formats for use with the
X.I write
Xoperator may declared as follows:
X.nf
X
X.ne 3
X    format NAME =
X    FORMLIST
X    .
X
X.fi
XIf name is omitted, format \*(L"stdout\*(R" is defined.
XFORMLIST consists of a sequence of lines, each of which may be of one of three
Xtypes:
X.Ip 1. 4
XA comment.
X.Ip 2. 4
XA \*(L"picture\*(R" line giving the format for one output line.
X.Ip 3. 4
XAn argument line supplying values to plug into a picture line.
X.PP
XPicture lines are printed exactly as they look, except for certain fields
Xthat substitute values into the line.
XEach picture field starts with either @ or ^.
XThe @ field (not to be confused with the array marker @) is the normal
Xcase; ^ fields are used
Xto do rudimentary multi-line text block filling.
XThe length of the field is supplied by padding out the field
Xwith multiple <, >, or | characters to specify, respectively, left justfication,
Xright justification, or centering.
XIf any of the values supplied for these fields contains a newline, only
Xthe text up to the newline is printed.
XThe special field @* can be used for printing multi-line values.
XIt should appear by itself on a line.
X.PP
XThe values are specified on the following line, in the same order as
Xthe picture fields.
XThey must currently be either string variable names or string literals (or
Xpseudo-literals).
XCurrently you can separate values with spaces, but commas may be placed
Xbetween values to prepare for possible future versions in which full expressions
Xare allowed as values.
X.PP
XPicture fields that begin with ^ rather than @ are treated specially.
XThe value supplied must be a string variable name which contains a text
Xstring.
X.I Perl
Xputs as much text as it can into the field, and then chops off the front
Xof the string so that the next time the string variable is referenced,
Xmore of the text can be printed.
XNormally you would use a sequence of fields in a vertical stack to print
Xout a block of text.
XIf you like, you can end the final field with .\|.\|., which will appear in the
Xoutput if the text was too long to appear in its entirety.
X.PP
XSince use of ^ fields can produce variable length records if the text to be
Xformatted is short, you can suppress blank lines by putting the tilde (~)
Xcharacter anywhere in the line.
X(Normally you should put it in the front if possible.)
XThe tilde will be translated to a space upon output.
X.PP
XExamples:
X.nf
X.lg 0
X.cs R 25
X
X.ne 10
X# a report on the /etc/passwd file
Xformat top =
X\&                        Passwd File
XName                Login    Office   Uid   Gid Home
X------------------------------------------------------------------
X\&.
Xformat stdout =
X@<<<<<<<<<<<<<<<<<< @||||||| @<<<<<<@>>>> @>>>> @<<<<<<<<<<<<<<<<<
X$name               $login   $office $uid $gid  $home
X\&.
X
X.ne 29
X# a report from a bug report form
Xformat top =
X\&                        Bug Reports
X@<<<<<<<<<<<<<<<<<<<<<<<     @|||         @>>>>>>>>>>>>>>>>>>>>>>>
X$system;                      $%;         $date
X------------------------------------------------------------------
X\&.
Xformat stdout =
XSubject: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
X\&         $subject
XIndex: @<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
X\&       $index                        $description
XPriority: @<<<<<<<<<< Date: @<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
X\&          $priority         $date    $description
XFrom: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
X\&      $from                          $description
XAssigned to: @<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
X\&             $programmer             $description
X\&~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
X\&                                     $description
X\&~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
X\&                                     $description
X\&~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
X\&                                     $description
X\&~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
X\&                                     $description
X\&~                                    ^<<<<<<<<<<<<<<<<<<<<<<<...
X\&                                     $description
X\&.
X
X.cs R
X.lg
XIt is possible to intermix prints with writes on the same output channel,
Xbut you'll have to handle $\- (lines left on the page) yourself.
X.fi
X.PP
XIf you are printing lots of fields that are usually blank, you should consider
Xusing the reset operator between records.
XNot only is it more efficient, but it can prevent the bug of adding another
Xfield and forgetting to zero it.
X.Sh "Predefined Names"
XThe following names have special meaning to
X.IR perl .
XI could have used alphabetic symbols for some of these, but I didn't want
Xto take the chance that someone would say reset "a-zA-Z" and wipe them all
Xout.
XYou'll just have to suffer along with these silly symbols.
XMost of them have reasonable mnemonics, or analogues in one of the shells.
X.Ip $_ 8
XThe default input and pattern-searching space.
XThe following pairs are equivalent:
X.nf
X
X.ne 2
X        while (<>) {\|.\|.\|.        # only equivalent in while!
X        while ($_ = <>) {\|.\|.\|.
X
X.ne 2
X        /\|^Subject:/
X        $_ \|=~ \|/\|^Subject:/
X
X.ne 2
X        y/a-z/A-Z/
X        $_ =~ y/a-z/A-Z/
X
X.ne 2
X        chop
X        chop($_)
X
X.fi 
X(Mnemonic: underline is understood in certain operations.)
X.Ip $. 8
XThe current input line number of the last file that was read.
XReadonly.
X(Mnemonic: many programs use . to mean the current line number.)
X.Ip $/ 8
XThe input record separator, newline by default.
XWorks like awk's RS variable, including treating blank lines as delimiters
Xif set to the null string.
XIf set to a value longer than one character, only the first character is used.
X(Mnemonic: / is used to delimit line boundaries when quoting poetry.)
X.Ip $, 8
XThe output field separator for the print operator.
XOrdinarily the print operator simply prints out the comma separated fields
Xyou specify.
XIn order to get behavior more like awk, set this variable as you would set
Xawk's OFS variable to specify what is printed between fields.
X(Mnemonic: what is printed when there is a , in your print statement.)
X.Ip $\e 8
XThe output record separator for the print operator.
XOrdinarily the print operator simply prints out the comma separated fields
Xyou specify, with no trailing newline or record separator assumed.
XIn order to get behavior more like awk, set this variable as you would set
Xawk's ORS variable to specify what is printed at the end of the print.
X(Mnemonic: you set $\e instead of adding \en at the end of the print.
XAlso, it's just like /, but it's what you get \*(L"back\*(R" from perl.)
X.Ip $# 8
XThe output format for printed numbers.
XThis variable is a half-hearted attempt to emulate awk's OFMT variable.
XThere are times, however, when awk and perl have differing notions of what
Xis in fact numeric.
XAlso, the initial value is %.20g rather than %.6g, so you need to set $#
Xexplicitly to get awk's value.
X(Mnemonic: # is the number sign.)
X.Ip $% 8
XThe current page number of the currently selected output channel.
X(Mnemonic: % is page number in nroff.)
X.Ip $= 8
XThe current page length (printable lines) of the currently selected output
Xchannel.
XDefault is 60.
X(Mnemonic: = has horizontal lines.)
X.Ip $\- 8
XThe number of lines left on the page of the currently selected output channel.
X(Mnemonic: lines_on_page - lines_printed.)
X.Ip $~ 8
XThe name of the current report format for the currently selected output
Xchannel.
X(Mnemonic: brother to $^.)
X.Ip $^ 8
XThe name of the current top-of-page format for the currently selected output
Xchannel.
X(Mnemonic: points to top of page.)
X.Ip $| 8
XIf set to nonzero, forces a flush after every write or print on the currently
Xselected output channel.
XDefault is 0.
XNote that stdout will typically be line buffered if output is to the
Xterminal and block buffered otherwise.
XSetting this variable is useful primarily when you are outputting to a pipe,
Xsuch as when you are running a perl script under rsh and want to see the
Xoutput as it's happening.
X(Mnemonic: when you want your pipes to be piping hot.)
X.Ip $$ 8
XThe process number of the
X.I perl
Xrunning this script.
X(Mnemonic: same as shells.)
X.Ip $? 8
XThe status returned by the last backtick (``) command.
X(Mnemonic: same as sh and ksh.)
X.Ip $+ 8 4
XThe last bracket matched by the last search pattern.
XThis is useful if you don't know which of a set of alternative patterns
Xmatched.
XFor example:
X.nf
X
X    /Version: \|(.*\|)|Revision: \|(.*\|)\|/ \|&& \|($rev = $+);
X
X.fi
X(Mnemonic: be positive and forward looking.)
X.Ip $* 8 2
XSet to 1 to do multiline matching within a string, 0 to assume strings contain
Xa single line.
XDefault is 0.
X(Mnemonic: * matches multiple things.)
X.Ip $0 8
XContains the name of the file containing the
X.I perl
Xscript being executed.
XThe value should be copied elsewhere before any pattern matching happens, which
Xclobbers $0.
X(Mnemonic: same as sh and ksh.)
X.Ip $[ 8 2
XThe index of the first element in an array, and of the first character in
Xa substring.
XDefault is 0, but you could set it to 1 to make
X.I perl
Xbehave more like
X.I awk
X(or Fortran)
Xwhen subscripting and when evaluating the index() and substr() functions.
X(Mnemonic: [ begins subscripts.)
X.Ip $! 8 2
XThe current value of errno, with all the usual caveats.
X(Mnemonic: What just went bang?)
X.Ip @ARGV 8 3
XThe array ARGV contains the command line arguments intended for the script.
XNote that $#ARGV is the generally number of arguments minus one, since
X$ARGV[0] is the first argument, NOT the command name.
XSee $0 for the command name.
X.Ip $ENV{expr} 8 2
XThe associative array ENV contains your current environment.
XSetting a value in ENV changes the environment for child processes.
X.Ip $SIG{expr} 8 2
XThe associative array SIG is used to set signal handlers for various signals.
XExample:
X.nf
X
X.ne 12
X        sub handler {        # 1st argument is signal name
X                ($sig) = @_;
X                print "Caught a SIG$sig--shutting down\n";
X                close(log);
X                exit(0);
X        }
X
X        $SIG{'INT'} = 'handler';
X        $SIG{'QUIT'} = 'handler';
X        ...
X        $SIG{'INT'} = 'DEFAULT';        # restore default action
X        $SIG{'QUIT'} = 'IGNORE';        # ignore SIGQUIT
X
X.fi
X.SH ENVIRONMENT
X.I Perl
Xcurrently uses no environment variables, except to make them available
Xto the script being executed, and to child processes.
XHowever, scripts running setuid would do well to execute the following lines
Xbefore doing anything else, just to keep people honest:
X.nf
X
X.ne 3
X    $ENV{'PATH'} = '/bin:/usr/bin';    # or whatever you need
X    $ENV{'SHELL'} = '/bin/sh' if $ENV{'SHELL'};
X    $ENV{'IFS'} = '' if $ENV{'IFS'};
X
X.fi
X.SH AUTHOR
XLarry Wall <lw...@jpl-devvax.Jpl.Nasa.Gov>
X.SH FILES
X/tmp/perl\-eXXXXXX        temporary file for
X.B \-e
Xcommands.
X.SH SEE ALSO
Xa2p        awk to perl translator
X.br
Xs2p        sed to perl translator
X.SH DIAGNOSTICS
XCompilation errors will tell you the line number of the error, with an
Xindication of the next token or token type that was to be examined.
X(In the case of a script passed to
X.I perl
Xvia
X.B \-e
Xswitches, each
X.B \-e
Xis counted as one line.)
X.SH TRAPS
XAccustomed awk users should take special note of the following:
X.Ip * 4 2
XSemicolons are required after all simple statements in perl.  Newline
Xis not a statement delimiter.
X.Ip * 4 2
XCurly brackets are required on ifs and whiles.
X.Ip * 4 2
XVariables begin with $ or @ in perl.
X.Ip * 4 2
XArrays index from 0 unless you set $[.
XLikewise string positions in substr() and index().
X.Ip * 4 2
XYou have to decide whether your array has numeric or string indices.
X.Ip * 4 2
XYou have to decide whether you want to use string or numeric comparisons.
X.Ip * 4 2
XReading an input line does not split it for you.  You get to split it yourself
Xto an array.
XAnd split has different arguments.
X.Ip * 4 2
XThe current input line is normally in $_, not $0.
XIt generally does not have the newline stripped.
X($0 is initially the name of the program executed, then the last matched
Xstring.)
X.Ip * 4 2
XThe current filename is $ARGV, not $FILENAME.
XNR, RS, ORS, OFS, and OFMT have equivalents with other symbols.
XFS doesn't have an equivalent, since you have to be explicit about
Xsplit statements.
X.Ip * 4 2
X$<digit> does not refer to fields--it refers to substrings matched by the last
Xmatch pattern.
X.Ip * 4 2
XThe print statement does not add field and record separators unless you set
X$, and $\e.
X.Ip * 4 2
XYou must open your files before you print to them.
X.Ip * 4 2
XThe range operator is \*(L"..\*(R", not comma.
X(The comma operator works as in C.)
X.Ip * 4 2
XThe match operator is \*(L"=~\*(R", not \*(L"~\*(R".
X(\*(L"~\*(R" is the one's complement operator.)
X.Ip * 4 2
XThe concatenation operator is \*(L".\*(R", not the null string.
X(Using the null string would render \*(L"/pat/ /pat/\*(R" unparseable,
Xsince the third slash would be interpreted as a division operator\*(--the
Xtokener is in fact slightly context sensitive for operators like /, ?, and <.
XAnd in fact, . itself can be the beginning of a number.)
X.Ip * 4 2
XThe \ennn construct in patterns must be given as [\ennn] to avoid interpretation
Xas a backreference.
X.Ip * 4 2
XNext, exit, and continue work differently.
X.Ip * 4 2
XWhen in doubt, run the awk construct through a2p and see what it gives you.
X.PP
XCerebral C programmers should take note of the following:
X.Ip * 4 2
XCurly brackets are required on ifs and whiles.
X.Ip * 4 2
XYou should use \*(L"elsif\*(R" rather than \*(L"else if\*(R"
X.Ip * 4 2
XBreak and continue become last and next, respectively.
X.Ip * 4 2
XThere's no switch statement.
X.Ip * 4 2
XVariables begin with $ or @ in perl.
X.Ip * 4 2
XPrintf does not implement *.
X.Ip * 4 2
XComments begin with #, not /*.
X.Ip * 4 2
XYou can't take the address of anything.
X.Ip * 4 2
XSubroutines are not reentrant.
X.Ip * 4 2
XARGV must be capitalized.
X.Ip * 4 2
XThe \*(L"system\*(R" calls link, unlink, rename, etc. return 1 for success, not 0.
X.Ip * 4 2
XSignal handlers deal with signal names, not numbers.
X.PP
XSeasoned sed programmers should take note of the following:
X.Ip * 4 2
XBackreferences in substitutions use $ rather than \e.
X.Ip * 4 2
XThe pattern matching metacharacters (, ), and | do not have backslashes in front.
X.SH BUGS
X.PP
XYou can't currently dereference array elements inside a double-quoted string.
XYou must assign them to a temporary and interpolate that.
X.PP
XAssociative arrays really ought to be first class objects.
X.PP
XRecursive subroutines are not currently supported, due to the way temporary
Xvalues are stored in the syntax tree.
X.PP
XArrays ought to be passable to subroutines just as strings are.
X.PP
XThe array literal consisting of one element is currently misinterpreted, i.e.
X.nf
X
X        @array = (123);
X
X.fi
Xdoesn't work right.
X.PP
X.I Perl
Xactually stands for Pathologically Eclectic Rubbish Lister, but don't tell
Xanyone I said that.
X.rn }` ''
!STUFFY!FUNK!
echo Extracting str.c
sed >str.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: str.c,v 1.0 87/12/18 13:06:22 root Exp $
X *
X * $Log:        str.c,v $
X * Revision 1.0  87/12/18  13:06:22  root
X * Initial revision
X * 
X */
X
X#include "handy.h"
X#include "EXTERN.h"
X#include "search.h"
X#include "util.h"
X#include "perl.h"
X
Xstr_reset(s)
Xregister char *s;
X{
X    register STAB *stab;
X    register STR *str;
X    register int i;
X    register int max;
X    register SPAT *spat;
X
X    if (!*s) {                /* reset ?? searches */
X        for (spat = spat_root; spat != Nullspat; spat = spat->spat_next) {
X            spat->spat_flags &= ~SPAT_USED;
X        }
X        return;
X    }
X
X    /* reset variables */
X
X    while (*s) {
X        i = *s;
X        if (s[1] == '-') {
X            s += 2;
X        }
X        max = *s++;
X        for ( ; i <= max; i++) {
X            for (stab = stab_index[i]; stab; stab = stab->stab_next) {
X                str = stab->stab_val;
X                str->str_cur = 0;
X                if (str->str_ptr != Nullch)
X                    str->str_ptr[0] = '\0';
X            }
X        }
X    }
X}
X
Xstr_numset(str,num)
Xregister STR *str;
Xdouble num;
X{
X    str->str_nval = num;
X    str->str_pok = 0;                /* invalidate pointer */
X    str->str_nok = 1;                /* validate number */
X}
X
Xchar *
Xstr_2ptr(str)
Xregister STR *str;
X{
X    register char *s;
X
X    if (!str)
X        return "";
X    GROWSTR(&(str->str_ptr), &(str->str_len), 24);
X    s = str->str_ptr;
X    if (str->str_nok) {
X        sprintf(s,"%.20g",str->str_nval);
X        while (*s) s++;
X    }
X    *s = '\0';
X    str->str_cur = s - str->str_ptr;
X    str->str_pok = 1;
X#ifdef DEBUGGING
X    if (debug & 32)
X        fprintf(stderr,"0x%lx ptr(%s)\n",str,str->str_ptr);
X#endif
X    return str->str_ptr;
X}
X
Xdouble
Xstr_2num(str)
Xregister STR *str;
X{
X    if (!str)
X        return 0.0;
X    if (str->str_len && str->str_pok)
X        str->str_nval = atof(str->str_ptr);
X    else
X        str->str_nval = 0.0;
X    str->str_nok = 1;
X#ifdef DEBUGGING
X    if (debug & 32)
X        fprintf(stderr,"0x%lx num(%g)\n",str,str->str_nval);
X#endif
X    return str->str_nval;
X}
X
Xstr_sset(dstr,sstr)
XSTR *dstr;
Xregister STR *sstr;
X{
X    if (!sstr)
X        str_nset(dstr,No,0);
X    else if (sstr->str_nok)
X        str_numset(dstr,sstr->str_nval);
X    else if (sstr->str_pok)
X        str_nset(dstr,sstr->str_ptr,sstr->str_cur);
X    else
X        str_nset(dstr,"",0);
X}
X
Xstr_nset(str,ptr,len)
Xregister STR *str;
Xregister char *ptr;
Xregister int len;
X{
X    GROWSTR(&(str->str_ptr), &(str->str_len), len + 1);
X    bcopy(ptr,str->str_ptr,len);
X    str->str_cur = len;
X    *(str->str_ptr+str->str_cur) = '\0';
X    str->str_nok = 0;                /* invalidate number */
X    str->str_pok = 1;                /* validate pointer */
X}
X
Xstr_set(str,ptr)
Xregister STR *str;
Xregister char *ptr;
X{
X    register int len;
X
X    if (!ptr)
X        ptr = "";
X    len = strlen(ptr);
X    GROWSTR(&(str->str_ptr), &(str->str_len), len + 1);
X    bcopy(ptr,str->str_ptr,len+1);
X    str->str_cur = len;
X    str->str_nok = 0;                /* invalidate number */
X    str->str_pok = 1;                /* validate pointer */
X}
X
Xstr_chop(str,ptr)        /* like set but assuming ptr is in str */
Xregister STR *str;
Xregister char *ptr;
X{
X    if (!(str->str_pok))
X        str_2ptr(str);
X    str->str_cur -= (ptr - str->str_ptr);
X    bcopy(ptr,str->str_ptr, str->str_cur + 1);
X    str->str_nok = 0;                /* invalidate number */
X    str->str_pok = 1;                /* validate pointer */
X}
X
Xstr_ncat(str,ptr,len)
Xregister STR *str;
Xregister char *ptr;
Xregister int len;
X{
X    if (!(str->str_pok))
X        str_2ptr(str);
X    GROWSTR(&(str->str_ptr), &(str->str_len), str->str_cur + len + 1);
X    bcopy(ptr,str->str_ptr+str->str_cur,len);
X    str->str_cur += len;
X    *(str->str_ptr+str->str_cur) = '\0';
X    str->str_nok = 0;                /* invalidate number */
X    str->str_pok = 1;                /* validate pointer */
X}
X
Xstr_scat(dstr,sstr)
XSTR *dstr;
Xregister STR *sstr;
X{
X    if (!(sstr->str_pok))
X        str_2ptr(sstr);
X    if (sstr)
X        str_ncat(dstr,sstr->str_ptr,sstr->str_cur);
X}
X
Xstr_cat(str,ptr)
Xregister STR *str;
Xregister char *ptr;
X{
X    register int len;
X
X    if (!ptr)
X        return;
X    if (!(str->str_pok))
X        str_2ptr(str);
X    len = strlen(ptr);
X    GROWSTR(&(str->str_ptr), &(str->str_len), str->str_cur + len + 1);
X    bcopy(ptr,str->str_ptr+str->str_cur,len+1);
X    str->str_cur += len;
X    str->str_nok = 0;                /* invalidate number */
X    str->str_pok = 1;                /* validate pointer */
X}
X
Xchar *
Xstr_append_till(str,from,delim,keeplist)
Xregister STR *str;
Xregister char *from;
Xregister int delim;
Xchar *keeplist;
X{
X    register char *to;
X    register int len;
X
X    if (!from)
X        return Nullch;
X    len = strlen(from);
X    GROWSTR(&(str->str_ptr), &(str->str_len), str->str_cur + len + 1);
X    str->str_nok = 0;                /* invalidate number */
X    str->str_pok = 1;                /* validate pointer */
X    to = str->str_ptr+str->str_cur;
X    for (; *from; from++,to++) {
X        if (*from == '\\' && from[1] && delim != '\\') {
X            if (!keeplist) {
X                if (from[1] == delim || from[1] == '\\')
X                    from++;
X                else
X                    *to++ = *from++;
X            }
X            else if (index(keeplist,from[1]))
X                *to++ = *from++;
X            else
X                from++;
X        }
X        else if (*from == delim)
X            break;
X        *to = *from;
X    }
X    *to = '\0';
X    str->str_cur = to - str->str_ptr;
X    return from;
X}
X
XSTR *
Xstr_new(len)
Xint len;
X{
X    register STR *str;
X    
X    if (freestrroot) {
X        str = freestrroot;
X        freestrroot = str->str_link.str_next;
X        str->str_link.str_magic = Nullstab;
X    }
X    else {
X        str = (STR *) safemalloc(sizeof(STR));
X        bzero((char*)str,sizeof(STR));
X    }
X    if (len)
X        GROWSTR(&(str->str_ptr), &(str->str_len), len + 1);
X    return str;
X}
X
Xvoid
Xstr_grow(str,len)
Xregister STR *str;
Xint len;
X{
X    if (len && str)
X        GROWSTR(&(str->str_ptr), &(str->str_len), len + 1);
X}
X
X/* make str point to what nstr did */
X
Xvoid
Xstr_replace(str,nstr)
Xregister STR *str;
Xregister STR *nstr;
X{
X    safefree(str->str_ptr);
X    str->str_ptr = nstr->str_ptr;
X    str->str_len = nstr->str_len;
X    str->str_cur = nstr->str_cur;
X    str->str_pok = nstr->str_pok;
X    if (str->str_nok = nstr->str_nok)
X        str->str_nval = nstr->str_nval;
X    safefree((char*)nstr);
X}
X
Xvoid
Xstr_free(str)
Xregister STR *str;
X{
X    if (!str)
X        return;
X    if (str->str_len)
X        str->str_ptr[0] = '\0';
X    str->str_cur = 0;
X    str->str_nok = 0;
X    str->str_pok = 0;
X    str->str_link.str_next = freestrroot;
X    freestrroot = str;
X}
X
Xstr_len(str)
Xregister STR *str;
X{
X    if (!str)
X        return 0;
X    if (!(str->str_pok))
X        str_2ptr(str);
X    if (str->str_len)
X        return str->str_cur;
X    else
X        return 0;
X}
X
Xchar *
Xstr_gets(str,fp)
Xregister STR *str;
Xregister FILE *fp;
X{
X#ifdef STDSTDIO                /* Here is some breathtakingly efficient cheating */
X
X    register char *bp;                /* we're going to steal some values */
X    register int cnt;                /*  from the stdio struct and put EVERYTHING */
X    register char *ptr;                /*   in the innermost loop into registers */
X    register char newline = record_separator;        /* (assuming >= 6 registers) */
X    int i;
X    int bpx;
X    int obpx;
X    register int get_paragraph;
X    register char *oldbp;
X
X    if (get_paragraph = !newline) {        /* yes, that's an assignment */
X        newline = '\n';
X        oldbp = Nullch;                        /* remember last \n position (none) */
X    }
X    cnt = fp->_cnt;                        /* get count into register */
X    str->str_nok = 0;                        /* invalidate number */
X    str->str_pok = 1;                        /* validate pointer */
X    if (str->str_len <= cnt)                /* make sure we have the room */
X        GROWSTR(&(str->str_ptr), &(str->str_len), cnt+1);
X    bp = str->str_ptr;                        /* move these two too to registers */
X    ptr = fp->_ptr;
X    for (;;) {
X      screamer:
X        while (--cnt >= 0) {                        /* this */        /* eat */
X            if ((*bp++ = *ptr++) == newline)        /* really */        /* dust */
X                goto thats_all_folks;                /* screams */        /* sed :-) */ 
X        }
X        
X        fp->_cnt = cnt;                        /* deregisterize cnt and ptr */
X        fp->_ptr = ptr;
X        i = _filbuf(fp);                /* get more characters */
X        cnt = fp->_cnt;
X        ptr = fp->_ptr;                        /* reregisterize cnt and ptr */
X
X        bpx = bp - str->str_ptr;        /* prepare for possible relocation */
X        if (get_paragraph && oldbp)
X            obpx = oldbp - str->str_ptr;
X        GROWSTR(&(str->str_ptr), &(str->str_len), str->str_cur + cnt + 1);
X        bp = str->str_ptr + bpx;        /* reconstitute our pointer */
X        if (get_paragraph && oldbp)
X            oldbp = str->str_ptr + obpx;
X
X        if (i == newline) {                /* all done for now? */
X            *bp++ = i;
X            goto thats_all_folks;
X        }
X        else if (i == EOF)                /* all done for ever? */
X            goto thats_really_all_folks;
X        *bp++ = i;                        /* now go back to screaming loop */
X    }
X
Xthats_all_folks:
X    if (get_paragraph && bp - 1 != oldbp) {
X        oldbp = bp;        /* remember where this newline was */
X        goto screamer;        /* and go back to the fray */
X    }
Xthats_really_all_folks:
X    fp->_cnt = cnt;                        /* put these back or we're in trouble */
X    fp->_ptr = ptr;
X    *bp = '\0';
X    str->str_cur = bp - str->str_ptr;        /* set length */
X
X#else /* !STDSTDIO */        /* The big, slow, and stupid way */
X
X    static char buf[4192];
X
X    if (fgets(buf, sizeof buf, fp) != Nullch)
X        str_set(str, buf);
X    else
X        str_set(str, No);
X
X#endif /* STDSTDIO */
X
X    return str->str_cur ? str->str_ptr : Nullch;
X}
X
X
XSTR *
Xinterp(str,s)
Xregister STR *str;
Xregister char *s;
X{
X    register char *t = s;
X    char *envsave = envname;
X    envname = Nullch;
X
X    str_set(str,"");
X    while (*s) {
X        if (*s == '\\' && s[1] == '$') {
X            str_ncat(str, t, s++ - t);
X            t = s++;
X        }
X        else if (*s == '$' && s[1] && s[1] != '|') {
X            str_ncat(str,t,s-t);
X            s = scanreg(s,tokenbuf);
X            str_cat(str,reg_get(tokenbuf));
X            t = s;
X        }
X        else
X            s++;
X    }
X    envname = envsave;
X    str_ncat(str,t,s-t);
X    return str;
X}
X
Xvoid
Xstr_inc(str)
Xregister STR *str;
X{
X    register char *d;
X
X    if (!str)
X        return;
X    if (str->str_nok) {
X        str->str_nval += 1.0;
X        str->str_pok = 0;
X        return;
X    }
X    if (!str->str_pok) {
X        str->str_nval = 1.0;
X        str->str_nok = 1;
X        return;
X    }
X    for (d = str->str_ptr; *d && *d != '.'; d++) ;
X    d--;
X    if (!isdigit(*str->str_ptr) || !isdigit(*d) ) {
X        str_numset(str,atof(str->str_ptr) + 1.0);  /* punt */
X        return;
X    }
X    while (d >= str->str_ptr) {
X        if (++*d <= '9')
X            return;
X        *(d--) = '0';
X    }
X    /* oh,oh, the number grew */
X    GROWSTR(&(str->str_ptr), &(str->str_len), str->str_cur + 2);
X    str->str_cur++;
X    for (d = str->str_ptr + str->str_cur; d > str->str_ptr; d--)
X        *d = d[-1];
X    *d = '1';
X}
X
Xvoid
Xstr_dec(str)
Xregister STR *str;
X{
X    register char *d;
X
X    if (!str)
X        return;
X    if (str->str_nok) {
X        str->str_nval -= 1.0;
X        str->str_pok = 0;
X        return;
X    }
X    if (!str->str_pok) {
X        str->str_nval = -1.0;
X        str->str_nok = 1;
X        return;
X    }
X    for (d = str->str_ptr; *d && *d != '.'; d++) ;
X    d--;
X    if (!isdigit(*str->str_ptr) || !isdigit(*d) || (*d == '0' && d == str->str_ptr)) {
X        str_numset(str,atof(str->str_ptr) - 1.0);  /* punt */
X        return;
X    }
X    while (d >= str->str_ptr) {
X        if (--*d >= '0')
X            return;
X        *(d--) = '9';
X    }
X}
X
X/* make a string that will exist for the duration of the expression eval */
X
XSTR *
Xstr_static(oldstr)
XSTR *oldstr;
X{
X    register STR *str = str_new(0);
X    static long tmps_size = -1;
X
X    str_sset(str,oldstr);
X    if (++tmps_max > tmps_size) {
X        tmps_size = tmps_max;
X        if (!(tmps_size & 127)) {
X            if (tmps_size)
X                tmps_list = (STR**)saferealloc((char*)tmps_list,
X                    (tmps_size + 128) * sizeof(STR*) );
X            else
X                tmps_list = (STR**)safemalloc(128 * sizeof(char*));
X        }
X    }
X    tmps_list[tmps_max] = str;
X    return str;
X}
X
XSTR *
Xstr_make(s)
Xchar *s;
X{
X    register STR *str = str_new(0);
X
X    str_set(str,s);
X    return str;
X}
X
XSTR *
Xstr_nmake(n)
Xdouble n;
X{
X    register STR *str = str_new(0);
X
X    str_numset(str,n);
X    return str;
X}
!STUFFY!FUNK!
echo Extracting Makefile.SH
sed >Makefile.SH <<'!STUFFY!FUNK!' -e 's/X//'
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
Xecho "Extracting Makefile (with variable substitutions)"
Xcat >Makefile <<!GROK!THIS!
X# $Header: Makefile.SH,v 1.0 87/12/18 16:11:50 root Exp $
X#
X# $Log:        Makefile.SH,v $
X# Revision 1.0  87/12/18  16:11:50  root
X# Initial revision
X# 
X# Revision 1.0  87/12/18  16:01:07  root
X# Initial revision
X# 
X# 
X
XCC = $cc
Xbin = $bin
Xlib = $lib
Xmansrc = $mansrc
Xmanext = $manext
XCFLAGS = $ccflags -O
XLDFLAGS = $ldflags
XSMALL = $small
XLARGE = $large $split
X
Xlibs = $libnm -lm
X!GROK!THIS!
X
Xcat >>Makefile <<'!NO!SUBS!'
X
Xpublic = perl
X
Xprivate = 
X
Xmanpages = perl.man
X
Xutil =
X
Xsh = Makefile.SH makedepend.SH
X
Xh1 = EXTERN.h INTERN.h arg.h array.h cmd.h config.h form.h handy.h
Xh2 = hash.h perl.h search.h spat.h stab.h str.h util.h
X
Xh = $(h1) $(h2)
X
Xc1 = arg.c array.c cmd.c dump.c form.c hash.c malloc.c
Xc2 = search.c stab.c str.c util.c version.c
X
Xc = $(c1) $(c2)
X
Xobj1 = arg.o array.o cmd.o dump.o form.o hash.o malloc.o
Xobj2 = search.o stab.o str.o util.o version.o
X
Xobj = $(obj1) $(obj2)
X
Xlintflags = -phbvxac
X
Xaddedbyconf = Makefile.old bsd eunice filexp loc pdp11 usg v7
X
X# grrr
XSHELL = /bin/sh
X
X.c.o:
X        $(CC) -c $(CFLAGS) $(LARGE) $*.c
X
Xall: $(public) $(private) $(util)
X        touch all
X
Xperl: $(obj) perl.o
X        $(CC) $(LDFLAGS) $(LARGE) $(obj) perl.o $(libs) -o perl
X
Xperl.c: perl.y
X        @ echo Expect 2 shift/reduce errors...
X        yacc perl.y
X        mv y.tab.c perl.c
X
Xperl.o: perl.c perly.c perl.h EXTERN.h search.h util.h INTERN.h handy.h
X        $(CC) -c $(CFLAGS) $(LARGE) perl.c
X
X# if a .h file depends on another .h file...
X$(h):
X        touch $@
X
Xperl.man: perl.man.1 perl.man.2
X        cat perl.man.1 perl.man.2 >perl.man
X
Xinstall: perl perl.man
X# won't work with csh
X        export PATH || exit 1
X        - mv $(bin)/perl $(bin)/perl.old
X        - if test `pwd` != $(bin); then cp $(public) $(bin); fi
X        cd $(bin); \
Xfor pub in $(public); do \
Xchmod 755 `basename $$pub`; \
Xdone
X        - test $(bin) = /bin || rm -f /bin/perl
X        - test $(bin) = /bin || ln -s $(bin)/perl /bin || cp $(bin)/perl /bin
X#        chmod 755 makedir
X#        - makedir `filexp $(lib)`
X#        - \
X#if test `pwd` != `filexp $(lib)`; then \
X#cp $(private) `filexp $(lib)`; \
X#fi
X#        cd `filexp $(lib)`; \
X#for priv in $(private); do \
X#chmod 755 `basename $$priv`; \
X#done
X        - if test `pwd` != $(mansrc); then \
Xfor page in $(manpages); do \
Xcp $$page $(mansrc)/`basename $$page .man`.$(manext); \
Xdone; \
Xfi
X
Xclean:
X        rm -f *.o
X
Xrealclean:
X        rm -f perl *.orig */*.orig *.o core $(addedbyconf)
X
X# The following lint has practically everything turned on.  Unfortunately,
X# you have to wade through a lot of mumbo jumbo that can't be suppressed.
X# If the source file has a /*NOSTRICT*/ somewhere, ignore the lint message
X# for that spot.
X
Xlint:
X        lint $(lintflags) $(defs) $(c) > perl.fuzz
X
Xdepend: makedepend
X        makedepend
X
Xtest: perl
X        chmod 755 t/TEST t/base.* t/comp.* t/cmd.* t/io.* t/op.*
X        cd t && (rm -f perl; ln -s ../perl . || ln ../perl .) && TEST
X
Xclist:
X        echo $(c) | tr ' ' '\012' >.clist
X
Xhlist:
X        echo $(h) | tr ' ' '\012' >.hlist
X
Xshlist:
X        echo $(sh) | tr ' ' '\012' >.shlist
X
X# AUTOMATICALLY GENERATED MAKE DEPENDENCIES--PUT NOTHING BELOW THIS LINE
X$(obj):
X        @ echo "You haven't done a "'"make depend" yet!'; exit 1
Xmakedepend: makedepend.SH
X        /bin/sh makedepend.SH
X!NO!SUBS!
X$eunicefix Makefile
Xcase `pwd` in
X*SH)
X    $rm -f ../Makefile
X    ln Makefile ../Makefile
X    ;;
Xesac
!STUFFY!FUNK!
echo ""
echo "End of kit 4 (of 10)"
cat /dev/null >kit4isdone
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