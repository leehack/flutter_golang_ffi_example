package main

// typedef struct Array {
// 	int len;
// 	int *data;
// } Array;
import "C"
import "unsafe"

//export sum
func sum(a C.int, b C.int) C.int {
	return a + b
}

//export test_bytes
func test_bytes(bt unsafe.Pointer, size C.int) *C.char {
	received := C.GoBytes(bt, size)
	res := C.CBytes(received)
	result := (*C.char)(res)
	return result
}

//export test2_bytes
func test2_bytes(bt C.Array) C.Array {
	sl := []int{1, 2, 3, 4, 5}
	buf := C.malloc(C.size_t(5 * C.sizeof_int))
	for i, v := range sl {
		*(*C.int)(unsafe.Pointer(uintptr(buf) + uintptr(i)*C.sizeof_int)) = C.int(v)
	}
	return C.Array{len: 5, data: (*C.int)(buf)}
}

//export enforce_binding
func enforce_binding() {}

func main() {}
