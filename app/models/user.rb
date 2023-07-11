class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # Esto crea el token cada vez que se crea un usuario nuevo
  acts_as_token_authenticatable
  has_many :reviews

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def generate_new_authentication_token
    token = User.generate_unique_secure_token
    update(authentication_token: token)
  end

end
