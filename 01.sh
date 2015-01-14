#! /bin/sh

# Make a new directory for the perl sources, cd to it, and run kits 1
# thru 10 through sh.  When all 10 kits have been run, read README.

echo "This is perl 1.0 kit 1 (of 10).  If kit 1 is complete, the line"
echo '"'"End of kit 1 (of 10)"'" will echo at the end.'
echo ""
export PATH || (echo "You didn't use sh, you clunch." ; kill $$)
mkdir x2p 2>/dev/null
echo Extracting README
sed >README <<'!STUFFY!FUNK!' -e 's/X//'
X
X                        Perl Kit, Version 1.0
X
X                    Copyright (c) 1987, Larry Wall
X
XYou may copy the perl kit in whole or in part as long as you don't try to
Xmake money off it, or pretend that you wrote it.
X--------------------------------------------------------------------------
X
XPerl is a language that combines some of the features of C, sed, awk and shell.
XSee the manual page for more hype.
X
XPerl will probably not run on machines with a small address space.
X
XPlease read all the directions below before you proceed any further, and
Xthen follow them carefully.  Failure to do so may void your warranty. :-)
X
XAfter you have unpacked your kit, you should have all the files listed
Xin MANIFEST.
X
XInstallation
X
X1)  Run Configure.  This will figure out various things about your system.
X    Some things Configure will figure out for itself, other things it will
X    ask you about.  It will then proceed to make config.h, config.sh, and
X    Makefile.
X
X    You might possibly have to trim # comments from the front of Configure
X    if your sh doesn't handle them, but all other # comments will be taken
X    care of.
X
X    (If you don't have sh, you'll have to copy the sample file config.H to
X    config.h and edit the config.h to reflect your system's peculiarities.)
X
X2)  Glance through config.h to make sure system dependencies are correct.
X    Most of them should have been taken care of by running the Configure script.
X
X    If you have any additional changes to make to the C definitions, they
X    can be done in the Makefile, or in config.h.  Bear in mind that they will
X    get undone next time you run Configure.
X
X3)  make depend
X
X    This will look for all the includes and modify Makefile accordingly.
X    Configure will offer to do this for you.
X
X4)  make
X
X    This will attempt to make perl in the current directory.
X
X5)  make test
X
X    This will run the regression tests on the perl you just made.
X    If it doesn't say "All tests successful" then something went wrong.
X    See the README in the t subdirectory.
X
X6)  make install
X
X    This will put perl into a public directory (normally /usr/local/bin).
X    It will also try to put the man pages in a reasonable place.  It will not
X    nroff the man page, however.  You may need to be root to do this.  If
X    you are not root, you must own the directories in question and you should
X    ignore any messages about chown not working.
X
X7)  Read the manual entry before running perl.
X
X8)  Go down to the x2p directory and do a "make depend, a "make" and a
X    "make install" to create the awk to perl and sed to perl translators.
X
X9)  IMPORTANT!  Help save the world!  Communicate any problems and suggested
X    patches to me, lw...@jpl-devvax.jpl.nasa.gov (Larry Wall), so we can
X    keep the world in sync.  If you have a problem, there's someone else
X    out there who either has had or will have the same problem.
X
X    If possible, send in patches such that the patch program will apply them.
X    Context diffs are the best, then normal diffs.  Don't send ed scripts--
X    I've probably changed my copy since the version you have.
X
X    Watch for perl patches in comp.sources.bugs.  Patches will generally be
X    in a form usable by the patch program.  If you are just now bringing up
X    perl and aren't sure how many patches there are, write to me and I'll
X    send any you don't have.  Your current patch level is shown in patchlevel.h.
X
!STUFFY!FUNK!
echo Extracting x2p/walk.c
sed >x2p/walk.c <<'!STUFFY!FUNK!' -e 's/X//'
X/* $Header: walk.c,v 1.0 87/12/18 13:07:40 root Exp $
X *
X * $Log:        walk.c,v $
X * Revision 1.0  87/12/18  13:07:40  root
X * Initial revision
X * 
X */
X
X#include "handy.h"
X#include "EXTERN.h"
X#include "util.h"
X#include "a2p.h"
X
Xbool exitval = FALSE;
Xbool realexit = FALSE;
Xint maxtmp = 0;
X
XSTR *
Xwalk(useval,level,node,numericptr)
Xint useval;
Xint level;
Xregister int node;
Xint *numericptr;
X{
X    register int len;
X    register STR *str;
X    register int type;
X    register int i;
X    register STR *tmpstr;
X    STR *tmp2str;
X    char *t;
X    char *d, *s;
X    int numarg;
X    int numeric = FALSE;
X    STR *fstr;
X    char *index();
X
X    if (!node) {
X        *numericptr = 0;
X        return str_make("");
X    }
X    type = ops[node].ival;
X    len = type >> 8;
X    type &= 255;
X    switch (type) {
X    case OPROG:
X        str = walk(0,level,ops[node+1].ival,&numarg);
X        opens = str_new(0);
X        if (do_split && need_entire && !absmaxfld)
X            split_to_array = TRUE;
X        if (do_split && split_to_array)
X            set_array_base = TRUE;
X        if (set_array_base) {
X            str_cat(str,"$[ = 1;\t\t\t# set array base to 1\n");
X        }
X        if (fswitch && !const_FS)
X            const_FS = fswitch;
X        if (saw_FS > 1 || saw_RS)
X            const_FS = 0;
X        if (saw_ORS && need_entire)
X            do_chop = TRUE;
X        if (fswitch) {
X            str_cat(str,"$FS = '");
X            if (index("*+?.[]()|^$\\",fswitch))
X                str_cat(str,"\\");
X            sprintf(tokenbuf,"%c",fswitch);
X            str_cat(str,tokenbuf);
X            str_cat(str,"';\t\t# field separator from -F switch\n");
X        }
X        else if (saw_FS && !const_FS) {
X            str_cat(str,"$FS = '[ \\t\\n]+';\t\t# default field separator\n");
X        }
X        if (saw_OFS) {
X            str_cat(str,"$, = ' ';\t\t# default output field separator\n");
X        }
X        if (saw_ORS) {
X            str_cat(str,"$\\ = \"\\n\";\t\t# default output record separator\n");
X        }
X        if (str->str_cur > 20)
X            str_cat(str,"\n");
X        if (ops[node+2].ival) {
X            str_scat(str,fstr=walk(0,level,ops[node+2].ival,&numarg));
X            str_free(fstr);
X            str_cat(str,"\n\n");
X        }
X        if (saw_line_op)
X            str_cat(str,"line: ");
X        str_cat(str,"while (<>) {\n");
X        tab(str,++level);
X        if (saw_FS && !const_FS)
X            do_chop = TRUE;
X        if (do_chop) {
X            str_cat(str,"chop;\t# strip record separator\n");
X            tab(str,level);
X        }
X        arymax = 0;
X        if (namelist) {
X            while (isalpha(*namelist)) {
X                for (d = tokenbuf,s=namelist;
X                  isalpha(*s) || isdigit(*s) || *s == '_';
X                  *d++ = *s++) ;
X                *d = '\0';
X                while (*s && !isalpha(*s)) s++;
X                namelist = s;
X                nameary[++arymax] = savestr(tokenbuf);
X            }
X        }
X        if (maxfld < arymax)
X            maxfld = arymax;
X        if (do_split)
X            emit_split(str,level);
X        str_scat(str,fstr=walk(0,level,ops[node+3].ival,&numarg));
X        str_free(fstr);
X        fixtab(str,--level);
X        str_cat(str,"}\n");
X        if (ops[node+4].ival) {
X            realexit = TRUE;
X            str_cat(str,"\n");
X            tab(str,level);
X            str_scat(str,fstr=walk(0,level,ops[node+4].ival,&numarg));
X            str_free(fstr);
X            str_cat(str,"\n");
X        }
X        if (exitval)
X            str_cat(str,"exit ExitValue;\n");
X        if (do_fancy_opens) {
X            str_cat(str,"\n\
Xsub Pick {\n\
X    ($name) = @_;\n\
X    $fh = $opened{$name};\n\
X    if (!$fh) {\n\
X        $nextfh == 0 && open(fh_0,$name);\n\
X        $nextfh == 1 && open(fh_1,$name);\n\
X        $nextfh == 2 && open(fh_2,$name);\n\
X        $nextfh == 3 && open(fh_3,$name);\n\
X        $nextfh == 4 && open(fh_4,$name);\n\
X        $nextfh == 5 && open(fh_5,$name);\n\
X        $nextfh == 6 && open(fh_6,$name);\n\
X        $nextfh == 7 && open(fh_7,$name);\n\
X        $nextfh == 8 && open(fh_8,$name);\n\
X        $nextfh == 9 && open(fh_9,$name);\n\
X        $fh = $opened{$name} = 'fh_' . $nextfh++;\n\
X    }\n\
X    select($fh);\n\
X}\n\
X");
X        }
X        break;
X    case OHUNKS:
X        str = walk(0,level,ops[node+1].ival,&numarg);
X        str_scat(str,fstr=walk(0,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        if (len == 3) {
X            str_scat(str,fstr=walk(0,level,ops[node+3].ival,&numarg));
X            str_free(fstr);
X        }
X        else {
X        }
X        break;
X    case ORANGE:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str," .. ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OPAT:
X        goto def;
X    case OREGEX:
X        str = str_new(0);
X        str_set(str,"/");
X        tmpstr=walk(0,level,ops[node+1].ival,&numarg);
X        /* translate \nnn to [\nnn] */
X        for (s = tmpstr->str_ptr, d = tokenbuf; *s; s++, d++) {
X            if (*s == '\\' && isdigit(s[1]) && isdigit(s[2]) && isdigit(s[3])) {
X                *d++ = '[';
X                *d++ = *s++;
X                *d++ = *s++;
X                *d++ = *s++;
X                *d++ = *s;
X                *d = ']';
X            }
X            else
X                *d = *s;
X        }
X        *d = '\0';
X        str_cat(str,tokenbuf);
X        str_free(tmpstr);
X        str_cat(str,"/");
X        break;
X    case OHUNK:
X        if (len == 1) {
X            str = str_new(0);
X            str = walk(0,level,oper1(OPRINT,0),&numarg);
X            str_cat(str," if ");
X            str_scat(str,fstr=walk(0,level,ops[node+1].ival,&numarg));
X            str_free(fstr);
X            str_cat(str,";");
X        }
X        else {
X            tmpstr = walk(0,level,ops[node+1].ival,&numarg);
X            if (*tmpstr->str_ptr) {
X                str = str_new(0);
X                str_set(str,"if (");
X                str_scat(str,tmpstr);
X                str_cat(str,") {\n");
X                tab(str,++level);
X                str_scat(str,fstr=walk(0,level,ops[node+2].ival,&numarg));
X                str_free(fstr);
X                fixtab(str,--level);
X                str_cat(str,"}\n");
X                tab(str,level);
X            }
X            else {
X                str = walk(0,level,ops[node+2].ival,&numarg);
X            }
X        }
X        break;
X    case OPPAREN:
X        str = str_new(0);
X        str_set(str,"(");
X        str_scat(str,fstr=walk(useval != 0,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,")");
X        break;
X    case OPANDAND:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str," && ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OPOROR:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str," || ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OPNOT:
X        str = str_new(0);
X        str_set(str,"!");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OCPAREN:
X        str = str_new(0);
X        str_set(str,"(");
X        str_scat(str,fstr=walk(useval != 0,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        numeric |= numarg;
X        str_cat(str,")");
X        break;
X    case OCANDAND:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        str_cat(str," && ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OCOROR:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        str_cat(str," || ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OCNOT:
X        str = str_new(0);
X        str_set(str,"!");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        numeric = 1;
X        break;
X    case ORELOP:
X        str = walk(1,level,ops[node+2].ival,&numarg);
X        numeric |= numarg;
X        tmpstr = walk(0,level,ops[node+1].ival,&numarg);
X        tmp2str = walk(1,level,ops[node+3].ival,&numarg);
X        numeric |= numarg;
X        if (!numeric) {
X            t = tmpstr->str_ptr;
X            if (strEQ(t,"=="))
X                str_set(tmpstr,"eq");
X            else if (strEQ(t,"!="))
X                str_set(tmpstr,"ne");
X            else if (strEQ(t,"<"))
X                str_set(tmpstr,"lt");
X            else if (strEQ(t,"<="))
X                str_set(tmpstr,"le");
X            else if (strEQ(t,">"))
X                str_set(tmpstr,"gt");
X            else if (strEQ(t,">="))
X                str_set(tmpstr,"ge");
X            if (!index(tmpstr->str_ptr,'\'') && !index(tmpstr->str_ptr,'"') &&
X              !index(tmp2str->str_ptr,'\'') && !index(tmp2str->str_ptr,'"') )
X                numeric |= 2;
X        }
X        if (numeric & 2) {
X            if (numeric & 1)                /* numeric is very good guess */
X                str_cat(str," ");
X            else
X                str_cat(str,"\377");
X            numeric = 1;
X        }
X        else
X            str_cat(str," ");
X        str_scat(str,tmpstr);
X        str_free(tmpstr);
X        str_cat(str," ");
X        str_scat(str,tmp2str);
X        str_free(tmp2str);
X        numeric = 1;
X        break;
X    case ORPAREN:
X        str = str_new(0);
X        str_set(str,"(");
X        str_scat(str,fstr=walk(useval != 0,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        numeric |= numarg;
X        str_cat(str,")");
X        break;
X    case OMATCHOP:
X        str = walk(1,level,ops[node+2].ival,&numarg);
X        str_cat(str," ");
X        tmpstr = walk(0,level,ops[node+1].ival,&numarg);
X        if (strEQ(tmpstr->str_ptr,"~"))
X            str_cat(str,"=~");
X        else {
X            str_scat(str,tmpstr);
X            str_free(tmpstr);
X        }
X        str_cat(str," ");
X        str_scat(str,fstr=walk(1,level,ops[node+3].ival,&numarg));
X        str_free(fstr);
X        numeric = 1;
X        break;
X    case OMPAREN:
X        str = str_new(0);
X        str_set(str,"(");
X        str_scat(str,fstr=walk(useval != 0,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        numeric |= numarg;
X        str_cat(str,")");
X        break;
X    case OCONCAT:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str," . ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OASSIGN:
X        str = walk(0,level,ops[node+2].ival,&numarg);
X        str_cat(str," ");
X        tmpstr = walk(0,level,ops[node+1].ival,&numarg);
X        str_scat(str,tmpstr);
X        if (str_len(tmpstr) > 1)
X            numeric = 1;
X        str_free(tmpstr);
X        str_cat(str," ");
X        str_scat(str,fstr=walk(1,level,ops[node+3].ival,&numarg));
X        str_free(fstr);
X        numeric |= numarg;
X        if (strEQ(str->str_ptr,"$FS = '\240'"))
X            str_set(str,"$FS = '[\240\\n\\t]+'");
X        break;
X    case OADD:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str," + ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        numeric = 1;
X        break;
X    case OSUB:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str," - ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        numeric = 1;
X        break;
X    case OMULT:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str," * ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        numeric = 1;
X        break;
X    case ODIV:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str," / ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        numeric = 1;
X        break;
X    case OMOD:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str," % ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        numeric = 1;
X        break;
X    case OPOSTINCR:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str,"++");
X        numeric = 1;
X        break;
X    case OPOSTDECR:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str,"--");
X        numeric = 1;
X        break;
X    case OPREINCR:
X        str = str_new(0);
X        str_set(str,"++");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        numeric = 1;
X        break;
X    case OPREDECR:
X        str = str_new(0);
X        str_set(str,"--");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        numeric = 1;
X        break;
X    case OUMINUS:
X        str = str_new(0);
X        str_set(str,"-");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        numeric = 1;
X        break;
X    case OUPLUS:
X        numeric = 1;
X        goto def;
X    case OPAREN:
X        str = str_new(0);
X        str_set(str,"(");
X        str_scat(str,fstr=walk(useval != 0,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,")");
X        numeric |= numarg;
X        break;
X    case OGETLINE:
X        str = str_new(0);
X        str_set(str,"$_ = <>;\n");
X        tab(str,level);
X        if (do_chop) {
X            str_cat(str,"chop;\t# strip record separator\n");
X            tab(str,level);
X        }
X        if (do_split)
X            emit_split(str,level);
X        break;
X    case OSPRINTF:
X        str = str_new(0);
X        str_set(str,"sprintf(");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,")");
X        break;
X    case OSUBSTR:
X        str = str_new(0);
X        str_set(str,"substr(");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,", ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,", ");
X        if (len == 3) {
X            str_scat(str,fstr=walk(1,level,ops[node+3].ival,&numarg));
X            str_free(fstr);
X        }
X        else
X            str_cat(str,"999999");
X        str_cat(str,")");
X        break;
X    case OSTRING:
X        str = str_new(0);
X        str_set(str,ops[node+1].cval);
X        break;
X    case OSPLIT:
X        str = str_new(0);
X        numeric = 1;
X        tmpstr = walk(1,level,ops[node+2].ival,&numarg);
X        if (useval)
X            str_set(str,"(@");
X        else
X            str_set(str,"@");
X        str_scat(str,tmpstr);
X        str_cat(str," = split(");
X        if (len == 3) {
X            fstr = walk(1,level,ops[node+3].ival,&numarg);
X            if (str_len(fstr) == 3 && *fstr->str_ptr == '\'') {
X                i = fstr->str_ptr[1] & 127;
X                if (index("*+?.[]()|^$\\",i))
X                    sprintf(tokenbuf,"/\\%c/",i);
X                else
X                    sprintf(tokenbuf,"/%c/",i);
X                str_cat(str,tokenbuf);
X            }
X            else
X                str_scat(str,fstr);
X            str_free(fstr);
X        }
X        else if (const_FS) {
X            sprintf(tokenbuf,"/[%c\\n]/",const_FS);
X            str_cat(str,tokenbuf);
X        }
X        else if (saw_FS)
X            str_cat(str,"$FS");
X        else
X            str_cat(str,"/[ \\t\\n]+/");
X        str_cat(str,", ");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,")");
X        if (useval) {
X            str_cat(str,")");
X        }
X        str_free(tmpstr);
X        break;
X    case OINDEX:
X        str = str_new(0);
X        str_set(str,"index(");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,", ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,")");
X        numeric = 1;
X        break;
X    case ONUM:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        break;
X    case OSTR:
X        tmpstr = walk(1,level,ops[node+1].ival,&numarg);
X        s = "'";
X        for (t = tmpstr->str_ptr; *t; t++) {
X            if (*t == '\\' || *t == '\'')
X                s = "\"";
X            *t += 128;
X        }
X        str = str_new(0);
X        str_set(str,s);
X        str_scat(str,tmpstr);
X        str_free(tmpstr);
X        str_cat(str,s);
X        break;
X    case OVAR:
X        str = str_new(0);
X        str_set(str,"$");
X        str_scat(str,tmpstr=walk(1,level,ops[node+1].ival,&numarg));
X        if (len == 1) {
X            tmp2str = hfetch(symtab,tmpstr->str_ptr);
X            if (tmp2str && atoi(tmp2str->str_ptr))
X                numeric = 2;
X            if (strEQ(str->str_ptr,"$NR")) {
X                numeric = 1;
X                str_set(str,"$.");
X            }
X            else if (strEQ(str->str_ptr,"$NF")) {
X                numeric = 1;
X                str_set(str,"$#Fld");
X            }
X            else if (strEQ(str->str_ptr,"$0"))
X                str_set(str,"$_");
X        }
X        else {
X            str_cat(tmpstr,"[]");
X            tmp2str = hfetch(symtab,tmpstr->str_ptr);
X            if (tmp2str && atoi(tmp2str->str_ptr))
X                str_cat(str,"[");
X            else
X                str_cat(str,"{");
X            str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X            str_free(fstr);
X            if (tmp2str && atoi(tmp2str->str_ptr))
X                strcpy(tokenbuf,"]");
X            else
X                strcpy(tokenbuf,"}");
X            *tokenbuf += 128;
X            str_cat(str,tokenbuf);
X        }
X        str_free(tmpstr);
X        break;
X    case OFLD:
X        str = str_new(0);
X        if (split_to_array) {
X            str_set(str,"$Fld");
X            str_cat(str,"[");
X            str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X            str_free(fstr);
X            str_cat(str,"]");
X        }
X        else {
X            i = atoi(walk(1,level,ops[node+1].ival,&numarg)->str_ptr);
X            if (i <= arymax)
X                sprintf(tokenbuf,"$%s",nameary[i]);
X            else
X                sprintf(tokenbuf,"$Fld%d",i);
X            str_set(str,tokenbuf);
X        }
X        break;
X    case OVFLD:
X        str = str_new(0);
X        str_set(str,"$Fld[");
X        i = ops[node+1].ival;
X        if ((ops[i].ival & 255) == OPAREN)
X            i = ops[i+1].ival;
X        tmpstr=walk(1,level,i,&numarg);
X        str_scat(str,tmpstr);
X        str_free(tmpstr);
X        str_cat(str,"]");
X        break;
X    case OJUNK:
X        goto def;
X    case OSNEWLINE:
X        str = str_new(2);
X        str_set(str,";\n");
X        tab(str,level);
X        break;
X    case ONEWLINE:
X        str = str_new(1);
X        str_set(str,"\n");
X        tab(str,level);
X        break;
X    case OSCOMMENT:
X        str = str_new(0);
X        str_set(str,";");
X        tmpstr = walk(0,level,ops[node+1].ival,&numarg);
X        for (s = tmpstr->str_ptr; *s && *s != '\n'; s++)
X            *s += 128;
X        str_scat(str,tmpstr);
X        str_free(tmpstr);
X        tab(str,level);
X        break;
X    case OCOMMENT:
X        str = str_new(0);
X        tmpstr = walk(0,level,ops[node+1].ival,&numarg);
X        for (s = tmpstr->str_ptr; *s && *s != '\n'; s++)
X            *s += 128;
X        str_scat(str,tmpstr);
X        str_free(tmpstr);
X        tab(str,level);
X        break;
X    case OCOMMA:
X        str = walk(1,level,ops[node+1].ival,&numarg);
X        str_cat(str,", ");
X        str_scat(str,fstr=walk(1,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OSEMICOLON:
X        str = str_new(1);
X        str_set(str,"; ");
X        break;
X    case OSTATES:
X        str = walk(0,level,ops[node+1].ival,&numarg);
X        str_scat(str,fstr=walk(0,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OSTATE:
X        str = str_new(0);
X        if (len >= 1) {
X            str_scat(str,fstr=walk(0,level,ops[node+1].ival,&numarg));
X            str_free(fstr);
X            if (len >= 2) {
X                tmpstr = walk(0,level,ops[node+2].ival,&numarg);
X                if (*tmpstr->str_ptr == ';') {
X                    addsemi(str);
X                    str_cat(str,tmpstr->str_ptr+1);
X                }
X                str_free(tmpstr);
X            }
X        }
X        break;
X    case OPRINTF:
X    case OPRINT:
X        str = str_new(0);
X        if (len == 3) {                /* output redirection */
X            tmpstr = walk(1,level,ops[node+3].ival,&numarg);
X            tmp2str = walk(1,level,ops[node+2].ival,&numarg);
X            if (!do_fancy_opens) {
X                t = tmpstr->str_ptr;
X                if (*t == '"' || *t == '\'')
X                    t = cpytill(tokenbuf,t+1,*t);
X                else
X                    fatal("Internal error: OPRINT");
X                d = savestr(t);
X                s = savestr(tokenbuf);
X                for (t = tokenbuf; *t; t++) {
X                    *t &= 127;
X                    if (!isalpha(*t) && !isdigit(*t))
X                        *t = '_';
X                }
X                if (!index(tokenbuf,'_'))
X                    strcpy(t,"_fh");
X                str_cat(opens,"open(");
X                str_cat(opens,tokenbuf);
X                str_cat(opens,", ");
X                d[1] = '\0';
X                str_cat(opens,d);
X                str_scat(opens,tmp2str);
X                str_cat(opens,tmpstr->str_ptr+1);
X                if (*tmp2str->str_ptr == '|')
X                    str_cat(opens,") || die 'Cannot pipe to \"");
X                else
X                    str_cat(opens,") || die 'Cannot create file \"");
X                if (*d == '"')
X                    str_cat(opens,"'.\"");
X                str_cat(opens,s);
X                if (*d == '"')
X                    str_cat(opens,"\".'");
X                str_cat(opens,"\".';\n");
X                str_free(tmpstr);
X                str_free(tmp2str);
X                safefree(s);
X                safefree(d);
X            }
X            else {
X                sprintf(tokenbuf,"do Pick('%s' . (%s)) &&\n",
X                   tmp2str->str_ptr, tmpstr->str_ptr);
X                str_cat(str,tokenbuf);
X                tab(str,level+1);
X                *tokenbuf = '\0';
X                str_free(tmpstr);
X                str_free(tmp2str);
X            }
X        }
X        else
X            strcpy(tokenbuf,"stdout");
X        if (type == OPRINTF)
X            str_cat(str,"printf");
X        else
X            str_cat(str,"print");
X        if (len == 3 || do_fancy_opens) {
X            if (*tokenbuf)
X                str_cat(str," ");
X            str_cat(str,tokenbuf);
X        }
X        tmpstr = walk(1+(type==OPRINT),level,ops[node+1].ival,&numarg);
X        if (!*tmpstr->str_ptr && lval_field) {
X            t = saw_OFS ? "$," : "' '";
X            if (split_to_array) {
X                sprintf(tokenbuf,"join(%s,@Fld)",t);
X                str_cat(tmpstr,tokenbuf);
X            }
X            else {
X                for (i = 1; i < maxfld; i++) {
X                    if (i <= arymax)
X                        sprintf(tokenbuf,"$%s, ",nameary[i]);
X                    else
X                        sprintf(tokenbuf,"$Fld%d, ",i);
X                    str_cat(tmpstr,tokenbuf);
X                }
X                if (maxfld <= arymax)
X                    sprintf(tokenbuf,"$%s",nameary[maxfld]);
X                else
X                    sprintf(tokenbuf,"$Fld%d",maxfld);
X                str_cat(tmpstr,tokenbuf);
X            }
X        }
X        if (*tmpstr->str_ptr) {
X            str_cat(str," ");
X            str_scat(str,tmpstr);
X        }
X        else {
X            str_cat(str," $_");
X        }
X        str_free(tmpstr);
X        break;
X    case OLENGTH:
X        str = str_make("length(");
X        goto maybe0;
X    case OLOG:
X        str = str_make("log(");
X        goto maybe0;
X    case OEXP:
X        str = str_make("exp(");
X        goto maybe0;
X    case OSQRT:
X        str = str_make("sqrt(");
X        goto maybe0;
X    case OINT:
X        str = str_make("int(");
X      maybe0:
X        numeric = 1;
X        if (len > 0)
X            tmpstr = walk(1,level,ops[node+1].ival,&numarg);
X        else
X            tmpstr = str_new(0);;
X        if (!*tmpstr->str_ptr) {
X            if (lval_field) {
X                t = saw_OFS ? "$," : "' '";
X                if (split_to_array) {
X                    sprintf(tokenbuf,"join(%s,@Fld)",t);
X                    str_cat(tmpstr,tokenbuf);
X                }
X                else {
X                    sprintf(tokenbuf,"join(%s, ",t);
X                    str_cat(tmpstr,tokenbuf);
X                    for (i = 1; i < maxfld; i++) {
X                        if (i <= arymax)
X                            sprintf(tokenbuf,"$%s,",nameary[i]);
X                        else
X                            sprintf(tokenbuf,"$Fld%d,",i);
X                        str_cat(tmpstr,tokenbuf);
X                    }
X                    if (maxfld <= arymax)
X                        sprintf(tokenbuf,"$%s)",nameary[maxfld]);
X                    else
X                        sprintf(tokenbuf,"$Fld%d)",maxfld);
X                    str_cat(tmpstr,tokenbuf);
X                }
X            }
X            else
X                str_cat(tmpstr,"$_");
X        }
X        if (strEQ(tmpstr->str_ptr,"$_")) {
X            if (type == OLENGTH && !do_chop) {
X                str = str_make("(length(");
X                str_cat(tmpstr,") - 1");
X            }
X        }
X        str_scat(str,tmpstr);
X        str_free(tmpstr);
X        str_cat(str,")");
X        break;
X    case OBREAK:
X        str = str_new(0);
X        str_set(str,"last");
X        break;
X    case ONEXT:
X        str = str_new(0);
X        str_set(str,"next line");
X        break;
X    case OEXIT:
X        str = str_new(0);
X        if (realexit) {
X            str_set(str,"exit");
X            if (len == 1) {
X                str_cat(str," ");
X                exitval = TRUE;
X                str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X                str_free(fstr);
X            }
X        }
X        else {
X            if (len == 1) {
X                str_set(str,"ExitValue = ");
X                exitval = TRUE;
X                str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X                str_free(fstr);
X                str_cat(str,"; ");
X            }
X            str_cat(str,"last line");
X        }
X        break;
X    case OCONTINUE:
X        str = str_new(0);
X        str_set(str,"next");
X        break;
X    case OREDIR:
X        goto def;
X    case OIF:
X        str = str_new(0);
X        str_set(str,"if (");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,") ");
X        str_scat(str,fstr=walk(0,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        if (len == 3) {
X            i = ops[node+3].ival;
X            if (i) {
X                if ((ops[i].ival & 255) == OBLOCK) {
X                    i = ops[i+1].ival;
X                    if (i) {
X                        if ((ops[i].ival & 255) != OIF)
X                            i = 0;
X                    }
X                }
X                else
X                    i = 0;
X            }
X            if (i) {
X                str_cat(str,"els");
X                str_scat(str,fstr=walk(0,level,i,&numarg));
X                str_free(fstr);
X            }
X            else {
X                str_cat(str,"else ");
X                str_scat(str,fstr=walk(0,level,ops[node+3].ival,&numarg));
X                str_free(fstr);
X            }
X        }
X        break;
X    case OWHILE:
X        str = str_new(0);
X        str_set(str,"while (");
X        str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,") ");
X        str_scat(str,fstr=walk(0,level,ops[node+2].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OFOR:
X        str = str_new(0);
X        str_set(str,"for (");
X        str_scat(str,tmpstr=walk(1,level,ops[node+1].ival,&numarg));
X        i = numarg;
X        if (i) {
X            t = s = tmpstr->str_ptr;
X            while (isalpha(*t) || isdigit(*t) || *t == '$' || *t == '_')
X                t++;
X            i = t - s;
X            if (i < 2)
X                i = 0;
X        }
X        str_cat(str,"; ");
X        fstr=walk(1,level,ops[node+2].ival,&numarg);
X        if (i && (t = index(fstr->str_ptr,0377))) {
X            if (strnEQ(fstr->str_ptr,s,i))
X                *t = ' ';
X        }
X        str_scat(str,fstr);
X        str_free(fstr);
X        str_free(tmpstr);
X        str_cat(str,"; ");
X        str_scat(str,fstr=walk(1,level,ops[node+3].ival,&numarg));
X        str_free(fstr);
X        str_cat(str,") ");
X        str_scat(str,fstr=walk(0,level,ops[node+4].ival,&numarg));
X        str_free(fstr);
X        break;
X    case OFORIN:
X        tmpstr=walk(0,level,ops[node+2].ival,&numarg);
X        str = str_new(0);
X        str_sset(str,tmpstr);
X        str_cat(str,"[]");
X        tmp2str = hfetch(symtab,str->str_ptr);
X        if (tmp2str && atoi(tmp2str->str_ptr)) {
X            maxtmp++;
X            fstr=walk(1,level,ops[node+1].ival,&numarg);
X            sprintf(tokenbuf,
X              "for ($T_%d = 1; ($%s = $%s[$T_%d]) || $T_%d <= $#%s; $T_%d++)%c",
X              maxtmp,
X              fstr->str_ptr,
X              tmpstr->str_ptr,
X              maxtmp,
X              maxtmp,
X              tmpstr->str_ptr,
X              maxtmp,
X              0377);
X            str_set(str,tokenbuf);
X            str_free(fstr);
X            str_scat(str,fstr=walk(0,level,ops[node+3].ival,&numarg));
X            str_free(fstr);
X        }
X        else {
X            str_set(str,"while (($junkkey,$");
X            str_scat(str,fstr=walk(1,level,ops[node+1].ival,&numarg));
X            str_free(fstr);
X            str_cat(str,") = each(");
X            str_scat(str,tmpstr);
X            str_cat(str,")) ");
X            str_scat(str,fstr=walk(0,level,ops[node+3].ival,&numarg));
X            str_free(fstr);
X        }
X        str_free(tmpstr);
X        break;
X    case OBLOCK:
X        str = str_new(0);
X        str_set(str,"{");
X        if (len == 2) {
X            str_scat(str,fstr=walk(0,level,ops[node+2].ival,&numarg));
X            str_free(fstr);
X        }
X        fixtab(str,++level);
X        str_scat(str,fstr=walk(0,level,ops[node+1].ival,&numarg));
X        str_free(fstr);
X        addsemi(str);
X        fixtab(str,--level);
X        str_cat(str,"}\n");
X        tab(str,level);
X        break;
X    default:
X      def:
X        if (len) {
X            if (len > 5)
X                fatal("Garbage length in walk");
X            str = walk(0,level,ops[node+1].ival,&numarg);
X            for (i = 2; i<= len; i++) {
X                str_scat(str,fstr=walk(0,level,ops[node+i].ival,&numarg));
X                str_free(fstr);
X            }
X        }
X        else {
X            str = Nullstr;
X        }
X        break;
X    }
X    if (!str)
X        str = str_new(0);
X    *numericptr = numeric;
X#ifdef DEBUGGING
X    if (debug & 4) {
X        printf("%3d %5d %15s %d %4d ",level,node,opname[type],len,str->str_cur);
X        for (t = str->str_ptr; *t && t - str->str_ptr < 40; t++)
X            if (*t == '\n')
X                printf("\\n");
X            else if (*t == '\t')
X                printf("\\t");
X            else
X                putchar(*t);
X        putchar('\n');
X    }
X#endif
X    return str;
X}
X
Xtab(str,lvl)
Xregister STR *str;
Xregister int lvl;
X{
X    while (lvl > 1) {
X        str_cat(str,"\t");
X        lvl -= 2;
X    }
X    if (lvl)
X        str_cat(str,"    ");
X}
X
Xfixtab(str,lvl)
Xregister STR *str;
Xregister int lvl;
X{
X    register char *s;
X
X    /* strip trailing white space */
X
X    s = str->str_ptr+str->str_cur - 1;
X    while (s >= str->str_ptr && (*s == ' ' || *s == '\t'))
X        s--;
X    s[1] = '\0';
X    str->str_cur = s + 1 - str->str_ptr;
X    if (s >= str->str_ptr && *s != '\n')
X        str_cat(str,"\n");
X
X    tab(str,lvl);
X}
X
Xaddsemi(str)
Xregister STR *str;
X{
X    register char *s;
X
X    s = str->str_ptr+str->str_cur - 1;
X    while (s >= str->str_ptr && (*s == ' ' || *s == '\t' || *s == '\n'))
X        s--;
X    if (s >= str->str_ptr && *s != ';' && *s != '}')
X        str_cat(str,";");
X}
X
Xemit_split(str,level)
Xregister STR *str;
Xint level;
X{
X    register int i;
X
X    if (split_to_array)
X        str_cat(str,"@Fld");
X    else {
X        str_cat(str,"(");
X        for (i = 1; i < maxfld; i++) {
X            if (i <= arymax)
X                sprintf(tokenbuf,"$%s,",nameary[i]);
X            else
X                sprintf(tokenbuf,"$Fld%d,",i);
X            str_cat(str,tokenbuf);
X        }
X        if (maxfld <= arymax)
X            sprintf(tokenbuf,"$%s)",nameary[maxfld]);
X        else
X            sprintf(tokenbuf,"$Fld%d)",maxfld);
X        str_cat(str,tokenbuf);
X    }
X    if (const_FS) {
X        sprintf(tokenbuf," = split(/[%c\\n]/);\n",const_FS);
X        str_cat(str,tokenbuf);
X    }
X    else if (saw_FS)
X        str_cat(str," = split($FS);\n");
X    else
X        str_cat(str," = split;\n");
X    tab(str,level);
X}
X
Xprewalk(numit,level,node,numericptr)
Xint numit;
Xint level;
Xregister int node;
Xint *numericptr;
X{
X    register int len;
X    register int type;
X    register int i;
X    char *t;
X    char *d, *s;
X    int numarg;
X    int numeric = FALSE;
X
X    if (!node) {
X        *numericptr = 0;
X        return 0;
X    }
X    type = ops[node].ival;
X    len = type >> 8;
X    type &= 255;
X    switch (type) {
X    case OPROG:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        if (ops[node+2].ival) {
X            prewalk(0,level,ops[node+2].ival,&numarg);
X        }
X        ++level;
X        prewalk(0,level,ops[node+3].ival,&numarg);
X        --level;
X        if (ops[node+3].ival) {
X            prewalk(0,level,ops[node+4].ival,&numarg);
X        }
X        break;
X    case OHUNKS:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        if (len == 3) {
X            prewalk(0,level,ops[node+3].ival,&numarg);
X        }
X        break;
X    case ORANGE:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        prewalk(1,level,ops[node+2].ival,&numarg);
X        break;
X    case OPAT:
X        goto def;
X    case OREGEX:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        break;
X    case OHUNK:
X        if (len == 1) {
X            prewalk(0,level,ops[node+1].ival,&numarg);
X        }
X        else {
X            i = prewalk(0,level,ops[node+1].ival,&numarg);
X            if (i) {
X                ++level;
X                prewalk(0,level,ops[node+2].ival,&numarg);
X                --level;
X            }
X            else {
X                prewalk(0,level,ops[node+2].ival,&numarg);
X            }
X        }
X        break;
X    case OPPAREN:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        break;
X    case OPANDAND:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        break;
X    case OPOROR:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        break;
X    case OPNOT:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        break;
X    case OCPAREN:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        numeric |= numarg;
X        break;
X    case OCANDAND:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        break;
X    case OCOROR:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        break;
X    case OCNOT:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        break;
X    case ORELOP:
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        numeric |= numarg;
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+3].ival,&numarg);
X        numeric |= numarg;
X        numeric = 1;
X        break;
X    case ORPAREN:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        numeric |= numarg;
X        break;
X    case OMATCHOP:
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+3].ival,&numarg);
X        numeric = 1;
X        break;
X    case OMPAREN:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        numeric |= numarg;
X        break;
X    case OCONCAT:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        break;
X    case OASSIGN:
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+3].ival,&numarg);
X        if (numarg || strlen(ops[ops[node+1].ival+1].cval) > 1) {
X            numericize(ops[node+2].ival);
X            if (!numarg)
X                numericize(ops[node+3].ival);
X        }
X        numeric |= numarg;
X        break;
X    case OADD:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        prewalk(1,level,ops[node+2].ival,&numarg);
X        numeric = 1;
X        break;
X    case OSUB:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        prewalk(1,level,ops[node+2].ival,&numarg);
X        numeric = 1;
X        break;
X    case OMULT:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        prewalk(1,level,ops[node+2].ival,&numarg);
X        numeric = 1;
X        break;
X    case ODIV:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        prewalk(1,level,ops[node+2].ival,&numarg);
X        numeric = 1;
X        break;
X    case OMOD:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        prewalk(1,level,ops[node+2].ival,&numarg);
X        numeric = 1;
X        break;
X    case OPOSTINCR:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        break;
X    case OPOSTDECR:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        break;
X    case OPREINCR:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        break;
X    case OPREDECR:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        break;
X    case OUMINUS:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        break;
X    case OUPLUS:
X        prewalk(1,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        break;
X    case OPAREN:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        numeric |= numarg;
X        break;
X    case OGETLINE:
X        break;
X    case OSPRINTF:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        break;
X    case OSUBSTR:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(1,level,ops[node+2].ival,&numarg);
X        if (len == 3) {
X            prewalk(1,level,ops[node+3].ival,&numarg);
X        }
X        break;
X    case OSTRING:
X        break;
X    case OSPLIT:
X        numeric = 1;
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        if (len == 3)
X            prewalk(0,level,ops[node+3].ival,&numarg);
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        break;
X    case OINDEX:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        numeric = 1;
X        break;
X    case ONUM:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        numeric = 1;
X        break;
X    case OSTR:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        break;
X    case OVAR:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        if (len == 1) {
X            if (numit)
X                numericize(node);
X        }
X        else {
X            prewalk(0,level,ops[node+2].ival,&numarg);
X        }
X        break;
X    case OFLD:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        break;
X    case OVFLD:
X        i = ops[node+1].ival;
X        prewalk(0,level,i,&numarg);
X        break;
X    case OJUNK:
X        goto def;
X    case OSNEWLINE:
X        break;
X    case ONEWLINE:
X        break;
X    case OSCOMMENT:
X        break;
X    case OCOMMENT:
X        break;
X    case OCOMMA:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        break;
X    case OSEMICOLON:
X        break;
X    case OSTATES:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        break;
X    case OSTATE:
X        if (len >= 1) {
X            prewalk(0,level,ops[node+1].ival,&numarg);
X            if (len >= 2) {
X                prewalk(0,level,ops[node+2].ival,&numarg);
X            }
X        }
X        break;
X    case OPRINTF:
X    case OPRINT:
X        if (len == 3) {                /* output redirection */
X            prewalk(0,level,ops[node+3].ival,&numarg);
X            prewalk(0,level,ops[node+2].ival,&numarg);
X        }
X        prewalk(0+(type==OPRINT),level,ops[node+1].ival,&numarg);
X        break;
X    case OLENGTH:
X        goto maybe0;
X    case OLOG:
X        goto maybe0;
X    case OEXP:
X        goto maybe0;
X    case OSQRT:
X        goto maybe0;
X    case OINT:
X      maybe0:
X        numeric = 1;
X        if (len > 0)
X            prewalk(type != OLENGTH,level,ops[node+1].ival,&numarg);
X        break;
X    case OBREAK:
X        break;
X    case ONEXT:
X        break;
X    case OEXIT:
X        if (len == 1) {
X            prewalk(1,level,ops[node+1].ival,&numarg);
X        }
X        break;
X    case OCONTINUE:
X        break;
X    case OREDIR:
X        goto def;
X    case OIF:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        if (len == 3) {
X            prewalk(0,level,ops[node+3].ival,&numarg);
X        }
X        break;
X    case OWHILE:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        break;
X    case OFOR:
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        prewalk(0,level,ops[node+3].ival,&numarg);
X        prewalk(0,level,ops[node+4].ival,&numarg);
X        break;
X    case OFORIN:
X        prewalk(0,level,ops[node+2].ival,&numarg);
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        prewalk(0,level,ops[node+3].ival,&numarg);
X        break;
X    case OBLOCK:
X        if (len == 2) {
X            prewalk(0,level,ops[node+2].ival,&numarg);
X        }
X        ++level;
X        prewalk(0,level,ops[node+1].ival,&numarg);
X        --level;
X        break;
X    default:
X      def:
X        if (len) {
X            if (len > 5)
X                fatal("Garbage length in prewalk");
X            prewalk(0,level,ops[node+1].ival,&numarg);
X            for (i = 2; i<= len; i++) {
X                prewalk(0,level,ops[node+i].ival,&numarg);
X            }
X        }
X        break;
X    }
X    *numericptr = numeric;
X    return 1;
X}
X
Xnumericize(node)
Xregister int node;
X{
X    register int len;
X    register int type;
X    register int i;
X    STR *tmpstr;
X    STR *tmp2str;
X    int numarg;
X
X    type = ops[node].ival;
X    len = type >> 8;
X    type &= 255;
X    if (type == OVAR && len == 1) {
X        tmpstr=walk(0,0,ops[node+1].ival,&numarg);
X        tmp2str = str_make("1");
X        hstore(symtab,tmpstr->str_ptr,tmp2str);
X    }
X}
!STUFFY!FUNK!
echo Extracting x2p/s2p
sed >x2p/s2p <<'!STUFFY!FUNK!' -e 's/X//'
X#!/bin/perl
X
X$indent = 4;
X$shiftwidth = 4;
X$l = '{'; $r = '}';
X$tempvar = '1';
X
Xwhile ($ARGV[0] =~ '^-') {
X    $_ = shift;
X  last if /^--/;
X    if (/^-D/) {
X        $debug++;
X        open(body,'>-');
X        next;
X    }
X    if (/^-n/) {
X        $assumen++;
X        next;
X    }
X    if (/^-p/) {
X        $assumep++;
X        next;
X    }
X    die "I don't recognize this switch: $_";
X}
X
Xunless ($debug) {
X    open(body,">/tmp/sperl$$") || do Die("Can't open temp file.");
X}
X
Xif (!$assumen && !$assumep) {
X    print body
X'while ($ARGV[0] =~ /^-/) {
X    $_ = shift;
X  last if /^--/;
X    if (/^-n/) {
X        $nflag++;
X        next;
X    }
X    die "I don\'t recognize this switch: $_";
X}
X
X';
X}
X
Xprint body '
X#ifdef PRINTIT
X#ifdef ASSUMEP
X$printit++;
X#else
X$printit++ unless $nflag;
X#endif
X#endif
Xline: while (<>) {
X';
X
Xline: while (<>) {
X    s/[ \t]*(.*)\n$/$1/;
X    if (/^:/) {
X        s/^:[ \t]*//;
X        $label = do make_label($_);
X        if ($. == 1) {
X            $toplabel = $label;
X        }
X        $_ = "$label:";
X        if ($lastlinewaslabel++) {$_ .= "\t;";}
X        if ($indent >= 2) {
X            $indent -= 2;
X            $indmod = 2;
X        }
X        next;
X    } else {
X        $lastlinewaslabel = '';
X    }
X    $addr1 = '';
X    $addr2 = '';
X    if (s/^([0-9]+)//) {
X        $addr1 = "$1";
X    }
X    elsif (s/^\$//) {
X        $addr1 = 'eof()';
X    }
X    elsif (s|^/||) {
X        $addr1 = '/';
X        delim: while (s:^([^(|)\\/]*)([(|)\\/])::) {
X            $prefix = $1;
X            $delim = $2;
X            if ($delim eq '\\') {
X                s/(.)(.*)/$2/;
X                $ch = $1;
X                $delim = '' if index("(|)",$ch) >= 0;
X                $delim .= $1;
X            }
X            elsif ($delim ne '/') {
X                $delim = '\\' . $delim;
X            }
X            $addr1 .= $prefix;
X            $addr1 .= $delim;
X            if ($delim eq '/') {
X                last delim;
X            }
X        }
X    }
X    if (s/^,//) {
X        if (s/^([0-9]+)//) {
X            $addr2 = "$1";
X        } elsif (s/^\$//) {
X            $addr2 = "eof()";
X        } elsif (s|^/||) {
X            $addr2 = '/';
X            delim: while (s:^([^(|)\\/]*)([(|)\\/])::) {
X                $prefix = $1;
X                $delim = $2;
X                if ($delim eq '\\') {
X                    s/(.)(.*)/$2/;
X                    $ch = $1;
X                    $delim = '' if index("(|)",$ch) >= 0;
X                    $delim .= $1;
X                }
X                elsif ($delim ne '/') {
X                    $delim = '\\' . $delim;
X                }
X                $addr2 .= $prefix;
X                $addr2 .= $delim;
X                if ($delim eq '/') {
X                    last delim;
X                }
X            }
X        } else {
X            do Die("Invalid second address at line $.: $_");
X        }
X        $addr1 .= " .. $addr2";
X    }
X                                        # a { to keep vi happy
X    if ($_ eq '}') {
X        $indent -= 4;
X        next;
X    }
X    if (s/^!//) {
X        $if = 'unless';
X        $else = "$r else $l\n";
X    } else {
X        $if = 'if';
X        $else = '';
X    }
X    if (s/^{//) {        # a } to keep vi happy
X        $indmod = 4;
X        $redo = $_;
X        $_ = '';
X        $rmaybe = '';
X    } else {
X        $rmaybe = "\n$r";
X        if ($addr2 || $addr1) {
X            $space = substr('        ',0,$shiftwidth);
X        } else {
X            $space = '';
X        }
X        $_ = do transmogrify();
X    }
X
X    if ($addr1) {
X        if ($_ !~ /[\n{}]/ && $rmaybe && !$change &&
X          $_ !~ / if / && $_ !~ / unless /) {
X            s/;$/ $if $addr1;/;
X            $_ = substr($_,$shiftwidth,1000);
X        } else {
X            $command = $_;
X            $_ = "$if ($addr1) $l\n$change$command$rmaybe";
X        }
X        $change = '';
X        next line;
X    }
X} continue {
X    @lines = split(/\n/,$_);
X    while ($#lines >= 0) {
X        $_ = shift(lines);
X        unless (s/^ *<<--//) {
X            print body substr("\t\t\t\t\t\t\t\t\t\t\t\t",0,$indent / 8),
X                substr('        ',0,$indent % 8);
X        }
X        print body $_, "\n";
X    }
X    $indent += $indmod;
X    $indmod = 0;
X    if ($redo) {
X        $_ = $redo;
X        $redo = '';
X        redo line;
X    }
X}
X
Xprint body "}\n";
Xif ($appendseen || $tseen || !$assumen) {
X    $printit++ if $dseen || (!$assumen && !$assumep);
X    print body '
Xcontinue {
X#ifdef PRINTIT
X#ifdef DSEEN
X#ifdef ASSUMEP
X    print if $printit++;
X#else
X    if ($printit) { print;} else { $printit++ unless $nflag; }
X#endif
X#else
X    print if $printit;
X#endif
X#else
X    print;
X#endif
X#ifdef TSEEN
X    $tflag = \'\';
X#endif
X#ifdef APPENDSEEN
X    if ($atext) { print $atext; $atext = \'\'; }
X#endif
X}
X';
X}
X
Xclose body;
X
Xunless ($debug) {
X    open(head,">/tmp/sperl2$$") || do Die("Can't open temp file 2.\n");
X    print head "#define PRINTIT\n" if ($printit);
X    print head "#define APPENDSEEN\n" if ($appendseen);
X    print head "#define TSEEN\n" if ($tseen);
X    print head "#define DSEEN\n" if ($dseen);
X    print head "#define ASSUMEN\n" if ($assumen);
X    print head "#define ASSUMEP\n" if ($assumep);
X    if ($opens) {print head "$opens\n";}
X    open(body,"/tmp/sperl$$") || do Die("Can't reopen temp file.");
X    while (<body>) {
X        print head $_;
X    }
X    close head;
X
X    print "#!/bin/perl\n\n";
X    open(body,"cc -E /tmp/sperl2$$ |") ||
X        do Die("Can't reopen temp file.");
X    while (<body>) {
X        /^# [0-9]/ && next;
X        /^[ \t]*$/ && next;
X        s/^<><>//;
X        print;
X    }
X}
X
X`/bin/rm -f /tmp/sperl$$ /tmp/sperl2$$`;
X
Xsub Die {
X    `/bin/rm -f /tmp/sperl$$ /tmp/sperl2$$`;
X    die $_[0];
X}
Xsub make_filehandle {
X    $fname = $_ = $_[0];
X    s/[^a-zA-Z]/_/g;
X    s/^_*//;
X    if (/^([a-z])([a-z]*)$/) {
X        $first = $1;
X        $rest = $2;
X        $first =~ y/a-z/A-Z/;
X        $_ = $first . $rest;
X    }
X    if (!$seen{$_}) {
X        $opens .= "open($_,'>$fname') || die \"Can't create $fname.\";\n";
X    }
X    $seen{$_} = $_;
X}
X
Xsub make_label {
X    $label = $_[0];
X    $label =~ s/[^a-zA-Z0-9]/_/g;
X    if ($label =~ /^[0-9_]/) { $label = 'L' . $label; }
X    $label = substr($label,0,8);
X    if ($label =~ /^([a-z])([a-z]*)$/) {
X        $first = $1;
X        $rest = $2;
X        $first =~ y/a-z/A-Z/;
X        $label = $first . $rest;
X    }
X    $label;
X}
X
Xsub transmogrify {
X    {        # case
X        if (/^d/) {
X            $dseen++;
X            $_ = '
X<<--#ifdef PRINTIT
X$printit = \'\';
X<<--#endif
Xnext line;';
X            next;
X        }
X
X        if (/^n/) {
X            $_ =
X'<<--#ifdef PRINTIT
X<<--#ifdef DSEEN
X<<--#ifdef ASSUMEP
Xprint if $printit++;
X<<--#else
Xif ($printit) { print;} else { $printit++ unless $nflag; }
X<<--#endif
X<<--#else
Xprint if $printit;
X<<--#endif
X<<--#else
Xprint;
X<<--#endif
X<<--#ifdef APPENDSEEN
Xif ($atext) {print $atext; $atext = \'\';}
X<<--#endif
X$_ = <>;
X<<--#ifdef TSEEN
X$tflag = \'\';
X<<--#endif';
X            next;
X        }
X
X        if (/^a/) {
X            $appendseen++;
X            $command = $space .  '$atext .=' . "\n<<--'";
X            $lastline = 0;
X            while (<>) {
X                s/^[ \t]*//;
X                s/^[\\]//;
X                unless (s|\\$||) { $lastline = 1;}
X                s/'/\\'/g;
X                s/^([ \t]*\n)/<><>$1/;
X                $command .= $_;
X                $command .= '<<--';
X                last if $lastline;
X            }
X            $_ = $command . "';";
X            last;
X        }
X
X        if (/^[ic]/) {
X            if (/^c/) { $change = 1; }
X            $addr1 = '$iter = (' . $addr1 . ')';
X            $command = $space .  'if ($iter == 1) { print' . "\n<<--'";
X            $lastline = 0;
X            while (<>) {
X                s/^[ \t]*//;
X                s/^[\\]//;
X                unless (s/\\$//) { $lastline = 1;}
X                s/'/\\'/g;
X                s/^([ \t]*\n)/<><>$1/;
X                $command .= $_;
X                $command .= '<<--';
X                last if $lastline;
X            }
X            $_ = $command . "';}";
X            if ($change) {
X                $dseen++;
X                $change = "$_\n";
X                $_ = "
X<<--#ifdef PRINTIT
X$space\$printit = '';
X<<--#endif
X${space}next line;";
X            }
X            last;
X        }
X
X        if (/^s/) {
X            $delim = substr($_,1,1);
X            $len = length($_);
X            $repl = $end = 0;
X            for ($i = 2; $i < $len; $i++) {
X                $c = substr($_,$i,1);
X                if ($c eq '\\') {
X                    $i++;
X                    if ($i >= $len) {
X                        $_ .= 'n';
X                        $_ .= <>;
X                        $len = length($_);
X                        $_ = substr($_,0,--$len);
X                    }
X                    elsif (!$repl && index("(|)",substr($_,$i,1)) >= 0) {
X                        $i--;
X                        $len--;
X                        $_ = substr($_,0,$i) . substr($_,$i+1,10000);
X                    }
X                }
X                elsif ($c eq $delim) {
X                    if ($repl) {
X                        $end = $i;
X                        last;
X                    } else {
X                        $repl = $i;
X                    }
X                }
X                elsif (!$repl && index("(|)",$c) >= 0) {
X                    $_ = substr($_,0,$i) . '\\' . substr($_,$i,10000);
X                    $i++;
X                    $len++;
X                }
X            }
X            print "repl $repl end $end $_\n";
X            do Die("Malformed substitution at line $.") unless $end;
X            $pat = substr($_, 0, $repl + 1);
X            $repl = substr($_, $repl + 1, $end - $repl - 1);
X            $end = substr($_, $end + 1, 1000);
X            $dol = '$';
X            $repl =~ s'&'$&'g;
X            $repl =~ s/[\\]([0-9])/$dol$1/g;
X            $subst = "$pat$repl$delim";
X            $cmd = '';
X            while ($end) {
X                if ($end =~ s/^g//) { $subst .= 'g'; next; }
X                if ($end =~ s/^p//) { $cmd .= ' && (print)'; next; }
X                if ($end =~ s/^w[ \t]*//) {
X                    $fh = do make_filehandle($end);
X                    $cmd .= " && (print $fh \$_)";
X                    $end = '';
X                    next;
X                }
X                do Die("Unrecognized substitution command ($end) at line $.");
X            }
X            $_ = $subst . $cmd . ';';
X            next;
X        }
X
X        if (/^p/) {
X            $_ = 'print;';
X            next;
X        }
X
X        if (/^w/) {
X            s/^w[ \t]*//;
X            $fh = do make_filehandle($_);
X            $_ = "print $fh \$_;";
X            next;
X        }
X
X        if (/^r/) {
X            $appendseen++;
X            s/^r[ \t]*//;
X            $file = $_;
X            $_ = "\$atext .= `cat $file 2>/dev/null`;";
X            next;
X        }
X
X        if (/^P/) {
X            $_ =
X'if (/(^[^\n]*\n)/) {
X    print $1;
X}';
X            next;
X        }
X
X        if (/^D/) {
X            $_ =
X's/^[^\n]*\n//;
Xif ($_) {redo line;}
Xnext line;';
X            next;
X        }
X
X        if (/^N/) {
X            $_ = '
X$_ .= <>;
X<<--#ifdef TSEEN
X$tflag = \'\';
X<<--#endif';
X            next;
X        }
X
X        if (/^h/) {
X            $_ = '$hold = $_;';
X            next;
X        }
X
X        if (/^H/) {
X            $_ = '$hold .= $_ ? $_ : "\n";';
X            next;
X        }
X
X        if (/^g/) {
X            $_ = '$_ = $hold;';
X            next;
X        }
X
X        if (/^G/) {
X            $_ = '$_ .= $hold ? $hold : "\n";';
X            next;
X        }
X
X        if (/^x/) {
X            $_ = '($_, $hold) = ($hold, $_);';
X            next;
X        }
X
X        if (/^b$/) {
X            $_ = 'next line;';
X            next;
X        }
X
X        if (/^b/) {
X            s/^b[ \t]*//;
X            $lab = do make_label($_);
X            if ($lab eq $toplabel) {
X                $_ = 'redo line;';
X            } else {
X                $_ = "goto $lab;";
X            }
X            next;
X        }
X
X        if (/^t$/) {
X            $_ = 'next line if $tflag;';
X            $tseen++;
X            next;
X        }
X
X        if (/^t/) {
X            s/^t[ \t]*//;
X            $lab = do make_label($_);
X            if ($lab eq $toplabel) {
X                $_ = 'if ($tflag) {$tflag = \'\'; redo line;}';
X            } else {
X                $_ = "if (\$tflag) {\$tflag = ''; goto $lab;}";
X            }
X            $tseen++;
X            next;
X        }
X
X        if (/^=/) {
X            $_ = 'print "$.\n";';
X            next;
X        }
X
X        if (/^q/) {
X            $_ =
X'close(ARGV);
X@ARGV = ();
Xnext line;';
X            next;
X        }
X    } continue {
X        if ($space) {
X            s/^/$space/;
X            s/(\n)(.)/$1$space$2/g;
X        }
X        last;
X    }
X    $_;
X}
X
!STUFFY!FUNK!
echo Extracting patchlevel.h
sed >patchlevel.h <<'!STUFFY!FUNK!' -e 's/X//'
X#define PATCHLEVEL 0
!STUFFY!FUNK!
echo ""
echo "End of kit 1 (of 10)"
cat /dev/null >kit1isdone
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