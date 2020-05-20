function getText() {
  var editor = document.getElementById("editorOriginal").value;
  console.log(editor);
}

function clearEverything() {
  document.getElementById("editorOriginal").value = "";
  document.getElementById("editorCopia").value = "";
  document.getElementById("salida").value = "";
}
