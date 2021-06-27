// +build production

package orchestrator

import (
	"context"
	"log"
	"os"

	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
	authentifaction "github.com/vigno88/venn-press/VennServer/pkg/authentification"
	"github.com/vigno88/venn-press/VennServer/pkg/control"
	metrics "github.com/vigno88/venn-press/VennServer/pkg/metrics"
	recipes "github.com/vigno88/venn-press/VennServer/pkg/recipes"
	action_scheduler "github.com/vigno88/venn-press/VennServer/pkg/scheduler"
	"github.com/vigno88/venn-press/VennServer/pkg/serial"
	"github.com/vigno88/venn-press/VennServer/pkg/util"
	"github.com/vigno88/venn-press/VennServer/pkg/wifi"
)

func Run(ctx context.Context, c chan *proto.MetricUpdates) {
	// Verify validity software
	// err := validate(util.PathKey)
	// if err != nil {
	// 	log.Fatalf(err.Error())
	// }
	// Initialize all the modules
	err := authentifaction.Init(ctx, util.PathAuth)
	handle(err)
	err = serial.Init(ctx, c)
	handle(err)
	err = metrics.Init(ctx, util.PathMetric)
	handle(err)
	err = wifi.Init(ctx, util.PathWifi)
	handle(err)
	err = control.Init(ctx, util.PathControl)
	handle(err)
	// err = motors.Init()
	handle(err)
	action_scheduler.Init()
	serial.MetricManager.Init()

	exit := make(chan string)
	go serial.Run(ctx, exit)
	go wifi.Run()
	go action_scheduler.Run()
	go serial.MetricManager.Run()
	// go motors.Run()
	err = recipes.Init(ctx, util.PathRecipe)
	handle(err)
	log.Printf("Orchestrator is running..\n")
	for {
		select {
		case <-exit:
			os.Exit(0)
		}
	}
}

func handle(err error) {
	if err != nil {
		log.Printf("%v", err)
		os.Exit(0)
	}
}
