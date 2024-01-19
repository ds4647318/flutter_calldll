import 'dart:ffi' as ffi;
import 'dart:io' show Directory, Platform;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';

// Correct FFI signature for getMyString returning a string
typedef GetMyStringFunc = ffi.Pointer<ffi.Int8> Function();
// Dart type definition for calling the C foreign function
typedef GetMyString = ffi.Pointer<ffi.Int8> Function();

class CallDll extends StatelessWidget {
  const CallDll({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the library path is correct for the platform
    var libraryPath = path.join(Directory.current.path, 'mydll.dll');
        
    final dylib = ffi.DynamicLibrary.open(libraryPath);

    // Look up the C function 'getMyString'
    final getMyString = dylib
      .lookup<ffi.NativeFunction<GetMyStringFunc>>('getMyString')
      .asFunction<GetMyString>();

    // Call the function and convert the result to a Dart string
    var ptr = getMyString();

    if (ptr.address == 0) {
      // Handle the case where the DLL returns a null pointer
      throw Exception('getMyString returned a null pointer');
    }

    var str = ptr.cast<Utf8>().toDartString();

    // Free the pointer if necessary (depends on the implementation of the DLL)
    // ffi.calloc.free(ptr);

    // Use the Dart string in the widget
    return Scaffold(
      appBar: AppBar(
        title: Text('CallDll Example'),
      ),
      body: Center(
        child: Text('DLL String: $str'),
      ),
    );
  }
}