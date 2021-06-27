package recipe

import (
	"context"
	"log"
	"strconv"

	"github.com/asdine/storm/v3"
	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
)

// var defaultRecipe *proto.Recipe
// var pathDB string
var db storm.DB

var currentRecipe *Recipe

const currentKey = "current"
const keyValueName = "recipe"

type Recipe struct {
	Id        int `storm:"id,increment"`
	UUID      string
	Name      string
	Info      string
	Selectors []*proto.Selector
	Settings  []*proto.Setting
	Graphs    []*proto.GraphSettings
}

func (r *Recipe) GetIndexSelector(name string) int {
	for i, s := range r.Selectors {
		if s.Name == name {
			return i
		}
	}
	return 0
}

func (r *Recipe) GetIndexSetting(name string) int {
	for i, s := range r.Settings {
		if s.Name == name {
			return i
		}
	}
	return 0
}

func (r *Recipe) GetIndexGraph(name string) int {
	for i, g := range r.Graphs {
		if g.Name == name {
			return i
		}
	}
	return 0
}

// Init opens the badgerDB
func Init(ctx context.Context, path string) error {
	// pathDB = path
	log.Printf("Initiating recipes store at %s", path)
	newDB, err := storm.Open(path)
	if err != nil {
		return err
	}
	db = *newDB
	// db.Close()
	return err
}

func ToRecipe(r *proto.Recipe) *Recipe {
	return &Recipe{
		UUID:      r.Uuid,
		Name:      r.Title,
		Info:      r.Info,
		Selectors: r.Selectors,
		Settings:  r.Settings,
		Graphs:    r.Graphs,
	}
}

func ToProto(r *Recipe) *proto.Recipe {
	return &proto.Recipe{
		Uuid:      r.UUID,
		Title:     r.Name,
		Info:      r.Info,
		Settings:  r.Settings,
		Selectors: r.Selectors,
		Graphs:    r.Graphs,
	}
}

func ReadCurrentRecipeUUID() (string, error) {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return "", err
	// }
	// defer db.Close()
	var uuid string
	err := db.Get(keyValueName, currentKey, &uuid)
	if err != nil {
		return "", err
	}
	return uuid, nil
}

func ReadCurrentRecipe() (*Recipe, error) {
	if currentRecipe == nil {
		uuid, err := ReadCurrentRecipeUUID()
		if err != nil {
			return nil, err
		}
		currentRecipe, err = ReadRecipe(uuid)
	}
	return currentRecipe, nil
}

func UpdateCurrentRecipe(uuid string) error {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return err
	// }
	// defer db.Close()
	// Update key of the current recipe
	err := db.Set(keyValueName, currentKey, uuid)
	if err != nil {
		return err
	}
	currentRecipe, err = ReadRecipe(uuid)
	return err
}

func ReadRecipe(uuid string) (*Recipe, error) {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return nil, err
	// }
	// defer db.Close()
	// Get the recipe struct
	recipe := &Recipe{}
	err := db.One("UUID", uuid, recipe)
	if err != nil {
		return nil, err
	}
	return recipe, nil
}

func UpdateRecipe(r *Recipe) error {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return err
	// }
	// defer db.Close()
	err := db.Update(r)
	return err
}

func ReadAllRecipes() ([]Recipe, error) {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return nil, err
	// }
	// defer db.Close()
	var recipes []Recipe
	err := db.All(&recipes)
	return recipes, err
}

func SaveRecipe(r *Recipe) error {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return err
	// }
	// defer db.Close()
	err := db.Save(r)
	return err
}

func DeleteRecipe(r *Recipe) error {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return err
	// }
	// defer db.Close()
	err := db.DeleteStruct(r)
	return err
}

func recipeToString(r *proto.Recipe) []string {
	var settings []string
	for _, s := range r.Settings {
		str := "p#"
		str += s.GetName()
		str += "#"
		str += strconv.FormatFloat(s.GetValue(), 'f', 10, 64)
		settings = append(settings, str)
	}
	return settings
}

func (r *Recipe) Join(new *Recipe) {
	for _, s := range new.Settings {
		r.Settings = append(r.Settings, s)
	}
	for _, s := range new.Selectors {
		r.Selectors = append(r.Selectors, s)
	}
	for _, g := range new.Graphs {
		r.Graphs = append(r.Graphs, g)
	}
}
