# Wiki - Sprint 1

## Integrantes

| Nome | Matrícula |
|------|-----------|
| Ana Luísa Reis Nascente | 211045688 |
| Gabriel de Sousa | 211056000 |
| Maria Luiza Rodrigues de Sousa | 221007223 |
| Arthur Henrique Aprigio dos Santos | 232000481 |

**Projeto:** CAMAAR - Sistema para avaliação de atividades acadêmicas remotas do CIC

**Escopo:** Desenvolvimento das funcionalidades de autenticação, definição de senha, criação de templates de formulário e visualização de formulários pendentes.

---

## Papéis

- **Scrum Master:** Ana Luísa Reis Nascente
- **Product Owner:** Maria Luiza Rodrigues de Sousa

---

## Funcionalidades e Responsáveis

| Issue | Funcionalidade | Responsável | Pontos |
|-------|----------------|-------------|--------|
| #1 | Sistema de Login | Ana Luísa Reis Nascente | 3 |
| #2 | Sistema de Definição de Senha | Arthur Henrique Aprigio dos Santos | 2 |
| #3 | Criar Template de Formulário | Maria Luiza Rodrigues de Sousa | 5 |
| #4 | Visualização de Formulários para Responder | Gabriel de Sousa | 3 |

**Velocity total da Sprint 1:** 13 pontos

---

## Regras de Negócio

### Issue 1 - Sistema de Login
- O usuário pode se autenticar com e-mail ou matrícula
- Usuários administradores visualizam a opção de "Gerenciamento" no menu lateral
- Credenciais inválidas exibem mensagem de erro e mantêm o usuário na página de login

### Issue 2 - Sistema de Definição de Senha
- A senha é definida a partir de um link enviado por e-mail
- As senhas digitadas nos campos "Nova Senha" e "Confirmar Senha" devem ser idênticas
- A senha é armazenada de forma criptografada
- Após definição bem-sucedida, o usuário é redirecionado para a tela de login

### Issue 3 - Criar Template de Formulário
- Apenas administradores podem criar templates
- Um template deve ter título e pelo menos uma questão associada
- Templates sem questões não podem ser salvos

### Issue 4 - Visualização de Formulários para Responder
- Apenas participantes de turmas visualizam formulários pendentes
- São exibidos somente formulários ainda não respondidos
- Quando não há formulários pendentes, o sistema exibe mensagem de estado vazio

---

## Política de Branching

Uma branch por issue, seguindo o padrão:

```
issue-<número>-<descrição-curta>
```

Exemplos: `issue-1-login`, `issue-2-definicao-senha`

Apenas 1 pull request por grupo é enviado ao repositório principal, a partir da branch `sprint-1`.
