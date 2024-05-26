import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import 'generated_bindings.dart';

/// A very short-lived native function.
///
/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.
int sum(int a, int b) => _bindings.sum(a, b);
List<int> testByte(List<int> bt) {
  final Pointer<Array> slice = calloc<Array>();
  final data = calloc<Int>(bt.length + 1);
  for (var i = 0; i < bt.length; i++) {
    data[i] = bt[i];
  }
  slice.ref.data = data;
  slice.ref.len = bt.length;
  final result = _bindings.test2_bytes(slice.ref);
  calloc.free(data);
  calloc.free(slice);
  final res = result.data.cast<Uint32>().asTypedList(result.len).toList();
  calloc.free(result.data);
  return res;
}

const String _libName = 'native_add';

/// The dynamic library in which the symbols for [NativeAddBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('libsum.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final NativeLibrary _bindings = NativeLibrary(_dylib);
