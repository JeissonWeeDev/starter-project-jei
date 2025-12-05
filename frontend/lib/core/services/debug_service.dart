import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// A singleton service for collecting and displaying in-app debug logs.
/// This is used to show debug information directly on the screen when
/// access to the debug console is not available.
class DebugService {
  static final DebugService _instance = DebugService._internal();
  factory DebugService() => _instance;
  DebugService._internal();

  /// A ValueNotifier that holds the list of log messages.
  /// UI widgets can listen to this notifier to rebuild when logs are updated.
  final ValueNotifier<List<String>> logs = ValueNotifier([]);

  /// Adds a new log message to the list.
  /// The message is timestamped for clarity.
  void log(String message) {
    final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());
    logs.value = [...logs.value, '$timestamp - $message'];
  }

  /// Clears all log messages.
  void clear() {
    logs.value = [];
  }
}
