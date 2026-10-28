// lib/voluntarios/home/widgets/home_impact_gallery_section.dart

import 'package:flutter/material.dart';
import '../../../eventos/models/evento_model.dart';

class HomeImpactGallerySection extends StatelessWidget {
  final List<EventoModel> eventos;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final Function(String) onAbrirDetalhes;
  final VoidCallback onVerTodos;
  final bool isMobile;

  const HomeImpactGallerySection({
    super.key,
    required this.eventos,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.onAbrirDetalhes,
    required this.onVerTodos,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.verified_rounded,
                    color: Color(0xFF0C6B6B), size: 20),
                SizedBox(width: 6),
                Text(
                  "Meus eventos",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062222),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavArrow(
                  icon: Icons.arrow_back_ios_new_rounded,
                  ativo: currentPage > 0,
                  onTap: () => pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
                const SizedBox(width: 6),
                _buildNavArrow(
                  icon: Icons.arrow_forward_ios_rounded,
                  ativo: currentPage < eventos.length - 1,
                  onTap: () => pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onVerTodos,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Ver todos",
                    style: TextStyle(
                      color: Color(0xFF0C6B6B),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: isMobile ? 220 : 190,
          child: PageView.builder(
            controller: pageController,
            itemCount: eventos.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final ev = eventos[index];
              return _buildCard(ev);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(eventos.length, (idx) {
            final ativo = idx == currentPage;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: ativo ? 16 : 6,
              height: 5,
              decoration: BoxDecoration(
                color:
                    ativo ? const Color(0xFF0C6B6B) : const Color(0xFFC2E4DC),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildNavArrow({
    required IconData icon,
    required bool ativo,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: ativo ? onTap : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: ativo ? Colors.white : Colors.grey.shade100,
          shape: BoxShape.circle,
          border: Border.all(
            color: ativo ? const Color(0xFFC2E4DC) : Colors.grey.shade300,
          ),
        ),
        child: Icon(
          icon,
          size: 12,
          color: ativo ? const Color(0xFF0C6B6B) : Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildCard(EventoModel ev) {
    return InkWell(
      onTap: () => onAbrirDetalhes(ev.id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF9FE8D8)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    ev.imagemUrl,
                    height: 95,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1F5EE),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "Inscrição Confirmada ✓",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0C6B6B),
                                ),
                              ),
                            ),
                            Text(
                              "${ev.data} • ${ev.horario}",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ev.titulo,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF062222),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${ev.ongNome} (${ev.cidade})",
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF7AAAA0)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(16)),
                    child: Image.network(
                      ev.imagemUrl,
                      width: 240,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1F5EE),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Presença Confirmada ✓",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0C6B6B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ev.titulo,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF062222),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${ev.ongNome} • ${ev.cidade}",
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF7AAAA0)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "📅 ${ev.data} • Horário: ${ev.horario}",
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
