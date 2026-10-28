// lib/utils/app_data.dart

class AppData {
  // --- REGRAS DE NEGÓCIO GLOBAIS ---
  static const int minHabilidades = 3;
  static const int maxHabilidades = 12;

  // --- CATEGORIAS COMPLETAS DE HABILIDADES (DO REGISTER STEP 2) ---
  static const Map<String, List<String>> categoriasHabilidades = {
    "🧠 Habilidades pessoais": [
      "Liderança",
      "Trabalho em equipe",
      "Comunicação",
      "Organização",
      "Empatia",
      "Proatividade",
      "Criatividade",
      "Resolução de problemas",
      "Flexibilidade",
      "Responsabilidade",
      "Paciência",
      "Adaptabilidade",
      "Escuta ativa",
    ],
    "📊 Administração e gestão": [
      "Administração",
      "Gestão de projetos",
      "Gestão de pessoas",
      "Recursos humanos",
      "Finanças",
      "Contabilidade",
      "Planejamento",
      "Organização",
      "Compras",
      "Gestão de documentos",
      "Processos administrativos",
    ],
    "🌱 Agricultura e Meio Ambiente": [
      "Agricultura",
      "Jardinagem",
      "Agroecologia",
      "Permacultura",
      "Reciclagem",
      "Gestão de resíduos",
      "Reflorestamento",
      "Conservação ambiental",
      "Educação ambiental",
    ],
    "🍳 Alimentação e hospitalidade": [
      "Cozinha",
      "Panificação e confeitaria",
      "Alimentação",
      "Atendimento",
      "Recepção",
      "Hotelaria",
      "Limpeza",
      "Organização de espaços",
      "Hospedagem",
    ],
    "🐶 Animais e cuidados veterinários": [
      "Veterinária",
      "Cuidados com animais",
      "Adestramento",
      "Resgate animal",
      "Abrigos e proteção animal",
      "Transporte de animais",
      "Adoção e divulgação",
    ],
    "📋 Apoio geral": [
      "Organização",
      "Limpeza",
      "Apoio operacional",
      "Separação e distribuição de doações",
      "Atendimento",
      "Eventos",
      "Cadastro e documentação",
      "Pesquisa",
      "Divulgação",
      "Apoio em atividades",
      "Trabalho manual",
      "Serviços gerais",
    ],
    "🎨 Artes e cultura": [
      "Artes visuais",
      "Música",
      "Teatro",
      "Dança",
      "Artesanato",
      "Fotografia",
      "Audiovisual",
      "Escrita",
      "Produção cultural",
      "Atividades criativas",
    ],
    "💰 Captação de recursos": [
      "Captação de doações",
      "Fundraising",
      "Elaboração de projetos",
      "Editais",
      "Patrocínios",
      "Parcerias",
      "Eventos beneficentes",
      "Campanhas de arrecadação",
      "Vendas",
    ],
    "🗣️ Comunicação e idiomas": [
      "Inglês",
      "Espanhol",
      "Tradução e interpretação",
      "Comunicação",
      "Oratória",
      "Escrita",
      "Jornalismo",
      "Atendimento ao público",
      "Mediação",
    ],
    "🔨 Construção e manutenção": [
      "Pedreiro",
      "Elétrica",
      "Hidráulica",
      "Pintura",
      "Marcenaria",
      "Serralheria",
      "Manutenção geral",
      "Jardinagem",
      "Reparos e instalações",
    ],
    "👩‍🏫 Educação": [
      "Ensino",
      "Reforço escolar",
      "Alfabetização",
      "Idiomas",
      "Matemática e ciências",
      "Informática e tecnologia",
      "Artes",
      "Esportes",
      "Mentoria",
      "Orientação profissional",
      "Capacitação e treinamento",
    ],
    "⚖️ Jurídico e documentação": [
      "Direito",
      "Orientação jurídica",
      "Contratos",
      "Documentação",
      "Regularização",
      "Mediação",
      "Proteção de dados",
      "Compliance",
    ],
    "📣 Marketing e comunicação digital": [
      "Marketing",
      "Redes sociais",
      "Criação de conteúdo",
      "Publicidade",
      "Comunicação institucional",
      "Relações públicas",
      "Fotografia",
      "Vídeo e audiovisual",
      "Design gráfico",
    ],
    "🧑‍⚕️ Saúde e bem-estar": [
      "Medicina",
      "Enfermagem",
      "Odontologia",
      "Psicologia",
      "Fisioterapia",
      "Nutrição",
      "Terapias",
      "Educação física",
      "Primeiros socorros",
      "Cuidados e bem-estar",
    ],
    "💻 Tecnologia": [
      "Desenvolvimento de software",
      "Desenvolvimento web",
      "Desenvolvimento de aplicativos",
      "Tecnologia da informação",
      "Suporte técnico",
      "Dados e análise",
      "Automação",
      "Inteligência artificial",
      "Informática",
      "Design digital",
    ],
    "🤝 Trabalho social e comunitário": [
      "Assistência social",
      "Trabalho comunitário",
      "Acolhimento",
      "Apoio a famílias",
      "Trabalho com crianças",
      "Trabalho com jovens",
      "Trabalho com idosos",
      "Inclusão social",
      "Inclusão de pessoas com deficiência",
      "Mobilização comunitária",
      "Mentoria",
    ],
    "🚗 Transporte e logística": [
      "Transporte",
      "Motorista",
      "Entregas",
      "Logística",
      "Estoque",
      "Distribuição",
      "Organização de materiais",
      "Carga e descarga",
      "Manutenção de veículos",
      "Apoio em eventos",
    ],
  };

