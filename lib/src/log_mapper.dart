import 'dart:convert';
import 'mapper.dart';
import 'entity/log.dart';
import 'log_level_mapper.dart';
import 'data/entity/local_log.dart';

class LogMapper extends Mapper<Log, LocalLog> {
  @override
  LocalLog map(Log from) {
    final logLevelMapper = LogLevelMapper();
    return LocalLog(
      message: stringifyMessage(from.message),
      formatted: from.formatted,
      timestamp: from.timestamp,
      level: logLevelMapper.map(from.level),
      levelForeground: from.levelForegroundColor.value,
      levelBackground: from.levelBackgroundColor.value,
    );
  }

  // Handles any object that is causing JsonEncoder() problems
  Object toEncodableFallback(dynamic object) {
    return object.toString();
  }

  String stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = JsonEncoder.withIndent('  ', toEncodableFallback);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }
}
