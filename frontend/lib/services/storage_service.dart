// lib/services/storage_service.dart

import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Faz o upload dos bytes da imagem e retorna a URL pública final
  Future<String> uploadFotoPerfil({
    required String usuarioId,
    required Uint8List bytes,
    required String extensao,
  }) async {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$usuarioId/avatar_$timestamp.$extensao';

    // 1. Envio para o bucket 'avatars'
    await _supabase.storage.from('avatars').uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(
            contentType: 'image/$extensao',
            upsert: true,
          ),
        );

    // 2. Obtenção da URL pública acessível
    final String publicUrl =
        _supabase.storage.from('avatars').getPublicUrl(filePath);

    return publicUrl;
  }
}
