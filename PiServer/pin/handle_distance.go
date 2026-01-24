package pin

import (
	"context"
	"fmt"
	"log"
	"time"

	"periph.io/x/conn/v3/gpio"
	"periph.io/x/conn/v3/gpio/gpioreg"
)

func HandleDistance(ctx context.Context, gpioNameTrig string, gpioNameEcho string, distanceChan chan float64) {
	pinTrig := gpioreg.ByName(gpioNameTrig)
	if pinTrig == nil {
		log.Println("Impossible to find Trig pin")
	}

	pinEcho := gpioreg.ByName(gpioNameEcho)
	if pinEcho == nil {
		log.Println("Impossible to find Echo pin")
	}

	if err := pinTrig.Out(gpio.Low); err != nil {
		log.Println(err)
	}
	if err := pinEcho.In(gpio.Float, gpio.NoEdge); err != nil {
		log.Println(err)
	}

	for {
		var start, end time.Time
		var distanceCm float64
		var noEcho bool

		pinTrig.Out(gpio.High)
		time.Sleep(10 * time.Microsecond)
		pinTrig.Out(gpio.Low)

		now := time.Now()
		timeout := now.Add(100 * time.Millisecond)

		for pinEcho.Read() == gpio.Low {
			if time.Now().After(timeout) {
				fmt.Println("Error: No Echo signal")
				noEcho = true
				break
			}
		}
		start = time.Now()
		if noEcho {
			distanceChan <- -1
			continue
		}

		for pinEcho.Read() == gpio.High {
			if time.Now().After(timeout) {
				fmt.Println("Error: Echo signal too long")
				noEcho = true
				break
			}
		}
		end = time.Now()
		if noEcho {
			distanceChan <- -1
			continue
		}

		distanceCm = (end.Sub(start).Seconds() * 34300) / 2
		if distanceCm < 0 || distanceCm > 400 {
			distanceCm = -1
		}

		select {
		case <-ctx.Done():
			return
		case distanceChan <- distanceCm:
		}

		if time.Since(now) < 100*time.Millisecond {
			time.Sleep(100*time.Millisecond - time.Since(now))
		}
	}
}