#! /bin/sh

# Make a new directory for the perl sources, cd to it, and run kits 1
# thru 10 through sh.  When all 10 kits have been run, read README.

echo "This is perl 1.0 kit 2 (of 10).  If kit 2 is complete, the line"
echo '"'"End of kit 2 (of 10)"'" will echo at the end.'
echo ""
export PATH || (echo "You didn't use sh, you clunch." ; kill $$)
echo Extracting perly.c
sed >perly.c <<'!STUFFY!FUNK!' -e 's/X//'
Xchar rcsid[] = "$Header: perly.c,v 1.0 87/12/18 15:53:31 root Exp $";
X/*
X * $Log:        perly.c,v $
X * Revision 1.0  87/12/18  15:53:31  root
X * Initial revision
X * 
X */
X
Xbool preprocess = FALSE;
Xbool assume_n = FALSE;
Xbool assume_p = FALSE;
Xbool doswitches = FALSE;
Xchar *filename;
Xchar *e_tmpname = "/tmp/perl-eXXXXXX";
XFILE *e_fp = Nullfp;
XARG *l();
X
Xmain(argc,argv,env)
Xregister int argc;
Xregister char **argv;
Xregister char **env;
X{
X    register STR *str;
X    register char *s;
X    char *index();
X
X    linestr = str_new(80);
X    str = str_make("-I/usr/lib/perl ");        /* first used for -I flags */
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
X        case 'e':
X            if (!e_fp) {
X                mktemp(e_tmpname);
X                e_fp = fopen(e_tmpname,"w");
X            }
X            if (argv[1])
X                fputs(argv[1],e_fp);
X            putc('\n', e_fp);
X            argc--,argv++;
X            break;
X        case 'i':
X            inplace = savestr(argv[0]+2);
X            argvoutstab = stabent("ARGVOUT",TRUE);
X            break;
X        case 'I':
X            str_cat(str,argv[0]);
X            str_cat(str," ");
X            if (!argv[0][2]) {
X                str_cat(str,argv[1]);
X                argc--,argv++;
X                str_cat(str," ");
X            }
X            break;
X        case 'n':
X            assume_n = TRUE;
X            strcpy(argv[0], argv[0]+1);
X            goto reswitch;
X        case 'p':
X            assume_p = TRUE;
X            strcpy(argv[0], argv[0]+1);
X            goto reswitch;
X        case 'P':
X            preprocess = TRUE;
X            strcpy(argv[0], argv[0]+1);
X            goto reswitch;
X        case 's':
X            doswitches = TRUE;
X            strcpy(argv[0], argv[0]+1);
X            goto reswitch;
X        case 'v':
X            version();
X            exit(0);
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
X    if (e_fp) {
X        fclose(e_fp);
X        argc++,argv--;
X        argv[0] = e_tmpname;
X    }
X
X    str_set(&str_no,No);
X    str_set(&str_yes,Yes);
X    init_eval();
X
X    /* open script */
X
X    if (argv[0] == Nullch)
X        argv[0] = "-";
X    filename = savestr(argv[0]);
X    if (strEQ(filename,"-"))
X        argv[0] = "";
X    if (preprocess) {
X        sprintf(buf, "\
X/bin/sed -e '/^[^#]/b' \
X -e '/^#[         ]*include[         ]/b' \
X -e '/^#[         ]*define[         ]/b' \
X -e '/^#[         ]*if[         ]/b' \
X -e '/^#[         ]*ifdef[         ]/b' \
X -e '/^#[         ]*else/b' \
X -e '/^#[         ]*endif/b' \
X -e 's/^#.*//' \
X %s | /lib/cpp -C %s-",
X          argv[0], str_get(str));
X        rsfp = popen(buf,"r");
X    }
X    else if (!*argv[0])
X        rsfp = stdin;
X    else
X        rsfp = fopen(argv[0],"r");
X    if (rsfp == Nullfp)
X        fatal("Perl script \"%s\" doesn't seem to exist.\n",filename);
X    str_free(str);                /* free -I directories */
X
X    defstab = stabent("_",TRUE);
X
X    /* init tokener */
X
X    bufptr = str_get(linestr);
X
X    /* now parse the report spec */
X
X    if (yyparse())
X        fatal("Execution aborted due to compilation errors.\n");
X
X    if (e_fp) {
X        e_fp = Nullfp;
X        UNLINK(e_tmpname);
X    }
X    argc--,argv++;        /* skip name of script */
X    if (doswitches) {
X        for (; argc > 0 && **argv == '-'; argc--,argv++) {
X            if (argv[0][1] == '-') {
X                argc--,argv++;
X                break;
X            }
X            str_numset(stabent(argv[0]+1,TRUE)->stab_val,(double)1.0);
X        }
X    }
X    if (argvstab = stabent("ARGV",FALSE)) {
X        for (; argc > 0; argc--,argv++) {
X            apush(argvstab->stab_array,str_make(argv[0]));
X        }
X    }
X    if (envstab = stabent("ENV",FALSE)) {
X        for (; *env; env++) {
X            if (!(s = index(*env,'=')))
X                continue;
X            *s++ = '\0';
X            str = str_make(s);
X            str->str_link.str_magic = envstab;
X            hstore(envstab->stab_hash,*env,str);
X            *--s = '=';
X        }
X    }
X    sigstab = stabent("SIG",FALSE);
X
X    magicalize("!#?^~=-%0123456789.+&*(),\\/[|");
X
X    (tmpstab = stabent("0",FALSE)) && str_set(STAB_STR(tmpstab),filename);
X    (tmpstab = stabent("$",FALSE)) &&
X        str_numset(STAB_STR(tmpstab),(double)getpid());
X
X    tmpstab = stabent("stdin",TRUE);
X    tmpstab->stab_io = stio_new();
X    tmpstab->stab_io->fp = stdin;
X
X    tmpstab = stabent("stdout",TRUE);
X    tmpstab->stab_io = stio_new();
X    tmpstab->stab_io->fp = stdout;
X    defoutstab = tmpstab;
X    curoutstab = tmpstab;
X
X    tmpstab = stabent("stderr",TRUE);
X    tmpstab->stab_io = stio_new();
X    tmpstab->stab_io->fp = stderr;
X
X    setjmp(top_env);        /* sets goto_targ on longjump */
X
X#ifdef DEBUGGING
X    if (debug & 1024)
X        dump_cmd(main_root,Nullcmd);
X    if (debug)
X        fprintf(stderr,"\nEXECUTING...\n\n");
X#endif
X
X    /* do it */
X
X    (void) cmd_exec(main_root);
X
X    if (goto_targ)
X        fatal("Can't find label \"%s\"--aborting.\n",goto_targ);
X    exit(0);
X}
X
Xmagicalize(list)
Xregister char *list;
X{
X    register STAB *stab;
X    char sym[2];
X
X    sym[1] = '\0';
X    while (*sym = *list++) {
X        if (stab = stabent(sym,FALSE)) {
X            stab->stab_flags = SF_VMAGIC;
X            stab->stab_val->str_link.str_magic = stab;
X        }
X    }
X}
X
X#define RETURN(retval) return (bufptr = s,retval)
X#define OPERATOR(retval) return (expectterm = TRUE,bufptr = s,retval)
X#define TERM(retval) return (expectterm = FALSE,bufptr = s,retval)
X#define LOOPX(f) return (yylval.ival = f,expectterm = FALSE,bufptr = s,LOOPEX)
X#define UNI(f) return (yylval.ival = f,expectterm = TRUE,bufptr = s,UNIOP)
X#define FUN0(f) return (yylval.ival = f,expectterm = FALSE,bufptr = s,FUNC0)
X#define FUN1(f) return (yylval.ival = f,expectterm = FALSE,bufptr = s,FUNC1)
X#define FUN2(f) return (yylval.ival = f,expectterm = FALSE,bufptr = s,FUNC2)
X#define FUN3(f) return (yylval.ival = f,expectterm = FALSE,bufptr = s,FUNC3)
X#define SFUN(f) return (yylval.ival = f,expectterm = FALSE,bufptr = s,STABFUN)
X
Xyylex()
X{
X    register char *s = bufptr;
X    register char *d;
X    register int tmp;
X    static bool in_format = FALSE;
X    static bool firstline = TRUE;
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
X    case 0:
X        s = str_get(linestr);
X        *s = '\0';
X        if (firstline && (assume_n || assume_p)) {
X            firstline = FALSE;
X            str_set(linestr,"while (<>) {");
X            s = str_get(linestr);
X            goto retry;
X        }
X        if (!rsfp)
X            RETURN(0);
X        if (in_format) {
X            yylval.formval = load_format();        /* leaves . in buffer */
X            in_format = FALSE;
X            s = str_get(linestr);
X            TERM(FORMLIST);
X        }
X        line++;
X        if ((s = str_gets(linestr, rsfp)) == Nullch) {
X            if (preprocess)
X                pclose(rsfp);
X            else if (rsfp != stdin)
X                fclose(rsfp);
X            rsfp = Nullfp;
X            if (assume_n || assume_p) {
X                str_set(linestr,assume_p ? "}continue{print;" : "");
X                str_cat(linestr,"}");
X                s = str_get(linestr);
X                goto retry;
X            }
X            s = str_get(linestr);
X            RETURN(0);
X        }
X#ifdef DEBUG
X        else if (firstline) {
X            char *showinput();
X            s = showinput();
X        }
X#endif
X        firstline = FALSE;
X        goto retry;
X    case ' ': case '\t':
X        s++;
X        goto retry;
X    case '\n':
X    case '#':
X        if (preprocess && s == str_get(linestr) &&
X               s[1] == ' ' && isdigit(s[2])) {
X            line = atoi(s+2)-1;
X            for (s += 2; isdigit(*s); s++) ;
X            while (*s && isspace(*s)) s++;
X            if (filename)
X                safefree(filename);
X            s[strlen(s)-1] = '\0';        /* wipe out newline */
X            filename = savestr(s);
X            s = str_get(linestr);
X        }
X        *s = '\0';
X        if (lex_newlines)
X            RETURN('\n');
X        goto retry;
X    case '+':
X    case '-':
X        if (s[1] == *s) {
X            s++;
X            if (*s++ == '+')
X                RETURN(INC);
X            else
X                RETURN(DEC);
X        }
X        /* FALL THROUGH */
X    case '*':
X    case '%':
X    case '^':
X    case '~':
X    case '(':
X    case ',':
X    case ':':
X    case ';':
X    case '{':
X    case '[':
X        tmp = *s++;
X        OPERATOR(tmp);
X    case ')':
X    case ']':
X    case '}':
X        tmp = *s++;
X        TERM(tmp);
X    case '&':
X        s++;
X        tmp = *s++;
X        if (tmp == '&')
X            OPERATOR(ANDAND);
X        s--;
X        OPERATOR('&');
X    case '|':
X        s++;
X        tmp = *s++;
X        if (tmp == '|')
X            OPERATOR(OROR);
X        s--;
X        OPERATOR('|');
X    case '=':
X        s++;
X        tmp = *s++;
X        if (tmp == '=')
X            OPERATOR(EQ);
X        if (tmp == '~')
X            OPERATOR(MATCH);
X        s--;
X        OPERATOR('=');
X    case '!':
X        s++;
X        tmp = *s++;
X        if (tmp == '=')
X            OPERATOR(NE);
X        if (tmp == '~')
X            OPERATOR(NMATCH);
X        s--;
X        OPERATOR('!');
X    case '<':
X        if (expectterm) {
X            s = scanstr(s);
X            TERM(RSTRING);
X        }
X        s++;
X        tmp = *s++;
X        if (tmp == '<')
X            OPERATOR(LS);
X        if (tmp == '=')
X            OPERATOR(LE);
X        s--;
X        OPERATOR('<');
X    case '>':
X        s++;
X        tmp = *s++;
X        if (tmp == '>')
X            OPERATOR(RS);
X        if (tmp == '=')
X            OPERATOR(GE);
X        s--;
X        OPERATOR('>');
X
X#define SNARFWORD \
X        d = tokenbuf; \
X        while (isalpha(*s) || isdigit(*s) || *s == '_') \
X            *d++ = *s++; \
X        *d = '\0'; \
X        d = tokenbuf;
X
X    case '$':
X        if (s[1] == '#' && (isalpha(s[2]) || s[2] == '_')) {
X            s++;
X            s = scanreg(s,tokenbuf);
X            yylval.stabval = aadd(stabent(tokenbuf,TRUE));
X            TERM(ARYLEN);
X        }
X        s = scanreg(s,tokenbuf);
X        yylval.stabval = stabent(tokenbuf,TRUE);
X        TERM(REG);
X
X    case '@':
X        s = scanreg(s,tokenbuf);
X        yylval.stabval = aadd(stabent(tokenbuf,TRUE));
X        TERM(ARY);
X
X    case '/':                        /* may either be division or pattern */
X    case '?':                        /* may either be conditional or pattern */
X        if (expectterm) {
X            s = scanpat(s);
X            TERM(PATTERN);
X        }
X        tmp = *s++;
X        OPERATOR(tmp);
X
X    case '.':
X        if (!expectterm || !isdigit(s[1])) {
X            s++;
X            tmp = *s++;
X            if (tmp == '.')
X                OPERATOR(DOTDOT);
X            s--;
X            OPERATOR('.');
X        }
X        /* FALL THROUGH */
X    case '0': case '1': case '2': case '3': case '4':
X    case '5': case '6': case '7': case '8': case '9':
X    case '\'': case '"': case '`':
X        s = scanstr(s);
X        TERM(RSTRING);
X
X    case '_':
X        SNARFWORD;
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'a': case 'A':
X        SNARFWORD;
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'b': case 'B':
X        SNARFWORD;
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'c': case 'C':
X        SNARFWORD;
X        if (strEQ(d,"continue"))
X            OPERATOR(CONTINUE);
X        if (strEQ(d,"chdir"))
X            UNI(O_CHDIR);
X        if (strEQ(d,"close"))
X            OPERATOR(CLOSE);
X        if (strEQ(d,"crypt"))
X            FUN2(O_CRYPT);
X        if (strEQ(d,"chop"))
X            OPERATOR(CHOP);
X        if (strEQ(d,"chmod")) {
X            yylval.ival = O_CHMOD;
X            OPERATOR(PRINT);
X        }
X        if (strEQ(d,"chown")) {
X            yylval.ival = O_CHOWN;
X            OPERATOR(PRINT);
X        }
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'd': case 'D':
X        SNARFWORD;
X        if (strEQ(d,"do"))
X            OPERATOR(DO);
X        if (strEQ(d,"die"))
X            UNI(O_DIE);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'e': case 'E':
X        SNARFWORD;
X        if (strEQ(d,"else"))
X            OPERATOR(ELSE);
X        if (strEQ(d,"elsif"))
X            OPERATOR(ELSIF);
X        if (strEQ(d,"eq") || strEQ(d,"EQ"))
X            OPERATOR(SEQ);
X        if (strEQ(d,"exit"))
X            UNI(O_EXIT);
X        if (strEQ(d,"eof"))
X            TERM(FEOF);
X        if (strEQ(d,"exp"))
X            FUN1(O_EXP);
X        if (strEQ(d,"each"))
X            SFUN(O_EACH);
X        if (strEQ(d,"exec")) {
X            yylval.ival = O_EXEC;
X            OPERATOR(PRINT);
X        }
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'f': case 'F':
X        SNARFWORD;
X        if (strEQ(d,"for"))
X            OPERATOR(FOR);
X        if (strEQ(d,"format")) {
X            in_format = TRUE;
X            OPERATOR(FORMAT);
X        }
X        if (strEQ(d,"fork"))
X            FUN0(O_FORK);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'g': case 'G':
X        SNARFWORD;
X        if (strEQ(d,"gt") || strEQ(d,"GT"))
X            OPERATOR(SGT);
X        if (strEQ(d,"ge") || strEQ(d,"GE"))
X            OPERATOR(SGE);
X        if (strEQ(d,"goto"))
X            LOOPX(O_GOTO);
X        if (strEQ(d,"gmtime"))
X            FUN1(O_GMTIME);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'h': case 'H':
X        SNARFWORD;
X        if (strEQ(d,"hex"))
X            FUN1(O_HEX);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'i': case 'I':
X        SNARFWORD;
X        if (strEQ(d,"if"))
X            OPERATOR(IF);
X        if (strEQ(d,"index"))
X            FUN2(O_INDEX);
X        if (strEQ(d,"int"))
X            FUN1(O_INT);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'j': case 'J':
X        SNARFWORD;
X        if (strEQ(d,"join"))
X            OPERATOR(JOIN);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'k': case 'K':
X        SNARFWORD;
X        if (strEQ(d,"keys"))
X            SFUN(O_KEYS);
X        if (strEQ(d,"kill")) {
X            yylval.ival = O_KILL;
X            OPERATOR(PRINT);
X        }
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'l': case 'L':
X        SNARFWORD;
X        if (strEQ(d,"last"))
X            LOOPX(O_LAST);
X        if (strEQ(d,"length"))
X            FUN1(O_LENGTH);
X        if (strEQ(d,"lt") || strEQ(d,"LT"))
X            OPERATOR(SLT);
X        if (strEQ(d,"le") || strEQ(d,"LE"))
X            OPERATOR(SLE);
X        if (strEQ(d,"localtime"))
X            FUN1(O_LOCALTIME);
X        if (strEQ(d,"log"))
X            FUN1(O_LOG);
X        if (strEQ(d,"link"))
X            FUN2(O_LINK);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'm': case 'M':
X        SNARFWORD;
X        if (strEQ(d,"m")) {
X            s = scanpat(s-1);
X            TERM(PATTERN);
X        }
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'n': case 'N':
X        SNARFWORD;
X        if (strEQ(d,"next"))
X            LOOPX(O_NEXT);
X        if (strEQ(d,"ne") || strEQ(d,"NE"))
X            OPERATOR(SNE);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'o': case 'O':
X        SNARFWORD;
X        if (strEQ(d,"open"))
X            OPERATOR(OPEN);
X        if (strEQ(d,"ord"))
X            FUN1(O_ORD);
X        if (strEQ(d,"oct"))
X            FUN1(O_OCT);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'p': case 'P':
X        SNARFWORD;
X        if (strEQ(d,"print")) {
X            yylval.ival = O_PRINT;
X            OPERATOR(PRINT);
X        }
X        if (strEQ(d,"printf")) {
X            yylval.ival = O_PRTF;
X            OPERATOR(PRINT);
X        }
X        if (strEQ(d,"push")) {
X            yylval.ival = O_PUSH;
X            OPERATOR(PUSH);
X        }
X        if (strEQ(d,"pop"))
X            OPERATOR(POP);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'q': case 'Q':
X        SNARFWORD;
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'r': case 'R':
X        SNARFWORD;
X        if (strEQ(d,"reset"))
X            UNI(O_RESET);
X        if (strEQ(d,"redo"))
X            LOOPX(O_REDO);
X        if (strEQ(d,"rename"))
X            FUN2(O_RENAME);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 's': case 'S':
X        SNARFWORD;
X        if (strEQ(d,"s")) {
X            s = scansubst(s);
X            TERM(SUBST);
X        }
X        if (strEQ(d,"shift"))
X            TERM(SHIFT);
X        if (strEQ(d,"split"))
X            TERM(SPLIT);
X        if (strEQ(d,"substr"))
X            FUN3(O_SUBSTR);
X        if (strEQ(d,"sprintf"))
X            OPERATOR(SPRINTF);
X        if (strEQ(d,"sub"))
X            OPERATOR(SUB);
X        if (strEQ(d,"select"))
X            OPERATOR(SELECT);
X        if (strEQ(d,"seek"))
X            OPERATOR(SEEK);
X        if (strEQ(d,"stat"))
X            OPERATOR(STAT);
X        if (strEQ(d,"sqrt"))
X            FUN1(O_SQRT);
X        if (strEQ(d,"sleep"))
X            UNI(O_SLEEP);
X        if (strEQ(d,"system")) {
X            yylval.ival = O_SYSTEM;
X            OPERATOR(PRINT);
X        }
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 't': case 'T':
X        SNARFWORD;
X        if (strEQ(d,"tr")) {
X            s = scantrans(s);
X            TERM(TRANS);
X        }
X        if (strEQ(d,"tell"))
X            TERM(TELL);
X        if (strEQ(d,"time"))
X            FUN0(O_TIME);
X        if (strEQ(d,"times"))
X            FUN0(O_TMS);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'u': case 'U':
X        SNARFWORD;
X        if (strEQ(d,"using"))
X            OPERATOR(USING);
X        if (strEQ(d,"until"))
X            OPERATOR(UNTIL);
X        if (strEQ(d,"unless"))
X            OPERATOR(UNLESS);
X        if (strEQ(d,"umask"))
X            FUN1(O_UMASK);
X        if (strEQ(d,"unshift")) {
X            yylval.ival = O_UNSHIFT;
X            OPERATOR(PUSH);
X        }
X        if (strEQ(d,"unlink")) {
X            yylval.ival = O_UNLINK;
X            OPERATOR(PRINT);
X        }
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'v': case 'V':
X        SNARFWORD;
X        if (strEQ(d,"values"))
X            SFUN(O_VALUES);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'w': case 'W':
X        SNARFWORD;
X        if (strEQ(d,"write"))
X            TERM(WRITE);
X        if (strEQ(d,"while"))
X            OPERATOR(WHILE);
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'x': case 'X':
X        SNARFWORD;
X        if (!expectterm && strEQ(d,"x"))
X            OPERATOR('x');
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'y': case 'Y':
X        SNARFWORD;
X        if (strEQ(d,"y")) {
X            s = scantrans(s);
X            TERM(TRANS);
X        }
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    case 'z': case 'Z':
X        SNARFWORD;
X        yylval.cval = savestr(d);
X        OPERATOR(WORD);
X    }
X}
X
XSTAB *
Xstabent(name,add)
Xregister char *name;
Xint add;
X{
X    register STAB *stab;
X
X    for (stab = stab_index[*name]; stab; stab = stab->stab_next) {
X        if (strEQ(name,stab->stab_name))
X            return stab;
X    }
X    
X    /* no entry--should we add one? */
X
X    if (add) {
X        stab = (STAB *) safemalloc(sizeof(STAB));
X        bzero((char*)stab, sizeof(STAB));
X        stab->stab_name = savestr(name);
X        stab->stab_val = str_new(0);
X        stab->stab_next = stab_index[*name];
X        stab_index[*name] = stab;
X        return stab;
X    }
X    return Nullstab;
X}
X
XSTIO *
Xstio_new()
X{
X    STIO *stio = (STIO *) safemalloc(sizeof(STIO));
X
X    bzero((char*)stio, sizeof(STIO));
X    stio->page_len = 60;
X    return stio;
X}
X
Xchar *
Xscanreg(s,dest)
Xregister char *s;
Xchar *dest;
X{
X    register char *d;
X
X    s++;
X    d = dest;
X    while (isalpha(*s) || isdigit(*s) || *s == '_')
X        *d++ = *s++;
X    *d = '\0';
X    d = dest;
X    if (!*d) {
X        *d = *s++;
X        if (*d == '{') {
X            d = dest;
X            while (*s && *s != '}')
X                *d++ = *s++;
X            *d = '\0';
X            d = dest;
X            if (*s)
X                s++;
X        }
X        else
X            d[1] = '\0';
X    }
X    if (*d == '^' && !isspace(*s))
X        *d = *s++ & 31;
X    return s;
X}
X
XSTR *
Xscanconst(string)
Xchar *string;
X{
X    register STR *retstr;
X    register char *t;
X    register char *d;
X
X    if (index(string,'|')) {
X        return Nullstr;
X    }
X    retstr = str_make(string);
X    t = str_get(retstr);
X    for (d=t; *d; ) {
X        switch (*d) {
X        case '.': case '[': case '$': case '(': case ')': case '|':
X            *d = '\0';
X            break;
X        case '\\':
X            if (index("wWbB0123456789",d[1])) {
X                *d = '\0';
X                break;
X            }
X            strcpy(d,d+1);
X            switch(*d) {
X            case 'n':
X                *d = '\n';
X                break;
X            case 't':
X                *d = '\t';
X                break;
X            case 'f':
X                *d = '\f';
X                break;
X            case 'r':
X                *d = '\r';
X                break;
X            }
X            /* FALL THROUGH */
X        default:
X            if (d[1] == '*' || d[1] == '+' || d[1] == '?') {
X                *d = '\0';
X                break;
X            }
X            d++;
X        }
X    }
X    if (!*t) {
X        str_free(retstr);
X        return Nullstr;
X    }
X    retstr->str_cur = strlen(retstr->str_ptr);        /* XXX cheating here */
X    return retstr;
X}
X
Xchar *
Xscanpat(s)
Xregister char *s;
X{
X    register SPAT *spat = (SPAT *) safemalloc(sizeof (SPAT));
X    register char *d;
X
X    bzero((char *)spat, sizeof(SPAT));
X    spat->spat_next = spat_root;        /* link into spat list */
X    spat_root = spat;
X    init_compex(&spat->spat_compex);
X
X    switch (*s++) {
X    case 'm':
X        s++;
X        break;
X    case '/':
X        break;
X    case '?':
X        spat->spat_flags |= SPAT_USE_ONCE;
X        break;
X    default:
X        fatal("Search pattern not found:\n%s",str_get(linestr));
X    }
X    s = cpytill(tokenbuf,s,s[-1]);
X    if (!*s)
X        fatal("Search pattern not terminated:\n%s",str_get(linestr));
X    s++;
X    if (*tokenbuf == '^') {
X        spat->spat_first = scanconst(tokenbuf+1);
X        if (spat->spat_first) {
X            spat->spat_flen = strlen(spat->spat_first->str_ptr);
X            if (spat->spat_flen == strlen(tokenbuf+1))
X                spat->spat_flags |= SPAT_SCANALL;
X        }
X    }
X    else {
X        spat->spat_flags |= SPAT_SCANFIRST;
X        spat->spat_first = scanconst(tokenbuf);
X        if (spat->spat_first) {
X            spat->spat_flen = strlen(spat->spat_first->str_ptr);
X            if (spat->spat_flen == strlen(tokenbuf))
X                spat->spat_flags |= SPAT_SCANALL;
X        }
X    }        
X    if (d = compile(&spat->spat_compex,tokenbuf,TRUE,FALSE))
X        fatal(d);
X    yylval.arg = make_match(O_MATCH,stab_to_arg(A_STAB,defstab),spat);
X    return s;
X}
X
Xchar *
Xscansubst(s)
Xregister char *s;
X{
X    register SPAT *spat = (SPAT *) safemalloc(sizeof (SPAT));
X    register char *d;
X
X    bzero((char *)spat, sizeof(SPAT));
X    spat->spat_next = spat_root;        /* link into spat list */
X    spat_root = spat;
X    init_compex(&spat->spat_compex);
X
X    s = cpytill(tokenbuf,s+1,*s);
X    if (!*s)
X        fatal("Substitution pattern not terminated:\n%s",str_get(linestr));
X    for (d=tokenbuf; *d; d++) {
X        if (*d == '$' && d[1] && d[-1] != '\\' && d[1] != '|') {
X            register ARG *arg;
X
X            spat->spat_runtime = arg = op_new(1);
X            arg->arg_type = O_ITEM;
X            arg[1].arg_type = A_DOUBLE;
X            arg[1].arg_ptr.arg_str = str_make(tokenbuf);
X            goto get_repl;                /* skip compiling for now */
X        }
X    }
X    if (*tokenbuf == '^') {
X        spat->spat_first = scanconst(tokenbuf+1);
X        if (spat->spat_first)
X            spat->spat_flen = strlen(spat->spat_first->str_ptr);
X    }
X    else {
X        spat->spat_flags |= SPAT_SCANFIRST;
X        spat->spat_first = scanconst(tokenbuf);
X        if (spat->spat_first)
X            spat->spat_flen = strlen(spat->spat_first->str_ptr);
X    }        
X    if (d = compile(&spat->spat_compex,tokenbuf,TRUE,FALSE))
X        fatal(d);
Xget_repl:
X    s = scanstr(s);
X    if (!*s)
X        fatal("Substitution replacement not terminated:\n%s",str_get(linestr));
X    spat->spat_repl = yylval.arg;
X    if (*s == 'g') {
X        s++;
X        spat->spat_flags &= ~SPAT_USE_ONCE;
X    }
X    else
X        spat->spat_flags |= SPAT_USE_ONCE;
X    yylval.arg = make_match(O_SUBST,stab_to_arg(A_STAB,defstab),spat);
X    return s;
X}
X
XARG *
Xmake_split(stab,arg)
Xregister STAB *stab;
Xregister ARG *arg;
X{
X    if (arg->arg_type != O_MATCH) {
X        register SPAT *spat = (SPAT *) safemalloc(sizeof (SPAT));
X        register char *d;
X
X        bzero((char *)spat, sizeof(SPAT));
X        spat->spat_next = spat_root;        /* link into spat list */
X        spat_root = spat;
X        init_compex(&spat->spat_compex);
X
X        spat->spat_runtime = arg;
X        arg = make_match(O_MATCH,stab_to_arg(A_STAB,defstab),spat);
X    }
X    arg->arg_type = O_SPLIT;
X    arg[2].arg_ptr.arg_spat->spat_repl = stab_to_arg(A_STAB,aadd(stab));
X    return arg;
X}
X
Xchar *
Xexpand_charset(s)
Xregister char *s;
X{
X    char t[512];
X    register char *d = t;
X    register int i;
X
X    while (*s) {
X        if (s[1] == '-' && s[2]) {
X            for (i = s[0]; i <= s[2]; i++)
X                *d++ = i;
X            s += 3;
X        }
X        else
X            *d++ = *s++;
X    }
X    *d = '\0';
X    return savestr(t);
X}
X
Xchar *
Xscantrans(s)
Xregister char *s;
X{
X    ARG *arg =
X        l(make_op(O_TRANS,2,stab_to_arg(A_STAB,defstab),Nullarg,Nullarg,0));
X    register char *t;
X    register char *r;
X    register char *tbl = safemalloc(256);
X    register int i;
X
X    arg[2].arg_type = A_NULL;
X    arg[2].arg_ptr.arg_cval = tbl;
X    for (i=0; i<256; i++)
X        tbl[i] = 0;
X    s = scanstr(s);
X    if (!*s)
X        fatal("Translation pattern not terminated:\n%s",str_get(linestr));
X    t = expand_charset(str_get(yylval.arg[1].arg_ptr.arg_str));
X    free_arg(yylval.arg);
X    s = scanstr(s-1);
X    if (!*s)
X        fatal("Translation replacement not terminated:\n%s",str_get(linestr));
X    r = expand_charset(str_get(yylval.arg[1].arg_ptr.arg_str));
X    free_arg(yylval.arg);
X    yylval.arg = arg;
X    if (!*r) {
X        safefree(r);
X        r = t;
X    }
X    for (i = 0; t[i]; i++) {
X        if (!r[i])
X            r[i] = r[i-1];
X        tbl[t[i] & 0377] = r[i];
X    }
X    if (r != t)
X        safefree(r);
X    safefree(t);
X    return s;
X}
X
XCMD *
Xblock_head(tail)
Xregister CMD *tail;
X{
X    if (tail == Nullcmd) {
X        return tail;
X    }
X    return tail->c_head;
X}
X
XCMD *
Xappend_line(head,tail)
Xregister CMD *head;
Xregister CMD *tail;
X{
X    if (tail == Nullcmd)
X        return head;
X    if (!tail->c_head)                        /* make sure tail is well formed */
X        tail->c_head = tail;
X    if (head != Nullcmd) {
X        tail = tail->c_head;                /* get to start of tail list */
X        if (!head->c_head)
X            head->c_head = head;        /* start a new head list */
X        while (head->c_next) {
X            head->c_next->c_head = head->c_head;
X            head = head->c_next;        /* get to end of head list */
X        }
X        head->c_next = tail;                /* link to end of old list */
X        tail->c_head = head->c_head;        /* propagate head pointer */
X    }
X    while (tail->c_next) {
X        tail->c_next->c_head = tail->c_head;
X        tail = tail->c_next;
X    }
X    return tail;
X}
X
XCMD *
Xmake_acmd(type,stab,cond,arg)
Xint type;
XSTAB *stab;
XARG *cond;
XARG *arg;
X{
X    register CMD *cmd = (CMD *) safemalloc(sizeof (CMD));
X
X    bzero((char *)cmd, sizeof(CMD));
X    cmd->c_type = type;
X    cmd->ucmd.acmd.ac_stab = stab;
X    cmd->ucmd.acmd.ac_expr = arg;
X    cmd->c_expr = cond;
X    if (cond) {
X        opt_arg(cmd,1);
X        cmd->c_flags |= CF_COND;
X    }
X    return cmd;
X}
X
XCMD *
Xmake_ccmd(type,arg,cblock)
Xint type;
Xregister ARG *arg;
Xstruct compcmd cblock;
X{
X    register CMD *cmd = (CMD *) safemalloc(sizeof (CMD));
X
X    bzero((char *)cmd, sizeof(CMD));
X    cmd->c_type = type;
X    cmd->c_expr = arg;
X    cmd->ucmd.ccmd.cc_true = cblock.comp_true;
X    cmd->ucmd.ccmd.cc_alt = cblock.comp_alt;
X    if (arg) {
X        opt_arg(cmd,1);
X        cmd->c_flags |= CF_COND;
X    }
X    return cmd;
X}
X
Xvoid
Xopt_arg(cmd,fliporflop)
Xregister CMD *cmd;
Xint fliporflop;
X{
X    register ARG *arg;
X    int opt = CFT_EVAL;
X    int sure = 0;
X    ARG *arg2;
X    char *tmps;        /* for True macro */
X    int context = 0;        /* 0 = normal, 1 = before &&, 2 = before || */
X    int flp = fliporflop;
X
X    if (!cmd)
X        return;
X    arg = cmd->c_expr;
X
X    /* Turn "if (!expr)" into "unless (expr)" */
X
X    while (arg->arg_type == O_NOT && arg[1].arg_type == A_EXPR) {
X        cmd->c_flags ^= CF_INVERT;                /* flip sense of cmd */
X        cmd->c_expr = arg[1].arg_ptr.arg_arg;        /* hoist the rest of expr */
X        free_arg(arg);
X        arg = cmd->c_expr;                        /* here we go again */
X    }
X
X    if (!arg->arg_len) {                /* sanity check */
X        cmd->c_flags |= opt;
X        return;
X    }
X
X    /* for "cond .. cond" we set up for the initial check */
X
X    if (arg->arg_type == O_FLIP)
X        context |= 4;
X
X    /* for "cond && expr" and "cond || expr" we can ignore expr, sort of */
X
X    if (arg->arg_type == O_AND)
X        context |= 1;
X    else if (arg->arg_type == O_OR)
X        context |= 2;
X    if (context && arg[flp].arg_type == A_EXPR) {
X        arg = arg[flp].arg_ptr.arg_arg;
X        flp = 1;
X    }
X
X    if (arg[flp].arg_flags & (AF_PRE|AF_POST)) {
X        cmd->c_flags |= opt;
X        return;                                /* side effect, can't optimize */
X    }
X
X    if (arg->arg_type == O_ITEM || arg->arg_type == O_FLIP ||
X      arg->arg_type == O_AND || arg->arg_type == O_OR) {
X        if (arg[flp].arg_type == A_SINGLE) {
X            opt = (str_true(arg[flp].arg_ptr.arg_str) ? CFT_TRUE : CFT_FALSE);
X            cmd->c_first = arg[flp].arg_ptr.arg_str;
X            goto literal;
X        }
X        else if (arg[flp].arg_type == A_STAB || arg[flp].arg_type == A_LVAL) {
X            cmd->c_stab  = arg[flp].arg_ptr.arg_stab;
X            opt = CFT_REG;
X          literal:
X            if (!context) {        /* no && or ||? */
X                free_arg(arg);
X                cmd->c_expr = Nullarg;
X            }
X            if (!(context & 1))
X                cmd->c_flags |= CF_EQSURE;
X            if (!(context & 2))
X                cmd->c_flags |= CF_NESURE;
X        }
X    }
X    else if (arg->arg_type == O_MATCH || arg->arg_type == O_SUBST ||
X             arg->arg_type == O_NMATCH || arg->arg_type == O_NSUBST) {
X        if ((arg[1].arg_type == A_STAB || arg[1].arg_type == A_LVAL) &&
X                arg[2].arg_type == A_SPAT &&
X                arg[2].arg_ptr.arg_spat->spat_first ) {
X            cmd->c_stab  = arg[1].arg_ptr.arg_stab;
X            cmd->c_first = arg[2].arg_ptr.arg_spat->spat_first;
X            cmd->c_flen  = arg[2].arg_ptr.arg_spat->spat_flen;
X            if (arg[2].arg_ptr.arg_spat->spat_flags & SPAT_SCANALL &&
X                (arg->arg_type == O_MATCH || arg->arg_type == O_NMATCH) )
X                sure |= CF_EQSURE;                /* (SUBST must be forced even */
X                                                /* if we know it will work.) */
X            arg[2].arg_ptr.arg_spat->spat_first = Nullstr;
X            arg[2].arg_ptr.arg_spat->spat_flen = 0; /* only one chk */
X            sure |= CF_NESURE;                /* normally only sure if it fails */
X            if (arg->arg_type == O_NMATCH || arg->arg_type == O_NSUBST)
X                cmd->c_flags |= CF_FIRSTNEG;
X            if (context & 1) {                /* only sure if thing is false */
X                if (cmd->c_flags & CF_FIRSTNEG)
X                    sure &= ~CF_NESURE;
X                else
X                    sure &= ~CF_EQSURE;
X            }
X            else if (context & 2) {        /* only sure if thing is true */
X                if (cmd->c_flags & CF_FIRSTNEG)
X                    sure &= ~CF_EQSURE;
X                else
X                    sure &= ~CF_NESURE;
X            }
X            if (sure & (CF_EQSURE|CF_NESURE)) {        /* if we know anything*/
X                if (arg[2].arg_ptr.arg_spat->spat_flags & SPAT_SCANFIRST)
X                    opt = CFT_SCAN;
X                else
X                    opt = CFT_ANCHOR;
X                if (sure == (CF_EQSURE|CF_NESURE)        /* really sure? */
X                    && arg->arg_type == O_MATCH
X                    && context & 4
X                    && fliporflop == 1) {
X                    arg[2].arg_type = A_SINGLE;                /* don't do twice */
X                    arg[2].arg_ptr.arg_str = &str_yes;
X                }
X                cmd->c_flags |= sure;
X            }
X        }
X    }
X    else if (arg->arg_type == O_SEQ || arg->arg_type == O_SNE ||
X             arg->arg_type == O_SLT || arg->arg_type == O_SGT) {
X        if (arg[1].arg_type == A_STAB || arg[1].arg_type == A_LVAL) {
X            if (arg[2].arg_type == A_SINGLE) {
X                cmd->c_stab  = arg[1].arg_ptr.arg_stab;
X                cmd->c_first = arg[2].arg_ptr.arg_str;
X                cmd->c_flen  = 30000;
X                switch (arg->arg_type) {
X                case O_SLT: case O_SGT:
X                    sure |= CF_EQSURE;
X                    cmd->c_flags |= CF_FIRSTNEG;
X                    break;
X                case O_SNE:
X                    cmd->c_flags |= CF_FIRSTNEG;
X                    /* FALL THROUGH */
X                case O_SEQ:
X                    sure |= CF_NESURE|CF_EQSURE;
X                    break;
X                }
X                if (context & 1) {        /* only sure if thing is false */
X                    if (cmd->c_flags & CF_FIRSTNEG)
X                        sure &= ~CF_NESURE;
X                    else
X                        sure &= ~CF_EQSURE;
X                }
X                else if (context & 2) { /* only sure if thing is true */
X                    if (cmd->c_flags & CF_FIRSTNEG)
X                        sure &= ~CF_EQSURE;
X                    else
X                        sure &= ~CF_NESURE;
X                }
X                if (sure & (CF_EQSURE|CF_NESURE)) {
X                    opt = CFT_STROP;
X                    cmd->c_flags |= sure;
X                }
X            }
X        }
X    }
X    else if (arg->arg_type == O_ASSIGN &&
X             (arg[1].arg_type == A_STAB || arg[1].arg_type == A_LVAL) &&
X             arg[1].arg_ptr.arg_stab == defstab &&
X             arg[2].arg_type == A_EXPR ) {
X        arg2 = arg[2].arg_ptr.arg_arg;
X        if (arg2->arg_type == O_ITEM && arg2[1].arg_type == A_READ) {
X            opt = CFT_GETS;
X            cmd->c_stab = arg2[1].arg_ptr.arg_stab;
X            if (!(arg2[1].arg_ptr.arg_stab->stab_io->flags & IOF_ARGV)) {
X                free_arg(arg2);
X                free_arg(arg);
X                cmd->c_expr = Nullarg;
X            }
X        }
X    }
X    else if (arg->arg_type == O_CHOP &&
X             (arg[1].arg_type == A_STAB || arg[1].arg_type == A_LVAL) ) {
X        opt = CFT_CHOP;
X        cmd->c_stab = arg[1].arg_ptr.arg_stab;
X        free_arg(arg);
X        cmd->c_expr = Nullarg;
X    }
X    if (context & 4)
X        opt |= CF_FLIP;
X    cmd->c_flags |= opt;
X
X    if (cmd->c_flags & CF_FLIP) {
X        if (fliporflop == 1) {
X            arg = cmd->c_expr;        /* get back to O_FLIP arg */
X            arg[3].arg_ptr.arg_cmd = (CMD*)safemalloc(sizeof(CMD));
X            bcopy((char *)cmd, (char *)arg[3].arg_ptr.arg_cmd, sizeof(CMD));
X            arg[4].arg_ptr.arg_cmd = (CMD*)safemalloc(sizeof(CMD));
X            bcopy((char *)cmd, (char *)arg[4].arg_ptr.arg_cmd, sizeof(CMD));
X            opt_arg(arg[4].arg_ptr.arg_cmd,2);
X            arg->arg_len = 2;                /* this is a lie */
X        }
X        else {
X            if ((opt & CF_OPTIMIZE) == CFT_EVAL)
X                cmd->c_flags = (cmd->c_flags & ~CF_OPTIMIZE) | CFT_UNFLIP;
X        }
X    }
X}
X
XARG *
Xmod_match(type,left,pat)
Xregister ARG *left;
Xregister ARG *pat;
X{
X
X    register SPAT *spat;
X    register ARG *newarg;
X
X    if ((pat->arg_type == O_MATCH ||
X         pat->arg_type == O_SUBST ||
X         pat->arg_type == O_TRANS ||
X         pat->arg_type == O_SPLIT
X        ) &&
X        pat[1].arg_ptr.arg_stab == defstab ) {
X        switch (pat->arg_type) {
X        case O_MATCH:
X            newarg = make_op(type == O_MATCH ? O_MATCH : O_NMATCH,
X                pat->arg_len,
X                left,Nullarg,Nullarg,0);
X            break;
X        case O_SUBST:
X            newarg = l(make_op(type == O_MATCH ? O_SUBST : O_NSUBST,
X                pat->arg_len,
X                left,Nullarg,Nullarg,0));
X            break;
X        case O_TRANS:
X            newarg = l(make_op(type == O_MATCH ? O_TRANS : O_NTRANS,
X                pat->arg_len,
X                left,Nullarg,Nullarg,0));
X            break;
X        case O_SPLIT:
X            newarg = make_op(type == O_MATCH ? O_SPLIT : O_SPLIT,
X                pat->arg_len,
X                left,Nullarg,Nullarg,0);
X            break;
X        }
X        if (pat->arg_len >= 2) {
X            newarg[2].arg_type = pat[2].arg_type;
X            newarg[2].arg_ptr = pat[2].arg_ptr;
X            newarg[2].arg_flags = pat[2].arg_flags;
X            if (pat->arg_len >= 3) {
X                newarg[3].arg_type = pat[3].arg_type;
X                newarg[3].arg_ptr = pat[3].arg_ptr;
X                newarg[3].arg_flags = pat[3].arg_flags;
X            }
X        }
X        safefree((char*)pat);
X    }
X    else {
X        spat = (SPAT *) safemalloc(sizeof (SPAT));
X        bzero((char *)spat, sizeof(SPAT));
X        spat->spat_next = spat_root;        /* link into spat list */
X        spat_root = spat;
X        init_compex(&spat->spat_compex);
X
X        spat->spat_runtime = pat;
X        newarg = make_op(type,2,left,Nullarg,Nullarg,0);
X        newarg[2].arg_type = A_SPAT;
X        newarg[2].arg_ptr.arg_spat = spat;
X        newarg[2].arg_flags = AF_SPECIAL;
X    }
X
X    return newarg;
X}
X
XCMD *
Xadd_label(lbl,cmd)
Xchar *lbl;
Xregister CMD *cmd;
X{
X    if (cmd)
X        cmd->c_label = lbl;
X    return cmd;
X}
X
XCMD *
Xaddcond(cmd, arg)
Xregister CMD *cmd;
Xregister ARG *arg;
X{
X    cmd->c_expr = arg;
X    opt_arg(cmd,1);
X    cmd->c_flags |= CF_COND;
X    return cmd;
X}
X
XCMD *
Xaddloop(cmd, arg)
Xregister CMD *cmd;
Xregister ARG *arg;
X{
X    cmd->c_expr = arg;
X    opt_arg(cmd,1);
X    cmd->c_flags |= CF_COND|CF_LOOP;
X    if (cmd->c_type == C_BLOCK)
X        cmd->c_flags &= ~CF_COND;
X    else {
X        arg = cmd->ucmd.acmd.ac_expr;
X        if (arg && arg->arg_type == O_ITEM && arg[1].arg_type == A_CMD)
X            cmd->c_flags &= ~CF_COND;  /* "do {} while" happens at least once */
X        if (arg && arg->arg_type == O_SUBR)
X            cmd->c_flags &= ~CF_COND;  /* likewise for "do subr() while" */
X    }
X    return cmd;
X}
X
XCMD *
Xinvert(cmd)
Xregister CMD *cmd;
X{
X    cmd->c_flags ^= CF_INVERT;
X    return cmd;
X}
X
Xyyerror(s)
Xchar *s;
X{
X    char tmpbuf[128];
X    char *tname = tmpbuf;
X
X    if (yychar > 256) {
X        tname = tokename[yychar-256];
X        if (strEQ(tname,"word"))
X            strcpy(tname,tokenbuf);
X        else if (strEQ(tname,"register"))
X            sprintf(tname,"$%s",tokenbuf);
X        else if (strEQ(tname,"array_length"))
X            sprintf(tname,"$#%s",tokenbuf);
X    }
X    else if (!yychar)
X        strcpy(tname,"EOF");
X    else if (yychar < 32)
X        sprintf(tname,"^%c",yychar+64);
X    else if (yychar == 127)
X        strcpy(tname,"^?");
X    else
X        sprintf(tname,"%c",yychar);
X    printf("%s in file %s at line %d, next token \"%s\"\n",
X      s,filename,line,tname);
X}
X
Xchar *
Xscanstr(s)
Xregister char *s;
X{
X    register char term;
X    register char *d;
X    register ARG *arg;
X    register bool makesingle = FALSE;
X    char *leave = "\\$nrtfb0123456789";        /* which backslash sequences to keep */
X
X    arg = op_new(1);
X    yylval.arg = arg;
X    arg->arg_type = O_ITEM;
X
X    switch (*s) {
X    default:                        /* a substitution replacement */
X        arg[1].arg_type = A_DOUBLE;
X        makesingle = TRUE;        /* maybe disable runtime scanning */
X        term = *s;
X        if (term == '\'')
X            leave = Nullch;
X        goto snarf_it;
X    case '0':
X        {
X            long i;
X            int shift;
X
X            arg[1].arg_type = A_SINGLE;
X            if (s[1] == 'x') {
X                shift = 4;
X                s += 2;
X            }
X            else if (s[1] == '.')
X                goto decimal;
X            else
X                shift = 3;
X            i = 0;
X            for (;;) {
X                switch (*s) {
X                default:
X                    goto out;
X                case '8': case '9':
X                    if (shift != 4)
X                        fatal("Illegal octal digit at line %d",line);
X                    /* FALL THROUGH */
X                case '0': case '1': case '2': case '3': case '4':
X                case '5': case '6': case '7':
X                    i <<= shift;
X                    i += *s++ & 15;
X                    break;
X                case 'a': case 'b': case 'c': case 'd': case 'e': case 'f':
X                case 'A': case 'B': case 'C': case 'D': case 'E': case 'F':
X                    if (shift != 4)
X                        goto out;
X                    i <<= 4;
X                    i += (*s++ & 7) + 9;
X                    break;
X                }
X            }
X          out:
X            sprintf(tokenbuf,"%d",i);
X            arg[1].arg_ptr.arg_str = str_make(tokenbuf);
X        }
X        break;
X    case '1': case '2': case '3': case '4': case '5':
X    case '6': case '7': case '8': case '9': case '.':
X      decimal:
X        arg[1].arg_type = A_SINGLE;
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
X        arg[1].arg_ptr.arg_str = str_make(tokenbuf);
X        break;
X    case '\'':
X        arg[1].arg_type = A_SINGLE;
X        term = *s;
X        leave = Nullch;
X        goto snarf_it;
X
X    case '<':
X        arg[1].arg_type = A_READ;
X        s = cpytill(tokenbuf,s+1,'>');
X        if (!*tokenbuf)
X            strcpy(tokenbuf,"ARGV");
X        if (*s)
X            s++;
X        if (rsfp == stdin && strEQ(tokenbuf,"stdin"))
X            fatal("Can't get both program and data from <stdin>\n");
X        arg[1].arg_ptr.arg_stab = stabent(tokenbuf,TRUE);
X        arg[1].arg_ptr.arg_stab->stab_io = stio_new();
X        if (strEQ(tokenbuf,"ARGV")) {
X            aadd(arg[1].arg_ptr.arg_stab);
X            arg[1].arg_ptr.arg_stab->stab_io->flags |= IOF_ARGV|IOF_START;
X        }
X        break;
X    case '"': 
X        arg[1].arg_type = A_DOUBLE;
X        makesingle = TRUE;        /* maybe disable runtime scanning */
X        term = *s;
X        goto snarf_it;
X    case '`':
X        arg[1].arg_type = A_BACKTICK;
X        term = *s;
X      snarf_it:
X        {
X            STR *tmpstr;
X            int sqstart = line;
X            char *tmps;
X
X            tmpstr = str_new(strlen(s));
X            s = str_append_till(tmpstr,s+1,term,leave);
X            while (!*s) {        /* multiple line string? */
X                s = str_gets(linestr, rsfp);
X                if (!*s)
X                    fatal("EOF in string at line %d\n",sqstart);
X                line++;
X                s = str_append_till(tmpstr,s,term,leave);
X            }
X            s++;
X            if (term == '\'') {
X                arg[1].arg_ptr.arg_str = tmpstr;
X                break;
X            }
X            tmps = s;
X            s = d = tmpstr->str_ptr;        /* assuming shrinkage only */
X            while (*s) {
X                if (*s == '$' && s[1]) {
X                    makesingle = FALSE;        /* force interpretation */
X                    if (!isalpha(s[1])) {        /* an internal register? */
X                        int len;
X
X                        len = scanreg(s,tokenbuf) - s;
X                        stabent(tokenbuf,TRUE);        /* make sure it's created */
X                        while (len--)
X                            *d++ = *s++;
X                        continue;
X                    }
X                }
X                else if (*s == '\\' && s[1]) {
X                    s++;
X                    switch (*s) {
X                    default:
X                      defchar:
X                        if (!leave || index(leave,*s))
X                            *d++ = '\\';
X                        *d++ = *s++;
X                        continue;
X                    case '0': case '1': case '2': case '3':
X                    case '4': case '5': case '6': case '7':
X                        *d = *s++ - '0';
X                        if (index("01234567",*s)) {
X                            *d <<= 3;
X                            *d += *s++ - '0';
X                        }
X                        else if (!index('`"',term)) {        /* oops, a subpattern */
X                            s--;
X                            goto defchar;
X                        }
X                        if (index("01234567",*s)) {
X                            *d <<= 3;
X                            *d += *s++ - '0';
X                        }
X                        d++;
X                        continue;
X                    case 'b':
X                        *d++ = '\b';
X                        break;
X                    case 'n':
X                        *d++ = '\n';
X                        break;
X                    case 'r':
X                        *d++ = '\r';
X                        break;
X                    case 'f':
X                        *d++ = '\f';
X                        break;
X                    case 't':
X                        *d++ = '\t';
X                        break;
X                    }
X                    s++;
X                    continue;
X                }
X                *d++ = *s++;
X            }
X            *d = '\0';
X            if (arg[1].arg_type == A_DOUBLE) {
X                if (makesingle)
X                    arg[1].arg_type = A_SINGLE;        /* now we can optimize on it */
X                else
X                    leave = "\\";
X                for (d = s = tmpstr->str_ptr; *s; *d++ = *s++) {
X                    if (*s == '\\' && (!leave || index(leave,s[1])))
X                        s++;
X                }
X                *d = '\0';
X            }
X            tmpstr->str_cur = d - tmpstr->str_ptr;        /* XXX cheat */
X            arg[1].arg_ptr.arg_str = tmpstr;
X            s = tmps;
X            break;
X        }
X    }
X    return s;
X}
X
XARG *
Xmake_op(type,newlen,arg1,arg2,arg3,dolist)
Xint type;
Xint newlen;
XARG *arg1;
XARG *arg2;
XARG *arg3;
Xint dolist;
X{
X    register ARG *arg;
X    register ARG *chld;
X    register int doarg;
X
X    arg = op_new(newlen);
X    arg->arg_type = type;
X    doarg = opargs[type];
X    if (chld = arg1) {
X        if (!(doarg & 1))
X            arg[1].arg_flags |= AF_SPECIAL;
X        if (doarg & 16)
X            arg[1].arg_flags |= AF_NUMERIC;
X        if (chld->arg_type == O_ITEM &&
X            (hoistable[chld[1].arg_type] || chld[1].arg_type == A_LVAL) ) {
X            arg[1].arg_type = chld[1].arg_type;
X            arg[1].arg_ptr = chld[1].arg_ptr;
X            arg[1].arg_flags |= chld[1].arg_flags;
X            free_arg(chld);
X        }
X        else {
X            arg[1].arg_type = A_EXPR;
X            arg[1].arg_ptr.arg_arg = chld;
X            if (dolist & 1) {
X                if (chld->arg_type == O_LIST) {
X                    if (newlen == 1) {        /* we can hoist entire list */
X                        chld->arg_type = type;
X                        free_arg(arg);
X                        arg = chld;
X                    }
X                    else {
X                        arg[1].arg_flags |= AF_SPECIAL;
X                    }
X                }
X                else if (chld->arg_type == O_ARRAY && chld->arg_len == 1)
X                    arg[1].arg_flags |= AF_SPECIAL;
X            }
X        }
X    }
X    if (chld = arg2) {
X        if (!(doarg & 2))
X            arg[2].arg_flags |= AF_SPECIAL;
X        if (doarg & 32)
X            arg[2].arg_flags |= AF_NUMERIC;
X        if (chld->arg_type == O_ITEM && 
X            (hoistable[chld[1].arg_type] || 
X             (type == O_ASSIGN && 
X              (chld[1].arg_type == A_READ ||
X               chld[1].arg_type == A_DOUBLE ||
X               chld[1].arg_type == A_BACKTICK ) ) ) ) {
X            arg[2].arg_type = chld[1].arg_type;
X            arg[2].arg_ptr = chld[1].arg_ptr;
X            free_arg(chld);
X        }
X        else {
X            arg[2].arg_type = A_EXPR;
X            arg[2].arg_ptr.arg_arg = chld;
X            if ((dolist & 2) &&
X              (chld->arg_type == O_LIST ||
X               (chld->arg_type == O_ARRAY && chld->arg_len == 1) ))
X                arg[2].arg_flags |= AF_SPECIAL;
X        }
X    }
X    if (chld = arg3) {
X        if (!(doarg & 4))
X            arg[3].arg_flags |= AF_SPECIAL;
X        if (doarg & 64)
X            arg[3].arg_flags |= AF_NUMERIC;
X        if (chld->arg_type == O_ITEM && hoistable[chld[1].arg_type]) {
X            arg[3].arg_type = chld[1].arg_type;
X            arg[3].arg_ptr = chld[1].arg_ptr;
X            free_arg(chld);
X        }
X        else {
X            arg[3].arg_type = A_EXPR;
X            arg[3].arg_ptr.arg_arg = chld;
X            if ((dolist & 4) &&
X              (chld->arg_type == O_LIST ||
X               (chld->arg_type == O_ARRAY && chld->arg_len == 1) ))
X                arg[3].arg_flags |= AF_SPECIAL;
X        }
X    }
X#ifdef DEBUGGING
X    if (debug & 16) {
X        fprintf(stderr,"%lx <= make_op(%s",arg,opname[arg->arg_type]);
X        if (arg1)
X            fprintf(stderr,",%s=%lx",
X                argname[arg[1].arg_type],arg[1].arg_ptr.arg_arg);
X        if (arg2)
X            fprintf(stderr,",%s=%lx",
X                argname[arg[2].arg_type],arg[2].arg_ptr.arg_arg);
X        if (arg3)
X            fprintf(stderr,",%s=%lx",
X                argname[arg[3].arg_type],arg[3].arg_ptr.arg_arg);
X        fprintf(stderr,")\n");
X    }
X#endif
X    evalstatic(arg);                /* see if we can consolidate anything */
X    return arg;
X}
X
X/* turn 123 into 123 == $. */
X
XARG *
Xflipflip(arg)
Xregister ARG *arg;
X{
X    if (arg && arg->arg_type == O_ITEM && arg[1].arg_type == A_SINGLE) {
X        arg = (ARG*)saferealloc((char*)arg,3*sizeof(ARG));
X        arg->arg_type = O_EQ;
X        arg->arg_len = 2;
X        arg[2].arg_type = A_STAB;
X        arg[2].arg_flags = 0;
X        arg[2].arg_ptr.arg_stab = stabent(".",TRUE);
X    }
X    return arg;
X}
X
Xvoid
Xevalstatic(arg)
Xregister ARG *arg;
X{
X    register STR *str;
X    register STR *s1;
X    register STR *s2;
X    double value;                /* must not be register */
X    register char *tmps;
X    int i;
X    double exp(), log(), sqrt(), modf();
X    char *crypt();
X
X    if (!arg || !arg->arg_len)
X        return;
X
X    if (arg[1].arg_type == A_SINGLE &&
X        (arg->arg_len == 1 || arg[2].arg_type == A_SINGLE) ) {
X        str = str_new(0);
X        s1 = arg[1].arg_ptr.arg_str;
X        if (arg->arg_len > 1)
X            s2 = arg[2].arg_ptr.arg_str;
X        else
X            s2 = Nullstr;
X        switch (arg->arg_type) {
X        default:
X            str_free(str);
X            str = Nullstr;                /* can't be evaluated yet */
X            break;
X        case O_CONCAT:
X            str_sset(str,s1);
X            str_scat(str,s2);
X            break;
X        case O_REPEAT:
X            i = (int)str_gnum(s2);
X            while (i--)
X                str_scat(str,s1);
X            break;
X        case O_MULTIPLY:
X            value = str_gnum(s1);
X            str_numset(str,value * str_gnum(s2));
X            break;
X        case O_DIVIDE:
X            value = str_gnum(s1);
X            str_numset(str,value / str_gnum(s2));
X            break;
X        case O_MODULO:
X            value = str_gnum(s1);
X            str_numset(str,(double)(((long)value) % ((long)str_gnum(s2))));
X            break;
X        case O_ADD:
X            value = str_gnum(s1);
X            str_numset(str,value + str_gnum(s2));
X            break;
X        case O_SUBTRACT:
X            value = str_gnum(s1);
X            str_numset(str,value - str_gnum(s2));
X            break;
X        case O_LEFT_SHIFT:
X            value = str_gnum(s1);
X            str_numset(str,(double)(((long)value) << ((long)str_gnum(s2))));
X            break;
X        case O_RIGHT_SHIFT:
X            value = str_gnum(s1);
X            str_numset(str,(double)(((long)value) >> ((long)str_gnum(s2))));
X            break;
X        case O_LT:
X            value = str_gnum(s1);
X            str_numset(str,(double)(value < str_gnum(s2)));
X            break;
X        case O_GT:
X            value = str_gnum(s1);
X            str_numset(str,(double)(value > str_gnum(s2)));
X            break;
X        case O_LE:
X            value = str_gnum(s1);
X            str_numset(str,(double)(value <= str_gnum(s2)));
X            break;
X        case O_GE:
X            value = str_gnum(s1);
X            str_numset(str,(double)(value >= str_gnum(s2)));
X            break;
X        case O_EQ:
X            value = str_gnum(s1);
X            str_numset(str,(double)(value == str_gnum(s2)));
X            break;
X        case O_NE:
X            value = str_gnum(s1);
X            str_numset(str,(double)(value != str_gnum(s2)));
X            break;
X        case O_BIT_AND:
X            value = str_gnum(s1);
X            str_numset(str,(double)(((long)value) & ((long)str_gnum(s2))));
X            break;
X        case O_XOR:
X            value = str_gnum(s1);
X            str_numset(str,(double)(((long)value) ^ ((long)str_gnum(s2))));
X            break;
X        case O_BIT_OR:
X            value = str_gnum(s1);
X            str_numset(str,(double)(((long)value) | ((long)str_gnum(s2))));
X            break;
X        case O_AND:
X            if (str_true(s1))
X                str = str_make(str_get(s2));
X            else
X                str = str_make(str_get(s1));
X            break;
X        case O_OR:
X            if (str_true(s1))
X                str = str_make(str_get(s1));
X            else
X                str = str_make(str_get(s2));
X            break;
X        case O_COND_EXPR:
X            if (arg[3].arg_type != A_SINGLE) {
X                str_free(str);
X                str = Nullstr;
X            }
X            else {
X                str = str_make(str_get(str_true(s1) ? s2 : arg[3].arg_ptr.arg_str));
X                str_free(arg[3].arg_ptr.arg_str);
X            }
X            break;
X        case O_NEGATE:
X            str_numset(str,(double)(-str_gnum(s1)));
X            break;
X        case O_NOT:
X            str_numset(str,(double)(!str_true(s1)));
X            break;
X        case O_COMPLEMENT:
X            str_numset(str,(double)(~(long)str_gnum(s1)));
X            break;
X        case O_LENGTH:
X            str_numset(str, (double)str_len(s1));
X            break;
X        case O_SUBSTR:
X            if (arg[3].arg_type != A_SINGLE || stabent("[",FALSE)) {
X                str_free(str);                /* making the fallacious assumption */
X                str = Nullstr;                /* that any $[ occurs before substr()*/
X            }
X            else {
X                char *beg;
X                int len = (int)str_gnum(s2);
X                int tmp;
X
X                for (beg = str_get(s1); *beg && len > 0; beg++,len--) ;
X                len = (int)str_gnum(arg[3].arg_ptr.arg_str);
X                str_free(arg[3].arg_ptr.arg_str);
X                if (len > (tmp = strlen(beg)))
X                    len = tmp;
X                str_nset(str,beg,len);
X            }
X            break;
X        case O_SLT:
X            tmps = str_get(s1);
X            str_numset(str,(double)(strLT(tmps,str_get(s2))));
X            break;
X        case O_SGT:
X            tmps = str_get(s1);
X            str_numset(str,(double)(strGT(tmps,str_get(s2))));
X            break;
X        case O_SLE:
X            tmps = str_get(s1);
X            str_numset(str,(double)(strLE(tmps,str_get(s2))));
X            break;
X        case O_SGE:
X            tmps = str_get(s1);
X            str_numset(str,(double)(strGE(tmps,str_get(s2))));
X            break;
X        case O_SEQ:
X            tmps = str_get(s1);
X            str_numset(str,(double)(strEQ(tmps,str_get(s2))));
X            break;
X        case O_SNE:
X            tmps = str_get(s1);
X            str_numset(str,(double)(strNE(tmps,str_get(s2))));
X            break;
X        case O_CRYPT:
X            tmps = str_get(s1);
X            str_set(str,crypt(tmps,str_get(s2)));
X            break;
X        case O_EXP:
X            str_numset(str,exp(str_gnum(s1)));
X            break;
X        case O_LOG:
X            str_numset(str,log(str_gnum(s1)));
X            break;
X        case O_SQRT:
X            str_numset(str,sqrt(str_gnum(s1)));
X            break;
X        case O_INT:
X            modf(str_gnum(s1),&value);
X            str_numset(str,value);
X            break;
X        case O_ORD:
X            str_numset(str,(double)(*str_get(s1)));
X            break;
X        }
X        if (str) {
X            arg->arg_type = O_ITEM;        /* note arg1 type is already SINGLE */
X            str_free(s1);
X            str_free(s2);
X            arg[1].arg_ptr.arg_str = str;
X        }
X    }
X}
X
XARG *
Xl(arg)
Xregister ARG *arg;
X{
X    register int i;
X    register ARG *arg1;
X
X    arg->arg_flags |= AF_COMMON;        /* XXX should cross-match */
X
X    /* see if it's an array reference */
X
X    if (arg[1].arg_type == A_EXPR) {
X        arg1 = arg[1].arg_ptr.arg_arg;
X
X        if (arg1->arg_type == O_LIST && arg->arg_type != O_ITEM) {
X                                                /* assign to list */
X            arg[1].arg_flags |= AF_SPECIAL;
X            arg[2].arg_flags |= AF_SPECIAL;
X            for (i = arg1->arg_len; i >= 1; i--) {
X                switch (arg1[i].arg_type) {
X                case A_STAB: case A_LVAL:
X                    arg1[i].arg_type = A_LVAL;
X                    break;
X                case A_EXPR: case A_LEXPR:
X                    arg1[i].arg_type = A_LEXPR;
X                    if (arg1[i].arg_ptr.arg_arg->arg_type == O_ARRAY)
X                        arg1[i].arg_ptr.arg_arg->arg_type = O_LARRAY;
X                    else if (arg1[i].arg_ptr.arg_arg->arg_type == O_HASH)
X                        arg1[i].arg_ptr.arg_arg->arg_type = O_LHASH;
X                    if (arg1[i].arg_ptr.arg_arg->arg_type == O_LARRAY)
X                        break;
X                    if (arg1[i].arg_ptr.arg_arg->arg_type == O_LHASH)
X                        break;
X                    /* FALL THROUGH */
X                default:
X                    sprintf(tokenbuf,
X                      "Illegal item (%s) as lvalue",argname[arg1[i].arg_type]);
X                    yyerror(tokenbuf);
X                }
X            }
X        }
X        else if (arg1->arg_type == O_ARRAY) {
X            if (arg1->arg_len == 1 && arg->arg_type != O_ITEM) {
X                                                /* assign to array */
X                arg[1].arg_flags |= AF_SPECIAL;
X                arg[2].arg_flags |= AF_SPECIAL;
X            }
X            else
X                arg1->arg_type = O_LARRAY;        /* assign to array elem */
X        }
X        else if (arg1->arg_type == O_HASH)
X            arg1->arg_type = O_LHASH;
X        else {
X            sprintf(tokenbuf,
X              "Illegal expression (%s) as lvalue",opname[arg1->arg_type]);
X            yyerror(tokenbuf);
X        }
X        arg[1].arg_type = A_LEXPR;
X#ifdef DEBUGGING
X        if (debug & 16)
X            fprintf(stderr,"lval LEXPR\n");
X#endif
X        return arg;
X    }
X
X    /* not an array reference, should be a register name */
X
X    if (arg[1].arg_type != A_STAB && arg[1].arg_type != A_LVAL) {
X        sprintf(tokenbuf,
X          "Illegal item (%s) as lvalue",argname[arg[1].arg_type]);
X        yyerror(tokenbuf);
X    }
X    arg[1].arg_type = A_LVAL;
X#ifdef DEBUGGING
X    if (debug & 16)
X        fprintf(stderr,"lval LVAL\n");
X#endif
X    return arg;
X}
X
XARG *
Xaddflags(i,flags,arg)
Xregister ARG *arg;
X{
X    arg[i].arg_flags |= flags;
X    return arg;
X}
X
XARG *
Xhide_ary(arg)
XARG *arg;
X{
X    if (arg->arg_type == O_ARRAY)
X        return make_op(O_ITEM,1,arg,Nullarg,Nullarg,0);
X    return arg;
X}
X
XARG *
Xmake_list(arg)
Xregister ARG *arg;
X{
X    register int i;
X    register ARG *node;
X    register ARG *nxtnode;
X    register int j;
X    STR *tmpstr;
X
X    if (!arg) {
X        arg = op_new(0);
X        arg->arg_type = O_LIST;
X    }
X    if (arg->arg_type != O_COMMA) {
X        arg->arg_flags |= AF_LISTISH;        /* see listish() below */
X        return arg;
X    }
X    for (i = 2, node = arg; ; i++) {
X        if (node->arg_len < 2)
X            break;
X        if (node[2].arg_type != A_EXPR)
X            break;
X        node = node[2].arg_ptr.arg_arg;
X        if (node->arg_type != O_COMMA)
X            break;
X    }
X    if (i > 2) {
X        node = arg;
X        arg = op_new(i);
X        tmpstr = arg->arg_ptr.arg_str;
X        *arg = *node;                /* copy everything except the STR */
X        arg->arg_ptr.arg_str = tmpstr;
X        for (j = 1; ; ) {
X            arg[j++] = node[1];
X            if (j >= i) {
X                arg[j] = node[2];
X                free_arg(node);
X                break;
X            }
X            nxtnode = node[2].arg_ptr.arg_arg;
X            free_arg(node);
X            node = nxtnode;
X        }
X    }
X    arg->arg_type = O_LIST;
X    arg->arg_len = i;
X    return arg;
X}
X
X/* turn a single item into a list */
X
XARG *
Xlistish(arg)
XARG *arg;
X{
X    if (arg->arg_flags & AF_LISTISH)
X        arg = make_op(O_LIST,1,arg,Nullarg,Nullarg,0);
X    return arg;
X}
X
XARG *
Xstab_to_arg(atype,stab)
Xint atype;
Xregister STAB *stab;
X{
X    register ARG *arg;
X
X    arg = op_new(1);
X    arg->arg_type = O_ITEM;
X    arg[1].arg_type = atype;
X    arg[1].arg_ptr.arg_stab = stab;
X    return arg;
X}
X
XARG *
Xcval_to_arg(cval)
Xregister char *cval;
X{
X    register ARG *arg;
X
X    arg = op_new(1);
X    arg->arg_type = O_ITEM;
X    arg[1].arg_type = A_SINGLE;
X    arg[1].arg_ptr.arg_str = str_make(cval);
X    safefree(cval);
X    return arg;
X}
X
XARG *
Xop_new(numargs)
Xint numargs;
X{
X    register ARG *arg;
X
X    arg = (ARG*)safemalloc((numargs + 1) * sizeof (ARG));
X    bzero((char *)arg, (numargs + 1) * sizeof (ARG));
X    arg->arg_ptr.arg_str = str_new(0);
X    arg->arg_len = numargs;
X    return arg;
X}
X
Xvoid
Xfree_arg(arg)
XARG *arg;
X{
X    str_free(arg->arg_ptr.arg_str);
X    safefree((char*)arg);
X}
X
XARG *
Xmake_match(type,expr,spat)
Xint type;
XARG *expr;
XSPAT *spat;
X{
X    register ARG *arg;
X
X    arg = make_op(type,2,expr,Nullarg,Nullarg,0);
X
X    arg[2].arg_type = A_SPAT;
X    arg[2].arg_ptr.arg_spat = spat;
X#ifdef DEBUGGING
X    if (debug & 16)
X        fprintf(stderr,"make_match SPAT=%lx\n",spat);
X#endif
X
X    if (type == O_SUBST || type == O_NSUBST) {
X        if (arg[1].arg_type != A_STAB)
X            yyerror("Illegal lvalue");
X        arg[1].arg_type = A_LVAL;
X    }
X    return arg;
X}
X
XARG *
Xcmd_to_arg(cmd)
XCMD *cmd;
X{
X    register ARG *arg;
X
X    arg = op_new(1);
X    arg->arg_type = O_ITEM;
X    arg[1].arg_type = A_CMD;
X    arg[1].arg_ptr.arg_cmd = cmd;
X    return arg;
X}
X
XCMD *
Xwopt(cmd)
Xregister CMD *cmd;
X{
X    register CMD *tail;
X    register ARG *arg = cmd->c_expr;
X    char *tmps;        /* used by True macro */
X
X    /* hoist "while (<channel>)" up into command block */
X
X    if (arg && arg->arg_type == O_ITEM && arg[1].arg_type == A_READ) {
X        cmd->c_flags &= ~CF_OPTIMIZE;        /* clear optimization type */
X        cmd->c_flags |= CFT_GETS;        /* and set it to do the input */
X        cmd->c_stab = arg[1].arg_ptr.arg_stab;
X        if (arg[1].arg_ptr.arg_stab->stab_io->flags & IOF_ARGV) {
X            cmd->c_expr = l(make_op(O_ASSIGN, 2,        /* fake up "$_ =" */
X               stab_to_arg(A_LVAL,defstab), arg, Nullarg,1 ));
X        }
X        else {
X            free_arg(arg);
X            cmd->c_expr = Nullarg;
X        }
X    }
X
X    /* First find the end of the true list */
X
X    if (cmd->ucmd.ccmd.cc_true == Nullcmd)
X        return cmd;
X    for (tail = cmd->ucmd.ccmd.cc_true; tail->c_next; tail = tail->c_next) ;
X
X    /* if there's a continue block, link it to true block and find end */
X
X    if (cmd->ucmd.ccmd.cc_alt != Nullcmd) {
X        tail->c_next = cmd->ucmd.ccmd.cc_alt;
X        for ( ; tail->c_next; tail = tail->c_next) ;
X    }
X
X    /* Here's the real trick: link the end of the list back to the beginning,
X     * inserting a "last" block to break out of the loop.  This saves one or
X     * two procedure calls every time through the loop, because of how cmd_exec
X     * does tail recursion.
X     */
X
X    tail->c_next = (CMD *) safemalloc(sizeof (CMD));
X    tail = tail->c_next;
X    if (!cmd->ucmd.ccmd.cc_alt)
X        cmd->ucmd.ccmd.cc_alt = tail;        /* every loop has a continue now */
X
X    bcopy((char *)cmd, (char *)tail, sizeof(CMD));
X    tail->c_type = C_EXPR;
X    tail->c_flags ^= CF_INVERT;                /* turn into "last unless" */
X    tail->c_next = tail->ucmd.ccmd.cc_true;        /* loop directly back to top */
X    tail->ucmd.acmd.ac_expr = make_op(O_LAST,0,Nullarg,Nullarg,Nullarg,0);
X    tail->ucmd.acmd.ac_stab = Nullstab;
X    return cmd;
X}
X
XFCMD *
Xload_format()
X{
X    FCMD froot;
X    FCMD *flinebeg;
X    register FCMD *fprev = &froot;
X    register FCMD *fcmd;
X    register char *s;
X    register char *t;
X    register char tmpchar;
X    bool noblank;
X
X    while ((s = str_gets(linestr,rsfp)) != Nullch) {
X        line++;
X        if (strEQ(s,".\n")) {
X            bufptr = s;
X            return froot.f_next;
X        }
X        if (*s == '#')
X            continue;
X        flinebeg = Nullfcmd;
X        noblank = FALSE;
X        while (*s) {
X            fcmd = (FCMD *)safemalloc(sizeof (FCMD));
X            bzero((char*)fcmd, sizeof (FCMD));
X            fprev->f_next = fcmd;
X            fprev = fcmd;
X            for (t=s; *t && *t != '@' && *t != '^'; t++) {
X                if (*t == '~') {
X                    noblank = TRUE;
X                    *t = ' ';
X                }
X            }
X            tmpchar = *t;
X            *t = '\0';
X            fcmd->f_pre = savestr(s);
X            fcmd->f_presize = strlen(s);
X            *t = tmpchar;
X            s = t;
X            if (!*s) {
X                if (noblank)
X                    fcmd->f_flags |= FC_NOBLANK;
X                break;
X            }
X            if (!flinebeg)
X                flinebeg = fcmd;                /* start values here */
X            if (*s++ == '^')
X                fcmd->f_flags |= FC_CHOP;        /* for doing text filling */
X            switch (*s) {
X            case '*':
X                fcmd->f_type = F_LINES;
X                *s = '\0';
X                break;
X            case '<':
X                fcmd->f_type = F_LEFT;
X                while (*s == '<')
X                    s++;
X                break;
X            case '>':
X                fcmd->f_type = F_RIGHT;
X                while (*s == '>')
X                    s++;
X                break;
X            case '|':
X                fcmd->f_type = F_CENTER;
X                while (*s == '|')
X                    s++;
X                break;
X            default:
X                fcmd->f_type = F_LEFT;
X                break;
X            }
X            if (fcmd->f_flags & FC_CHOP && *s == '.') {
X                fcmd->f_flags |= FC_MORE;
X                while (*s == '.')
X                    s++;
X            }
X            fcmd->f_size = s-t;
X        }
X        if (flinebeg) {
X          again:
X            if ((bufptr = str_gets(linestr ,rsfp)) == Nullch)
X                goto badform;
X            line++;
X            if (strEQ(bufptr,".\n")) {
X                yyerror("Missing values line");
X                return froot.f_next;
X            }
X            if (*bufptr == '#')
X                goto again;
X            lex_newlines = TRUE;
X            while (flinebeg || *bufptr) {
X                switch(yylex()) {
X                default:
X                    yyerror("Bad value in format");
X                    *bufptr = '\0';
X                    break;
X                case '\n':
X                    if (flinebeg)
X                        yyerror("Missing value in format");
X                    *bufptr = '\0';
X                    break;
X                case REG:
X                    yylval.arg = stab_to_arg(A_LVAL,yylval.stabval);
X                    /* FALL THROUGH */
X                case RSTRING:
X                    if (!flinebeg)
X                        yyerror("Extra value in format");
X                    else {
X                        flinebeg->f_expr = yylval.arg;
X                        do {
X                            flinebeg = flinebeg->f_next;
X                        } while (flinebeg && flinebeg->f_size == 0);
X                    }
X                    break;
X                case ',': case ';':
X                    continue;
X                }
X            }
X            lex_newlines = FALSE;
X        }
X    }
X  badform:
X    bufptr = str_get(linestr);
X    yyerror("Format not terminated");
X    return froot.f_next;
X}
!STUFFY!FUNK!
echo ""
echo "End of kit 2 (of 10)"
cat /dev/null >kit2isdone
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