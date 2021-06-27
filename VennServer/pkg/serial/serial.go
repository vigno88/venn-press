package serial

import (
	"bufio"
	"context"
	"encoding/binary"
	"fmt"
	"io"
	"log"
	"time"

	config "github.com/vigno88/venn-press/VennServer/configs"
	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"

	"github.com/vmihailenco/msgpack"
	"go.bug.st/serial"
)

type serialManager struct {
	Port     serial.Port
	Response map[string]chan string
	ToSend   chan []byte
	Received chan []byte
	ErrChan  chan error
	gRPCChan chan *proto.MetricUpdates
}

var manager serialManager

func Init(ctx context.Context, c chan *proto.MetricUpdates) error {
	p, err := manager.openPort()
	if err != nil {
		return err
	}
	mapChan := make(map[string]chan string)
	mapChan["setting"] = make(chan string)
	manager = serialManager{
		Port:     p,
		Response: mapChan,
		Received: make(chan []byte),
		ErrChan:  make(chan error),
		ToSend:   make(chan []byte),
		gRPCChan: c,
	}
	return nil
}

func (m *serialManager) openPort() (serial.Port, error) {
	mode := &serial.Mode{
		BaudRate: 115200,
	}
	port, err := serial.Open("/dev/ttyAMA2", mode)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	log.Printf("Serial port opened\n")
	return port, nil
}

func Run(ctx context.Context, exit chan<- string) {
	stopRead := make(chan string)
	go manager.readPort(stopRead)
	for {
		select {
		case request := <-manager.ToSend:
			_, err := manager.Port.Write([]byte(request))
			log.Printf("Print %s to the serial port\n", request)
			if err != nil {
				manager.ErrChan <- fmt.Errorf("Error writing port: %v", err)
				stopRead <- "done"
				return
			}
		case received := <-manager.Received:
			manager.process(ctx, received)
		case err := <-manager.ErrChan:
			log.Printf("Error: %v\n", err)
		}
	}
}

func SendString(s string) {
	manager.ToSend <- []byte(s)
}

func (m *serialManager) readPort(stop <-chan string) {
	log.Printf("Starting to read the serial port\n")
	serialReader := bufio.NewReader(m.Port)
	for {
		select {
		case <-stop:
			return
		default:
			// // Read 2 bytes to get length
			l := make([]byte, 2)
			_, err := io.ReadFull(serialReader, l)
			if err != nil {
				log.Printf("Error reading from the serial port: %v\n", err)
			}
			// Convert the 2 byte to a uint16
			lP := binary.LittleEndian.Uint16(l)
			payload := make([]byte, lP)
			_, err = io.ReadFull(serialReader, payload)
			if err != nil {
				log.Printf("Error reading from the serial port: %v\n", err)
			}
			m.Received <- payload
			time.Sleep(time.Millisecond)
		}
	}
}

func (m *serialManager) process(ctx context.Context, packet []byte) error {
	// Get the type of packet
	var out map[string]interface{}
	err := msgpack.Unmarshal(packet, &out)
	if err != nil {
		return err
	}
	if out["t"].(int8) == 3 {
		parseEvent(packet)
	} else if out["t"].(int8) == 4 {
		parseMetrics(packet)
	} else {
		return fmt.Errorf("Received an invalid mspPack message\n")
	}
	return nil
}

func SendSetting(setting *proto.Setting) {
	b, err := msgpack.Marshal(&ParameterMsgPack{T: 2, Ps: []map[string]int{{setting.SmallName: int(setting.GetValue())}}})
	if err != nil {
		log.Printf("Error while sending new settings: %v\n", err)
	}
	// Send the length of the payload
	length := make([]byte, 2)
	binary.LittleEndian.PutUint16(length, uint16(len(b)))
	manager.ToSend <- length
	// Send the payload
	manager.ToSend <- b
}

func SendCommand(action *proto.Action) {
	c := CommandMsgPack{T: 1, Name: action.Name, Arg: action.Payload}
	b, err := c.MarshalMsg(nil)
	if err != nil {
		log.Printf("Error while sending new settings: %v\n", err)
	}
	// Send the length of the payload
	length := make([]byte, 2)
	binary.LittleEndian.PutUint16(length, uint16(len(b)))
	manager.ToSend <- length
	// Send the payload
	manager.ToSend <- b
}

func parseEvent(packet []byte) {
	var event EventMsgPack
	event.UnmarshalMsg(packet)
	// Turn into an event and Send to a channel - TODO
}

func parseMetrics(packet []byte) {
	var metrics MetricsMsgPack
	_, err := metrics.UnmarshalMsg(packet)
	if err != nil {
		log.Printf("Error while unmarshalling msgpack: %v", err)
		return
	}

	var updates []*proto.MetricUpdate
	for _, v := range metrics.Ms {
		for k, v := range v {
			metric := &proto.MetricUpdate{}
			metric.Name = config.GetMetricName(k)
			metric.Target = float64(config.GetTarget(metric.Name))
			metric.Value = float64(v)
			updates = append(updates, metric)
		}
	}
	// Send the received metrics to the UI
	manager.gRPCChan <- &proto.MetricUpdates{Updates: updates}
	// Send the received metrics to the serial output
	MetricManager.Send(&proto.MetricUpdates{Updates: updates})
}
