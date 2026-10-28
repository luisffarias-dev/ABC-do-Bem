// lib/widgets/features_toggle_section.dart

import 'package:flutter/material.dart';
import '../utils/responsive.dart';

// Passos para Voluntários
final List<Map<String, String>> volunteerSteps = [
  {
    "icon": "👤",
    "title": "Crie seu perfil",
    "desc":
        "Cadastre suas habilidades e causas que você tem interesse em apoiar.",
  },
  {
    "icon": "🗺️",
    "title": "Encontre ONGs",
    "desc": "Busque organizações por geolocalização na região do Grande ABC.",
  },
  {
    "icon": "📅",
    "title": "Inscreva-se",
    "desc": "Encontrou uma ação legal? Participe com apenas dois cliques.",
  },
  {
    "icon": "🤝",
    "title": "Faça a diferença",
    "desc": "Alinhe os detalhes pelo chat direto com a ONG e comece a atuar.",
  },
];

// Passos para ONGs
final List<Map<String, String>> ongSteps = [
  {
    "icon": "🏢",
    "title": "Cadastre a Instituição",
    "desc":
        "Crie o perfil da sua organização e mostre sua missão para a comunidade.",
  },
  {
    "icon": "📢",
    "title": "Divulgue necessidades",
    "desc": "Publique eventos, vagas para mutirões ou necessidades diárias.",
  },
  {
    "icon": "🎯",
    "title": "Aprove voluntários",
    "desc":
        "Receba inscrições de pessoas com as habilidades exatas que você precisa.",
  },
  {
    "icon": "💬",
    "title": "Gerencie projetos",
    "desc": "Use o chat integrado para coordenar os voluntários com agilidade.",
  },
];

class FeaturesToggleSection extends StatefulWidget {
  const FeaturesToggleSection({super.key});

  @override
  State<FeaturesToggleSection> createState() => _FeaturesToggleSectionState();
}

class _FeaturesToggleSectionState extends State<FeaturesToggleSection> {
  bool isVolunteerSelected = true;

  Widget _buildGrid(
    BuildContext context,
    List<Map<String, String>> steps,
    Color iconBgColor,
    Color stepColor,
  ) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    final int crossAxisCount = isDesktop ? 4 : (isMobile ? 1 : 2);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: isMobile ? 180 : 220,
      ),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        return Container(
          padding: EdgeInsets.all(isMobile ? 18 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    step["icon"]!,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "PASSO ${index + 1}",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: stepColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step["title"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  step["desc"]!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3A6868),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(
    String text,
    bool isSelected,
    VoidCallback onTap,
    bool isMobile,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 18 : 32,
          vertical: isMobile ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0C6B6B) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF3A6868),
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 12 : 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 64,
        horizontal: isMobile ? 16 : 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // Barra de alternância (Toggle)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: Row(
                  mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isMobile)
                      Expanded(
                        child: _buildTabButton(
                          "Voluntários",
                          isVolunteerSelected,
                          () => setState(() => isVolunteerSelected = true),
                          isMobile,
                        ),
                      )
                    else
                      _buildTabButton(
                        "Para Voluntários",
                        isVolunteerSelected,
                        () => setState(() => isVolunteerSelected = true),
                        isMobile,
                      ),
                    if (isMobile)
                      Expanded(
                        child: _buildTabButton(
                          "Instituições",
                          !isVolunteerSelected,
                          () => setState(() => isVolunteerSelected = false),
                          isMobile,
                        ),
                      )
                    else
                      _buildTabButton(
                        "Para Instituições",
                        !isVolunteerSelected,
                        () => setState(() => isVolunteerSelected = false),
                        isMobile,
                      ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 32 : 48),

              // Grade animada com os passos
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isVolunteerSelected
                    ? _buildGrid(
                        context,
                        volunteerSteps,
                        const Color(0xFFD1F5EE),
                        const Color(0xFF29B0A0),
                      )
                    : _buildGrid(
                        context,
                        ongSteps,
                        const Color(0xFFC2E4DC),
                        const Color(0xFF0C6B6B),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
