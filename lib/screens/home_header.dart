import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'EJERCICIO 2  ·  RENDIMIENTO',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Optimización del\nMain Thread',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Procesa una colección de 100,000 registros en segundo plano '
          'mientras la interfaz permanece fluida.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
