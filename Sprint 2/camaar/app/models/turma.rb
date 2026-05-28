class Turma < ApplicationRecord
  belongs_to :disciplina
  has_and_belongs_to_many :users

  validates :codigo, :semestre, :horario, presence: true
  validates :disciplina, presence: true
end