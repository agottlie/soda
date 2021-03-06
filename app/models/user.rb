class User < ApplicationRecord
	has_secure_password
	has_many :songs, :dependent => :destroy
	validates :password, presence: true, confirmation: true
	validates :password_confirmation, presence: true
	validates :email, presence: true, uniqueness: true, format: {
		with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
	}
end
