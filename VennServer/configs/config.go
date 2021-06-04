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
	temp := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       20,
		Max:         95,
		Min:         20,
		Name:        "Temperature",
		Info:        "This slider controls the temperature of the water.",
		SmallName:   "t",
		Target:      &proto.Target{Name: "Water", Uncertainty: 2},
	}

	tm1 := &proto.Setting{
		Destination: proto.Destination_MOTOR,
		Value:       2000,
		Max:         5000,
		Min:         100,
		Name:        "Travel Masseur 1",
		SmallName:   "tm1",
		Info:        "This slider controls the travel distance of first module's masseur.",
	}
	tm2 := &proto.Setting{
		Destination: proto.Destination_MOTOR,
		Value:       2000,
		Max:         5000,
		Min:         100,
		Name:        "Travel Masseur 2",
		SmallName:   "tm2",
		Info:        "This slider controls the travel distance of second module's masseur.",
	}
	tm3 := &proto.Setting{
		Destination: proto.Destination_MOTOR,
		Value:       2000,
		Max:         5000,
		Min:         100,
		Name:        "Travel Masseur 3",
		SmallName:   "tm3",
		Info:        "This slider controls the travel distance of third module's masseur.",
	}
	dt1 := &proto.Setting{
		Destination: proto.Destination_MOTOR,
		Value:       10,
		Max:         200,
		Min:         5,
		Name:        "Divisor Traction 1",
		SmallName:   "dt1",
		Info:        "The speed of Traction 1 is the one of Masseur 1 divided by Divisor Traction 1",
	}
	dt2 := &proto.Setting{
		Destination: proto.Destination_MOTOR,
		Value:       10,
		Max:         200,
		Min:         5,
		Name:        "Divisor Traction 2",
		SmallName:   "dt2",
		Info:        "The speed of Traction 2 is the one of Masseur 2 divided by Divisor Traction 2",
	}
	dt3 := &proto.Setting{
		Destination: proto.Destination_MOTOR,
		Value:       10,
		Max:         200,
		Min:         5,
		Name:        "Divisor Traction 3",
		SmallName:   "dt3",
		Info:        "The speed of Traction 3 is the one of Masseur 3 divided by Divisor Traction 3",
	}
	pm1 := &proto.Setting{
		Destination: proto.Destination_NONE,
		Value:       0,
		Max:         100,
		Min:         0,
		Name:        "Pression Masseur 1",
		SmallName:   "pm1",
		Info:        "This slider records the pression of first module's masseur.",
	}

	pm2 := &proto.Setting{
		Destination: proto.Destination_NONE,
		Value:       0,
		Max:         100,
		Min:         0,
		Name:        "Pression Masseur 2",
		SmallName:   "pm2",
		Info:        "This slider records the pression of second module's masseur.",
	}
	pm3 := &proto.Setting{
		Destination: proto.Destination_NONE,
		Value:       0,
		Max:         100,
		Min:         0,
		Name:        "Pression Masseur 3",
		SmallName:   "pm3",
		Info:        "This slider records the pression of third module's masseur.",
	}
	pt1 := &proto.Setting{
		Destination: proto.Destination_NONE,
		Value:       0,
		Max:         100,
		Min:         0,
		Name:        "Pression Traction 1",
		SmallName:   "pt1",
		Info:        "This slider records the pression of first module's traction.",
	}

	pt2 := &proto.Setting{
		Destination: proto.Destination_NONE,
		Value:       0,
		Max:         100,
		Min:         0,
		Name:        "Pression Traction 2",
		SmallName:   "pt2",
		Info:        "This slider records the pression of second module's traction.",
	}
	pt3 := &proto.Setting{
		Destination: proto.Destination_NONE,
		Value:       0,
		Max:         100,
		Min:         0,
		Name:        "Pression Traction 3",
		SmallName:   "pt3",
		Info:        "This slider records the pression of third module's traction.",
	}

	// Static settings
	pTopPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0,
		Max:         1000,
		Min:         -1000,
		Name:        "PID - P - Top plate",
		SmallName:   "pTop",
		Info:        "Proportional constant of the PID of the top hot plate",
	}
	iTopPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0,
		Max:         1000,
		Min:         -1000,
		Name:        "PID - I - Top plate",
		SmallName:   "iTop",
		Info:        "Integral constant of the PID of the top hot plate",
	}
	dTopPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0,
		Max:         1000,
		Min:         -1000,
		Name:        "PID - D - Top plate",
		SmallName:   "dTop",
		Info:        "Derivative constant of the PID of the top hot plate",
	}

	return &ReadableConfig{
		DefaultRecipe: recipe.Recipe{
			UUID: "",
			Name: "Default",
			Info: "This is the default recipe from config.",
			Selectors: []*proto.Selector{
				{
					Name:   "Active Module Count",
					Choice: "three",
					PossibleChoices: []string{
						"one", "two", "three",
					},
				},
			},
			Settings: []*proto.Setting{
				temp,
				tm1,
				tm2,
				tm3,
				dt1,
				dt2,
				dt3,
				pm1,
				pm2,
				pm3,
				pt1,
				pt2,
				pt3,
			},
		},
		StaticRecipe: recipe.Recipe{
			UUID: "static",
			Name: "static",
			Info: "",
			Settings: []*proto.Setting{
				pTopPlate, iTopPlate, dTopPlate,
			},
		},
		Metrics: []metrics.Metric{
			{
				Name:      " ",
				Unit:      "mm",
				Type:      "Distance",
				SmallName: "d",
				Info:      "Distance vertical parcourue depuis derniere mise a zero.",
				HasTarget: false,
				Value:     0,
			},
			{
				Name:      "Plate",
				Unit:      "kg",
				Type:      "Weight",
				Info:      "Poids vertical entre les 2 plaques.",
				HasTarget: false,
				Value:     0,
			},
			{
				Name:      "Top",
				Unit:      "°c",
				Type:      "Temperature",
				Info:      "Temperature de la plaque du haut.",
				HasTarget: false,
				Value:     0,
			},
			{
				Name:      "Bottom",
				Unit:      "°c",
				Type:      "Temperature",
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
