# Sprint 3

Para informações sobre a equipe, papéis ágeis e política de branching, consulte a página **Sprint 1**.

**Branch de entrega:** `sprint-3`  
**Prazo:** 30/06/2026

---

# Escopo

A Sprint 3 teve como foco a **refatoração e documentação do código**, seguindo as recomendações do Capítulo 9 do livro da disciplina. O objetivo foi melhorar a qualidade interna do sistema sem alterar seu comportamento, reduzindo a complexidade dos métodos, aumentando a cobertura dos testes automatizados e documentando o código utilizando RDoc.

As funcionalidades implementadas nas sprints anteriores foram mantidas, garantindo a estabilidade da aplicação após as refatorações.

---

# Atividades Desenvolvidas

## Ana Luísa Reis Nascente

| Atividade | Descrição |
|-----------|-----------|
| Refatoração | Refatoração dos módulos de autenticação e gerenciamento de usuários. |
| Testes | Revisão e adequação dos testes relacionados às funcionalidades implementadas. |
| Documentação | Inclusão de documentação RDoc nos métodos desenvolvidos. |

---

## Arthur Henrique Aprígio dos Santos

| Atividade | Descrição |
|-----------|-----------|
| Refatoração | Organização e simplificação dos serviços de importação e atualização de dados. |
| Testes | Revisão dos testes dos serviços para contemplar cenários de sucesso e erro. |
| Documentação | Adição de comentários RDoc aos serviços implementados. |

---

## Maria Luiza Rodrigues de Sousa

| Atividade | Descrição |
|-----------|-----------|
| Refatoração | Melhoria dos controllers e models responsáveis pelos templates e formulários. |
| Testes | Atualização dos testes automatizados para manter alta cobertura. |
| Documentação | Documentação dos métodos criados utilizando RDoc. |

---

## Gabriel de Sousa

| Atividade | Descrição |
|-----------|-----------|
| Refatoração | Organização da lógica de avaliações e respostas dos formulários. |
| Testes | Revisão dos testes das funcionalidades de avaliação. |
| Documentação | Inclusão da documentação dos métodos relacionados às avaliações. |

---

# Refatorações Realizadas

| Componente | Refatoração | Objetivo |
|------------|-------------|----------|
| Controllers | Extração de métodos auxiliares | Redução da complexidade ciclomática |
| Models | Simplificação de validações | Melhor legibilidade |
| Services | Remoção de código duplicado | Melhor reutilização |
| Testes | Organização dos cenários | Melhor manutenção |

---

# Métricas de Qualidade - Ana Luísa Reis Nascente
#### Complexidade Ciclomática e ABC Score (RubyCritic)

| Métrica | Valor |
| :--- | :--- |
| Maior ABC Score antes da refatoração | [Valor numérico] |
| Maior ABC Score após a refatoração | [Valor numérico] |
| Quantidade de métodos refatorados | [Quantidade ou descrição, ex: 2 métodos divididos] |
| Limite estabelecido | < 20 |

**Análise:**
[Escreva uma breve análise explicando qual era o método problemático, por que a nota estava alta e qual foi a solução aplicada (ex: Extract Method) para baixar a nota.]

#### Cobertura de Testes (SimpleCov)

| Componente | Cobertura |
| :--- | :--- |
| Models (`[nomes_dos_arquivos.rb]`) | [Valor]% |
| Controllers (`[nomes_dos_arquivos.rb]`) | [Valor]% |

**Análise:**
[Breve parágrafo informando se a cobertura de testes atingiu a meta exigida de >90%.]

#### Happy Path e Sad Path

| Item | Situação |
| :--- | :--- |
| Happy Path | [ ✔ ou ✖ ] |
| Sad Path | [ ✔ ou ✖ ] |

Todos os cenários de teste abrangem caminhos de sucesso e caminhos de erro, validando o comportamento esperado do sistema. As features originais do Cucumber foram mantidas e executadas com sucesso, garantindo a ausência de regressões.

#### Documentação (RDoc)

| Item | Valor |
| :--- | :--- |
| Métodos documentados | [Valor] |
| Controllers documentados | [Valor] |
| Models documentados | [Valor] |

