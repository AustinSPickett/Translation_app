class User < ApplicationRecord
  attr_accessor :remember_token
  
  before_save {self.email = email.downcase}  ### this will converte all emails to lowercase before saving them. 1. we did this to prevent multiple indexes for the same email due to casing 
  validates :name, presence: true, length: {minimum: 4, maximum: 50}
  
  #to truly check for duplicates we have indexed the email field in user using:
  #$rails generate migration add_index_to_users_email
  # 1. it is users because we are changing the database not the model 
  # 2. dont forget to db:migrate before moving on 
  VALID_EMAIL_REGEX =/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i 
  validates :email, presence: true, length: {maximum: 255},
                    format:{ with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive:false}
  has_secure_password                  
  validates :password, presence: true, length: { minimum: 6 }
  
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : Bcrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end 
  
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end 
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end 
  
  # Returns true if the given token matches the diest.
  def authenticated?(remember_token)#the remember_token here is not the same as attr_accessor :remember_token 
    #this will prevent an error from happending in BCript when a second browser is used after loging out in one
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end 
  
  # Forgets a user.
  def forget 
    update_attribute(:remember_digest, nil)
  end 
    
end
