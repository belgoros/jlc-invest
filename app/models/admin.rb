class Admin < ActiveRecord::Base

  has_secure_password

  attr_accessible :email, :firstname, :lastname, :password_digest, :remember_token,
  :password, :password_confirmation
  
  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
            uniqueness: { case_sensitive: false }
            
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  before_save do |user|
    user.email = email.downcase.strip
    user.firstname = firstname.capitalize.strip
    user.lastname = lastname.upcase.strip    
  end
  
  before_save :create_remember_token
  
  
  
  private
  
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
end
