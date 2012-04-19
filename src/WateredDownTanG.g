grammar WateredDownTanG;

options{
language=Java;
output=AST;
ASTLabelType=CommonTree;
}

tanG	:	NEWLINE? ((i ((NEWLINE  EOF)?|(NEWLINE m)))? | m);

//Import Statements
i	:	td_from filename td_imp (    ID      (DOT ID)*    (   COMMA  ID (DOT ID)*      )*    | '*'       ) (NEWLINE iprime)? 
 	|	td_imp filename (NEWLINE iprime)?; 
 	
 iprime	:	td_from filename td_imp (ID (DOT ID)* (COMMA  ID (DOT ID)*)* | '*') (NEWLINE i)?
 	|	td_imp filename (NEWLINE i)?;

//Main body
m	:	statement (NEWLINE mprime)?;

mprime	:	statement (NEWLINE m)?;

statement
	:	td_node ID LPAREN! params RPAREN! NEWLINE (m NEWLINE)? td_end
	|	orexpression
	|	condType
	|	loopType
	|	td_return orexpression
	|	td_assert orexpression
	|	td_break (orexpression)?
	|	td_continue;
	
params	:	(ID(COMMA ID)*)?;

//Loops
loopType	:	td_for ID td_in iterable NEWLINE (m NEWLINE)? td_end
	|	td_while orexpression NEWLINE (m NEWLINE) td_end
	|	td_do NEWLINE (m NEWLINE)? td_while orexpression NEWLINE td_end
	|	td_loop NEWLINE (m NEWLINE) td_end
	|	td_until orexpression NEWLINE (m NEWLINE)? td_end;
//Things that can be iterated through
iterable	:	ID;

//Expressions
expression
	:	condType;

//conditionals
condType	:	td_if orexpression NEWLINE (m NEWLINE)? td_else NEWLINE (m NEWLINE)? td_end
	|	td_unless orexpression NEWLINE (m NEWLINE)? td_end
	|	td_cond  NEWLINE (cstatement NEWLINE)* td_end;
	
cstatement
	:	orexpression NEWLINE (m NEWLINE)? td_end;
	
orexpression
	:	ID;

//Keywords
td_from	:	FROM;
td_imp 	:	IMPORT
           	;
filename	:	FILENAME;
td_node    	:	NODE;
td_end     	:	END;
td_return  	:	RETURN;
td_assert  	:	ASSERT;
td_break   	:	BREAK;
td_continue	:	CONTINUE;
td_for     	:	FOR;
td_in      	:	IN;
td_while   	:	WHILE;
td_do      	:	DO;
td_loop    	:	LOOP;
td_until   	:	UNTIL;
td_if      	:	IF;
td_else    	:	ELSE;
td_unless  	:	UNLESS;
td_cond    	:	COND;
td_fork    	:	FORK;
td_or	:	OR;
td_xor	:	XOR;
td_and	:	AND;
td_not	:	NOT;
td_memtest
	:	MEMTEST;
td_idtest
	:	IDTEST;
td_mod	:	MOD;

//Lexer/Tokens

//Operators  
COMMENT
    :   ('#' |'//') ~('\n'|'\r')* '\r'? '\n' {skip();}
    |   '/*' ( options {greedy=false;} : . )* '*/' {skip();}
    ;
  
FROM
	:	'from'
	;
FILENAME	:	(('"')('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')* '.td' ('"'))
	|	(('\'')('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')* '.td' ('\''));
IMPORT
	:	'import'
	;
NODE
	:	'node'
	;
END
	:	'end'
	;
RETURN
	:	'return'
	;
ASSERT	:	'assert';
CONTINUE	:	'continue';
BREAK	:	'break';
FOR	:	'for';
IN	:	'in';
WHILE	:	'while';
DO	:	'do';
LOOP	:	'loop';
IF	:	'if';
ELSE	:	'else';
UNTIL	:	'until';
UNLESS	:	'unless';
COND	:	'cond';
FORK	:	'fork';
OR	:	'or';
XOR	:	'xor';
AND	:	'and';
NOT	:	'not';
MEMTEST	:	'in' | 'not in';
IDTEST	:	'is'| 'is not';
MOD	:	'mod';
ASSN	:	'='|'+='|'-='|'*='|'/='|'%='|'**='|'>>='|'<<='|'^='
	|	'/\\='|'\\/='|'&&='|'||=';
RANGE	:	'..';
NRANGE	:	'||';
BOOLAND	:	'&&';
EQTEST	:	'=='|'!=';
MAGCOMP	:	'>'|'<'|'>='|'<=';
BITOR	:	'\\/';
BITXOR	:	'^';
BITAND	:	'/\\';
BITSHIFT	:	'>>'|'<<';
ADDSUB	:	'+'|'-';
MULT	:	'*'|'/'|'%';
BITNOT	:	'!';
EXP	:	'**';
PIPE	:	'|';
FATCOMMA	:	'=>';
DOT
	:	'.'
	;
LPAREN
	:	'('
	;
COMMA
	:	','
	;	
RPAREN
	:	')'
	;
	
LBRACK	:	'[';
RBRACK	:	']';

LBRACE	:	'{';

RBRACE	:	'}';
QUOTE	:	'"';

//other stuff
INT :	'0'..'9'+
    ;
    
FLOAT
    :   ('0'..'9')+ DOT ('0'..'9')* EXPONENT?
    |   DOT ('0'..'9')+ EXPONENT?
    |   ('0'..'9')+ EXPONENT
    ;


NEWLINE	:	('\r'? '\n')+
		;


WS  :   ( ' '
        | '\t'
        ) {skip();};



HEX	:	'0x' (HEX_DIGIT)+;

BYTE	:	'0b' ('1'|'0')+;

STRING
    :  '"' ( ESC_SEQ | ~('\\'|'"') )* '"'
    ;

EXPONENT : ('e'|'E') ('+'|'-')? ('0'..'9')+ ;

ID  :	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;



fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\');
    

