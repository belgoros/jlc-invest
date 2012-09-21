class Operation < ActiveRecord::Base
  belongs_to :client

  attr_accessible :close_date, :duration, :interests, :rate, :sum, :total, :type, :value_date
end
