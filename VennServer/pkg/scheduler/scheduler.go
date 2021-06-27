package action_scheduler

import (
	"fmt"
	"log"
	"time"

	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
	recipe "github.com/vigno88/venn-press/VennServer/pkg/recipes"
	"github.com/vigno88/venn-press/VennServer/pkg/serial"
)

var heatingSchedule Schedule
var pressureSchedule Schedule
var currentTime int

func Init() {
	heatingSchedule = Schedule{isActive: false}
	pressureSchedule = Schedule{isActive: false}
}

func Stop() {
	heatingSchedule.isActive = false
	pressureSchedule.isActive = false

	// Stop weight
	a := proto.Action{Name: "setW", Payload: "s"}
	serial.SendCommand(&a)
	// Stop temp
	// TODO
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

	heatingSchedule.init(hItems, setTemperature)
	pressureSchedule.init(pItems, setWeight)
	currentTime = 0
}

func Run() {
	for range time.Tick(time.Second) {
		if heatingSchedule.isActive && heatingSchedule.getTimeNextCommand() == currentTime {
			heatingSchedule.sendCommand()
		}
		if pressureSchedule.isActive && pressureSchedule.getTimeNextCommand() == currentTime {
			pressureSchedule.sendCommand()
		}
		currentTime++
	}
}

func setTemperature(t float64) {
	a := proto.Action{Name: "setT", Payload: fmt.Sprintf("%f", t)}
	serial.SendCommand(&a)
}

func setWeight(t float64) {
	a := proto.Action{Name: "setW", Payload: fmt.Sprintf("%f", t)}
	serial.SendCommand(&a)
}
