# frozen_string_literal: true

class Admin::TurmasController < ApplicationController
  before_action :require_admin!
  layout 'authenticated'

  # GET /admin/turmas
  def index
    @turmas = Turma.joins(:disciplina)
                   .where(disciplinas: { department: current_user.department })
                   .includes(:disciplina)
                   .order('disciplinas.codigo, turmas.semestre')
  end

  private

  def require_admin!
    unless current_user&.admin?
      render json: { message: 'Acesso negado.' }, status: :forbidden
    end
  end
end