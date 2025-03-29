require 'devise'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    #User can ahve multiple bins
    has_many :bins, dependent: :destroy 
    has_many :items, dependent: :destroy 

    #User can have multiple locations
    has_many :locations, dependent: :destroy 
 
    # Validations
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :reset_code, uniqueness: true, allow_nil: true
    

    # Custom format validations for specific requirements
    validates :password, format: { with: /[A-Z]/, message: "must include at least one uppercase letter" }
    validates :password, format: { with: /[a-z]/, message: "must include at least one lowercase letter" }
    validates :password, format: { with: /\d/, message: "must include at least one number" }
    validates :password, format: { with: /[\W_]/, message: "must include at least one special character" }

end
