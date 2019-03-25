class Operation < ApplicationRecord
  belongs_to :account

  DEPOSIT     = I18n.t('activerecord.attributes.operation.deposit')
  REMISSION   = I18n.t('activerecord.attributes.operation.remission')
  WITHDRAWAL  = I18n.t('activerecord.attributes.operation.withdrawal')

  TRANSACTIONS = [DEPOSIT, WITHDRAWAL, REMISSION]

  default_scope { order('value_date') }

  VALID_DECIMAL_REGEX = /\A\d+(\.)?(\d{0,2})?\z/

  validates :operation_type, presence: true, inclusion: {in: TRANSACTIONS}

  validates :rate, presence: true, format: { with: VALID_DECIMAL_REGEX },
            numericality: {greater_than_or_equal_to: 0}, if: Proc.new { |op| op.operation_type != WITHDRAWAL }

  validates :sum,         presence: true, format: {with: VALID_DECIMAL_REGEX}, numericality: {greater_than: 0}
  validates :value_date,  presence: true
  validates :close_date,  presence: true, if: Proc.new { |op| op.operation_type != WITHDRAWAL }
  validates :withholding, presence: true, format: {with: VALID_DECIMAL_REGEX},
                          numericality: {greater_than_or_equal_to: 0}, if: Proc.new { |op| op.operation_type != WITHDRAWAL }
  validates :account_id,  presence: true

  before_validation :check_balance,    if: Proc.new { |op| op.operation_type == WITHDRAWAL }
  before_validation :check_close_date, if: Proc.new { |op| op.operation_type != WITHDRAWAL }
  before_save :calculate_total

private

  def calculate_total
    if operation_type != WITHDRAWAL
      calculate_duration
      calculate_interests
      self.total = interests + sum
    else
      self.total      = -sum
      self.duration   = nil
      self.rate       = nil
      self.interests  = nil
    end
  end

  def calculate_interests
    brut_interests = calculate_brut_interests
    self.interests = brut_interests - brut_interests * withholding.to_f/100
  end

  def calculate_brut_interests
    sum.to_f * duration/365 * (rate.to_f/100)
  end


  def calculate_duration
    self.duration = (close_date - value_date).to_i
  end

  def check_balance
    self.sum ||= 0
    if account.operations.empty? || sum > account_balance
      errors.add(:base, I18n.t(:insufficient_balance, balance: account_balance.round(2), sum: sum))
    end
  end

  def account_balance
    account.balance
  end

  def check_close_date
    errors[:base] << I18n.t(:duration_error) if value_date.nil? || close_date.nil? || value_date > close_date
  end
end
