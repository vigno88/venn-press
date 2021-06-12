package config

import (
	proto "github.com/vigno88/Venn/VennServer/pkg/api/v1"
	"github.com/vigno88/Venn/VennServer/pkg/control"
	"github.com/vigno88/Venn/VennServer/pkg/metrics"
	recipe "github.com/vigno88/Venn/VennServer/pkg/recipes"
)

func GetMetricName(smallName string) string {
	for _, v := range GetDefaultConfig().Metrics {
		if v.SmallName == smallName {
			return v.Name
		}
	}
	return ""
}

func GetTarget(name string) float32 {
	for _, v := range GetDefaultConfig().Metrics {
		if v.Name == name {
			return v.Target
		}
	}
	return 0
}

type ReadableConfig struct {
	DefaultRecipe recipe.Recipe
	StaticRecipe  recipe.Recipe
	Metrics       []metrics.Metric
	Controls      []control.Config
}

// This function is to be a human readable config
func GetDefaultConfig() *ReadableConfig {

	// Static settings
	pTopPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0,
		Max:         1000,
		Min:         -1000,
		Name:        "P Constant Top",
		SmallName:   "pTop",
		Info:        "Proportional constant of the PID of the top hot plate",
		IsStatic:    true,
	}
	iTopPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0,
		Max:         1000,
		Min:         -1000,
		Name:        "I Constant Top",
		SmallName:   "iTop",
		Info:        "Integral constant of the PID of the top hot plate",
		IsStatic:    true,
	}
	dTopPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0,
		Max:         1000,
		Min:         -1000,
		Name:        "D Constant Top",
		SmallName:   "dTop",
		Info:        "Derivative constant of the PID of the top hot plate",
		IsStatic:    true,
	}
	pBottomPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0,
		Max:         1000,
		Min:         -1000,
		Name:        "P Constant Bottom",
		SmallName:   "pBot",
		Info:        "Proportional constant of the PID of the bottom hot plate",
		IsStatic:    true,
	}
	iBottomPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0,
		Max:         1000,
		Min:         -1000,
		Name:        "I Constant Bottom",
		SmallName:   "iBot",
		Info:        "Integral constant of the PID of the bottom hot plate",
		IsStatic:    true,
	}
	dBottomPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0,
		Max:         1000,
		Min:         -1000,
		Name:        "D Constant Bottom",
		SmallName:   "dBot",
		Info:        "Derivative constant of the PID of the bottom hot plate",
		IsStatic:    true,
	}

	return &ReadableConfig{
		DefaultRecipe: recipe.Recipe{
			UUID:      "",
			Name:      "Default",
			Info:      "This is the default recipe from config.",
			Selectors: []*proto.Selector{},
			Settings:  []*proto.Setting{},
			Graphs: []*proto.GraphSettings{
				{Name: "Weight", UnitVerticalAxis: "kg", UnitHorizontalAxis: "s", VerticalAxis: "Weight", HorizontalAxis: "Time", Points: []*proto.Point{}, IsStatic: false},
				{Name: "Temperature", UnitVerticalAxis: "°c", UnitHorizontalAxis: "s", VerticalAxis: "Temperature", HorizontalAxis: "Time", Points: []*proto.Point{}, IsStatic: false},
			},
		},
		StaticRecipe: recipe.Recipe{
			UUID: "static",
			Name: "static",
			Info: "",
			Settings: []*proto.Setting{
				pTopPlate, iTopPlate, dTopPlate, pBottomPlate, iBottomPlate, dBottomPlate,
			},
		},
		Metrics: []metrics.Metric{
			{
				Name:      "Plates",
				Unit:      "mm",
				Type:      "Distance",
				SmallName: "d",
				Info:      "Distance vertical parcourue depuis derniere mise a zero.",
				HasTarget: false,
				Value:     0,
			},
			{
				Name:      "Load Cell",
				Unit:      "kg",
				Type:      "Weight",
				SmallName: "w",
				Info:      "Poids vertical entre les 2 plaques.",
				HasTarget: false,
				Value:     0,
			},
			{
				Name:      "Top",
				Unit:      "°c",
				Type:      "Temperature",
				SmallName: "tT",
				Info:      "Temperature de la plaque du haut.",
				HasTarget: false,
				Value:     0,
			},
			{
				Name:      "Bottom",
				Unit:      "°c",
				Type:      "Temperature",
				SmallName: "tB",
				Info:      "Temperature de la plaque du bas.",
				HasTarget: false,
				Value:     0,
			},
		},
		Controls: []control.Config{
			{
				// Id:                 `motion-up`,
				Title:              `Motion`,
				Type:               int(proto.ControlConfig_ICON_BUTTON),
				IconType:           "up_arrow",
				ActionName:         "motor",
				StateActionPayload: []string{"mUp", "mStop"},
			},
			{
				// Id:                 `motion-down`,
				Title:              `Motion`,
				Type:               int(proto.ControlConfig_ICON_BUTTON),
				IconType:           "down_arrow",
				ActionName:         "motor",
				StateActionPayload: []string{"mDown", "mStop"},
			},
			{
				// Id:                 `test`,
				Title:              `Test`,
				Type:               int(proto.ControlConfig_TWO_STATE_BUTTON),
				StateText:          []string{"Start", "Stop"},
				ActionName:         "test",
				StateActionPayload: []string{"start", "stop"},
			},
			{
				// Id:                 `home`,
				Title:              `Homing`,
				Type:               int(proto.ControlConfig_SINGLE_STATE_BUTTON),
				StateText:          []string{"Home"},
				ActionName:         "home",
				StateActionPayload: []string{"start"},
			},
			{
				// Id:                 `weight-tare`,
				Title:              `Weight`,
				Type:               int(proto.ControlConfig_SINGLE_STATE_BUTTON),
				StateText:          []string{"Tare"},
				ActionName:         "weight",
				StateActionPayload: []string{"tare"},
			},
			{
				// Id:                 `distance-tare`,
				Title:              `Distance`,
				Type:               int(proto.ControlConfig_SINGLE_STATE_BUTTON),
				StateText:          []string{"Tare"},
				ActionName:         "distance",
				StateActionPayload: []string{"tare"},
			},
		},
	}
}
