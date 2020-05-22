// CONSTANTES PARA LOS TIPOS DE VALORES DE LA GRAMATICA
const VALUE_TYPES = {
  NUMERO: "VALOR_NUMERO",
  IDENTIFICADOR: "VALOR_ID",
  CADENA: "VALOR_CADENA",
  CARACTER: "VALOR_CARACTER",
};

// CONSTANTES PARA LOS TIPOS DE OPERACIONES DE LA GRAMATICA
const OPERATION_VALUE = {
  SUMA: "OP_SUMA",
  RESTA: "OP_RESTA",
  MULTIPLICACION: "OP_MULTIPLICACION",
  DIVISION: "OP_DIVISION",
  MODULO: "OP_MODULO",
  NEGATIVO: "OP_NEGATIVO",
  MAYOR_QUE: "OP_MAYOR_QUE",
  MENOR_QUE: "OP_MENOR_QUE",

  MAYOR_IGUAL: "OP_MAYOR_IGUAL",
  MENOR_IGUAL: "OP_MENOR_IGUAL",
  DOBLE_IGUAL: "OP_DOBLE_IGUAL",
  DISTINTO: "OP_DISTINTO",

  AND: "OP_AND",
  OR: "OP_OR",
  NOT: "OP_NOT",

  CONCATENACION: "OP_CONCATENACION",
};

// CONSTANTES PARA LOS TIPOS DE INSTRUCCIONES QUE VALIDA LA GRAMATICA
const INSTRUCTION_TYPE = {
  IMPORT: "IMPORTACION",
  CLASS: "CLASE",
  DECLARACION: "DECLARACION",
  ASIGNACION: "ASIGNACION",
  IMPRESION: "IMPRESION",
  FUNCION: "FUNCION",
  IF: "IF",
  ELSE: "ELSE",
  IF_ELSE: "ELSE IF",
  SWITCH: "SWITCH",
  SWITCH_OP: "SWITCH_OP",
  SWITCH_DEF: "SWITCH_DEF",
  WHILE: "WHILE",
  DO_WHILE: "DOWHILE",
  FOR: "FOR",
  ASIGNACION_SIMPLIFICADA: "ASIGNACION_SIMPLIFICADA",
};

// CONSTANTE SP ARA LOS DIPOS DE LAS OPCIONES DEL SWITCH
const SWITCH_OPTION_TYPE = {
  CASE: "CASE",
  DEFAULT: "DEFAULT",
};

//

/**
 * Esta función se encarga de crear objetos tipo Operación.
 * Recibe como parámetros el operando izquierdo y el operando derecho.
 * También recibe como parámetro el tipo del operador
 * @param {*} operandoIzq
 * @param {*} operandoDer
 * @param {*} tipo
 */
function nuevaOperacion(operandoIzq, operandoDer, tipo) {
  return {
    OPERANDO_IZQUIERDO: operandoIzq,
    OPERANDO_DERECHO: operandoDer,
    TIPO: tipo,
  };
}

/**
 * El objetivo de esta API es proveer las funciones necesarias para la construcción de operaciones e instrucciones.
 */
