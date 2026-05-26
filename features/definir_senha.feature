# language: pt
Funcionalidade: Sistema de definição de senha
  Como Usuário do sistema
  Quero definir minha senha de acesso ao receber o convite de cadastro
  A fim de garantir acesso seguro e personalizado ao sistema

  Contexto:
    Dado que o usuário recebeu um e-mail de convite de cadastro com um link válido
    E acessa o link de definição de senha

  Cenário: Definição de senha com sucesso (Caminho Feliz)
    Quando o usuário preenche o campo "Nova Senha" com uma senha válida
    E confirma a senha no campo "Confirmar Senha"
    E aciona o botão "Definir Senha"
    Então o sistema deve salvar a senha criptografada no banco de dados
    E exibir a mensagem "Senha definida com sucesso"
    E redirecionar o usuário para a tela de login

  Cenário: Falha ao definir senha com link expirado (Caminho Triste)
    Quando o usuário tenta acessar um link de definição de senha expirado
    Então o sistema deve rejeitar a requisição
    E exibir a mensagem "O link de definição de senha expirou. Solicite um novo acesso ao administrador"
