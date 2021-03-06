// +build production

package service

import (
	"context"

	proto "github.com/vigno88/venn-press/VennServer/pkg/api/v1"
	// "github.com/vigno88/venn-press/VennServer/pkg/motors"
)

type motorControlServiceServer struct {
}

func MotorControlServiceServer() proto.MotorControlServiceServer {
	return &motorControlServiceServer{}
}

func (s *motorControlServiceServer) Home(ctx context.Context, e *proto.Empty) (*proto.Empty, error) {
	// return &proto.Empty{}, motors.Home()
	return &proto.Empty{}, nil
}

func (s *motorControlServiceServer) StartCycle(ctx context.Context, e *proto.Empty) (*proto.Empty, error) {
	// return &proto.Empty{}, motors.StartCycle()
	return &proto.Empty{}, nil
}

func (s *motorControlServiceServer) StopCycle(ctx context.Context, e *proto.Empty) (*proto.Empty, error) {
	// return &proto.Empty{}, motors.StopCycle()
	return &proto.Empty{}, nil
}
