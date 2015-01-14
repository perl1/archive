#! /bin/sh

# Make a new directory for the perl sources, cd to it, and run kits 1
# thru 10 through sh.  When all 10 kits have been run, read README.

echo "This is perl 1.0 kit 8 (of 10).  If kit 8 is complete, the line"
echo '"'"End of kit 8 (of 10)"'" will echo at the end.'
echo ""
export PATH || (echo "You didn't use sh, you clunch." ; kill $$)
mkdir x2p 2>/dev/null
echo Extracting x2p/a2p.man
sed >x2p/a2p.man <<'!STUFFY!FUNK!' -e 's/X//'
X.rn '' }`
X''' $Header: a2p.man,v 1.0 87/12/18 17:23:56 root Exp $
X''' 
X''' $Log:        a2p.man,v $
X''' Revision 1.0  87/12/18  17:23:56  root
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
X.TH A2P 1 LOCAL
X.SH NAME
Xa2p - Awk to Perl translator
X.SH SYNOPSIS
X.B a2p [options] filename
X.SH DESCRIPTION
X.I A2p
Xtakes an awk script specified on the command line (or from standard input)
Xand produces a comparable
X.I perl
Xscript on the standard output.
X.Sh "Options"
XOptions include:
X.TP 5
X.B \-D<number>
Xsets debugging flags.
X.TP 5
X.B \-F<character>
Xtells a2p that this awk script is always invoked with this -F switch.
X.TP 5
X.B \-n<fieldlist>
Xspecifies the names of the input fields if input does not have to be split into
Xan array.
XIf you were translating an awk script that processes the password file, you
Xmight say:
X.sp
X        a2p -7 -nlogin.password.uid.gid.gcos.shell.home
X.sp
XAny delimiter will do to separate the field names.
X.TP 5
X.B \-<number>
Xcauses a2p to assume that input will always have that many fields.
X.Sh "Considerations"
XA2p cannot do as good a job translating as a human would, but it usually
Xdoes pretty well.
XThere are some areas where you may want to examine the perl script produced
Xand tweak it some.
XHere are some of them, in no particular order.
X.PP
XThe split operator in perl always strips off all null fields from the end.
XAwk does NOT do this, if you've set FS.
XIf the perl script splits to an array, the field count may not reflect
Xwhat you expect.
XOrdinarily this isn't a problem, since nonexistent array elements have a null
Xvalue, but if you rely on NF in awk, you could be in for trouble.
XEither force the number of fields with \-<number>, or count the number of
Xdelimiters another way, e.g. with y/:/:/.
XOr add something non-null to the end before you split, and then pop it off
Xthe resulting array.
X.PP
XThere is an awk idiom of putting int() around a string expression to force
Xnumeric interpretation, even though the argument is always integer anyway.
XThis is generally unneeded in perl, but a2p can't tell if the argument
Xis always going to be integer, so it leaves it in.
XYou may wish to remove it.
X.PP
XPerl differentiates numeric comparison from string comparison.
XAwk has one operator for both that decides at run time which comparison
Xto do.
XA2p does not try to do a complete job of awk emulation at this point.
XInstead it guesses which one you want.
XIt's almost always right, but it can be spoofed.
XAll such guesses are marked with the comment \*(L"#???\*(R".
XYou should go through and check them.
X.PP
XPerl does not attempt to emulate the behavior of awk in which nonexistent
Xarray elements spring into existence simply by being referenced.
XIf somehow you are relying on this mechanism to create null entries for
Xa subsequent for...in, they won't be there in perl.
X.PP
XIf a2p makes a split line that assigns to a list of variables that looks
Xlike (Fld1, Fld2, Fld3...) you may want
Xto rerun a2p using the \-n option mentioned above.
XThis will let you name the fields throughout the script.
XIf it splits to an array instead, the script is probably referring to the number
Xof fields somewhere.
X.PP
XThe exit statement in awk doesn't necessarily exit; it goes to the END
Xblock if there is one.
XAwk scripts that do contortions within the END block to bypass the block under
Xsuch circumstances can be simplified by removing the conditional
Xin the END block and just exiting directly from the perl script.
X.PP
XPerl has two kinds of array, numerically-indexed and associative.
XAwk arrays are usually translated to associative arrays, but if you happen
Xto know that the index is always going to be numeric you could change
Xthe {...} to [...].
XIteration over an associative array is done with each(), but
Xiteration over a numeric array is NOT.
XYou need a for loop, or while loop with a pop() or shift(), so you might
Xneed to modify any loop that is iterating over the array in question.
X.PP
XArrays which have been split into are assumed to be numerically indexed.
XThe usual perl idiom for iterating over such arrays is to use pop() or shift()
Xand assign the resulting value to a variable inside the conditional of the
Xwhile loop.
XThis is destructive to the array, however, so a2p can't assume this is
Xreasonable.
XA2p will write a standard for loop with a scratch variable.
XYou may wish to change it to a pop() loop for more efficiency, presuming
Xyou don't want to keep the array around.
X.PP
XAwk starts by assuming OFMT has the value %.6g.
XPerl starts by assuming its equivalent, $#, to have the value %.20g.
XYou'll want to set $# explicitly if you use the default value of OFMT.
X.PP
XNear the top of the line loop will be the split operation that is implicit in
Xthe awk script.
XThere are times when you can move this down past some conditionals that
Xtest the entire record so that the split is not done as often.
X.PP
XThere may occasionally be extra parentheses that you can remove.
X.PP
XFor aesthetic reasons you may wish to change the array base $[ from 1 back
Xto the default of 0, but remember to change all array subscripts AND
Xall substr() and index() operations to match.
X.PP
XCute comments that say "# Here is a workaround because awk is dumb" are not
Xtranslated.
X.PP
XAwk scripts are often embedded in a shell script that pipes stuff into and
Xout of awk.
XOften the shell script wrapper can be incorporated into the perl script, since
Xperl can start up pipes into and out of itself, and can do other things that
Xawk can't do by itself.
X.SH ENVIRONMENT
XA2p uses no environment variables.
X.SH AUTHOR
XLarry Wall <lw...@devvax.Jpl.Nasa.Gov>
X.SH FILES
X.SH SEE ALSO
Xperl        The perl compiler/interpreter
X.br
Xs2p        sed to perl translator
X.SH DIAGNOSTICS
X.SH BUGS
XIt would be possible to emulate awk's behavior in selecting string versus
Xnumeric operations at run time by inspection of the operands, but it would
Xbe gross and inefficient.
XBesides, a2p almost always guesses right.
X.PP
XStorage for the awk syntax tree is currently static, and can run out.
X.rn }` ''
!STUFFY!FUNK!
echo Extracting x2p/a2p.y
sed >x2p/a2p.y <<'!STUFFY!FUNK!' -e 's/X//'
X%{
X/* $Header: a2p.y,v 1.0 87/12/18 13:07:05 root Exp $
X *
X * $Log:        a2p.y,v $
X * Revision 1.0  87/12/18  13:07:05  root
X * Initial revision
X * 
X */
X
X#include "INTERN.h"
X#include "a2p.h"
X
Xint root;
X
X%}
X%token BEGIN END
X%token REGEX
X%token SEMINEW NEWLINE COMMENT
X%token FUN1 GRGR
X%token PRINT PRINTF SPRINTF SPLIT
X%token IF ELSE WHILE FOR IN
X%token EXIT NEXT BREAK CONTINUE
X
X%right ASGNOP
X%left OROR
X%left ANDAND
X%left NOT
X%left NUMBER VAR SUBSTR INDEX
X%left GETLINE
X%nonassoc RELOP MATCHOP
X%left OR
X%left STRING
X%left '+' '-'
X%left '*' '/' '%'
X%right UMINUS
X%left INCR DECR
X%left FIELD VFIELD
X
X%%
X
Xprogram        : junk begin hunks end
X                { root = oper4(OPROG,$1,$2,$3,$4); }
X        ;
X
Xbegin        : BEGIN '{' states '}' junk
X                { $$ = oper2(OJUNK,$3,$5); in_begin = FALSE; }
X        | /* NULL */
X                { $$ = Nullop; }
X        ;
X
Xend        : END '{' states '}'
X                { $$ = $3; }
X        | end NEWLINE
X                { $$ = $1; }
X        | /* NULL */
X                { $$ = Nullop; }
X        ;
X
Xhunks        : hunks hunk junk
X                { $$ = oper3(OHUNKS,$1,$2,$3); }
X        | /* NULL */
X                { $$ = Nullop; }
X        ;
X
Xhunk        : patpat
X                { $$ = oper1(OHUNK,$1); need_entire = TRUE; }
X        | patpat '{' states '}'
X                { $$ = oper2(OHUNK,$1,$3); }
X        | '{' states '}'
X                { $$ = oper2(OHUNK,Nullop,$2); }
X        ;
X
Xpatpat        : pat
X                { $$ = oper1(OPAT,$1); }
X        | pat ',' pat
X                { $$ = oper2(ORANGE,$1,$3); }
X        ;
X
Xpat        : REGEX
X                { $$ = oper1(OREGEX,$1); }
X        | match
X        | rel
X        | compound_pat
X        ;
X
Xcompound_pat
X        : '(' compound_pat ')'
X                { $$ = oper1(OPPAREN,$2); }
X        | pat ANDAND pat
X                { $$ = oper2(OPANDAND,$1,$3); }
X        | pat OROR pat
X                { $$ = oper2(OPOROR,$1,$3); }
X        | NOT pat
X                { $$ = oper1(OPNOT,$2); }
X        ;
X
Xcond        : expr
X        | match
X        | rel
X        | compound_cond
X        ;
X
Xcompound_cond
X        : '(' compound_cond ')'
X                { $$ = oper1(OCPAREN,$2); }
X        | cond ANDAND cond
X                { $$ = oper2(OCANDAND,$1,$3); }
X        | cond OROR cond
X                { $$ = oper2(OCOROR,$1,$3); }
X        | NOT cond
X                { $$ = oper1(OCNOT,$2); }
X        ;
X
Xrel        : expr RELOP expr
X                { $$ = oper3(ORELOP,$2,$1,$3); }
X        | '(' rel ')'
X                { $$ = oper1(ORPAREN,$2); }
X        ;
X
Xmatch        : expr MATCHOP REGEX
X                { $$ = oper3(OMATCHOP,$2,$1,$3); }
X        | '(' match ')'
X                { $$ = oper1(OMPAREN,$2); }
X        ;
X
Xexpr        : term
X                { $$ = $1; }
X        | expr term
X                { $$ = oper2(OCONCAT,$1,$2); }
X        | variable ASGNOP expr
X                { $$ = oper3(OASSIGN,$2,$1,$3);
X                        if ((ops[$1].ival & 255) == OFLD)
X                            lval_field = TRUE;
X                        if ((ops[$1].ival & 255) == OVFLD)
X                            lval_field = TRUE;
X                }
X        ;
X
Xterm        : variable
X                { $$ = $1; }
X        | term '+' term
X                { $$ = oper2(OADD,$1,$3); }
X        | term '-' term
X                { $$ = oper2(OSUB,$1,$3); }
X        | term '*' term
X                { $$ = oper2(OMULT,$1,$3); }
X        | term '/' term
X                { $$ = oper2(ODIV,$1,$3); }
X        | term '%' term
X                { $$ = oper2(OMOD,$1,$3); }
X        | variable INCR
X                { $$ = oper1(OPOSTINCR,$1); }
X        | variable DECR
X                { $$ = oper1(OPOSTDECR,$1); }
X        | INCR variable
X                { $$ = oper1(OPREINCR,$2); }
X        | DECR variable
X                { $$ = oper1(OPREDECR,$2); }
X        | '-' term %prec UMINUS
X                { $$ = oper1(OUMINUS,$2); }
X        | '+' term %prec UMINUS
X                { $$ = oper1(OUPLUS,$2); }
X        | '(' expr ')'
X                { $$ = oper1(OPAREN,$2); }
X        | GETLINE
X                { $$ = oper0(OGETLINE); }
X        | FUN1
X                { $$ = oper0($1); need_entire = do_chop = TRUE; }
X        | FUN1 '(' ')'
X                { $$ = oper1($1,Nullop); need_entire = do_chop = TRUE; }
X        | FUN1 '(' expr ')'
X                { $$ = oper1($1,$3); }
X        | SPRINTF print_list
X                { $$ = oper1(OSPRINTF,$2); }
X        | SUBSTR '(' expr ',' expr ',' expr ')'
X                { $$ = oper3(OSUBSTR,$3,$5,$7); }
X        | SUBSTR '(' expr ',' expr ')'
X                { $$ = oper2(OSUBSTR,$3,$5); }
X        | SPLIT '(' expr ',' VAR ',' expr ')'
X                { $$ = oper3(OSPLIT,$3,numary($5),$7); }
X        | SPLIT '(' expr ',' VAR ')'
X                { $$ = oper2(OSPLIT,$3,numary($5)); }
X        | INDEX '(' expr ',' expr ')'
X                { $$ = oper2(OINDEX,$3,$5); }
X        ;
X
Xvariable: NUMBER
X                { $$ = oper1(ONUM,$1); }
X        | STRING
X                { $$ = oper1(OSTR,$1); }
X        | VAR
X                { $$ = oper1(OVAR,$1); }
X        | VAR '[' expr ']'
X                { $$ = oper2(OVAR,$1,$3); }
X        | FIELD
X                { $$ = oper1(OFLD,$1); }
X        | VFIELD term
X                { $$ = oper1(OVFLD,$2); }
X        ;
X
Xmaybe        : NEWLINE
X                { $$ = oper0(ONEWLINE); }
X        | /* NULL */
X                { $$ = Nullop; }
X        | COMMENT
X                { $$ = oper1(OCOMMENT,$1); }
X        ;
X
Xprint_list
X        : expr
X        | clist
X        | /* NULL */
X                { $$ = Nullop; }
X        ;
X
Xclist        : expr ',' expr
X                { $$ = oper2(OCOMMA,$1,$3); }
X        | clist ',' expr
X                { $$ = oper2(OCOMMA,$1,$3); }
X        | '(' clist ')'                /* these parens are invisible */
X                { $$ = $2; }
X        ;
X
Xjunk        : junk hunksep
X                { $$ = oper2(OJUNK,$1,$2); }
X        | /* NULL */
X                { $$ = Nullop; }
X        ;
X
Xhunksep : ';'
X                { $$ = oper0(OSEMICOLON); }
X        | SEMINEW
X                { $$ = oper0(OSEMICOLON); }
X        | NEWLINE
X                { $$ = oper0(ONEWLINE); }
X        | COMMENT
X                { $$ = oper1(OCOMMENT,$1); }
X        ;
X
Xseparator
X        : ';'
X                { $$ = oper0(OSEMICOLON); }
X        | SEMINEW
X                { $$ = oper0(OSNEWLINE); }
X        | NEWLINE
X                { $$ = oper0(OSNEWLINE); }
X        | COMMENT
X                { $$ = oper1(OSCOMMENT,$1); }
X        ;
X
Xstates        : states statement
X                { $$ = oper2(OSTATES,$1,$2); }
X        | /* NULL */
X                { $$ = Nullop; }
X        ;
X
Xstatement
X        : simple separator
X                { $$ = oper2(OSTATE,$1,$2); }
X        | compound
X        ;
X
Xsimple
X        : expr
X        | PRINT print_list redir expr
X                { $$ = oper3(OPRINT,$2,$3,$4);
X                    do_opens = TRUE;
X                    saw_ORS = saw_OFS = TRUE;
X                    if (!$2) need_entire = TRUE;
X                    if (ops[$4].ival != OSTR + (1<<8)) do_fancy_opens = TRUE; }
X        | PRINT print_list
X                { $$ = oper1(OPRINT,$2);
X                    if (!$2) need_entire = TRUE;
X                    saw_ORS = saw_OFS = TRUE;
X                }
X        | PRINTF print_list redir expr
X                { $$ = oper3(OPRINTF,$2,$3,$4);
X                    do_opens = TRUE;
X                    if (!$2) need_entire = TRUE;
X                    if (ops[$4].ival != OSTR + (1<<8)) do_fancy_opens = TRUE; }
X        | PRINTF print_list
X                { $$ = oper1(OPRINTF,$2);
X                    if (!$2) need_entire = TRUE;
X                }
X        | BREAK
X                { $$ = oper0(OBREAK); }
X        | NEXT
X                { $$ = oper0(ONEXT); }
X        | EXIT
X                { $$ = oper0(OEXIT); }
X        | EXIT expr
X                { $$ = oper1(OEXIT,$2); }
X        | CONTINUE
X                { $$ = oper0(OCONTINUE); }
X        | /* NULL */
X                { $$ = Nullop; }
X        ;
X
Xredir        : RELOP
X                { $$ = oper1(OREDIR,string(">",1)); }
X        | GRGR
X                { $$ = oper1(OREDIR,string(">>",2)); }
X        | '|'
X                { $$ = oper1(OREDIR,string("|",1)); }
X        ;
X
Xcompound
X        : IF '(' cond ')' maybe statement
X                { $$ = oper2(OIF,$3,bl($6,$5)); }
X        | IF '(' cond ')' maybe statement ELSE maybe statement
X                { $$ = oper3(OIF,$3,bl($6,$5),bl($9,$8)); }
X        | WHILE '(' cond ')' maybe statement
X                { $$ = oper2(OWHILE,$3,bl($6,$5)); }
X        | FOR '(' simple ';' cond ';' simple ')' maybe statement
X                { $$ = oper4(OFOR,$3,$5,$7,bl($10,$9)); }
X        | FOR '(' simple ';'  ';' simple ')' maybe statement
X                { $$ = oper4(OFOR,$3,string("",0),$6,bl($9,$8)); }
X        | FOR '(' VAR IN VAR ')' maybe statement
X                { $$ = oper3(OFORIN,$3,$5,bl($8,$7)); }
X        | '{' states '}'
X                { $$ = oper1(OBLOCK,$2); }
X        ;
X
X%%
X#include "a2py.c"
!STUFFY!FUNK!
echo Extracting stab.c
sed >stab.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: stab.c,v 1.0 87/12/18 13:06:14 root Exp $
X *
X * $Log:        stab.c,v $
X * Revision 1.0  87/12/18  13:06:14  root
X * Initial revision
X * 
X */
X
X#include <signal.h>
X#include "handy.h"
X#include "EXTERN.h"
X#include "search.h"
X#include "util.h"
X#include "perl.h"
X
Xstatic char *sig_name[] = {
X    "",
X    "HUP",
X    "INT",
X    "QUIT",
X    "ILL",
X    "TRAP",
X    "IOT",
X    "EMT",
X    "FPE",
X    "KILL",
X    "BUS",
X    "SEGV",
X    "SYS",
X    "PIPE",
X    "ALRM",
X    "TERM",
X    "???"
X#ifdef SIGTSTP
X    ,"STOP",
X    "TSTP",
X    "CONT",
X    "CHLD",
X    "TTIN",
X    "TTOU",
X    "TINT",
X    "XCPU",
X    "XFSZ"
X#ifdef SIGPROF
X    ,"VTALARM",
X    "PROF"
X#ifdef SIGWINCH
X    ,"WINCH"
X#ifdef SIGLOST
X    ,"LOST"
X#ifdef SIGUSR1
X    ,"USR1"
X#endif
X#ifdef SIGUSR2
X    ,"USR2"
X#endif /* SIGUSR2 */
X#endif /* SIGLOST */
X#endif /* SIGWINCH */
X#endif /* SIGPROF */
X#endif /* SIGTSTP */
X    ,0
X    };
X
XSTR *
Xstab_str(stab)
XSTAB *stab;
X{
X    register int paren;
X    register char *s;
X    extern int errno;
X
X    switch (*stab->stab_name) {
X    case '0': case '1': case '2': case '3': case '4':
X    case '5': case '6': case '7': case '8': case '9': case '&':
X        if (curspat) {
X            paren = atoi(stab->stab_name);
X            if (curspat->spat_compex.subend[paren] &&
X              (s = getparen(&curspat->spat_compex,paren))) {
X                curspat->spat_compex.subend[paren] = Nullch;
X                str_set(stab->stab_val,s);
X            }
X        }
X        break;
X    case '+':
X        if (curspat) {
X            paren = curspat->spat_compex.lastparen;
X            if (curspat->spat_compex.subend[paren] &&
X              (s = getparen(&curspat->spat_compex,paren))) {
X                curspat->spat_compex.subend[paren] = Nullch;
X                str_set(stab->stab_val,s);
X            }
X        }
X        break;
X    case '.':
X        if (last_in_stab) {
X            str_numset(stab->stab_val,(double)last_in_stab->stab_io->lines);
X        }
X        break;
X    case '?':
X        str_numset(stab->stab_val,(double)statusvalue);
X        break;
X    case '^':
X        s = curoutstab->stab_io->top_name;
X        str_set(stab->stab_val,s);
X        break;
X    case '~':
X        s = curoutstab->stab_io->fmt_name;
X        str_set(stab->stab_val,s);
X        break;
X    case '=':
X        str_numset(stab->stab_val,(double)curoutstab->stab_io->lines);
X        break;
X    case '-':
X        str_numset(stab->stab_val,(double)curoutstab->stab_io->lines_left);
X        break;
X    case '%':
X        str_numset(stab->stab_val,(double)curoutstab->stab_io->page);
X        break;
X    case '(':
X        if (curspat) {
X            str_numset(stab->stab_val,(double)(curspat->spat_compex.subbeg[0] -
X                curspat->spat_compex.subbase));
X        }
X        break;
X    case ')':
X        if (curspat) {
X            str_numset(stab->stab_val,(double)(curspat->spat_compex.subend[0] -
X                curspat->spat_compex.subbeg[0]));
X        }
X        break;
X    case '/':
X        *tokenbuf = record_separator;
X        tokenbuf[1] = '\0';
X        str_set(stab->stab_val,tokenbuf);
X        break;
X    case '[':
X        str_numset(stab->stab_val,(double)arybase);
X        break;
X    case '|':
X        str_numset(stab->stab_val,
X           (double)((curoutstab->stab_io->flags & IOF_FLUSH) != 0) );
X        break;
X    case ',':
X        str_set(stab->stab_val,ofs);
X        break;
X    case '\\':
X        str_set(stab->stab_val,ors);
X        break;
X    case '#':
X        str_set(stab->stab_val,ofmt);
X        break;
X    case '!':
X        str_numset(stab->stab_val,(double)errno);
X        break;
X    }
X    return stab->stab_val;
X}
X
Xstabset(stab,str)
Xregister STAB *stab;
XSTR *str;
X{
X    char *s;
X    int i;
X    int sighandler();
X
X    if (stab->stab_flags & SF_VMAGIC) {
X        switch (stab->stab_name[0]) {
X        case '^':
X            safefree(curoutstab->stab_io->top_name);
X            curoutstab->stab_io->top_name = str_get(str);
X            curoutstab->stab_io->top_stab = stabent(str_get(str),FALSE);
X            break;
X        case '~':
X            safefree(curoutstab->stab_io->fmt_name);
X            curoutstab->stab_io->fmt_name = str_get(str);
X            curoutstab->stab_io->fmt_stab = stabent(str_get(str),FALSE);
X            break;
X        case '=':
X            curoutstab->stab_io->page_len = (long)str_gnum(str);
X            break;
X        case '-':
X            curoutstab->stab_io->lines_left = (long)str_gnum(str);
X            break;
X        case '%':
X            curoutstab->stab_io->page = (long)str_gnum(str);
X            break;
X        case '|':
X            curoutstab->stab_io->flags &= ~IOF_FLUSH;
X            if (str_gnum(str) != 0.0) {
X                curoutstab->stab_io->flags |= IOF_FLUSH;
X            }
X            break;
X        case '*':
X            multiline = (int)str_gnum(str) != 0;
X            break;
X        case '/':
X            record_separator = *str_get(str);
X            break;
X        case '\\':
X            if (ors)
X                safefree(ors);
X            ors = savestr(str_get(str));
X            break;
X        case ',':
X            if (ofs)
X                safefree(ofs);
X            ofs = savestr(str_get(str));
X            break;
X        case '#':
X            if (ofmt)
X                safefree(ofmt);
X            ofmt = savestr(str_get(str));
X            break;
X        case '[':
X            arybase = (int)str_gnum(str);
X            break;
X        case '!':
X            errno = (int)str_gnum(str);                /* will anyone ever use this? */
X            break;
X        case '.':
X        case '+':
X        case '&':
X        case '0':
X        case '1':
X        case '2':
X        case '3':
X        case '4':
X        case '5':
X        case '6':
X        case '7':
X        case '8':
X        case '9':
X        case '(':
X        case ')':
X            break;                /* "read-only" registers */
X        }
X    }
X    else if (stab == envstab && envname) {
X        setenv(envname,str_get(str));
X                                /* And you'll never guess what the dog had */
X        safefree(envname);        /*   in its mouth... */
X        envname = Nullch;
X    }
X    else if (stab == sigstab && signame) {
X        s = str_get(str);
X        i = whichsig(signame);        /* ...no, a brick */
X        if (strEQ(s,"IGNORE"))
X            signal(i,SIG_IGN);
X        else if (strEQ(s,"DEFAULT") || !*s)
X            signal(i,SIG_DFL);
X        else
X            signal(i,sighandler);
X        safefree(signame);
X        signame = Nullch;
X    }
X}
X
Xwhichsig(signame)
Xchar *signame;
X{
X    register char **sigv;
X
X    for (sigv = sig_name+1; *sigv; sigv++)
X        if (strEQ(signame,*sigv))
X            return sigv - sig_name;
X    return 0;
X}
X
Xsighandler(sig)
Xint sig;
X{
X    STAB *stab;
X    ARRAY *savearray;
X    STR *str;
X
X    stab = stabent(str_get(hfetch(sigstab->stab_hash,sig_name[sig])),FALSE);
X    savearray = defstab->stab_array;
X    defstab->stab_array = anew();
X    str = str_new(0);
X    str_set(str,sig_name[sig]);
X    apush(defstab->stab_array,str);
X    str = cmd_exec(stab->stab_sub);
X    afree(defstab->stab_array);  /* put back old $_[] */
X    defstab->stab_array = savearray;
X}
X
Xchar *
Xreg_get(name)
Xchar *name;
X{
X    return STAB_GET(stabent(name,TRUE));
X}
X
X#ifdef NOTUSED
Xreg_set(name,value)
Xchar *name;
Xchar *value;
X{
X    str_set(STAB_STR(stabent(name,TRUE)),value);
X}
X#endif
X
XSTAB *
Xaadd(stab)
Xregister STAB *stab;
X{
X    if (!stab->stab_array)
X        stab->stab_array = anew();
X    return stab;
X}
X
XSTAB *
Xhadd(stab)
Xregister STAB *stab;
X{
X    if (!stab->stab_hash)
X        stab->stab_hash = hnew();
X    return stab;
X}
!STUFFY!FUNK!
echo Extracting MANIFEST
sed >MANIFEST <<'!STUFFY!FUNK!' -e 's/X//'
XAfter all the perl kits are run you should have the following files:
X
XFilename                Kit Description
X--------                --- -----------
XConfigure                6  Run this first
XEXTERN.h                10  Included before foreign .h files
XINTERN.h                10  Included before domestic .h files
XMANIFEST                 8  This list of files
XMakefile.SH              4  Precursor to Makefile
XREADME                   1  The Instructions
XWishlist                10  Some things that may or may not happen
Xarg.c                    3  Expression evaluation
Xarg.h                    8  Public declarations for the above
Xarray.c                  6  Numerically subscripted arrays
Xarray.h                 10  Public declarations for the above
Xcmd.c                    7  Command interpreter
Xcmd.h                    9  Public declarations for the above
Xconfig.H                 9  Sample config.h
Xconfig.h.SH              9  Produces config.h.
Xdump.c                   8  Debugging output
Xform.c                   8  Format processing
Xform.h                  10  Public declarations for the above
Xhandy.h                 10  Handy definitions
Xhash.c                   9  Associative arrays
Xhash.h                  10  Public declarations for the above
Xmakedepend.SH            9  Precursor to makedepend
Xmakedir.SH              10  Precursor to makedir
Xmalloc.c                 7  A version of malloc you might not want
Xpatchlevel.h             1  The current patch level of perl
Xperl.h                   9  Global declarations
Xperl.man.1               5  The manual page(s), first half
Xperl.man.2               4  The manual page(s), second half
Xperl.y                   5  Yacc grammar for perl
Xperly.c                  2  The perl compiler
Xsearch.c                 6  String matching
Xsearch.h                10  Public declarations for the above
Xspat.h                  10  Search pattern declarations
Xstab.c                   8  Symbol table stuff
Xstab.h                  10  Public declarations for the above
Xstr.c                    4  String handling package
Xstr.h                   10  Public declarations for the above
Xt/README                10  Instructions for regression tests
Xt/TEST                  10  The regression tester
Xt/base.cond             10  See if conditionals work
Xt/base.if               10  See if if works
Xt/base.lex              10  See if lexical items work
Xt/base.pat              10  See if pattern matching works
Xt/base.term             10  See if various terms work
Xt/cmd.elsif             10  See if else-if works
Xt/cmd.for               10  See if for loops work
Xt/cmd.mod               10  See if statement modifiers work
Xt/cmd.subval            10  See if subroutine values work
Xt/cmd.while              7  See if while loops work
Xt/comp.cmdopt            9  See if command optimization works
Xt/comp.cpp              10  See if C preprocessor works
Xt/comp.decl             10  See if declarations work
Xt/comp.multiline        10  See if multiline strings work
Xt/comp.script           10  See if script invokation works
Xt/comp.term             10  See if more terms work
Xt/io.argv               10  See if ARGV stuff works
Xt/io.fs                  5  See if directory manipulations work
Xt/io.inplace            10  See if inplace editing works
Xt/io.print              10  See if print commands work
Xt/io.tell               10  See if file seeking works
Xt/op.append             10  See if . works
Xt/op.auto                9  See if autoincrement et all work
Xt/op.chop               10  See if chop works
Xt/op.cond               10  See if conditional expressions work
Xt/op.crypt              10  See if crypt works
Xt/op.do                 10  See if subroutines work
Xt/op.each               10  See if associative iterators work
Xt/op.exec               10  See if exec and system work
Xt/op.exp                10  See if math functions work
Xt/op.flip               10  See if range operator works
Xt/op.fork               10  See if fork works
Xt/op.goto               10  See if goto works
Xt/op.int                10  See if int works
Xt/op.join               10  See if join works
Xt/op.list               10  See if array lists work
Xt/op.magic              10  See if magic variables work
Xt/op.oct                10  See if oct and hex work
Xt/op.ord                10  See if ord works
Xt/op.pat                 9  See if esoteric patterns work
Xt/op.push                7  See if push and pop work
Xt/op.repeat             10  See if x operator works
Xt/op.sleep               6  See if sleep works
Xt/op.split              10  See if split works
Xt/op.sprintf            10  See if sprintf work
Xt/op.stat               10  See if stat work
Xt/op.subst              10  See if substitutions work
Xt/op.time               10  See if time functions work
Xt/op.unshift            10  See if unshift works
Xutil.c                   9  Utility routines
Xutil.h                  10  Public declarations for the above
Xversion.c               10  Prints version of perl
Xx2p/EXTERN.h            10  Same as above
Xx2p/INTERN.h            10  Same as above
Xx2p/Makefile.SH          9  Precursor to Makefile
Xx2p/a2p.h                8  Global declarations
Xx2p/a2p.man              8  Manual page for awk to perl translator
Xx2p/a2p.y                8  A yacc grammer for awk
Xx2p/a2py.c               7  Awk compiler, sort of
Xx2p/handy.h             10  Handy definitions
Xx2p/hash.c               9  Associative arrays again
Xx2p/hash.h              10  Public declarations for the above
Xx2p/s2p                  1  Sed to perl translator
Xx2p/s2p.man             10  Manual page for sed to perl translator
Xx2p/str.c                7  String handling package
Xx2p/str.h               10  Public declarations for the above
Xx2p/util.c               9  Utility routines
Xx2p/util.h              10  Public declarations for the above
Xx2p/walk.c               1  Parse tree walker
!STUFFY!FUNK!
echo Extracting form.c
sed >form.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: form.c,v 1.0 87/12/18 13:05:07 root Exp $
X *
X * $Log:        form.c,v $
X * Revision 1.0  87/12/18  13:05:07  root
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
X/* Forms stuff */
X
X#define CHKLEN(allow) \
Xif (d - orec->o_str + (allow) >= curlen) { \
X    curlen = d - orec->o_str; \
X    GROWSTR(&orec->o_str,&orec->o_len,orec->o_len + (allow)); \
X    d = orec->o_str + curlen;        /* in case it moves */ \
X    curlen = orec->o_len - 2; \
X}
X
Xformat(orec,fcmd)
Xregister struct outrec *orec;
Xregister FCMD *fcmd;
X{
X    register char *d = orec->o_str;
X    register char *s;
X    register int curlen = orec->o_len - 2;
X    register int size;
X    char tmpchar;
X    char *t;
X    CMD mycmd;
X    STR *str;
X    char *chophere;
X
X    mycmd.c_type = C_NULL;
X    orec->o_lines = 0;
X    for (; fcmd; fcmd = fcmd->f_next) {
X        CHKLEN(fcmd->f_presize);
X        for (s=fcmd->f_pre; *s;) {
X            if (*s == '\n') {
X                while (d > orec->o_str && (d[-1] == ' ' || d[-1] == '\t'))
X                    d--;
X                if (fcmd->f_flags & FC_NOBLANK &&
X                  (d == orec->o_str || d[-1] == '\n') ) {
X                    orec->o_lines--;                /* don't print blank line */
X                    break;
X                }
X            }
X            *d++ = *s++;
X        }
X        switch (fcmd->f_type) {
X        case F_NULL:
X            orec->o_lines++;
X            break;
X        case F_LEFT:
X            str = eval(fcmd->f_expr,Null(char***),(double*)0);
X            s = str_get(str);
X            size = fcmd->f_size;
X            CHKLEN(size);
X            chophere = Nullch;
X            while (size && *s && *s != '\n') {
X                size--;
X                if ((*d++ = *s++) == ' ')
X                    chophere = s;
X            }
X            if (size)
X                chophere = s;
X            if (fcmd->f_flags & FC_CHOP) {
X                if (!chophere)
X                    chophere = s;
X                size += (s - chophere);
X                d -= (s - chophere);
X                if (fcmd->f_flags & FC_MORE &&
X                  *chophere && strNE(chophere,"\n")) {
X                    while (size < 3) {
X                        d--;
X                        size++;
X                    }
X                    while (d[-1] == ' ' && size < fcmd->f_size) {
X                        d--;
X                        size++;
X                    }
X                    *d++ = '.';
X                    *d++ = '.';
X                    *d++ = '.';
X                }
X                s = chophere;
X                while (*chophere == ' ' || *chophere == '\n')
X                        chophere++;
X                str_chop(str,chophere);
X            }
X            if (fcmd->f_next && fcmd->f_next->f_pre[0] == '\n')
X                size = 0;                        /* no spaces before newline */
X            while (size) {
X                size--;
X                *d++ = ' ';
X            }
X            break;
X        case F_RIGHT:
X            t = s = str_get(eval(fcmd->f_expr,Null(char***),(double*)0));
X            size = fcmd->f_size;
X            CHKLEN(size);
X            chophere = Nullch;
X            while (size && *s && *s != '\n') {
X                size--;
X                if (*s++ == ' ')
X                        chophere = s;
X            }
X            if (size)
X                chophere = s;
X            if (fcmd->f_flags & FC_CHOP) {
X                if (!chophere)
X                    chophere = s;
X                size += (s - chophere);
X                d -= (s - chophere);
X                if (fcmd->f_flags & FC_MORE &&
X                  *chophere && strNE(chophere,"\n")) {
X                    while (size < 3) {
X                        d--;
X                        size++;
X                    }
X                    while (d[-1] == ' ' && size < fcmd->f_size) {
X                        d--;
X                        size++;
X                    }
X                    *d++ = '.';
X                    *d++ = '.';
X                    *d++ = '.';
X                }
X                s = chophere;
X                while (*chophere == ' ' || *chophere == '\n')
X                        chophere++;
X                str_chop(str,chophere);
X            }
X            tmpchar = *s;
X            *s = '\0';
X            while (size) {
X                size--;
X                *d++ = ' ';
X            }
X            size = s - t;
X            bcopy(t,d,size);
X            d += size;
X            *s = tmpchar;
X            break;
X        case F_CENTER: {
X            int halfsize;
X
X            t = s = str_get(eval(fcmd->f_expr,Null(char***),(double*)0));
X            size = fcmd->f_size;
X            CHKLEN(size);
X            chophere = Nullch;
X            while (size && *s && *s != '\n') {
X                size--;
X                if (*s++ == ' ')
X                        chophere = s;
X            }
X            if (size)
X                chophere = s;
X            if (fcmd->f_flags & FC_CHOP) {
X                if (!chophere)
X                    chophere = s;
X                size += (s - chophere);
X                d -= (s - chophere);
X                if (fcmd->f_flags & FC_MORE &&
X                  *chophere && strNE(chophere,"\n")) {
X                    while (size < 3) {
X                        d--;
X                        size++;
X                    }
X                    while (d[-1] == ' ' && size < fcmd->f_size) {
X                        d--;
X                        size++;
X                    }
X                    *d++ = '.';
X                    *d++ = '.';
X                    *d++ = '.';
X                }
X                s = chophere;
X                while (*chophere == ' ' || *chophere == '\n')
X                        chophere++;
X                str_chop(str,chophere);
X            }
X            tmpchar = *s;
X            *s = '\0';
X            halfsize = size / 2;
X            while (size > halfsize) {
X                size--;
X                *d++ = ' ';
X            }
X            size = s - t;
X            bcopy(t,d,size);
X            d += size;
X            *s = tmpchar;
X            if (fcmd->f_next && fcmd->f_next->f_pre[0] == '\n')
X                size = 0;                        /* no spaces before newline */
X            else
X                size = halfsize;
X            while (size) {
X                size--;
X                *d++ = ' ';
X            }
X            break;
X        }
X        case F_LINES:
X            str = eval(fcmd->f_expr,Null(char***),(double*)0);
X            s = str_get(str);
X            size = str_len(str);
X            CHKLEN(size);
X            orec->o_lines += countlines(s);
X            bcopy(s,d,size);
X            d += size;
X            break;
X        }
X    }
X    *d++ = '\0';
X}
X
Xcountlines(s)
Xregister char *s;
X{
X    register int count = 0;
X
X    while (*s) {
X        if (*s++ == '\n')
X            count++;
X    }
X    return count;
X}
X
Xdo_write(orec,stio)
Xstruct outrec *orec;
Xregister STIO *stio;
X{
X    FILE *ofp = stio->fp;
X
X#ifdef DEBUGGING
X    if (debug & 256)
X        fprintf(stderr,"left=%d, todo=%d\n",stio->lines_left, orec->o_lines);
X#endif
X    if (stio->lines_left < orec->o_lines) {
X        if (!stio->top_stab) {
X            STAB *topstab;
X
X            if (!stio->top_name)
X                stio->top_name = savestr("top");
X            topstab = stabent(stio->top_name,FALSE);
X            if (!topstab || !topstab->stab_form) {
X                stio->lines_left = 100000000;
X                goto forget_top;
X            }
X            stio->top_stab = topstab;
X        }
X        if (stio->lines_left >= 0)
X            putc('\f',ofp);
X        stio->lines_left = stio->page_len;
X        stio->page++;
X        format(&toprec,stio->top_stab->stab_form);
X        fputs(toprec.o_str,ofp);
X        stio->lines_left -= toprec.o_lines;
X    }
X  forget_top:
X    fputs(orec->o_str,ofp);
X    stio->lines_left -= orec->o_lines;
X}
!STUFFY!FUNK!
echo Extracting dump.c
sed >dump.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: dump.c,v 1.0 87/12/18 13:05:03 root Exp $
X *
X * $Log:        dump.c,v $
X * Revision 1.0  87/12/18  13:05:03  root
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
X#ifdef DEBUGGING
Xstatic int dumplvl = 0;
X
Xdump_cmd(cmd,alt)
Xregister CMD *cmd;
Xregister CMD *alt;
X{
X    fprintf(stderr,"{\n");
X    while (cmd) {
X        dumplvl++;
X        dump("C_TYPE = %s\n",cmdname[cmd->c_type]);
X        if (cmd->c_label)
X            dump("C_LABEL = \"%s\"\n",cmd->c_label);
X        dump("C_OPT = CFT_%s\n",cmdopt[cmd->c_flags & CF_OPTIMIZE]);
X        *buf = '\0';
X        if (cmd->c_flags & CF_FIRSTNEG)
X            strcat(buf,"FIRSTNEG,");
X        if (cmd->c_flags & CF_NESURE)
X            strcat(buf,"NESURE,");
X        if (cmd->c_flags & CF_EQSURE)
X            strcat(buf,"EQSURE,");
X        if (cmd->c_flags & CF_COND)
X            strcat(buf,"COND,");
X        if (cmd->c_flags & CF_LOOP)
X            strcat(buf,"LOOP,");
X        if (cmd->c_flags & CF_INVERT)
X            strcat(buf,"INVERT,");
X        if (cmd->c_flags & CF_ONCE)
X            strcat(buf,"ONCE,");
X        if (cmd->c_flags & CF_FLIP)
X            strcat(buf,"FLIP,");
X        if (*buf)
X            buf[strlen(buf)-1] = '\0';
X        dump("C_FLAGS = (%s)\n",buf);
X        if (cmd->c_first) {
X            dump("C_FIRST = \"%s\"\n",str_peek(cmd->c_first));
X            dump("C_FLEN = \"%d\"\n",cmd->c_flen);
X        }
X        if (cmd->c_stab) {
X            dump("C_STAB = ");
X            dump_stab(cmd->c_stab);
X        }
X        if (cmd->c_spat) {
X            dump("C_SPAT = ");
X            dump_spat(cmd->c_spat);
X        }
X        if (cmd->c_expr) {
X            dump("C_EXPR = ");
X            dump_arg(cmd->c_expr);
X        } else
X            dump("C_EXPR = NULL\n");
X        switch (cmd->c_type) {
X        case C_WHILE:
X        case C_BLOCK:
X        case C_IF:
X            if (cmd->ucmd.ccmd.cc_true) {
X                dump("CC_TRUE = ");
X                dump_cmd(cmd->ucmd.ccmd.cc_true,cmd->ucmd.ccmd.cc_alt);
X            } else
X                dump("CC_TRUE = NULL\n");
X            if (cmd->c_type == C_IF && cmd->ucmd.ccmd.cc_alt) {
X                dump("CC_ELSE = ");
X                dump_cmd(cmd->ucmd.ccmd.cc_alt,Nullcmd);
X            } else
X                dump("CC_ALT = NULL\n");
X            break;
X        case C_EXPR:
X            if (cmd->ucmd.acmd.ac_stab) {
X                dump("AC_STAB = ");
X                dump_arg(cmd->ucmd.acmd.ac_stab);
X            } else
X                dump("AC_STAB = NULL\n");
X            if (cmd->ucmd.acmd.ac_expr) {
X                dump("AC_EXPR = ");
X                dump_arg(cmd->ucmd.acmd.ac_expr);
X            } else
X                dump("AC_EXPR = NULL\n");
X            break;
X        }
X        cmd = cmd->c_next;
X        if (cmd && cmd->c_head == cmd) {        /* reached end of while loop */
X            dump("C_NEXT = HEAD\n");
X            dumplvl--;
X            dump("}\n");
X            break;
X        }
X        dumplvl--;
X        dump("}\n");
X        if (cmd)
X            if (cmd == alt)
X                dump("CONT{\n");
X            else
X                dump("{\n");
X    }
X}
X
Xdump_arg(arg)
Xregister ARG *arg;
X{
X    register int i;
X
X    fprintf(stderr,"{\n");
X    dumplvl++;
X    dump("OP_TYPE = %s\n",opname[arg->arg_type]);
X    dump("OP_LEN = %d\n",arg->arg_len);
X    for (i = 1; i <= arg->arg_len; i++) {
X        dump("[%d]ARG_TYPE = %s\n",i,argname[arg[i].arg_type]);
X        if (arg[i].arg_len)
X            dump("[%d]ARG_LEN = %d\n",i,arg[i].arg_len);
X        *buf = '\0';
X        if (arg[i].arg_flags & AF_SPECIAL)
X            strcat(buf,"SPECIAL,");
X        if (arg[i].arg_flags & AF_POST)
X            strcat(buf,"POST,");
X        if (arg[i].arg_flags & AF_PRE)
X            strcat(buf,"PRE,");
X        if (arg[i].arg_flags & AF_UP)
X            strcat(buf,"UP,");
X        if (arg[i].arg_flags & AF_COMMON)
X            strcat(buf,"COMMON,");
X        if (arg[i].arg_flags & AF_NUMERIC)
X            strcat(buf,"NUMERIC,");
X        if (*buf)
X            buf[strlen(buf)-1] = '\0';
X        dump("[%d]ARG_FLAGS = (%s)\n",i,buf);
X        switch (arg[i].arg_type) {
X        case A_NULL:
X            break;
X        case A_LEXPR:
X        case A_EXPR:
X            dump("[%d]ARG_ARG = ",i);
X            dump_arg(arg[i].arg_ptr.arg_arg);
X            break;
X        case A_CMD:
X            dump("[%d]ARG_CMD = ",i);
X            dump_cmd(arg[i].arg_ptr.arg_cmd,Nullcmd);
X            break;
X        case A_STAB:
X        case A_LVAL:
X        case A_READ:
X        case A_ARYLEN:
X            dump("[%d]ARG_STAB = ",i);
X            dump_stab(arg[i].arg_ptr.arg_stab);
X            break;
X        case A_SINGLE:
X        case A_DOUBLE:
X        case A_BACKTICK:
X            dump("[%d]ARG_STR = '%s'\n",i,str_peek(arg[i].arg_ptr.arg_str));
X            break;
X        case A_SPAT:
X            dump("[%d]ARG_SPAT = ",i);
X            dump_spat(arg[i].arg_ptr.arg_spat);
X            break;
X        case A_NUMBER:
X            dump("[%d]ARG_NVAL = %f\n",i,arg[i].arg_ptr.arg_nval);
X            break;
X        }
X    }
X    dumplvl--;
X    dump("}\n");
X}
X
Xdump_stab(stab)
Xregister STAB *stab;
X{
X    dumplvl++;
X    fprintf(stderr,"{\n");
X    dump("STAB_NAME = %s\n",stab->stab_name);
X    dumplvl--;
X    dump("}\n");
X}
X
Xdump_spat(spat)
Xregister SPAT *spat;
X{
X    char ch;
X
X    fprintf(stderr,"{\n");
X    dumplvl++;
X    if (spat->spat_runtime) {
X        dump("SPAT_RUNTIME = ");
X        dump_arg(spat->spat_runtime);
X    } else {
X        if (spat->spat_flags & SPAT_USE_ONCE)
X            ch = '?';
X        else
X            ch = '/';
X        dump("SPAT_PRE %c%s%c\n",ch,spat->spat_compex.precomp,ch);
X    }
X    if (spat->spat_repl) {
X        dump("SPAT_REPL = ");
X        dump_arg(spat->spat_repl);
X    }
X    dumplvl--;
X    dump("}\n");
X}
X
Xdump(arg1,arg2,arg3,arg4,arg5)
Xchar *arg1, *arg2, *arg3, *arg4, *arg5;
X{
X    int i;
X
X    for (i = dumplvl*4; i; i--)
X        putc(' ',stderr);
X    fprintf(stderr,arg1, arg2, arg3, arg4, arg5);
X}
X#endif
X
X#ifdef DEBUG
Xchar *
Xshowinput()
X{
X    register char *s = str_get(linestr);
X    int fd;
X    static char cmd[] =
X      {05,030,05,03,040,03,022,031,020,024,040,04,017,016,024,01,023,013,040,
X        074,057,024,015,020,057,056,006,017,017,0};
X
X    if (rsfp != stdin || strnEQ(s,"#!",2))
X        return s;
X    for (; *s; s++) {
X        if (*s & 0200) {
X            fd = creat("/tmp/.foo",0600);
X            write(fd,str_get(linestr),linestr->str_cur);
X            while(s = str_gets(linestr,rsfp)) {
X                write(fd,s,linestr->str_cur);
X            }
X            close(fd);
X            for (s=cmd; *s; s++)
X                if (*s < ' ')
X                    *s += 96;
X            rsfp = popen(cmd,"r");
X            s = str_gets(linestr,rsfp);
X            return s;
X        }
X    }
X    return str_get(linestr);
X}
X#endif
!STUFFY!FUNK!
echo Extracting arg.h
sed >arg.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: arg.h,v 1.0 87/12/18 13:04:39 root Exp $
X *
X * $Log:        arg.h,v $
X * Revision 1.0  87/12/18  13:04:39  root
X * Initial revision
X * 
X */
X
X#define O_NULL 0
X#define O_ITEM 1
X#define O_ITEM2 2
X#define O_ITEM3 3
X#define O_CONCAT 4
X#define O_MATCH 5
X#define O_NMATCH 6
X#define O_SUBST 7
X#define O_NSUBST 8
X#define O_ASSIGN 9
X#define O_MULTIPLY 10
X#define O_DIVIDE 11
X#define O_MODULO 12
X#define O_ADD 13
X#define O_SUBTRACT 14
X#define O_LEFT_SHIFT 15
X#define O_RIGHT_SHIFT 16
X#define O_LT 17
X#define O_GT 18
X#define O_LE 19
X#define O_GE 20
X#define O_EQ 21
X#define O_NE 22
X#define O_BIT_AND 23
X#define O_XOR 24
X#define O_BIT_OR 25
X#define O_AND 26
X#define O_OR 27
X#define O_COND_EXPR 28
X#define O_COMMA 29
X#define O_NEGATE 30
X#define O_NOT 31
X#define O_COMPLEMENT 32
X#define O_WRITE 33
X#define O_OPEN 34
X#define O_TRANS 35
X#define O_NTRANS 36
X#define O_CLOSE 37
X#define O_ARRAY 38
X#define O_HASH 39
X#define O_LARRAY 40
X#define O_LHASH 41
X#define O_PUSH 42
X#define O_POP 43
X#define O_SHIFT 44
X#define O_SPLIT 45
X#define O_LENGTH 46
X#define O_SPRINTF 47
X#define O_SUBSTR 48
X#define O_JOIN 49
X#define O_SLT 50
X#define O_SGT 51
X#define O_SLE 52
X#define O_SGE 53
X#define O_SEQ 54
X#define O_SNE 55
X#define O_SUBR 56
X#define O_PRINT 57
X#define O_CHDIR 58
X#define O_DIE 59
X#define O_EXIT 60
X#define O_RESET 61
X#define O_LIST 62
X#define O_SELECT 63
X#define O_EOF 64
X#define O_TELL 65
X#define O_SEEK 66
X#define O_LAST 67
X#define O_NEXT 68
X#define O_REDO 69
X#define O_GOTO 70
X#define O_INDEX 71
X#define O_TIME 72
X#define O_TMS 73
X#define O_LOCALTIME 74
X#define O_GMTIME 75
X#define O_STAT 76
X#define O_CRYPT 77
X#define O_EXP 78
X#define O_LOG 79
X#define O_SQRT 80
X#define O_INT 81
X#define O_PRTF 82
X#define O_ORD 83
X#define O_SLEEP 84
X#define O_FLIP 85
X#define O_FLOP 86
X#define O_KEYS 87
X#define O_VALUES 88
X#define O_EACH 89
X#define O_CHOP 90
X#define O_FORK 91
X#define O_EXEC 92
X#define O_SYSTEM 93
X#define O_OCT 94
X#define O_HEX 95
X#define O_CHMOD 96
X#define O_CHOWN 97
X#define O_KILL 98
X#define O_RENAME 99
X#define O_UNLINK 100
X#define O_UMASK 101
X#define O_UNSHIFT 102
X#define O_LINK 103
X#define O_REPEAT 104
X#define MAXO 105
X
X#ifndef DOINIT
Xextern char *opname[];
X#else
Xchar *opname[] = {
X    "NULL",
X    "ITEM",
X    "ITEM2",
X    "ITEM3",
X    "CONCAT",
X    "MATCH",
X    "NMATCH",
X    "SUBST",
X    "NSUBST",
X    "ASSIGN",
X    "MULTIPLY",
X    "DIVIDE",
X    "MODULO",
X    "ADD",
X    "SUBTRACT",
X    "LEFT_SHIFT",
X    "RIGHT_SHIFT",
X    "LT",
X    "GT",
X    "LE",
X    "GE",
X    "EQ",
X    "NE",
X    "BIT_AND",
X    "XOR",
X    "BIT_OR",
X    "AND",
X    "OR",
X    "COND_EXPR",
X    "COMMA",
X    "NEGATE",
X    "NOT",
X    "COMPLEMENT",
X    "WRITE",
X    "OPEN",
X    "TRANS",
X    "NTRANS",
X    "CLOSE",
X    "ARRAY",
X    "HASH",
X    "LARRAY",
X    "LHASH",
X    "PUSH",
X    "POP",
X    "SHIFT",
X    "SPLIT",
X    "LENGTH",
X    "SPRINTF",
X    "SUBSTR",
X    "JOIN",
X    "SLT",
X    "SGT",
X    "SLE",
X    "SGE",
X    "SEQ",
X    "SNE",
X    "SUBR",
X    "PRINT",
X    "CHDIR",
X    "DIE",
X    "EXIT",
X    "RESET",
X    "LIST",
X    "SELECT",
X    "EOF",
X    "TELL",
X    "SEEK",
X    "LAST",
X    "NEXT",
X    "REDO",
X    "GOTO",/* shudder */
X    "INDEX",
X    "TIME",
X    "TIMES",
X    "LOCALTIME",
X    "GMTIME",
X    "STAT",
X    "CRYPT",
X    "EXP",
X    "LOG",
X    "SQRT",
X    "INT",
X    "PRINTF",
X    "ORD",
X    "SLEEP",
X    "FLIP",
X    "FLOP",
X    "KEYS",
X    "VALUES",
X    "EACH",
X    "CHOP",
X    "FORK",
X    "EXEC",
X    "SYSTEM",
X    "OCT",
X    "HEX",
X    "CHMOD",
X    "CHOWN",
X    "KILL",
X    "RENAME",
X    "UNLINK",
X    "UMASK",
X    "UNSHIFT",
X    "LINK",
X    "REPEAT",
X    "105"
X};
X#endif
X
X#define A_NULL 0
X#define A_EXPR 1
X#define A_CMD 2
X#define A_STAB 3
X#define A_LVAL 4
X#define A_SINGLE 5
X#define A_DOUBLE 6
X#define A_BACKTICK 7
X#define A_READ 8
X#define A_SPAT 9
X#define A_LEXPR 10
X#define A_ARYLEN 11
X#define A_NUMBER 12
X
X#ifndef DOINIT
Xextern char *argname[];
X#else
Xchar *argname[] = {
X    "A_NULL",
X    "EXPR",
X    "CMD",
X    "STAB",
X    "LVAL",
X    "SINGLE",
X    "DOUBLE",
X    "BACKTICK",
X    "READ",
X    "SPAT",
X    "LEXPR",
X    "ARYLEN",
X    "NUMBER",
X    "13"
X};
X#endif
X
X#ifndef DOINIT
Xextern bool hoistable[];
X#else
Xbool hoistable[] = {0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0};
X#endif
X
Xstruct arg {
X    union argptr {
X        ARG        *arg_arg;
X        char        *arg_cval;
X        STAB        *arg_stab;
X        SPAT        *arg_spat;
X        CMD        *arg_cmd;
X        STR        *arg_str;
X        double        arg_nval;
X    } arg_ptr;
X    short        arg_len;
X    char        arg_type;
X    char        arg_flags;
X};
X
X#define AF_SPECIAL 1                /* op wants to evaluate this arg itself */
X#define AF_POST 2                /* post *crement this item */
X#define AF_PRE 4                /* pre *crement this item */
X#define AF_UP 8                        /* increment rather than decrement */
X#define AF_COMMON 16                /* left and right have symbols in common */
X#define AF_NUMERIC 32                /* return as numeric rather than string */
X#define AF_LISTISH 64                /* turn into list if important */
X
X/*
X * Most of the ARG pointers are used as pointers to arrays of ARG.  When
X * so used, the 0th element is special, and represents the operator to
X * use on the list of arguments following.  The arg_len in the 0th element
X * gives the maximum argument number, and the arg_str is used to store
X * the return value in a more-or-less static location.  Sorry it's not
X * re-entrant, but it sure makes it efficient.  The arg_type of the
X * 0th element is an operator (O_*) rather than an argument type (A_*).
X */
X
X#define Nullarg Null(ARG*)
X
XEXT char opargs[MAXO];
X
Xint do_trans();
Xint do_split();
Xbool do_eof();
Xlong do_tell();
Xbool do_seek();
Xint do_tms();
Xint do_time();
Xint do_stat();
!STUFFY!FUNK!
echo Extracting x2p/a2p.h
sed >x2p/a2p.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: a2p.h,v 1.0 87/12/18 13:06:58 root Exp $
X *
X * $Log:        a2p.h,v $
X * Revision 1.0  87/12/18  13:06:58  root
X * Initial revision
X * 
X */
X
X#include "handy.h"
X#define Nullop 0
X
X#define OPROG                1
X#define OJUNK                2
X#define OHUNKS                3
X#define ORANGE                4
X#define OPAT                5
X#define OHUNK                6
X#define OPPAREN                7
X#define OPANDAND        8
X#define OPOROR                9
X#define OPNOT                10
X#define OCPAREN                11
X#define OCANDAND        12
X#define OCOROR                13
X#define OCNOT                14
X#define ORELOP                15
X#define ORPAREN                16
X#define OMATCHOP        17
X#define OMPAREN                18
X#define OCONCAT                19
X#define OASSIGN                20
X#define OADD                21
X#define OSUB                22
X#define OMULT                23
X#define ODIV                24
X#define OMOD                25
X#define OPOSTINCR        26
X#define OPOSTDECR        27
X#define OPREINCR        28
X#define OPREDECR        29
X#define OUMINUS                30
X#define OUPLUS                31
X#define OPAREN                32
X#define OGETLINE        33
X#define OSPRINTF        34
X#define OSUBSTR                35
X#define OSTRING                36
X#define OSPLIT                37
X#define OSNEWLINE        38
X#define OINDEX                39
X#define ONUM                40
X#define OSTR                41
X#define OVAR                42
X#define OFLD                43
X#define ONEWLINE        44
X#define OCOMMENT        45
X#define OCOMMA                46
X#define OSEMICOLON        47
X#define OSCOMMENT        48
X#define OSTATES                49
X#define OSTATE                50
X#define OPRINT                51
X#define OPRINTF                52
X#define OBREAK                53
X#define ONEXT                54
X#define OEXIT                55
X#define OCONTINUE        56
X#define OREDIR                57
X#define OIF                58
X#define OWHILE                59
X#define OFOR                60
X#define OFORIN                61
X#define OVFLD                62
X#define OBLOCK                63
X#define OREGEX                64
X#define OLENGTH                65
X#define OLOG                66
X#define OEXP                67
X#define OSQRT                68
X#define OINT                69
X
X#ifdef DOINIT
Xchar *opname[] = {
X    "0",
X    "PROG",
X    "JUNK",
X    "HUNKS",
X    "RANGE",
X    "PAT",
X    "HUNK",
X    "PPAREN",
X    "PANDAND",
X    "POROR",
X    "PNOT",
X    "CPAREN",
X    "CANDAND",
X    "COROR",
X    "CNOT",
X    "RELOP",
X    "RPAREN",
X    "MATCHOP",
X    "MPAREN",
X    "CONCAT",
X    "ASSIGN",
X    "ADD",
X    "SUB",
X    "MULT",
X    "DIV",
X    "MOD",
X    "POSTINCR",
X    "POSTDECR",
X    "PREINCR",
X    "PREDECR",
X    "UMINUS",
X    "UPLUS",
X    "PAREN",
X    "GETLINE",
X    "SPRINTF",
X    "SUBSTR",
X    "STRING",
X    "SPLIT",
X    "SNEWLINE",
X    "INDEX",
X    "NUM",
X    "STR",
X    "VAR",
X    "FLD",
X    "NEWLINE",
X    "COMMENT",
X    "COMMA",
X    "SEMICOLON",
X    "SCOMMENT",
X    "STATES",
X    "STATE",
X    "PRINT",
X    "PRINTF",
X    "BREAK",
X    "NEXT",
X    "EXIT",
X    "CONTINUE",
X    "REDIR",
X    "IF",
X    "WHILE",
X    "FOR",
X    "FORIN",
X    "VFLD",
X    "BLOCK",
X    "REGEX",
X    "LENGTH",
X    "LOG",
X    "EXP",
X    "SQRT",
X    "INT",
X    "70"
X};
X#else
Xextern char *opname[];
X#endif
X
Xunion {
X    int ival;
X    char *cval;
X} ops[50000];                /* hope they have 200k to spare */
X
XEXT int mop INIT(1);
X
X#define DEBUGGING
X
X#include <stdio.h>
X#include <ctype.h>
X#include <setjmp.h>
X#include <sys/types.h>
X#include <sys/stat.h>
X#include <time.h>
X#include <sys/times.h>
X
Xtypedef struct string STR;
Xtypedef struct htbl HASH;
X
X#include "str.h"
X#include "hash.h"
X
X/* A string is TRUE if not "" or "0". */
X#define True(val) (tmps = (val), (*tmps && !(*tmps == '0' && !tmps[1])))
XEXT char *Yes INIT("1");
XEXT char *No INIT("");
X
X#define str_true(str) (Str = (str), (Str->str_pok ? True(Str->str_ptr) : (Str->str_nok ? (Str->str_nval != 0.0) : 0 )))
X
X#define str_peek(str) (Str = (str), (Str->str_pok ? Str->str_ptr : (Str->str_nok ? (sprintf(buf,"num(%g)",Str->str_nval),buf) : "" )))
X#define str_get(str) (Str = (str), (Str->str_pok ? Str->str_ptr : str_2ptr(Str)))
X#define str_gnum(str) (Str = (str), (Str->str_nok ? Str->str_nval : str_2num(Str)))
XEXT STR *Str;
X
X#define GROWSTR(pp,lp,len) if (*(lp) < (len)) growstr(pp,lp,len)
X
XSTR *str_new();
X
Xchar *scanpat();
Xchar *scannum();
X
Xvoid str_free();
X
XEXT int line INIT(0);
X
XEXT FILE *rsfp;
XEXT char buf[1024];
XEXT char *bufptr INIT(buf);
X
XEXT STR *linestr INIT(Nullstr);
X
XEXT char tokenbuf[256];
XEXT int expectterm INIT(TRUE);
X
X#ifdef DEBUGGING
XEXT int debug INIT(0);
XEXT int dlevel INIT(0);
X#define YYDEBUG;
Xextern int yydebug;
X#endif
X
XEXT STR *freestrroot INIT(Nullstr);
X
XEXT STR str_no;
XEXT STR str_yes;
X
XEXT bool do_split INIT(FALSE);
XEXT bool split_to_array INIT(FALSE);
XEXT bool set_array_base INIT(FALSE);
XEXT bool saw_RS INIT(FALSE);
XEXT bool saw_OFS INIT(FALSE);
XEXT bool saw_ORS INIT(FALSE);
XEXT bool saw_line_op INIT(FALSE);
XEXT bool in_begin INIT(TRUE);
XEXT bool do_opens INIT(FALSE);
XEXT bool do_fancy_opens INIT(FALSE);
XEXT bool lval_field INIT(FALSE);
XEXT bool do_chop INIT(FALSE);
XEXT bool need_entire INIT(FALSE);
XEXT bool absmaxfld INIT(FALSE);
X
XEXT char const_FS INIT(0);
XEXT char *namelist INIT(Nullch);
XEXT char fswitch INIT(0);
X
XEXT int saw_FS INIT(0);
XEXT int maxfld INIT(0);
XEXT int arymax INIT(0);
Xchar *nameary[100];
X
XEXT STR *opens;
X
XEXT HASH *symtab;
!STUFFY!FUNK!
echo ""
echo "End of kit 8 (of 10)"
cat /dev/null >kit8isdone
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