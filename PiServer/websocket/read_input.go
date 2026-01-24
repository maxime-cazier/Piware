package websocket

import (
	"encoding/json"
	"fmt"
)

type CommandDto struct {
	Command string `json:"Command"`
}

func ReadInput(client Client) {
	for {
		_, commandByte, err := client.conn.ReadMessage()
		if err != nil {
			break
		}
		var commandDto CommandDto
		err = json.Unmarshal(commandByte, &commandDto)
    if err != nil {
        fmt.Println("Error parsing command :", err)
				continue
    }
		switch Command(commandDto.Command) {
			case CommandTurnBlueLedOn, CommandTurnBlueLedOff, CommandTurnGreenLedOff, CommandTurnGreenLedOn, CommandTurnRedLedOff, CommandTurnRedLedOn:
				client.inputChan <- Command(commandDto.Command)
			default:
				fmt.Println("Unknown command :", commandDto.Command)
		}
	}
}