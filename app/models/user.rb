class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :providers, inverse_of: :user, dependent: :destroy

  has_one :facebook, -> (user) { user.providers.facebook },
          class_name: "Provider"
end
