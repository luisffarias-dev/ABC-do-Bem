// lib/landing_page.dart

import 'package:flutter/material.dart';

// Importando o utilitário de responsividade
import 'utils/responsive.dart';

// Importando os blocos da página
import 'widgets/custom_nav_bar.dart';
import 'widgets/hero_section.dart';
import 'widgets/features_toggle_section.dart';
import 'widgets/impact_gallery_section.dart';
import 'widgets/landing_page_sections.dart';

class LandingPage extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegisterVolunteer;
  final VoidCallback onRegisterOng;

  const LandingPage({
    super.key,
    required this.onLogin,
    required this.onRegisterVolunteer,
    required this.onRegisterOng,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Quicksand'),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0FAF7),
        // Drawer móvel para garantir acesso fácil às ações no smartphone
        drawer: isMobile ? _buildMobileDrawer(context) : null,
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  // Espaçamento do topo para acomodar a CustomNavBar flutuante
                  SizedBox(height: isMobile ? 70 : 80),

                  HeroSection(
                    onRegisterVolunteer: onRegisterVolunteer,
                    onRegisterOng: onRegisterOng,
                  ),
                  const StatsSection(),
                  const FeaturesToggleSection(),
                  const ImpactGallerySection(),

                  // Seções de escolha de perfil e CTA final
                  SplitRoleSection(
                    onRegisterVolunteer: onRegisterVolunteer,
                    onRegisterOng: onRegisterOng,
                  ),
                  FinalCtaSection(
                    onRegisterVolunteer: onRegisterVolunteer,
                    onLogin: onLogin,
                  ),

                  const CustomFooter(),
                ],
              ),
            ),

            // Barra de Navegação Superior Fixa
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomNavBar(
                onLogin: onLogin,
                onRegisterVolunteer: onRegisterVolunteer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Menu lateral deslizante acionado em telas móveis
  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                children: const [
                  Icon(Icons.eco_rounded, color: Color(0xFF0C6B6B), size: 30),
                  SizedBox(width: 10),
                  Text(
                    "ABC do Bem",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF062222),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFC2E4DC)),
            const SizedBox(height: 12),
            ListTile(
              leading:
                  const Icon(Icons.login_rounded, color: Color(0xFF0C6B6B)),
              title: const Text(
                "Entrar na Conta",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF062222)),
              ),
              onTap: () {
                Navigator.pop(context);
                onLogin();
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism_rounded,
                  color: Color(0xFF0C6B6B)),
              title: const Text(
                "Quero ser Voluntário",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF062222)),
              ),
              onTap: () {
                Navigator.pop(context);
                onRegisterVolunteer();
              },
            ),
            ListTile(
              leading: const Icon(Icons.storefront_rounded,
                  color: Color(0xFF0C6B6B)),
              title: const Text(
                "Cadastrar Minha ONG",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF062222)),
              ),
              onTap: () {
                Navigator.pop(context);
                onRegisterOng();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "ABC do Bem © 2026\nConectando quem quer ajudar com quem precisa.",
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade600, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
