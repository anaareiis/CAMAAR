class UpdateDataController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  layout 'authenticated'


  def index
    
  end

  def update
    result = UpdateDataService.update_all

    if result[:success]
      redirect_to dashboard_path, notice: result[:message]
    else
      redirect_to dashboard_path, alert: result[:error]
    end
  end

  private

  def require_admin!
    unless current_user&.admin?
      render json: { message: 'Acesso negado.' }, status: :forbidden
    end
  end
end