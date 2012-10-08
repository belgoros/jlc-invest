class Operation < ActiveRecord::Base
  belongs_to :client
  
  TRANSACTIONS = %w{deposit withdrawal}
  
  attr_accessible :operation_type, :duration, :rate, :interests, :sum, :total, :value_date, :close_date  
  
  VALID_DECIMAL_REGEX = /^\d+(\.)?(\d{0,2})?$/
  
  validates :operation_type, presence: true, inclusion: { in: TRANSACTIONS}
  validates :duration, presence: true, numericality: {greater_than: 0}
  validates :rate, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: {greater_than: 0}
  validates :interests, presence: true, if: Proc.new { |op| op.operation_type == TRANSACTIONS[0] }, numericality: {greater_than: 0}
  validates :sum, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: {greater_than: 0}
  validates :total, presence: true, numericality: {greater_than: 0}
  validates :value_date, presence: true
  validates :client_id, presence: true  
  
  before_validation :calculate_interests_and_total
  before_validation {|op| op.value_date = Date.today}
  
  #before_save :format_decimal_values
  
  private
  
    def calculate_interests_and_total     
      self.sum ||= 0
      self.rate ||= 0
      self.duration ||= 0
      self.interests = sum * (rate/100 * duration/12)
      self.total = interests + sum    
    end

    def format_decimal_values
      self.rate = rate.to_s.sub(/,/, '.').to_f
      self.sum = sum.to_s.sub(/,/, '.').to_f    
    end

end
