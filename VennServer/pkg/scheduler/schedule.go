package action_scheduler

import (
	"fmt"

	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
	"github.com/vigno88/venn-press/VennServer/pkg/serial"
)

type SendCommand func(float64)
type ScheduleItem struct {
	// time in seconds
	time           int
	requestedValue float64
}

// The schedule is used to tell
type Schedule struct {
	isActive   bool
	index      int
	items      []ScheduleItem
	actionName string
	// command  SendCommand
}

func (s *Schedule) init(i []ScheduleItem, n string) {
	s.index = 0
	s.items = i
	s.actionName = n
	// s.command = c
	if len(i) == 0 {
		s.isActive = false
	} else {
		s.isActive = true
	}
}

func (s *Schedule) stop() {
	s.isActive = false
	a := proto.Action{Name: s.actionName, Payload: "so"}
	serial.SendCommand(&a)
}

func (s *Schedule) getTimeNextCommand() int {
	return s.items[s.index].time
}

func (s *Schedule) sendCommand() {
	a := proto.Action{Name: s.actionName, Payload: fmt.Sprintf("%f", s.items[s.index].requestedValue)}
	serial.SendCommand(&a)
	if s.index == len(s.items)-1 {
		s.stop()
		return
	}
	s.index++
}
