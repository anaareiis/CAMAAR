class AvaliacoesController < ApplicationController
  def new
    @avaliacao = Avaliacao.new
    @templates = Template.all
  end

  def create
    @avaliacao = Avaliacao.new(avaliacao_params)
    if @avaliacao.save
      redirect_to avaliacoes_path, notice: "Formulário de avaliação disponibilizado para a turma."
    else
      @templates = Template.all
      render :new, status: :unprocessable_entity
    end
  end

  private

  def avaliacao_params
    params.require(:avaliacao).permit(:template_id, :turma_id, :data_inicio, :data_fim)
  end
end