#! /bin/sh

# Make a new directory for the perl sources, cd to it, and run kits 1
# thru 10 through sh.  When all 10 kits have been run, read README.

echo "This is perl 1.0 kit 9 (of 10).  If kit 9 is complete, the line"
echo '"'"End of kit 9 (of 10)"'" will echo at the end.'
echo ""
export PATH || (echo "You didn't use sh, you clunch." ; kill $$)
mkdir t 2>/dev/null
mkdir x2p 2>/dev/null
echo Extracting x2p/util.c
sed >x2p/util.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: util.c,v 1.0 87/12/18 13:07:34 root Exp $
X *
X * $Log:        util.c,v $
X * Revision 1.0  87/12/18  13:07:34  root
X * Initial revision
X * 
X */
X
X#include <stdio.h>
X
X#include "handy.h"
X#include "EXTERN.h"
X#include "a2p.h"
X#include "INTERN.h"
X#include "util.h"
X
X#define FLUSH
X#define MEM_SIZE unsigned int
X
Xstatic char nomem[] = "Out of memory!\n";
X
X/* paranoid version of malloc */
X
Xstatic int an = 0;
X
Xchar *
Xsafemalloc(size)
XMEM_SIZE size;
X{
X    char *ptr;
X    char *malloc();
X
X    ptr = malloc(size?size:1);        /* malloc(0) is NASTY on our system */
X#ifdef DEBUGGING
X    if (debug & 128)
X        fprintf(stderr,"0x%x: (%05d) malloc %d bytes\n",ptr,an++,size);
X#endif
X    if (ptr != Nullch)
X        return ptr;
X    else {
X        fputs(nomem,stdout) FLUSH;
X        exit(1);
X    }
X    /*NOTREACHED*/
X}
X
X/* paranoid version of realloc */
X
Xchar *
Xsaferealloc(where,size)
Xchar *where;
XMEM_SIZE size;
X{
X    char *ptr;
X    char *realloc();
X
X    ptr = realloc(where,size?size:1);        /* realloc(0) is NASTY on our system */
X#ifdef DEBUGGING
X    if (debug & 128) {
X        fprintf(stderr,"0x%x: (%05d) rfree\n",where,an++);
X        fprintf(stderr,"0x%x: (%05d) realloc %d bytes\n",ptr,an++,size);
X    }
X#endif
X    if (ptr != Nullch)
X        return ptr;
X    else {
X        fputs(nomem,stdout) FLUSH;
X        exit(1);
X    }
X    /*NOTREACHED*/
X}
X
X/* safe version of free */
X
Xsafefree(where)
Xchar *where;
X{
X#ifdef DEBUGGING
X    if (debug & 128)
X        fprintf(stderr,"0x%x: (%05d) free\n",where,an++);
X#endif
X    free(where);
X}
X
X/* safe version of string copy */
X
Xchar *
Xsafecpy(to,from,len)
Xchar *to;
Xregister char *from;
Xregister int len;
X{
X    register char *dest = to;
X
X    if (from != Nullch) 
X        for (len--; len && (*dest++ = *from++); len--) ;
X    *dest = '\0';
X    return to;
X}
X
X#ifdef undef
X/* safe version of string concatenate, with \n deletion and space padding */
X
Xchar *
Xsafecat(to,from,len)
Xchar *to;
Xregister char *from;
Xregister int len;
X{
X    register char *dest = to;
X
X    len--;                                /* leave room for null */
X    if (*dest) {
X        while (len && *dest++) len--;
X        if (len) {
X            len--;
X            *(dest-1) = ' ';
X        }
X    }
X    if (from != Nullch)
X        while (len && (*dest++ = *from++)) len--;
X    if (len)
X        dest--;
X    if (*(dest-1) == '\n')
X        dest--;
X    *dest = '\0';
X    return to;
X}
X#endif
X
X/* copy a string up to some (non-backslashed) delimiter, if any */
X
Xchar *
Xcpytill(to,from,delim)
Xregister char *to, *from;
Xregister int delim;
X{
X    for (; *from; from++,to++) {
X        if (*from == '\\' && from[1] == delim)
X            *to++ = *from++;
X        else if (*from == delim)
X            break;
X        *to = *from;
X    }
X    *to = '\0';
X    return from;
X}
X
Xchar *
Xcpy2(to,from,delim)
Xregister char *to, *from;
Xregister int delim;
X{
X    for (; *from; from++,to++) {
X        if (*from == '\\' && from[1] == delim)
X            *to++ = *from++;
X        else if (*from == '$')
X            *to++ = '\\';
X        else if (*from == delim)
X            break;
X        *to = *from;
X    }
X    *to = '\0';
X    return from;
X}
X
X/* return ptr to little string in big string, NULL if not found */
X
Xchar *
Xinstr(big, little)
Xchar *big, *little;
X
X{
X    register char *t, *s, *x;
X
X    for (t = big; *t; t++) {
X        for (x=t,s=little; *s; x++,s++) {
X            if (!*x)
X                return Nullch;
X            if (*s != *x)
X                break;
X        }
X        if (!*s)
X            return t;
X    }
X    return Nullch;
X}
X
X/* copy a string to a safe spot */
X
Xchar *
Xsavestr(str)
Xchar *str;
X{
X    register char *newaddr = safemalloc((MEM_SIZE)(strlen(str)+1));
X
X    (void)strcpy(newaddr,str);
X    return newaddr;
X}
X
X/* grow a static string to at least a certain length */
X
Xvoid
Xgrowstr(strptr,curlen,newlen)
Xchar **strptr;
Xint *curlen;
Xint newlen;
X{
X    if (newlen > *curlen) {                /* need more room? */
X        if (*curlen)
X            *strptr = saferealloc(*strptr,(MEM_SIZE)newlen);
X        else
X            *strptr = safemalloc((MEM_SIZE)newlen);
X        *curlen = newlen;
X    }
X}
X
X/*VARARGS1*/
Xfatal(pat,a1,a2,a3,a4)
Xchar *pat;
X{
X    fprintf(stderr,pat,a1,a2,a3,a4);
X    exit(1);
X}
X
Xstatic bool firstsetenv = TRUE;
Xextern char **environ;
X
Xvoid
Xsetenv(nam,val)
Xchar *nam, *val;
X{
X    register int i=envix(nam);                /* where does it go? */
X
X    if (!environ[i]) {                        /* does not exist yet */
X        if (firstsetenv) {                /* need we copy environment? */
X            int j;
X#ifndef lint
X            char **tmpenv = (char**)        /* point our wand at memory */
X                safemalloc((i+2) * sizeof(char*));
X#else
X            char **tmpenv = Null(char **);
X#endif /* lint */
X    
X            firstsetenv = FALSE;
X            for (j=0; j<i; j++)                /* copy environment */
X                tmpenv[j] = environ[j];
X            environ = tmpenv;                /* tell exec where it is now */
X        }
X#ifndef lint
X        else
X            environ = (char**) saferealloc((char*) environ,
X                (i+2) * sizeof(char*));
X                                        /* just expand it a bit */
X#endif /* lint */
X        environ[i+1] = Nullch;        /* make sure it's null terminated */
X    }
X    environ[i] = safemalloc(strlen(nam) + strlen(val) + 2);
X                                        /* this may or may not be in */
X                                        /* the old environ structure */
X    sprintf(environ[i],"%s=%s",nam,val);/* all that work just for this */
X}
X
Xint
Xenvix(nam)
Xchar *nam;
X{
X    register int i, len = strlen(nam);
X
X    for (i = 0; environ[i]; i++) {
X        if (strnEQ(environ[i],nam,len) && environ[i][len] == '=')
X            break;                        /* strnEQ must come first to avoid */
X    }                                        /* potential SEGV's */
X    return i;
X}
!STUFFY!FUNK!
echo Extracting util.c
sed >util.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: util.c,v 1.0 87/12/18 13:06:30 root Exp $
X *
X * $Log:        util.c,v $
X * Revision 1.0  87/12/18  13:06:30  root
X * Initial revision
X * 
X */
X
X#include <stdio.h>
X
X#include "handy.h"
X#include "EXTERN.h"
X#include "search.h"
X#include "perl.h"
X#include "INTERN.h"
X#include "util.h"
X
X#define FLUSH
X#define MEM_SIZE unsigned int
X
Xstatic char nomem[] = "Out of memory!\n";
X
X/* paranoid version of malloc */
X
Xstatic int an = 0;
X
Xchar *
Xsafemalloc(size)
XMEM_SIZE size;
X{
X    char *ptr;
X    char *malloc();
X
X    ptr = malloc(size?size:1);        /* malloc(0) is NASTY on our system */
X#ifdef DEBUGGING
X    if (debug & 128)
X        fprintf(stderr,"0x%x: (%05d) malloc %d bytes\n",ptr,an++,size);
X#endif
X    if (ptr != Nullch)
X        return ptr;
X    else {
X        fputs(nomem,stdout) FLUSH;
X        exit(1);
X    }
X    /*NOTREACHED*/
X}
X
X/* paranoid version of realloc */
X
Xchar *
Xsaferealloc(where,size)
Xchar *where;
XMEM_SIZE size;
X{
X    char *ptr;
X    char *realloc();
X
X    ptr = realloc(where,size?size:1);        /* realloc(0) is NASTY on our system */
X#ifdef DEBUGGING
X    if (debug & 128) {
X        fprintf(stderr,"0x%x: (%05d) rfree\n",where,an++);
X        fprintf(stderr,"0x%x: (%05d) realloc %d bytes\n",ptr,an++,size);
X    }
X#endif
X    if (ptr != Nullch)
X        return ptr;
X    else {
X        fputs(nomem,stdout) FLUSH;
X        exit(1);
X    }
X    /*NOTREACHED*/
X}
X
X/* safe version of free */
X
Xsafefree(where)
Xchar *where;
X{
X#ifdef DEBUGGING
X    if (debug & 128)
X        fprintf(stderr,"0x%x: (%05d) free\n",where,an++);
X#endif
X    free(where);
X}
X
X/* safe version of string copy */
X
Xchar *
Xsafecpy(to,from,len)
Xchar *to;
Xregister char *from;
Xregister int len;
X{
X    register char *dest = to;
X
X    if (from != Nullch) 
X        for (len--; len && (*dest++ = *from++); len--) ;
X    *dest = '\0';
X    return to;
X}
X
X#ifdef undef
X/* safe version of string concatenate, with \n deletion and space padding */
X
Xchar *
Xsafecat(to,from,len)
Xchar *to;
Xregister char *from;
Xregister int len;
X{
X    register char *dest = to;
X
X    len--;                                /* leave room for null */
X    if (*dest) {
X        while (len && *dest++) len--;
X        if (len) {
X            len--;
X            *(dest-1) = ' ';
X        }
X    }
X    if (from != Nullch)
X        while (len && (*dest++ = *from++)) len--;
X    if (len)
X        dest--;
X    if (*(dest-1) == '\n')
X        dest--;
X    *dest = '\0';
X    return to;
X}
X#endif
X
X/* copy a string up to some (non-backslashed) delimiter, if any */
X
Xchar *
Xcpytill(to,from,delim)
Xregister char *to, *from;
Xregister int delim;
X{
X    for (; *from; from++,to++) {
X        if (*from == '\\' && from[1] == delim)
X            from++;
X        else if (*from == delim)
X            break;
X        *to = *from;
X    }
X    *to = '\0';
X    return from;
X}
X
X/* return ptr to little string in big string, NULL if not found */
X
Xchar *
Xinstr(big, little)
Xchar *big, *little;
X
X{
X    register char *t, *s, *x;
X
X    for (t = big; *t; t++) {
X        for (x=t,s=little; *s; x++,s++) {
X            if (!*x)
X                return Nullch;
X            if (*s != *x)
X                break;
X        }
X        if (!*s)
X            return t;
X    }
X    return Nullch;
X}
X
X/* copy a string to a safe spot */
X
Xchar *
Xsavestr(str)
Xchar *str;
X{
X    register char *newaddr = safemalloc((MEM_SIZE)(strlen(str)+1));
X
X    (void)strcpy(newaddr,str);
X    return newaddr;
X}
X
X/* grow a static string to at least a certain length */
X
Xvoid
Xgrowstr(strptr,curlen,newlen)
Xchar **strptr;
Xint *curlen;
Xint newlen;
X{
X    if (newlen > *curlen) {                /* need more room? */
X        if (*curlen)
X            *strptr = saferealloc(*strptr,(MEM_SIZE)newlen);
X        else
X            *strptr = safemalloc((MEM_SIZE)newlen);
X        *curlen = newlen;
X    }
X}
X
X/*VARARGS1*/
Xfatal(pat,a1,a2,a3,a4)
Xchar *pat;
X{
X    extern FILE *e_fp;
X    extern char *e_tmpname;
X
X    fprintf(stderr,pat,a1,a2,a3,a4);
X    if (e_fp)
X        UNLINK(e_tmpname);
X    exit(1);
X}
X
Xstatic bool firstsetenv = TRUE;
Xextern char **environ;
X
Xvoid
Xsetenv(nam,val)
Xchar *nam, *val;
X{
X    register int i=envix(nam);                /* where does it go? */
X
X    if (!environ[i]) {                        /* does not exist yet */
X        if (firstsetenv) {                /* need we copy environment? */
X            int j;
X#ifndef lint
X            char **tmpenv = (char**)        /* point our wand at memory */
X                safemalloc((i+2) * sizeof(char*));
X#else
X            char **tmpenv = Null(char **);
X#endif /* lint */
X    
X            firstsetenv = FALSE;
X            for (j=0; j<i; j++)                /* copy environment */
X                tmpenv[j] = environ[j];
X            environ = tmpenv;                /* tell exec where it is now */
X        }
X#ifndef lint
X        else
X            environ = (char**) saferealloc((char*) environ,
X                (i+2) * sizeof(char*));
X                                        /* just expand it a bit */
X#endif /* lint */
X        environ[i+1] = Nullch;        /* make sure it's null terminated */
X    }
X    environ[i] = safemalloc(strlen(nam) + strlen(val) + 2);
X                                        /* this may or may not be in */
X                                        /* the old environ structure */
X    sprintf(environ[i],"%s=%s",nam,val);/* all that work just for this */
X}
X
Xint
Xenvix(nam)
Xchar *nam;
X{
X    register int i, len = strlen(nam);
X
X    for (i = 0; environ[i]; i++) {
X        if (strnEQ(environ[i],nam,len) && environ[i][len] == '=')
X            break;                        /* strnEQ must come first to avoid */
X    }                                        /* potential SEGV's */
X    return i;
X}
!STUFFY!FUNK!
echo Extracting hash.c
sed >hash.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: hash.c,v 1.0 87/12/18 13:05:17 root Exp $
X *
X * $Log:        hash.c,v $
X * Revision 1.0  87/12/18  13:05:17  root
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
Xhfetch(tb,key)
Xregister HASH *tb;
Xchar *key;
X{
X    register char *s;
X    register int i;
X    register int hash;
X    register HENT *entry;
X
X    if (!tb)
X        return Nullstr;
X    for (s=key,                i=0,        hash = 0;
X      /* while */ *s;
X         s++,                i++,        hash *= 5) {
X        hash += *s * coeff[i];
X    }
X    entry = tb->tbl_array[hash & tb->tbl_max];
X    for (; entry; entry = entry->hent_next) {
X        if (entry->hent_hash != hash)                /* strings can't be equal */
X            continue;
X        if (strNE(entry->hent_key,key))        /* is this it? */
X            continue;
X        return entry->hent_val;
X    }
X    return Nullstr;
X}
X
Xbool
Xhstore(tb,key,val)
Xregister HASH *tb;
Xchar *key;
XSTR *val;
X{
X    register char *s;
X    register int i;
X    register int hash;
X    register HENT *entry;
X    register HENT **oentry;
X
X    if (!tb)
X        return FALSE;
X    for (s=key,                i=0,        hash = 0;
X      /* while */ *s;
X         s++,                i++,        hash *= 5) {
X        hash += *s * coeff[i];
X    }
X
X    oentry = &(tb->tbl_array[hash & tb->tbl_max]);
X    i = 1;
X
X    for (entry = *oentry; entry; i=0, entry = entry->hent_next) {
X        if (entry->hent_hash != hash)                /* strings can't be equal */
X            continue;
X        if (strNE(entry->hent_key,key))        /* is this it? */
X            continue;
X        safefree((char*)entry->hent_val);
X        entry->hent_val = val;
X        return TRUE;
X    }
X    entry = (HENT*) safemalloc(sizeof(HENT));
X
X    entry->hent_key = savestr(key);
X    entry->hent_val = val;
X    entry->hent_hash = hash;
X    entry->hent_next = *oentry;
X    *oentry = entry;
X
X    if (i) {                                /* initial entry? */
X        tb->tbl_fill++;
X        if ((tb->tbl_fill * 100 / (tb->tbl_max + 1)) > FILLPCT)
X            hsplit(tb);
X    }
X
X    return FALSE;
X}
X
X#ifdef NOTUSED
Xbool
Xhdelete(tb,key)
Xregister HASH *tb;
Xchar *key;
X{
X    register char *s;
X    register int i;
X    register int hash;
X    register HENT *entry;
X    register HENT **oentry;
X
X    if (!tb)
X        return FALSE;
X    for (s=key,                i=0,        hash = 0;
X      /* while */ *s;
X         s++,                i++,        hash *= 5) {
X        hash += *s * coeff[i];
X    }
X
X    oentry = &(tb->tbl_array[hash & tb->tbl_max]);
X    entry = *oentry;
X    i = 1;
X    for (; entry; i=0, oentry = &entry->hent_next, entry = entry->hent_next) {
X        if (entry->hent_hash != hash)                /* strings can't be equal */
X            continue;
X        if (strNE(entry->hent_key,key))        /* is this it? */
X            continue;
X        safefree((char*)entry->hent_val);
X        safefree(entry->hent_key);
X        *oentry = entry->hent_next;
X        safefree((char*)entry);
X        if (i)
X            tb->tbl_fill--;
X        return TRUE;
X    }
X    return FALSE;
X}
X#endif
X
Xhsplit(tb)
XHASH *tb;
X{
X    int oldsize = tb->tbl_max + 1;
X    register int newsize = oldsize * 2;
X    register int i;
X    register HENT **a;
X    register HENT **b;
X    register HENT *entry;
X    register HENT **oentry;
X
X    a = (HENT**) saferealloc((char*)tb->tbl_array, newsize * sizeof(HENT*));
X    bzero((char*)&a[oldsize], oldsize * sizeof(HENT*)); /* zero second half */
X    tb->tbl_max = --newsize;
X    tb->tbl_array = a;
X
X    for (i=0; i<oldsize; i++,a++) {
X        if (!*a)                                /* non-existent */
X            continue;
X        b = a+oldsize;
X        for (oentry = a, entry = *a; entry; entry = *oentry) {
X            if ((entry->hent_hash & newsize) != i) {
X                *oentry = entry->hent_next;
X                entry->hent_next = *b;
X                if (!*b)
X                    tb->tbl_fill++;
X                *b = entry;
X                continue;
X            }
X            else
X                oentry = &entry->hent_next;
X        }
X        if (!*a)                                /* everything moved */
X            tb->tbl_fill--;
X    }
X}
X
XHASH *
Xhnew()
X{
X    register HASH *tb = (HASH*)safemalloc(sizeof(HASH));
X
X    tb->tbl_array = (HENT**) safemalloc(8 * sizeof(HENT*));
X    tb->tbl_fill = 0;
X    tb->tbl_max = 7;
X    hiterinit(tb);        /* so each() will start off right */
X    bzero((char*)tb->tbl_array, 8 * sizeof(HENT*));
X    return tb;
X}
X
X#ifdef NOTUSED
Xhshow(tb)
Xregister HASH *tb;
X{
X    fprintf(stderr,"%5d %4d (%2d%%)\n",
X        tb->tbl_max+1,
X        tb->tbl_fill,
X        tb->tbl_fill * 100 / (tb->tbl_max+1));
X}
X#endif
X
Xhiterinit(tb)
Xregister HASH *tb;
X{
X    tb->tbl_riter = -1;
X    tb->tbl_eiter = Null(HENT*);
X    return tb->tbl_fill;
X}
X
XHENT *
Xhiternext(tb)
Xregister HASH *tb;
X{
X    register HENT *entry;
X
X    entry = tb->tbl_eiter;
X    do {
X        if (entry)
X            entry = entry->hent_next;
X        if (!entry) {
X            tb->tbl_riter++;
X            if (tb->tbl_riter > tb->tbl_max) {
X                tb->tbl_riter = -1;
X                break;
X            }
X            entry = tb->tbl_array[tb->tbl_riter];
X        }
X    } while (!entry);
X
X    tb->tbl_eiter = entry;
X    return entry;
X}
X
Xchar *
Xhiterkey(entry)
Xregister HENT *entry;
X{
X    return entry->hent_key;
X}
X
XSTR *
Xhiterval(entry)
Xregister HENT *entry;
X{
X    return entry->hent_val;
X}
!STUFFY!FUNK!
echo Extracting x2p/hash.c
sed >x2p/hash.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: hash.c,v 1.0 87/12/18 13:07:18 root Exp $
X *
X * $Log:        hash.c,v $
X * Revision 1.0  87/12/18  13:07:18  root
X * Initial revision
X * 
X */
X
X#include <stdio.h>
X#include "EXTERN.h"
X#include "handy.h"
X#include "util.h"
X#include "a2p.h"
X
XSTR *
Xhfetch(tb,key)
Xregister HASH *tb;
Xchar *key;
X{
X    register char *s;
X    register int i;
X    register int hash;
X    register HENT *entry;
X
X    if (!tb)
X        return Nullstr;
X    for (s=key,                i=0,        hash = 0;
X      /* while */ *s;
X         s++,                i++,        hash *= 5) {
X        hash += *s * coeff[i];
X    }
X    entry = tb->tbl_array[hash & tb->tbl_max];
X    for (; entry; entry = entry->hent_next) {
X        if (entry->hent_hash != hash)                /* strings can't be equal */
X            continue;
X        if (strNE(entry->hent_key,key))        /* is this it? */
X            continue;
X        return entry->hent_val;
X    }
X    return Nullstr;
X}
X
Xbool
Xhstore(tb,key,val)
Xregister HASH *tb;
Xchar *key;
XSTR *val;
X{
X    register char *s;
X    register int i;
X    register int hash;
X    register HENT *entry;
X    register HENT **oentry;
X
X    if (!tb)
X        return FALSE;
X    for (s=key,                i=0,        hash = 0;
X      /* while */ *s;
X         s++,                i++,        hash *= 5) {
X        hash += *s * coeff[i];
X    }
X
X    oentry = &(tb->tbl_array[hash & tb->tbl_max]);
X    i = 1;
X
X    for (entry = *oentry; entry; i=0, entry = entry->hent_next) {
X        if (entry->hent_hash != hash)                /* strings can't be equal */
X            continue;
X        if (strNE(entry->hent_key,key))        /* is this it? */
X            continue;
X        safefree((char*)entry->hent_val);
X        entry->hent_val = val;
X        return TRUE;
X    }
X    entry = (HENT*) safemalloc(sizeof(HENT));
X
X    entry->hent_key = savestr(key);
X    entry->hent_val = val;
X    entry->hent_hash = hash;
X    entry->hent_next = *oentry;
X    *oentry = entry;
X
X    if (i) {                                /* initial entry? */
X        tb->tbl_fill++;
X        if ((tb->tbl_fill * 100 / (tb->tbl_max + 1)) > FILLPCT)
X            hsplit(tb);
X    }
X
X    return FALSE;
X}
X
X#ifdef NOTUSED
Xbool
Xhdelete(tb,key)
Xregister HASH *tb;
Xchar *key;
X{
X    register char *s;
X    register int i;
X    register int hash;
X    register HENT *entry;
X    register HENT **oentry;
X
X    if (!tb)
X        return FALSE;
X    for (s=key,                i=0,        hash = 0;
X      /* while */ *s;
X         s++,                i++,        hash *= 5) {
X        hash += *s * coeff[i];
X    }
X
X    oentry = &(tb->tbl_array[hash & tb->tbl_max]);
X    entry = *oentry;
X    i = 1;
X    for (; entry; i=0, oentry = &entry->hent_next, entry = entry->hent_next) {
X        if (entry->hent_hash != hash)                /* strings can't be equal */
X            continue;
X        if (strNE(entry->hent_key,key))        /* is this it? */
X            continue;
X        safefree((char*)entry->hent_val);
X        safefree(entry->hent_key);
X        *oentry = entry->hent_next;
X        safefree((char*)entry);
X        if (i)
X            tb->tbl_fill--;
X        return TRUE;
X    }
X    return FALSE;
X}
X#endif
X
Xhsplit(tb)
XHASH *tb;
X{
X    int oldsize = tb->tbl_max + 1;
X    register int newsize = oldsize * 2;
X    register int i;
X    register HENT **a;
X    register HENT **b;
X    register HENT *entry;
X    register HENT **oentry;
X
X    a = (HENT**) saferealloc((char*)tb->tbl_array, newsize * sizeof(HENT*));
X    bzero((char*)&a[oldsize], oldsize * sizeof(HENT*)); /* zero second half */
X    tb->tbl_max = --newsize;
X    tb->tbl_array = a;
X
X    for (i=0; i<oldsize; i++,a++) {
X        if (!*a)                                /* non-existent */
X            continue;
X        b = a+oldsize;
X        for (oentry = a, entry = *a; entry; entry = *oentry) {
X            if ((entry->hent_hash & newsize) != i) {
X                *oentry = entry->hent_next;
X                entry->hent_next = *b;
X                if (!*b)
X                    tb->tbl_fill++;
X                *b = entry;
X                continue;
X            }
X            else
X                oentry = &entry->hent_next;
X        }
X        if (!*a)                                /* everything moved */
X            tb->tbl_fill--;
X    }
X}
X
XHASH *
Xhnew()
X{
X    register HASH *tb = (HASH*)safemalloc(sizeof(HASH));
X
X    tb->tbl_array = (HENT**) safemalloc(8 * sizeof(HENT*));
X    tb->tbl_fill = 0;
X    tb->tbl_max = 7;
X    hiterinit(tb);        /* so each() will start off right */
X    bzero((char*)tb->tbl_array, 8 * sizeof(HENT*));
X    return tb;
X}
X
X#ifdef NOTUSED
Xhshow(tb)
Xregister HASH *tb;
X{
X    fprintf(stderr,"%5d %4d (%2d%%)\n",
X        tb->tbl_max+1,
X        tb->tbl_fill,
X        tb->tbl_fill * 100 / (tb->tbl_max+1));
X}
X#endif
X
Xhiterinit(tb)
Xregister HASH *tb;
X{
X    tb->tbl_riter = -1;
X    tb->tbl_eiter = Null(HENT*);
X    return tb->tbl_fill;
X}
X
XHENT *
Xhiternext(tb)
Xregister HASH *tb;
X{
X    register HENT *entry;
X
X    entry = tb->tbl_eiter;
X    do {
X        if (entry)
X            entry = entry->hent_next;
X        if (!entry) {
X            tb->tbl_riter++;
X            if (tb->tbl_riter > tb->tbl_max) {
X                tb->tbl_riter = -1;
X                break;
X            }
X            entry = tb->tbl_array[tb->tbl_riter];
X        }
X    } while (!entry);
X
X    tb->tbl_eiter = entry;
X    return entry;
X}
X
Xchar *
Xhiterkey(entry)
Xregister HENT *entry;
X{
X    return entry->hent_key;
X}
X
XSTR *
Xhiterval(entry)
Xregister HENT *entry;
X{
X    return entry->hent_val;
X}
!STUFFY!FUNK!
echo Extracting makedepend.SH
sed >makedepend.SH <<'!STUFFY!FUNK!' -e 's/X//'
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
Xecho "Extracting makedepend (with variable substitutions)"
X$spitshell >makedepend <<!GROK!THIS!
X$startsh
X# $Header: makedepend.SH,v 1.0 87/12/18 17:54:32 root Exp $
X#
X# $Log:        makedepend.SH,v $
X# Revision 1.0  87/12/18  17:54:32  root
X# Initial revision
X# 
X# 
X
Xexport PATH || (echo "OOPS, this isn't sh.  Desperation time.  I will feed myself to sh."; sh \$0; kill \$\$)
X
Xcat='$cat'
Xcp='$cp'
Xcpp='$cpp'
Xecho='$echo'
Xegrep='$egrep'
Xexpr='$expr'
Xmv='$mv'
Xrm='$rm'
Xsed='$sed'
Xsort='$sort'
Xtest='$test'
Xtr='$tr'
Xuniq='$uniq'
X!GROK!THIS!
X
X$spitshell >>makedepend <<'!NO!SUBS!'
X
X$cat /dev/null >.deptmp
X$rm -f *.c.c c/*.c.c
Xif test -f Makefile; then
X    mf=Makefile
Xelse
X    mf=makefile
Xfi
Xif test -f $mf; then
X    defrule=`<$mf sed -n                \
X        -e '/^\.c\.o:.*;/{'                \
X        -e    's/\$\*\.c//'                \
X        -e    's/^[^;]*;[         ]*//p'        \
X        -e    q                                \
X        -e '}'                                \
X        -e '/^\.c\.o: *$/{'                \
X        -e    N                                \
X        -e    's/\$\*\.c//'                \
X        -e    's/^.*\n[         ]*//p'                \
X        -e    q                                \
X        -e '}'`
Xfi
Xcase "$defrule" in
X'') defrule='$(CC) -c $(CFLAGS)' ;;
Xesac
X
Xmake clist || ($echo "Searching for .c files..."; \
X        $echo *.c */*.c | $tr ' ' '\012' | $egrep -v '\*' >.clist)
Xfor file in `$cat .clist`; do
X# for file in `cat /dev/null`; do
X    case "$file" in
X    *.c) filebase=`basename $file .c` ;;
X    *.y) filebase=`basename $file .c` ;;
X    esac
X    $echo "Finding dependencies for $filebase.o."
X    $sed -n <$file >$file.c \
X        -e "/^${filebase}_init(/q" \
X        -e '/^#/{' \
X        -e 's|/\*.*$||' \
X        -e 's|\\$||' \
X        -e p \
X        -e '}'
X    $cpp -I/usr/local/include -I. -I./h $file.c | \
X    $sed \
X        -e '/^# *[0-9]/!d' \
X        -e 's/^.*"\(.*\)".*$/'$filebase'.o: \1/' \
X        -e 's|: \./|: |' \
X        -e 's|\.c\.c|.c|' | \
X    $uniq | $sort | $uniq >> .deptmp
Xdone
X
X$sed <Makefile >Makefile.new -e '1,/^# AUTOMATICALLY/!d'
X
Xmake shlist || ($echo "Searching for .SH files..."; \
X        $echo *.SH */*.SH | $tr ' ' '\012' | $egrep -v '\*' >.shlist)
Xif $test -s .deptmp; then
X    for file in `cat .shlist`; do
X        $echo `$expr X$file : 'X\(.*\).SH`: $file config.sh \; \
X            /bin/sh $file >> .deptmp
X    done
X    $echo "Updating Makefile..."
X    $echo "# If this runs make out of memory, delete /usr/include lines." \
X        >> Makefile.new
X    $sed 's|^\(.*\.o:\) *\(.*/.*\.c\) *$|\1 \2; '"$defrule \2|" .deptmp \
X       >>Makefile.new
Xelse
X    make hlist || ($echo "Searching for .h files..."; \
X        $echo *.h */*.h | $tr ' ' '\012' | $egrep -v '\*' >.hlist)
X    $echo "You don't seem to have a proper C preprocessor.  Using grep instead."
X    $egrep '^#include ' `cat .clist` `cat .hlist`  >.deptmp
X    $echo "Updating Makefile..."
X    <.clist $sed -n                                                        \
X        -e '/\//{'                                                        \
X        -e   's|^\(.*\)/\(.*\)\.c|\2.o: \1/\2.c; '"$defrule \1/\2.c|p"        \
X        -e   d                                                                \
X        -e '}'                                                                \
X        -e 's|^\(.*\)\.c|\1.o: \1.c|p' >> Makefile.new
X    <.hlist $sed -n 's|\(.*/\)\(.*\)|s= \2= \1\2=|p' >.hsed
X    <.deptmp $sed -n 's|c:#include "\(.*\)".*$|o: \1|p' | \
X       $sed 's|^[^;]*/||' | \
X       $sed -f .hsed >> Makefile.new
X    <.deptmp $sed -n 's|c:#include <\(.*\)>.*$|o: /usr/include/\1|p' \
X       >> Makefile.new
X    <.deptmp $sed -n 's|h:#include "\(.*\)".*$|h: \1|p' | \
X       $sed -f .hsed >> Makefile.new
X    <.deptmp $sed -n 's|h:#include <\(.*\)>.*$|h: /usr/include/\1|p' \
X       >> Makefile.new
X    for file in `$cat .shlist`; do
X        $echo `$expr X$file : 'X\(.*\).SH`: $file config.sh \; \
X            /bin/sh $file >> Makefile.new
X    done
Xfi
X$rm -f Makefile.old
X$cp Makefile Makefile.old
X$cp Makefile.new Makefile
X$rm Makefile.new
X$echo "# WARNING: Put nothing here or make depend will gobble it up!" >> Makefile
X$rm -f .deptmp `sed 's/\.c/.c.c/' .clist` .shlist .clist .hlist .hsed
X
X!NO!SUBS!
X$eunicefix makedepend
Xchmod 755 makedepend
Xcase `pwd` in
X*SH)
X    $rm -f ../makedepend
X    ln makedepend ../makedepend
X    ;;
Xesac
!STUFFY!FUNK!
echo Extracting perl.h
sed >perl.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: perl.h,v 1.0 87/12/18 13:05:38 root Exp $
X *
X * $Log:        perl.h,v $
X * Revision 1.0  87/12/18  13:05:38  root
X * Initial revision
X * 
X */
X
X#define DEBUGGING
X#define STDSTDIO        /* eventually should be in config.h */
X
X#define VOIDUSED 1
X#include "config.h"
X
X#ifndef BCOPY
X#   define bcopy(s1,s2,l) memcpy(s2,s1,l);
X#   define bzero(s,l) memset(s,0,l);
X#endif
X
X#include <stdio.h>
X#include <ctype.h>
X#include <setjmp.h>
X#include <sys/types.h>
X#include <sys/stat.h>
X#include <time.h>
X#include <sys/times.h>
X
Xtypedef struct arg ARG;
Xtypedef struct cmd CMD;
Xtypedef struct formcmd FCMD;
Xtypedef struct scanpat SPAT;
Xtypedef struct stab STAB;
Xtypedef struct stio STIO;
Xtypedef struct string STR;
Xtypedef struct atbl ARRAY;
Xtypedef struct htbl HASH;
X
X#include "str.h"
X#include "form.h"
X#include "stab.h"
X#include "spat.h"
X#include "arg.h"
X#include "cmd.h"
X#include "array.h"
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
XCMD *add_label();
XCMD *block_head();
XCMD *append_line();
XCMD *make_acmd();
XCMD *make_ccmd();
XCMD *invert();
XCMD *addcond();
XCMD *addloop();
XCMD *wopt();
X
XSPAT *stab_to_spat();
X
XSTAB *stabent();
X
XARG *stab_to_arg();
XARG *op_new();
XARG *make_op();
XARG *make_lval();
XARG *make_match();
XARG *make_split();
XARG *flipflip();
X
XSTR *arg_to_str();
XSTR *str_new();
XSTR *stab_str();
XSTR *eval();
X
XFCMD *load_format();
X
Xchar *scanpat();
Xchar *scansubst();
Xchar *scantrans();
Xchar *scanstr();
Xchar *scanreg();
Xchar *reg_get();
Xchar *str_append_till();
Xchar *str_gets();
X
Xbool do_match();
Xbool do_open();
Xbool do_close();
Xbool do_print();
X
Xint do_subst();
X
Xvoid str_free();
Xvoid freearg();
X
XEXT int line INIT(0);
XEXT int arybase INIT(0);
X
Xstruct outrec {
X    int o_lines;
X    char *o_str;
X    int o_len;
X};
X
XEXT struct outrec outrec;
XEXT struct outrec toprec;
X
XEXT STAB *last_in_stab INIT(Nullstab);
XEXT STAB *defstab INIT(Nullstab);
XEXT STAB *argvstab INIT(Nullstab);
XEXT STAB *envstab INIT(Nullstab);
XEXT STAB *sigstab INIT(Nullstab);
XEXT STAB *defoutstab INIT(Nullstab);
XEXT STAB *curoutstab INIT(Nullstab);
XEXT STAB *argvoutstab INIT(Nullstab);
X
XEXT STR *freestrroot INIT(Nullstr);
X
XEXT FILE *rsfp;
XEXT char buf[1024];
XEXT char *bufptr INIT(buf);
X
XEXT STR *linestr INIT(Nullstr);
X
XEXT char record_separator INIT('\n');
XEXT char *ofs INIT(Nullch);
XEXT char *ors INIT(Nullch);
XEXT char *ofmt INIT(Nullch);
XEXT char *inplace INIT(Nullch);
X
XEXT char tokenbuf[256];
XEXT int expectterm INIT(TRUE);
XEXT int lex_newlines INIT(FALSE);
X
XFILE *popen();
X/* char *str_get(); */
XSTR *interp();
Xvoid free_arg();
XSTIO *stio_new();
X
XEXT struct stat statbuf;
XEXT struct tms timesbuf;
X
X#ifdef DEBUGGING
XEXT int debug INIT(0);
XEXT int dlevel INIT(0);
XEXT char debname[40];
XEXT char debdelim[40];
X#define YYDEBUG;
Xextern int yydebug;
X#endif
X
XEXT STR str_no;
XEXT STR str_yes;
X
X/* runtime control stuff */
X
XEXT struct loop {
X    char *loop_label;
X    jmp_buf loop_env;
X} loop_stack[32];
X
XEXT int loop_ptr INIT(-1);
X
XEXT jmp_buf top_env;
X
XEXT char *goto_targ INIT(Nullch);        /* cmd_exec gets strange when set */
X
Xdouble atof();
Xlong time();
Xstruct tm *gmtime(), *localtime();
X
X#ifdef CHARSPRINTF
X    char *sprintf();
X#else
X    int sprintf();
X#endif
X
X#ifdef EUNICE
X#define UNLINK(f) while (unlink(f) >= 0)
X#else
X#define UNLINK unlink
X#endif
!STUFFY!FUNK!
echo Extracting config.h.SH
sed >config.h.SH <<'!STUFFY!FUNK!' -e 's/X//'
Xcase $CONFIG in
X'')
X    if test ! -f config.sh; then
X        ln ../config.sh . || \
X        ln ../../config.sh . || \
X        ln ../../../config.sh . || \
X        (echo "Can't find config.sh."; exit 1)
X        echo "Using config.sh from above..."
X    fi
X    . config.sh
X    ;;
Xesac
Xecho "Extracting config.h (with variable substitutions)"
Xcat <<!GROK!THIS! >config.h
X/* config.h
X * This file was produced by running the config.h.SH script, which
X * gets its values from config.sh, which is generally produced by
X * running Configure.
X *
X * Feel free to modify any of this as the need arises.  Note, however,
X * that running config.h.SH again will wipe out any changes you've made.
X * For a more permanent change edit config.sh and rerun config.h.SH.
X */
X
X
X/* EUNICE:
X *        This symbol, if defined, indicates that the program is being compiled
X *        under the EUNICE package under VMS.  The program will need to handle
X *        things like files that don't go away the first time you unlink them,
X *        due to version numbering.  It will also need to compensate for lack
X *        of a respectable link() command.
X */
X/* VMS:
X *        This symbol, if defined, indicates that the program is running under
X *        VMS.  It is currently only set in conjunction with the EUNICE symbol.
X */
X#$d_eunice        EUNICE                /**/
X#$d_eunice        VMS                /**/
X
X/* CHARSPRINTF:
X *        This symbol is defined if this system declares "char *sprintf()" in
X *        stdio.h.  The trend seems to be to declare it as "int sprintf()".  It
X *        is up to the package author to declare sprintf correctly based on the
X *        symbol.
X */
X#$d_charsprf        CHARSPRINTF         /**/
X
X/* index:
X *        This preprocessor symbol is defined, along with rindex, if the system
X *        uses the strchr and strrchr routines instead.
X */
X/* rindex:
X *        This preprocessor symbol is defined, along with index, if the system
X *        uses the strchr and strrchr routines instead.
X */
X#$d_index        index strchr        /* cultural */
X#$d_index        rindex strrchr        /*  differences? */
X
X/* STRUCTCOPY:
X *        This symbol, if defined, indicates that this C compiler knows how
X *        to copy structures.  If undefined, you'll need to use a block copy
X *        routine of some sort instead.
X */
X#$d_strctcpy        STRUCTCOPY        /**/
X
X/* vfork:
X *        This symbol, if defined, remaps the vfork routine to fork if the
X *        vfork() routine isn't supported here.
X */
X#$d_vfork        vfork fork        /**/
X
X/* VOIDFLAGS:
X *        This symbol indicates how much support of the void type is given by this
X *        compiler.  What various bits mean:
X *
X *            1 = supports declaration of void
X *            2 = supports arrays of pointers to functions returning void
X *            4 = supports comparisons between pointers to void functions and
X *                    addresses of void functions
X *
X *        The package designer should define VOIDUSED to indicate the requirements
X *        of the package.  This can be done either by #defining VOIDUSED before
X *        including config.h, or by defining defvoidused in Myinit.U.  If the
X *        level of void support necessary is not present, defines void to int.
X */
X#ifndef VOIDUSED
X#define VOIDUSED $defvoidused
X#endif
X#define VOIDFLAGS $voidflags
X#if (VOIDFLAGS & VOIDUSED) != VOIDUSED
X#$define void int                /* is void to be avoided? */
X#$define M_VOID                /* Xenix strikes again */
X#endif
X
X!GROK!THIS!
!STUFFY!FUNK!
echo Extracting cmd.h
sed >cmd.h <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: cmd.h,v 1.0 87/12/18 13:04:59 root Exp $
X *
X * $Log:        cmd.h,v $
X * Revision 1.0  87/12/18  13:04:59  root
X * Initial revision
X * 
X */
X
X#define C_NULL 0
X#define C_IF 1
X#define C_WHILE 2
X#define C_EXPR 3
X#define C_BLOCK 4
X
X#ifndef DOINIT
Xextern char *cmdname[];
X#else
Xchar *cmdname[] = {
X    "NULL",
X    "IF",
X    "WHILE",
X    "EXPR",
X    "BLOCK",
X    "5",
X    "6",
X    "7",
X    "8",
X    "9",
X    "10",
X    "11",
X    "12",
X    "13",
X    "14",
X    "15",
X    "16"
X};
X#endif
X
X#define CF_OPTIMIZE 077        /* type of optimization */
X#define CF_FIRSTNEG 0100/* conditional is ($register NE 'string') */
X#define CF_NESURE 0200        /* if first doesn't match we're sure */
X#define CF_EQSURE 0400        /* if first does match we're sure */
X#define CF_COND        01000        /* test c_expr as conditional first, if not null. */
X                        /* Set for everything except do {} while currently */
X#define CF_LOOP 02000        /* loop on the c_expr conditional (loop modifiers) */
X#define CF_INVERT 04000        /* it's an "unless" or an "until" */
X#define CF_ONCE 010000        /* we've already pushed the label on the stack */
X#define CF_FLIP 020000        /* on a match do flipflop */
X
X#define CFT_FALSE 0        /* c_expr is always false */
X#define CFT_TRUE 1        /* c_expr is always true */
X#define CFT_REG 2        /* c_expr is a simple register */
X#define CFT_ANCHOR 3        /* c_expr is an anchored search /^.../ */
X#define CFT_STROP 4        /* c_expr is a string comparison */
X#define CFT_SCAN 5        /* c_expr is an unanchored search /.../ */
X#define CFT_GETS 6        /* c_expr is $reg = <filehandle> */
X#define CFT_EVAL 7        /* c_expr is not optimized, so call eval() */
X#define CFT_UNFLIP 8        /* 2nd half of range not optimized */
X#define CFT_CHOP 9        /* c_expr is a chop on a register */
X
X#ifndef DOINIT
Xextern char *cmdopt[];
X#else
Xchar *cmdopt[] = {
X    "FALSE",
X    "TRUE",
X    "REG",
X    "ANCHOR",
X    "STROP",
X    "SCAN",
X    "GETS",
X    "EVAL",
X    "UNFLIP",
X    "CHOP",
X    "10"
X};
X#endif
X
Xstruct acmd {
X    STAB        *ac_stab;        /* a symbol table entry */
X    ARG                *ac_expr;        /* any associated expression */
X};
X
Xstruct ccmd {
X    CMD                *cc_true;        /* normal code to do on if and while */
X    CMD                *cc_alt;        /* else code or continue code */
X};
X
Xstruct cmd {
X    CMD                *c_next;        /* the next command at this level */
X    ARG                *c_expr;        /* conditional expression */
X    CMD                *c_head;        /* head of this command list */
X    STR                *c_first;        /* head of string to match as shortcut */
X    STAB        *c_stab;        /* a symbol table entry, mostly for fp */
X    SPAT        *c_spat;        /* pattern used by optimization */
X    char        *c_label;        /* label for this construct */
X    union ucmd {
X        struct acmd acmd;        /* normal command */
X        struct ccmd ccmd;        /* compound command */
X    } ucmd;
X    short        c_flen;                /* len of c_first, if not null */
X    short        c_flags;        /* optimization flags--see above */
X    char        c_type;                /* what this command does */
X};
X
X#define Nullcmd Null(CMD*)
X
XEXT CMD *main_root INIT(Nullcmd);
X
XEXT struct compcmd {
X    CMD *comp_true;
X    CMD *comp_alt;
X};
X
X#ifndef DOINIT
Xextern struct compcmd Nullccmd;
X#else
Xstruct compcmd Nullccmd = {Nullcmd, Nullcmd};
X#endif
Xvoid opt_arg();
Xvoid evalstatic();
XSTR *cmd_exec();
!STUFFY!FUNK!
echo Extracting x2p/Makefile.SH
sed >x2p/Makefile.SH <<'!STUFFY!FUNK!' -e 's/X//'
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
Xecho "Extracting x2p/Makefile (with variable substitutions)"
Xcat >Makefile <<!GROK!THIS!
X# $Header: Makefile.SH,v 1.0 87/12/18 17:50:17 root Exp $
X#
X# $Log:        Makefile.SH,v $
X# Revision 1.0  87/12/18  17:50:17  root
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
Xpublic = a2p s2p
X
Xprivate = 
X
Xmanpages = a2p.man s2p.man
X
Xutil =
X
Xsh = Makefile.SH makedepend.SH
X
Xh = EXTERN.h INTERN.h config.h handy.h hash.h a2p.h str.h util.h
X
Xc = hash.c ../malloc.c str.c util.c walk.c
X
Xobj = hash.o malloc.o str.o util.o walk.o
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
Xa2p: $(obj) a2p.o
X        $(CC) $(LDFLAGS) $(LARGE) $(obj) a2p.o $(libs) -o a2p
X
Xa2p.c: a2p.y
X        @ echo Expect 107 shift/reduce errors...
X        yacc a2p.y
X        mv y.tab.c a2p.c
X
Xa2p.o: a2p.c a2py.c a2p.h EXTERN.h util.h INTERN.h handy.h
X        $(CC) -c $(CFLAGS) $(LARGE) a2p.c
X
X# if a .h file depends on another .h file...
X$(h):
X        touch $@
Xinstall: a2p s2p
X# won't work with csh
X        export PATH || exit 1
X        - mv $(bin)/a2p $(bin)/a2p.old
X        - mv $(bin)/s2p $(bin)/s2p.old
X        - if test `pwd` != $(bin); then cp $(public) $(bin); fi
X        cd $(bin); \
Xfor pub in $(public); do \
Xchmod 755 `basename $$pub`; \
Xdone
X        - test $(bin) = /bin || rm -f /bin/a2p
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
X        rm -f a2p *.orig */*.orig *.o core $(addedbyconf)
X
X# The following lint has practically everything turned on.  Unfortunately,
X# you have to wade through a lot of mumbo jumbo that can't be suppressed.
X# If the source file has a /*NOSTRICT*/ somewhere, ignore the lint message
X# for that spot.
X
Xlint:
X        lint $(lintflags) $(defs) $(c) > a2p.fuzz
X
Xdepend: ../makedepend
X        ../makedepend
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
echo Extracting t/comp.cmdopt
sed >t/comp.cmdopt <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: comp.cmdopt,v 1.0 87/12/18 13:12:19 root Exp $
X
Xprint "1..40\n";
X
X# test the optimization of constants
X
Xif (1) { print "ok 1\n";} else { print "not ok 1\n";}
Xunless (0) { print "ok 2\n";} else { print "not ok 2\n";}
X
Xif (0) { print "not ok 3\n";} else { print "ok 3\n";}
Xunless (1) { print "not ok 4\n";} else { print "ok 4\n";}
X
Xunless (!1) { print "ok 5\n";} else { print "not ok 5\n";}
Xif (!0) { print "ok 6\n";} else { print "not ok 6\n";}
X
Xunless (!0) { print "not ok 7\n";} else { print "ok 7\n";}
Xif (!1) { print "not ok 8\n";} else { print "ok 8\n";}
X
X$x = 1;
Xif (1 && $x) { print "ok 9\n";} else { print "not ok 9\n";}
Xif (0 && $x) { print "not ok 10\n";} else { print "ok 10\n";}
X$x = '';
Xif (1 && $x) { print "not ok 11\n";} else { print "ok 11\n";}
Xif (0 && $x) { print "not ok 12\n";} else { print "ok 12\n";}
X
X$x = 1;
Xif (1 || $x) { print "ok 13\n";} else { print "not ok 13\n";}
Xif (0 || $x) { print "ok 14\n";} else { print "not ok 14\n";}
X$x = '';
Xif (1 || $x) { print "ok 15\n";} else { print "not ok 15\n";}
Xif (0 || $x) { print "not ok 16\n";} else { print "ok 16\n";}
X
X
X# test the optimization of registers
X
X$x = 1;
Xif ($x) { print "ok 17\n";} else { print "not ok 17\n";}
Xunless ($x) { print "not ok 18\n";} else { print "ok 18\n";}
X
X$x = '';
Xif ($x) { print "not ok 19\n";} else { print "ok 19\n";}
Xunless ($x) { print "ok 20\n";} else { print "not ok 20\n";}
X
X# test optimization of string operations
X
X$a = 'a';
Xif ($a eq 'a') { print "ok 21\n";} else { print "not ok 21\n";}
Xif ($a ne 'a') { print "not ok 22\n";} else { print "ok 22\n";}
X
Xif ($a =~ /a/) { print "ok 23\n";} else { print "not ok 23\n";}
Xif ($a !~ /a/) { print "not ok 24\n";} else { print "ok 24\n";}
X# test interaction of logicals and other operations
X
X$a = 'a';
X$x = 1;
Xif ($a eq 'a' && $x) { print "ok 25\n";} else { print "not ok 25\n";}
Xif ($a ne 'a' && $x) { print "not ok 26\n";} else { print "ok 26\n";}
X$x = '';
Xif ($a eq 'a' && $x) { print "not ok 27\n";} else { print "ok 27\n";}
Xif ($a ne 'a' && $x) { print "not ok 28\n";} else { print "ok 28\n";}
X
X$x = 1;
Xif ($a eq 'a' || $x) { print "ok 29\n";} else { print "not ok 29\n";}
Xif ($a ne 'a' || $x) { print "ok 30\n";} else { print "not ok 30\n";}
X$x = '';
Xif ($a eq 'a' || $x) { print "ok 31\n";} else { print "not ok 31\n";}
Xif ($a ne 'a' || $x) { print "not ok 32\n";} else { print "ok 32\n";}
X
X$x = 1;
Xif ($a =~ /a/ && $x) { print "ok 33\n";} else { print "not ok 33\n";}
Xif ($a !~ /a/ && $x) { print "not ok 34\n";} else { print "ok 34\n";}
X$x = '';
Xif ($a =~ /a/ && $x) { print "not ok 35\n";} else { print "ok 35\n";}
X    if ($a !~ /a/ && $x) { print "not ok 36\n";} else { print "ok 36\n";}
X
X$x = 1;
Xif ($a =~ /a/ || $x) { print "ok 37\n";} else { print "not ok 37\n";}
Xif ($a !~ /a/ || $x) { print "ok 38\n";} else { print "not ok 38\n";}
X$x = '';
Xif ($a =~ /a/ || $x) { print "ok 39\n";} else { print "not ok 39\n";}
Xif ($a !~ /a/ || $x) { print "not ok 40\n";} else { print "ok 40\n";}
!STUFFY!FUNK!
echo Extracting config.H
sed >config.H <<'!STUFFY!FUNK!' -e 's/X//'
X/* config.h
X * This file was produced by running the config.h.SH script, which
X * gets its values from config.sh, which is generally produced by
X * running Configure.
X *
X * Feel free to modify any of this as the need arises.  Note, however,
X * that running config.h.SH again will wipe out any changes you've made.
X * For a more permanent change edit config.sh and rerun config.h.SH.
X */
X
X
X/* EUNICE:
X *        This symbol, if defined, indicates that the program is being compiled
X *        under the EUNICE package under VMS.  The program will need to handle
X *        things like files that don't go away the first time you unlink them,
X *        due to version numbering.  It will also need to compensate for lack
X *        of a respectable link() command.
X */
X/* VMS:
X *        This symbol, if defined, indicates that the program is running under
X *        VMS.  It is currently only set in conjunction with the EUNICE symbol.
X */
X#/*undef        EUNICE                /**/
X#/*undef        VMS                /**/
X
X/* CHARSPRINTF:
X *        This symbol is defined if this system declares "char *sprintf()" in
X *        stdio.h.  The trend seems to be to declare it as "int sprintf()".  It
X *        is up to the package author to declare sprintf correctly based on the
X *        symbol.
X */
X#define        CHARSPRINTF         /**/
X
X/* index:
X *        This preprocessor symbol is defined, along with rindex, if the system
X *        uses the strchr and strrchr routines instead.
X */
X/* rindex:
X *        This preprocessor symbol is defined, along with index, if the system
X *        uses the strchr and strrchr routines instead.
X */
X#/*undef        index strchr        /* cultural */
X#/*undef        rindex strrchr        /*  differences? */
X
X/* STRUCTCOPY:
X *        This symbol, if defined, indicates that this C compiler knows how
X *        to copy structures.  If undefined, you'll need to use a block copy
X *        routine of some sort instead.
X */
X#define        STRUCTCOPY        /**/
X
X/* vfork:
X *        This symbol, if defined, remaps the vfork routine to fork if the
X *        vfork() routine isn't supported here.
X */
X#/*undef        vfork fork        /**/
X
X/* VOIDFLAGS:
X *        This symbol indicates how much support of the void type is given by this
X *        compiler.  What various bits mean:
X *
X *            1 = supports declaration of void
X *            2 = supports arrays of pointers to functions returning void
X *            4 = supports comparisons between pointers to void functions and
X *                    addresses of void functions
X *
X *        The package designer should define VOIDUSED to indicate the requirements
X *        of the package.  This can be done either by #defining VOIDUSED before
X *        including config.h, or by defining defvoidused in Myinit.U.  If the
X *        level of void support necessary is not present, defines void to int.
X */
X#ifndef VOIDUSED
X#define VOIDUSED 7
X#endif
X#define VOIDFLAGS 7
X#if (VOIDFLAGS & VOIDUSED) != VOIDUSED
X#define void int                /* is void to be avoided? */
X#define M_VOID                /* Xenix strikes again */
X#endif
X
!STUFFY!FUNK!
echo Extracting t/op.auto
sed >t/op.auto <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.auto,v 1.0 87/12/18 13:13:08 root Exp $
X
Xprint "1..30\n";
X
X$x = 10000;
Xif (0 + ++$x - 1 == 10000) { print "ok 1\n";} else {print "not ok 1\n";}
Xif (0 + $x-- - 1 == 10000) { print "ok 2\n";} else {print "not ok 2\n";}
Xif (1 * $x == 10000) { print "ok 3\n";} else {print "not ok 3\n";}
Xif (0 + $x-- - 0 == 10000) { print "ok 4\n";} else {print "not ok 4\n";}
Xif (1 + $x == 10000) { print "ok 5\n";} else {print "not ok 5\n";}
Xif (1 + $x++ == 10000) { print "ok 6\n";} else {print "not ok 6\n";}
Xif (0 + $x == 10000) { print "ok 7\n";} else {print "not ok 7\n";}
Xif (0 + --$x + 1 == 10000) { print "ok 8\n";} else {print "not ok 8\n";}
Xif (0 + ++$x + 0 == 10000) { print "ok 9\n";} else {print "not ok 9\n";}
Xif ($x == 10000) { print "ok 10\n";} else {print "not ok 10\n";}
X
X$x[0] = 10000;
Xif (0 + ++$x[0] - 1 == 10000) { print "ok 11\n";} else {print "not ok 11\n";}
Xif (0 + $x[0]-- - 1 == 10000) { print "ok 12\n";} else {print "not ok 12\n";}
Xif (1 * $x[0] == 10000) { print "ok 13\n";} else {print "not ok 13\n";}
Xif (0 + $x[0]-- - 0 == 10000) { print "ok 14\n";} else {print "not ok 14\n";}
Xif (1 + $x[0] == 10000) { print "ok 15\n";} else {print "not ok 15\n";}
Xif (1 + $x[0]++ == 10000) { print "ok 16\n";} else {print "not ok 16\n";}
Xif (0 + $x[0] == 10000) { print "ok 17\n";} else {print "not ok 17\n";}
Xif (0 + --$x[0] + 1 == 10000) { print "ok 18\n";} else {print "not ok 18\n";}
Xif (0 + ++$x[0] + 0 == 10000) { print "ok 19\n";} else {print "not ok 19\n";}
Xif ($x[0] == 10000) { print "ok 20\n";} else {print "not ok 20\n";}
X
X$x{0} = 10000;
Xif (0 + ++$x{0} - 1 == 10000) { print "ok 21\n";} else {print "not ok 21\n";}
Xif (0 + $x{0}-- - 1 == 10000) { print "ok 22\n";} else {print "not ok 22\n";}
Xif (1 * $x{0} == 10000) { print "ok 23\n";} else {print "not ok 23\n";}
Xif (0 + $x{0}-- - 0 == 10000) { print "ok 24\n";} else {print "not ok 24\n";}
Xif (1 + $x{0} == 10000) { print "ok 25\n";} else {print "not ok 25\n";}
Xif (1 + $x{0}++ == 10000) { print "ok 26\n";} else {print "not ok 26\n";}
Xif (0 + $x{0} == 10000) { print "ok 27\n";} else {print "not ok 27\n";}
Xif (0 + --$x{0} + 1 == 10000) { print "ok 28\n";} else {print "not ok 28\n";}
Xif (0 + ++$x{0} + 0 == 10000) { print "ok 29\n";} else {print "not ok 29\n";}
Xif ($x{0} == 10000) { print "ok 30\n";} else {print "not ok 30\n";}
!STUFFY!FUNK!
echo Extracting t/op.pat
sed >t/op.pat <<'!STUFFY!FUNK!' -e 's/X//'
X#!./perl
X
X# $Header: op.pat,v 1.0 87/12/18 13:14:07 root Exp $
Xprint "1..22\n";
X
X$x = "abc\ndef\n";
X
Xif ($x =~ /^abc/) {print "ok 1\n";} else {print "not ok 1\n";}
Xif ($x !~ /^def/) {print "ok 2\n";} else {print "not ok 2\n";}
X
X$* = 1;
Xif ($x =~ /^def/) {print "ok 3\n";} else {print "not ok 3\n";}
X$* = 0;
X
X$_ = '123';
Xif (/^([0-9][0-9]*)/) {print "ok 4\n";} else {print "not ok 4\n";}
X
Xif ($x =~ /^xxx/) {print "not ok 5\n";} else {print "ok 5\n";}
Xif ($x !~ /^abc/) {print "not ok 6\n";} else {print "ok 6\n";}
X
Xif ($x =~ /def/) {print "ok 7\n";} else {print "not ok 7\n";}
Xif ($x !~ /def/) {print "not ok 8\n";} else {print "ok 8\n";}
X
Xif ($x !~ /.def/) {print "ok 9\n";} else {print "not ok 9\n";}
Xif ($x =~ /.def/) {print "not ok 10\n";} else {print "ok 10\n";}
X
Xif ($x =~ /\ndef/) {print "ok 11\n";} else {print "not ok 11\n";}
Xif ($x !~ /\ndef/) {print "not ok 12\n";} else {print "ok 12\n";}
X
X$_ = 'aaabbbccc';
Xif (/(a*b*)(c*)/ && $1 eq 'aaabbb' && $2 eq 'ccc') {
X        print "ok 13\n";
X} else {
X        print "not ok 13\n";
X}
Xif (/(a+b+c+)/ && $1 eq 'aaabbbccc') {
X        print "ok 14\n";
X} else {
X        print "not ok 14\n";
X}
X
Xif (/a+b?c+/) {print "not ok 15\n";} else {print "ok 15\n";}
X
X$_ = 'aaabccc';
Xif (/a+b?c+/) {print "ok 16\n";} else {print "not ok 16\n";}
Xif (/a*b+c*/) {print "ok 17\n";} else {print "not ok 17\n";}
X
X$_ = 'aaaccc';
Xif (/a*b?c*/) {print "ok 18\n";} else {print "not ok 18\n";}
Xif (/a*b+c*/) {print "not ok 19\n";} else {print "ok 19\n";}
X
X$_ = 'abcdef';
Xif (/bcd|xyz/) {print "ok 20\n";} else {print "not ok 20\n";}
Xif (/xyz|bcd/) {print "ok 21\n";} else {print "not ok 21\n";}
X
Xif (m|bc/*d|) {print "ok 22\n";} else {print "not ok 22\n";}
!STUFFY!FUNK!
echo ""
echo "End of kit 9 (of 10)"
cat /dev/null >kit9isdone
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