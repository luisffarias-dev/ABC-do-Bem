// lib/widgets/hero_section.dart

import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onRegisterVolunteer;
  final VoidCallback onRegisterOng;

  const HeroSection({
    super.key,
    required this.onRegisterVolunteer,
    required this.onRegisterOng,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    final List<String> cities = [
      "Santo André",
      "São Bernardo do Campo",
      "São Caetano do Sul",
      "Mauá",
      "Diadema",
      "Ribeirão Pires",
      "Rio Grande da Serra",
    ];

    Widget textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Conectando\nvoluntários e ONGs",
          style: TextStyle(
            fontSize: isMobile ? 32 : (isDesktop ? 48 : 40),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.15,
          ),
        ),
        SizedBox(height: isMobile ? 14 : 20),
        Text(
          "A plataforma que une quem quer ajudar com quem precisa de apoio no Grande ABC. Simples, rápida e gratuita.",
          style: TextStyle(
            fontSize: isMobile ? 15 : 18,
            color: const Color(0xFF9FE8D8),
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        SizedBox(height: isMobile ? 24 : 32),

        // Botões de Ação
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9FE8D8), Color(0xFF3DCFB0)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: onRegisterVolunteer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Sou Voluntário — Quero Ajudar",
                    style: TextStyle(
                      color: Color(0xFF062222),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onRegisterOng,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Sou uma ONG — Quero Cadastrar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9FE8D8), Color(0xFF3DCFB0)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: onRegisterVolunteer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Sou Voluntário — Quero Ajudar",
                    style: TextStyle(
                      color: Color(0xFF062222),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: onRegisterOng,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Sou uma ONG — Quero Cadastrar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
      ],
    );

    Widget citiesWidget = Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: cities.map((c) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Text(
            "📍 $c",
            style: const TextStyle(
              color: Color(0xFF9FE8D8),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: isMobile ? 40 : 80,
        bottom: isMobile ? 50 : 80,
        left: isMobile ? 16 : 24,
        right: isMobile ? 16 : 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.4, 0.8, 1.0],
          colors: [
            Color(0xFF062222),
            Color(0xFF0C5252),
            Color(0xFF1A8F8F),
            Color(0xFF3DCFB0),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 3, child: textContent),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo_abcdobem.png',
                          width: 350,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.eco_rounded,
                            size: 180,
                            color: Color(0xFF9FE8D8),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    textContent,
                    SizedBox(height: isMobile ? 32 : 44),
                    Center(
                      child: Image.asset(
                        'assets/images/logo_abcdobem.png',
                        width: isMobile ? 180 : 250,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.eco_rounded,
                          size: isMobile ? 120 : 160,
                          color: const Color(0xFF9FE8D8),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: isMobile ? 32 : 48),
              citiesWidget,
            ],
          ),
        ),
      ),
    );
  }
}
