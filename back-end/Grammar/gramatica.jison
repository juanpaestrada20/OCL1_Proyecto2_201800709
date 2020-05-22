/* GRAMATICA PARA EL LENGUAJE JAVA */
%{
        const ERRORES			= require('../Instrucciones/instrucciones').ERRORES; 
%}

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
"boolean"                           return 'TD_BOOLEAN';
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
"+="                                return 'OP_SUMA_SIMPLIFICADA';
"-="                                return 'OP_RESTA_SIMPLIFICADA';
"*="                                return 'OP_MULTIPLICACION_SIMPLIFICADA';
"/="                                return 'OP_DIVISION_SIMPLIFICADA';
"%="                                return 'OP_MODULO_SIMPLIFICADA';

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
\"[^\"]*\"	                    { yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
\'[^\']*\'	                    { yytext = yytext.substr(1,yyleng-2); return 'CARACTER'; }

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

%{
	const OPERATION_VALUE	= require('../Instrucciones/instrucciones').OPERATION_VALUE;
	const VALUE_TYPES 		= require('../Instrucciones/instrucciones').VALUE_TYPES;
	const TYPES			= require('../Instrucciones/instrucciones').TYPES; 
	const instruccionesAPI	= require('../Instrucciones/instrucciones').instruccionesAPI;
%}
        
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
%right 'OP_SUMA_SIMPLIFICADA' 'OP_RESTA_SIMPLIFICADA' 'OP_MULTIPLICACION_SIMPLIFICADA'  'OP_DIVISION_SIMPLIFICADA' 'OP_MODULO_SIMPLIFICADA'

// SIMBOLO INICIAL
%start INICIO

%%
/* ANALIZADOR SINTACTICO */

INICIO
        : INICIOPRIMA EOF       { return $1; } // Se retorna el AST al finalizar de reconocer la entrada
;

INICIOPRIMA
        : INICIOPRIMA IMPORTACIONES     { $1.push($2); $$ = $1; }
        | IMPORTACIONES                 { $$ = $1; }
;

IMPORTACIONES
        : PR_IMPORT IMPORTACION        { $$ = $2; } 
        | PR_CLASS CLASE               { $$ = $2; }
;

IMPORTACION
        : ID S_PUNTOCOMA      { $$ = instruccionesAPI.nuevoImport($1); }
;

CLASE
        : ID S_LLAVE_ABRE CUERPO S_LLAVE_CIERRA { $$ = instruccionesAPI.nuevoClase($1, $3);}
        | ID S_LLAVE_ABRE S_LLAVE_CIERRA        { $$ = instruccionesAPI.nuevoClase($1, undefined);}
;

CUERPO
        : CUERPO CUERPOPRIMA    { $1.push($2); $$ = $1; }
        | CUERPOPRIMA           { $$ = $1; }  
;

CUERPOPRIMA
        : DECLARACIONES { $$ = $1;}
        | FUNCIONES     { $$ = $1; }
;

DECLARACIONES 
        : TIPO_DATO DECLARACION S_PUNTOCOMA { $$ = instruccionesAPI.nuevoDeclaracion($2, $1); }
;

DECLARACION
        : DECLARACION S_COMA DECLARACIONPRIMA   { $$ = instruccionesAPI.nuevoVariables($1, $2, $3); }
        | DECLARACIONPRIMA                      { $$ = $1;}
;

DECLARACIONPRIMA
        : ID                    { $$ = $1 }
        | ID S_IGUAL EXPRESION  { $$ = instruccionesAPI.nuevoAsignacion($1, $3); }
;

FUNCIONES 
        : TIPO_DATO ID PARAMETROS CUERPO_METODO                                 { $$ = instruccionesAPI.nuevoFuncion($1, $2, $3, $4); }
        | PR_VOID ID PARAMETROS CUERPO_METODO                                   { $$ = instruccionesAPI.nuevoMetodo($2, $3, $4); }
        | PR_VOID PR_MAIN S_PARENTESIS_ABRE S_PARENTESIS_CIERRA CUERPO_METODO  { $$ = instruccionesAPI.nuevoMetodo($2, undefined, $4); }
;

PARAMETROS
        : S_PARENTESIS_ABRE LISTA_PARAMETRO S_PARENTESIS_CIERRA { $$ = $2; }
        | S_PARENTESIS_ABRE S_PARENTESIS_CIERRA                 { $$ = undefined; }
;

LISTA_PARAMETRO
        : LISTA_PARAMETRO S_COMA PARAMETRO        { $$ = instruccionesAPI.nuevoParametros($1, $2, $3); }
        | PARAMETRO                             { $$ = $1; }
;

PARAMETRO
        : TIPO_DATO ID  { $$ = instruccionesAPI.nuevoParametro($1, $2); }
;

CUERPO_METODO
        : S_LLAVE_ABRE INSTRUCCIONES S_LLAVE_CIERRA     { $$ = $2; }
        | S_LLAVE_ABRE S_LLAVE_CIERRA                   { $$ = undefined; }
;

