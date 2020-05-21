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
"do"                                return 'PR_DO';
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
":"                                 return 'S_DOSPUNTOS';
","                                 return 'S_COMA';
"."                                 return 'S_PUNTO';
"="                                 return 'S_IGUAL';

/* VALORES BOOLEANOS */
"true"                              return 'PR_TRUE';
"false"                             return 'PR_FALSE';

/* CADENA */
\"[^\"]*\"				            { yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
\'[^\']*\'				            { yytext = yytext.substr(1,yyleng-2); return 'CARACTER'; }

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
%left 'OP_AND' 'OP_OR'
%left 'OP_IGUALIGUAL' 'OP_DISTINTO'
%left 'OP_MENOR' 'OP_MENORIGUAL' 'OP_MAYORIGUAL' 'OP_MAYOR'
%left 'OP_SUMA' 'OP_RESTA'
%left 'OP_MULTIPLICACION' 'OP_DIVISION'
%left 'OP_POTENCIA' 'OP_MODULO'
%left 'UMENOS'
%right 'OP_NOT'
%right 'OP_AUMENTO' 'OP_DECREMENTO'

// SIMBOLO INICIAL
%start INICIO

%%
/* ANALIZADOR SINTACTICO */

INICIO
        :INICIOPRIMA EOF          { return $1} // Se retorna el AST al finalizar de reconocer la entrada
;

INICIOPRIMA
        : IMPORTACIONES CLASES { $1.push($2); $$ = S1; }
        | CLASES               { $$ = [$1]; }
;

IMPORTACIONES
        : IMPORTACIONES PR_IMPORT ID S_PUNTOCOMA            
        | PR_IMPORT ID S_PUNTOCOMA
;

CLASES 
        : CLASES PR_CLASS ID S_LLAVE_ABRE CUERPO S_LLAVE_CIERRA
        | PR_CLASS ID S_LLAVE_ABRE CUERPO S_LLAVE_CIERRA
;

CUERPO
        : CUERPO CUERPOPRIMA
        | CUERPOPRIMA
;

CUERPOPRIMA
        : DECLARACIONES
        | FUNCIONES
;

DECLARACIONES 
        : TIPO_DATO DECLARACION S_PUNTOCOMA
;

DECLARACION
        : DECLARACION S_COMA DECLARACIONPRIMA
        | DECLARACIONPRIMA
;

DECLARACIONPRIMA
        : ID = EXPRESION
        | ID
;

FUNCIONES 
        : TIPO_DATO ID PARAMETROS CUERPO_METODO
        | PR_VOID ID PARAMETROS CUERPO_METODO
        | POR_VOID PR_MAIN S_PARENTESIS_ABRE S_PARENTESIS_CIERRA CUERPO_METODO
;

PARAMETROS
        : S_PARENTESIS_ABRE LISTA_PARAMETRO S_PARENTESIS_CIERRA
        | S_PARENTESIS_ABRE S_PARENTESIS_CIERRA
;

LISTA_PARAMETRO
        : LISTA_PARAMETRO COMA PARAMETRO
        | PARAMETRO
;

PARAMETRO
        : TIPO_DATO ID
;

CUERPO_METODO
        : S_LLAVE_ABRE INSTRUCCIONES S_LLAVE_CIERRA
        | S_LLAVE_ABRE S_LLAVE_CIERRA
;

INSTRUCCIONES
        : INSTRUCCIONES INSTRUCCION
        | INSTRUCCION
;

INSTRUCCION
        : DECLARACION
        | ASIGNACION
        | FUNCION
        | IMPRESION
        | IF
        | SWITCH
        | WHILE
        | DO_WHILE
        | FOR
        | BREAK
        | CONTINUE
        | RETURN
;

ASIGNACION
        : ID S_IGUAL EXPRESION S_PUNTOCOMA
        | ID OP_AUMENTO S_PUNTOCOMA
        | ID OP_DECREMENTO S_PUNTOCOMA
