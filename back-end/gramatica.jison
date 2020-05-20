/* GRAMATICA PARA EL LENGUAJE JAVA */

/*DEFINICION DE ANALIZADOR LEXICIO*/

%lex

%options case-sensitive

%%

\s+                                                 // Espacios en blanco
/* COMENTARIOS */
"//".*                                              // Comentario Simple
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]                 // Comentario de multiples lineas

/* PALABRAS RESERVADAS */
/* Tipo de Datos */
"int"                               return 'TD_INT';
"double"                            return 'TD_DOUBLE';
"boolean"                           return 'TD_BOOLEAN;
"char"                              return 'TD_CHAR';
"String"                            return 'TD_STRING';

/* Generales */
"import"                            return 'PR_IMPORT';
"class"                             return 'PR_CLASS';
"void"                              return 'PR_VOID';
"main"                              return 'PR_MAIN';
"System"                            return 'PR_SYSTEM';
"out"                               return 'PR_OUT';
"print"                             return 'PR_PRINT';
"println"                           return 'PR_PRINTLN';
"return"                            return 'PR_RETURN';


/* Sentencias */
"if"                                return 'PR_IF';
"else"                              return 'PR_ELSE';
"switch"                            return 'PR_SWITCH';
"case"                              return 'PR_CASE';
"default"                           return 'PR_DEFAULT';
"break"                             return 'PR_BREAK';

/* Ciclos */  
"while"                             return 'PR_WHILE';
"do"                                return 'PR_DOR';
"for"                               return 'PR_FOR';
"continue"                          return 'PR_CONTINUE';

/* OPERADORES */
/* Aritmeticos */
"+"                                 return 'OP_SUMA';
"-"                                 return 'OP_RESTA';
"*"                                 return 'OP_MULTIPLICACION';
"/"                                 return 'OP_DIVISION';
"^"                                 return 'OP_POTENCIA';
"%"                                 return 'OP_MODULO';
"++"                                return 'OP_AUMENTO';
"--"                                return 'OP_DECREMENTO';

/* Relacionales */
"=="                                return 'OP_IGUALIGUAL';
"!="                                return 'OP_DISTINTO';
">"                                 return 'OP_MAYOR';
"<"                                 return 'OP_MENOR';
">="                                return 'OP_MAYORIGUAL';
"<="                                return 'OP_MENORIGUAL';

/* Logicos */
"&&"                                return 'OP_AND'; 
"||"                                return 'OP_OR'; 
"!"                                 return 'OP_NOT'; 

/* SIMBOLOS */
"{"                                 return 'S_LLAVE_ABRE';
"}"                                 return 'S_LLAVE_CIERRA';
"("                                 return 'S_PARENTESIS_ABRE';
")"                                 return 'S_PARENTESIS_CIERRA';
"["                                 return 'S_CORCHETE_ABRE';
"]"                                 return 'S_CORCHETE_CIERRA';
";"                                 return 'S_PUNTOCOMA';
","                                 return 'S_COMA';
"."                                 return 'S_PUNTO';
"="                                 return 'S_IGUAL';

/* VALORES BOOLEANOS */
"true"                              return 'PR_TRUE';
"false"                             return 'PR_FALSE';

/* ID */
([a-zA-Z_])[a-zA-Z0-9_]*            return 'ID';

/* NUMERO */
[0-9]+("."[0-9]+)?\b                return 'NUMERO';

/* ESPACIOS EN BLANCO */
[ \r\t]+                            {}
\n                                  {}

<<EOF>>                             return 'EOF';

.                                   { console.error('Error léxio: ' + yytext + '\nLínea: ' + yylloc.first_line + '\nColumna: ' + yylloc.column); }

/lex

/* PRECEDENCIAS */
%left 

// SIMBOLO INICIAL
%start inicio

%%
/* ANALIZADOR SINTACTICO */
