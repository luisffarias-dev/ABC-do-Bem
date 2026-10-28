// lib/ongs/home/widgets/ong_banner_header.dart

import 'package:flutter/material.dart';
import '../../../ongs/models/ong_dashboard_models.dart';

class OngBannerHeader extends StatelessWidget {
  final OngDashboardModel dashboard;
  final bool isMobile;

  const OngBannerHeader({
    super.key,
    required this.dashboard,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF062222), Color(0xFF0C5252), Color(0xFF1A8F8F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF9FE8D8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "PAINEL DA ONG",
                  style: TextStyle(
                    color: Color(0xFF062222),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${dashboard.cidade} - SP",
                style: const TextStyle(color: Color(0xFF9FE8D8), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dashboard.nome,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 20 : 26,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dashboard.categoria,
                      style: const TextStyle(
                        color: Color(0xFF9FE8D8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: isMobile ? 26 : 32,
                backgroundImage: NetworkImage(dashboard.logoUrl),
                backgroundColor: Colors.white,
              ),
            ],
          ),
          SizedBox(height: isMobile ? 14 : 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem(
                "${dashboard.totalVoluntariosEngajados}",
                "Voluntários ativos",
              ),
              _buildMetricItem("${dashboard.vagasAbertas}", "Vagas abertas"),
              _buildMetricItem("${dashboard.horasGeradas}h", "Horas geradas"),
              _buildMetricItem(
                "${dashboard.candidaturasPendentes.length}",
                "Candidaturas",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String valor, String rotulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          rotulo,
          style: const TextStyle(color: Color(0xFF9FE8D8), fontSize: 11),
        ),
      ],
    );
  }
}
