var fs = require("fs");
var parser = require("./Grammar/gramatica");

const OPERATION_VALUE = require("./Instrucciones/instrucciones")
  .OPERATION_VALUE;
const VALUE_TYPES = require("./Instrucciones/instrucciones").VALUE_TYPES;
const TYPES = require("./Instrucciones/instrucciones").TYPES;
const SWITCH_OPTION_TYPE = require("./Instrucciones/instrucciones")
  .SWITCH_OPTION_TYPE;
const instruccionesAPI = require("./Instrucciones/instrucciones")
  .instruccionesAPI;

fs.readFile("./entrada.txt", (err, data) => {
  if (err) throw err;
  parser.parse(data.toString());
});
