// +build production

package service

import (
	"context"
	"log"

	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
	"github.com/vigno88/venn-press/VennServer/pkg/control"
	action_scheduler "github.com/vigno88/venn-press/VennServer/pkg/scheduler"
	"github.com/vigno88/venn-press/VennServer/pkg/serial"
)

// metricServiceServer is implementation of proto.metricServiceServer proto interface
type controlServiceServer struct {
	controlChan chan *proto.ControlEvent
}

func NewControlServiceServer(c chan *proto.ControlEvent) proto.ControlServiceServer {
	return &controlServiceServer{c}
}

func (s *controlServiceServer) Send(c context.Context, a *proto.Action) (*proto.SendResponse, error) {
	if a.Name == `test` {
		if a.Payload == `start` {
			action_scheduler.Start()
			control.SendEvent(&proto.ControlEvent{Name: "test", Payload: "start"})
		} else if a.Payload == `stop` {
			action_scheduler.Stop()
			control.SendEvent(&proto.ControlEvent{Name: "test", Payload: "stop"})
		}
		return &proto.SendResponse{}, nil
	}

	serial.SendCommand(a)
	return &proto.SendResponse{}, nil
}

func (s *controlServiceServer) Subscribe(e *proto.Empty, stream proto.ControlService_SubscribeServer) error {
	log.Print("Control Subscribe requested")
	for {
		c := <-s.controlChan
		// metrics.Put(context.Background(), m)
		if err :=
			stream.Send(c); err != nil {
			// put message back to the channel
			s.controlChan <- c
			log.Printf("Control stream connection failed: %v", err)
			return nil
		}
	}
}

func (s *controlServiceServer) ReadConfig(ctx context.Context, e *proto.Empty) (*proto.ControlConfigs, error) {
	cs, err := control.ReadAll()
	if err != nil {
		return nil, err
	}
	var configs []*proto.ControlConfig
	for _, c := range cs {
		configs = append(configs, control.ToProto(&c))
	}
	return &proto.ControlConfigs{Configs: configs}, nil
}