Todos os métodos implementados ou modificados receberam documentação estruturada contendo:
* Descrição técnica da operação;
* Parâmetros e argumentos recebidos;
* Valor de retorno esperado;
* Possíveis efeitos colaterais na base de dados ou na sessão.

#### Comparação Antes × Depois

| Item | Antes | Depois |
| :--- | :--- | :--- |
| ABC Score máximo | [Valor] | [Valor] |
| Cobertura dos testes | [Valor]% | [Valor]% |
| Métodos documentados | [Valor] | [Valor] |

# Métricas de Qualidade - Gabriel
#### Complexidade Ciclomática e ABC Score (RubyCritic)

| Métrica | Valor |
| :--- | :--- |
| Maior ABC Score antes da refatoração | [Valor numérico] |
| Maior ABC Score após a refatoração | [Valor numérico] |
| Quantidade de métodos refatorados | [Quantidade ou descrição, ex: 2 métodos divididos] |
| Limite estabelecido | < 20 |

**Análise:**
[Escreva uma breve análise explicando qual era o método problemático, por que a nota estava alta e qual foi a solução aplicada (ex: Extract Method) para baixar a nota.]

#### Cobertura de Testes (SimpleCov)

| Componente | Cobertura |
| :--- | :--- |
| Models (`[nomes_dos_arquivos.rb]`) | [Valor]% |
| Controllers (`[nomes_dos_arquivos.rb]`) | [Valor]% |

**Análise:**
[Breve parágrafo informando se a cobertura de testes atingiu a meta exigida de >90%.]

#### Happy Path e Sad Path

| Item | Situação |
| :--- | :--- |
| Happy Path | [ ✔ ou ✖ ] |
| Sad Path | [ ✔ ou ✖ ] |

Todos os cenários de teste abrangem caminhos de sucesso e caminhos de erro, validando o comportamento esperado do sistema. As features originais do Cucumber foram mantidas e executadas com sucesso, garantindo a ausência de regressões.

#### Documentação (RDoc)

| Item | Valor |
| :--- | :--- |
| Métodos documentados | [Valor] |
| Controllers documentados | [Valor] |
| Models documentados | [Valor] |

Todos os métodos implementados ou modificados receberam documentação estruturada contendo:
* Descrição técnica da operação;
* Parâmetros e argumentos recebidos;
* Valor de retorno esperado;
* Possíveis efeitos colaterais na base de dados ou na sessão.

#### Comparação Antes × Depois

| Item | Antes | Depois |
| :--- | :--- | :--- |
| ABC Score máximo | [Valor] | [Valor] |
| Cobertura dos testes | [Valor]% | [Valor]% |
| Métodos documentados | [Valor] | [Valor] |

# Métricas de Qualidade - Arthur
#### Complexidade Ciclomática e ABC Score (RubyCritic)

| Métrica | Valor |
| :--- | :--- |
| Maior ABC Score antes da refatoração | [Valor numérico] |
| Maior ABC Score após a refatoração | [Valor numérico] |
| Quantidade de métodos refatorados | [Quantidade ou descrição, ex: 2 métodos divididos] |
| Limite estabelecido | < 20 |

**Análise:**
[Escreva uma breve análise explicando qual era o método problemático, por que a nota estava alta e qual foi a solução aplicada (ex: Extract Method) para baixar a nota.]

#### Cobertura de Testes (SimpleCov)

| Componente | Cobertura |
| :--- | :--- |
| Models (`[nomes_dos_arquivos.rb]`) | [Valor]% |
| Controllers (`[nomes_dos_arquivos.rb]`) | [Valor]% |

**Análise:**
[Breve parágrafo informando se a cobertura de testes atingiu a meta exigida de >90%.]

#### Happy Path e Sad Path

| Item | Situação |
| :--- | :--- |
| Happy Path | [ ✔ ou ✖ ] |
| Sad Path | [ ✔ ou ✖ ] |

Todos os cenários de teste abrangem caminhos de sucesso e caminhos de erro, validando o comportamento esperado do sistema. As features originais do Cucumber foram mantidas e executadas com sucesso, garantindo a ausência de regressões.

#### Documentação (RDoc)

| Item | Valor |
| :--- | :--- |
| Métodos documentados | [Valor] |
| Controllers documentados | [Valor] |
| Models documentados | [Valor] |

