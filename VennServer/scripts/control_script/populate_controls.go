package main

import (
	"context"
	"log"

	config "github.com/vigno88/venn-press/VennServer/configs"
	"github.com/vigno88/venn-press/VennServer/pkg/control"
	"github.com/vigno88/venn-press/VennServer/pkg/util"
)

func main() {
	err := control.Init(context.Background(), util.PathControl)
	if err != nil {
		log.Printf("Error while init control store: %s\n", err.Error())
	}
	c := config.GetDefaultConfig()
	// Add all the metrics from the config in the metric store
	for _, v := range c.Controls {
		err := control.Create(&v)
		if err != nil {
			log.Fatalf("Error while adding control: %s\n", err.Error())
		}

	}
	log.Println("Default control setup done")
}
