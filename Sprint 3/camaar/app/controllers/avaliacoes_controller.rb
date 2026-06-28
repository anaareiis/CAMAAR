require 'csv'

# Controla a criação, listagem, resposta e visualização de resultados dos
# formulários de avaliação dos fluxos #99, #109, #110 e #113.
class AvaliacoesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: [:new, :create, :resultados, :exportar_csv]
  before_action :set_avaliacao, only: [:show, :responder, :submeter, :resultados, :exportar_csv]
  layout 'authenticated'

  def index
    @avaliacoes = Avaliacao.visiveis_para(current_user)
  end

  def show; end

  def new
    @avaliacao = Avaliacao.new
    carregar_opcoes_formulario
  end

  def create
    @avaliacao = Avaliacao.new(avaliacao_params)
    if @avaliacao.save
      redirect_to avaliacoes_path, notice: 'Formulário disponibilizado para a turma.'
    else
      carregar_opcoes_formulario
      render :new, status: :unprocessable_entity
    end
  end

  def responder
    return redirect_to avaliacoes_path, alert: 'Você já respondeu este formulário.' if ja_respondeu?

    carregar_questoes
  end

  def submeter
    return redirect_to avaliacoes_path, alert: 'Você já respondeu este formulário.' if ja_respondeu?

    if Resposta.salvar_lote(build_respostas)
      redirect_to avaliacoes_path, notice: 'Respostas enviadas com sucesso.'
    else
      renderizar_resposta_invalida
    end
  end

  def resultados
    @questoes = @avaliacao.questoes_com_respostas
    @total_respostas = @avaliacao.total_respondentes
  end

  def exportar_csv
    respostas = Resposta.where(avaliacao: @avaliacao)

    if respostas.empty?
      redirect_to resultados_avaliacao_path(@avaliacao),
                  alert: 'Não existem respostas para exportar'
      return
    end

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['Aluno', 'Questão', 'Resposta']

      respostas.includes(:user, :questao).each do |resposta|
        csv << [
          resposta.user.name,
          resposta.questao.enunciado,
          resposta.texto
        ]
      end
    end

    send_data csv_data,
              filename: "avaliacao_#{@avaliacao.id}.csv",
              type: 'text/csv'
  end

  private

  # Carrega a avaliação informada na rota.
  #
  # Não recebe argumentos; usa +params[:id]+. Retorna a instância carregada por
  # atribuição em +@avaliacao+ e levanta +ActiveRecord::RecordNotFound+ quando
  # o id não existe. Não altera o banco de dados.
  def set_avaliacao
    @avaliacao = Avaliacao.find(params[:id])
  end

  # Filtra os parâmetros permitidos para criar uma avaliação.
  #
  # Não recebe argumentos; lê +params[:avaliacao]+. Retorna um hash de
  # parâmetros fortes com template, turma, datas e tipo. Não possui efeitos
  # colaterais.
  def avaliacao_params
    params.require(:avaliacao).permit(:template_id, :turma_id, :data_inicio, :data_fim, :tipo)
  end

  # Carrega templates e turmas necessários ao formulário de criação.
  #
  # Não recebe argumentos. Retorna os dados por meio de +@templates+ e
  # +@turmas+. Não altera o banco de dados.
  def carregar_opcoes_formulario
    @templates = Template.all
    @turmas = Turma.includes(:disciplina).all
  end

  # Verifica se o usuário atual já respondeu a avaliação carregada.
  #
  # Não recebe argumentos. Retorna +true+ ou +false+. Não altera o banco de
  # dados.
  def ja_respondeu?
    @avaliacao.respondida_por?(current_user)
  end

  # Carrega as questões do template da avaliação atual.
  #
  # Não recebe argumentos. Retorna os dados por meio de +@questoes+. Não altera
  # o banco de dados.
  def carregar_questoes
    @questoes = @avaliacao.template.questoes
  end

  # Cria respostas em memória a partir do payload do formulário.
  #
  # Não recebe argumentos; lê +params[:respostas]+. Retorna um array de
  # +Resposta+. Não persiste registros no banco.
  def build_respostas
    (params[:respostas]&.to_unsafe_h || {}).map do |questao_id, texto|
      Resposta.new(user: current_user, avaliacao: @avaliacao,
                   questao_id: questao_id, texto: texto)
    end
  end

  # Renderiza novamente o formulário quando a submissão é inválida.
  #
  # Não recebe argumentos. Retorna resposta HTTP 422 com as questões carregadas
  # e mensagem de alerta. Não altera o banco de dados.
  def renderizar_resposta_invalida
    carregar_questoes
    flash.now[:alert] = 'Preencha todas as questões.'
    render :responder, status: :unprocessable_entity
  end
end
