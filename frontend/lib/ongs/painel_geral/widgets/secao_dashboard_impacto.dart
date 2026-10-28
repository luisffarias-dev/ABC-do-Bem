// lib/ongs/painel_geral/widgets/secao_dashboard_impacto.dart

import 'package:flutter/material.dart';
import 'card_painel_base.dart';

class SecaoDashboardImpacto extends StatelessWidget {
  final bool isMobile;
  final ValueChanged<String> onNavegar;

  const SecaoDashboardImpacto({
    super.key,
    required this.isMobile,
    required this.onNavegar,
  });

  @override
  Widget build(BuildContext context) {
    return CardPainelBase(
      titulo: "1. Métricas e Indicadores",
      icone: Icons.insights_rounded,
      isMobile: isMobile,
      botaoAcao: TextButton.icon(
        onPressed: () => onNavegar("Relatórios"),
        icon: const Icon(
          Icons.file_download_outlined,
          size: 15,
          color: Color(0xFF0C6B6B),
        ),
        label: const Text(
          "Exportar",
          style: TextStyle(
            color: Color(0xFF0C6B6B),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      conteudo: Column(
        children: [
          Row(
            children: [
              _buildMiniIndicador(
                valor: "340h",
                rotulo: "Horas doadas",
                icon: Icons.schedule_rounded,
                cor: const Color(0xFF0C6B6B),
              ),
              const SizedBox(width: 8),
              _buildMiniIndicador(
                valor: "88%",
                rotulo: "Vagas preenchidas",
                icon: Icons.pie_chart_rounded,
                cor: const Color(0xFF1A528F),
              ),
              const SizedBox(width: 8),
              _buildMiniIndicador(
                valor: "64%",
                rotulo: "Retenção vol.",
                icon: Icons.repeat_rounded,
                cor: const Color(0xFFD46B08),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FAF7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC2E4DC)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.savings_outlined,
                  color: Color(0xFF0C6B6B),
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Impacto social estimado: R\$ 18.700,00 no Grande ABC.",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF062222),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniIndicador({
    required String valor,
    required String rotulo,
    required IconData icon,
    required Color cor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 8 : 12),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: cor),
            const SizedBox(height: 4),
            Text(
              valor,
              style: TextStyle(
                fontSize: isMobile ? 15 : 18,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            Text(
              rotulo,
              style: TextStyle(
                fontSize: isMobile ? 9 : 10,
                color: Colors.grey.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
