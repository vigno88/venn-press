// +build production

package service

import (
	"context"
	"log"

	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
	motors "github.com/vigno88/venn-press/VennServer/pkg/motors"
	recipe "github.com/vigno88/venn-press/VennServer/pkg/recipes"
	"github.com/vigno88/venn-press/VennServer/pkg/serial"
	"github.com/vigno88/venn-press/VennServer/pkg/util"
)

// settingServiceServer is implementation of proto.settingServiceServer proto interface
type settingServiceServer struct {
}

func NewSettingServiceServer() proto.SettingServiceServer {
	return &settingServiceServer{}
}

// createRecipe asks the server to create a new recipe in the backend
func (s *settingServiceServer) CreateRecipe(ctx context.Context, e *proto.Empty) (*proto.Recipe, error) {
	r, err := recipe.ReadCurrentRecipe()
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
		return &proto.Recipe{}, err
	}
	newRecipe := recipe.ToProto(r)
	newRecipe.Uuid = util.GetNewUUID(ctx)
	recipe.SaveRecipe(recipe.ToRecipe(newRecipe))
	return newRecipe, nil
}

// getRecipe gets a single recipe from the backend
func (s *settingServiceServer) ReadRecipe(ctx context.Context, uuid *proto.StringValue) (*proto.Recipe, error) {
	r, err := recipe.ReadRecipe(uuid.GetValue())
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", uuid.GetValue(), err.Error())
		return &proto.Recipe{}, err
	}
	return recipe.ToProto(r), nil
}

func (s *settingServiceServer) ReadCurrentRecipe(ctx context.Context, e *proto.Empty) (*proto.Recipe, error) {
	r, err := recipe.ReadCurrentRecipe()
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
		return nil, err
	}
	// Get the static recipe
	staticR, err := recipe.ReadRecipe("static")
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", "static", err.Error())
		return nil, err
	}
	r.Join(staticR)
	return recipe.ToProto(r), nil
}

// selectRecipe tells the backend what is the active recipe
func (s *settingServiceServer) UpdateCurrentRecipe(ctx context.Context, uuid *proto.StringValue) (*proto.Empty, error) {
	return &proto.Empty{}, recipe.UpdateCurrentRecipe(uuid.GetValue())
}
func (s *settingServiceServer) UpdateSetting(ctx context.Context, u *proto.SettingUpdate) (*proto.Empty, error) {
	r, err := getCurrentRecipe(u.IsStatic)
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
		return &proto.Empty{}, err
	}
	index := r.GetIndexSetting(u.Name)
	r.Settings[index].Value = u.Value
	switch r.Settings[index].Destination {
	case proto.Destination_NONE:
		break
	case proto.Destination_MICROCONTROLLER:
		serial.SendSetting(r.Settings[index])
		break
	case proto.Destination_MOTOR:
		motors.ProcessNewSetting(r.Settings[index], int(u.Value))
		break
	}
	return &proto.Empty{}, recipe.UpdateRecipe(r)
}

func (s *settingServiceServer) UpdateUncertainty(ctx context.Context, u *proto.TargetUpdate) (*proto.Empty, error) {
	r, err := getCurrentRecipe(u.IsStatic)
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
		return &proto.Empty{}, err
	}
	index := r.GetIndexSetting(u.Name)
	r.Settings[index].Target.Uncertainty = u.GetValue()
	return &proto.Empty{}, recipe.UpdateRecipe(r)
}

func (s *settingServiceServer) UpdateSelectedChoice(ctx context.Context, u *proto.SelectorUpdate) (*proto.Empty, error) {
	r, err := getCurrentRecipe(u.IsStatic)
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
		return &proto.Empty{}, err
	}
	var choice string
	index := r.GetIndexSelector(u.Name)
	for _, v := range r.Selectors[index].PossibleChoices {
		if v == u.ChoiceName {
			choice = v
			break
		}
	}
	r.Selectors[index].Choice = choice
	return &proto.Empty{}, recipe.UpdateRecipe(r)
}

func (s *settingServiceServer) UpdateChoice(ctx context.Context, u *proto.ChoiceUpdate) (*proto.Empty, error) {
	r, err := getCurrentRecipe(u.IsStatic)
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
		return &proto.Empty{}, err
	}
	index := r.GetIndexSelector(u.NameSelector)
	for i, v := range r.Selectors[index].PossibleChoices {
		if v == u.NewChoice {
			// Update the possible choice
			r.Selectors[index].PossibleChoices[i] = u.NewChoice
			// Update the selected choice if it is also the one
			if r.Selectors[index].Choice == u.NewChoice {
				r.Selectors[index].Choice = u.NewChoice
			}
			break
		}
	}
	return &proto.Empty{}, recipe.UpdateRecipe(r)
}

func (s *settingServiceServer) UpdateGraphSettings(ctx context.Context, u *proto.GraphUpdate) (*proto.Empty, error) {
	r, err := getCurrentRecipe(u.IsStatic)
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
		return &proto.Empty{}, err
	}
	index := r.GetIndexGraph(u.Name)
	r.Graphs[index].Points = u.NewPoints
	return &proto.Empty{}, recipe.UpdateRecipe(r)
}

func (s *settingServiceServer) ReadRecipesUUID(ctx context.Context, e *proto.Empty) (*proto.UUIDS, error) {
	recipes, err := recipe.ReadAllRecipes()
	if err != nil {
		log.Printf("Error while reading all recipes: %s", err.Error())
		return nil, err
	}
	uuids := []string{}
	for _, r := range recipes {
		uuids = append(uuids, r.UUID)
	}
	return &proto.UUIDS{Uuids: uuids}, nil
}

func (s *settingServiceServer) UpdateRecipe(ctx context.Context, u *proto.Recipe) (*proto.Empty, error) {
	// It is only possible to modify the current recipe from the ui
	r, err := getCurrentRecipe(false)
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
		return &proto.Empty{}, err
	}
	// Update the current recipe with the attributes of the new recipe
	newR := recipe.ToRecipe(u)
	r.Info = newR.Info
	r.Name = newR.Name
	r.Selectors = newR.Selectors
	r.Settings = newR.Settings
	return &proto.Empty{}, recipe.UpdateRecipe(r)
}

func (s *settingServiceServer) DeleteRecipe(ctx context.Context, uuid *proto.StringValue) (*proto.Empty, error) {
	r, err := recipe.ReadRecipe(uuid.Value)
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
		return &proto.Empty{}, err
	}
	err = recipe.DeleteRecipe(r)
	return &proto.Empty{}, err
}

func (s *settingServiceServer) ReadSelectorList(ctx context.Context, e *proto.Empty) (*proto.Selectors, error) {
	r, err := getCurrentRecipe(false)
	if err != nil {
		log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
		return nil, err
	}
	p := recipe.ToProto(r)
	return &proto.Selectors{Selectors: p.Selectors}, nil
}

func getCurrentRecipe(isStatic bool) (*recipe.Recipe, error) {
	var r *recipe.Recipe
	var err error
	// Look if the setting is from the static recipe
	if isStatic {
		r, err = recipe.ReadRecipe(`static`)
		if err != nil {
			return nil, err
		}
	} else {
		r, err = recipe.ReadCurrentRecipe()
		if err != nil {
			log.Printf("Error while reading this recipe %s: %s ", r.Name, err.Error())
			return nil, err
		}
	}
	return r, err
}
