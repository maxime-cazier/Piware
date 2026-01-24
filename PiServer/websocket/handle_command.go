package websocket

import (
  "context"
  "fmt"

  "PiServer/pin"
)

func HandleCommand(ctx context.Context, client Client) {
  redLedChan := make(chan bool)
  greenLedChan := make(chan bool)
  blueLedChan := make(chan bool)

  defer close(redLedChan)
  defer close(greenLedChan)
  defer close(blueLedChan)

  go pin.HandleLED(pin.LED_ROUGE, redLedChan)
  go pin.HandleLED(pin.LED_VERTE, greenLedChan)
  go pin.HandleLED(pin.LED_BLEUE, blueLedChan)

  for command := range client.inputChan {
      
      var targetChan chan bool
      var valueToSend bool
      switch command {
      case CommandTurnRedLedOn:
        targetChan = redLedChan
        valueToSend = true
      case CommandTurnRedLedOff:
        targetChan = redLedChan
        valueToSend = false
      case CommandTurnGreenLedOn:
        targetChan = greenLedChan
        valueToSend = true
      case CommandTurnGreenLedOff:
        targetChan = greenLedChan
        valueToSend = false
      case CommandTurnBlueLedOn:
        targetChan = blueLedChan
        valueToSend = true
      case CommandTurnBlueLedOff:
        targetChan = blueLedChan
        valueToSend = false
      default:
        fmt.Println("Unknown command received :", command)
        continue 
      }

      if targetChan != nil {
        select {
        case targetChan <- valueToSend:
        case <-ctx.Done():
          return
        }
      }
  }
}