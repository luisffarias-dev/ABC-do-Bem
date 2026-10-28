// lib/services/nlp/ia_sugestao_causa_service.dart

import '../../utils/app_data.dart';
import 'vocabulario_causas.dart';

class IaSugestaoCausaService {
  static final RegExp _emojiRegex = RegExp(
    r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F1E0}-\u{1F1FF}]',
    unicode: true,
  );

  /// Remove emojis e espaços extras mantendo a pontuação e acentos normais
  static String removerEmojis(String texto) {
    return texto.replaceAll(_emojiRegex, '').trim();
  }

  /// Normaliza o texto para indexação (sem emojis, sem acentos, minúsculo)
  static String limparParaComparacao(String texto) {
    const comAcento = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖòóôõöÈÉÊËèéêëÌÍÎÏìíîïÙÚÛÜùúûüÇçÑñ';
    const semAcento = 'AAAAAAaaaaaaOOOOOoooooEEEEeeeeIIIIiiiiUUUUuuuuCcNn';

    String limpo = removerEmojis(texto);

    for (int i = 0; i < comAcento.length; i++) {
      limpo = limpo.replaceAll(comAcento[i], semAcento[i]);
    }

    return limpo.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]'), ' ').trim();
  }

  /// Retorna a lista oficial de causas do AppData com os nomes limpos (sem emojis)
  static List<String> obterCausasLimpos() {
    return AppData.habilidadesPorCausa.keys.map(removerEmojis).toList();
  }

  /// Analisa o título do evento e retorna as causas ordenadas (sem emojis)
  static List<String> inferirCausas(String titulo) {
    final textoLimpo = limparParaComparacao(titulo);
    if (textoLimpo.length < 3) return [];

    final tokens = textoLimpo
        .split(RegExp(r'\s+'))
        .where((t) => t.length > 2 && !VocabularioCausas.stopWords.contains(t))
        .toList();

    final Map<String, int> pontuacao = {};

    for (final causaChaveOriginal in AppData.habilidadesPorCausa.keys) {
      final causaNomeLimpo = removerEmojis(causaChaveOriginal);
      final causaComparacao = limparParaComparacao(causaChaveOriginal);
      pontuacao[causaNomeLimpo] = 0;

      // 1. Nome exato da causa no título digitado
      if (textoLimpo.contains(causaComparacao)) {
        pontuacao[causaNomeLimpo] = (pontuacao[causaNomeLimpo] ?? 0) +
            VocabularioCausas.pesoNomeExatoCausa;
      }

      // 2. Correspondência com habilidades do AppData
      final habilidades = AppData.habilidadesPorCausa[causaChaveOriginal] ?? [];
      for (final hab in habilidades) {
        final habLimpa = limparParaComparacao(hab);
        if (habLimpa.length > 3 && textoLimpo.contains(habLimpa)) {
          pontuacao[causaNomeLimpo] = (pontuacao[causaNomeLimpo] ?? 0) +
              VocabularioCausas.pesoHabilidadeAppData;
        }
      }

      // 3. Correspondência com doações do AppData
      final doacoes = AppData.doacoesPorCausa[causaChaveOriginal] ?? [];
      for (final doacao in doacoes) {
        final doacaoLimpa = limparParaComparacao(doacao);
        if (doacaoLimpa.length > 3 &&
            doacaoLimpa != "outros" &&
            textoLimpo.contains(doacaoLimpa)) {
          pontuacao[causaNomeLimpo] = (pontuacao[causaNomeLimpo] ?? 0) +
              VocabularioCausas.pesoDoacaoAppData;
        }
      }

      // 4. Termos e expressões do vocabulário léxico especializado
      final chaveVocabulario =
          VocabularioCausas.dicionarioPorCausa.keys.firstWhere(
        (k) => limparParaComparacao(k) == causaComparacao,
        orElse: () => '',
      );

      final termosExtras =
          VocabularioCausas.dicionarioPorCausa[chaveVocabulario] ?? [];

      for (final termo in termosExtras) {
        // Expressões compostas (ex: "cesta basica", "reforco escolar")
        if (termo.contains(' ') && textoLimpo.contains(termo)) {
          pontuacao[causaNomeLimpo] = (pontuacao[causaNomeLimpo] ?? 0) +
              VocabularioCausas.pesoExpressaoComposta;
          continue;
        }

        // Unigramas e radicais
        for (final token in tokens) {
          if (token == termo) {
            pontuacao[causaNomeLimpo] = (pontuacao[causaNomeLimpo] ?? 0) +
                VocabularioCausas.pesoTermoExatoVocabulario;
          } else if (token.length >= 4 && termo.length >= 4) {
            if (token.startsWith(termo) || termo.startsWith(token)) {
              pontuacao[causaNomeLimpo] = (pontuacao[causaNomeLimpo] ?? 0) +
                  VocabularioCausas.pesoPrefixoRadical;
            }
          }
        }
      }
    }

    final resultados = pontuacao.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return resultados.map((e) => e.key).toList();
  }
}
