import 'package:flutter/material.dart';

class LegalPopups {
  // ---------------------------------------------------------
  // 1. TERMOS DE USO - VOLUNTÁRIOS
  // ---------------------------------------------------------
  static void mostrarTermosVoluntario(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.volunteer_activism_rounded, color: Color(0xFF0C6B6B)),
            SizedBox(width: 8),
            Text(
              "Termos de Uso (Voluntário)",
              style: TextStyle(
                color: Color(0xFF062222),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              "1. Natureza do Serviço\n"
              "O ABC do Bem é uma plataforma facilitadora que conecta voluntários a Organizações Não Governamentais (ONGs). O cadastro e a atuação não geram qualquer vínculo empregatício, trabalhista ou previdenciário com a plataforma ou com as instituições.\n\n"
              "2. Idade Mínima e Autorização\n"
              "O cadastro na plataforma é permitido para pessoas a partir de 12 anos de idade. No entanto, voluntários menores de 18 anos precisarão obrigatoriamente da autorização e consentimento expresso de um dos pais ou responsável legal para confirmar presença e participar das ações e eventos divulgados.\n\n"
              "3. Conduta e Ambiente Seguro\n"
              "O ABC do Bem preza por um ambiente acolhedor. Não será tolerada nenhuma forma de discriminação, assédio, preconceito ou comportamento inadequado. Violações a esta regra resultarão no banimento imediato da plataforma.\n\n"
              "4. Compromisso e Assiduidade\n"
              "Ao confirmar participação em uma ação, a ONG conta com a sua presença. Caso ocorra algum imprevisto, o voluntário compromete-se a avisar a instituição com a maior antecedência possível através dos canais de contato fornecidos.\n\n"
              "5. Responsabilidades e Direitos de Imagem\n"
              "A plataforma atua apenas como intermediadora. O alinhamento de expectativas, regras de segurança e eventuais autorizações de uso de imagem (para fotos das ações) devem ser acordados diretamente entre você (ou seus responsáveis) e a ONG organizadora.\n\n"
              "6. Veracidade das Informações\n"
              "O usuário declara que todas as informações prestadas no perfil são verdadeiras, sob pena de exclusão da plataforma.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF3A6868),
                height: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Fechar",
              style: TextStyle(
                color: Color(0xFF0C6B6B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 2. TERMOS DE USO - ONGs
  // ---------------------------------------------------------
  static void mostrarTermosOng(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.gavel_rounded, color: Color(0xFF0C6B6B)),
            SizedBox(width: 8),
            Text(
              "Termos de Uso (ONGs)",
              style: TextStyle(
                color: Color(0xFF062222),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              "1. Natureza do Serviço\n"
              "O ABC do Bem atua exclusivamente como uma ponte tecnológica entre cidadãos dispostos a ajudar e instituições cadastradas. A plataforma não possui vínculo associativo, societário ou trabalhista com a ONG, tampouco com os voluntários inscritos.\n\n"
              "2. Ausência de Garantia de Comparecimento\n"
              "A plataforma facilita o recrutamento e o 'match' de perfis, porém NÃO garante o comparecimento, a assiduidade ou a qualificação técnica final dos voluntários inscritos. Cabe à organização gerenciar possíveis faltas (no-shows) e realizar a triagem final dos candidatos.\n\n"
              "3. Responsabilidade por Segurança e Integridade\n"
              "É de inteira responsabilidade da ONG garantir um ambiente seguro e salubre para a atuação voluntária. A instituição deve fornecer os Equipamentos de Proteção Individual (EPIs) quando necessários, orientações claras de conduta e garantir a integridade física e moral dos voluntários durante as ações.\n\n"
              "4. Voluntários Menores de Idade\n"
              "Caso a ONG aceite o apoio de voluntários menores de 18 anos, é de sua total e exclusiva responsabilidade exigir e arquivar o termo de autorização assinado pelos pais ou responsáveis legais, conforme exige a legislação vigente (ECA).\n\n"
              "5. Direitos de Imagem\n"
              "O ABC do Bem não cede automaticamente direitos de imagem dos usuários. Se a instituição desejar fotografar ou filmar os voluntários para campanhas e redes sociais, deverá colher a assinatura de um Termo de Uso de Imagem próprio no dia da ação.\n\n"
              "6. Idoneidade e Propósito\n"
              "A organização declara ser legalmente constituída e compromete-se a não utilizar a força de trabalho voluntária para fins ilícitos, perigosos ou para substituição de mão de obra remunerada visando lucro financeiro.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF3A6868),
                height: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Fechar",
              style: TextStyle(
                color: Color(0xFF0C6B6B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 3. POLÍTICA DE PRIVACIDADE E LGPD (UNIFICADA)
  // ---------------------------------------------------------
  static void mostrarLGPD(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.shield_rounded, color: Color(0xFF0C6B6B)),
            SizedBox(width: 8),
            Text(
              "Política de Privacidade",
              style: TextStyle(
                color: Color(0xFF062222),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              "Tratamento de Dados (LGPD - Lei nº 13.709/2018)\n\n"
              "O ABC do Bem tem o compromisso de respeitar a sua privacidade e garantir o sigilo de todas as informações fornecidas, em estrita conformidade com a Lei Geral de Proteção de Dados (Lei Federal nº 13.709/2018).\n\n"
              "1. Finalidade da Coleta\n"
              "Seus dados cadastrais (nome, documentos, e-mail, telefone e endereço) são coletados com o único e exclusivo propósito de viabilizar a conexão entre voluntários e Organizações Não Governamentais.\n\n"
              "2. Compartilhamento de Informações\n"
              "O ABC do Bem não vende, aluga ou cede seus dados para empresas terceiras com fins publicitários ou comerciais. Os dados de contato (como telefone e e-mail) só são compartilhados internamente entre o Voluntário e a ONG no momento em que ambas as partes confirmam o interesse mútuo (Match/Inscrição na Ação).\n\n"
              "3. Proteção e Segurança\n"
              "Utilizamos protocolos de segurança modernos e criptografia para proteger nossa base de dados contra acessos não autorizados, vazamentos ou destruição de informações.\n\n"
              "4. Direitos do Titular (Seus Direitos)\n"
              "Você é o proprietário absoluto dos seus dados. A qualquer momento, através do aplicativo, você possui o direito de:\n"
              "• Acessar e visualizar os dados que temos sobre você;\n"
              "• Corrigir informações desatualizadas ou incorretas;\n"
              "• Solicitar a anonimização ou bloqueio temporário do seu perfil;\n"
              "• Solicitar a exclusão definitiva e irrestrita da sua conta e de todos os seus dados dos nossos servidores.\n\n"
              "Ao continuar utilizando nossa plataforma, você declara ciência e consentimento expresso para o tratamento dos dados conforme descrito nesta política.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF3A6868),
                height: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Fechar",
              style: TextStyle(
                color: Color(0xFF0C6B6B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
