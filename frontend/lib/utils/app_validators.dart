// lib/utils/app_validators.dart

class AppValidators {
  // Construtor privado para evitar instanciação indevida
  AppValidators._();

  /// Valida campo obrigatório geral
  static String? validarObrigatorio(
    String? valor, {
    String mensagem = "Este campo é obrigatório.",
  }) {
    if (valor == null || valor.trim().isEmpty) {
      return mensagem;
    }
    return null;
  }

  /// Valida formato de e-mail segundo padrão RFC 5322
  static String? validarEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return "O e-mail é obrigatório.";
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
    );

    if (!emailRegex.hasMatch(email.trim())) {
      return "Informe um e-mail válido.";
    }

    return null;
  }

  /// Valida se a confirmação de e-mail é idêntica ao e-mail principal
  static String? validarConfirmacaoEmail(String? email, String? confirmacao) {
    final erroConfirmacao = validarEmail(confirmacao);
    if (erroConfirmacao != null) return erroConfirmacao;

    if (email?.trim().toLowerCase() != confirmacao?.trim().toLowerCase()) {
      return "Os e-mails informados não coincidem.";
    }

    return null;
  }

  /// Valida regras de segurança de senha (mínimo de caracteres)
  static String? validarSenha(String? senha, {int tamanhoMinimo = 6}) {
    if (senha == null || senha.isEmpty) {
      return "A senha é obrigatória.";
    }

    if (senha.length < tamanhoMinimo) {
      return "A senha deve conter no mínimo $tamanhoMinimo caracteres.";
    }

    return null;
  }

  /// Valida se a confirmação de senha é idêntica à senha informada
  static String? validarConfirmacaoSenha(String? senha, String? confirmacao) {
    if (confirmacao == null || confirmacao.isEmpty) {
      return "Confirme sua senha.";
    }

    if (senha != confirmacao) {
      return "As senhas não coincidem.";
    }

    return null;
  }

  /// Valida CPF com cálculo dos dígitos verificadores (módulo 11)
  static String? validarCpf(String? cpf) {
    if (cpf == null || cpf.trim().isEmpty) {
      return "O CPF é obrigatório.";
    }

    final String numeros = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length != 11) {
      return "CPF deve conter 11 dígitos.";
    }

    // Rejeita sequências repetidas como 111.111.111-11
    if (RegExp(r'^(\d)\1*$').hasMatch(numeros)) {
      return "CPF inválido.";
    }

    final List<int> digitos =
        numeros.split('').map((String d) => int.parse(d)).toList();

    int calcularDigito(int n, int pesoInicial) {
      int soma = 0;
      for (int i = 0; i < n; i++) {
        soma += digitos[i] * (pesoInicial - i);
      }
      final int resto = (soma * 10) % 11;
      return resto >= 10 ? 0 : resto;
    }

    // Primeiro dígito verificador
    if (digitos[9] != calcularDigito(9, 10)) {
      return "CPF inválido.";
    }

    // Segundo dígito verificador
    if (digitos[10] != calcularDigito(10, 11)) {
      return "CPF inválido.";
    }

    return null;
  }

  /// Valida se a data de nascimento está no formato DD/MM/AAAA, se é válida no calendário
  /// e se o voluntário tem pelo menos [idadeMinima] anos (padrão: 14 anos)
  static String? validarDataNascimento(String? dataStr,
      {int idadeMinima = 14}) {
    if (dataStr == null || dataStr.trim().isEmpty) {
      return "Data de nascimento obrigatória.";
    }

    final texto = dataStr.trim();
    if (texto.length < 10) {
      return "Data incompleta (DD/MM/AAAA).";
    }

    final partes = texto.split('/');
    if (partes.length != 3) {
      return "Formato inválido. Use DD/MM/AAAA.";
    }

    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final ano = int.tryParse(partes[2]);

    if (dia == null || mes == null || ano == null) {
      return "Data inválida.";
    }

    if (mes < 1 || mes > 12 || dia < 1 || dia > 31) {
      return "Dia ou mês inválido.";
    }

    DateTime dataNasc;
    try {
      dataNasc = DateTime(ano, mes, dia);
      // Evita rolagem automática de datas como 31/02 para março
      if (dataNasc.day != dia ||
          dataNasc.month != mes ||
          dataNasc.year != ano) {
        return "Data inexistente no calendário.";
      }
    } catch (_) {
      return "Data inválida.";
    }

    final hoje = DateTime.now();

    if (dataNasc.isAfter(hoje)) {
      return "A data não pode estar no futuro.";
    }

    if (ano < 1910) {
      return "Ano de nascimento irreal.";
    }

    // Cálculo exato de idade considerando aniversário no ano vigente
    int idade = hoje.year - dataNasc.year;
    if (hoje.month < dataNasc.month ||
        (hoje.month == dataNasc.month && hoje.day < dataNasc.day)) {
      idade--;
    }

    if (idade < idadeMinima) {
      return "É necessário ter no mínimo $idadeMinima anos para participar.";
    }

    return null;
  }

  /// Valida CNPJ com cálculo dos dígitos verificadores
  static String? validarCnpj(String? cnpj) {
    if (cnpj == null || cnpj.trim().isEmpty) {
      return "O CNPJ é obrigatório.";
    }

    final String numeros = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length != 14) {
      return "CNPJ incompleto.";
    }

    if (RegExp(r'^(\d)\1*$').hasMatch(numeros)) {
      return "CNPJ inválido.";
    }

    final List<int> digitos =
        numeros.split('').map((String d) => int.parse(d)).toList();

    int calcularDigito(int n, List<int> pesos) {
      int soma = 0;
      for (int i = 0; i < n; i++) {
        soma += digitos[i] * pesos[i];
      }
      final int resto = soma % 11;
      return resto < 2 ? 0 : 11 - resto;
    }

    const List<int> pesos1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    const List<int> pesos2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    if (digitos[12] != calcularDigito(12, pesos1)) {
      return "CNPJ inválido.";
    }

    if (digitos[13] != calcularDigito(13, pesos2)) {
      return "CNPJ inválido.";
    }

    return null;
  }

  /// Valida ano de fundação ou início
  static String? validarAno(String? anoStr) {
    if (anoStr == null || anoStr.trim().isEmpty) {
      return "O ano é obrigatório.";
    }

    if (anoStr.length != 4) {
      return "Deve conter 4 dígitos.";
    }

    final int? ano = int.tryParse(anoStr);
    if (ano == null) {
      return "Ano inválido.";
    }

    if (ano > DateTime.now().year) {
      return "O ano não pode estar no futuro.";
    }

    if (ano < 1800) {
      return "Ano irreal.";
    }

    return null;
  }

  /// Valida formato de URL / site institucional
  static String? validarSite(String? site) {
    if (site == null || site.trim().isEmpty) {
      return null; // Opcional
    }

    final siteRegex = RegExp(
      r"^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$",
    );

    if (!siteRegex.hasMatch(site.trim())) {
      return "Formato de site inválido.";
    }

    return null;
  }

  /// Valida telefone fixo (DDD + número)
  static String? validarTelefone(String? telefone) {
    if (telefone == null || telefone.trim().isEmpty) {
      return "O telefone é obrigatório.";
    }

    if (telefone.trim().length < 14) {
      return "Telefone incompleto.";
    }

    return null;
  }

  /// Valida celular / WhatsApp com 8 ou 9 dígitos
  static String? validarWhatsapp(String? whatsapp) {
    if (whatsapp == null || whatsapp.trim().isEmpty) {
      return "O WhatsApp é obrigatório.";
    }

    if (whatsapp.trim().length < 14) {
      return "WhatsApp incompleto.";
    }

    return null;
  }

  /// Valida formato de CEP
  static String? validarCep(String? cep) {
    if (cep == null || cep.trim().isEmpty) {
      return "O CEP é obrigatório.";
    }

    if (cep.trim().length < 9) {
      return "CEP incompleto.";
    }

    return null;
  }
}
