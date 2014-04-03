class OperationsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :new, :edit, :show, :update, :destroy]
  before_filter :find_account,   except: :index

  def index
    all_operations = Client.accounts_sum
    @operations    = all_operations.paginate(page: params[:page])
    @total         = all_operations.map(&:accounts_balance).inject(:+) unless all_operations.empty?
  end

  def new
    @operation = @account.operations.new
  end

  def create
    @operation = @account.operations.new(operation_params)
    if @operation.save
      redirect_to @account, notice: t(:created_success, model: Operation.model_name.human)
    else
      render "new"
    end
  end

  def edit
    @operation = @account.operations.find(params[:id])
  end

  def show
    @operation = @account.operations.find(params[:id])
    report     = OperationReport.new()
    output     = report.to_pdf(@operation)
    respond_to do |format|
      format.pdf do
        send_data output, type: :pdf, disposition: "inline"
      end
    end
  end

  def update
    @operation = @account.operations.find(params[:id])
    if @operation.update_attributes(operation_params)
      redirect_to @account, notice: t(:updated_success, model: Operation.model_name.human)
    else
      render 'edit'
    end
  end

  def destroy
    @account.operations.find(params[:id]).destroy
    redirect_to @account, notice: t(:destroyed_success, model: Operation.model_name.human)
  end


  private

    def find_account
      @account = Account.find(params[:account_id])
      @balance = @account.balance
    end

    def operation_params
      params.require(:operation).permit(:operation_type, :duration, :rate, :interests, :sum, :total, :value_date, :close_date, :withholding)
    end
end
