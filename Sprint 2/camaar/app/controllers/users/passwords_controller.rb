# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  # POST /users/password (solicitar redefinição - Issue #107)
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      render json: { message: 'E-mail de redefinição de senha enviado com sucesso.' }, status: :ok
    else
      render json: { message: 'E-mail não encontrado.', errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /users/password (redefinir senha com token - Issue #107)
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      render json: { message: 'Senha redefinida com sucesso.' }, status: :ok
    else
      render json: { message: 'Token inválido ou expirado.', errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
