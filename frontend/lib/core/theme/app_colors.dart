import 'package:flutter/material.dart';

class AppColors {
  // Fundo principal do app
  static const Color background = Color(0xFFF0FAF7);

  // Textos e Títulos
  static const Color textDark = Color(0xFF062222);
  static const Color textSecondary = Color(0xFF3A6868);
  static const Color textLight = Color(0xFF9FE8D8);

  // Cores Principais da Marca (Verdes)
  static const Color primary = Color(0xFF0C6B6B);
  static const Color primaryLight = Color(
    0xFF8CD4C7,
  ); // Usada no botão Continuar

  // Gradiente do Topo
  static const List<Color> headerGradient = [
    Color(0xFF062222),
    Color(0xFF0C5252),
    Color(0xFF1A8F8F),
  ];

  // Bordas e Fundos de Componentes (Inputs, Chips, Cards)
  static const Color borderLight = Color(0xFFC2E4DC);
  static const Color fillLight = Color(
    0xFFE3F5F1,
  ); // Usado na caixa de LGPD e Logo
  static const Color chipSelected = Color(0xFFD1F5EE);

  // Feedbacks (Erros e Sucesso)
  static const Color error = Colors.redAccent;
  static const Color success = Colors.green;
}