INSTRUCCIONES
        : INSTRUCCIONES INSTRUCCION     { $$ = instruccionesAPI.nuevoInstrucciones($1, $2); }
        | INSTRUCCION                   { $$ = instruccionesAPI.nuevoInstruccion($1); }
;

INSTRUCCION
        : DECLARACIONES { $$ = $1; }
        | ASIGNACION    { $$ = $1; }
        | FUNCION       { $$ = $1; }
        | IMPRESION     { $$ = $1; }
        | IF            { $$ = $1; }
        | SWITCH        { $$ = $1; }
        | WHILE         { $$ = $1; }
        | DO_WHILE      { $$ = $1; }
        | FOR           { $$ = $1; }
        | BREAK         { $$ = $1; }
        | CONTINUE      { $$ = $1; }
        | RETURN        { $$ = $1; }
;

ASIGNACION
        : ID S_IGUAL EXPRESION S_PUNTOCOMA      { $$ = instruccionesAPI.nuevoAsignacion($1, $3); }
        | ID OP_AUMENTO S_PUNTOCOMA             { $$ = instruccionesAPI.nuevoAumento($1, $2); }
        | ID OP_DECREMENTO S_PUNTOCOMA          { $$ = instruccionesAPI.nuevoAumento($1, $2); }
        | ID OP_SIMPLIFICADA EXPRESION          { $$ = instruccionesAPI.nuevoAsignacionSimplificada($1, $2, $3); }
;

FUNCION
        : ID S_PARENTESIS_ABRE EXPRESIONES S_PARENTESIS_CIERRA S_PUNTOCOMA      { $$ = instruccionesAPI.nuevoLLamadaFuncion($1,$3); }
        | ID S_PARENTESIS_ABRE S_PARENTESIS_CIERRA S_PUNTOCOMA                  { $$ = instruccionesAPI.nuevoLLamadaFuncion($1, undefined); }
;

EXPRESIONES     
        : EXPRESIONES S_COMA EXPRESION  { $$ = instruccionesAPI.nuevoExpresionesParametro($1, $3); }
        | EXPRESION                     { $$ = $1; }  
;

IMPRESION 
        : PR_SYSTEM S_PUNTO PR_OUT S_PUNTO TIPO_IMPRESION S_PARENTESIS_ABRE EXPRESION S_PARENTESIS_CIERRA S_PUNTOCOMA { $$ = instruccionesAPI.nuevoImprimir($5, $7); }
;

TIPO_IMPRESION 
        : PR_PRINT      { $$ = $1; }
        | PR_PRINTLN    { $$ = $1; }
;

IF
        : PR_IF CONDICION CUERPO_METODO                         { $$ = instruccionesAPI.cuerpoIf($2, $3, undefined, undefined); }
        | PR_IF CONDICION CUERPO_METODO PR_ELSE CUERPO_METODO   { $$ = instruccionesAPI.cuerpoIf($2, $3, instruccionesAPI.nuevoElse($5), undefined); }
        | PR_IF CONDICION CUERPO_METODO PR_ELSE IF              { $$ = instruccionesAPI.cuerpoIf($2, $3, undefined, instruccionesAPI.nuevoElseIf($5)); }
;

CONDICION
        : S_PARENTESIS_ABRE EXPRESION S_PARENTESIS_CIERRA   { $$ = instruccionesAPI.nuevoCondicion($2); }
;

SWITCH
        : PR_SWITCH CONDICION S_LLAVE_ABRE CASES S_LLAVE_CIERRA { $$ = instruccionesAPI.nuevoSwitch($2, $4); }
;

CASES
        : CASES CASE    { $1.push($2); $$ = $1; }
        | CASE          { $$ = instruccionesAPI.nuevoListaCasos($1); }
;

CASE    
        : PR_CASE EXPRESION S_DOSPUNTOS INSTRUCCIONES   { $$ = instruccionesAPI.nuevoCaso($2, $4); }
        | PR_DEFAULT S_DOSPUNTOS INSTRUCCIONES          { $$ = instruccionesAPI.nuevoCasoDef($3); }
;      

WHILE 
        : PR_WHILE CONDICION CUERPO_METODO      { $$ = instruccionesAPI.nuevoWhile($2,$3); }
;

DO_WHILE 
        : PR_DO CUERPO_METODO PR_WHILE CONDICION S_PUNTOCOMA    { $$ = instruccionesAPI.nuevoDoWhile($4, $2); }
;

FOR     
        : PR_FOR S_PARENTESIS_ABRE ASIGNACION_FOR  EXPRESION S_PUNTOCOMA CAMBIO_VALOR S_PARENTESIS_CIERRA CUERPO_METODO { $$ = instruccionesAPI.nuevoFor($3, $5, $7, $9); }
;

ASIGNACION_FOR
        : DECLARACIONES { $$ = $1; }
        | ASIGNACION    { $$ = $1; }
;

CAMBIO_VALOR
        : ID OP_SUMA OP_SUMA    { $$ = instruccionesAPI.operacionUnaria(OPERATION_VALUE.AUMENTO); }
        | ID OP_RESTA OP_RESTA  { $$ = instruccionesAPI.operacionUnaria(OPERATION_VALUE.DECREMENTO); }
