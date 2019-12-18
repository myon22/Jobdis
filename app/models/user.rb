class User < ApplicationRecord
  attr_accessor :remember_token,:activation_token ,:reset_token
  before_save :downcase_email
  before_create :create_activation_digest 
  validates :name, presence: true, length:{maximum:100}
  REG = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  validates :email, presence: true, length:{maximum:155},
                     format: {with:REG},
                     uniqueness: {case_sensitive: false}
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

    def create_activation_digest
      self.activation_token = User.new_token
      self.activate_digest = User.digest(activation_token)
    end

    def create_reset_digest
      self.reset_token = User.new_token
      self.reset_digest = User.digest(reset_token)
    end

    def authenticated?(name,token)
      digest = send("#{name}_digest")
      BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
      update_attribute(:remember_digest, nil)
    end


end
