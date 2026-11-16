import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ThreadInfoCard extends StatelessWidget {
  const ThreadInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.layers_rounded, color: AppColors.primary, size: 21),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'El trabajo intensivo corre fuera del hilo de interfaz con '
              'compute(). El indicador animado permanece visible mientras '
              'se procesa el reporte.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
