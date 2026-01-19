import 'dart:io';

void writeToLogFile(String message) {
  File("${Platform.environment["HOME"]}/brtc.log")
      .writeAsStringSync("$message\n", mode: FileMode.append);
}
