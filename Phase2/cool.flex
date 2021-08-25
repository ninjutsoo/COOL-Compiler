/*******************mohammad amin roshani - 610396104**********************/
/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  My defenitions
 */
/* this is defined for nested comments.
*/
unsigned int comment = 0;
/* this is for when the string is too long or or we've seen null */
bool wrong_str = false;
/* this shows us our remaining space for strings */
unsigned int rem_str = MAX_STR_CONST;


/* this function is for writing and each time checks if we can write or not */
int write_str(char *str, unsigned int len) {
  if (len < rem_str) {
    strncpy(string_buf_ptr, str, len);
    string_buf_ptr += len;
    rem_str -= len;
    string_buf [MAX_STR_CONST - rem_str ] = '\0';
    return 0;
  } else {
    wrong_str = true;
    yylval.error_msg = "String constant too long";
    return -1;
  }
}

%}

/*
 * Here are names for regular expressions.
 */


OBJECTID        [a-z][_a-zA-Z0-9]*
TYPEID          [A-Z][_a-zA-Z0-9]*
DIGIT		[0-9]+
DARROW          =>
ASSIGN		<-
LE		<=
CLASS		[cC][lL][aA][sS][sS]
IF		[iI][fF]
FI		[fF][iI]
ELSE		[eE][lL][sS][eE]
IN		[iI][nN]
INHERITS	{IN}[hH][eE][rR][iI][tT][sS]
ISVOID		[iI][sS][vV][oO][iI][dD]
LET		[lL][eE][tT]
LOOP		[lL][oO][oO][pP]
POOL		[pP][oO][oO][lL]
THEN		[tT][hH][eE][nN]
WHILE		[wW][hH][iI][lL][eE]
CASE		[cC][aA][sS][eE]
ESAC		[eE][sS][aA][cC]
NEW             [nN][eE][wW]
OF              [oO][fF]
NOT             [nN][oO][tT]
TRUE            t[rR][uU][eE]
FALSE           f[aA][lL][sS][eE]
/* here we define two conditions to detect where we are */
%x COMMENT
%x STRING
/* this condition is when we see a null or too long error and we will scape just with /n or "
*/
%x ESC


%%
<INITIAL,COMMENT>\n		{ curr_lineno++; 
				}

"(*"				{ comment++;
				  BEGIN(COMMENT); 
				}

"*)"				{ yylval.error_msg = "Unmatched *)";
				  return ERROR; 
				}

<COMMENT>"*)"			{ comment--;
				  if (comment == 0)	
				  BEGIN(INITIAL); 
				}
 /* eat every thing but newline in comments */
<COMMENT>[^\n]			{}

"--"[^\n]*			{}

<COMMENT><<EOF>>		{ yylval.error_msg = "EOF in comment";
				  BEGIN(INITIAL);
				  return ERROR; 
				}
 /* comments are done */
 /*****************************************************************************************/
 /* here we start strings */

\"				{ BEGIN(STRING);
				  string_buf_ptr = string_buf;
				  rem_str = MAX_STR_CONST;
				  wrong_str = false;
				}

<STRING><<EOF>>			{ BEGIN(INITIAL);
				  if (!wrong_str) {
				  yylval.error_msg = "EOF in string constant";
				  return ERROR;
				  }
				}
<STRING>[\0]			{ yylval.error_msg = "String contains null character";
				  wrong_str = true;
				  BEGIN(ESC);
				}

<STRING>[^\n\\\0\"]*		{ if (strlen(yytext) < rem_str) {
				  	write_str (yytext, strlen(yytext));
				  }
				  else {
				  	if (!wrong_str) {
						wrong_str = true;
						yylval.error_msg = "String constant too long";
						BEGIN(ESC);
						return ERROR;
						}
					}
				}

<STRING>[\n]			{ BEGIN(INITIAL);
				  curr_lineno++;
				  if (!wrong_str) {
				  	yylval.error_msg = "Unterminated string constant";
				  	return ERROR;
				  }
				}

