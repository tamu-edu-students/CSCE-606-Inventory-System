require 'devise'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    #User can ahve multiple bins
    has_many :bins, dependent: :destroy
    has_many :items, dependent: :destroy
    has_many :logs, dependent: :destroy

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
    has_many :friendships, dependent: :destroy
    has_many :friends, through: :friendships
    has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy
    has_many :inverse_friends, through: :inverse_friendships, source: :user
    
    # Shared bins relationships
    has_many :shared_bins, foreign_key: 'shared_with_id', dependent: :destroy
    has_many :shared_with_bins, through: :shared_bins, source: :bin
    has_many :inverse_shared_bins, class_name: 'SharedBin', foreign_key: 'user_id'
    has_many :shared_with_others_bins, through: :inverse_shared_bins, source: :bin
    
    def all_friends
      friends + inverse_friends
    end
    
    def accessible_bins
      bins + shared_with_bins
    end
    
    def can_access_bin?(bin)
      bin.user_id == id || shared_with_bins.include?(bin)
    end

    def accessible_items
      items + shared_with_bins.map(&:items).flatten
    end

    def shared_with_users
      inverse_shared_bins.map(&:shared_with).uniq
    end
end
