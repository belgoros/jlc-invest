class Account < ActiveRecord::Base
  belongs_to :client
  has_many :operations, dependent: :destroy

  validates :client_id, presence: true
  before_save :generate_account_number

  SEPARATOR = '-'

  def balance
    except_remissions     = deposits_and_withdrawals(operations)
    sum_except_remissions = except_remissions.map(&:total).inject(:+) || 0
    remissions_operations = remissions(operations)
    sum_except_remissions += remissions_operations.map(&:interests).inject(:+) unless remissions_operations.empty?
    sum_except_remissions
  end

  private

    def generate_account_number
      last_found  = Account.last
      year_prefix = Date.today.year.to_s
      acc_suffix  = 0
      acc_suffix  = last_found.acc_number.split(SEPARATOR).last.to_i if last_found
      self.acc_number = year_prefix << SEPARATOR << sprintf("%05d", acc_suffix + 1)
    end

    def deposits_and_withdrawals(items)
      items.select {|op| op.operation_type != Operation::REMISSION }
    end

    def remissions(items)
      items.select {|op| op.operation_type == Operation::REMISSION }
    end
end
