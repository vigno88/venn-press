package main

import (
	"context"
	"log"

	config "github.com/vigno88/venn-press/VennServer/configs"
	recipe "github.com/vigno88/venn-press/VennServer/pkg/recipes"
	"github.com/vigno88/venn-press/VennServer/pkg/util"
)

func main() {
	c := config.GetDefaultConfig()
	// Add the default recipe to the recipe store
	// uuid := util.GetNewUUID(context.Background())
	uuid := `default`
	c.DefaultRecipe.UUID = `default`
	err := recipe.Init(context.Background(), util.PathRecipe)
	if err != nil {
		log.Fatalf("Error while init : %s\n", err.Error())
	}
	/// Save the default recipe
	err = recipe.SaveRecipe(&c.DefaultRecipe)
	if err != nil {
		log.Fatalf("Error while saving : %s\n", err.Error())
	}
	// Save the static recipe
	err = recipe.SaveRecipe(&c.StaticRecipe)
	if err != nil {
		log.Fatalf("Error while saving : %s\n", err.Error())
	}
	// Update the current recipe to be the recipe that has been saved
	err = recipe.UpdateCurrentRecipe(uuid)
	if err != nil {
		log.Fatalf("Error while updating : %s\n", err.Error())
	}
	log.Println("Default recipe setup done")
}
