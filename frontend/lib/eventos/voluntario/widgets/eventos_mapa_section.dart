// lib/eventos/voluntario/widgets/eventos_mapa_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../detalhe/evento_detalhe_page.dart';
import '../../models/evento_model.dart';

class EventosMapaSection extends StatefulWidget {
  final List<EventoModel> eventos;
  final bool isMobile;
  final void Function(EventoModel evento) onAcaoInscricao;
  final String usuarioAtualId;
  final bool isOng;

  const EventosMapaSection({
    super.key,
    required this.eventos,
    required this.isMobile,
    required this.onAcaoInscricao,
    this.usuarioAtualId = "voluntario-1",
    this.isOng = false,
  });

  @override
  State<EventosMapaSection> createState() => _EventosMapaSectionState();
}

class _EventosMapaSectionState extends State<EventosMapaSection> {
  // Ponto central no Grande ABC (Santo André / São Bernardo)
  static const LatLng _centroGrandeABC = LatLng(-23.6638, -46.5383);

  final MapController _mapController = MapController();
  EventoModel? _eventoSelecionado;

  Color _obterCorPorCausa(String causa) {
    switch (causa.toLowerCase()) {
      case 'meio ambiente':
        return const Color(0xFF2E7D32);
      case 'educação':
        return const Color(0xFF1565C0);
      case 'saúde':
        return const Color(0xFFC62828);
      case 'cultura':
        return const Color(0xFF6A1B9A);
      case 'habitação':
      case 'assistência social':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF0C6B6B);
    }
  }

  void _selecionarEvento(EventoModel ev, {bool moverMapa = true}) {
    setState(() => _eventoSelecionado = ev);

    if (moverMapa && ev.latitude != null && ev.longitude != null) {
      _mapController.move(LatLng(ev.latitude!, ev.longitude!), 14.0);
    }
  }

  void _abrirDetalhes(EventoModel ev) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventoDetalhePage(
          eventoId: ev.id,
          usuarioAtualId: widget.usuarioAtualId,
          isOng: widget.isOng,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventosComCoordenadas = widget.eventos
        .where((e) => e.latitude != null && e.longitude != null)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. MAPA WIDESCREEN 16:9
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC2E4DC)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: eventosComCoordenadas.isNotEmpty
                        ? LatLng(
                            eventosComCoordenadas.first.latitude!,
                            eventosComCoordenadas.first.longitude!,
                          )
                        : _centroGrandeABC,
                    initialZoom: 12.0,
                    onTap: (_, __) => setState(() => _eventoSelecionado = null),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.abcdobem.app',
                    ),
                    MarkerLayer(
                      markers: eventosComCoordenadas.map((ev) {
                        final isSelected = _eventoSelecionado?.id == ev.id;
                        final corPin = _obterCorPorCausa(ev.categoria);

                        return Marker(
                          point: LatLng(ev.latitude!, ev.longitude!),
                          width: isSelected ? 46 : 34,
                          height: isSelected ? 46 : 34,
                          child: GestureDetector(
                            onTap: () => _selecionarEvento(ev),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected ? corPin : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.white : corPin,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: isSelected ? Colors.white : corPin,
                                size: isSelected ? 24 : 18,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // Botão de recentralizar
                Positioned(
                  top: 12,
                  right: 12,
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    elevation: 2,
                    tooltip: "Recentralizar no Grande ABC",
                    onPressed: () {
                      _mapController.move(_centroGrandeABC, 12.0);
                      setState(() => _eventoSelecionado = null);
                    },
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: Color(0xFF0C6B6B),
                      size: 20,
                    ),
                  ),
                ),

                // Card flutuante compacto sobre o mapa
                if (_eventoSelecionado != null)
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: _buildCardFlutuante(_eventoSelecionado!),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 2. CABEÇALHO DA LISTA VERTICAL
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.isMobile
                    ? "Eventos próximos (${eventosComCoordenadas.length})"
                    : "Eventos próximos no Grande ABC (${eventosComCoordenadas.length})",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.isMobile
                  ? "Toque no mapa"
                  : "Toque para ver no mapa e detalhes",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 3. LISTA VERTICAL DE EVENTOS
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: eventosComCoordenadas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final ev = eventosComCoordenadas[index];
            final isSelected = _eventoSelecionado?.id == ev.id;
            final corCausa = _obterCorPorCausa(ev.categoria);

            return InkWell(
              onTap: () {
                _selecionarEvento(ev);
                _abrirDetalhes(ev);
              },
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0C6B6B)
                        : const Color(0xFFC2E4DC),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: isSelected ? 0.08 : 0.02),
                      blurRadius: isSelected ? 6 : 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        ev.imagemUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 70,
                          height: 70,
                          color: const Color(0xFFD1F5EE),
                          child: Icon(Icons.event, color: corCausa),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: corCausa.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ev.categoria,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: corCausa,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                ev.data,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0C6B6B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ev.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF062222),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${ev.ongNome} • ${ev.cidade}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => widget.onAcaoInscricao(ev),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color(0xFF0C6B6B)
                            : const Color(0xFFD1F5EE),
                        foregroundColor:
                            isSelected ? Colors.white : const Color(0xFF0C6B6B),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        ev.isInscrito ? "Inscrito" : "Participar",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCardFlutuante(EventoModel ev) {
    return InkWell(
      onTap: () => _abrirDetalhes(ev),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF9FE8D8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ev.imagemUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 50,
                  height: 50,
                  color: const Color(0xFFD1F5EE),
                  child: const Icon(Icons.event,
                      color: Color(0xFF0C6B6B), size: 22),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ev.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF062222),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${ev.ongNome} • ${ev.cidade}",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFF0C6B6B),
            ),
          ],
        ),
      ),
    );
  }
}
