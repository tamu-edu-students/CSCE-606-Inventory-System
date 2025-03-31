require 'devise'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    #User can ahve multiple bins
    has_many :bins
    has_many :items

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

    # Friendship relationships
    has_many :friendships
    has_many :friends, through: :friendships, source: :friend
    has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
    has_many :inverse_friends, through: :inverse_friendships, source: :user
    
    # Shared bins relationships
    has_many :shared_bins, foreign_key: 'shared_with_id'
    has_many :shared_with_me_bins, through: :shared_bins, source: :bin
    has_many :inverse_shared_bins, class_name: 'SharedBin', foreign_key: 'shared_with_id'
    has_many :shared_with_others_bins, through: :inverse_shared_bins, source: :bin
    
    def all_friends
      (friends + inverse_friends).uniq
    end
    
    def accessible_bins
      Bin.where(id: (bins.pluck(:id) + shared_with_me_bins.pluck(:id)).uniq)
    end
    
    def can_access_bin?(bin)
      bin.user_id == id || shared_with_me_bins.include?(bin)
    end
end
