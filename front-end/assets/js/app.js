function getText() {
  var editor = document.getElementById("editorOriginal").value;
  console.log(editor);

  var url = "http://localhost:3000/parser/";
  const data = { text: editor };

  fetch(url, {
    method: "POST",
    body: JSON.stringify(data),
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((res) => res.json())
    .catch((error) => console.error("Error:", error))
    .then((response) => {
      console.log("Success:", response);
      colocarResultado(response);
      return response;
    });
}

function clearEverything() {
  document.getElementById("editorOriginal").value = "";
  document.getElementById("editorCopia").value = "";
  document.getElementById("salida").value = "";
}

function abrir() {
  editor = document.getElementById("editor");
  var archivo = document.getElementById("fileInput");

  archivo.addEventListener("change", procesar, false);
}

function procesar(e) {
  var archivos = e.target.files[0];

  var lector = new FileReader();
  lector.readAsText(archivos);
  lector.addEventListener("load", mostrar, false);
}

function mostrar(e) {
  var result = e.target.result.toString();
  document.getElementById("editorOriginal").value = result;
}

function colocarResultado(json) {
  document.getElementById("salida").value = JSON.stringify(json, null, "\t");
}

window.addEventListener("load", abrir, false);
