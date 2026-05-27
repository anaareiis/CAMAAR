class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[admin user].freeze
  validates :name, presence: true
  validates :role, inclusion: { in: ROLES }, allow_nil: true

  def admin?
    role == 'admin'
  end
end
