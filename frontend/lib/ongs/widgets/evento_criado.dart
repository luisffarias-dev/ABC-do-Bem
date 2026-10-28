// lib/ongs/widgets/sucesso_compartilhar_evento_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../eventos/models/evento_model.dart';

class SucessoCompartilharEventoDialog extends StatelessWidget {
  final EventoModel evento;
  final VoidCallback onConcluir;

  const SucessoCompartilharEventoDialog({
    super.key,
    required this.evento,
    required this.onConcluir,
  });

  static Future<void> exibir(
    BuildContext context, {
    required EventoModel evento,
    required VoidCallback onConcluir,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SucessoCompartilharEventoDialog(
        evento: evento,
        onConcluir: onConcluir,
      ),
    );
  }

  void _copiarLink(BuildContext context) {
    final link = "https://abcdobem.org.br/eventos/${evento.id}";
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Link da ação copiado para a área de transferência!"),
        backgroundColor: Color(0xFF0C6B6B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _simularCompartilhamento(BuildContext context, String rede) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Compartilhando no $rede..."),
        backgroundColor: const Color(0xFF0C6B6B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone e Mensagem de Sucesso
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFD1F5EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF0C6B6B),
                  size: 40,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Evento Cadastrado com Sucesso!",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                "A ação já está visível para a comunidade do Grande ABC. Divulgue nas redes para acelerar as inscrições:",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Card da Arte / Informações da Ação
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FAF7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(11)),
                      child: Image.network(
                        evento.imagemUrl,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 90,
                          color: const Color(0xFFC7EBE3),
                          child: const Icon(Icons.image_not_supported_outlined,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evento.titulo,
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF062222),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  size: 13, color: Color(0xFF0C6B6B)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "${evento.data} • ${evento.horario}",
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  size: 13, color: Color(0xFF0C6B6B)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "${evento.endereco} - ${evento.cidade}",
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Botões de Redes Sociais
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Compartilhar em:",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062222),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRedeButton(
                    label: "WhatsApp",
                    cor: const Color(0xFF25D366),
                    icon: Icons.chat_rounded,
                    onTap: () => _simularCompartilhamento(context, "WhatsApp"),
                  ),
                  _buildRedeButton(
                    label: "Instagram",
                    cor: const Color(0xFFE1306C),
                    icon: Icons.camera_alt_rounded,
                    onTap: () => _simularCompartilhamento(context, "Instagram"),
                  ),
                  _buildRedeButton(
                    label: "LinkedIn",
                    cor: const Color(0xFF0A66C2),
                    icon: Icons.work_rounded,
                    onTap: () => _simularCompartilhamento(context, "LinkedIn"),
                  ),
                  _buildRedeButton(
                    label: "Facebook",
                    cor: const Color(0xFF1877F2),
                    icon: Icons.facebook_rounded,
                    onTap: () => _simularCompartilhamento(context, "Facebook"),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Copiar Link
              OutlinedButton.icon(
                onPressed: () => _copiarLink(context),
                icon: const Icon(Icons.link_rounded,
                    size: 16, color: Color(0xFF0C6B6B)),
                label: const Text(
                  "Copiar Link da Ação",
                  style: TextStyle(
                      color: Color(0xFF0C6B6B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(38),
                  side: const BorderSide(color: Color(0xFF0C6B6B)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConcluir();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0C6B6B),
            minimumSize: const Size.fromHeight(42),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            "Concluir e Voltar ao Painel",
            style: TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildRedeButton({
    required String label,
    required Color cor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: cor, size: 22),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF062222),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
