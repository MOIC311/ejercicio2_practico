import 'package:ejercicio2_practico/main.dart';
import 'package:ejercicio2_practico/screens/home_screen.dart';
import 'package:ejercicio2_practico/services/report_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generates and filters the full report in a worker isolate', () async {
    final result = await ReportProcessor.generateReport();

    expect(result.processedRecords, reportRecordCount);
    expect(result.filteredRecords, greaterThan(0));
    expect(result.filteredRecords, lessThan(result.processedRecords));
    expect(result.elapsedMilliseconds, greaterThanOrEqualTo(0));
  });

  testWidgets('shows an active indicator while generating a report', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ReportApp());
    expect(find.text('Optimización del\nMain Thread'), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Procesando en segundo plano...'), findsOneWidget);
  });

  testWidgets('shows the report and success notification when complete', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          reportGenerator: () async => const ReportResult(
            processedRecords: reportRecordCount,
            filteredRecords: 12345,
            elapsedMilliseconds: 250,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Reporte completado'), findsOneWidget);
    expect(
      find.textContaining('Reporte generado correctamente: 100000'),
      findsOneWidget,
    );
  });
}
