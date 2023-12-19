package main

import "C"

//export sum
func sum(a C.int, b C.int) C.int {
	return a + b
}

//export enforce_binding
func enforce_binding() {}

func main() {}
