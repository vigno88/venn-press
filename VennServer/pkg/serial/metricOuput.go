package serial

import (
	"fmt"
	"log"
	"time"

	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
	"go.bug.st/serial"
)

type MetricOutput struct {
	Port        serial.Port
	ToSend      chan proto.MetricUpdates
	IsActive    bool
	CurrentTime time.Duration
}

var MetricManager MetricOutput

func (o *MetricOutput) Init() error {
	p, err := o.openPort()
	if err != nil {
		return err
	}
	MetricManager = MetricOutput{
		Port:     p,
		ToSend:   make(chan proto.MetricUpdates),
		IsActive: false,
	}
	return nil
}

func (m *MetricOutput) openPort() (serial.Port, error) {
	mode := &serial.Mode{
		BaudRate: 115200,
	}
	port, err := serial.Open("/dev/ttyAMA4", mode)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	log.Printf("Serial port output metrics opened\n")
	return port, nil
}

func (m *MetricOutput) Run() {
	for range time.Tick(100 * time.Millisecond) {
		select {
		case request := <-m.ToSend:
			if m.IsActive {
				_, err := m.Port.Write([]byte(m.getPackage(&request)))
				log.Printf("Print %s to the serial port\n", request)
				if err != nil {
					log.Printf("Error writing port: %v", err)
					return
				}
			}
		}
		m.CurrentTime += 100 * time.Millisecond
	}
}

func (m *MetricOutput) Start() {
	m.IsActive = true
	m.CurrentTime = 0
	// Reset the channel
	m.ToSend = make(chan proto.MetricUpdates)
	m.Port.Write([]byte("Pressure test\n"))
	m.Port.Write([]byte("Time(s),Distance(mm),Weight(kg),TemperatureTop(c),TemperatureBottom(c)\n"))
}

func (m *MetricOutput) Stop() {
	m.IsActive = false
}

func (m *MetricOutput) Send(ms *proto.MetricUpdates) {
	m.ToSend <- *ms
}

func (m *MetricOutput) getPackage(ms *proto.MetricUpdates) []byte {
	var distance float32
	var weight float32
	var temperatureTop float32
	var TemperatureBottom float32
	for _, u := range ms.Updates {
		if u.Name == "Plates" {
			distance = float32(u.Value)
		} else if u.Name == "Load Cell" {
			weight = float32(u.Value)
		} else if u.Name == "Top" {
			temperatureTop = float32(u.Value)
		} else if u.Name == "Bottom" {
			TemperatureBottom = float32(u.Value)
		}
	}
	return []byte(fmt.Sprintf("%f,%f,%f,%f,%f\n", m.CurrentTime.Seconds(), distance, weight, temperatureTop, TemperatureBottom))
}
