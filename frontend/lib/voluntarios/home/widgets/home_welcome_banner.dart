// lib/voluntarios/home/widgets/home_welcome_banner.dart

import 'package:flutter/material.dart';

import '../../../../services/session_service.dart';
import '../../../models/dashboard_volunteer_models.dart';

class HomeWelcomeBanner extends StatelessWidget {
  final VoluntarioDashboardModel dashboard;
  final bool isMobile;

  const HomeWelcomeBanner({
    super.key,
    required this.dashboard,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Resolve o nome completo preferencialmente pelo dashboard ou pela sessão
    String nomeCompleto = dashboard.nome.trim();
    if (nomeCompleto.isEmpty || nomeCompleto.toLowerCase() == "voluntário") {
      final sessaoNome = SessionService.instance.nomeUsuario?.trim();
      if (sessaoNome != null && sessaoNome.isNotEmpty) {
        nomeCompleto = sessaoNome;
      }
    }

    // Extrai o primeiro nome
    final String primeiroNome =
        nomeCompleto.isNotEmpty ? nomeCompleto.split(' ').first : "Voluntário";

    // 2. Validação abrangente de foto (HTTP, HTTPS ou Data URL Base64)
    final String fotoUrl = dashboard.fotoUrl.trim();
    final bool temFotoValida = fotoUrl.isNotEmpty &&
        (fotoUrl.startsWith("http://") ||
            fotoUrl.startsWith("https://") ||
            fotoUrl.startsWith("data:image/"));

    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF062222), Color(0xFF0C5252), Color(0xFF1A8F8F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "BEM-VINDO(A) DE VOLTA",
            style: TextStyle(
              color: Color(0xFF9FE8D8),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Olá, $primeiroNome! 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 20 : 26,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CircleAvatar(
                radius: isMobile ? 22 : 28,
                backgroundColor: const Color(0xFF1A8F8F),
                backgroundImage: temFotoValida ? NetworkImage(fotoUrl) : null,
                child: !temFotoValida
                    ? Text(
                        primeiroNome.isNotEmpty
                            ? primeiroNome[0].toUpperCase()
                            : 'V',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 18 : 22,
                        ),
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Acompanhe suas missões ativas e descubra novas oportunidades de impacto no ABC.",
            style: TextStyle(color: Color(0xFF9FE8D8), fontSize: 12),
          ),
          SizedBox(height: isMobile ? 14 : 18),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem("${dashboard.metricas.totalCidades}", "Cidades"),
              _buildMetricItem(
                  "${dashboard.metricas.ongsAjudadas}", "ONGs parceiras"),
              _buildMetricItem(dashboard.metricas.horasDoadas, "Horas doadas"),
              _buildRatingMetricItem(
                  dashboard.metricas.rankingEstrelas, "Ranking"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF9FE8D8), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildRatingMetricItem(double rating, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$rating",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 3),
            const Icon(Icons.star_rounded, color: Colors.amber, size: 15),
          ],
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF9FE8D8), fontSize: 10),
        ),
      ],
    );
  }
}
