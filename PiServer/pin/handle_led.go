package pin

import (
	"fmt"
	"log"

	"periph.io/x/conn/v3/gpio"
	"periph.io/x/conn/v3/gpio/gpioreg"
)


func HandleLED(gpioName string, switchChan chan bool) error {
	pinLed := gpioreg.ByName(gpioName)
	if pinLed == nil {
		log.Fatal("Impossible to find LED pin")
		return fmt.Errorf("pin not found")
	}
	if err := pinLed.Out(gpio.Low); err != nil {
		log.Println(err)
	}

	for switchState := range switchChan {
		if switchState {
			if err := pinLed.Out(gpio.High); err != nil {
				log.Println(err)
			}
		} else {
			if err := pinLed.Out(gpio.Low); err != nil {
				log.Println(err)
			}
		}
	}
	return nil
}



