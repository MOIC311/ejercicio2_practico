import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ReportActionCard extends StatelessWidget {
  const ReportActionCard({
    super.key,
    required this.isProcessing,
    required this.onGenerate,
  });

  final bool isProcessing;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.data_array_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Procesamiento masivo',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Generar reporte',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: isProcessing ? null : onGenerate,
            icon: Icon(
              isProcessing ? Icons.hourglass_top_rounded : Icons.bolt_rounded,
              size: 20,
            ),
            label: Text(
              isProcessing
                  ? 'Procesando en segundo plano...'
                  : 'Generar reporte',
            ),
          ),
          if (isProcessing) ...[
            const SizedBox(height: 22),
            const _ProcessingIndicator(),
          ],
        ],
      ),
    );
  }
}

class _ProcessingIndicator extends StatelessWidget {
  const _ProcessingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'El isolate está generando y analizando los registros. '
              'Puedes seguir usando la app.',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