const instruccionesAPI = {
  /**
   * Crreacion de la raiz del arbol AST
   * @param {*} imports
   * @param {*} clases
   */
  root: function (imports, clases) {
    return {
      raiz: {
        IMPORTS: imports,
        CLASES: clases,
      },
    };
  },

  /**
   * Creacion de la lista de Importaciones
   * @param {*} importaciones
   * @param {*} imports
   */
  nuevoImports: function (importaciones, imports) {
    return {
      IMPORTACIONES: importaciones,
      IMPORT: imports,
    };
  },

  /**
   * Creacion de objeto de cada importacion
   * @param {*} identificador
   */
  nuevoImport: function (identificador) {
    return {
      TIPO: INSTRUCTION_TYPE.IMPORT,
      IDENTIFICADOR: identificador,
      PUNTOCOMA: ";",
    };
  },

  /**
   * Creacion de la Lista de clases
   * @param {*} clases
   * @param {*} clase
   */
  nuevoClases: function (clases, clase) {
    return {
      CLASES: clases,
      CLASE: clase,
    };
  },
  /**
   * Creacion de objeto para cada clase declarada
   * @param {*} identificador
   * @param {*} instrucciones
   */
  nuevoClase: function (identificador, instrucciones) {
    return {
      TIPO: INSTRUCTION_TYPE.CLASS,
      IDENTIFICADOR: identificador,
      BLOQUE_CLASE: {
        LLAVE_ABRE: "{",
        INSTRUCCION: instrucciones,
        LLAVE_CIERRA: "}",
      },
    };
  },

  bloqueClase: function (clases, clase) {
    return {
      BLOQUE: clases,
      BLOQUEPRIMA: clase,
    };
  },

  /**
   * Crea un objeto tipo Instrucción para la sentencia Declaración.
   * @param {*}variables
   */
  nuevoDeclaracion: function (variables, tipo) {
    return {
      TIPO: INSTRUCTION_TYPE.DECLARACION,
      TIPO_DATO: tipo,
      VARIABLE: variables,
      PUNTOCOMA: ";",
    };
  },

  /**
   * Creacion de la lista de variables declaradas
   * @param {*} var1
   * @param {*} coma
   * @param {*} var2
   */
  nuevoVariables: function (var1, coma, var2) {
    return {
      VARIABLE: var1,
      COMA: coma,
      VARIABLEP: var2,
    };
  },

  /**
   * Crea un objeto tipo Instrucción para la sentencia Asignación.
   * @param {*} identificador
   * @param {*} expresion
   */
  nuevoAsignacion: function (identificador, expresion) {
    return {
      TIPO: INSTRUCTION_TYPE.ASIGNACION,
      IDENTIFICADOR: identificador,
      IGUAL: "=",
      EXPRESION: expresion,
      PUNTOCOMA: ";",
    };
  },

  /**
   * Creacion de objeto cuando aumenta o disminuye una variable
   * @param {*} identificador
   * @param {*} aumento
   */
  nuevoAumento: function (identificador, aumento) {
    return {
      IDENTIFICADOR: identificador,
      CAMBIO: aumento,
    };
  },

  /**
   * Creacion de objeto tipo Metodo
   * @param {*} identificador
   * @param {*} parametros
   * @param {*} instrucciones
   */
  nuevoMetodo: function (identificador, parametros, instrucciones) {
    return {
      METODOS: {
        TIPO: "METODO",
        VOID: "void",
        IDENTIFICADOR: identificador,
        PARENTESIS_ABRE: "(",
        PARAMETROS: parametros,
        PARENTESIS_CIERRA: ")",
        BLOQUE_METODO: {
          LLAVE_ABRE: "{",
          INSTRUCCION: instrucciones,
          LLAVE_CIERRA: "}",
        },
      },
    };
  },

  /**
   * Creacion de objeto tipo Funcion
   * @param {*} identificador
   * @param {*} parametros
   * @param {*} instrucciones
   */
  nuevoFuncion: function (tipo, identificador, parametros, instrucciones) {
    return {
      FUNCIONES: {
        TIPO: "FUNCION",
        TIPO_DATO: tipo,
        IDENTIFICADOR: identificador,
        PARENTESIS_ABRE: "(",
        PARAMETROS: parametros,
        PARENTESIS_CIERRA: ")",
        BLOQUE_METODO: {
          LLAVE_ABRE: "{",
          INSTRUCCION: instrucciones,
          LLAVE_CIERRA: "}",
        },
      },
    };
  },

  /**
   * Creacion de la lista de parametros
   * @param {*} parametros
   * @param {*} coma
   * @param {*} parametro
   */
  nuevoParametros: function (parametros, coma, parametro) {
    return {
      PRAMETROS: parametros,
      COMA: coma,
      PARAMETRO: parametro,
    };
  },

  /**
   * Crea un objeto para los parametros que pida la funcion
   * @param {*} tipo_dato
   * @param {*} identificador
   */
  nuevoParametro: function (tipo_dato, identificador) {
    return {
      TIPO: "PARAMETRO",
      TIPO_DATO: tipo_dato,
      identificador: identificador,
    };
  },

  /**
   * Creacion de objeto de las instrucciones en un bloque
   * @param {*} instrucciones
   * @param {*} instrucccion
   */
  nuevoInstrucciones: function (instrucciones, instrucccion) {
    return {
      INSTRUCTIONES: instrucciones,
      INSTRUCCION: instrucccion,
    };
  },

  /**
   * Creacion de objeto de una instruccion
   * @param {*} instrucccion
   */
  nuevoInstruccion: function (instrucccion) {
    return {
      INSTRUCCION: instrucccion,
    };
  },

  /**
   * Creacion de objeto de llamada una funcion
   * @param {*} identificador
   * @param {*} parametros
   */
  nuevoLLamadaFuncion: function (identificador, parametros) {
    return {
      TIPO: INSTRUCTION_TYPE.FUNCION,
      IDENTIFICADOR: identificador,
      PARENTESIS_ABRE: "(",
      PARAMETROS: parametros,
      PARENTESIS_CIERRA: ")",
      PUNTOCOMA: ";",
    };
  },

  /**
   * Creacion de objeto de parametros necesarios al llamar una funcion
   * @param {*} expresiones
   * @param {*} expresion
   */
  nuevoExpresionesParametro: function (expresiones, expresion) {
    return {
      PARAMETRO: expresiones,
      COMA: ",",
      PARAMETRO: expresion,
    };
  },

  /**
   * Crea un objeto tipo Instrucción para la sentencia Imprimir.
   * @param {*} tipo
   * @param {*} expresion
   */
  nuevoImprimir: function (tipo, expresion) {
    return {
      TIPO: INSTRUCTION_TYPE.IMPRESION,
      INSTRUCCION: "System.out." + tipo,
      EXPRESION: expresion,
    };
  },

  /**
   * Crea un objeto tipo Instrucción para la sentencia If.
   * @param {*} cuerpo
   */
  nuevoIf: function (cuerpo) {
    return {
      IF: cuerpo,
    };
  },

  /**
   * Crea un objeto del cuerpo del  if
   * @param {*} condicion
   * @param {*} instrucciones
   * @param {*} _else
   * @param {*} elseif
   */
  cuerpoIf: function (condicion, instrucciones, _else, elseif) {
    return {
      TIPO: INSTRUCTION_TYPE.IF,
      CONDICION: condicion,
      BLOQUE_INSTRUCCIONES: {
        LLAVE_ABRE: "{",
        INSTRUCCION: instrucciones,
        LLAVE_CIERRA: "}",
      },
      ELSE_IF: else_if,
      ELSE: _else,
    };
  },

  /**
   * Creacion del objeto de la intruccion else
   * @param {*} instrucciones
   */
  nuevoElse: function (instrucciones) {
    return {
      TIPO: INSTRUCTION_TYPE.ELSE,
      BLOQUE_INSTRUCCIONES: {
        LLAVE_ABRE: "{",
        INSTRUCCION: instrucciones,
        LLAVE_CIERRA: "}",
      },
    };
  },

  /**
   * Creacion de objetos tipo else if
   * @param {*} _if
   */
  nuevoElseIf: function (_if) {
    return {
      TIPO: INSTRUCTION_TYPE.IF_ELSE,
      IF: _if,
    };
  },

  /**
   * Creacion de objeto para condiciones
   * @param {*} expresion
   */
  nuevoCondicion: function (expresion) {
    return {
      PARENTESIS_ABRE: "(",
      EXPRESION: expresion,
      PARENTESIS_CIERRA: ")",
    };
  },

  /**
   * Crea un objeto tipo Instrucción para la sentencia Switch.
   * @param {*} condicion
   * @param {*} instrucciones
   */
  nuevoSwitch: function (condicion, casos) {
    return {
      TIPO: INSTRUCTION_TYPE.SWITCH,
      CONDICION: condicion,
      BLOQUE_SWITCH: {
        LLAVE_ABRE: "{",
        CASOS: casos,
        LLAVE_CIERRA: "}",
      },
    };
  },

  /**
   * Crea una lista de casos para la sentencia Switch.
   * @param {*} caso
   */
  nuevoListaCasos: function (caso) {
    var casos = [];
    casos.push(caso);
    return casos;
  },

  /**
   * Crea un objeto tipo OPCION_SWITCH para una CASO de la sentencia switch.
   * @param {*} expresion
   * @param {*} instrucciones
   */
  nuevoCaso: function (expresion, instrucciones) {
    return {
      TIPO: SWITCH_OPTION_TYPE.CASE,
      EXPRESION: expresion,
      DOSPUNTOS: ":",
      INSTRUCCIONES: instrucciones,
    };
  },

  /**
   * Crea un objeto tipo OPCION_SWITCH para un CASO DEFECTO de la sentencia switch.
   * @param {*} instrucciones
   */
  nuevoCasoDef: function (instrucciones) {
    return {
      TIPO: SWITCH_OPTION_TYPE.DEFAULT,
      DOSPUNTOS: ":",
      INSTRUCCION: instrucciones,
    };
  },

  /**
   * Crea un objeto tipo instrucción para la sentencia for.
   * @param {*} declaracion
   * @param {*} epresion
   * @param {*} instrucciones
   * @param {*} cambio
   * @param {*} decremento
   */
  nuevoFor: function (declaracion, expresion, cambio, instrucciones) {
    return {
      TIPO: INSTRUCTION_TYPE.FOR,
      DECLARACION: declaracion,
      PUNTOCOMA: ";",
      EXPRESION: expresion,
      PUNTOCOMA: ";",
      CAMBIO: cambio,
      BLOQUE_INSTRUCCIONES: {
        LLAVE_ABRE: "{",
        INSTRUCCION: instrucciones,
        LLAVE_CIERRA: "}",
      },
    };
  },

  /**
   * Crea un objeto tipo Instrucción para la sentencia While.
   * @param {*} condicion
   * @param {*} instrucciones
   */
  nuevoWhile: function (condicion, instrucciones) {
    return {
      tipo: INSTRUCTION_TYPE.WHILE,
      CONDICION: condicion,
      BLOQUE_INSTRUCCIONES: {
        LLAVE_ABRE: "{",
        INSTRUCCION: instrucciones,
        LLAVE_CIERRA: "}",
      },
    };
  },

  /**
   * Creacion de objeto tipo do while.
   * @param {*} condicion
   * @param {*} instrucciones
   */
  nuevoDoWhile: function (condicion, instrucciones) {
    return {
      TIPO: INSTRUCTION_TYPE.DO_WHILE,
      BLOQUE_INSTRUCCIONES: {
        LLAVE_ABRE: "{",
        INSTRUCCION: instrucciones,
        LLAVE_CIERRA: "}",
      },
      CONDICION: condicion,
      PUNTOCOMA: ";",
    };
  },

  /**
   * Creacion de objeto break
   */
  nuevoBreak: function () {
    return {
      TIPO: "BREAK",
      PUNTOCOMA: ";",
    };
  },

  /**
   * Creacion de objeto continue
   */
  nuevoContinue: function () {
    return {
      TIPO: "CONTINUE",
      PUNTOCOMA: ";",
    };
  },

  /**
   * Creacion de un objeto de retorno
   * @param {*} expresion
   */
  nuevoReturn: function (expresion) {
    return {
      TIPO: "RETURN",
      EXPRESION: expresion,
      PUNTOCOMA: ";",
    };
  },

  /**
   * Crea un nuevo objeto tipo Operación para las operaciones binarias válidas.
   * @param {*} operandoIzq
   * @param {*} operandoDer
   * @param {*} tipo
   */
  nuevoOperacionBinaria: function (operandoIzq, operandoDer, tipo) {
    return nuevaOperacion(operandoIzq, operandoDer, tipo);
  },

  /**
   * Crea un nuevo objeto tipo Operación para las operaciones unarias válidas
   * @param {*} operando
   * @param {*} tipo
   */
  nuevoOperacionUnaria: function (operando, tipo) {
    return nuevaOperacion(operando, undefined, tipo);
  },

  /**
   * Crea un nuevo objeto tipo Valor, esto puede ser una cadena, un número o un identificador
   * @param {*} valor
   * @param {*} tipo
   */
  nuevoValor: function (valor, tipo) {
    return {
      TIPO: tipo,
      VALOR: valor,
    };
  },

  /**
   * Crea un objeto tipo Operador (+ , - , / , *, %)
   * @param {*} operador
   */
  nuevoOperador: function (operador) {
    return operador;
  },

  /**
   * Crea un objeto tipo Instrucción para la sentencia Asignacion con Operador
   * @param {*} identificador
   * @param {*} operador
   * @param {*} expresionCadena
   */
  nuevoAsignacionSimplificada: function (
    identificador,
    operador,
    expresionNumerica
  ) {
    return {
      TIPO: INSTRUCTION_TYPE.ASIGNACION_SIMPLIFICADA,
      OPERADOR: operador,
      EXPRESION: expresionNumerica,
      IDENTIFICADOR: identificador,
    };
  },
};
// Exportamos nuestras constantes y nuestra API

module.exports.OPERATION_VALUE = OPERATION_VALUE;
module.exports.INSTRUCTION_TYPE = INSTRUCTION_TYPE;
module.exports.VALUE_TYPES = VALUE_TYPES;
module.exports.instruccionesAPI = instruccionesAPI;
module.exports.SWITCH_OPTION_TYPE = SWITCH_OPTION_TYPE;

// El codigo fue inspirado en el ejemplo dado de el Ingeniero Erick Navarro
