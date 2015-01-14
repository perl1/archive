#! /bin/sh

# Make a new directory for the perl sources, cd to it, and run kits 1
# thru 10 through sh.  When all 10 kits have been run, read README.

echo "This is perl 1.0 kit 7 (of 10).  If kit 7 is complete, the line"
echo '"'"End of kit 7 (of 10)"'" will echo at the end.'
echo ""
export PATH || (echo "You didn't use sh, you clunch." ; kill $$)
mkdir t 2>/dev/null
mkdir x2p 2>/dev/null
echo Extracting x2p/a2py.c
sed >x2p/a2py.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: a2py.c,v 1.0 87/12/18 17:50:33 root Exp $
X *
X * $Log:        a2py.c,v $
X * Revision 1.0  87/12/18  17:50:33  root
X * Initial revision
X * 
X */
X
X#include "util.h"
Xchar *index();
X
Xchar *filename;
X
Xmain(argc,argv,env)
Xregister int argc;
Xregister char **argv;
Xregister char **env;
X{
X    register STR *str;
X    register char *s;
X    int i;
X    STR *walk();
X    STR *tmpstr;
X
X    linestr = str_new(80);
X    str = str_new(0);                /* first used for -I flags */
X    for (argc--,argv++; argc; argc--,argv++) {
X        if (argv[0][0] != '-' || !argv[0][1])
X            break;
X      reswitch:
X        switch (argv[0][1]) {
X#ifdef DEBUGGING
X        case 'D':
X            debug = atoi(argv[0]+2);
X#ifdef YYDEBUG
X            yydebug = (debug & 1);
X#endif
X            break;
X#endif
X        case '0': case '1': case '2': case '3': case '4':
X        case '5': case '6': case '7': case '8': case '9':
X            maxfld = atoi(argv[0]+1);
X            absmaxfld = TRUE;
X            break;
X        case 'F':
X            fswitch = argv[0][2];
X            break;
X        case 'n':
X            namelist = savestr(argv[0]+2);
X            break;
X        case '-':
X            argc--,argv++;
X            goto switch_end;
X        case 0:
X            break;
X        default:
X            fatal("Unrecognized switch: %s\n",argv[0]);
X        }
X    }
X  switch_end:
X
X    /* open script */
X
X    if (argv[0] == Nullch)
X        argv[0] = "-";
X    filename = savestr(argv[0]);
X    if (strEQ(filename,"-"))
X        argv[0] = "";
X    if (!*argv[0])
X        rsfp = stdin;
X    else
X        rsfp = fopen(argv[0],"r");
X    if (rsfp == Nullfp)
X        fatal("Awk script \"%s\" doesn't seem to exist.\n",filename);
X
X    /* init tokener */
X
X    bufptr = str_get(linestr);
X    symtab = hnew();
X
X    /* now parse the report spec */
X
X    if (yyparse())
X        fatal("Translation aborted due to syntax errors.\n");
X
X#ifdef DEBUGGING
X    if (debug & 2) {
X        int type, len;
X
X        for (i=1; i<mop;) {
X            type = ops[i].ival;
X            len = type >> 8;
X            type &= 255;
X            printf("%d\t%d\t%d\t%-10s",i++,type,len,opname[type]);
X            if (type == OSTRING)
X                printf("\t\"%s\"\n",ops[i].cval),i++;
X            else {
X                while (len--) {
X                    printf("\t%d",ops[i].ival),i++;
X                }
X                putchar('\n');
X            }
X        }
X    }
X    if (debug & 8)
X        dump(root);
X#endif
X
X    /* first pass to look for numeric variables */
X
X    prewalk(0,0,root,&i);
X
X    /* second pass to produce new program */
X
X    tmpstr = walk(0,0,root,&i);
X    str = str_make("#!/bin/perl\n\n");
X    if (do_opens && opens) {
X        str_scat(str,opens);
X        str_free(opens);
X        str_cat(str,"\n");
X    }
X    str_scat(str,tmpstr);
X    str_free(tmpstr);
X#ifdef DEBUGGING
X    if (!(debug & 16))
X#endif
X    fixup(str);
X    putlines(str);
X    exit(0);
X}
X
X#define RETURN(retval) return (bufptr = s,retval)
X#define XTERM(retval) return (expectterm = TRUE,bufptr = s,retval)
X#define XOP(retval) return (expectterm = FALSE,bufptr = s,retval)
X#define ID(x) return (yylval=string(x,0),expectterm = FALSE,bufptr = s,VAR)
X
Xyylex()
X{
X    register char *s = bufptr;
X    register char *d;
X    register int tmp;
X
X  retry:
X#ifdef YYDEBUG
X    if (yydebug)
X        if (index(s,'\n'))
X            fprintf(stderr,"Tokener at %s",s);
X        else
X            fprintf(stderr,"Tokener at %s\n",s);
X#endif
X    switch (*s) {
X    default:
X        fprintf(stderr,
X            "Unrecognized character %c in file %s line %d--ignoring.\n",
X             *s++,filename,line);
X        goto retry;
X    case '\\':
X    case 0:
X        s = str_get(linestr);
X        *s = '\0';
X        if (!rsfp)
X            RETURN(0);
X        line++;
X        if ((s = str_gets(linestr, rsfp)) == Nullch) {
X            if (rsfp != stdin)
X                fclose(rsfp);
X            rsfp = Nullfp;
X            s = str_get(linestr);
X            RETURN(0);
X        }
X        goto retry;
X    case ' ': case '\t':
X        s++;
X        goto retry;
X    case '\n':
X        *s = '\0';
X        XTERM(NEWLINE);
X    case '#':
X        yylval = string(s,0);
X        *s = '\0';
X        XTERM(COMMENT);
X    case ';':
X        tmp = *s++;
X        if (*s == '\n') {
X            s++;
X            XTERM(SEMINEW);
X        }
X        XTERM(tmp);
X    case '(':
X    case '{':
X    case '[':
X    case ')':
X    case ']':
X        tmp = *s++;
X        XOP(tmp);
X    case 127:
X        s++;
X        XTERM('}');
X    case '}':
X        for (d = s + 1; isspace(*d); d++) ;
X        if (!*d)
X            s = d - 1;
X        *s = 127;
X        XTERM(';');
X    case ',':
X        tmp = *s++;
X        XTERM(tmp);
X    case '~':
X        s++;
X        XTERM(MATCHOP);
X    case '+':
X    case '-':
X        if (s[1] == *s) {
X            s++;
X            if (*s++ == '+')
X                XTERM(INCR);
X            else
X                XTERM(DECR);
X        }
X        /* FALL THROUGH */
X    case '*':
X    case '%':
X        tmp = *s++;
X        if (*s == '=') {
X            yylval = string(s-1,2);
X            s++;
X            XTERM(ASGNOP);
X        }
X        XTERM(tmp);
X    case '&':
X        s++;
X        tmp = *s++;
X        if (tmp == '&')
X            XTERM(ANDAND);
X        s--;
X        XTERM('&');
X    case '|':
X        s++;
X        tmp = *s++;
X        if (tmp == '|')
X            XTERM(OROR);
X        s--;
X        XTERM('|');
X    case '=':
X        s++;
X        tmp = *s++;
X        if (tmp == '=') {
X            yylval = string("==",2);
X            XTERM(RELOP);
X        }
X        s--;
X        yylval = string("=",1);
X        XTERM(ASGNOP);
X    case '!':
X        s++;
X        tmp = *s++;
X        if (tmp == '=') {
X            yylval = string("!=",2);
X            XTERM(RELOP);
X        }
X        if (tmp == '~') {
X            yylval = string("!~",2);
X            XTERM(MATCHOP);
X        }
X        s--;
X        XTERM(NOT);
X    case '<':
X        s++;
X        tmp = *s++;
X        if (tmp == '=') {
X            yylval = string("<=",2);
X            XTERM(RELOP);
X        }
X        s--;
X        yylval = string("<",1);
X        XTERM(RELOP);
X    case '>':
X        s++;
X        tmp = *s++;
X        if (tmp == '=') {
X            yylval = string(">=",2);
X            XTERM(RELOP);
X        }
X        s--;
X        yylval = string(">",1);
X        XTERM(RELOP);
X
X#define SNARFWORD \
X        d = tokenbuf; \
X        while (isalpha(*s) || isdigit(*s) || *s == '_') \
X            *d++ = *s++; \
X        *d = '\0'; \
X        d = tokenbuf;
X
X    case '$':
X        s++;
X        if (*s == '0') {
X            s++;
X            do_chop = TRUE;
X            need_entire = TRUE;
X            ID("0");
X        }
X        do_split = TRUE;
X        if (isdigit(*s)) {
X            for (d = s; isdigit(*s); s++) ;
X            yylval = string(d,s-d);
X            tmp = atoi(d);
X            if (tmp > maxfld)
X                maxfld = tmp;
X            XOP(FIELD);
X        }
X        split_to_array = set_array_base = TRUE;
X        XOP(VFIELD);
X
X    case '/':                        /* may either be division or pattern */
X        if (expectterm) {
X            s = scanpat(s);
X            XTERM(REGEX);
X        }
X        tmp = *s++;
X        if (*s == '=') {
X            yylval = string("/=",2);
X            s++;
X            XTERM(ASGNOP);
X        }
X        XTERM(tmp);
X
X    case '0': case '1': case '2': case '3': case '4':
X    case '5': case '6': case '7': case '8': case '9':
X        s = scannum(s);
X        XOP(NUMBER);
X    case '"':
X        s++;
X        s = cpy2(tokenbuf,s,s[-1]);
X        if (!*s)
X            fatal("String not terminated:\n%s",str_get(linestr));
X        s++;
X        yylval = string(tokenbuf,0);
X        XOP(STRING);
X
X    case 'a': case 'A':
X        SNARFWORD;
X        ID(d);
X    case 'b': case 'B':
X        SNARFWORD;
X        if (strEQ(d,"break"))
X            XTERM(BREAK);
X        if (strEQ(d,"BEGIN"))
X            XTERM(BEGIN);
X        ID(d);
X    case 'c': case 'C':
X        SNARFWORD;
X        if (strEQ(d,"continue"))
X            XTERM(CONTINUE);
X        ID(d);
X    case 'd': case 'D':
X        SNARFWORD;
X        ID(d);
X    case 'e': case 'E':
X        SNARFWORD;
X        if (strEQ(d,"END"))
X            XTERM(END);
X        if (strEQ(d,"else"))
X            XTERM(ELSE);
X        if (strEQ(d,"exit")) {
X            saw_line_op = TRUE;
X            XTERM(EXIT);
X        }
X        if (strEQ(d,"exp")) {
X            yylval = OEXP;
X            XTERM(FUN1);
X        }
X        ID(d);
X    case 'f': case 'F':
X        SNARFWORD;
X        if (strEQ(d,"FS")) {
X            saw_FS++;
X            if (saw_FS == 1 && in_begin) {
X                for (d = s; *d && isspace(*d); d++) ;
X                if (*d == '=') {
X                    for (d++; *d && isspace(*d); d++) ;
X                    if (*d == '"' && d[2] == '"')
X                        const_FS = d[1];
X                }
X            }
X            ID(tokenbuf);
X        }
X        if (strEQ(d,"FILENAME"))
X            d = "ARGV";
X        if (strEQ(d,"for"))
X            XTERM(FOR);
X        ID(d);
X    case 'g': case 'G':
X        SNARFWORD;
X        if (strEQ(d,"getline"))
X            XTERM(GETLINE);
X        ID(d);
X    case 'h': case 'H':
X        SNARFWORD;
X        ID(d);
X    case 'i': case 'I':
X        SNARFWORD;
X        if (strEQ(d,"if"))
X            XTERM(IF);
X        if (strEQ(d,"in"))
X            XTERM(IN);
X        if (strEQ(d,"index")) {
X            set_array_base = TRUE;
X            XTERM(INDEX);
X        }
X        if (strEQ(d,"int")) {
X            yylval = OINT;
X            XTERM(FUN1);
X        }
X        ID(d);
X    case 'j': case 'J':
X        SNARFWORD;
X        ID(d);
X    case 'k': case 'K':
X        SNARFWORD;
X        ID(d);
X    case 'l': case 'L':
X        SNARFWORD;
X        if (strEQ(d,"length")) {
X            yylval = OLENGTH;
X            XTERM(FUN1);
X        }
X        if (strEQ(d,"log")) {
X            yylval = OLOG;
X            XTERM(FUN1);
X        }
X        ID(d);
X    case 'm': case 'M':
X        SNARFWORD;
X        ID(d);
X    case 'n': case 'N':
X        SNARFWORD;
X        if (strEQ(d,"NF"))
X            do_split = split_to_array = set_array_base = TRUE;
X        if (strEQ(d,"next")) {
X            saw_line_op = TRUE;
X            XTERM(NEXT);
X        }
X        ID(d);
X    case 'o': case 'O':
X        SNARFWORD;
X        if (strEQ(d,"ORS")) {
X            saw_ORS = TRUE;
X            d = "$\\";
X        }
X        if (strEQ(d,"OFS")) {
X            saw_OFS = TRUE;
X            d = "$,";
X        }
X        if (strEQ(d,"OFMT")) {
X            d = "$#";
X        }
X        ID(d);
X    case 'p': case 'P':
X        SNARFWORD;
X        if (strEQ(d,"print")) {
X            XTERM(PRINT);
X        }
X        if (strEQ(d,"printf")) {
X            XTERM(PRINTF);
X        }
X        ID(d);
X    case 'q': case 'Q':
X        SNARFWORD;
X        ID(d);
X    case 'r': case 'R':
X        SNARFWORD;
X        if (strEQ(d,"RS")) {
X            d = "$/";
X            saw_RS = TRUE;
X        }
X        ID(d);
X    case 's': case 'S':
X        SNARFWORD;
X        if (strEQ(d,"split")) {
X            set_array_base = TRUE;
X            XOP(SPLIT);
X        }
X        if (strEQ(d,"substr")) {
X            set_array_base = TRUE;
X            XTERM(SUBSTR);
X        }
X        if (strEQ(d,"sprintf"))
X            XTERM(SPRINTF);
X        if (strEQ(d,"sqrt")) {
X            yylval = OSQRT;
X            XTERM(FUN1);
X        }
X        ID(d);
X    case 't': case 'T':
X        SNARFWORD;
X        ID(d);
X    case 'u': case 'U':
X        SNARFWORD;
X        ID(d);
X    case 'v': case 'V':
X        SNARFWORD;
X        ID(d);
X    case 'w': case 'W':
X        SNARFWORD;
X        if (strEQ(d,"while"))
X            XTERM(WHILE);
X        ID(d);
X    case 'x': case 'X':
X        SNARFWORD;
X        ID(d);
X    case 'y': case 'Y':
X        SNARFWORD;
X        ID(d);
X    case 'z': case 'Z':
X        SNARFWORD;
X        ID(d);
X    }
X}
X
Xchar *
Xscanpat(s)
Xregister char *s;
X{
X    register char *d;
X
X    switch (*s++) {
X    case '/':
X        break;
X    default:
X        fatal("Search pattern not found:\n%s",str_get(linestr));
X    }
X    s = cpytill(tokenbuf,s,s[-1]);
X    if (!*s)
X        fatal("Search pattern not terminated:\n%s",str_get(linestr));
X    s++;
X    yylval = string(tokenbuf,0);
X    return s;
X}
X
Xyyerror(s)
Xchar *s;
X{
X    fprintf(stderr,"%s in file %s at line %d\n",
X      s,filename,line);
X}
X
Xchar *
Xscannum(s)
Xregister char *s;
X{
X    register char *d;
X
X    switch (*s) {
X    case '1': case '2': case '3': case '4': case '5':
X    case '6': case '7': case '8': case '9': case '0' : case '.':
X        d = tokenbuf;
X        while (isdigit(*s) || *s == '_')
X            *d++ = *s++;
X        if (*s == '.' && index("0123456789eE",s[1]))
X            *d++ = *s++;
X        while (isdigit(*s) || *s == '_')
X            *d++ = *s++;
X        if (index("eE",*s) && index("+-0123456789",s[1]))
X            *d++ = *s++;
X        if (*s == '+' || *s == '-')
X            *d++ = *s++;
X        while (isdigit(*s))
X            *d++ = *s++;
X        *d = '\0';
X        yylval = string(tokenbuf,0);
X        break;
X    }
X    return s;
X}
X
Xstring(ptr,len)
Xchar *ptr;
X{
X    int retval = mop;
X
X    ops[mop++].ival = OSTRING + (1<<8);
X    if (!len)
X        len = strlen(ptr);
X    ops[mop].cval = safemalloc(len+1);
X    strncpy(ops[mop].cval,ptr,len);
X    ops[mop++].cval[len] = '\0';
X    return retval;
X}
X
Xoper0(type)
Xint type;
X{
X    int retval = mop;
X
X    if (type > 255)
X        fatal("type > 255 (%d)\n",type);
X    ops[mop++].ival = type;
X    return retval;
X}
X
Xoper1(type,arg1)
Xint type;
Xint arg1;
X{
X    int retval = mop;
X
X    if (type > 255)
X        fatal("type > 255 (%d)\n",type);
X    ops[mop++].ival = type + (1<<8);
X    ops[mop++].ival = arg1;
X    return retval;
X}
X
Xoper2(type,arg1,arg2)
Xint type;
Xint arg1;
Xint arg2;
X{
X    int retval = mop;
X
X    if (type > 255)
X        fatal("type > 255 (%d)\n",type);
X    ops[mop++].ival = type + (2<<8);
X    ops[mop++].ival = arg1;
X    ops[mop++].ival = arg2;
X    return retval;
X}
X
Xoper3(type,arg1,arg2,arg3)
Xint type;
Xint arg1;
Xint arg2;
Xint arg3;
X{
X    int retval = mop;
X
X    if (type > 255)
X        fatal("type > 255 (%d)\n",type);
X    ops[mop++].ival = type + (3<<8);
X    ops[mop++].ival = arg1;
X    ops[mop++].ival = arg2;
X    ops[mop++].ival = arg3;
X    return retval;
X}
X
Xoper4(type,arg1,arg2,arg3,arg4)
Xint type;
Xint arg1;
Xint arg2;
Xint arg3;
Xint arg4;
X{
X    int retval = mop;
X
X    if (type > 255)
X        fatal("type > 255 (%d)\n",type);
X    ops[mop++].ival = type + (4<<8);
X    ops[mop++].ival = arg1;
X    ops[mop++].ival = arg2;
X    ops[mop++].ival = arg3;
X    ops[mop++].ival = arg4;
X    return retval;
X}
X
Xoper5(type,arg1,arg2,arg3,arg4,arg5)
Xint type;
Xint arg1;
Xint arg2;
Xint arg3;
Xint arg4;
Xint arg5;
X{
X    int retval = mop;
X
X    if (type > 255)
X        fatal("type > 255 (%d)\n",type);
X    ops[mop++].ival = type + (5<<8);
X    ops[mop++].ival = arg1;
X    ops[mop++].ival = arg2;
X    ops[mop++].ival = arg3;
X    ops[mop++].ival = arg4;
X    ops[mop++].ival = arg5;
X    return retval;
X}
X
Xint depth = 0;
X
Xdump(branch)
Xint branch;
X{
X    register int type;
X    register int len;
X    register int i;
X
X    type = ops[branch].ival;
X    len = type >> 8;
X    type &= 255;
X    for (i=depth; i; i--)
X        printf(" ");
X    if (type == OSTRING) {
X        printf("%-5d\"%s\"\n",branch,ops[branch+1].cval);
X    }
X    else {
X        printf("(%-5d%s %d\n",branch,opname[type],len);
X        depth++;
X        for (i=1; i<=len; i++)
X            dump(ops[branch+i].ival);
X        depth--;
X        for (i=depth; i; i--)
X            printf(" ");
X        printf(")\n");
X    }
X}
X
Xbl(arg,maybe)
Xint arg;
Xint maybe;
X{
X    if (!arg)
X        return 0;
X    else if ((ops[arg].ival & 255) != OBLOCK)
X        return oper2(OBLOCK,arg,maybe);
X    else if ((ops[arg].ival >> 8) != 2)
X        return oper2(OBLOCK,ops[arg+1].ival,maybe);
X    else
X        return arg;
X}
X
Xfixup(str)
XSTR *str;
X{
X    register char *s;
X    register char *t;
X
X    for (s = str->str_ptr; *s; s++) {
X        if (*s == ';' && s[1] == ' ' && s[2] == '\n') {
X            strcpy(s+1,s+2);
X            s++;
X        }
X        else if (*s == '\n') {
X            for (t = s+1; isspace(*t & 127); t++) ;
X            t--;
X            while (isspace(*t & 127) && *t != '\n') t--;
X            if (*t == '\n' && t-s > 1) {
X                if (s[-1] == '{')
X                    s--;
X                strcpy(s+1,t);
X            }
X            s++;
X        }
X    }
X}
X
Xputlines(str)
XSTR *str;
X{
X    register char *d, *s, *t, *e;
X    register int pos, newpos;
X
X    d = tokenbuf;
X    pos = 0;
X    for (s = str->str_ptr; *s; s++) {
X        *d++ = *s;
X        pos++;
X        if (*s == '\n') {
X            *d = '\0';
X            d = tokenbuf;
X            pos = 0;
X            putone();
X        }
X        else if (*s == '\t')
X            pos += 7;
X        if (pos > 78) {                /* split a long line? */
X            *d-- = '\0';
X            newpos = 0;
X            for (t = tokenbuf; isspace(*t & 127); t++) {
X                if (*t == '\t')
X                    newpos += 8;
X                else
X                    newpos += 1;
X            }
X            e = d;
X            while (d > tokenbuf && (*d != ' ' || d[-1] != ';'))
X                d--;
X            if (d < t+10) {
X                d = e;
X                while (d > tokenbuf &&
X                  (*d != ' ' || d[-1] != '|' || d[-2] != '|') )
X                    d--;
X            }
X            if (d < t+10) {
X                d = e;
X                while (d > tokenbuf &&
X                  (*d != ' ' || d[-1] != '&' || d[-2] != '&') )
X                    d--;
X            }
X            if (d < t+10) {
X                d = e;
X                while (d > tokenbuf && (*d != ' ' || d[-1] != ','))
X                    d--;
X            }
X            if (d < t+10) {
X                d = e;
X                while (d > tokenbuf && *d != ' ')
X                    d--;
X            }
X            if (d > t+3) {
X                *d = '\0';
X                putone();
X                putchar('\n');
X                if (d[-1] != ';' && !(newpos % 4)) {
X                    *t++ = ' ';
X                    *t++ = ' ';
X                    newpos += 2;
X                }
X                strcpy(t,d+1);
X                newpos += strlen(t);
X                d = t + strlen(t);
X                pos = newpos;
X            }
X            else
X                d = e + 1;
X        }
X    }
X}
X
Xputone()
X{
X    register char *t;
X
X    for (t = tokenbuf; *t; t++) {
X        *t &= 127;
X        if (*t == 127) {
X            *t = ' ';
X            strcpy(t+strlen(t)-1, "\t#???\n");
X        }
X    }
X    t = tokenbuf;
X    if (*t == '#') {
X        if (strnEQ(t,"#!/bin/awk",10) || strnEQ(t,"#! /bin/awk",11))
X            return;
X    }
X    fputs(tokenbuf,stdout);
X}
X
Xnumary(arg)
Xint arg;
X{
X    STR *key;
X    int dummy;
X
X    key = walk(0,0,arg,&dummy);
X    str_cat(key,"[]");
X    hstore(symtab,key->str_ptr,str_make("1"));
X    str_free(key);
X    set_array_base = TRUE;
X    return arg;
X}
!STUFFY!FUNK!
echo Extracting cmd.c
sed >cmd.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: cmd.c,v 1.0 87/12/18 13:04:51 root Exp $
X *
X * $Log:        cmd.c,v $
X * Revision 1.0  87/12/18  13:04:51  root
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
Xstatic STR str_chop;
X
X/* This is the main command loop.  We try to spend as much time in this loop
X * as possible, so lots of optimizations do their activities in here.  This
X * means things get a little sloppy.
X */
X
XSTR *
Xcmd_exec(cmd)
Xregister CMD *cmd;
X{
X    SPAT *oldspat;
X#ifdef DEBUGGING
X    int olddlevel;
X    int entdlevel;
X#endif
X    register STR *retstr;
X    register char *tmps;
X    register int cmdflags;
X    register bool match;
X    register char *go_to = goto_targ;
X    ARG *arg;
X    FILE *fp;
X
X    retstr = &str_no;
X#ifdef DEBUGGING
X    entdlevel = dlevel;
X#endif
Xtail_recursion_entry:
X#ifdef DEBUGGING
X    dlevel = entdlevel;
X#endif
X    if (cmd == Nullcmd)
X        return retstr;
X    cmdflags = cmd->c_flags;        /* hopefully load register */
X    if (go_to) {
X        if (cmd->c_label && strEQ(go_to,cmd->c_label))
X            goto_targ = go_to = Nullch;                /* here at last */
X        else {
X            switch (cmd->c_type) {
X            case C_IF:
X                oldspat = curspat;
X#ifdef DEBUGGING
X                olddlevel = dlevel;
X#endif
X                retstr = &str_yes;
X                if (cmd->ucmd.ccmd.cc_true) {
X#ifdef DEBUGGING
X                    debname[dlevel] = 't';
X                    debdelim[dlevel++] = '_';
X#endif
X                    retstr = cmd_exec(cmd->ucmd.ccmd.cc_true);
X                }
X                if (!goto_targ) {
X                    go_to = Nullch;
X                } else {
X                    retstr = &str_no;
X                    if (cmd->ucmd.ccmd.cc_alt) {
X#ifdef DEBUGGING
X                        debname[dlevel] = 'e';
X                        debdelim[dlevel++] = '_';
X#endif
X                        retstr = cmd_exec(cmd->ucmd.ccmd.cc_alt);
X                    }
X                }
X                if (!goto_targ)
X                    go_to = Nullch;
X                curspat = oldspat;
X#ifdef DEBUGGING
X                dlevel = olddlevel;
X#endif
X                break;
X            case C_BLOCK:
X            case C_WHILE:
X                if (!(cmdflags & CF_ONCE)) {
X                    cmdflags |= CF_ONCE;
X                    loop_ptr++;
X                    loop_stack[loop_ptr].loop_label = cmd->c_label;
X#ifdef DEBUGGING
X                    if (debug & 4) {
X                        deb("(Pushing label #%d %s)\n",
X                          loop_ptr,cmd->c_label);
X                    }
X#endif
X                }
X                switch (setjmp(loop_stack[loop_ptr].loop_env)) {
X                case O_LAST:        /* not done unless go_to found */
X                    go_to = Nullch;
X                    retstr = &str_no;
X#ifdef DEBUGGING
X                    olddlevel = dlevel;
X#endif
X                    curspat = oldspat;
X#ifdef DEBUGGING
X                    if (debug & 4) {
X                        deb("(Popping label #%d %s)\n",loop_ptr,
X                            loop_stack[loop_ptr].loop_label);
X                    }
X#endif
X                    loop_ptr--;
X                    cmd = cmd->c_next;
X                    goto tail_recursion_entry;
X                case O_NEXT:        /* not done unless go_to found */
X                    go_to = Nullch;
X                    goto next_iter;
X                case O_REDO:        /* not done unless go_to found */
X                    go_to = Nullch;
X                    goto doit;
X                }
X                oldspat = curspat;
X#ifdef DEBUGGING
X                olddlevel = dlevel;
X#endif
X                if (cmd->ucmd.ccmd.cc_true) {
X#ifdef DEBUGGING
X                    debname[dlevel] = 't';
X                    debdelim[dlevel++] = '_';
X#endif
X                    cmd_exec(cmd->ucmd.ccmd.cc_true);
X                }
X                if (!goto_targ) {
X                    go_to = Nullch;
X                    goto next_iter;
X                }
X#ifdef DEBUGGING
X                dlevel = olddlevel;
X#endif
X                if (cmd->ucmd.ccmd.cc_alt) {
X#ifdef DEBUGGING
X                    debname[dlevel] = 'a';
X                    debdelim[dlevel++] = '_';
X#endif
X                    cmd_exec(cmd->ucmd.ccmd.cc_alt);
X                }
X                if (goto_targ)
X                    break;
X                go_to = Nullch;
X                goto finish_while;
X            }
X            cmd = cmd->c_next;
X            if (cmd && cmd->c_head == cmd)        /* reached end of while loop */
X                return retstr;                /* targ isn't in this block */
X            goto tail_recursion_entry;
X        }
X    }
X
Xuntil_loop:
X
X#ifdef DEBUGGING
X    if (debug & 2) {
X        deb("%s        (%lx)        r%lx        t%lx        a%lx        n%lx        cs%lx\n",
X            cmdname[cmd->c_type],cmd,cmd->c_expr,
X            cmd->ucmd.ccmd.cc_true,cmd->ucmd.ccmd.cc_alt,cmd->c_next,curspat);
X    }
X    debname[dlevel] = cmdname[cmd->c_type][0];
X    debdelim[dlevel++] = '!';
X#endif
X    while (tmps_max >= 0)                /* clean up after last eval */
X        str_free(tmps_list[tmps_max--]);
X
X    /* Here is some common optimization */
X
X    if (cmdflags & CF_COND) {
X        switch (cmdflags & CF_OPTIMIZE) {
X
X        case CFT_FALSE:
X            retstr = cmd->c_first;
X            match = FALSE;
X            if (cmdflags & CF_NESURE)
X                goto maybe;
X            break;
X        case CFT_TRUE:
X            retstr = cmd->c_first;
X            match = TRUE;
X            if (cmdflags & CF_EQSURE)
X                goto flipmaybe;
X            break;
X
X        case CFT_REG:
X            retstr = STAB_STR(cmd->c_stab);
X            match = str_true(retstr);        /* => retstr = retstr, c2 should fix */
X            if (cmdflags & (match ? CF_EQSURE : CF_NESURE))
X                goto flipmaybe;
X            break;
X
X        case CFT_ANCHOR:        /* /^pat/ optimization */
X            if (multiline) {
X                if (*cmd->c_first->str_ptr && !(cmdflags & CF_EQSURE))
X                    goto scanner;        /* just unanchor it */
X                else
X                    break;                /* must evaluate */
X            }
X            /* FALL THROUGH */
X        case CFT_STROP:                /* string op optimization */
X            retstr = STAB_STR(cmd->c_stab);
X            if (*cmd->c_first->str_ptr == *str_get(retstr) &&
X                    strnEQ(cmd->c_first->str_ptr, str_get(retstr),
X                      cmd->c_flen) ) {
X                if (cmdflags & CF_EQSURE) {
X                    match = !(cmdflags & CF_FIRSTNEG);
X                    retstr = &str_yes;
X                    goto flipmaybe;
X                }
X            }
X            else if (cmdflags & CF_NESURE) {
X                match = cmdflags & CF_FIRSTNEG;
X                retstr = &str_no;
X                goto flipmaybe;
X            }
X            break;                        /* must evaluate */
X
X        case CFT_SCAN:                        /* non-anchored search */
X          scanner:
X            retstr = STAB_STR(cmd->c_stab);
X            if (instr(str_get(retstr),cmd->c_first->str_ptr)) {
X                if (cmdflags & CF_EQSURE) {
X                    match = !(cmdflags & CF_FIRSTNEG);
X                    retstr = &str_yes;
X                    goto flipmaybe;
X                }
X            }
X            else if (cmdflags & CF_NESURE) {
X                match = cmdflags & CF_FIRSTNEG;
X                retstr = &str_no;
X                goto flipmaybe;
X            }
X            break;                        /* must evaluate */
X
X        case CFT_GETS:                        /* really a while (<file>) */
X            last_in_stab = cmd->c_stab;
X            fp = last_in_stab->stab_io->fp;
X            retstr = defstab->stab_val;
X            if (fp && str_gets(retstr, fp)) {
X                last_in_stab->stab_io->lines++;
X                match = TRUE;
X            }
X            else if (last_in_stab->stab_io->flags & IOF_ARGV)
X                goto doeval;        /* doesn't necessarily count as EOF yet */
X            else {
X                retstr = &str_no;
X                match = FALSE;
X            }
X            goto flipmaybe;
X        case CFT_EVAL:
X            break;
X        case CFT_UNFLIP:
X            retstr = eval(cmd->c_expr,Null(char***));
X            match = str_true(retstr);
X            if (cmd->c_expr->arg_type == O_FLIP)        /* undid itself? */
X                cmdflags = copyopt(cmd,cmd->c_expr[3].arg_ptr.arg_cmd);
X            goto maybe;
X        case CFT_CHOP:
X            retstr = cmd->c_stab->stab_val;
X            match = (retstr->str_cur != 0);
X            tmps = str_get(retstr);
X            tmps += retstr->str_cur - match;
X            str_set(&str_chop,tmps);
X            *tmps = '\0';
X            retstr->str_nok = 0;
X            retstr->str_cur = tmps - retstr->str_ptr;
X            retstr = &str_chop;
X            goto flipmaybe;
X        }
X
X    /* we have tried to make this normal case as abnormal as possible */
X
X    doeval:
X        retstr = eval(cmd->c_expr,Null(char***));
X        match = str_true(retstr);
X        goto maybe;
X
X    /* if flipflop was true, flop it */
X
X    flipmaybe:
X        if (match && cmdflags & CF_FLIP) {
X            if (cmd->c_expr->arg_type == O_FLOP) {        /* currently toggled? */
X                retstr = eval(cmd->c_expr,Null(char***)); /* let eval undo it */
X                cmdflags = copyopt(cmd,cmd->c_expr[3].arg_ptr.arg_cmd);
X            }
X            else {
X                retstr = eval(cmd->c_expr,Null(char***)); /* let eval do it */
X                if (cmd->c_expr->arg_type == O_FLOP)        /* still toggled? */
X                    cmdflags = copyopt(cmd,cmd->c_expr[4].arg_ptr.arg_cmd);
X            }
X        }
X        else if (cmdflags & CF_FLIP) {
X            if (cmd->c_expr->arg_type == O_FLOP) {        /* currently toggled? */
X                match = TRUE;                                /* force on */
X            }
X        }
X
X    /* at this point, match says whether our expression was true */
X
X    maybe:
X        if (cmdflags & CF_INVERT)
X            match = !match;
X        if (!match && cmd->c_type != C_IF) {
X            cmd = cmd->c_next;
X            goto tail_recursion_entry;
X        }
X    }
X
X    /* now to do the actual command, if any */
X
X    switch (cmd->c_type) {
X    case C_NULL:
X        fatal("panic: cmd_exec\n");
X    case C_EXPR:                        /* evaluated for side effects */
X        if (cmd->ucmd.acmd.ac_expr) {        /* more to do? */
X            retstr = eval(cmd->ucmd.acmd.ac_expr,Null(char***));
X        }
X        break;
X    case C_IF:
X        oldspat = curspat;
X#ifdef DEBUGGING
X        olddlevel = dlevel;
X#endif
X        if (match) {
X            retstr = &str_yes;
X            if (cmd->ucmd.ccmd.cc_true) {
X#ifdef DEBUGGING
X                debname[dlevel] = 't';
X                debdelim[dlevel++] = '_';
X#endif
X                retstr = cmd_exec(cmd->ucmd.ccmd.cc_true);
X            }
X        }
X        else {
X            retstr = &str_no;
X            if (cmd->ucmd.ccmd.cc_alt) {
X#ifdef DEBUGGING
X                debname[dlevel] = 'e';
X                debdelim[dlevel++] = '_';
X#endif
X                retstr = cmd_exec(cmd->ucmd.ccmd.cc_alt);
X            }
X        }
X        curspat = oldspat;
X#ifdef DEBUGGING
X        dlevel = olddlevel;
X#endif
X        break;
X    case C_BLOCK:
X    case C_WHILE:
X        if (!(cmdflags & CF_ONCE)) {        /* first time through here? */
X            cmdflags |= CF_ONCE;
X            loop_ptr++;
X            loop_stack[loop_ptr].loop_label = cmd->c_label;
X#ifdef DEBUGGING
X            if (debug & 4) {
X                deb("(Pushing label #%d %s)\n",
X                  loop_ptr,cmd->c_label);
X            }
X#endif
X        }
X        switch (setjmp(loop_stack[loop_ptr].loop_env)) {
X        case O_LAST:
X            retstr = &str_no;
X            curspat = oldspat;
X#ifdef DEBUGGING
X            if (debug & 4) {
X                deb("(Popping label #%d %s)\n",loop_ptr,
X                    loop_stack[loop_ptr].loop_label);
X            }
X#endif
X            loop_ptr--;
X            cmd = cmd->c_next;
X            goto tail_recursion_entry;
X        case O_NEXT:
X            goto next_iter;
X        case O_REDO:
X            goto doit;
X        }
X        oldspat = curspat;
X#ifdef DEBUGGING
X        olddlevel = dlevel;
X#endif
X    doit:
X        if (cmd->ucmd.ccmd.cc_true) {
X#ifdef DEBUGGING
X            debname[dlevel] = 't';
X            debdelim[dlevel++] = '_';
X#endif
X            cmd_exec(cmd->ucmd.ccmd.cc_true);
X        }
X        /* actually, this spot is never reached anymore since the above
X         * cmd_exec() returns through longjmp().  Hooray for structure.
X         */
X      next_iter:
X#ifdef DEBUGGING
X        dlevel = olddlevel;
X#endif
X        if (cmd->ucmd.ccmd.cc_alt) {
X#ifdef DEBUGGING
X            debname[dlevel] = 'a';
X            debdelim[dlevel++] = '_';
X#endif
X            cmd_exec(cmd->ucmd.ccmd.cc_alt);
X        }
X      finish_while:
X        curspat = oldspat;
X#ifdef DEBUGGING
X        dlevel = olddlevel - 1;
X#endif
X        if (cmd->c_type != C_BLOCK)
X            goto until_loop;        /* go back and evaluate conditional again */
X    }
X    if (cmdflags & CF_LOOP) {
X        cmdflags |= CF_COND;                /* now test the condition */
X        goto until_loop;
X    }
X    cmd = cmd->c_next;
X    goto tail_recursion_entry;
X}
X
X#ifdef DEBUGGING
X/*VARARGS1*/
Xdeb(pat,a1,a2,a3,a4,a5,a6,a7,a8)
Xchar *pat;
X{
X    register int i;
X
X    for (i=0; i<dlevel; i++)
X        fprintf(stderr,"%c%c ",debname[i],debdelim[i]);
X    fprintf(stderr,pat,a1,a2,a3,a4,a5,a6,a7,a8);
X}
X#endif
X
Xcopyopt(cmd,which)
Xregister CMD *cmd;
Xregister CMD *which;
X{
X    cmd->c_flags &= CF_ONCE|CF_COND|CF_LOOP;
X    cmd->c_flags |= which->c_flags;
X    cmd->c_first = which->c_first;
X    cmd->c_flen = which->c_flen;
X    cmd->c_stab = which->c_stab;
X    return cmd->c_flags;
X}
!STUFFY!FUNK!
echo Extracting x2p/str.c
sed >x2p/str.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: str.c,v 1.0 87/12/18 13:07:26 root Exp $
X *
X * $Log:        str.c,v $
X * Revision 1.0  87/12/18  13:07:26  root
X * Initial revision
X * 
X */
X
X#include "handy.h"
X#include "EXTERN.h"
X#include "util.h"
X#include "a2p.h"
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
X    register char newline = '\n';        /* (assuming at least 6 registers) */
X    int i;
X    int bpx;
X
X    cnt = fp->_cnt;                        /* get count into register */
X    str->str_nok = 0;                        /* invalidate number */
X    str->str_pok = 1;                        /* validate pointer */
X    if (str->str_len <= cnt)                /* make sure we have the room */
X        GROWSTR(&(str->str_ptr), &(str->str_len), cnt+1);
X    bp = str->str_ptr;                        /* move these two too to registers */
X    ptr = fp->_ptr;
X    for (;;) {
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
X        GROWSTR(&(str->str_ptr), &(str->str_len), str->str_cur + cnt + 1);
X        bp = str->str_ptr + bpx;        /* reconstitute our pointer */
X
X        if (i == newline) {                /* all done for now? */
X            *bp++ = i;
X            goto thats_all_folks;
X        }
X        else if (i == EOF)                /* all done for ever? */
X            goto thats_all_folks;
X        *bp++ = i;                        /* now go back to screaming loop */
X    }
X
Xthats_all_folks:
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
echo Extracting malloc.c
sed >malloc.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: malloc.c,v 1.0 87/12/18 13:05:35 root Exp $
X *
X * $Log:        malloc.c,v $
X * Revision 1.0  87/12/18  13:05:35  root
X * Initial revision
X * 
X */
X
X#ifndef lint
Xstatic char sccsid[] = "@(#)malloc.c        4.3 (Berkeley) 9/16/83";
X#endif
X#include <stdio.h>
X
X#define RCHECK
X/*
X * malloc.c (Caltech) 2/21/82
X * Chris Kingsley, kingsley@cit-20.
X *
X * This is a very fast storage allocator.  It allocates blocks of a small 
X * number of different sizes, and keeps free lists of each size.  Blocks that
X * don't exactly fit are passed up to the next larger size.  In this 
X * implementation, the available sizes are 2^n-4 (or 2^n-12) bytes long.
X * This is designed for use in a program that uses vast quantities of memory,
X * but bombs when it runs out. 
X */
X
X#include <sys/types.h>
X
X#define        NULL 0
X
X/*
X * The overhead on a block is at least 4 bytes.  When free, this space
X * contains a pointer to the next free block, and the bottom two bits must
X * be zero.  When in use, the first byte is set to MAGIC, and the second
X * byte is the size index.  The remaining bytes are for alignment.
X * If range checking is enabled and the size of the block fits
X * in two bytes, then the top two bytes hold the size of the requested block
X * plus the range checking words, and the header word MINUS ONE.
X */
Xunion        overhead {
X        union        overhead *ov_next;        /* when free */
X        struct {
X                u_char        ovu_magic;        /* magic number */
X                u_char        ovu_index;        /* bucket # */
X#ifdef RCHECK
X                u_short        ovu_size;        /* actual block size */
X                u_int        ovu_rmagic;        /* range magic number */
X#endif
X        } ovu;
X#define        ov_magic        ovu.ovu_magic
X#define        ov_index        ovu.ovu_index
X#define        ov_size                ovu.ovu_size
X#define        ov_rmagic        ovu.ovu_rmagic
X};
X
X#define        MAGIC                0xff                /* magic # on accounting info */
X#define RMAGIC                0x55555555        /* magic # on range info */
X#ifdef RCHECK
X#define        RSLOP                sizeof (u_int)
X#else
X#define        RSLOP                0
X#endif
X
X/*
X * nextf[i] is the pointer to the next free block of size 2^(i+3).  The
X * smallest allocatable block is 8 bytes.  The overhead information
X * precedes the data area returned to the user.
X */
X#define        NBUCKETS 30
Xstatic        union overhead *nextf[NBUCKETS];
Xextern        char *sbrk();
X
X#ifdef MSTATS
X/*
X * nmalloc[i] is the difference between the number of mallocs and frees
X * for a given block size.
X */
Xstatic        u_int nmalloc[NBUCKETS];
X#include <stdio.h>
X#endif
X
X#ifdef debug
X#define        ASSERT(p)   if (!(p)) botch("p"); else
Xstatic
Xbotch(s)
X        char *s;
X{
X
X        printf("assertion botched: %s\n", s);
X        abort();
X}
X#else
X#define        ASSERT(p)
X#endif
X
Xchar *
Xmalloc(nbytes)
X        register unsigned nbytes;
X{
X          register union overhead *p;
X          register int bucket = 0;
X          register unsigned shiftr;
X
X        /*
X         * Convert amount of memory requested into
X         * closest block size stored in hash buckets
X         * which satisfies request.  Account for
X         * space used per block for accounting.
X         */
X          nbytes += sizeof (union overhead) + RSLOP;
X          nbytes = (nbytes + 3) &~ 3; 
X          shiftr = (nbytes - 1) >> 2;
X        /* apart from this loop, this is O(1) */
X          while (shiftr >>= 1)
X                  bucket++;
X        /*
X         * If nothing in hash bucket right now,
X         * request more memory from the system.
X         */
X          if (nextf[bucket] == NULL)    
X                  morecore(bucket);
X          if ((p = (union overhead *)nextf[bucket]) == NULL)
X                  return (NULL);
X        /* remove from linked list */
X        if (*((int*)p) > 0x10000000)
X            fprintf(stderr,"Corrupt malloc ptr 0x%x at 0x%x\n",*((int*)p),p);
X          nextf[bucket] = nextf[bucket]->ov_next;
X        p->ov_magic = MAGIC;
X        p->ov_index= bucket;
X#ifdef MSTATS
X          nmalloc[bucket]++;
X#endif
X#ifdef RCHECK
X        /*
X         * Record allocated size of block and
X         * bound space with magic numbers.
X         */
X          if (nbytes <= 0x10000)
X                p->ov_size = nbytes - 1;
X        p->ov_rmagic = RMAGIC;
X          *((u_int *)((caddr_t)p + nbytes - RSLOP)) = RMAGIC;
X#endif
X          return ((char *)(p + 1));
X}
X
X/*
X * Allocate more memory to the indicated bucket.
X */
Xstatic
Xmorecore(bucket)
X        register bucket;
X{
X          register union overhead *op;
X          register int rnu;       /* 2^rnu bytes will be requested */
X          register int nblks;     /* become nblks blocks of the desired size */
X        register int siz;
X
X          if (nextf[bucket])
X                  return;
X        /*
X         * Insure memory is allocated
X         * on a page boundary.  Should
X         * make getpageize call?
X         */
X          op = (union overhead *)sbrk(0);
X          if ((int)op & 0x3ff)
X                  sbrk(1024 - ((int)op & 0x3ff));
X        /* take 2k unless the block is bigger than that */
X          rnu = (bucket <= 8) ? 11 : bucket + 3;
X          nblks = 1 << (rnu - (bucket + 3));  /* how many blocks to get */
X          if (rnu < bucket)
X                rnu = bucket;
X        op = (union overhead *)sbrk(1 << rnu);
X        /* no more room! */
X          if ((int)op == -1)
X                  return;
X        /*
X         * Round up to minimum allocation size boundary
X         * and deduct from block count to reflect.
X         */
X          if ((int)op & 7) {
X                  op = (union overhead *)(((int)op + 8) &~ 7);
X                  nblks--;
X          }
X        /*
X         * Add new memory allocated to that on
X         * free list for this hash bucket.
X         */
X          nextf[bucket] = op;
X          siz = 1 << (bucket + 3);
X          while (--nblks > 0) {
X                op->ov_next = (union overhead *)((caddr_t)op + siz);
X                op = (union overhead *)((caddr_t)op + siz);
X          }
X}
X
Xfree(cp)
X        char *cp;
X{   
X          register int size;
X        register union overhead *op;
X
X          if (cp == NULL)
X                  return;
X        op = (union overhead *)((caddr_t)cp - sizeof (union overhead));
X#ifdef debug
X          ASSERT(op->ov_magic == MAGIC);                /* make sure it was in use */
X#else
X        if (op->ov_magic != MAGIC)
X                return;                                /* sanity */
X#endif
X#ifdef RCHECK
X          ASSERT(op->ov_rmagic == RMAGIC);
X        if (op->ov_index <= 13)
X                ASSERT(*(u_int *)((caddr_t)op + op->ov_size + 1 - RSLOP) == RMAGIC);
X#endif
X          ASSERT(op->ov_index < NBUCKETS);
X          size = op->ov_index;
X        op->ov_next = nextf[size];
X          nextf[size] = op;
X#ifdef MSTATS
X          nmalloc[size]--;
X#endif
X}
X
X/*
X * When a program attempts "storage compaction" as mentioned in the
X * old malloc man page, it realloc's an already freed block.  Usually
X * this is the last block it freed; occasionally it might be farther
X * back.  We have to search all the free lists for the block in order
X * to determine its bucket: 1st we make one pass thru the lists
X * checking only the first block in each; if that fails we search
X * ``realloc_srchlen'' blocks in each list for a match (the variable
X * is extern so the caller can modify it).  If that fails we just copy
X * however many bytes was given to realloc() and hope it's not huge.
X */
Xint realloc_srchlen = 4;        /* 4 should be plenty, -1 =>'s whole list */
X
Xchar *
Xrealloc(cp, nbytes)
X        char *cp; 
X        unsigned nbytes;
X{   
X          register u_int onb;
X        union overhead *op;
X          char *res;
X        register int i;
X        int was_alloced = 0;
X
X          if (cp == NULL)
X                  return (malloc(nbytes));
X        op = (union overhead *)((caddr_t)cp - sizeof (union overhead));
X        if (op->ov_magic == MAGIC) {
X                was_alloced++;
X                i = op->ov_index;
X        } else {
X                /*
X                 * Already free, doing "compaction".
X                 *
X                 * Search for the old block of memory on the
X                 * free list.  First, check the most common
X                 * case (last element free'd), then (this failing)
X                 * the last ``realloc_srchlen'' items free'd.
X                 * If all lookups fail, then assume the size of
X                 * the memory block being realloc'd is the
X                 * smallest possible.
X                 */
X                if ((i = findbucket(op, 1)) < 0 &&
X                    (i = findbucket(op, realloc_srchlen)) < 0)
X                        i = 0;
X        }
X        onb = (1 << (i + 3)) - sizeof (*op) - RSLOP;
X        /* avoid the copy if same size block */
X        if (was_alloced &&
X            nbytes <= onb && nbytes > (onb >> 1) - sizeof(*op) - RSLOP)
X                return(cp);
X          if ((res = malloc(nbytes)) == NULL)
X                  return (NULL);
X          if (cp != res)                        /* common optimization */
X                bcopy(cp, res, (nbytes < onb) ? nbytes : onb);
X          if (was_alloced)
X                free(cp);
X          return (res);
X}
X
X/*
X * Search ``srchlen'' elements of each free list for a block whose
X * header starts at ``freep''.  If srchlen is -1 search the whole list.
X * Return bucket number, or -1 if not found.
X */
Xstatic
Xfindbucket(freep, srchlen)
X        union overhead *freep;
X        int srchlen;
X{
X        register union overhead *p;
X        register int i, j;
X
X        for (i = 0; i < NBUCKETS; i++) {
X                j = 0;
X                for (p = nextf[i]; p && j != srchlen; p = p->ov_next) {
X                        if (p == freep)
X                                return (i);
X                        j++;
X                }
X        }
X        return (-1);
X}
X
X#ifdef MSTATS
X/*
X * mstats - print out statistics about malloc
X * 
X * Prints two lines of numbers, one showing the length of the free list
X * for each size category, the second showing the number of mallocs -
X * frees for each size category.
X */
Xmstats(s)
X        char *s;
X{
X          register int i, j;
X          register union overhead *p;
X          int totfree = 0,
X          totused = 0;
X
X          fprintf(stderr, "Memory allocation statistics %s\nfree:\t", s);
X          for (i = 0; i < NBUCKETS; i++) {
X                  for (j = 0, p = nextf[i]; p; p = p->ov_next, j++)
X                          ;
X                  fprintf(stderr, " %d", j);
X                  totfree += j * (1 << (i + 3));
X          }
X          fprintf(stderr, "\nused:\t");
X          for (i = 0; i < NBUCKETS; i++) {
X                  fprintf(stderr, " %d", nmalloc[i]);
X                  totused += nmalloc[i] * (1 << (i + 3));
X          }
X          fprintf(stderr, "\n\tTotal in use: %d, total free: %d\n",
X            totused, totfree);
X}
X#endif
!STUFFY!FUNK!
echo Extracting t/cmd.while
sed >t/cmd.while <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: cmd.while,v 1.0 87/12/18 13:12:15 root Exp $
X
Xprint "1..10\n";
X
Xopen (tmp,'>Cmd.while.tmp') || die "Can't create Cmd.while.tmp.";
Xprint tmp "tvi925\n";
Xprint tmp "tvi920\n";
Xprint tmp "vt100\n";
Xprint tmp "Amiga\n";
Xprint tmp "paper\n";
Xclose tmp;
X
X# test "last" command
X
Xopen(fh,'Cmd.while.tmp') || die "Can't open Cmd.while.tmp.";
Xwhile (<fh>) {
X    last if /vt100/;
X}
Xif (!eof && /vt100/) {print "ok 1\n";} else {print "not ok 1\n";}
X
X# test "next" command
X
X$bad = '';
Xopen(fh,'Cmd.while.tmp') || die "Can't open Cmd.while.tmp.";
Xwhile (<fh>) {
X    next if /vt100/;
X    $bad = 1 if /vt100/;
X}
Xif (!eof || /vt100/ || $bad) {print "not ok 2\n";} else {print "ok 2\n";}
X
X# test "redo" command
X
X$bad = '';
Xopen(fh,'Cmd.while.tmp') || die "Can't open Cmd.while.tmp.";
Xwhile (<fh>) {
X    if (s/vt100/VT100/g) {
X        s/VT100/Vt100/g;
X        redo;
X    }
X    $bad = 1 if /vt100/;
X    $bad = 1 if /VT100/;
X}
Xif (!eof || $bad) {print "not ok 3\n";} else {print "ok 3\n";}
X
X# now do the same with a label and a continue block
X
X# test "last" command
X
X$badcont = '';
Xopen(fh,'Cmd.while.tmp') || die "Can't open Cmd.while.tmp.";
Xline: while (<fh>) {
X    if (/vt100/) {last line;}
X} continue {
X    $badcont = 1 if /vt100/;
X}
Xif (!eof && /vt100/) {print "ok 4\n";} else {print "not ok 4\n";}
Xif (!$badcont) {print "ok 5\n";} else {print "not ok 5\n";}
X
X# test "next" command
X
X$bad = '';
X$badcont = 1;
Xopen(fh,'Cmd.while.tmp') || die "Can't open Cmd.while.tmp.";
Xentry: while (<fh>) {
X    next entry if /vt100/;
X    $bad = 1 if /vt100/;
X} continue {
X    $badcont = '' if /vt100/;
X}
Xif (!eof || /vt100/ || $bad) {print "not ok 6\n";} else {print "ok 6\n";}
Xif (!$badcont) {print "ok 7\n";} else {print "not ok 7\n";}
X
X# test "redo" command
X
X$bad = '';
X$badcont = '';
Xopen(fh,'Cmd.while.tmp') || die "Can't open Cmd.while.tmp.";
Xloop: while (<fh>) {
X    if (s/vt100/VT100/g) {
X        s/VT100/Vt100/g;
X        redo loop;
X    }
X    $bad = 1 if /vt100/;
X    $bad = 1 if /VT100/;
X} continue {
X    $badcont = 1 if /vt100/;
X}
Xif (!eof || $bad) {print "not ok 8\n";} else {print "ok 8\n";}
Xif (!$badcont) {print "ok 9\n";} else {print "not ok 9\n";}
X
X`/bin/rm -f Cmd.while.tmp`;
X
X#$x = 0;
X#while (1) {
X#    if ($x > 1) {last;}
X#    next;
X#} continue {
X#    if ($x++ > 10) {last;}
X#    next;
X#}
X#
X#if ($x < 10) {print "ok 10\n";} else {print "not ok 10\n";}
X
X$i = 9;
X{
X    $i++;
X}
Xprint "ok $i\n";
!STUFFY!FUNK!
echo Extracting t/op.push
sed >t/op.push <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.push,v 1.0 87/12/18 13:14:10 root Exp $
X
Xprint "1..2\n";
X
X@x = (1,2,3);
Xpush(@x,@x);
Xif (join(x,':') eq '1:2:3:1:2:3') {print "ok 1\n";} else {print "not ok 1\n";}
Xpush(x,4);
Xif (join(x,':') eq '1:2:3:1:2:3:4') {print "ok 2\n";} else {print "not ok 2\n";}
!STUFFY!FUNK!
echo ""
echo "End of kit 7 (of 10)"
cat /dev/null >kit7isdone
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