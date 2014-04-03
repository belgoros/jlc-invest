class Admin < ActiveRecord::Base

  has_secure_password

  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  before_save :normalize_admin_identity
  before_create :create_remember_token

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def full_name
    ["#{firstname}", "#{lastname}"].join(' ')
  end

  def normalize_admin_identity
    self.email     = email.downcase.strip
    self.firstname = firstname.strip.split('-').map(&:capitalize).join('-')
    self.lastname  = lastname.upcase.strip
  end

  protected :normalize_admin_identity


  private

  def create_remember_token
    self.remember_token = Admin.hash(Admin.new_remember_token)
  end

end
