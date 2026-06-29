require 'csv'

# Responsável pelas regras de negócio relacionadas às avaliações.
class AvaliacaoService

  CSV_HEADERS = ['Aluno', 'Questão', 'Resposta'].freeze

  # ───────────────────────────────────────────────
  # Listagem
  # ───────────────────────────────────────────────

  def self.avaliacoes_para(user)
    return avaliacoes_admin if user.admin?

    avaliacoes_discente(user)
  end

  def self.avaliacoes_admin
    Avaliacao.includes(:template, :turma).all
  end

  def self.avaliacoes_discente(user)
    turma_ids = user.turmas.pluck(:id)

    Avaliacao.includes(:template, turma: :disciplina)
             .para_discentes
             .where(turma_id: turma_ids)
             .nao_respondidas_por(user)
  end

  # ───────────────────────────────────────────────
  # Respostas
  # ───────────────────────────────────────────────

  def self.ja_respondeu?(avaliacao, user)
    Resposta.exists?(
      avaliacao: avaliacao,
      user: user
    )
  end

  def self.submeter_respostas(avaliacao:, user:, respostas_params:)
    return :ja_respondeu if ja_respondeu?(avaliacao, user)

    respostas = build_respostas(
      avaliacao: avaliacao,
      user: user,
      respostas: respostas_params
    )

    respostas.any? &&
      respostas.all?(&:valid?) &&
      respostas.all?(&:save)
  end

  def self.build_respostas(avaliacao:, user:, respostas:)
    (respostas&.to_unsafe_h || {}).map do |questao_id, texto|
      nova_resposta(
        avaliacao,
        user,
        questao_id,
        texto
      )
    end
  end

  def self.nova_resposta(avaliacao, user, questao_id, texto)
    Resposta.new(
      avaliacao: avaliacao,
      user: user,
      questao_id: questao_id,
      texto: texto
    )
  end

  # ───────────────────────────────────────────────
  # Resultados
  # ───────────────────────────────────────────────

  def self.questoes_resultado(avaliacao)
    avaliacao
      .template
      .questoes
      .includes(:respostas)
  end

  def self.total_respostas(avaliacao)
    Resposta.where(avaliacao: avaliacao)
            .select(:user_id)
            .distinct
            .count
  end

  # ───────────────────────────────────────────────
  # CSV
  # ───────────────────────────────────────────────

  def self.exportar_csv(avaliacao)
    respostas = respostas_da_avaliacao(avaliacao)
    return nil if respostas.empty?

    gerar_csv(respostas)
  end

  def self.respostas_da_avaliacao(avaliacao)
    Resposta.where(avaliacao: avaliacao)
  end

  def self.gerar_csv(respostas)
    CSV.generate(headers: true) do |csv|
      csv << CSV_HEADERS
      adicionar_respostas_csv(csv, respostas)
    end
  end

  def self.adicionar_respostas_csv(csv, respostas)
    respostas.includes(:user, :questao).each do |resposta|
      csv << linha_csv(resposta)
    end
  end

  def self.linha_csv(resposta)
    [
      resposta.user.name,
      resposta.questao.enunciado,
      resposta.texto
    ]
  end

end