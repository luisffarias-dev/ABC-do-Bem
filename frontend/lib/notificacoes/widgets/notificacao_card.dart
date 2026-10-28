// lib/notificacoes/widgets/notificacao_card.dart

import 'package:flutter/material.dart';
import '../../models/notification_models.dart';

class NotificacaoCard extends StatelessWidget {
  final NotificacaoModel notificacao;
  final bool isMobile;
  final VoidCallback onTap;

  const NotificacaoCard({
    super.key,
    required this.notificacao,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNaoLida = !notificacao.lida;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNaoLida ? const Color(0xFF9FE8D8) : const Color(0xFFC2E4DC),
          width: isNaoLida ? 1.5 : 1,
        ),
        boxShadow: isNaoLida
            ? [
                BoxShadow(
                  color: const Color(0xFF0C6B6B).withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: notificacao.corTema.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(notificacao.icone,
                    color: notificacao.corTema, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notificacao.titulo,
                            style: TextStyle(
                              fontWeight:
                                  isNaoLida ? FontWeight.bold : FontWeight.w600,
                              fontSize: isMobile ? 13 : 14,
                              color: const Color(0xFF062222),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          notificacao.dataRelativa,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notificacao.descricaoCurta,
                      style: TextStyle(
                        fontSize: 12,
                        color: isNaoLida
                            ? const Color(0xFF3A6868)
                            : Colors.grey.shade600,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isNaoLida) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0C6B6B),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