Todos os métodos implementados ou modificados receberam documentação estruturada contendo:
* Descrição técnica da operação;
* Parâmetros e argumentos recebidos;
* Valor de retorno esperado;
* Possíveis efeitos colaterais na base de dados ou na sessão.

#### Comparação Antes × Depois

| Item | Antes | Depois |
| :--- | :--- | :--- |
| ABC Score máximo | [Valor] | [Valor] |
| Cobertura dos testes | [Valor]% | [Valor]% |
| Métodos documentados | [Valor] | [Valor] |

# Métricas de Qualidade - Maria Luiza Rodrigues
#### Complexidade Ciclomática e ABC Score (RubyCritic)

| Métrica | Valor |
| :--- | :--- |
| Maior ABC Score antes da refatoração | 28.5 |
| Maior ABC Score após a refatoração | 8.2 |
| Quantidade de métodos refatorados | 1 método principal extraído para 3 auxiliares |
| Limite estabelecido | < 20 |

**Análise:**
O método `exportar_csv` do `AvaliacoesController` apresentava um ABC Score de 28.5 por acumular validação de dados, iteração de CSV e respostas HTTP. A lógica foi reorganizada por meio de separação de responsabilidades (Extract Method) para os novos métodos privados `gerar_csv_respostas` e `redirecionar_sem_respostas`. Isso reduziu a complexidade máxima da classe para 8.2, cumprindo o limite exigido para a entrega. Os demais controllers e models já operavam com médias de complexidade baixas (3.9 e 6.7 por método).

#### Cobertura de Testes (SimpleCov)

| Componente | Cobertura |
| :--- | :--- |
| Models (`avaliacao.rb`, `template.rb`, `questao.rb`, `resposta.rb`) | 100% |
| Controllers (`avaliacoes_controller.rb`, `templates_controller.rb`) | 100% |

**Análise:**
Após a execução da suite do RSpec via SimpleCov, todos os ficheiros correspondentes a esta frente de trabalho atingiram cobertura máxima (100%), superando a meta estabelecida de 90%.

#### Happy Path e Sad Path

| Item | Situação |
| :--- | :--- |
| Happy Path | ✔ |
| Sad Path | ✔ |

Todos os cenários de teste abrangem caminhos de sucesso e caminhos de erro, validando o comportamento esperado para submissões válidas e inválidas de formulários. As features originais do Cucumber foram mantidas sem alterações, garantindo a ausência de regressões no sistema após a refatoração.

#### Documentação (RDoc)

| Item | Valor |
| :--- | :--- |
| Métodos documentados | 31 |
| Controllers documentados | 2 |
| Models documentados | 1 |

Todos os métodos implementados ou modificados receberam documentação estruturada contendo:
* Descrição técnica da operação;
* Parâmetros e argumentos recebidos;
* Valor de retorno esperado;
* Possíveis efeitos colaterais na base de dados ou na sessão.

#### Comparação Antes × Depois

| Item | Antes | Depois |
| :--- | :--- | :--- |
| ABC Score máximo | 28.5 | 8.2 |
| Cobertura dos testes | 82.82% (Global) | 100% (Local) |
| Métodos documentados | 0 | 31 |
# Ferramentas Utilizadas

| Ferramenta | Finalidade |
|-------------|------------|
| Saikuro | Análise da complexidade ciclomática |
| RubyCritic | Análise do ABC Score e qualidade do código |
| SimpleCov | Medição da cobertura dos testes |
| RSpec | Testes automatizados |
| Cucumber | Testes funcionais (Happy Path e Sad Path) |
| RDoc | Geração da documentação do código |

---

# Resultados

Durante esta sprint foi possível melhorar significativamente a qualidade do código por meio da redução da complexidade dos métodos, aumento da cobertura dos testes automatizados e documentação das funcionalidades implementadas.

Os resultados obtidos nas ferramentas foram:

- **Maior complexidade ciclomática:** X → X
- **Maior ABC Score:** X → X
- **Cobertura total dos testes:** X%
- **Métodos documentados:** X
- **Métodos refatorados:** X

As refatorações realizadas não alteraram o comportamento do sistema, preservando todas as funcionalidades implementadas nas sprints anteriores e tornando o código mais organizado, legível e de fácil manutenção.
