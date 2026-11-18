import { PrismaClient, Role, ApplicationStatus } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import * as bcrypt from 'bcrypt';
import 'dotenv/config';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });



const CIDADES_ABC = [
  'Santo André',
  'São Bernardo do Campo',
  'São Caetano do Sul',
  'Diadema',
  'Mauá',
  'Ribeirão Pires',
  'Rio Grande da Serra',
];

function diasNoFuturo(dias: number, hora = 9): Date {
  const data = new Date();
  data.setDate(data.getDate() + dias);
  data.setHours(hora, 0, 0, 0);
  return data;
}

async function main() {
  console.log('🧹 Limpando registros fora do Grande ABC e dados antigos...');

  // 1. Remove registros antigos/fora do ABC para manter a base 100% regionalizada
  await prisma.ongPostLike.deleteMany({});
  await prisma.volunteerExperienceLike.deleteMany({});
  await prisma.ongPost.deleteMany({});
  await prisma.volunteerExperience.deleteMany({});
  await prisma.ongFollower.deleteMany({});
  await prisma.notification.deleteMany({});
  await prisma.message.deleteMany({});
  await prisma.application.deleteMany({});
  await prisma.opportunity.deleteMany({});
  await prisma.user.deleteMany({
    where: {
      OR: [
        { cidade: null },
        { cidade: { notIn: CIDADES_ABC, mode: 'insensitive' } },
      ],
    },
  });

  // Limpa também os usuários remanescentes do ABC para recriar com senhas e coordenadas padronizadas
  await prisma.user.deleteMany({});

  const defaultPassword = await bcrypt.hash('SenhaForte@123', 10);

  console.log('🏢 Criando ONGs do Grande ABC...');

  // ==========================================
  // ONGs DO GRANDE ABC
  // ==========================================
  const ongMaua = await prisma.user.create({
    data: {
      email: 'contato@institutoverdemaua.org.br',
      password: defaultPassword,
      name: 'Instituto Verde Mauá',
      role: Role.ONG,
      razaoSocial: 'Instituto Socioambiental Verde Mauá',
      cnpj: '12.345.678/0001-10',
      anoFundacao: 2016,
      cep: '09370-000',
      logradouro: 'Av. Capitão João',
      numero: '1420',
      bairro: 'Matriz',
      cidade: 'Mauá',
      estado: 'SP',
      aceiteTermos: true,
      aceiteLgpd: true,
      causaPrincipal: 'Meio Ambiente e Sustentabilidade',
      servicosOferecidos: ['Reflorestamento', 'Educação Ambiental', 'Hortas Comunitárias'],
      publicoAtendido: ['Comunidade Geral', 'Escolas Públicas'],
      descricao: 'Atuamos na recuperação de nascentes do Rio Tamanduateí e criação de hortas urbanas em Mauá.',
      habilidadesBuscadas: ['Jardinagem', 'Logística', 'Educação Ambiental', 'Fotografia'],
      formatoVoluntariado: 'PRESENCIAL',
      aceitaDoacoes: ['Mudas', 'Ferramentas', 'Adubo Orgânico'],
      whatsapp: '11988881111',
      instagram: '@institutoverdemaua',
    },
  });

  const ongSantoAndre = await prisma.user.create({
    data: {
      email: 'contato@patasdoabc.org.br',
      password: defaultPassword,
      name: 'Patas Solidárias ABC',
      role: Role.ONG,
      razaoSocial: 'Associação Protetora dos Animais Patas Solidárias',
      cnpj: '23.456.789/0001-21',
      anoFundacao: 2018,
      cep: '09040-210',
      logradouro: 'Rua Catequese',
      numero: '850',
      bairro: 'Vila Guiomar',
      cidade: 'Santo André',
      estado: 'SP',
      aceiteTermos: true,
      aceiteLgpd: true,
      causaPrincipal: 'Causa Animal',
      servicosOferecidos: ['Resgate', 'Feira de Adoção', 'Mutirão de Castração'],
      publicoAtendido: ['Cães e Gatos Abandonados'],
      descricao: 'Resgate, tratamento veterinário e feiras de adoção responsável em Santo André e região.',
      habilidadesBuscadas: ['Cuidado Animal', 'Veterinária', 'Redes Sociais', 'Transporte'],
      formatoVoluntariado: 'PRESENCIAL',
      aceitaDoacoes: ['Ração', 'Medicamentos', 'Cobertores'],
      whatsapp: '11988882222',
      instagram: '@patassolidariasabc',
    },
  });

  const ongSbc = await prisma.user.create({
    data: {
      email: 'contato@conectasbc.org.br',
      password: defaultPassword,
      name: 'Conecta Jovem SBC',
      role: Role.ONG,
      razaoSocial: 'Centro de Inclusão Digital Conecta SBC',
      cnpj: '34.567.890/0001-32',
      anoFundacao: 2019,
      cep: '09750-001',
      logradouro: 'Av. Lucas Nogueira Garcez',
      numero: '510',
      bairro: 'Jardim do Mar',
      cidade: 'São Bernardo do Campo',
      estado: 'SP',
      aceiteTermos: true,
      aceiteLgpd: true,
      causaPrincipal: 'Educação e Tecnologia',
      servicosOferecidos: ['Aulas de Programação', 'Mentoria de Carreira', 'Reforço Escolar'],
      publicoAtendido: ['Jovens e Adolescentes'],
      descricao: 'Capacitação gratuita em tecnologia, lógica de programação e empregabilidade para jovens de SBC.',
      habilidadesBuscadas: ['Programação', 'Mentoria', 'Design', 'Comunicação'],
      formatoVoluntariado: 'HIBRIDO',
      aceitaDoacoes: ['Notebooks', 'Periféricos'],
      whatsapp: '11988883333',
      instagram: '@conectajovemsbc',
    },
  });

  const ongScs = await prisma.user.create({
    data: {
      email: 'contato@maosquecuidamscs.org.br',
      password: defaultPassword,
      name: 'Mãos que Cuidam SCS',
      role: Role.ONG,
      razaoSocial: 'Núcleo de Assistência Social Mãos que Cuidam',
      cnpj: '45.678.901/0001-43',
      anoFundacao: 2014,
      cep: '09520-320',
      logradouro: 'Rua Amazonas',
      numero: '1120',
      bairro: 'Centro',
      cidade: 'São Caetano do Sul',
      estado: 'SP',
      aceiteTermos: true,
      aceiteLgpd: true,
      causaPrincipal: 'Assistência Social e Combate à Fome',
      servicosOferecidos: ['Cozinha Solidária', 'Cestas Básicas', 'Apoio à Terceira Idade'],
      publicoAtendido: ['Famílias em Vulnerabilidade', 'Idosos'],
      descricao: 'Distribuição semanal de marmitas e cestas básicas para famílias vulneráveis do ABC.',
      habilidadesBuscadas: ['Culinária', 'Organização', 'Logística', 'Atendimento'],
      formatoVoluntariado: 'PRESENCIAL',
      aceitaDoacoes: ['Alimentos Não Perecíveis', 'Itens de Higiene'],
      whatsapp: '11988884444',
      instagram: '@maosquecuidamscs',
    },
  });

  const ongDiadema = await prisma.user.create({
    data: {
      email: 'contato@artediadema.org.br',
      password: defaultPassword,
      name: 'Coletivo Cultural Diadema',
      role: Role.ONG,
      razaoSocial: 'Associação Cultural e Esportiva de Diadema',
      cnpj: '56.789.012/0001-54',
      anoFundacao: 2017,
      cep: '09910-470',
      logradouro: 'Av. Fábio Eduardo Ramos Esquivel',
      numero: '640',
      bairro: 'Centro',
      cidade: 'Diadema',
      estado: 'SP',
      aceiteTermos: true,
      aceiteLgpd: true,
      causaPrincipal: 'Cultura, Esporte e Lazer',
      servicosOferecidos: ['Oficinas de Música', 'Teatro Comunitário', 'Recreação Infantil'],
      publicoAtendido: ['Crianças', 'Adolescentes'],
      descricao: 'Oficinas culturais e esportivas nos bairros de Diadema aos finais de semana.',
      habilidadesBuscadas: ['Música', 'Recreação', 'Fotografia', 'Produção de Eventos'],
      formatoVoluntariado: 'PRESENCIAL',
      aceitaDoacoes: ['Instrumentos Musicais', 'Materiais Escolares'],
      whatsapp: '11988885555',
      instagram: '@coletivoculturaldiadema',
    },
  });

  console.log('🙋 Criando Voluntários do Grande ABC...');

  // ==========================================
  // VOLUNTÁRIOS DO GRANDE ABC
  // ==========================================
  const vol1 = await prisma.user.create({
    data: {
      email: 'lucas.maua@email.com',
      password: defaultPassword,
      name: 'Lucas Andrade',
      role: Role.USER,
      cpf: '111.222.333-44',
      nascimento: '2001-05-14',
      telefone: '11977771111',
      cidade: 'Mauá',
      estado: 'SP',
      bairro: 'Jardim Zaíra',
      aceiteTermos: true,
      aceiteLgpd: true,
      bio: 'Desenvolvedor apaixonado por educação tecnológica, mentoria para jovens e ações ambientais em Mauá.',
      habilidades: ['Programação', 'Mentoria', 'Logística', 'Educação Ambiental'],
      disponibilidade: ['Sábados', 'Domingos'],
    },
  });

  const vol2 = await prisma.user.create({
    data: {
      email: 'mariana.sa@email.com',
      password: defaultPassword,
      name: 'Mariana Costa',
      role: Role.USER,
      cpf: '222.333.444-55',
      nascimento: '1998-09-22',
      telefone: '11977772222',
      cidade: 'Santo André',
      estado: 'SP',
      bairro: 'Campestre',
      aceiteTermos: true,
      aceiteLgpd: true,
      bio: 'Estudante de veterinária e fotógrafa nas horas vagas. Amo ajudar feiras de adoção no ABC.',
      habilidades: ['Cuidado Animal', 'Veterinária', 'Fotografia', 'Redes Sociais'],
      disponibilidade: ['Sábados'],
    },
  });

  const vol3 = await prisma.user.create({
    data: {
      email: 'rafael.sbc@email.com',
      password: defaultPassword,
      name: 'Rafael Oliveira',
      role: Role.USER,
      cpf: '333.444.555-66',
      nascimento: '1995-02-10',
      telefone: '11977773333',
      cidade: 'São Bernardo do Campo',
      estado: 'SP',
      bairro: 'Rudge Ramos',
      aceiteTermos: true,
      aceiteLgpd: true,
      bio: 'Gosto de ajudar na cozinha solidária, organização de doações e eventos culturais.',
      habilidades: ['Culinária', 'Organização', 'Logística', 'Produção de Eventos'],
      disponibilidade: ['Finais de Semana', 'Noite'],
    },
  });

  console.log('📅 Criando Eventos Futuros no Grande ABC...');

  // ==========================================
  // EVENTOS FUTUROS (100% NO ABC PAULISTA)
  // ==========================================
  const opp1 = await prisma.opportunity.create({
    data: {
      title: 'Mutirão de Reflorestamento no Parque Guapituba',
      description: 'Plantio de 200 mudas nativas da Mata Atlântica e limpeza de trilhas ecológicas em Mauá.',
      eventDate: diasNoFuturo(4, 8),
      durationHours: 5,
      totalVacancies: 25,
      categories: ['Meio Ambiente', 'Sustentabilidade'],
      modality: 'PRESENCIAL',
      requiredSkills: ['Jardinagem', 'Educação Ambiental', 'Logística'],
      minAge: 16,
      requirements: ['Usar calçado fechado', 'Levar garrafa de água'],
      status: 'ATIVA',
      cep: '09360-120',
      logradouro: 'Av. Capitão João',
      numero: '3220',
      bairro: 'Guapituba',
      cidade: 'Mauá',
      estado: 'SP',
      latitude: -23.6812,
      longitude: -46.4534,
      ongId: ongMaua.id,
    },
  });

  const opp2 = await prisma.opportunity.create({
    data: {
      title: 'Feira de Adoção Responsável no Parque Central',
      description: 'Apoio no cuidado com cães e gatos, recepção de adotantes e registros fotográficos dos pets.',
      eventDate: diasNoFuturo(6, 9),
      durationHours: 6,
      totalVacancies: 15,
      categories: ['Causa Animal', 'Eventos'],
      modality: 'PRESENCIAL',
      requiredSkills: ['Cuidado Animal', 'Fotografia', 'Atendimento'],
      minAge: 18,
      requirements: ['Amor por animais', 'Disponibilidade integral no turno'],
      status: 'ATIVA',
      cep: '09041-300',
      logradouro: 'Rua José Bonifácio',
      numero: '400',
      bairro: 'Vila Assunção',
      cidade: 'Santo André',
      estado: 'SP',
      latitude: -23.6687,
      longitude: -46.5332,
      ongId: ongSantoAndre.id,
    },
  });

  const opp3 = await prisma.opportunity.create({
    data: {
      title: 'Workshop de Lógica de Programação e Git para Jovens',
      description: 'Mentoria prática para estudantes do ensino médio de São Bernardo do Campo darem os primeiros passos em TI.',
      eventDate: diasNoFuturo(10, 14),
      durationHours: 4,
      totalVacancies: 10,
      categories: ['Educação', 'Tecnologia'],
      modality: 'HIBRIDO',
      requiredSkills: ['Programação', 'Mentoria', 'Comunicação'],
      minAge: 18,
      requirements: ['Conhecimento básico em lógica ou desenvolvimento web'],
      status: 'ATIVA',
      cep: '09750-001',
      logradouro: 'Av. Lucas Nogueira Garcez',
      numero: '510',
      bairro: 'Jardim do Mar',
      cidade: 'São Bernardo do Campo',
      estado: 'SP',
      latitude: -23.6914,
      longitude: -46.5558,
      ongId: ongSbc.id,
    },
  });

  const opp4 = await prisma.opportunity.create({
    data: {
      title: 'Cozinha Solidária: Preparo e Entrega de Marmitas',
      description: 'Preparo de 300 refeições e montagem de kits de higiene para famílias cadastradas em São Caetano.',
      eventDate: diasNoFuturo(12, 8),
      durationHours: 5,
      totalVacancies: 20,
      categories: ['Assistência Social', 'Combate à Fome'],
      modality: 'PRESENCIAL',
      requiredSkills: ['Culinária', 'Organização', 'Logística'],
      minAge: 16,
      requirements: ['Touca descartável fornecida no local'],
      status: 'ATIVA',
      cep: '09520-320',
      logradouro: 'Rua Amazonas',
      numero: '1120',
      bairro: 'Centro',
      cidade: 'São Caetano do Sul',
      estado: 'SP',
      latitude: -23.6152,
      longitude: -46.5701,
      ongId: ongScs.id,
    },
  });

  const opp5 = await prisma.opportunity.create({
    data: {
      title: 'Festival Cultural Comunitário de Diadema',
      description: 'Apoio na produção de palco, oficinas infantis de música e cobertura fotográfica do evento.',
      eventDate: diasNoFuturo(18, 10),
      durationHours: 6,
      totalVacancies: 18,
      categories: ['Cultura', 'Recreação'],
      modality: 'PRESENCIAL',
      requiredSkills: ['Produção de Eventos', 'Recreação', 'Fotografia', 'Música'],
      minAge: 16,
      requirements: ['Disposição para trabalho em equipe'],
      status: 'ATIVA',
      cep: '09910-470',
      logradouro: 'Av. Fábio Eduardo Ramos Esquivel',
      numero: '640',
      bairro: 'Centro',
      cidade: 'Diadema',
      estado: 'SP',
      latitude: -23.6861,
      longitude: -46.6228,
      ongId: ongDiadema.id,
    },
  });

  const opp6 = await prisma.opportunity.create({
    data: {
      title: 'Design e Gestão de Redes Sociais para Campanhas do ABC',
      description: 'Criação de artes e calendário editorial remoto para divulgação das feiras de adoção e campanhas do agasalho.',
      eventDate: diasNoFuturo(22, 19),
      durationHours: 4,
      totalVacancies: 8,
      categories: ['Comunicação', 'Tecnologia'],
      modality: 'REMOTO',
      requiredSkills: ['Design', 'Redes Sociais', 'Comunicação'],
      minAge: 16,
      requirements: ['Acesso a computador ou celular com Canva/Figma'],
      status: 'ATIVA',
      cidade: 'Ribeirão Pires',
      estado: 'SP',
      latitude: -23.7111,
      longitude: -46.4125,
      ongId: ongSantoAndre.id,
    },
  });

  console.log('💬 Populando feed social e seguidores do ABC...');

  // Seguidores
  await prisma.ongFollower.createMany({
    data: [
      { ongId: ongMaua.id, volunteerId: vol1.id },
      { ongId: ongSbc.id, volunteerId: vol1.id },
      { ongId: ongSantoAndre.id, volunteerId: vol2.id },
      { ongId: ongScs.id, volunteerId: vol3.id },
    ],
  });

  // Postagens no mural das ONGs
  await prisma.ongPost.createMany({
    data: [
      {
        ongId: ongMaua.id,
        title: 'Mutirão deste sábado no Parque Guapituba!',
        text: 'Já temos 200 mudas prontas para plantio em Mauá. Inscreva-se na vaga e venha fortalecer o verde do ABC!',
        opportunityId: opp1.id,
      },
      {
        ongId: ongSantoAndre.id,
        title: 'Mais de 30 cães e gatos esperando um lar em Santo André',
        text: 'Nossa próxima feira no Parque Central precisa de voluntários para recepção e fotos.',
        opportunityId: opp2.id,
      },
    ],
  });

  // Relato de experiência de voluntário
  await prisma.volunteerExperience.create({
    data: {
      userId: vol1.id,
      ongName: 'Conecta Jovem SBC',
      text: 'Experiência incrível mentorando a turma de lógica de programação em São Bernardo! Galera do ABC muito engajada.',
      formattedDate: 'Novembro/2026',
    },
  });

  // Inscrição inicial de exemplo (Mariana inscrita em SBC para deixar Mauá, Santo André e Remoto livres para recomendação)
  await prisma.application.create({
    data: {
      userId: vol2.id,
      opportunityId: opp3.id,
      status: ApplicationStatus.PENDING,
      tipoCarona: 'NENHUMA',
    },
  });

  console.log('✅ Banco populado com sucesso! 100% focado no Grande ABC.');
  console.log('🔑 Senha padrão para todos os usuários de teste: 123456');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
    await pool.end();
  });