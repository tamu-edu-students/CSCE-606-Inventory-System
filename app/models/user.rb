class User < ApplicationRecord
    # Add bcrypt for secure password storage
    has_secure_password
    
    #User can ahve multiple bins
    has_many :bins, dependent: :destroy 

  
    # Validations
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    # Validate password presence, length, and complexity
    validates :password, presence: true, length: { minimum: 8 }, format: { 
      with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+\z/, 
      message: "must include at least one uppercase letter, one lowercase letter, one number, and one special character" 
    }    
end
