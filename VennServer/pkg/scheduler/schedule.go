package action_scheduler

import (
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
	isActive bool
	index    int
	items    []ScheduleItem
	command  SendCommand
}

func (s *Schedule) init(i []ScheduleItem, c SendCommand) {
	s.index = 0
	s.items = i
	s.command = c
	if len(i) == 0 {
		s.isActive = false
	} else {
		s.isActive = true
		// Start the output to serial
		serial.MetricManager.Start()
	}
}

func (s *Schedule) stop() {
	s.isActive = false
	// Stop the output to serial
	serial.MetricManager.Stop()
}

func (s *Schedule) getTimeNextCommand() int {
	return s.items[s.index].time
}

func (s *Schedule) sendCommand() {
	s.command(s.items[s.index].requestedValue)
	if s.index == len(s.items)-1 {
		s.stop()
		return
	}
	s.index++
}
