class User < ApplicationRecord
  attr_accessor :remember_token
  validates :name, presence: true, length:{maximum:100}
  REG = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  validates :email, presence: true, length:{maximum:155},
                     format: {with:REG},
                     uniqueness: {case_sensitive: false}
  before_save :downcase_email
  has_secure_password

  def downcase_email
    self.email = email.downcase
  end 
  
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
      BCrypt::Password.create(string,cost: cost)
    end
    
    def new_token
      SecureRandom.urlsafe_base64
    end
    
  end

    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest ,User.digest(remember_token))
    end

    def authenticated?(name,token)
      digest = send("#{name}_digest")
      BCrypt::Password.new(digest).is_password?(params)
    end

    def forget
      update_attribute(:remember_digest, nil)
    end


end
