class Client < ActiveRecord::Base
  has_many :accounts, dependent: :destroy
  default_scope { order('lastname') }

  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname,  presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false, scope: "firstname" }
  validates :street,    presence: true, length: { maximum: 50 }
  validates :house,     presence: true, length: { maximum: 5  }
  validates :zipcode,   presence: true, length: { maximum: 5  }
  validates :city,      presence: true, length: { maximum: 50 }
  validates :country,   presence: true, length: { maximum: 50 }
  validates :phone,     length: { maximum: 50 }

  scope :accounts_sum, -> { includes(accounts: :operations).order('clients.lastname') }

  before_validation do |client|
    client.firstname = firstname.strip.split('-').map(&:capitalize).join('-') unless firstname.blank?
    client.lastname  = lastname.strip.upcase unless lastname.blank?
  end

  before_save do |client|
    client.street    = street.strip.capitalize
    client.zipcode   = zipcode.strip
    client.city      = city.strip.capitalize
    client.country   = country.strip.upcase
    client.phone     = phone.strip unless phone.blank?
  end

  def full_name
    ["#{firstname}", "#{lastname}"].join(' ')
  end

  def zip_city_country
    zipcode + ' ' + city + ' ' + country
  end

  def accounts_balance
    balance = 0
    balance = accounts.map(&:balance).inject(:+) unless accounts.empty?
    balance
  end
end
