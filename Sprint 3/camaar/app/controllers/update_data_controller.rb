# Responsável por receber as requisições de atualização de dados do SIGAA
# e delegar o processamento para o UpdateDataService.
class UpdateDataController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  layout 'authenticated'

  def update
    result = UpdateDataService.update_all

    if result[:success]
      redirect_to dashboard_path, notice: result[:message]
    else
      redirect_to dashboard_path, alert: result[:error]
    end
  end
end