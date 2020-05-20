package main

import (
	"fmt"
	"html/template"
	"net/http"
)

func index(w http.ResponseWriter, r *http.Request) {
	t := template.Must(template.ParseFiles("index.html"))
	t.Execute(w, nil)
}

func main() {
	fs := http.FileServer(http.Dir("assets"))
	http.Handle("/assets/", http.StripPrefix("/assets/", fs))
	http.Handle("/css", http.FileServer(http.Dir("css/")))
	http.Handle("/js", http.FileServer(http.Dir("js/")))
	http.HandleFunc("/", index)
	fmt.Printf("Listening...")
	http.ListenAndServe(":8080", nil)
}
