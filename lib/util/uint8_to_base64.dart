import 'dart:convert';
import 'dart:typed_data';

/// To Change Uint8 to Base64
/// @dataType => image/png
String uint8ToBase64(Uint8List uint8list, String dataType) {
  String base64String = base64Encode(uint8list);
  // String header = "data:image/png;base64,";
  String header = "data:$dataType;base64,";
  return header + base64String;
}
