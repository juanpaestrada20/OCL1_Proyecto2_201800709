const port = 3000;
const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const cors = require("cors");

var fs = require("fs");
var parser = require("./Grammar/gramatica");

const OPERATION_VALUE = require("./Instrucciones/instrucciones")
  .OPERATION_VALUE;
const VALUE_TYPES = require("./Instrucciones/instrucciones").VALUE_TYPES;
const TYPES = require("./Instrucciones/instrucciones").TYPES;
const instruccionesAPI = require("./Instrucciones/instrucciones")
  .instruccionesAPI;
const errores = require("./Instrucciones/instrucciones").ERRORES;

let ast;

app.use(express.json());
app.use(bodyParser.json());
app.use(cors());

app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "POST, PUT, GET, OPTIONS");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  next();
});

app.post("/parser/", (request, response) => {
  var entrada = request.body.text;
  var result = crearAst(entrada);
  response.send(result);
});

function crearAst(text) {
  try {
    ast = parser.parse(text.toString());
    fs.writeFileSync("./ast.json", JSON.stringify(ast, null, 2));
    return ast;
  } catch (e) {
    console.error(e);
    return;
  }
}

app.listen(port, () => {
  console.log("Backend Iniciado en http://localhost:3000");
});
