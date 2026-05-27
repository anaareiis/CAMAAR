class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :login

  ROLES = %w[admin user].freeze
  validates :name, presence: true
  validates :role, inclusion: { in: ROLES }, allow_nil: true
  validates :matricula, uniqueness: true, allow_nil: true

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)&.downcase
    where(conditions.to_h).where(
      'lower(email) = :value OR lower(matricula) = :value', value: login
    ).first
  end

  def admin?
    role == 'admin'
  end
end
