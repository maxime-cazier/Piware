package websocket

import (
	"PiServer/pin"
	"context"
)

func BuildMessage(ctx context.Context, client Client) {
  btn1Chan := make(chan bool)
  btn2Chan := make(chan bool)
  btn3Chan := make(chan bool)
  distChan := make(chan float64) 

  defer close(btn1Chan)
  defer close(btn2Chan)
  defer close(btn3Chan)
  defer close(distChan)

  go pin.HandleButton(ctx, pin.BTN_1, btn1Chan)
  go pin.HandleButton(ctx, pin.BTN_2, btn2Chan)
  go pin.HandleButton(ctx, pin.BTN_3, btn3Chan)
  go pin.HandleDistance(ctx, pin.DISTCAPT_TRIG, pin.DISTCAPT_ECHO, distChan)

  for {
    var state MessageDto

    
    state.Button1 = <-btn1Chan
    state.Button2 = <-btn2Chan
    state.Button3 = <-btn3Chan
    state.Distance = <-distChan

		select {
		case <-ctx.Done():
			return
		case client.outputChan <- state:
		}
	}
}