;

BREAK
        : PR_BREAK S_PUNTOCOMA  { $$ = instruccionesAPI.nuevoBreak(); }
;

CONTINUE
        : PR_CONTINUE S_PUNTOCOMA { $$ = instruccionesAPI.nuevoContinue(); }
;

RETURN
        : PR_RETURN EXPRESION S_PUNTOCOMA       { $$ = instruccionesAPI.nuevoReturn($2); }
        | PR_RETURN S_PUNTOCOMA                 { $$ = instruccionesAPI.nuevoReturn(undefined); }
;

TIPO_DATO
        : TD_CHAR       { $$ = instruccionesAPI.nuevoValor($1, TYPES.CAHR); }
        | TD_STRING     { $$ = instruccionesAPI.nuevoValor($1, TYPES.STRING); }
        | TD_INT        { $$ = instruccionesAPI.nuevoValor($1, TYPES.INT); }
        | TD_DOUBLE     { $$ = instruccionesAPI.nuevoValor($1, TYPES.DOUBLE); }
        | TD_BOOLEAN    { $$ = instruccionesAPI.nuevoValor($1, TYPES.BOOLEAN); }
;

OP_SIMPLIFICADA
        : OP_SUMA_SIMPLIFICADA                  { $$ = instruccionesAPI.nuevoOperador(OPERATION_VALUE.MAS_IGUAL); }
        | OP_RESTA_SIMPLIFICADA                 { $$ = instruccionesAPI.nuevoOperador(OPERATION_VALUE.MENOS_IGUAL); }
        | OP_MULTIPLICACION_SIMPLIFICADA        { $$ = instruccionesAPI.nuevoOperador(OPERATION_VALUE.MULTIPLICACION_IGUAL); }
        | OP_DIVISION_SIMPLIFICADA              { $$ = instruccionesAPI.nuevoOperador(OPERATION_VALUE.DIVISION_IGUAL); }
        | OP_MODULO_SIMPLIFICADA                { $$ = instruccionesAPI.nuevoOperador(OPERATION_VALUE.MODULO_IGUAL); }
;

EXPRESION
        : OP_RESTA EXPRESION %prec UMENOS	                { $$ = instruccionesAPI.operacionUnaria($2, OPERATION_VALUE.NEGATIVO); }
	| OP_NOT EXPRESION	                                { $$ = instruccionesAPI.operacionUnaria($2, OPERATION_VALUE.NOT); }
        | EXPRESION OP_SUMA EXPRESION                           { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.SUMA); }
        | EXPRESION OP_RESTA EXPRESION	                        { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.RESTA); }
        | EXPRESION OP_MULTIPLICACION EXPRESION                 { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.MULTIPLICACION); }
        | EXPRESION OP_DIVISION EXPRESION                       { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.DIVISION); }
	| EXPRESION OP_MODULO EXPRESION                         { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.MODULO); }
	| EXPRESION OP_POTENCIA EXPRESION                       { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.POTENCIA); }
	| EXPRESION OP_AND EXPRESION	                        { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.AND); }
	| EXPRESION OP_OR EXPRESION                             { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.OR); }
	| EXPRESION OP_IGUALIGUAL EXPRESION                     { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.IGUAL_IGUAL); }
	| EXPRESION OP_DISTINTO EXPRESION                       { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.DISTINTO); }
	| EXPRESION OP_MENOR S_IGUAL EXPRESION                  { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.MENOR_IGUAL); }
	| EXPRESION OP_MENOR EXPRESION                          { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.MENOR_QUE); }
	| EXPRESION OP_MAYOR S_IGUAL EXPRESION                  { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.MAYOR_IGUAL); }
	| EXPRESION OP_MAYOR EXPRESION                          { $$ = instruccionesAPI.operacionBinaria($1, $3, OPERATION_VALUE.MAYOR_QUE); }
	| S_PARENTESIS_ABRE EXPRESION S_PARENTESIS_CIERRA       { $$ = $2; }
	| NUMERO        { $$ = instruccionesAPI.nuevoValor($1, VALUE_TYPES.NUMERO); }
        | PR_TRUE       { $$ = instruccionesAPI.nuevoValor($1, VALUE_TYPES.BOOLEAN); }
        | PR_FALSE      { $$ = instruccionesAPI.nuevoValor($1, VALUE_TYPES.BOOLEAN); }
        | CADENA        { $$ = instruccionesAPI.nuevoValor($1, VALUE_TYPES.CADENA); }
	| CARACTER      { $$ = instruccionesAPI.nuevoValor($1, VALUE_TYPES.CARACTER); }
        | FUNCION2      { $$ = instruccionesAPI.nuevoValor($1, "FUNCION"); }
	| ID            { $$ = instruccionesAPI.nuevoValor($1, VALUE_TYPES.IDENTIFICADOR); }
;

FUNCION2
        : ID S_PARENTESIS_ABRE EXPRESIONES S_PARENTESIS_CIERRA
        | ID S_PARENTESIS_ABRE S_PARENTESIS_CIERRA
;