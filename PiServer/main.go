package main

import (
	"fmt"
	"log"
	"net/http"

	"PiServer/websocket"

	"periph.io/x/host/v3"
)


func main() {
	if _, err := host.Init(); err != nil {
		log.Fatal(err)
		return 
	}

	http.HandleFunc("/ws", websocket.WsHandler)
	fmt.Println("Server started on :8080")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("Server error: ", err)
		return 
	}
}