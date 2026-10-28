// lib/widgets/header/widgets/header_user_menu_modal.dart

import 'package:flutter/material.dart';

import '../../../voluntarios/perfil/meu_perfil_page.dart';
import '../../../ongs/perfil/ong_perfil_page.dart';
import '../../../ongs/home/ong_home_page.dart';
import '../../../ongs/gestao_eventos/gestao_eventos_page.dart';
import '../../../login/login_page.dart';

class HeaderUserMenuModal {
  static void exibir(
    BuildContext context, {
    required String usuarioId,
    required String tipoUsuario,
    required bool isOng,
    required String nomeExibicao,
    required String fotoExibicao,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabeçalho do menu
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(fotoExibicao),
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nomeExibicao,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF062222),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isOng
                                ? const Color(0xFF0C6B6B)
                                : const Color(0xFFD1F5EE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isOng ? "INSTITUIÇÃO PARCEIRA" : "VOLUNTÁRIO ATIVO",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isOng
                                  ? Colors.white
                                  : const Color(0xFF0C6B6B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),

              // Opções de ONG
              if (isOng) ...[
                ListTile(
                  leading: const Icon(Icons.storefront_rounded,
                      color: Color(0xFF0C6B6B)),
                  title: const Text("Perfil da ONG"),
                  subtitle: const Text(
                      "Como os voluntários visualizam sua instituição",
                      style: TextStyle(fontSize: 11)),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OngPerfilPage(
                          ongId: usuarioId,
                          voluntarioId: usuarioId,
                          tipoUsuario: "ong",
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard_rounded,
                      color: Color(0xFF0C6B6B)),
                  title: const Text("Painel da ONG"),
                  subtitle: const Text(
                      "Gestão de vagas, voluntários e métricas",
                      style: TextStyle(fontSize: 11)),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OngHomePage(ongId: usuarioId),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event_note_rounded,
                      color: Color(0xFF0C6B6B)),
                  title: const Text("Gestão de Eventos"),
                  subtitle: const Text(
                      "Criar, editar e acompanhar ações e presenças",
                      style: TextStyle(fontSize: 11)),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GestaoEventosPage(
                          ongId: usuarioId,
                          tipoUsuario: "ong",
                        ),
                      ),
                    );
                  },
                ),
              ] else ...[
                // Opção de Voluntário
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded,
                      color: Color(0xFF0C6B6B)),
                  title: const Text("Meu Perfil de Voluntário"),
                  subtitle: const Text("Ver histórico, causas e habilidades",
                      style: TextStyle(fontSize: 11)),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MeuPerfilPage(
                          usuarioId: usuarioId,
                          tipoUsuario: "voluntario",
                        ),
                      ),
                    );
                  },
                ),
              ],

              // Desconectar
              ListTile(
                leading:
                    const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: const Text("Desconectar",
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
