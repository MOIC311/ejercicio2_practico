import 'dart:convert';

import 'package:flutter/foundation.dart';

const reportRecordCount = 100000;

class ReportResult {
  const ReportResult({
    required this.processedRecords,
    required this.filteredRecords,
    required this.elapsedMilliseconds,
  });

  final int processedRecords;
  final int filteredRecords;
  final int elapsedMilliseconds;

  factory ReportResult.fromMap(Map<String, int> values) {
    return ReportResult(
      processedRecords: values['processedRecords']!,
      filteredRecords: values['filteredRecords']!,
      elapsedMilliseconds: values['elapsedMilliseconds']!,
    );
  }
}

class ReportProcessor {
  const ReportProcessor._();

  static Future<ReportResult> generateReport() async {
    final result = await compute(_processRecords, reportRecordCount);
    return ReportResult.fromMap(result);
  }
}

Map<String, int> _processRecords(int recordCount) {
  final stopwatch = Stopwatch()..start();
  final records = List<String>.generate(recordCount, (index) {
    return jsonEncode({
      'id': index,
      'name': 'Registro-${index.toString().padLeft(6, '0')}',
      'amount': (index * 37) % 10000,
      'category': index % 8,
    });
  }, growable: false);

  var filteredRecords = 0;
  var checksum = 0;
  for (final encodedRecord in records) {
    final record = jsonDecode(encodedRecord) as Map<String, dynamic>;
    final id = record['id'] as int;
    final name = record['name'] as String;
    var score = (id + record['amount'] as int) & 0x7fffffff;

    for (var iteration = 0; iteration < 32; iteration++) {
      score =
          (score * 31 + name.codeUnitAt(iteration % name.length)) & 0x7fffffff;
    }

    checksum = (checksum + score) & 0x7fffffff;
    if (score % 5 == 0) {
      filteredRecords++;
    }
  }
  stopwatch.stop();

  return {
    'processedRecords': records.length,
    'filteredRecords': filteredRecords,
    'elapsedMilliseconds': stopwatch.elapsedMilliseconds,
    'checksum': checksum,
  };
}
