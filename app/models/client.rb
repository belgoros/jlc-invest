class Client < ActiveRecord::Base
  attr_accessible :box, :city, :country, :firstname, :house, :lastname, :phone, 
  :street, :zipcode
  
  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname, presence: true, length: { maximum: 50 }, 
                       uniqueness: { case_sensitive: false, scope: "firstname"}
  validates :street, presence: true, length: { maximum: 50 }
  validates :house, presence: true, length: { maximum: 5 }
  validates :zipcode, presence: true, length: { maximum: 5 }
  validates :city, presence: true, length: { maximum: 50 }
  validates :country, presence: true, length: { maximum: 10 }
  
  before_save do |client|
    client.firstname = firstname.capitalize.strip
    client.lastname = lastname.upcase.strip
    client.street = street.capitalize.strip        
    client.zipcode = zipcode.strip
    client.city = city.capitalize.strip
    client.country = country.upcase.strip    
  end
end
