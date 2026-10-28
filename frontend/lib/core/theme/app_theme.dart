import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Define a fonte padrão para o app inteiro
      fontFamily: 'Quicksand',

      // Define a cor de fundo padrão de todos os Scaffolds (Telas)
      scaffoldBackgroundColor: AppColors.background,

      // Define a cor principal do Material Design
      primaryColor: AppColors.primary,

      // Ajuste global para a cor primária
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        error: AppColors.error,
      ),

      // Configuração global para Textos
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.textDark),
        bodyLarge: TextStyle(color: AppColors.textDark),
      ),
    );
  }
}
