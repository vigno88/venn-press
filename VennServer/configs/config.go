package config

import (
	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
	"github.com/vigno88/venn-press/VennServer/pkg/control"
	"github.com/vigno88/venn-press/VennServer/pkg/metrics"
	recipe "github.com/vigno88/venn-press/VennServer/pkg/recipes"
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

const (
	motorUp       = "mU"
	motorUpSlow   = "mUs"
	motorDown     = "mD"
	motorDownSlow = "mDs"
	motorStop     = "mS"
)

// This function is to be a human readable config
func GetDefaultConfig() *ReadableConfig {

	// Static settings
	pTopPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       4,
		Max:         1000,
		Min:         -1000,
		Name:        "P Constant Top",
		SmallName:   "pTop",
		Info:        "Proportional constant of the PID of the top hot plate",
		IsStatic:    true,
	}
	iTopPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0.2,
		Max:         1000,
		Min:         -1000,
		Name:        "I Constant Top",
		SmallName:   "iTop",
		Info:        "Integral constant of the PID of the top hot plate",
		IsStatic:    true,
	}
	dTopPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       1,
		Max:         1000,
		Min:         -1000,
		Name:        "D Constant Top",
		SmallName:   "dTop",
		Info:        "Derivative constant of the PID of the top hot plate",
		IsStatic:    true,
	}
	pBottomPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       4,
		Max:         1000,
		Min:         -1000,
		Name:        "P Constant Bottom",
		SmallName:   "pBot",
		Info:        "Proportional constant of the PID of the bottom hot plate",
		IsStatic:    true,
	}
	iBottomPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       0.2,
		Max:         1000,
		Min:         -1000,
		Name:        "I Constant Bottom",
		SmallName:   "iBot",
		Info:        "Integral constant of the PID of the bottom hot plate",
		IsStatic:    true,
	}
	dBottomPlate := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       1,
		Max:         1000,
		Min:         -1000,
		Name:        "D Constant Bottom",
		SmallName:   "dBot",
		Info:        "Derivative constant of the PID of the bottom hot plate",
		IsStatic:    false,
	}

	// hardnessParam := &proto.Setting{
	// 	Destination: proto.Destination_MICROCONTROLLER,
	// 	Value:       0.7,
	// 	Max:         1,
	// 	Min:         0,
	// 	Name:        "Hardness Constant",
	// 	SmallName:   "hC",
	// 	Info:        "Hardness Constant is used for the calibration of the force put on objects when loading weight.",
	// 	IsStatic:    false,
	// }

	loadFactor := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       13550,
		Max:         100000,
		Min:         -100000,
		Name:        "Load Cell Factor",
		SmallName:   "lcF",
		Info:        "Load Cell Factor is used to calibrate the load cell.",
		IsStatic:    false,
	}

	pMotor := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       1,
		Max:         1000,
		Min:         -1000,
		Name:        "P Constant Motor",
		SmallName:   "pM",
		Info:        "Proportional constant of the PID of the motor controller.",
		IsStatic:    false,
	}

	iMotor := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       1,
		Max:         1000,
		Min:         -1000,
		Name:        "I Constant Motor",
		SmallName:   "iM",
		Info:        "Integral constant of the PID of the motor controller.",
		IsStatic:    false,
	}

	dMotor := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       1,
		Max:         1000,
		Min:         -1000,
		Name:        "D Constant Motor",
		SmallName:   "dM",
		Info:        "Derivative constant of the PID of the motor controller.",
		IsStatic:    false,
	}

	stepMult := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       1,
		Max:         100,
		Min:         0,
		Name:        "Step Multiplier",
		SmallName:   "sMu",
		Info:        "Multiply the output of the PID with this value",
		IsStatic:    false,
	}

	pidST := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       100,
		Max:         10000,
		Min:         0,
		Name:        "PID Sample Time (ms)",
		SmallName:   "pidST",
		Info:        "Sample time in milliseconds of the PID",
		IsStatic:    false,
	}

	maxLoad := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       900,
		Max:         10000,
		Min:         0,
		Name:        "Max load (kg) - Safety",
		SmallName:   "mL",
		Info:        "Maximum Load possible that can be applied to the load cell",
		IsStatic:    false,
	}

	delaySlow := &proto.Setting{
		Destination: proto.Destination_MICROCONTROLLER,
		Value:       150,
		Max:         5000,
		Min:         50,
		Name:        "Delay Step Slow Move",
		SmallName:   "dS",
		Info:        "Delay in ms between each step in the slow move action.",
		IsStatic:    false,
	}

	return &ReadableConfig{
		DefaultRecipe: recipe.Recipe{
			UUID:      "",
			Name:      "Default",
			Info:      "This is the default recipe from config.",
			Selectors: []*proto.Selector{},
			Settings: []*proto.Setting{
				loadFactor, pMotor, iMotor, dMotor, stepMult, pidST, maxLoad, delaySlow,
			},
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
				StateActionPayload: []string{motorUp, motorStop},
			},
			{
				// Id:                 `motion-down`,
				Title:              `Motion`,
				Type:               int(proto.ControlConfig_ICON_BUTTON),
				IconType:           "down_arrow",
				ActionName:         "motor",
				StateActionPayload: []string{motorDown, motorStop},
			},
			{
				// Id:                 `motion-up`,
				Title:              `Slow Motion`,
				Type:               int(proto.ControlConfig_ICON_BUTTON),
				IconType:           "up_arrow",
				ActionName:         "motor",
				StateActionPayload: []string{motorUpSlow, motorStop},
			},
			{
				// Id:                 `motion-down`,
				Title:              `Slow Motion`,
				Type:               int(proto.ControlConfig_ICON_BUTTON),
				IconType:           "down_arrow",
				ActionName:         "motor",
				StateActionPayload: []string{motorDownSlow, motorStop},
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
