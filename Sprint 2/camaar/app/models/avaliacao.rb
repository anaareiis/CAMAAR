class Avaliacao < ApplicationRecord
  belongs_to :template
  belongs_to :turma 

  validates :data_inicio, :data_fim, presence: true
  validate :data_fim_posterior_a_data_inicio

  private

  def data_fim_posterior_a_data_inicio
    if data_inicio.present? && data_fim.present? && data_fim <= data_inicio
      errors.add(:data_fim, "deve ser posterior à data de início")
    end
  end
end