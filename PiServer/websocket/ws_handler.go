package websocket

import (
	"context"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

type Command = string

const (
	CommandTurnRedLedOn Command = "TURN_RED_LED_ON"
	CommandTurnGreenLedOn Command = "TURN_GREEN_LED_ON"
	CommandTurnBlueLedOn Command = "TURN_BLUE_LED_ON"
	CommandTurnRedLedOff Command = "TURN_RED_LED_OFF"
	CommandTurnGreenLedOff Command = "TURN_GREEN_LED_OFF"
	CommandTurnBlueLedOff Command = "TURN_BLUE_LED_OFF"
)

type MessageDto struct {
	Button1 bool `json:"Button1"`
	Button2 bool `json:"Button2"`
	Button3 bool `json:"Button3"`
	Distance float64  `json:"Distance"`
}

type Client struct {
	conn *websocket.Conn
	inputChan chan Command
	outputChan chan MessageDto
}

func WsHandler(w http.ResponseWriter, r *http.Request) {
	var upgrader = websocket.Upgrader{
		ReadBufferSize:  512,
		WriteBufferSize: 512,
		CheckOrigin: func(r *http.Request) bool {
			return true 
		},
	}

	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("Error upgrading connection:", err)
		return
	}

	defer conn.Close()
	inputChan := make(chan Command)
	outputChan := make(chan MessageDto)

	var client = Client{
		conn: conn,
		inputChan: inputChan,
		outputChan: outputChan,
	}

	defer close(inputChan)
	defer close(outputChan)
	ctx, cancel := context.WithCancel(context.Background())
  defer cancel()

	go HandleCommand(ctx, client)
	go BuildMessage(ctx, client)
	go SendMessage(client)
	ReadInput(client)
}