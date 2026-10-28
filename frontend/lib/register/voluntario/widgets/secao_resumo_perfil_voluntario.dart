// lib/register/voluntario/widgets/secao_resumo_perfil_voluntario.dart

import 'package:flutter/material.dart';

class SecaoResumoPerfilVoluntario extends StatelessWidget {
  final Map<String, String> dadosBasicos;
  final List<String> habilidadesSelecionadas;
  final bool isMobile;

  const SecaoResumoPerfilVoluntario({
    super.key,
    required this.dadosBasicos,
    required this.habilidadesSelecionadas,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final nomeCompleto =
        "${dadosBasicos['nome'] ?? ''} ${dadosBasicos['sobrenome'] ?? ''}"
            .trim();
    final email = dadosBasicos['email'] ?? 'Não informado';
    final telefone = dadosBasicos['telefone'] ?? 'Não informado';
    final cidadeEstado =
        "${dadosBasicos['cidade'] ?? ''} - ${dadosBasicos['estado'] ?? ''}"
            .trim();
    final bool temSenha =
        (dadosBasicos['senha'] ?? dadosBasicos['password'] ?? '').isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F5F1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_pin_rounded,
                  color: Color(0xFF0C6B6B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Resumo do Seu Perfil",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE3F5F1)),
          const SizedBox(height: 14),

          // Nome e Cidade/Estado
          if (isMobile) ...[
            _itemDado("Nome Completo", nomeCompleto, Icons.badge_outlined),
            const SizedBox(height: 10),
            _itemDado("Localidade", cidadeEstado, Icons.location_on_outlined),
          ] else
            Row(
              children: [
                Expanded(
                  child: _itemDado(
                    "Nome Completo",
                    nomeCompleto,
                    Icons.badge_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _itemDado(
                    "Localidade",
                    cidadeEstado,
                    Icons.location_on_outlined,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),

          // E-mail e Celular / WhatsApp
          if (isMobile) ...[
            _itemDado(
                "E-mail de Contato & Acesso", email, Icons.email_outlined),
            const SizedBox(height: 10),
            _itemDado(
              "Celular / WhatsApp",
              telefone,
              Icons.phone_android_rounded,
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: _itemDado(
                    "E-mail de Contato & Acesso",
                    email,
                    Icons.email_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _itemDado(
                    "Celular / WhatsApp",
                    telefone,
                    Icons.phone_android_rounded,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 12),

          // Credencial de Acesso mascarada
          _itemDado(
            "Senha de Acesso",
            temSenha ? "•••••••• (Definida)" : "Não informada",
            Icons.lock_outline_rounded,
          ),

          const SizedBox(height: 16),
          const Text(
            "Causas & Habilidades Selecionadas:",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A6868),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: habilidadesSelecionadas.map((hab) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FAF7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: Text(
                  hab,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0C6B6B),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _itemDado(String label, String valor, IconData icone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 16, color: const Color(0xFF0C6B6B)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF7AAAA0),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                valor.isNotEmpty ? valor : "-",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
