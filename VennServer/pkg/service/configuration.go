// +build production

package service

import (
	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
)

type configurationServiceServer struct {
}

func NewConfigurationServiceServer() proto.ConfigurationServiceServer {
	return &configurationServiceServer{}
}
