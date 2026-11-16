import 'package:flutter/material.dart';

import '../services/report_processor.dart';
import '../theme/app_colors.dart';
import 'home_header.dart';
import 'report_action_card.dart';
import 'report_result_card.dart';
import 'thread_info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.reportGenerator = ReportProcessor.generateReport,
  });

  final Future<ReportResult> Function() reportGenerator;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isProcessing = false;
  ReportResult? _result;

  Future<void> _generateReport() async {
    setState(() {
      _isProcessing = true;
      _result = null;
    });

    try {
      final result = await widget.reportGenerator();
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _result = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reporte generado correctamente: '
            '${result.processedRecords} registros procesados.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo generar el reporte: $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.speed_rounded, color: AppColors.primary),
            SizedBox(width: 9),
            Text(
              'Rendimiento',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
              children: [
                const HomeHeader(),
                const SizedBox(height: 28),
                ReportActionCard(
                  isProcessing: _isProcessing,
                  onGenerate: _generateReport,
                ),
                if (_result case final result?) ...[
                  const SizedBox(height: 18),
                  ReportResultCard(result: result),
                ],
                const SizedBox(height: 22),
                const ThreadInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
