require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  describe 'POST /users/sign_in' do
    let!(:user) do
      User.create!(
        name: 'Usuário Comum',
        email: 'aluno@unb.br',
        password: 'senha123',
        role: 'user'
      )
    end

    let!(:admin) do
      User.create!(
        name: 'Administrador',
        email: 'admin@unb.br',
        password: 'admin123',
        role: 'admin',
        department: 'CIC'
      )
    end

    context 'Caminho Feliz - login com credenciais válidas' do
      it 'autentica usuário comum com sucesso' do
        post '/users/sign_in', params: {
          user: { email: 'aluno@unb.br', password: 'senha123' }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Login realizado com sucesso.')
        expect(JSON.parse(response.body)['user']['role']).to eq('user')
      end

      it 'autentica administrador e retorna seu papel' do
        post '/users/sign_in', params: {
          user: { email: 'admin@unb.br', password: 'admin123' }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['user']['role']).to eq('admin')
        expect(JSON.parse(response.body)['user']['department']).to eq('CIC')
      end
    end

    context 'Caminho Triste - credenciais inválidas' do
      it 'retorna erro com senha incorreta' do
        post '/users/sign_in', params: {
          user: { email: 'aluno@unb.br', password: 'senhaErrada' }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end

      it 'retorna erro com email inexistente' do
        post '/users/sign_in', params: {
          user: { email: 'inexistente@unb.br', password: 'qualquersenha' }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    it 'realiza logout com sucesso' do
      post '/users/sign_in', params: {
        user: { email: 'aluno@unb.br', password: 'senha123' }
      }, as: :json
      delete '/users/sign_out', as: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
