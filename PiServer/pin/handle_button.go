package pin

import (
	"context"
	"fmt"
	"time"

	"periph.io/x/conn/v3/gpio"
	"periph.io/x/conn/v3/gpio/gpioreg"
)

func HandleButton(ctx context.Context, gpioName string, stateChan chan bool) {
	pinBouton := gpioreg.ByName(gpioName)
	if pinBouton == nil {
		fmt.Println("Impossible to find button pin")
		return
	}
	if err := pinBouton.In(gpio.PullUp, gpio.NoEdge); err != nil {
    fmt.Println("Error configuring button:", err)
    return
  }

	for {
		level := pinBouton.Read()
		select {
		case stateChan <- level == gpio.Low:
			time.Sleep(50 * time.Millisecond)
			continue
		case <-ctx.Done():
			return
		}

	}
}
