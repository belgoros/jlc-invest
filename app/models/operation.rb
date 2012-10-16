class Operation < ActiveRecord::Base
  belongs_to :client

  default_scope order: 'operations.value_date DESC'

  TRANSACTIONS = %w(deposit withdrawal)

  attr_accessible :operation_type, :duration, :rate, :interests, :sum, :total, :value_date, :close_date

  VALID_DECIMAL_REGEX = /^\d+(\.)?(\d{0,2})?$/

  validates :operation_type, presence: true, inclusion: {in: TRANSACTIONS}
  validates :duration, presence: true, numericality: {greater_than: 0}, if: Proc.new { |op| op.operation_type == TRANSACTIONS[0] }
  validates :rate, presence: true, format: {with: VALID_DECIMAL_REGEX}, numericality: {greater_than: 0},
            if: Proc.new { |op| op.operation_type == TRANSACTIONS[0] }

  validates :sum, presence: true, format: {with: VALID_DECIMAL_REGEX}, numericality: {greater_than: 0}
  validates :total, presence: true, numericality: true
  validates :value_date, presence: true
  validates :client_id, presence: true

  before_validation :calculate_interests_and_total




  private

#Exemple
#
#Un placement de 1.000 € sur 6 mois au taux annuel de 12 %.
#Avec des intérêts simples, le taux périodique proportionnel sera de 0,12  x 6 mois / 12 mois, soit 6 %.
#Le montant des intérêts sera alors de 1.000 x 6 / 100, soit 60 €.
#Pour une durée d'un an, les intérêts seront de 60 € × 2 = 120 €.

  def calculate_interests_and_total
    self.duration ||= 0
    self.rate ||= 0
    self.sum ||= 0
    if operation_type == TRANSACTIONS[0]
      self.interests = sum * (rate/100.to_f * duration/12).round(2)
    end
    if operation_type == TRANSACTIONS[0]
      self.total = interests + sum
    else
      check_balance
      self.total = -sum
    end

  end

  def check_balance
    errors.add(:sum, "#{sum} exceeds the actual balance") if client.operations.empty? || sum > client.operations.map(&:total).inject(:+)
  end


end