;

FUNCION
        : ID S_PARENTESIS_ABRE EXPRESIONES S_PARENTESIS_CIERRA S_PUNTOCOMA
        | ID S_PARENTESIS_ABRE S_PARENTESIS_CIERRA S_PUNTOCOMA
;

EXPRESIONES
        : EXPRESIONES COMA EXPRESION
        | EXPRESION
;

IMPRESION 
        : PR_SYSTEM S_PUNTO PR_OUT S_PUNTO TIPO_IMPRESION S_PARENTESIS_ABRE EXPRESION S_PARENTESIS_CIERRA S_PUNTOCOMA
;

TIPO_IMPRESION 
        : PR_PRINT
        | PR_PRINTLN
;

IF
        : PR_IF CONDICION CUERPO_METODO
        | PR_IF CONDICION CUERPO_METODO PR_ELSE CUERPO_METODO
        | PR_IF CONDICION CUERPO_METODO PR_ELSE IF
;

CONDICION
        : S_PARENTESIS_ABRE EXPRESION S_PARENTESIS_CIERRA
;

SWITCH
        : PR_SWITCH CONDICION S_LLAVE_ABRE CASES S_LLAVE_CIERRA
;

CASES
        : CASES CASE
        | CASE
;

CASE    
        : PR_CASE EXPRESION S_DOSPUNTOS INSTRUCCIONES
        | PR_DEFAULT S_DOSPUNTOS INSTRUCCIONES
;

WHILE 
        : PR_WHILE CONDICION CUERPO_METODO
;

DO_WHILE 
        : PR_DO CUERPO_METODO PR_WHILE CONDICION S_PUNTOCOMA
;

FOR     
        : PR_FOR S_PARENTESIS_ABRE ASIGNACION_FOR S_PUNTOCOMA EXPRESION S_PUNTOCOMA CAMBIO_VALOR S_PARENTESIS_CIERRA CUERPO_METODO
;

ASIGNACION_FOR
        : DECLARACION
        | ASIGNACION
;

CAMBIO_VALOR
        : OP_AUMENTO
        | OP_DECREMENTO
;

BREAK
        : PR_BREAK S_PUNTOCOMA
;

CONTINUE
        : PR_CONTINUE S_PUNTOCOMA
;

RETURN
        : PR_RETURN EXPRESION S_PUNTOCOMA
        | PR_RETURN S_PUNTOCOMA
;

TIPO_DATO
        : TD_CHAR
        | TD_STRING
        | TD_INT
        | TD_DOUBLE
        | TD_BOOLEAN
;

EXPRESION
        : OP_RESTA EXPRESION %prec UMENOS	
	    | OP_NOT EXPRESION	
        | EXPRESION OP_SUMA EXPRESION 
        | EXPRESION OP_RESTA EXPRESION	
        | EXPRESION OP_MULTIPLICACION EXPRESION 
        | EXPRESION OP_DIVISION EXPRESION 
	    | EXPRESION OP_MODULO EXPRESION 
	    | EXPRESION OP_POTENCIA EXPRESION 
	    | EXPRESION OP_AND EXPRESION	
	    | EXPRESION OP_OR EXPRESION 
	    | EXPRESION OP_IGUALIGUAL EXPRESION 
	    | EXPRESION OP_DISTINTO EXPRESION 
	    | EXPRESION OP_MENORIGUAL EXPRESION 
	    | EXPRESION OP_MENOR EXPRESION 
	    | EXPRESION OP_MAYORIGUAL EXPRESION 
	    | EXPRESION OP_MAYOR EXPRESION 
	    | S_PARENTESIS_ABRE EXPRESION S_PARENTESIS_CIERRA 
	    | NUMERO 
        | PR_TRUE 
        | PR_FALSE 
        | CADENA 
	    | CARACTER 
        | FUNCION
	    | ID 
;