<STRING>[\0]			{ yylval.error_msg = "String contains null character";
				  wrong_str = true;
				  BEGIN(ESC);
				  return ERROR;
				}
	
<STRING>[\\](.|\n)		{ if (strlen(yytext) - 1 < rem_str) {
				  	if (yytext[1] == '\n') {
				  		curr_lineno++;
						write_str ("\n", 1);
					}
					else {
						switch(yytext[1]) {
							case 'n' : 
								write_str ("\n", 1);
								break;
							case 'f' :
								write_str ("\f", 1);
								break;
							case 'b' :
								write_str ("\b", 1);
								break;
							case 't' :
								write_str ("\t", 1);
								break;
							case '\0' :
								yylval.error_msg = "String contains null character";
								wrong_str = true;
								BEGIN(ESC);
								return ERROR;
							default :
								write_str (&yytext[1], 1);
						}
					}
				  }
				}

<STRING>[\"]			{ BEGIN(INITIAL);
				  if (!wrong_str) {
				  	yylval.symbol = stringtable.add_string(string_buf);
					return (STR_CONST);
				  }
				}

<ESC>[^\"|\n]			{}

<ESC>[\n]			{ BEGIN(INITIAL);
				  curr_lineno++;
				}

<ESC>[\"]			{ BEGIN(INITIAL);
				}
 /* strings are done */
 /*****************************************************************************************/
 
<INITIAL>[ \t\r\f\v]+		{}
<INITIAL>{CLASS} 		{return (CLASS);}
<INITIAL>{IF}			{return (IF);}
<INITIAL>{FI}			{return (FI);}
<INITIAL>{ELSE}			{return (ELSE);}
<INITIAL>{IN}			{return (IN);}
<INITIAL>{INHERITS}		{return (INHERITS);}
<INITIAL>{ISVOID}		{return (ISVOID);}
<INITIAL>{LET}			{return (LET);}
<INITIAL>{LOOP}			{return (LOOP);}
<INITIAL>{POOL}			{return (POOL);}
<INITIAL>{THEN}			{return (THEN);}
<INITIAL>{WHILE}		{return (WHILE);}
<INITIAL>{CASE}			{return (CASE);}
<INITIAL>{ESAC}			{return (ESAC);}
<INITIAL>{NEW}			{return (NEW);}
<INITIAL>{OF}			{return (OF);}
<INITIAL>{NOT}			{return (NOT);}
<INITIAL>{DARROW}		{return (DARROW);}
<INITIAL>{ASSIGN}		{return (ASSIGN);}
<INITIAL>{LE}			{return (LE);}

<INITIAL>{TRUE}			{yylval.boolean = true;
		 		 return (BOOL_CONST);
				}

<INITIAL>{FALSE}		{yylval.boolean = false; 
		 		 return (BOOL_CONST);
				}

<INITIAL>{OBJECTID}		{yylval.symbol = stringtable.add_string(yytext);
				 return (OBJECTID);
				}
<INITIAL>{TYPEID}		{yylval.symbol = stringtable.add_string(yytext); 
				 return (TYPEID);
				}

<INITIAL>{DIGIT}		{yylval.symbol = stringtable.add_string(yytext); 
		 		return (INT_CONST);
				}

<INITIAL>";"			{return int(';');}
<INITIAL>","			{return int(',');}
<INITIAL>":"			{return int(':');}
<INITIAL>"{"			{return int('{');}
<INITIAL>"}"			{return int('}');}
<INITIAL>"+"			{return int('+');}
<INITIAL>"-"			{return int('-');}
<INITIAL>"*"			{return int('*');}
<INITIAL>"/"			{return int('/');}
<INITIAL>"<"			{return int('<');}
<INITIAL>"="			{return int('=');}
<INITIAL>"~"			{return int('~');}
<INITIAL>"."			{return int('.');}
<INITIAL>"@"			{return int('@');}
<INITIAL>"("			{return int('(');}
<INITIAL>")"			{return int(')');}
<INITIAL>.			{yylval.error_msg = yytext; 
		 		 return (ERROR); 
				}



 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

%%
 	