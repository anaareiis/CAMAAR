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

  # Lista as avaliações visíveis para o usuário informado.
  #
  # +user+ - usuário autenticado que acessa a listagem.
  # Retorna uma relação de +Avaliacao+. Para admins, contém todos os
  # formulários; para discentes, contém apenas avaliações discentes das turmas
  # em que estão matriculados e ainda não respondidas. Não altera o banco de
  # dados.
  def self.visiveis_para(user)
    return com_dados_de_listagem.all if user.admin?

    com_dados_de_listagem
      .para_discentes
      .where(turma_id: user.turmas.select(:id))
      .nao_respondidas_por(user)
  end

  # Verifica se o usuário informado já respondeu esta avaliação.
  #
  # +user+ - usuário autenticado consultado.
  # Retorna +true+ quando existe ao menos uma resposta desse usuário para a
  # avaliação; caso contrário, retorna +false+. Não altera o banco de dados.
  def respondida_por?(user)
    respostas.exists?(user: user)
  end

  # Carrega as questões do template com suas respostas.
  #
  # Não recebe argumentos. Retorna uma relação de +Questao+ com respostas em
  # eager loading para a tela de resultados. Não altera o banco de dados.
  def questoes_com_respostas
    template.questoes.includes(:respostas)
  end

  # Conta quantos usuários distintos responderam esta avaliação.
  #
  # Não recebe argumentos. Retorna um inteiro com o total de respondentes
  # únicos. Não altera o banco de dados.
  def total_respondentes
    respostas.select(:user_id).distinct.count
  end

  private

  # Valida se a data de fim ocorre após a data de início.
  #
  # Não recebe argumentos. Retorna +nil+ e adiciona erro em +data_fim+ quando o
  # período é inválido. Não persiste alterações no banco de dados.
  def data_fim_posterior_a_data_inicio
    return unless data_inicio.present? && data_fim.present?
    return if data_fim > data_inicio

    errors.add(:data_fim, 'deve ser posterior à data de início')
  end
end
