package metrics

import (
	"context"
	// "fmt"
	"log"

	"github.com/asdine/storm/v3"
	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
)

// var pathDB string
var db storm.DB

// var bucketName string

type Metric struct {
	Id        int `storm:"id,increment"`
	Name      string
	SmallName string
	Unit      string
	Target    float32
	Type      string
	Info      string
	HasTarget bool
	Value     float64
}

func ToProto(m *Metric) *proto.MetricConfig {
	return &proto.MetricConfig{
		Unit:      m.Unit,
		Target:    m.Target,
		Type:      m.Type,
		Name:      m.Name,
		SmallName: m.SmallName,
		Info:      m.Info,
		HasTarget: m.HasTarget,
	}
}

func ToMetric(m *proto.MetricConfig) *Metric {
	return &Metric{
		Name:      m.Name,
		SmallName: m.SmallName,
		Unit:      m.Unit,
		Target:    m.Target,
		Type:      m.Type,
		Info:      m.Info,
		HasTarget: m.HasTarget,
	}
}

// Init open the metric store at the specified path, the store is used to store
// the metric configuration as well as the most recent metrics
func Init(ctx context.Context, path string) error {
	log.Printf("Initiating the metrics store at %s\n", path)
	// pathDB = path
	newDb, err := storm.Open(path)
	if err != nil {
		return err
	}
	db = *newDb
	// defer db.Close()
	// err = db.Init(&Metric{})
	return err
}

func Create(m *Metric) error {
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

func Update(m *Metric) error {
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

func Read(name string) (*Metric, error) {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return nil, err
	// }
	// defer db.Close()
	var m Metric
	err := db.One("Name", name, &m)
	return &m, err

}

// Not implemented for now
func Delete(name string) *Metric {
	return nil
}

func ReadAll() ([]Metric, error) {
	// db, err := storm.Open(pathDB)
	// if err != nil {
	// 	return nil, err
	// }
	// defer db.Close()
	var metrics []Metric
	err := db.All(&metrics)
	return metrics, err
}
