require 'csv'

# Gerencia o ciclo de vida das avaliações:
# criação, resposta, resultados e exportação em CSV.
class AvaliacoesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!,
                only: [:new, :create, :resultados, :exportar_csv]
  before_action :set_avaliacao,
                only: [:show, :responder, :submeter,
                       :resultados, :exportar_csv]

  layout 'authenticated'

  # ───────────────────────────────────────────────
  # Actions
  # ───────────────────────────────────────────────

  def index
    @avaliacoes = AvaliacaoService.avaliacoes_para(current_user)
  end

  def show
  end

  def new
    @avaliacao = Avaliacao.new
    carregar_formulario
  end

  def create
    @avaliacao = Avaliacao.new(avaliacao_params)

    if @avaliacao.save
      redirect_to avaliacoes_path,
                  notice: 'Formulário disponibilizado para a turma.'
    else
      carregar_formulario
      render :new, status: :unprocessable_entity
    end
  end

  def responder
    if AvaliacaoService.ja_respondeu?(@avaliacao, current_user)
      redirect_to avaliacoes_path,
                  alert: 'Você já respondeu este formulário.'
    else
      @questoes = @avaliacao.template.questoes
    end
  end

  def submeter
    resultado = AvaliacaoService.submeter_respostas(
      avaliacao: @avaliacao,
      user: current_user,
      respostas_params: params[:respostas]
    )

    case resultado
    when :ja_respondeu
      redirect_to avaliacoes_path,
                  alert: 'Você já respondeu este formulário.'

    when true
      redirect_to avaliacoes_path,
                  notice: 'Respostas enviadas com sucesso.'

    else
      render_responder_com_erro
    end
  end

  def resultados
    @questoes = AvaliacaoService.questoes_resultado(@avaliacao)
    @total_respostas = AvaliacaoService.total_respostas(@avaliacao)
  end

  def exportar_csv
    csv = AvaliacaoService.exportar_csv(@avaliacao)

    unless csv
      redirect_to resultados_avaliacao_path(@avaliacao),
                  alert: 'Não existem respostas para exportar'
      return
    end

    send_data csv,
              filename: "avaliacao_#{@avaliacao.id}.csv",
              type: 'text/csv'
  end

  private

  # ───────────────────────────────────────────────
  # Helpers
  # ───────────────────────────────────────────────

  def carregar_formulario
    @templates = Template.all
    @turmas = Turma.includes(:disciplina).all
  end

  def render_responder_com_erro
    @questoes = @avaliacao.template.questoes
    flash.now[:alert] = 'Preencha todas as questões.'
    render :responder,
           status: :unprocessable_entity
  end

  def set_avaliacao
    @avaliacao = Avaliacao.find(params[:id])
  end

  def avaliacao_params
    params.require(:avaliacao).permit(
      :template_id,
      :turma_id,
      :data_inicio,
      :data_fim,
      :tipo
    )
  end
end