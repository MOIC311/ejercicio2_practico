import 'package:flutter/material.dart';

import '../services/report_processor.dart';
import '../theme/app_colors.dart';

class ReportResultCard extends StatelessWidget {
  const ReportResultCard({super.key, required this.result});

  final ReportResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.success),
              SizedBox(width: 10),
              Text(
                'Reporte completado',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ResultLine(
            label: 'Registros procesados',
            value: result.processedRecords.toString(),
          ),
          const SizedBox(height: 8),
          _ResultLine(
            label: 'Coincidencias filtradas',
            value: result.filteredRecords.toString(),
          ),
          const SizedBox(height: 8),
          _ResultLine(
            label: 'Tiempo del isolate',
            value: '${result.elapsedMilliseconds} ms',
          ),
        ],
      ),
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
