// test/unit/models/voluntario_profile_models_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:abc_do_bem/voluntarios/models/voluntario_profile_models.dart';

void main() {
  group('Testes Unitários - VoluntarioPerfilModel', () {
    test(
        'Deve instanciar corretamente a partir de um JSON parcial com fallbacks',
        () {
      final jsonMock = {
        'id': 'vol-10',
        'nome': 'Douglas Oliveira',
        'cidade': 'Mauá',
        'totalHoras': 35,
        'experiencias': [
          {
            'id': 'exp-1',
            'ongNome': 'Reforço Mauá',
            'dataFormatada': 'Há 2 dias',
            'texto': 'Ação educativa com turmas do ensino fundamental.',
            'curtidas': 5,
          }
        ],
      };

      final perfil = VoluntarioPerfilModel.fromJson(jsonMock);

      expect(perfil.id, equals('vol-10'));
      expect(perfil.nome, equals('Douglas Oliveira'));
      expect(perfil.cidade, equals('Mauá'));
      expect(perfil.totalHoras, equals(35));
      expect(perfil.estado, equals('SP')); // Fallback padrão
      expect(perfil.experiencias.length, equals(1));
      expect(perfil.experiencias.first.ongNome, equals('Reforço Mauá'));
    });

    test(
        'copyWith deve atualizar apenas campos específicos preservando os demais',
        () {
      const perfilOriginal = VoluntarioPerfilModel(
        id: 'vol-1',
        nome: 'Ana Silva',
        cpf: '123.456.789-00',
        nascimento: '15/05/1995',
        cidade: 'Santo André',
        estado: 'SP',
        cep: '09000-000',
        logradouro: 'Rua das Flores',
        numero: '123',
        bairro: 'Centro',
        fotoUrl: 'https://exemplo.com/foto_antiga.jpg',
        bannerUrl: 'https://exemplo.com/banner.jpg',
        totalEventos: 10,
        totalHoras: 80,
        tempoAtivo: '2a',
        bio: 'Bio voluntária',
        habilidades: ['Educação'],
        disponibilidade: ['Manhãs'],
        escolaridade: 'Superior',
        curso: 'Pedagogia',
        experiencias: [],
      );

      final perfilAtualizado = perfilOriginal.copyWith(
        fotoUrl: 'https://exemplo.com/nova_foto.png',
        totalHoras: 85,
      );

      expect(perfilAtualizado.fotoUrl,
          equals('https://exemplo.com/nova_foto.png'));
      expect(perfilAtualizado.totalHoras, equals(85));
      expect(perfilAtualizado.nome, equals('Ana Silva'));
      expect(perfilAtualizado.cidade, equals('Santo André'));
      expect(perfilAtualizado.habilidades, equals(['Educação']));
    });
  });
}
