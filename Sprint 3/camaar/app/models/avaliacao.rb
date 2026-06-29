# Representa um formulário de avaliação disponibilizado para uma turma, com
# público-alvo discente ou docente.
class Avaliacao < ApplicationRecord
  self.table_name = 'avaliacaos'

  TIPOS = %w[discente docente].freeze

  belongs_to :template
  belongs_to :turma
  has_many :respostas, dependent: :destroy

  validates :data_inicio, :data_fim, presence: true
  validates :tipo, inclusion: { in: TIPOS }
  validate :data_fim_posterior_a_data_inicio

  scope :com_dados_de_listagem, -> { includes(:template, turma: :disciplina) }
  scope :para_discentes, -> { where(tipo: 'discente') }
  scope :respondidas_por, ->(user) { joins(:respostas).where(respostas: { user_id: user.id }).distinct }
  scope :nao_respondidas_por, ->(user) { where.not(id: respondidas_por(user)) }

  # a. Descrição: Lista as avaliações visíveis para o usuário autenticado.
  # b. Argumentos: Recebe o argumento 'user' (objeto User), correspondente ao usuário que acessa a listagem.
  # c. Retorno: Retorna uma coleção de objetos Avaliacao (ActiveRecord::Relation).
  # d. Efeitos colaterais: Não possui efeitos colaterais no banco de dados.
  def self.visiveis_para(user)
    return com_dados_de_listagem.all if user.admin?

    com_dados_de_listagem
      .para_discentes
      .where(turma_id: user.turmas.select(:id))
      .nao_respondidas_por(user)
  end

  # a. Descrição: Verifica se o usuário informado já submeteu respostas para esta avaliação.
  # b. Argumentos: Recebe o argumento 'user' (objeto User).
  # c. Retorno: Retorna um valor booleano (true caso exista resposta, false caso contrário).
  # d. Efeitos colaterais: Não possui efeitos colaterais.
  def respondida_por?(user)
    respostas.exists?(user: user)
  end

  # a. Descrição: Carrega a coleção de questões associadas ao template da avaliação, incluindo suas respectivas respostas precarregadas (eager loading).
  # b. Argumentos: Não recebe argumentos.
  # c. Retorno: Retorna uma coleção de objetos Questao (ActiveRecord::Relation).
  # d. Efeitos colaterais: Não possui efeitos colaterais.
  def questoes_com_respostas
    template.questoes.includes(:respostas)
  end

  # a. Descrição: Conta o número total de usuários distintos que responderam a esta avaliação.
  # b. Argumentos: Não recebe argumentos.
  # c. Retorno: Retorna um número Inteiro (Integer) correspondente ao total de respondentes únicos.
  # d. Efeitos colaterais: Não possui efeitos colaterais.
  def total_respondentes
    respostas.select(:user_id).distinct.count
  end

  private

  # a. Descrição: Método de validação customizada para garantir coerência cronológica entre o início e o fim da avaliação.
  # b. Argumentos: Não recebe argumentos.
  # c. Retorno: Retorna nil caso válido, ou adiciona uma string ao array de 'errors' da instância.
  # d. Efeitos colaterais: Altera o estado interno do objeto injetando mensagens de erro. Não persiste diretamente no banco.
  def data_fim_posterior_a_data_inicio
    return unless data_inicio.present? && data_fim.present?
    return if data_fim > data_inicio

    errors.add(:data_fim, 'deve ser posterior à data de início')
  end
end