  // --- FORMATOS DE VOLUNTARIADO ---
  static const List<String> formatosVoluntariado = [
    "Apenas Presencial",
    "Apenas Remoto (Online)",
    "Híbrido (Presencial e Remoto)",
  ];

  // --- HABILIDADES POR CAUSA (ONG / VOLUNTÁRIO) ---
  static const Map<String, List<String>> habilidadesPorCausa = {
    "🤝 Apoio humanitário": [
      "Apoio operacional",
      "Escuta ativa",
      "Tradução e interpretação",
      "Primeiros socorros",
      "Empatia",
      "Responsabilidade",
      "Organização",
    ],
    "🫂 Assistência social": [
      "Atendimento",
      "Apoio a famílias",
      "Apoio operacional",
      "Separação e distribuição de doações",
      "Cadastro e documentação",
      "Assistência social",
      "Escuta ativa",
      "Empatia",
    ],
    "💻 Ciência e tecnologia": [
      "Informática e tecnologia",
      "Desenvolvimento de software",
      "Desenvolvimento web",
      "Desenvolvimento de aplicativos",
      "Tecnologia da informação",
      "Suporte técnico",
      "Inteligência artificial",
    ],
    "🍲 Combate à pobreza": [
      "Cozinha",
      "Panificação e confeitaria",
      "Logística",
      "Distribuição",
      "Estoque",
      "Separação e distribuição de doações",
      "Trabalho manual",
    ],
    "🧒 Crianças e adolescentes": [
      "Reforço escolar",
      "Alfabetização",
      "Artes",
      "Esportes",
      "Teatro",
      "Música",
      "Mentoria",
      "Trabalho com crianças",
      "Paciência",
    ],
    "🎨 Cultura": [
      "Artes visuais",
      "Música",
      "Teatro",
      "Dança",
      "Artesanato",
      "Fotografia",
      "Audiovisual",
      "Escrita",
      "Produção cultural",
      "Criatividade",
    ],
    "🏘️ Desenvolvimento comunitário": [
      "Trabalho comunitário",
      "Mobilização comunitária",
      "Gestão de projetos",
      "Planejamento",
      "Educação ambiental",
      "Comunicação",
      "Liderança",
    ],
    "⚖️ Direitos humanos": [
      "Direito",
      "Orientação jurídica",
      "Mediação",
      "Proteção de dados",
      "Compliance",
      "Comunicação",
      "Empatia",
    ],
    "📚 Educação": [
      "Ensino",
      "Reforço escolar",
      "Alfabetização",
      "Idiomas",
      "Matemática e ciências",
      "Capacitação e treinamento",
      "Mentoria",
      "Organização",
    ],
    "💼 Emprego e capacitação profissional": [
      "Capacitação e treinamento",
      "Orientação profissional",
      "Recursos humanos",
      "Administração",
      "Planejamento",
      "Comunicação",
      "Oratória",
    ],
    "⚽ Esporte": [
      "Esportes",
      "Educação física",
      "Eventos",
      "Organização",
      "Trabalho em equipe",
      "Liderança",
    ],
    "🏠 Habitação": [
      "Pedreiro",
      "Elétrica",
      "Hidráulica",
      "Pintura",
      "Marcenaria",
      "Serralheria",
      "Manutenção geral",
      "Reparos e instalações",
    ],
    "👴 Idosos": [
      "Trabalho com idosos",
      "Cuidados e bem-estar",
      "Fisioterapia",
      "Enfermagem",
      "Paciência",
      "Empatia",
      "Acolhimento",
    ],
    "🤝 Inclusão social": [
      "Inclusão social",
      "Inclusão de pessoas com deficiência",
      "Acolhimento",
      "Assistência social",
      "Escuta ativa",
      "Empatia",
      "Flexibilidade",
    ],
    "🌱 Meio ambiente": [
      "Agricultura",
      "Jardinagem",
      "Agroecologia",
      "Permacultura",
      "Reciclagem",
      "Gestão de resíduos",
      "Reflorestamento",
      "Conservação ambiental",
      "Educação ambiental",
    ],
    "👩 Mulheres": [
      "Acolhimento",
      "Psicologia",
      "Orientação jurídica",
      "Assistência social",
      "Escuta ativa",
      "Empatia",
      "Comunicação",
    ],
    "♿ Pessoas com deficiência": [
      "Inclusão de pessoas com deficiência",
      "Fisioterapia",
      "Terapias",
      "Psicologia",
      "Acolhimento",
      "Paciência",
      "Empatia",
    ],
    "🐾 Proteção animal": [
      "Veterinária",
      "Cuidados com animais",
      "Adestramento",
      "Resgate animal",
      "Abrigos e proteção animal",
      "Transporte de animais",
      "Adoção e divulgação",
    ],
    "🏥 Saúde": [
      "Medicina",
      "Enfermagem",
      "Odontologia",
      "Psicologia",
      "Nutrição",
      "Primeiros socorros",
      "Cuidados e bem-estar",
      "Responsabilidade",
    ],
    "🍽️ Segurança alimentar": [
      "Cozinha",
      "Nutrição",
      "Logística",
      "Distribuição",
      "Estoque",
      "Separação e distribuição de doações",
      "Organização",
    ],
  };

