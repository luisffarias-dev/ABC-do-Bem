// lib/widgets/impact_gallery_section.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/responsive.dart';

// Dados para o carrossel de ações realizadas
final List<Map<String, String>> galleryItems = [
  {
    "image":
        "https://plus.unsplash.com/premium_photo-1681152783648-29c9c15b56ed?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "title": "Mutirão de Revitalização",
    "local": "📍 Mauá",
  },
  {
    "image":
        "https://images.unsplash.com/photo-1599059813005-11265ba4b4ce?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "title": "Arrecadação de Alimentos",
    "local": "📍 Santo André",
  },
  {
    "image":
        "https://images.unsplash.com/photo-1526976668912-1a811878dd37?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "title": "Apoio Escolar Comunitário",
    "local": "📍 São Bernardo do Campo",
  },
  {
    "image":
        "https://images.unsplash.com/photo-1559027615-cd4628902d4a?q=80&w=1174&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "title": "Feira de Adoção Pet",
    "local": "📍 São Caetano do Sul",
  },
  {
    "image":
        "https://plus.unsplash.com/premium_photo-1661775317533-2163ba4dbc93?q=80&w=1174&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "title": "Pintura da Casa de Apoio aos Imigrantes",
    "local": "📍 Mauá",
  },
  {
    "image":
        "https://images.unsplash.com/photo-1565803974275-dccd2f933cbb?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "title": "Limpeza da Prainha da Represa Billings",
    "local": "📍 São Bernardo do Campo",
  },
];

class ImpactGallerySection extends StatefulWidget {
  const ImpactGallerySection({super.key});

  @override
  State<ImpactGallerySection> createState() => _ImpactGallerySectionState();
}

class _ImpactGallerySectionState extends State<ImpactGallerySection> {
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % galleryItems.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildCard(Map<String, String> item, {double? width}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Container(
        key: ValueKey<String>(item["title"]!),
        width: width,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                item["image"]!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFC7EBE3),
                  child: const Icon(
                    Icons.image_not_supported_rounded,
                    color: Color(0xFF0C6B6B),
                    size: 40,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF062222).withOpacity(0.85),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3DCFB0).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item["local"]!,
                        style: const TextStyle(
                          color: Color(0xFF062222),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    final item1 = galleryItems[currentIndex];
    final item2 = galleryItems[(currentIndex + 1) % galleryItems.length];
    final item3 = galleryItems[(currentIndex + 2) % galleryItems.length];

    return Container(
      width: double.infinity,
      color: const Color(0xFFF0FAF7),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 64,
        horizontal: isMobile ? 16 : 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Impacto Real",
                style: TextStyle(
                  fontSize: isMobile ? 26 : 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF062222),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Veja um pouco do que nossa rede já transformou no ABC",
                style: TextStyle(
                  color: const Color(0xFF3A6868),
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 14 : 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 32 : 48),

              // Layout adaptativo: Row com Expanded no desktop, card único no mobile
              if (isDesktop)
                Row(
                  children: [
                    Expanded(child: _buildCard(item1)),
                    const SizedBox(width: 20),
                    Expanded(child: _buildCard(item2)),
                    const SizedBox(width: 20),
                    Expanded(child: _buildCard(item3)),
                  ],
                )
              else
                _buildCard(item1, width: double.infinity),

              const SizedBox(height: 24),

              // Indicadores de paginação (Dots)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(galleryItems.length, (index) {
                  final bool isActive = currentIndex == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: isActive ? 24 : 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF0C6B6B)
                          : const Color(0xFFC2E4DC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
