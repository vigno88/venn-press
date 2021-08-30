package serial

//go:generate msgp

type ParameterMsgPack struct {
	T  int                  `msg:"t"`
	Ps []map[string]float32 `msg:"ps"`
}

type CommandMsgPack struct {
	T    int    `msg:"t"`
	Name string `msg:"n"`
	Arg  string `msg:"a"`
}

type EventMsgPack struct {
	T    int    `msg:"t"`
	Name string `msg:"n"`
}

type MetricsMsgPack struct {
	T  int                  `msg:"t"`
	Ms []map[string]float32 `msg:"ms"`
}
