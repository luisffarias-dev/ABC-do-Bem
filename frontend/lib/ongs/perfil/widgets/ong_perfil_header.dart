// lib/ongs/perfil/widgets/ong_perfil_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import '../../models/ong_detail_models.dart';

class OngPerfilHeader extends StatelessWidget {
  final OngDetalheModel ong;
  final bool isOng;
  final bool isMobile;
  final VoidCallback onToggleSeguir;
  final VoidCallback onConversar;
  final VoidCallback onEditarDados;
  final VoidCallback onCriarEvento;

  const OngPerfilHeader({
    super.key,
    required this.ong,
    required this.isOng,
    required this.isMobile,
    required this.onToggleSeguir,
    required this.onConversar,
    required this.onEditarDados,
    required this.onCriarEvento,
  });

  @override
  Widget build(BuildContext context) {
    final bool seguindo = ong.isSeguindo;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Superior
          Container(
            height: isMobile ? 110 : 160,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(ong.bannerUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isMobile ? 14 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo com borda sobreposta
                    Transform.translate(
                      offset: Offset(0, isMobile ? -36 : -55),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 6),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            ong.logoUrl,
                            width: isMobile ? 64 : 90,
                            height: isMobile ? 64 : 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ong.nome,
                            style: TextStyle(
                              fontSize: isMobile ? 17 : 21,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF062222),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1F5EE),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ong.categoria,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0C6B6B),
                                  ),
                                ),
                              ),
                              Text(
                                "${ong.cidade} • ${ong.totalSeguidores} seg.",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Linha de canais de contato e redes
                _buildLinhaRedesETelefone(context),
                const SizedBox(height: 14),

                // Botões de Ação
                if (isOng)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEditarDados,
                          icon: const Icon(
                            Icons.edit_note_rounded,
                            size: 16,
                            color: Color(0xFF0C6B6B),
                          ),
                          label: const Text(
                            "Editar Dados",
                            style: TextStyle(
                              color: Color(0xFF0C6B6B),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFF0C6B6B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onCriarEvento,
                          icon: const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Criar Evento",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0C6B6B),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onConversar,
                          icon: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 15,
                            color: Color(0xFF0C6B6B),
                          ),
                          label: const Text(
                            "Conversar",
                            style: TextStyle(
                              color: Color(0xFF0C6B6B),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFF0C6B6B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onToggleSeguir,
                          icon: Icon(
                            seguindo
                                ? Icons.check_rounded
                                : Icons.notifications_none_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: Text(
                            seguindo ? "Seguindo" : "Seguir ONG",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: seguindo
                                ? const Color(0xFF29B0A0)
                                : const Color(0xFF0C6B6B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 14),

                // Match Card exclusivo para voluntários
                if (!isOng) _buildMatchCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinhaRedesETelefone(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAF7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ong.instagram != null && ong.instagram!.isNotEmpty)
                _buildMiniIcon(
                    context, FontAwesomeIcons.instagram, "Instagram"),
              if (ong.facebook != null && ong.facebook!.isNotEmpty)
                _buildMiniIcon(context, FontAwesomeIcons.facebook, "Facebook"),
              if (ong.linkedin != null && ong.linkedin!.isNotEmpty)
                _buildMiniIcon(context, FontAwesomeIcons.linkedin, "LinkedIn"),
              if (ong.whatsapp != null && ong.whatsapp!.isNotEmpty)
                _buildMiniIcon(context, FontAwesomeIcons.whatsapp, "WhatsApp"),
            ],
          ),
          if (ong.telefone != null && ong.telefone!.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 14,
                  color: Color(0xFF0C6B6B),
                ),
                const SizedBox(width: 4),
                Text(
                  ong.telefone!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062222),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMiniIcon(BuildContext context, IconData icon, String nomeRede) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Acessando canal do $nomeRede..."),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF9FE8D8)),
          ),
          child: FaIcon(icon, size: 14, color: const Color(0xFF0C6B6B)),
        ),
      ),
    );
  }

  Widget _buildMatchCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE6F7F3), Color(0xFFD4F2EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF9FE8D8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Color(0xFF0C6B6B),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      "Essa ONG precisa de você!",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF062222),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "🎯 96% Match",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C6B6B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  "Suas habilidades em Educação e Fotografia combinam com as atividades urgentes desta instituição no ABC.",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
