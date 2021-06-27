package control

import (
	"context"
	"log"

	"github.com/asdine/storm/v3"
	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
)

// var pathDB string
var db storm.DB

type Config struct {
	Id                 int `storm:"id,increment"`
	Title              string
	Type               int
	StateText          []string
	ActionName         string
	StateActionPayload []string
	IconType           string
}

func ToProto(c *Config) *proto.ControlConfig {
	return &proto.ControlConfig{
		Title:              c.Title,
		Type:               proto.ControlConfig_ControlType(c.Type),
		StateText:          c.StateText,
		StateActionPayload: c.StateActionPayload,
		ActionName:         c.ActionName,
		IconType:           c.IconType,
	}
}

func ToConfig(c *proto.ControlConfig) *Config {
	return &Config{
		Title:              c.Title,
		Type:               int(c.Type),
		StateText:          c.StateText,
		StateActionPayload: c.StateActionPayload,
		ActionName:         c.ActionName,
		IconType:           c.IconType,
	}
}

// Init open the control config store at the specified path, the store is used to store
// the control configuration
func Init(ctx context.Context, path string) error {
	log.Printf("Initiating the control config store at %s\n", path)
	// pathDB = path
	newDb, err := storm.Open(path)
	db = *newDb
	if err != nil {
		return err
	}
	// defer db.Close()
	return err
}

func Create(m *Config) error {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return err
	// }
	// defer db.Close()
	err := db.Save(m)
	if err == storm.ErrAlreadyExists {
		return db.Update(m)
	}
	return err
}

func Update(m *Config) error {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return err
	// }
	// defer db.Close()
	err := db.Save(m)
	if err == storm.ErrAlreadyExists {
		return db.Update(m)
	}
	return err
}

func Read(name string) (*Config, error) {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return nil, err
	// }
	// defer db.Close()
	var m Config
	err := db.One("Id", name, &m)
	return &m, err

}

// Not implemented for now
func Delete(name string) *Config {
	return nil
}

func ReadAll() ([]Config, error) {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return nil, err
	// }
	// defer db.Close()
	var metrics []Config
	err := db.All(&metrics)
	return metrics, err
}
