#! /bin/sh

# Make a new directory for the perl sources, cd to it, and run kits 1
# thru 10 through sh.  When all 10 kits have been run, read README.

echo "This is perl 1.0 kit 3 (of 10).  If kit 3 is complete, the line"
echo '"'"End of kit 3 (of 10)"'" will echo at the end.'
echo ""
export PATH || (echo "You didn't use sh, you clunch." ; kill $$)
echo Extracting arg.c
sed >arg.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: arg.c,v 1.0 87/12/18 13:04:33 root Exp $
X *
X * $Log:        arg.c,v $
X * Revision 1.0  87/12/18  13:04:33  root
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
XARG *debarg;
X
Xbool
Xdo_match(s,arg)
Xregister char *s;
Xregister ARG *arg;
X{
X    register SPAT *spat = arg[2].arg_ptr.arg_spat;
X    register char *d;
X    register char *t;
X
X    if (!spat || !s)
X        fatal("panic: do_match\n");
X    if (spat->spat_flags & SPAT_USED) {
X#ifdef DEBUGGING
X        if (debug & 8)
X            deb("2.SPAT USED\n");
X#endif
X        return FALSE;
X    }
X    if (spat->spat_runtime) {
X        t = str_get(eval(spat->spat_runtime,Null(STR***)));
X#ifdef DEBUGGING
X        if (debug & 8)
X            deb("2.SPAT /%s/\n",t);
X#endif
X        if (d = compile(&spat->spat_compex,t,TRUE,FALSE)) {
X#ifdef DEBUGGING
X            deb("/%s/: %s\n", t, d);
X#endif
X            return FALSE;
X        }
X        if (spat->spat_compex.complen <= 1 && curspat)
X            spat = curspat;
X        if (execute(&spat->spat_compex, s, TRUE, 0)) {
X            if (spat->spat_compex.numsubs)
X                curspat = spat;
X            return TRUE;
X        }
X        else
X            return FALSE;
X    }
X    else {
X#ifdef DEBUGGING
X        if (debug & 8) {
X            char ch;
X
X            if (spat->spat_flags & SPAT_USE_ONCE)
X                ch = '?';
X            else
X                ch = '/';
X            deb("2.SPAT %c%s%c\n",ch,spat->spat_compex.precomp,ch);
X        }
X#endif
X        if (spat->spat_compex.complen <= 1 && curspat)
X            spat = curspat;
X        if (spat->spat_first) {
X            if (spat->spat_flags & SPAT_SCANFIRST) {
X                str_free(spat->spat_first);
X                spat->spat_first = Nullstr;        /* disable optimization */
X            }
X            else if (*spat->spat_first->str_ptr != *s ||
X              strnNE(spat->spat_first->str_ptr, s, spat->spat_flen) )
X                return FALSE;
X        }
X        if (execute(&spat->spat_compex, s, TRUE, 0)) {
X            if (spat->spat_compex.numsubs)
X                curspat = spat;
X            if (spat->spat_flags & SPAT_USE_ONCE)
X                spat->spat_flags |= SPAT_USED;
X            return TRUE;
X        }
X        else
X            return FALSE;
X    }
X    /*NOTREACHED*/
X}
X
Xint
Xdo_subst(str,arg)
XSTR *str;
Xregister ARG *arg;
X{
X    register SPAT *spat;
X    register STR *dstr;
X    register char *s;
X    register char *m;
X
X    spat = arg[2].arg_ptr.arg_spat;
X    s = str_get(str);
X    if (!spat || !s)
X        fatal("panic: do_subst\n");
X    else if (spat->spat_runtime) {
X        char *d;
X
X        m = str_get(eval(spat->spat_runtime,Null(STR***)));
X        if (d = compile(&spat->spat_compex,m,TRUE,FALSE)) {
X#ifdef DEBUGGING
X            deb("/%s/: %s\n", m, d);
X#endif
X            return 0;
X        }
X    }
X#ifdef DEBUGGING
X    if (debug & 8) {
X        deb("2.SPAT /%s/\n",spat->spat_compex.precomp);
X    }
X#endif
X    if (spat->spat_compex.complen <= 1 && curspat)
X        spat = curspat;
X    if (spat->spat_first) {
X        if (spat->spat_flags & SPAT_SCANFIRST) {
X            str_free(spat->spat_first);
X            spat->spat_first = Nullstr;        /* disable optimization */
X        }
X        else if (*spat->spat_first->str_ptr != *s ||
X          strnNE(spat->spat_first->str_ptr, s, spat->spat_flen) )
X            return 0;
X    }
X    if (m = execute(&spat->spat_compex, s, TRUE, 1)) {
X        int iters = 0;
X
X        dstr = str_new(str_len(str));
X        if (spat->spat_compex.numsubs)
X            curspat = spat;
X        do {
X            if (iters++ > 10000)
X                fatal("Substitution loop?\n");
X            if (spat->spat_compex.numsubs)
X                s = spat->spat_compex.subbase;
X            str_ncat(dstr,s,m-s);
X            s = spat->spat_compex.subend[0];
X            str_scat(dstr,eval(spat->spat_repl,Null(STR***)));
X            if (spat->spat_flags & SPAT_USE_ONCE)
X                break;
X        } while (m = execute(&spat->spat_compex, s, FALSE, 1));
X        str_cat(dstr,s);
X        str_replace(str,dstr);
X        STABSET(str);
X        return iters;
X    }
X    return 0;
X}
X
Xint
Xdo_trans(str,arg)
XSTR *str;
Xregister ARG *arg;
X{
X    register char *tbl;
X    register char *s;
X    register int matches = 0;
X    register int ch;
X
X    tbl = arg[2].arg_ptr.arg_cval;
X    s = str_get(str);
X    if (!tbl || !s)
X        fatal("panic: do_trans\n");
X#ifdef DEBUGGING
X    if (debug & 8) {
X        deb("2.TBL\n");
X    }
X#endif
X    while (*s) {
X        if (ch = tbl[*s & 0377]) {
X            matches++;
X            *s = ch;
X        }
X        s++;
X    }
X    STABSET(str);
X    return matches;
X}
X
Xint
Xdo_split(s,spat,retary)
Xregister char *s;
Xregister SPAT *spat;
XSTR ***retary;
X{
X    register STR *dstr;
X    register char *m;
X    register ARRAY *ary;
X    static ARRAY *myarray = Null(ARRAY*);
X    int iters = 0;
X    STR **sarg;
X    register char *e;
X    int i;
X
X    if (!spat || !s)
X        fatal("panic: do_split\n");
X    else if (spat->spat_runtime) {
X        char *d;
X
X        m = str_get(eval(spat->spat_runtime,Null(STR***)));
X        if (d = compile(&spat->spat_compex,m,TRUE,FALSE)) {
X#ifdef DEBUGGING
X            deb("/%s/: %s\n", m, d);
X#endif
X            return FALSE;
X        }
X    }
X#ifdef DEBUGGING
X    if (debug & 8) {
X        deb("2.SPAT /%s/\n",spat->spat_compex.precomp);
X    }
X#endif
X    if (retary)
X        ary = myarray;
X    else
X        ary = spat->spat_repl[1].arg_ptr.arg_stab->stab_array;
X    if (!ary)
X        myarray = ary = anew();
X    ary->ary_fill = -1;
X    while (*s && (m = execute(&spat->spat_compex, s, (iters == 0), 1))) {
X        if (spat->spat_compex.numsubs)
X            s = spat->spat_compex.subbase;
X        dstr = str_new(m-s);
X        str_nset(dstr,s,m-s);
X        astore(ary, iters++, dstr);
X        if (iters > 10000)
X            fatal("Substitution loop?\n");
X        s = spat->spat_compex.subend[0];
X    }
X    if (*s) {                        /* ignore field after final "whitespace" */
X        dstr = str_new(0);        /*   if they interpolate, it's null anyway */
X        str_set(dstr,s);
X        astore(ary, iters++, dstr);
X    }
X    else {
X        while (iters > 0 && !*str_get(afetch(ary,iters-1)))
X            iters--;
X    }
X    if (retary) {
X        sarg = (STR**)safemalloc((iters+2)*sizeof(STR*));
X
X        sarg[0] = Nullstr;
X        sarg[iters+1] = Nullstr;
X        for (i = 1; i <= iters; i++)
X            sarg[i] = afetch(ary,i-1);
X        *retary = sarg;
X    }
X    return iters;
X}
X
Xvoid
Xdo_join(arg,delim,str)
Xregister ARG *arg;
Xregister char *delim;
Xregister STR *str;
X{
X    STR **tmpary;        /* must not be register */
X    register STR **elem;
X
X    (void)eval(arg[2].arg_ptr.arg_arg,&tmpary);
X    elem = tmpary+1;
X    if (*elem)
X    str_sset(str,*elem++);
X    for (; *elem; elem++) {
X        str_cat(str,delim);
X        str_scat(str,*elem);
X    }
X    STABSET(str);
X    safefree((char*)tmpary);
X}
X
Xbool
Xdo_open(stab,name)
XSTAB *stab;
Xregister char *name;
X{
X    FILE *fp;
X    int len = strlen(name);
X    register STIO *stio = stab->stab_io;
X
X    while (len && isspace(name[len-1]))
X        name[--len] = '\0';
X    if (!stio)
X        stio = stab->stab_io = stio_new();
X    if (stio->fp) {
X        if (stio->type == '|')
X            pclose(stio->fp);
X        else if (stio->type != '-')
X            fclose(stio->fp);
X        stio->fp = Nullfp;
X    }
X    stio->type = *name;
X    if (*name == '|') {
X        for (name++; isspace(*name); name++) ;
X        fp = popen(name,"w");
X    }
X    else if (*name == '>' && name[1] == '>') {
X        for (name += 2; isspace(*name); name++) ;
X        fp = fopen(name,"a");
X    }
X    else if (*name == '>') {
X        for (name++; isspace(*name); name++) ;
X        if (strEQ(name,"-")) {
X            fp = stdout;
X            stio->type = '-';
X        }
X        else
X            fp = fopen(name,"w");
X    }
X    else {
X        if (*name == '<') {
X            for (name++; isspace(*name); name++) ;
X            if (strEQ(name,"-")) {
X                fp = stdin;
X                stio->type = '-';
X            }
X            else
X                fp = fopen(name,"r");
X        }
X        else if (name[len-1] == '|') {
X            name[--len] = '\0';
X            while (len && isspace(name[len-1]))
X                name[--len] = '\0';
X            for (; isspace(*name); name++) ;
X            fp = popen(name,"r");
X            stio->type = '|';
X        }
X        else {
X            stio->type = '<';
X            for (; isspace(*name); name++) ;
X            if (strEQ(name,"-")) {
X                fp = stdin;
X                stio->type = '-';
X            }
X            else
X                fp = fopen(name,"r");
X        }
X    }
X    if (!fp)
X        return FALSE;
X    if (stio->type != '|' && stio->type != '-') {
X        if (fstat(fileno(fp),&statbuf) < 0) {
X            fclose(fp);
X            return FALSE;
X        }
X        if ((statbuf.st_mode & S_IFMT) != S_IFREG &&
X            (statbuf.st_mode & S_IFMT) != S_IFCHR) {
X            fclose(fp);
X            return FALSE;
X        }
X    }
X    stio->fp = fp;
X    return TRUE;
X}
X
XFILE *
Xnextargv(stab)
Xregister STAB *stab;
X{
X    register STR *str;
X    char *oldname;
X
X    while (alen(stab->stab_array) >= 0L) {
X        str = ashift(stab->stab_array);
X        str_sset(stab->stab_val,str);
X        STABSET(stab->stab_val);
X        oldname = str_get(stab->stab_val);
X        if (do_open(stab,oldname)) {
X            if (inplace) {
X                if (*inplace) {
X                    str_cat(str,inplace);
X#ifdef RENAME
X                    rename(oldname,str->str_ptr);
X#else
X                    UNLINK(str->str_ptr);
X                    link(oldname,str->str_ptr);
X                    UNLINK(oldname);
X#endif
X                }
X                sprintf(tokenbuf,">%s",oldname);
X                do_open(argvoutstab,tokenbuf);
X                defoutstab = argvoutstab;
X            }
X            str_free(str);
X            return stab->stab_io->fp;
X        }
X        else
X            fprintf(stderr,"Can't open %s\n",str_get(str));
X        str_free(str);
X    }
X    if (inplace) {
X        do_close(argvoutstab,FALSE);
X        defoutstab = stabent("stdout",TRUE);
X    }
X    return Nullfp;
X}
X
Xbool
Xdo_close(stab,explicit)
XSTAB *stab;
Xbool explicit;
X{
X    bool retval = FALSE;
X    register STIO *stio = stab->stab_io;
X
X    if (!stio)                /* never opened */
X        return FALSE;
X    if (stio->fp) {
X        if (stio->type == '|')
X            retval = (pclose(stio->fp) >= 0);
X        else if (stio->type == '-')
X            retval = TRUE;
X        else
X            retval = (fclose(stio->fp) != EOF);
X        stio->fp = Nullfp;
X    }
X    if (explicit)
X        stio->lines = 0;
X    stio->type = ' ';
X    return retval;
X}
X
Xbool
Xdo_eof(stab)
XSTAB *stab;
X{
X    register STIO *stio;
X    int ch;
X
X    if (!stab)
X        return TRUE;
X
X    stio = stab->stab_io;
X    if (!stio)
X        return TRUE;
X
X    while (stio->fp) {
X
X#ifdef STDSTDIO                        /* (the code works without this) */
X        if (stio->fp->_cnt)                /* cheat a little, since */
X            return FALSE;                /* this is the most usual case */
X#endif
X
X        ch = getc(stio->fp);
X        if (ch != EOF) {
X            ungetc(ch, stio->fp);
X            return FALSE;
X        }
X        if (stio->flags & IOF_ARGV) {        /* not necessarily a real EOF yet? */
X            if (!nextargv(stab))        /* get another fp handy */
X                return TRUE;
X        }
X        else
X            return TRUE;                /* normal fp, definitely end of file */
X    }
X    return TRUE;
X}
X
Xlong
Xdo_tell(stab)
XSTAB *stab;
X{
X    register STIO *stio;
X    int ch;
X
X    if (!stab)
X        return -1L;
X
X    stio = stab->stab_io;
X    if (!stio || !stio->fp)
X        return -1L;
X
X    return ftell(stio->fp);
X}
X
Xbool
Xdo_seek(stab, pos, whence)
XSTAB *stab;
Xlong pos;
Xint whence;
X{
X    register STIO *stio;
X
X    if (!stab)
X        return FALSE;
X
X    stio = stab->stab_io;
X    if (!stio || !stio->fp)
X        return FALSE;
X
X    return fseek(stio->fp, pos, whence) >= 0;
X}
X
Xdo_stat(arg,sarg,retary)
Xregister ARG *arg;
Xregister STR **sarg;
XSTR ***retary;
X{
X    register ARRAY *ary;
X    static ARRAY *myarray = Null(ARRAY*);
X    int max = 13;
X    register int i;
X
X    ary = myarray;
X    if (!ary)
X        myarray = ary = anew();
X    ary->ary_fill = -1;
X    if (arg[1].arg_type == A_LVAL) {
X        tmpstab = arg[1].arg_ptr.arg_stab;
X        if (!tmpstab->stab_io ||
X          fstat(fileno(tmpstab->stab_io->fp),&statbuf) < 0) {
X            max = 0;
X        }
X    }
X    else
X        if (stat(str_get(sarg[1]),&statbuf) < 0)
X            max = 0;
X
X    if (retary) {
X        if (max) {
X            apush(ary,str_nmake((double)statbuf.st_dev));
X            apush(ary,str_nmake((double)statbuf.st_ino));
X            apush(ary,str_nmake((double)statbuf.st_mode));
X            apush(ary,str_nmake((double)statbuf.st_nlink));
X            apush(ary,str_nmake((double)statbuf.st_uid));
X            apush(ary,str_nmake((double)statbuf.st_gid));
X            apush(ary,str_nmake((double)statbuf.st_rdev));
X            apush(ary,str_nmake((double)statbuf.st_size));
X            apush(ary,str_nmake((double)statbuf.st_atime));
X            apush(ary,str_nmake((double)statbuf.st_mtime));
X            apush(ary,str_nmake((double)statbuf.st_ctime));
X            apush(ary,str_nmake((double)statbuf.st_blksize));
X            apush(ary,str_nmake((double)statbuf.st_blocks));
X        }
X        sarg = (STR**)safemalloc((max+2)*sizeof(STR*));
X        sarg[0] = Nullstr;
X        sarg[max+1] = Nullstr;
X        for (i = 1; i <= max; i++)
X            sarg[i] = afetch(ary,i-1);
X        *retary = sarg;
X    }
X    return max;
X}
X
Xdo_tms(retary)
XSTR ***retary;
X{
X    register ARRAY *ary;
X    static ARRAY *myarray = Null(ARRAY*);
X    register STR **sarg;
X    int max = 4;
X    register int i;
X
X    ary = myarray;
X    if (!ary)
X        myarray = ary = anew();
X    ary->ary_fill = -1;
X    if (times(&timesbuf) < 0)
X        max = 0;
X
X    if (retary) {
X        if (max) {
X            apush(ary,str_nmake(((double)timesbuf.tms_utime)/60.0));
X            apush(ary,str_nmake(((double)timesbuf.tms_stime)/60.0));
X            apush(ary,str_nmake(((double)timesbuf.tms_cutime)/60.0));
X            apush(ary,str_nmake(((double)timesbuf.tms_cstime)/60.0));
X        }
X        sarg = (STR**)safemalloc((max+2)*sizeof(STR*));
X        sarg[0] = Nullstr;
X        sarg[max+1] = Nullstr;
X        for (i = 1; i <= max; i++)
X            sarg[i] = afetch(ary,i-1);
X        *retary = sarg;
X    }
X    return max;
X}
X
Xdo_time(tmbuf,retary)
Xstruct tm *tmbuf;
XSTR ***retary;
X{
X    register ARRAY *ary;
X    static ARRAY *myarray = Null(ARRAY*);
X    register STR **sarg;
X    int max = 9;
X    register int i;
X    STR *str;
X
X    ary = myarray;
X    if (!ary)
X        myarray = ary = anew();
X    ary->ary_fill = -1;
X    if (!tmbuf)
X        max = 0;
X
X    if (retary) {
X        if (max) {
X            apush(ary,str_nmake((double)tmbuf->tm_sec));
X            apush(ary,str_nmake((double)tmbuf->tm_min));
X            apush(ary,str_nmake((double)tmbuf->tm_hour));
X            apush(ary,str_nmake((double)tmbuf->tm_mday));
X            apush(ary,str_nmake((double)tmbuf->tm_mon));
X            apush(ary,str_nmake((double)tmbuf->tm_year));
X            apush(ary,str_nmake((double)tmbuf->tm_wday));
X            apush(ary,str_nmake((double)tmbuf->tm_yday));
X            apush(ary,str_nmake((double)tmbuf->tm_isdst));
X        }
X        sarg = (STR**)safemalloc((max+2)*sizeof(STR*));
X        sarg[0] = Nullstr;
X        sarg[max+1] = Nullstr;
X        for (i = 1; i <= max; i++)
X            sarg[i] = afetch(ary,i-1);
X        *retary = sarg;
X    }
X    return max;
X}
X
Xvoid
Xdo_sprintf(str,len,sarg)
Xregister STR *str;
Xregister int len;
Xregister STR **sarg;
X{
X    register char *s;
X    register char *t;
X    bool dolong;
X    char ch;
X
X    str_set(str,"");
X    len--;                        /* don't count pattern string */
X    sarg++;
X    for (s = str_get(*(sarg++)); *sarg && *s && len; len--) {
X        dolong = FALSE;
X        for (t = s; *t && *t != '%'; t++) ;
X        if (!*t)
X            break;                /* not enough % patterns, oh well */
X        for (t++; *sarg && *t && t != s; t++) {
X            switch (*t) {
X            case '\0':
X                break;
X            case '%':
X                ch = *(++t);
X                *t = '\0';
X                sprintf(buf,s);
X                s = t;
X                *(t--) = ch;
X                break;
X            case 'l':
X                dolong = TRUE;
X                break;
X            case 'D': case 'X': case 'O':
X                dolong = TRUE;
X                /* FALL THROUGH */
X            case 'd': case 'x': case 'o': case 'c':
X                ch = *(++t);
X                *t = '\0';
X                if (dolong)
X                    sprintf(buf,s,(long)str_gnum(*(sarg++)));
X                else
X                    sprintf(buf,s,(int)str_gnum(*(sarg++)));
X                s = t;
X                *(t--) = ch;
X                break;
X            case 'E': case 'e': case 'f': case 'G': case 'g':
X                ch = *(++t);
X                *t = '\0';
X                sprintf(buf,s,str_gnum(*(sarg++)));
X                s = t;
X                *(t--) = ch;
X                break;
X            case 's':
X                ch = *(++t);
X                *t = '\0';
X                sprintf(buf,s,str_get(*(sarg++)));
X                s = t;
X                *(t--) = ch;
X                break;
X            }
X        }
X        str_cat(str,buf);
X    }
X    if (*s)
X        str_cat(str,s);
X    STABSET(str);
X}
X
Xbool
Xdo_print(s,fp)
Xchar *s;
XFILE *fp;
X{
X    if (!fp || !s)
X        return FALSE;
X    fputs(s,fp);
X    return TRUE;
X}
X
Xbool
Xdo_aprint(arg,fp)
Xregister ARG *arg;
Xregister FILE *fp;
X{
X    STR **tmpary;        /* must not be register */
X    register STR **elem;
X    register bool retval;
X    double value;
X
X    (void)eval(arg[1].arg_ptr.arg_arg,&tmpary);
X    if (arg->arg_type == O_PRTF) {
X        do_sprintf(arg->arg_ptr.arg_str,32767,tmpary);
X        retval = do_print(str_get(arg->arg_ptr.arg_str),fp);
X    }
X    else {
X        retval = FALSE;
X        for (elem = tmpary+1; *elem; elem++) {
X            if (retval && ofs)
X                do_print(ofs, fp);
X            if (ofmt && fp) {
X                if ((*elem)->str_nok || str_gnum(*elem) != 0.0)
X                    fprintf(fp, ofmt, str_gnum(*elem));
X                retval = TRUE;
X            }
X            else
X                retval = do_print(str_get(*elem), fp);
X            if (!retval)
X                break;
X        }
X        if (ors)
X            retval = do_print(ors, fp);
X    }
X    safefree((char*)tmpary);
X    return retval;
X}
X
Xbool
Xdo_aexec(arg)
Xregister ARG *arg;
X{
X    STR **tmpary;        /* must not be register */
X    register STR **elem;
X    register char **a;
X    register int i;
X    char **argv;
X
X    (void)eval(arg[1].arg_ptr.arg_arg,&tmpary);
X    i = 0;
X    for (elem = tmpary+1; *elem; elem++)
X        i++;
X    if (i) {
X        argv = (char**)safemalloc((i+1)*sizeof(char*));
X        a = argv;
X        for (elem = tmpary+1; *elem; elem++) {
X            *a++ = str_get(*elem);
X        }
X        *a = Nullch;
X        execvp(argv[0],argv);
X        safefree((char*)argv);
X    }
X    safefree((char*)tmpary);
X    return FALSE;
X}
X
Xbool
Xdo_exec(cmd)
Xchar *cmd;
X{
X    STR **tmpary;        /* must not be register */
X    register char **a;
X    register char *s;
X    char **argv;
X
X    /* see if there are shell metacharacters in it */
X
X    for (s = cmd; *s; s++) {
X        if (*s != ' ' && !isalpha(*s) && index("$&*(){}[]'\";\\|?<>~`",*s)) {
X            execl("/bin/sh","sh","-c",cmd,0);
X            return FALSE;
X        }
X    }
X    argv = (char**)safemalloc(((s - cmd) / 2 + 2)*sizeof(char*));
X
X    a = argv;
X    for (s = cmd; *s;) {
X        while (isspace(*s)) s++;
X        if (*s)
X            *(a++) = s;
X        while (*s && !isspace(*s)) s++;
X        if (*s)
X            *s++ = '\0';
X    }
X    *a = Nullch;
X    if (argv[0])
X        execvp(argv[0],argv);
X    safefree((char*)argv);
X    return FALSE;
X}
X
XSTR *
Xdo_push(arg,ary)
Xregister ARG *arg;
Xregister ARRAY *ary;
X{
X    STR **tmpary;        /* must not be register */
X    register STR **elem;
X    register STR *str = &str_no;
X
X    (void)eval(arg[1].arg_ptr.arg_arg,&tmpary);
X    for (elem = tmpary+1; *elem; elem++) {
X        str = str_new(0);
X        str_sset(str,*elem);
X        apush(ary,str);
X    }
X    safefree((char*)tmpary);
X    return str;
X}
X
Xdo_unshift(arg,ary)
Xregister ARG *arg;
Xregister ARRAY *ary;
X{
X    STR **tmpary;        /* must not be register */
X    register STR **elem;
X    register STR *str = &str_no;
X    register int i;
X
X    (void)eval(arg[1].arg_ptr.arg_arg,&tmpary);
X    i = 0;
X    for (elem = tmpary+1; *elem; elem++)
X        i++;
X    aunshift(ary,i);
X    i = 0;
X    for (elem = tmpary+1; *elem; elem++) {
X        str = str_new(0);
X        str_sset(str,*elem);
X        astore(ary,i++,str);
X    }
X    safefree((char*)tmpary);
X}
X
Xapply(type,arg,sarg)
Xint type;
Xregister ARG *arg;
XSTR **sarg;
X{
X    STR **tmpary;        /* must not be register */
X    register STR **elem;
X    register int i;
X    register int val;
X    register int val2;
X
X    if (sarg)
X        tmpary = sarg;
X    else
X        (void)eval(arg[1].arg_ptr.arg_arg,&tmpary);
X    i = 0;
X    for (elem = tmpary+1; *elem; elem++)
X        i++;
X    switch (type) {
X    case O_CHMOD:
X        if (--i > 0) {
X            val = (int)str_gnum(tmpary[1]);
X            for (elem = tmpary+2; *elem; elem++)
X                if (chmod(str_get(*elem),val))
X                    i--;
X        }
X        break;
X    case O_CHOWN:
X        if (i > 2) {
X            i -= 2;
X            val = (int)str_gnum(tmpary[1]);
X            val2 = (int)str_gnum(tmpary[2]);
X            for (elem = tmpary+3; *elem; elem++)
X                if (chown(str_get(*elem),val,val2))
X                    i--;
X        }
X        else
X            i = 0;
X        break;
X    case O_KILL:
X        if (--i > 0) {
X            val = (int)str_gnum(tmpary[1]);
X            if (val < 0)
X                val = -val;
X            for (elem = tmpary+2; *elem; elem++)
X                if (kill(atoi(str_get(*elem)),val))
X                    i--;
X        }
X        break;
X    case O_UNLINK:
X        for (elem = tmpary+1; *elem; elem++)
X            if (UNLINK(str_get(*elem)))
X                i--;
X        break;
X    }
X    if (!sarg)
X        safefree((char*)tmpary);
X    return i;
X}
X
XSTR *
Xdo_subr(arg,sarg)
Xregister ARG *arg;
Xregister char **sarg;
X{
X    ARRAY *savearray;
X    STR *str;
X
X    savearray = defstab->stab_array;
X    defstab->stab_array = anew();
X    if (arg[1].arg_flags & AF_SPECIAL)
X        (void)do_push(arg,defstab->stab_array);
X    else if (arg[1].arg_type != A_NULL) {
X        str = str_new(0);
X        str_sset(str,sarg[1]);
X        apush(defstab->stab_array,str);
X    }
X    str = cmd_exec(arg[2].arg_ptr.arg_stab->stab_sub);
X    afree(defstab->stab_array);  /* put back old $_[] */
X    defstab->stab_array = savearray;
X    return str;
X}
X
Xvoid
Xdo_assign(retstr,arg)
XSTR *retstr;
Xregister ARG *arg;
X{
X    STR **tmpary;        /* must not be register */
X    register ARG *larg = arg[1].arg_ptr.arg_arg;
X    register STR **elem;
X    register STR *str;
X    register ARRAY *ary;
X    register int i;
X    register int lasti;
X    char *s;
X
X    (void)eval(arg[2].arg_ptr.arg_arg,&tmpary);
X
X    if (arg->arg_flags & AF_COMMON) {
X        if (*(tmpary+1)) {
X            for (elem=tmpary+2; *elem; elem++) {
X                *elem = str_static(*elem);
X            }
X        }
X    }
X    if (larg->arg_type == O_LIST) {
X        lasti = larg->arg_len;
X        for (i=1,elem=tmpary+1; i <= lasti; i++) {
X            if (*elem)
X                s = str_get(*(elem++));
X            else
X                s = "";
X            switch (larg[i].arg_type) {
X            case A_STAB:
X            case A_LVAL:
X                str = STAB_STR(larg[i].arg_ptr.arg_stab);
X                break;
X            case A_LEXPR:
X                str = eval(larg[i].arg_ptr.arg_arg,Null(STR***));
X                break;
X            }
X            str_set(str,s);
X            STABSET(str);
X        }
X        i = elem - tmpary - 1;
X    }
X    else {                        /* should be an array name */
X        ary = larg[1].arg_ptr.arg_stab->stab_array;
X        for (i=0,elem=tmpary+1; *elem; i++) {
X            str = str_new(0);
X            if (*elem)
X                str_sset(str,*(elem++));
X            astore(ary,i,str);
X        }
X        ary->ary_fill = i - 1;        /* they can get the extra ones back by */
X    }                                /*   setting an element larger than old fill */
X    str_numset(retstr,(double)i);
X    STABSET(retstr);
X    safefree((char*)tmpary);
X}
X
Xint
Xdo_kv(hash,kv,sarg,retary)
XHASH *hash;
Xint kv;
Xregister STR **sarg;
XSTR ***retary;
X{
X    register ARRAY *ary;
X    int max = 0;
X    int i;
X    static ARRAY *myarray = Null(ARRAY*);
X    register HENT *entry;
X
X    ary = myarray;
X    if (!ary)
X        myarray = ary = anew();
X    ary->ary_fill = -1;
X
X    hiterinit(hash);
X    while (entry = hiternext(hash)) {
X        max++;
X        if (kv == O_KEYS)
X            apush(ary,str_make(hiterkey(entry)));
X        else
X            apush(ary,str_make(str_get(hiterval(entry))));
X    }
X    if (retary) { /* array wanted */
X        sarg = (STR**)saferealloc((char*)sarg,(max+2)*sizeof(STR*));
X        sarg[0] = Nullstr;
X        sarg[max+1] = Nullstr;
X        for (i = 1; i <= max; i++)
X            sarg[i] = afetch(ary,i-1);
X        *retary = sarg;
X    }
X    return max;
X}
X
XSTR *
Xdo_each(hash,sarg,retary)
XHASH *hash;
Xregister STR **sarg;
XSTR ***retary;
X{
X    static STR *mystr = Nullstr;
X    STR *retstr;
X    HENT *entry = hiternext(hash);
X
X    if (mystr) {
X        str_free(mystr);
X        mystr = Nullstr;
X    }
X
X    if (retary) { /* array wanted */
X        if (entry) {
X            sarg = (STR**)saferealloc((char*)sarg,4*sizeof(STR*));
X            sarg[0] = Nullstr;
X            sarg[3] = Nullstr;
X            sarg[1] = mystr = str_make(hiterkey(entry));
X            retstr = sarg[2] = hiterval(entry);
X            *retary = sarg;
X        }
X        else {
X            sarg = (STR**)saferealloc((char*)sarg,2*sizeof(STR*));
X            sarg[0] = Nullstr;
X            sarg[1] = retstr = Nullstr;
X            *retary = sarg;
X        }
X    }
X    else
X        retstr = hiterval(entry);
X        
X    return retstr;
X}
X
Xinit_eval()
X{
X    register int i;
X
X#define A(e1,e2,e3) (e1+(e2<<1)+(e3<<2))
X    opargs[O_ITEM] =                A(1,0,0);
X    opargs[O_ITEM2] =                A(0,0,0);
X    opargs[O_ITEM3] =                A(0,0,0);
X    opargs[O_CONCAT] =                A(1,1,0);
X    opargs[O_MATCH] =                A(1,0,0);
X    opargs[O_NMATCH] =                A(1,0,0);
X    opargs[O_SUBST] =                A(1,0,0);
X    opargs[O_NSUBST] =                A(1,0,0);
X    opargs[O_ASSIGN] =                A(1,1,0);
X    opargs[O_MULTIPLY] =        A(1,1,0);
X    opargs[O_DIVIDE] =                A(1,1,0);
X    opargs[O_MODULO] =                A(1,1,0);
X    opargs[O_ADD] =                A(1,1,0);
X    opargs[O_SUBTRACT] =        A(1,1,0);
X    opargs[O_LEFT_SHIFT] =        A(1,1,0);
X    opargs[O_RIGHT_SHIFT] =        A(1,1,0);
X    opargs[O_LT] =                A(1,1,0);
X    opargs[O_GT] =                A(1,1,0);
X    opargs[O_LE] =                A(1,1,0);
X    opargs[O_GE] =                A(1,1,0);
X    opargs[O_EQ] =                A(1,1,0);
X    opargs[O_NE] =                A(1,1,0);
X    opargs[O_BIT_AND] =                A(1,1,0);
X    opargs[O_XOR] =                A(1,1,0);
X    opargs[O_BIT_OR] =                A(1,1,0);
X    opargs[O_AND] =                A(1,0,0);        /* don't eval arg 2 (yet) */
X    opargs[O_OR] =                A(1,0,0);        /* don't eval arg 2 (yet) */
X    opargs[O_COND_EXPR] =        A(1,0,0);        /* don't eval args 2 or 3 */
X    opargs[O_COMMA] =                A(1,1,0);
X    opargs[O_NEGATE] =                A(1,0,0);
X    opargs[O_NOT] =                A(1,0,0);
X    opargs[O_COMPLEMENT] =        A(1,0,0);
X    opargs[O_WRITE] =                A(1,0,0);
X    opargs[O_OPEN] =                A(1,1,0);
X    opargs[O_TRANS] =                A(1,0,0);
X    opargs[O_NTRANS] =                A(1,0,0);
X    opargs[O_CLOSE] =                A(0,0,0);
X    opargs[O_ARRAY] =                A(1,0,0);
X    opargs[O_HASH] =                A(1,0,0);
X    opargs[O_LARRAY] =                A(1,0,0);
X    opargs[O_LHASH] =                A(1,0,0);
X    opargs[O_PUSH] =                A(1,0,0);
X    opargs[O_POP] =                A(0,0,0);
X    opargs[O_SHIFT] =                A(0,0,0);
X    opargs[O_SPLIT] =                A(1,0,0);
X    opargs[O_LENGTH] =                A(1,0,0);
X    opargs[O_SPRINTF] =                A(1,0,0);
X    opargs[O_SUBSTR] =                A(1,1,1);
X    opargs[O_JOIN] =                A(1,0,0);
X    opargs[O_SLT] =                A(1,1,0);
X    opargs[O_SGT] =                A(1,1,0);
X    opargs[O_SLE] =                A(1,1,0);
X    opargs[O_SGE] =                A(1,1,0);
X    opargs[O_SEQ] =                A(1,1,0);
X    opargs[O_SNE] =                A(1,1,0);
X    opargs[O_SUBR] =                A(1,0,0);
X    opargs[O_PRINT] =                A(1,0,0);
X    opargs[O_CHDIR] =                A(1,0,0);
X    opargs[O_DIE] =                A(1,0,0);
X    opargs[O_EXIT] =                A(1,0,0);
X    opargs[O_RESET] =                A(1,0,0);
X    opargs[O_LIST] =                A(0,0,0);
X    opargs[O_EOF] =                A(0,0,0);
X    opargs[O_TELL] =                A(0,0,0);
X    opargs[O_SEEK] =                A(0,1,1);
X    opargs[O_LAST] =                A(1,0,0);
X    opargs[O_NEXT] =                A(1,0,0);
X    opargs[O_REDO] =                A(1,0,0);
X    opargs[O_GOTO] =                A(1,0,0);
X    opargs[O_INDEX] =                A(1,1,0);
X    opargs[O_TIME] =                 A(0,0,0);
X    opargs[O_TMS] =                 A(0,0,0);
X    opargs[O_LOCALTIME] =        A(1,0,0);
X    opargs[O_GMTIME] =                A(1,0,0);
X    opargs[O_STAT] =                A(1,0,0);
X    opargs[O_CRYPT] =                A(1,1,0);
X    opargs[O_EXP] =                A(1,0,0);
X    opargs[O_LOG] =                A(1,0,0);
X    opargs[O_SQRT] =                A(1,0,0);
X    opargs[O_INT] =                A(1,0,0);
X    opargs[O_PRTF] =                A(1,0,0);
X    opargs[O_ORD] =                 A(1,0,0);
X    opargs[O_SLEEP] =                A(1,0,0);
X    opargs[O_FLIP] =                A(1,0,0);
X    opargs[O_FLOP] =                A(0,1,0);
X    opargs[O_KEYS] =                A(0,0,0);
X    opargs[O_VALUES] =                A(0,0,0);
X    opargs[O_EACH] =                A(0,0,0);
X    opargs[O_CHOP] =                A(1,0,0);
X    opargs[O_FORK] =                A(1,0,0);
X    opargs[O_EXEC] =                A(1,0,0);
X    opargs[O_SYSTEM] =                A(1,0,0);
X    opargs[O_OCT] =                A(1,0,0);
X    opargs[O_HEX] =                A(1,0,0);
X    opargs[O_CHMOD] =                A(1,0,0);
X    opargs[O_CHOWN] =                A(1,0,0);
X    opargs[O_KILL] =                A(1,0,0);
X    opargs[O_RENAME] =                A(1,1,0);
X    opargs[O_UNLINK] =                A(1,0,0);
X    opargs[O_UMASK] =                A(1,0,0);
X    opargs[O_UNSHIFT] =                A(1,0,0);
X    opargs[O_LINK] =                A(1,1,0);
X    opargs[O_REPEAT] =                A(1,1,0);
X}
X
Xstatic int (*ihand)();
Xstatic int (*qhand)();
X
XSTR *
Xeval(arg,retary)
Xregister ARG *arg;
XSTR ***retary;                /* where to return an array to, null if nowhere */
X{
X    register STR *str;
X    register int anum;
X    register int optype;
X    register int maxarg;
X    double value;
X    STR *quicksarg[5];
X    register STR **sarg = quicksarg;
X    register char *tmps;
X    char *tmps2;
X    int argflags;
X    long tmplong;
X    FILE *fp;
X    STR *tmpstr;
X    FCMD *form;
X    STAB *stab;
X    ARRAY *ary;
X    bool assigning = FALSE;
X    double exp(), log(), sqrt(), modf();
X    char *crypt(), *getenv();
X
X    if (!arg)
X        return &str_no;
X    str = arg->arg_ptr.arg_str;
X    optype = arg->arg_type;
X    maxarg = arg->arg_len;
X    if (maxarg > 3 || retary) {
X        sarg = (STR **)safemalloc((maxarg+2) * sizeof(STR*));
X    }
X#ifdef DEBUGGING
X    if (debug & 8) {
X        deb("%s (%lx) %d args:\n",opname[optype],arg,maxarg);
X    }
X    debname[dlevel] = opname[optype][0];
X    debdelim[dlevel++] = ':';
X#endif
X    for (anum = 1; anum <= maxarg; anum++) {
X        argflags = arg[anum].arg_flags;
X        if (argflags & AF_SPECIAL)
X            continue;
X      re_eval:
X        switch (arg[anum].arg_type) {
X        default:
X            sarg[anum] = &str_no;
X#ifdef DEBUGGING
X            tmps = "NULL";
X#endif
X            break;
X        case A_EXPR:
X#ifdef DEBUGGING
X            if (debug & 8) {
X                tmps = "EXPR";
X                deb("%d.EXPR =>\n",anum);
X            }
X#endif
X            sarg[anum] = eval(arg[anum].arg_ptr.arg_arg, Null(STR***));
X            break;
X        case A_CMD:
X#ifdef DEBUGGING
X            if (debug & 8) {
X                tmps = "CMD";
X                deb("%d.CMD (%lx) =>\n",anum,arg[anum].arg_ptr.arg_cmd);
X            }
X#endif
X            sarg[anum] = cmd_exec(arg[anum].arg_ptr.arg_cmd);
X            break;
X        case A_STAB:
X            sarg[anum] = STAB_STR(arg[anum].arg_ptr.arg_stab);
X#ifdef DEBUGGING
X            if (debug & 8) {
X                sprintf(buf,"STAB $%s ==",arg[anum].arg_ptr.arg_stab->stab_name);
X                tmps = buf;
X            }
X#endif
X            break;
X        case A_LEXPR:
X#ifdef DEBUGGING
X            if (debug & 8) {
X                tmps = "LEXPR";
X                deb("%d.LEXPR =>\n",anum);
X            }
X#endif
X            str = eval(arg[anum].arg_ptr.arg_arg,Null(STR***));
X            if (!str)
X                fatal("panic: A_LEXPR\n");
X            goto do_crement;
X        case A_LVAL:
X#ifdef DEBUGGING
X            if (debug & 8) {
X                sprintf(buf,"LVAL $%s ==",arg[anum].arg_ptr.arg_stab->stab_name);
X                tmps = buf;
X            }
X#endif
X            str = STAB_STR(arg[anum].arg_ptr.arg_stab);
X            if (!str)
X                fatal("panic: A_LVAL\n");
X          do_crement:
X            assigning = TRUE;
X            if (argflags & AF_PRE) {
X                if (argflags & AF_UP)
X                    str_inc(str);
X                else
X                    str_dec(str);
X                STABSET(str);
X                sarg[anum] = str;
X                str = arg->arg_ptr.arg_str;
X            }
X            else if (argflags & AF_POST) {
X                sarg[anum] = str_static(str);
X                if (argflags & AF_UP)
X                    str_inc(str);
X                else
X                    str_dec(str);
X                STABSET(str);
X                str = arg->arg_ptr.arg_str;
X            }
X            else {
X                sarg[anum] = str;
X            }
X            break;
X        case A_ARYLEN:
X            sarg[anum] = str_static(&str_no);
X            str_numset(sarg[anum],
X                (double)alen(arg[anum].arg_ptr.arg_stab->stab_array));
X#ifdef DEBUGGING
X            tmps = "ARYLEN";
X#endif
X            break;
X        case A_SINGLE:
X            sarg[anum] = arg[anum].arg_ptr.arg_str;
X#ifdef DEBUGGING
X            tmps = "SINGLE";
X#endif
X            break;
X        case A_DOUBLE:
X            (void) interp(str,str_get(arg[anum].arg_ptr.arg_str));
X            sarg[anum] = str;
X#ifdef DEBUGGING
X            tmps = "DOUBLE";
X#endif
X            break;
X        case A_BACKTICK:
X            tmps = str_get(arg[anum].arg_ptr.arg_str);
X            fp = popen(str_get(interp(str,tmps)),"r");
X            tmpstr = str_new(80);
X            str_set(str,"");
X            if (fp) {
X                while (str_gets(tmpstr,fp) != Nullch) {
X                    str_scat(str,tmpstr);
X                }
X                statusvalue = pclose(fp);
X            }
X            else
X                statusvalue = -1;
X            str_free(tmpstr);
X
X            sarg[anum] = str;
X#ifdef DEBUGGING
X            tmps = "BACK";
X#endif
X            break;
X        case A_READ:
X            fp = Nullfp;
X            last_in_stab = arg[anum].arg_ptr.arg_stab;
X            if (last_in_stab->stab_io) {
X                fp = last_in_stab->stab_io->fp;
X                if (!fp && (last_in_stab->stab_io->flags & IOF_ARGV)) {
X                    if (last_in_stab->stab_io->flags & IOF_START) {
X                        last_in_stab->stab_io->flags &= ~IOF_START;
X                        last_in_stab->stab_io->lines = 0;
X                        if (alen(last_in_stab->stab_array) < 0L) {
X                            tmpstr = str_make("-");        /* assume stdin */
X                            apush(last_in_stab->stab_array, tmpstr);
X                        }
X                    }
X                    fp = nextargv(last_in_stab);
X                    if (!fp)        /* Note: fp != last_in_stab->stab_io->fp */
X                        do_close(last_in_stab,FALSE);        /* now it does */
X                }
X            }
X          keepgoing:
X            if (!fp)
X                sarg[anum] = &str_no;
X            else if (!str_gets(str,fp)) {
X                if (last_in_stab->stab_io->flags & IOF_ARGV) {
X                    fp = nextargv(last_in_stab);
X                    if (fp)
X                        goto keepgoing;
X                    do_close(last_in_stab,FALSE);
X                    last_in_stab->stab_io->flags |= IOF_START;
X                }
X                if (fp == stdin) {
X                    clearerr(fp);
X                }
X                sarg[anum] = &str_no;
X                break;
X            }
X            else {
X                last_in_stab->stab_io->lines++;
X                sarg[anum] = str;
X            }
X#ifdef DEBUGGING
X            tmps = "READ";
X#endif
X            break;
X        }
X#ifdef DEBUGGING
X        if (debug & 8)
X            deb("%d.%s = '%s'\n",anum,tmps,str_peek(sarg[anum]));
X#endif
X    }
X    switch (optype) {
X    case O_ITEM:
X        if (str != sarg[1])
X            str_sset(str,sarg[1]);
X        STABSET(str);
X        break;
X    case O_ITEM2:
X        if (str != sarg[2])
X            str_sset(str,sarg[2]);
X        STABSET(str);
X        break;
X    case O_ITEM3:
X        if (str != sarg[3])
X            str_sset(str,sarg[3]);
X        STABSET(str);
X        break;
X    case O_CONCAT:
X        if (str != sarg[1])
X            str_sset(str,sarg[1]);
X        str_scat(str,sarg[2]);
X        STABSET(str);
X        break;
X    case O_REPEAT:
X        if (str != sarg[1])
X            str_sset(str,sarg[1]);
X        anum = (long)str_gnum(sarg[2]);
X        if (anum >= 1) {
X            tmpstr = str_new(0);
X            str_sset(tmpstr,str);
X            for (anum--; anum; anum--)
X                str_scat(str,tmpstr);
X        }
X        else
X            str_sset(str,&str_no);
X        STABSET(str);
X        break;
X    case O_MATCH:
X        str_set(str, do_match(str_get(sarg[1]),arg) ? Yes : No);
X        STABSET(str);
X        break;
X    case O_NMATCH:
X        str_set(str, do_match(str_get(sarg[1]),arg) ? No : Yes);
X        STABSET(str);
X        break;
X    case O_SUBST:
X        value = (double) do_subst(str, arg);
X        str = arg->arg_ptr.arg_str;
X        goto donumset;
X    case O_NSUBST:
X        str_set(arg->arg_ptr.arg_str, do_subst(str, arg) ? No : Yes);
X        str = arg->arg_ptr.arg_str;
X        break;
X    case O_ASSIGN:
X        if (arg[2].arg_flags & AF_SPECIAL)
X            do_assign(str,arg);
X        else {
X            if (str != sarg[2])
X                str_sset(str, sarg[2]);
X            STABSET(str);
X        }
X        break;
X    case O_CHOP:
X        tmps = str_get(str);
X        tmps += str->str_cur - (str->str_cur != 0);
X        str_set(arg->arg_ptr.arg_str,tmps);        /* remember last char */
X        *tmps = '\0';                                /* wipe it out */
X        str->str_cur = tmps - str->str_ptr;
X        str->str_nok = 0;
X        str = arg->arg_ptr.arg_str;
X        break;
X    case O_MULTIPLY:
X        value = str_gnum(sarg[1]);
X        value *= str_gnum(sarg[2]);
X        goto donumset;
X    case O_DIVIDE:
X        value = str_gnum(sarg[1]);
X        value /= str_gnum(sarg[2]);
X        goto donumset;
X    case O_MODULO:
X        value = str_gnum(sarg[1]);
X        value = (double)(((long)value) % (long)str_gnum(sarg[2]));
X        goto donumset;
X    case O_ADD:
X        value = str_gnum(sarg[1]);
X        value += str_gnum(sarg[2]);
X        goto donumset;
X    case O_SUBTRACT:
X        value = str_gnum(sarg[1]);
X        value -= str_gnum(sarg[2]);
X        goto donumset;
X    case O_LEFT_SHIFT:
X        value = str_gnum(sarg[1]);
X        value = (double)(((long)value) << (long)str_gnum(sarg[2]));
X        goto donumset;
X    case O_RIGHT_SHIFT:
X        value = str_gnum(sarg[1]);
X        value = (double)(((long)value) >> (long)str_gnum(sarg[2]));
X        goto donumset;
X    case O_LT:
X        value = str_gnum(sarg[1]);
X        value = (double)(value < str_gnum(sarg[2]));
X        goto donumset;
X    case O_GT:
X        value = str_gnum(sarg[1]);
X        value = (double)(value > str_gnum(sarg[2]));
X        goto donumset;
X    case O_LE:
X        value = str_gnum(sarg[1]);
X        value = (double)(value <= str_gnum(sarg[2]));
X        goto donumset;
X    case O_GE:
X        value = str_gnum(sarg[1]);
X        value = (double)(value >= str_gnum(sarg[2]));
X        goto donumset;
X    case O_EQ:
X        value = str_gnum(sarg[1]);
X        value = (double)(value == str_gnum(sarg[2]));
X        goto donumset;
X    case O_NE:
X        value = str_gnum(sarg[1]);
X        value = (double)(value != str_gnum(sarg[2]));
X        goto donumset;
X    case O_BIT_AND:
X        value = str_gnum(sarg[1]);
X        value = (double)(((long)value) & (long)str_gnum(sarg[2]));
X        goto donumset;
X    case O_XOR:
X        value = str_gnum(sarg[1]);
X        value = (double)(((long)value) ^ (long)str_gnum(sarg[2]));
X        goto donumset;
X    case O_BIT_OR:
X        value = str_gnum(sarg[1]);
X        value = (double)(((long)value) | (long)str_gnum(sarg[2]));
X        goto donumset;
X    case O_AND:
X        if (str_true(sarg[1])) {
X            anum = 2;
X            optype = O_ITEM2;
X            maxarg = 0;
X            argflags = arg[anum].arg_flags;
X            goto re_eval;
X        }
X        else {
X            if (assigning) {
X                str_sset(str, sarg[1]);
X                STABSET(str);
X            }
X            else
X                str = sarg[1];
X            break;
X        }
X    case O_OR:
X        if (str_true(sarg[1])) {
X            if (assigning) {
X                str_set(str, sarg[1]);
X                STABSET(str);
X            }
X            else
X                str = sarg[1];
X            break;
X        }
X        else {
X            anum = 2;
X            optype = O_ITEM2;
X            maxarg = 0;
X            argflags = arg[anum].arg_flags;
X            goto re_eval;
X        }
X    case O_COND_EXPR:
X        anum = (str_true(sarg[1]) ? 2 : 3);
X        optype = (anum == 2 ? O_ITEM2 : O_ITEM3);
X        maxarg = 0;
X        argflags = arg[anum].arg_flags;
X        goto re_eval;
X    case O_COMMA:
X        str = sarg[2];
X        break;
X    case O_NEGATE:
X        value = -str_gnum(sarg[1]);
X        goto donumset;
X    case O_NOT:
X        value = (double) !str_true(sarg[1]);
X        goto donumset;
X    case O_COMPLEMENT:
X        value = (double) ~(long)str_gnum(sarg[1]);
X        goto donumset;
X    case O_SELECT:
X        if (arg[1].arg_type == A_LVAL)
X            defoutstab = arg[1].arg_ptr.arg_stab;
X        else
X            defoutstab = stabent(str_get(sarg[1]),TRUE);
X        if (!defoutstab->stab_io)
X            defoutstab->stab_io = stio_new();
X        curoutstab = defoutstab;
X        str_set(str,curoutstab->stab_io->fp ? Yes : No);
X        STABSET(str);
X        break;
X    case O_WRITE:
X        if (maxarg == 0)
X            stab = defoutstab;
X        else if (arg[1].arg_type == A_LVAL)
X            stab = arg[1].arg_ptr.arg_stab;
X        else
X            stab = stabent(str_get(sarg[1]),TRUE);
X        if (!stab->stab_io) {
X            str_set(str, No);
X            STABSET(str);
X            break;
X        }
X        curoutstab = stab;
X        fp = stab->stab_io->fp;
X        debarg = arg;
X        if (stab->stab_io->fmt_stab)
X            form = stab->stab_io->fmt_stab->stab_form;
X        else
X            form = stab->stab_form;
X        if (!form || !fp) {
X            str_set(str, No);
X            STABSET(str);
X            break;
X        }
X        format(&outrec,form);
X        do_write(&outrec,stab->stab_io);
X        if (stab->stab_io->flags & IOF_FLUSH)
X            fflush(fp);
X        str_set(str, Yes);
X        STABSET(str);
X        break;
X    case O_OPEN:
X        if (do_open(arg[1].arg_ptr.arg_stab,str_get(sarg[2]))) {
X            str_set(str, Yes);
X            arg[1].arg_ptr.arg_stab->stab_io->lines = 0;
X        }
X        else
X            str_set(str, No);
X        STABSET(str);
X        break;
X    case O_TRANS:
X        value = (double) do_trans(str,arg);
X        str = arg->arg_ptr.arg_str;
X        goto donumset;
X    case O_NTRANS:
X        str_set(arg->arg_ptr.arg_str, do_trans(str,arg) == 0 ? Yes : No);
X        str = arg->arg_ptr.arg_str;
X        break;
X    case O_CLOSE:
X        str_set(str,
X            do_close(arg[1].arg_ptr.arg_stab,TRUE) ? Yes : No );
X        STABSET(str);
X        break;
X    case O_EACH:
X        str_sset(str,do_each(arg[1].arg_ptr.arg_stab->stab_hash,sarg,retary));
X        retary = Null(STR***);                /* do_each already did retary */
X        STABSET(str);
X        break;
X    case O_VALUES:
X    case O_KEYS:
X        value = (double) do_kv(arg[1].arg_ptr.arg_stab->stab_hash,
X          optype,sarg,retary);
X        retary = Null(STR***);                /* do_keys already did retary */
X        goto donumset;
X    case O_ARRAY:
X        if (maxarg == 1) {
X            ary = arg[1].arg_ptr.arg_stab->stab_array;
X            maxarg = ary->ary_fill;
X            if (retary) { /* array wanted */
X                sarg =
X                  (STR **)saferealloc((char*)sarg,(maxarg+3)*sizeof(STR*));
X                for (anum = 0; anum <= maxarg; anum++) {
X                    sarg[anum+1] = str = afetch(ary,anum);
X                }
X                maxarg++;
X            }
X            else
X                str = afetch(ary,maxarg);
X        }
X        else
X            str = afetch(arg[2].arg_ptr.arg_stab->stab_array,
X                ((int)str_gnum(sarg[1])) - arybase);
X        if (!str)
X            return &str_no;
X        break;
X    case O_HASH:
X        tmpstab = arg[2].arg_ptr.arg_stab;                /* XXX */
X        str = hfetch(tmpstab->stab_hash,str_get(sarg[1]));
X        if (!str)
X            return &str_no;
X        break;
X    case O_LARRAY:
X        anum = ((int)str_gnum(sarg[1])) - arybase;
X        str = afetch(arg[2].arg_ptr.arg_stab->stab_array,anum);
X        if (!str || str == &str_no) {
X            str = str_new(0);
X            astore(arg[2].arg_ptr.arg_stab->stab_array,anum,str);
X        }
X        break;
X    case O_LHASH:
X        tmpstab = arg[2].arg_ptr.arg_stab;
X        str = hfetch(tmpstab->stab_hash,str_get(sarg[1]));
X        if (!str) {
X            str = str_new(0);
X            hstore(tmpstab->stab_hash,str_get(sarg[1]),str);
X        }
X        if (tmpstab == envstab) {        /* heavy wizardry going on here */
X            str->str_link.str_magic = tmpstab;/* str is now magic */
X            envname = savestr(str_get(sarg[1]));
X                                        /* he threw the brick up into the air */
X        }
X        else if (tmpstab == sigstab) {        /* same thing, only different */
X            str->str_link.str_magic = tmpstab;
X            signame = savestr(str_get(sarg[1]));
X        }
X        break;
X    case O_PUSH:
X        if (arg[1].arg_flags & AF_SPECIAL)
X            str = do_push(arg,arg[2].arg_ptr.arg_stab->stab_array);
X        else {
X            str = str_new(0);                /* must copy the STR */
X            str_sset(str,sarg[1]);
X            apush(arg[2].arg_ptr.arg_stab->stab_array,str);
X        }
X        break;
X    case O_POP:
X        str = apop(arg[1].arg_ptr.arg_stab->stab_array);
X        if (!str)
X            return &str_no;
X#ifdef STRUCTCOPY
X        *(arg->arg_ptr.arg_str) = *str;
X#else
X        bcopy((char*)str, (char*)arg->arg_ptr.arg_str, sizeof *str);
X#endif
X        safefree((char*)str);
X        str = arg->arg_ptr.arg_str;
X        break;
X    case O_SHIFT:
X        str = ashift(arg[1].arg_ptr.arg_stab->stab_array);
X        if (!str)
X            return &str_no;
X#ifdef STRUCTCOPY
X        *(arg->arg_ptr.arg_str) = *str;
X#else
X        bcopy((char*)str, (char*)arg->arg_ptr.arg_str, sizeof *str);
X#endif
X        safefree((char*)str);
X        str = arg->arg_ptr.arg_str;
X        break;
X    case O_SPLIT:
X        value = (double) do_split(str_get(sarg[1]),arg[2].arg_ptr.arg_spat,retary);
X        retary = Null(STR***);                /* do_split already did retary */
X        goto donumset;
X    case O_LENGTH:
X        value = (double) str_len(sarg[1]);
X        goto donumset;
X    case O_SPRINTF:
X        sarg[maxarg+1] = Nullstr;
X        do_sprintf(str,arg->arg_len,sarg);
X        break;
X    case O_SUBSTR:
X        anum = ((int)str_gnum(sarg[2])) - arybase;
X        for (tmps = str_get(sarg[1]); *tmps && anum > 0; tmps++,anum--) ;
X        anum = (int)str_gnum(sarg[3]);
X        if (anum >= 0 && strlen(tmps) > anum)
X            str_nset(str, tmps, anum);
X        else
X            str_set(str, tmps);
X        break;
X    case O_JOIN:
X        if (arg[2].arg_flags & AF_SPECIAL && arg[2].arg_type == A_EXPR)
X            do_join(arg,str_get(sarg[1]),str);
X        else
X            ajoin(arg[2].arg_ptr.arg_stab->stab_array,str_get(sarg[1]),str);
X        break;
X    case O_SLT:
X        tmps = str_get(sarg[1]);
X        value = (double) strLT(tmps,str_get(sarg[2]));
X        goto donumset;
X    case O_SGT:
X        tmps = str_get(sarg[1]);
X        value = (double) strGT(tmps,str_get(sarg[2]));
X        goto donumset;
X    case O_SLE:
X        tmps = str_get(sarg[1]);
X        value = (double) strLE(tmps,str_get(sarg[2]));
X        goto donumset;
X    case O_SGE:
X        tmps = str_get(sarg[1]);
X        value = (double) strGE(tmps,str_get(sarg[2]));
X        goto donumset;
X    case O_SEQ:
X        tmps = str_get(sarg[1]);
X        value = (double) strEQ(tmps,str_get(sarg[2]));
X        goto donumset;
X    case O_SNE:
X        tmps = str_get(sarg[1]);
X        value = (double) strNE(tmps,str_get(sarg[2]));
X        goto donumset;
X    case O_SUBR:
X        str_sset(str,do_subr(arg,sarg));
X        STABSET(str);
X        break;
X    case O_PRTF:
X    case O_PRINT:
X        if (maxarg <= 1)
X            stab = defoutstab;
X        else {
X            stab = arg[2].arg_ptr.arg_stab;
X            if (!stab)
X                stab = defoutstab;
X        }
X        if (!stab->stab_io)
X            value = 0.0;
X        else if (arg[1].arg_flags & AF_SPECIAL)
X            value = (double)do_aprint(arg,stab->stab_io->fp);
X        else {
X            value = (double)do_print(str_get(sarg[1]),stab->stab_io->fp);
X            if (ors && optype == O_PRINT)
X                do_print(ors, stab->stab_io->fp);
X        }
X        if (stab->stab_io->flags & IOF_FLUSH)
X            fflush(stab->stab_io->fp);
X        goto donumset;
X    case O_CHDIR:
X        tmps = str_get(sarg[1]);
X        if (!tmps || !*tmps)
X            tmps = getenv("HOME");
X        if (!tmps || !*tmps)
X            tmps = getenv("LOGDIR");
X        value = (double)(chdir(tmps) >= 0);
X        goto donumset;
X    case O_DIE:
X        tmps = str_get(sarg[1]);
X        if (!tmps || !*tmps)
X            exit(1);
X        fatal("%s\n",str_get(sarg[1]));
X        value = 0.0;
X        goto donumset;
X    case O_EXIT:
X        exit((int)str_gnum(sarg[1]));
X        value = 0.0;
X        goto donumset;
X    case O_RESET:
X        str_reset(str_get(sarg[1]));
X        value = 1.0;
X        goto donumset;
X    case O_LIST:
X        if (maxarg > 0)
X            str = sarg[maxarg];        /* unwanted list, return last item */
X        else
X            str = &str_no;
X        break;
X    case O_EOF:
X        str_set(str, do_eof(maxarg > 0 ? arg[1].arg_ptr.arg_stab : last_in_stab) ? Yes : No);
X        STABSET(str);
X        break;
X    case O_TELL:
X        value =        (double)do_tell(maxarg > 0 ? arg[1].arg_ptr.arg_stab : last_in_stab);
X        goto donumset;
X        break;
X    case O_SEEK:
X        value = str_gnum(sarg[2]);
X        str_set(str, do_seek(arg[1].arg_ptr.arg_stab,
X          (long)value, (int)str_gnum(sarg[3]) ) ? Yes : No);
X        STABSET(str);
X        break;
X    case O_REDO:
X    case O_NEXT:
X    case O_LAST:
X        if (maxarg > 0) {
X            tmps = str_get(sarg[1]);
X            while (loop_ptr >= 0 && (!loop_stack[loop_ptr].loop_label ||
X              strNE(tmps,loop_stack[loop_ptr].loop_label) )) {
X#ifdef DEBUGGING
X                if (debug & 4) {
X                    deb("(Skipping label #%d %s)\n",loop_ptr,
X                        loop_stack[loop_ptr].loop_label);
X                }
X#endif
X                loop_ptr--;
X            }
X#ifdef DEBUGGING
X            if (debug & 4) {
X                deb("(Found label #%d %s)\n",loop_ptr,
X                    loop_stack[loop_ptr].loop_label);
X            }
X#endif
X        }
X        if (loop_ptr < 0)
X            fatal("Bad label: %s\n", maxarg > 0 ? tmps : "<null>");
X        longjmp(loop_stack[loop_ptr].loop_env, optype);
X    case O_GOTO:/* shudder */
X        goto_targ = str_get(sarg[1]);
X        longjmp(top_env, 1);
X    case O_INDEX:
X        tmps = str_get(sarg[1]);
X        if (!(tmps2 = instr(tmps,str_get(sarg[2]))))
X            value = (double)(-1 + arybase);
X        else
X            value = (double)(tmps2 - tmps + arybase);
X        goto donumset;
X    case O_TIME:
X        value = (double) time(0);
X        goto donumset;
X    case O_TMS:
X        value = (double) do_tms(retary);
X        retary = Null(STR***);                /* do_tms already did retary */
X        goto donumset;
X    case O_LOCALTIME:
X        tmplong = (long) str_gnum(sarg[1]);
X        value = (double) do_time(localtime(&tmplong),retary);
X        retary = Null(STR***);                /* do_localtime already did retary */
X        goto donumset;
X    case O_GMTIME:
X        tmplong = (long) str_gnum(sarg[1]);
X        value = (double) do_time(gmtime(&tmplong),retary);
X        retary = Null(STR***);                /* do_gmtime already did retary */
X        goto donumset;
X    case O_STAT:
X        value = (double) do_stat(arg,sarg,retary);
X        retary = Null(STR***);                /* do_stat already did retary */
X        goto donumset;
X    case O_CRYPT:
X        tmps = str_get(sarg[1]);
X        str_set(str,crypt(tmps,str_get(sarg[2])));
X        break;
X    case O_EXP:
X        value = exp(str_gnum(sarg[1]));
X        goto donumset;
X    case O_LOG:
X        value = log(str_gnum(sarg[1]));
X        goto donumset;
X    case O_SQRT:
X        value = sqrt(str_gnum(sarg[1]));
X        goto donumset;
X    case O_INT:
X        modf(str_gnum(sarg[1]),&value);
X        goto donumset;
X    case O_ORD:
X        value = (double) *str_get(sarg[1]);
X        goto donumset;
X    case O_SLEEP:
X        tmps = str_get(sarg[1]);
X        time(&tmplong);
X        if (!tmps || !*tmps)
X            sleep((32767<<16)+32767);
X        else
X            sleep(atoi(tmps));
X        value = (double)tmplong;
X        time(&tmplong);
X        value = ((double)tmplong) - value;
X        goto donumset;
X    case O_FLIP:
X        if (str_true(sarg[1])) {
X            str_numset(str,0.0);
X            anum = 2;
X            arg->arg_type = optype = O_FLOP;
X            maxarg = 0;
X            arg[2].arg_flags &= ~AF_SPECIAL;
X            arg[1].arg_flags |= AF_SPECIAL;
X            argflags = arg[anum].arg_flags;
X            goto re_eval;
X        }
X        str_set(str,"");
X        break;
X    case O_FLOP:
X        str_inc(str);
X        if (str_true(sarg[2])) {
X            arg->arg_type = O_FLIP;
X            arg[1].arg_flags &= ~AF_SPECIAL;
X            arg[2].arg_flags |= AF_SPECIAL;
X            str_cat(str,"E0");
X        }
X        break;
X    case O_FORK:
X        value = (double)fork();
X        goto donumset;
X    case O_SYSTEM:
X        if (anum = vfork()) {
X            ihand = signal(SIGINT, SIG_IGN);
X            qhand = signal(SIGQUIT, SIG_IGN);
X            while ((maxarg = wait(&argflags)) != anum && maxarg != -1)
X                ;
X            if (maxarg == -1)
X                argflags = -1;
X            signal(SIGINT, ihand);
X            signal(SIGQUIT, qhand);
X            value = (double)argflags;
X            goto donumset;
X        }
X        /* FALL THROUGH */
X    case O_EXEC:
X        if (arg[1].arg_flags & AF_SPECIAL)
X            value = (double)do_aexec(arg);
X        else {
X            value = (double)do_exec(str_get(sarg[1]));
X        }
X        goto donumset;
X    case O_HEX:
X        maxarg = 4;
X        goto snarfnum;
X
X    case O_OCT:
X        maxarg = 3;
X
X      snarfnum:
X        anum = 0;
X        tmps = str_get(sarg[1]);
X        for (;;) {
X            switch (*tmps) {
X            default:
X                goto out;
X            case '8': case '9':
X                if (maxarg != 4)
X                    goto out;
X                /* FALL THROUGH */
X            case '0': case '1': case '2': case '3': case '4':
X            case '5': case '6': case '7':
X                anum <<= maxarg;
X                anum += *tmps++ & 15;
X                break;
X            case 'a': case 'b': case 'c': case 'd': case 'e': case 'f':
X            case 'A': case 'B': case 'C': case 'D': case 'E': case 'F':
X                if (maxarg != 4)
X                    goto out;
X                anum <<= 4;
X                anum += (*tmps++ & 7) + 9;
X                break;
X            case 'x':
X                maxarg = 4;
X                tmps++;
X                break;
X            }
X        }
X      out:
X        value = (double)anum;
X        goto donumset;
X    case O_CHMOD:
X    case O_CHOWN:
X    case O_KILL:
X    case O_UNLINK:
X        if (arg[1].arg_flags & AF_SPECIAL)
X            value = (double)apply(optype,arg,Null(STR**));
X        else {
X            sarg[2] = Nullstr;
X            value = (double)apply(optype,arg,sarg);
X        }
X        goto donumset;
X    case O_UMASK:
X        value = (double)umask((int)str_gnum(sarg[1]));
X        goto donumset;
X    case O_RENAME:
X        tmps = str_get(sarg[1]);
X#ifdef RENAME
X        value = (double)(rename(tmps,str_get(sarg[2])) >= 0);
X#else
X        tmps2 = str_get(sarg[2]);
X        UNLINK(tmps2);
X        if (!(anum = link(tmps,tmps2)))
X            anum = UNLINK(tmps);
X        value = (double)(anum >= 0);
X#endif
X        goto donumset;
X    case O_LINK:
X        tmps = str_get(sarg[1]);
X        value = (double)(link(tmps,str_get(sarg[2])) >= 0);
X        goto donumset;
X    case O_UNSHIFT:
X        ary = arg[2].arg_ptr.arg_stab->stab_array;
X        if (arg[1].arg_flags & AF_SPECIAL)
X            do_unshift(arg,ary);
X        else {
X            str = str_new(0);                /* must copy the STR */
X            str_sset(str,sarg[1]);
X            aunshift(ary,1);
X            astore(ary,0,str);
X        }
X        value = (double)(ary->ary_fill + 1);
X        break;
X    }
X#ifdef DEBUGGING
X    dlevel--;
X    if (debug & 8)
X        deb("%s RETURNS \"%s\"\n",opname[optype],str_get(str));
X#endif
X    goto freeargs;
X
Xdonumset:
X    str_numset(str,value);
X    STABSET(str);
X#ifdef DEBUGGING
X    dlevel--;
X    if (debug & 8)
X        deb("%s RETURNS \"%f\"\n",opname[optype],value);
X#endif
X
Xfreeargs:
X    if (sarg != quicksarg) {
X        if (retary) {
X            if (optype == O_LIST)
X                sarg[0] = &str_no;
X            else
X                sarg[0] = Nullstr;
X            sarg[maxarg+1] = Nullstr;
X            *retary = sarg;        /* up to them to free it */
X        }
X        else
X            safefree(sarg);
X    }
X    return str;
X
Xnullarray:
X    maxarg = 0;
X#ifdef DEBUGGING
X    dlevel--;
X    if (debug & 8)
X        deb("%s RETURNS ()\n",opname[optype],value);
X#endif
X    goto freeargs;
X}
!STUFFY!FUNK!
echo ""
echo "End of kit 3 (of 10)"
cat /dev/null >kit3isdone
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