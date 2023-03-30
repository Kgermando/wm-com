// import 'dart:io';
// import 'dart:typed_data';

// // import 'package:open_file/open_file.dart' as open_file;
// import 'package:open_app_file/open_app_file.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// // ignore: depend_on_referenced_packages
// import 'package:path_provider_platform_interface/path_provider_platform_interface.dart'
//   as path_provider_interface;

// ///To save the Excel file in the Mobile and Desktop platforms.
// Future<void> saveAndLaunchFilePdf(Uint8List bytes, String fileName) async {
//   String? path;
//   if (Platform.isAndroid ||
//       Platform.isIOS ||
//       Platform.isLinux ||
//       GetPlatform.isWindows) {
//     final Directory directory =
//       await path_provider.getApplicationSupportDirectory();
//     path = directory.path;
//   } else {
//     path = await path_provider_interface.PathProviderPlatform.instance
//         .getApplicationSupportPath();
//   }
 
//   final String fileLocation = GetPlatform.isWindows ? '$path\\$fileName' : '$path/$fileName';
//   final File file = File(fileLocation);
//   await file.writeAsBytes(bytes, flush: true);

//   if (Platform.isAndroid || Platform.isIOS) { 
//     await OpenAppFile.open(fileLocation);
//   } else if (GetPlatform.isWindows) {
//     await Process.run('start', <String>[fileLocation], runInShell: true);
//   } else if (Platform.isMacOS) {
//     await Process.run('open', <String>[fileLocation], runInShell: true);
//   } else if (Platform.isLinux) {
//     await Process.run('xdg-open', <String>[fileLocation], runInShell: true);
//   }
// }
