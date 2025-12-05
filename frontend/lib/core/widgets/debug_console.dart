import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import '../services/debug_service.dart';

/// A floating, draggable overlay widget that displays debug logs in real-time.
class DebugConsole extends StatefulWidget {
  const DebugConsole({super.key});

  @override
  State<DebugConsole> createState() => _DebugConsoleState();
}

class _DebugConsoleState extends State<DebugConsole> {
  Offset _position = const Offset(10, 10);
  bool _isExpanded = false;
  final _debugService = DebugService();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7, // Fixed width
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisSize: _isExpanded ? MainAxisSize.max : MainAxisSize.min, // Adjust size based on expanded state
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                if (_isExpanded)
                  SizedBox( // Fixed height for log list when expanded
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: _buildLogList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bug_report, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            const Text(
              'Debug Console',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            // Copy All Button
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.white, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _debugService.logs.value.join('\n')));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logs copied to clipboard!')),
                );
              },
              tooltip: 'Copy All Logs',
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.white, size: 18),
              onPressed: _debugService.clear,
              tooltip: 'Clear Logs',
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
            Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogList() {
    return Flexible(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: _debugService.logs,
        builder: (context, logs, child) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                Color logColor = Colors.white;
                if (log.contains('❌') || log.contains('Error')) {
                  logColor = Colors.red.shade300;
                } else if (log.contains('✅') || log.contains('Success')) {
                  logColor = Colors.green.shade300;
                } else if (log.contains('⚠️')) {
                  logColor = Colors.yellow.shade300;
                }

                return SelectableText( // Changed to SelectableText
                  log,
                  style: TextStyle(color: logColor, fontSize: 10, fontFamily: 'monospace'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
