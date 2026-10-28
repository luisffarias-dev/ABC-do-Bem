// lib/eventos/detalhe/widgets/evento_detalhe_localizacao_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/evento_model.dart';

class EventoDetalheLocalizacaoSection extends StatelessWidget {
  final EventoModel evento;
  final bool isDono;
  final VoidCallback? onEditarEndereco;

  const EventoDetalheLocalizacaoSection({
    super.key,
    required this.evento,
    required this.isDono,
    this.onEditarEndereco,
  });

  // Ponto padrão central no Grande ABC caso latitude ou longitude sejam nulas
  static const LatLng _pontoPadraoGrandeABC = LatLng(-23.6638, -46.5383);

  bool get _temCoordenadasValidas {
    final lat = evento.latitude;
    final lng = evento.longitude;
    if (lat == null || lng == null) return false;
    if (lat.isNaN || lng.isNaN) return false;
    return lat >= -90.0 && lat <= 90.0 && lng >= -180.0 && lng <= 180.0;
  }

  void _copiarEndereco(BuildContext context) {
    final endereco = (evento.endereco ?? '').trim();
    final cidade = evento.cidade.trim();
    final textoCompleto = [
      if (endereco.isNotEmpty) endereco,
      if (cidade.isNotEmpty) cidade,
    ].join(' - ');

    if (textoCompleto.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: textoCompleto));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Endereço copiado para a área de transferência!"),
          backgroundColor: Color(0xFF0C6B6B),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool coordenadasValidas = _temCoordenadasValidas;
    final LatLng pontoFinal = coordenadasValidas
        ? LatLng(evento.latitude!, evento.longitude!)
        : _pontoPadraoGrandeABC;

    final String enderecoExibicao =
        (evento.endereco != null && evento.endereco!.trim().isNotEmpty)
            ? "${evento.endereco!.trim()} - ${evento.cidade}"
            : "${evento.cidade} (Endereço exato a confirmar com a organização)";

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:
            MainAxisSize.min, // Previne que a Column force altura infinita
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ponto de Encontro",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF062222),
                ),
              ),
              if (isDono)
                TextButton.icon(
                  onPressed: onEditarEndereco,
                  icon: const Icon(Icons.edit_location_alt_outlined, size: 14),
                  label: const Text("Editar Local",
                      style: TextStyle(fontSize: 11)),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0C6B6B),
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: Color(0xFF0C6B6B), size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  enderecoExibicao,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Contêiner com altura fixa rígida para eliminar qualquer erro de Unbounded Height
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: double.infinity,
              height:
                  190, // Altura explícita garantida contra constraints infinitas
              child: coordenadasValidas
                  ? FlutterMap(
                      options: MapOptions(
                        initialCenter: pontoFinal,
                        initialZoom: 15.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag
                              .none, // Desativa gestos acidentais durante o scroll da página
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.abcdobem.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: pontoFinal,
                              width: 38,
                              height: 38,
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: Color(0xFF0C6B6B),
                                size: 38,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      color: const Color(0xFFD1F5EE),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.map_outlined,
                                color: Color(0xFF0C6B6B), size: 30),
                            SizedBox(height: 6),
                            Text(
                              "Localização no mapa pendente de confirmação",
                              style: TextStyle(
                                color: Color(0xFF0C6B6B),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _copiarEndereco(context),
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text("Copiar Endereço Completo"),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0C6B6B),
                side: const BorderSide(color: Color(0xFF0C6B6B)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
