class ImportDataController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def import

    result = ImportDataService.import_all

    if result[:success]
      redirect_to admin_path,
                  notice: 'Dados importados com sucesso'
    else
      redirect_to admin_path,
                  alert: result[:error]
    end
  end
end