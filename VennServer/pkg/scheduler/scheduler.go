package action_scheduler

import (
	"log"
	"time"

	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
	"github.com/vigno88/venn-press/VennServer/pkg/control"
	recipe "github.com/vigno88/venn-press/VennServer/pkg/recipes"
	"github.com/vigno88/venn-press/VennServer/pkg/serial"
)

var heatingSchedule Schedule
var pressureSchedule Schedule
var currentTime int
var isActive bool

func Init() {
	heatingSchedule = Schedule{isActive: false}
	pressureSchedule = Schedule{isActive: false}
}

func Stop() {
	heatingSchedule.isActive = false
	pressureSchedule.isActive = false

	// Stop weight controller
	a := proto.Action{Name: "setW", Payload: "so"}
	serial.SendCommand(&a)
	// Stop temp PID
	a = proto.Action{Name: "setT", Payload: "so"}
	serial.SendCommand(&a)
	isActive = false
	// Stop the output to serial
	serial.MetricManager.Stop()
}

func Start() {
	// Get the points
	r, err := recipe.ReadCurrentRecipe()
	if err != nil {
		log.Printf("Error in the command scheduler: %v", err)
	}
	var hItems []ScheduleItem
	var pItems []ScheduleItem
	for _, g := range r.Graphs {
		if g.Name == "Weight" {
			for _, s := range g.Points {
				pItems = append(pItems, ScheduleItem{int(s.X), s.Y})
			}
		} else if g.Name == "Temperature" {
			for _, s := range g.Points {
				hItems = append(hItems, ScheduleItem{int(s.X), s.Y})
			}
		}
	}

	heatingSchedule.init(hItems, "setT")
	pressureSchedule.init(pItems, "setW")
	// Start weight controller
	a := proto.Action{Name: "setW", Payload: "st"}
	serial.SendCommand(&a)
	// Start temp PID
	a = proto.Action{Name: "setT", Payload: "st"}
	serial.SendCommand(&a)
	currentTime = 0
	isActive = true
	// Start the output to serial
	serial.MetricManager.Start()
}

func Run() {
	ticker := time.NewTicker(time.Second)
	for {
		select {
		case <-ticker.C:
			if heatingSchedule.isActive && heatingSchedule.getTimeNextCommand() == currentTime {
				heatingSchedule.sendCommand()
			}
			if pressureSchedule.isActive && pressureSchedule.getTimeNextCommand() == currentTime {
				pressureSchedule.sendCommand()
			}
			if !pressureSchedule.isActive && !heatingSchedule.isActive && isActive {
				Stop()
				control.SendEvent(&proto.ControlEvent{Name: "test", Payload: "stop"})
			}
			currentTime++
		}
	}
}
