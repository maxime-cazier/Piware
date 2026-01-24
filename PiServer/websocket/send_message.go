package websocket

import "fmt"

func SendMessage(client Client) {
	for message := range client.outputChan {
		err := client.conn.WriteJSON(message)
		if err != nil {
			fmt.Println("Error sending message :", err)
			break
		}
	}
}