  // --- DOAÇÕES POR CAUSA ---
  static const Map<String, List<String>> doacoesPorCausa = {
    "🤝 Apoio humanitário": [
      "Alimentos não perecíveis",
      "Água potável",
      "Kits de higiene pessoal e limpeza",
      "Roupas, cobertores e calçados",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🫂 Assistência social": [
      "Alimentos não perecíveis",
      "Roupas, calçados e enxovais",
      "Produtos de higiene e limpeza",
      "Brinquedos",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "💻 Ciência e tecnologia": [
      "Equipamentos Eletrônicos (PCs, Celulares, Tablets)",
      "Peças de hardware",
      "Periféricos",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🍲 Combate à pobreza": [
      "Alimentos não perecíveis",
      "Alimentos perecíveis",
      "Roupas e Calçados",
      "Produtos de Higiene Pessoal",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🧒 Crianças e adolescentes": [
      "Material Escolar",
      "Livros infantis",
      "Brinquedos",
      "Roupas e Calçados",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🎨 Cultura": [
      "Instrumentos musicais",
      "Livros",
      "Equipamentos Eletrônicos (Som, Luz, Foto)",
      "Material Escolar/Artesanato",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🏘️ Desenvolvimento comunitário": [
      "Materiais de Construção",
      "Móveis e Eletrodomésticos",
      "Equipamentos Eletrônicos",
      "Produtos de Limpeza",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "⚖️ Direitos humanos": [
      "Material Escolar/Escritório",
      "Equipamentos Eletrônicos (PCs, Celulares)",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "📚 Educação": [
      "Material Escolar",
      "Livros didáticos",
      "Equipamentos Eletrônicos",
      "Móveis e Eletrodomésticos",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "💼 Emprego e capacitação profissional": [
      "Material Escolar/Escritório",
      "Roupas e Calçados (Vestuário profissional)",
      "Equipamentos Eletrônicos",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "⚽ Esporte": [
      "Material esportivo (Bolas, Redes)",
      "Roupas e Calçados (Chuteiras, Tênis)",
      "Troféus e medalhas",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🏠 Habitação": [
      "Materiais de Construção",
      "Móveis e Eletrodomésticos",
      "Ferramentas",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "👴 Idosos": [
      "Fraldas geriátricas",
      "Produtos de Higiene Pessoal",
      "Medicamentos",
      "Alimentos não perecíveis",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🤝 Inclusão social": [
      "Roupas e Calçados",
      "Produtos de Higiene Pessoal",
      "Alimentos não perecíveis",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🌱 Meio Ambiente": [
      "Mudas e sementes",
      "Ferramentas de jardinagem",
      "Materiais recicláveis",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "👩 Mulheres": [
      "Produtos de Higiene Pessoal (Absorventes)",
      "Roupas e Calçados",
      "Alimentos não perecíveis",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "♿ Pessoas com deficiência": [
      "Equipamentos de mobilidade (Cadeiras de rodas)",
      "Tecnologia assistiva",
      "Medicamentos",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🐾 Proteção animal": [
      "Ração e Itens Pet",
      "Medicamentos veterinários",
      "Produtos de Limpeza",
      "Caminhas e cobertores",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🏥 Saúde": [
      "Medicamentos",
      "Insumos hospitalares",
      "Produtos de Higiene Pessoal",
      "Fraldas",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
    "🍽️ Segurança alimentar": [
      "Alimentos perecíveis",
      "Alimentos não perecíveis",
      "Utensílios de cozinha",
      "Produtos de Limpeza",
      "Doações Financeiras (Pix/Conta)",
      "Outros",
    ],
  };

  // --- MÉTODOS AUXILIARES GLOBAIS ---
  static List<String> get todasHabilidades {
    final Set<String> todas = {};
    for (var lista in categoriasHabilidades.values) {
      todas.addAll(lista);
    }
    final listaOrdenada = todas.toList()..sort();
    return listaOrdenada;
  }

  static List<String> get todasDoacoes {
    final Set<String> todas = {};
    for (var lista in doacoesPorCausa.values) {
      todas.addAll(lista);
    }
    final listaOrdenada = todas.toList()..sort();
    return listaOrdenada;
  }

  // --- GERENCIAMENTO DE NOTIFICAÇÕES ---
  static final List<Map<String, dynamic>> notificacoesMock = [
    {
      "id": "notif-1",
      "tipo": "evento",
      "titulo": "Novo evento perto de você! 📍",
      "descricaoCurta":
          "Mutirão de Reforço Escolar a 1,2 km de você em Santo André.",
      "mensagemCompleta":
          "A ONG Mãos que Fazem abriu vagas para um novo mutirão de reforço escolar que combina 98% com suas habilidades em Santo André. Que tal participar?",
      "dataRelativa": "Há 15 min",
      "lida": false,
      "icone": "Icons.event_available_rounded",
      "cor": 0xFF0C6B6B,
      "eventoId": "1",
    },
    {
      "id": "notif-2",
      "tipo": "aprovacao",
      "titulo": "Inscrição Aprovada! 🎉",
      "descricaoCurta":
          "Ação Verde ABC confirmou sua presença no Plantio Comunitário.",
      "mensagemCompleta":
          "Parabéns! Sua solicitação para participar do Plantio Comunitário na Represa Billings foi aprovada pela instituição. Prepare suas luvas e chapéu!",
      "dataRelativa": "Há 2 horas",
      "lida": false,
      "icone": "Icons.check_circle_outline_rounded",
      "cor": 0xFF29B0A0,
      "eventoId": "2",
    },
    {
      "id": "notif-3",
      "tipo": "conquista",
      "titulo": "Novo Nível: Voluntário Ouro! 🏆",
      "descricaoCurta": "Você ultrapassou 40 horas doadas no ABC do Bem.",
      "mensagemCompleta":
          "Incrível! Pela sua dedicação e impacto nas cidades do Grande ABC, você acaba de conquistar o selo Ouro no seu perfil. Continue transformando vidas!",
      "dataRelativa": "Ontem",
      "lida": false,
      "icone": "Icons.emoji_events_rounded",
      "cor": 0xFFD48806,
    },
    {
      "id": "notif-4",
      "tipo": "sistema",
      "titulo": "Complete seu perfil 📝",
      "descricaoCurta":
          "Adicione suas causas favoritas para receber alertas mais precisos.",
      "mensagemCompleta":
          "Seu perfil está 80% completo. Conte-nos mais sobre as áreas que você mais gosta de atuar para receber convites cirúrgicos de ONGs da sua região.",
      "dataRelativa": "Há 3 dias",
      "lida": true,
      "icone": "Icons.person_outline_rounded",
      "cor": 0xFF3A6868,
    },
  ];

  static int get notificacoesNaoLidasCount {
    return notificacoesMock.where((n) => n['lida'] == false).length;
  }

  // --- GERENCIAMENTO DE MENSAGENS / CHAT ---
  static final List<Map<String, dynamic>> conversasMock = [
    {
      "id": "chat-1",
      "ongId": "ong-1",
      "ongNome": "Mãos que Fazem",
      "cidade": "Santo André",
      "foto":
          "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200",
      "online": true,
      "naoLidas": 2,
      "mensagens": [
        {
          "texto":
              "Olá, Ana! Confirmamos sua solicitação para o reforço escolar.",
          "enviadaPorMim": false,
          "horario": "10:14",
        },
        {
          "texto":
              "Que ótimo! Preciso levar algum material didático específico?",
          "enviadaPorMim": true,
          "horario": "10:18",
        },
        {
          "texto":
              "Não se preocupe! Todo o material já estará separado na sala.",
          "enviadaPorMim": false,
          "horario": "10:20",
        },
      ],
    },
    {
      "id": "chat-2",
      "ongId": "ong-2",
      "ongNome": "Ação Verde ABC",
      "cidade": "São Bernardo",
      "foto":
          "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=200",
      "online": false,
      "naoLidas": 0,
      "mensagens": [
        {
          "texto":
              "O ponto de encontro para o plantio será na portaria principal.",
          "enviadaPorMim": false,
          "horario": "Ontem",
        },
      ],
    },
    {
      "id": "chat-3",
      "ongId": "ong-3",
      "ongNome": "Saúde para Todos",
      "cidade": "São Caetano",
      "foto":
          "https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=200",
      "online": true,
      "naoLidas": 1,
      "mensagens": [
        {
          "texto": "Agradecemos o seu interesse no mutirão de saúde bucal!",
          "enviadaPorMim": false,
          "horario": "Segunda",
        },
      ],
    },
  ];

  static int get mensagensNaoLidasCount {
    int total = 0;
    for (var c in conversasMock) {
      total += (c['naoLidas'] as int? ?? 0);
    }
    return total;
  }
}
