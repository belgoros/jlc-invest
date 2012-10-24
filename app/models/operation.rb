class Operation < ActiveRecord::Base
  belongs_to :client  
  
  DEPOSIT = 'deposit'
  REMISSION = 'remission'
  WITHDRAWAL = 'withdrawal'

  TRANSACTIONS = [DEPOSIT, WITHDRAWAL, REMISSION]
  
  default_scope order: 'operations.value_date DESC'

  attr_accessible :operation_type, :duration, :rate, :interests, :sum, :total, :value_date, :close_date

  VALID_DECIMAL_REGEX = /^\d+(\.)?(\d{0,2})?$/

  validates :operation_type, presence: true, inclusion: {in: TRANSACTIONS}

  validates :rate, presence: true, format: {with: VALID_DECIMAL_REGEX}, numericality: {greater_than: 0},
            if: Proc.new { |op| op.operation_type != WITHDRAWAL }

  validates :sum, presence: true, format: {with: VALID_DECIMAL_REGEX}, numericality: {greater_than: 0}
  validates :value_date, presence: true
  validates :close_date, presence: true, if: Proc.new { |op| op.operation_type != WITHDRAWAL }
  validates :client_id, presence: true
  
  
  
  before_validation :check_balance, if: Proc.new { |op| op.operation_type == WITHDRAWAL }
  before_save :calculate_total  
  
  private
        
    def calculate_total      
       if operation_type != WITHDRAWAL
         calculate_duration
         self.interests = sum.to_f * duration/365 * (rate.to_f/100)
         self.total = interests + sum
       else
         self.total = -sum
       end
    end


    def calculate_duration
      self.duration = (close_date - value_date).to_i
    end

    def check_balance      
      if client.operations.empty? || sum > account_balance
        errors.add(:sum, "#{sum} exceeds the actual balance") 
      end      
    end
    
    def account_balance
      client.operations.map(&:total).inject(:+)
    end


end
