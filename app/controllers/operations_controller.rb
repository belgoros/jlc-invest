class OperationsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :new, :edit, :show, :update, :destroy]
  before_filter :find_account, except: :index

  def index    
    @operations = Account.operations_by_client.paginate(page: params[:page])
  end

  def new
    @operation = @account.operations.new
  end

  def create
    @operation = @account.operations.new(params[:operation])
    if @operation.save
      flash[:success] = t(:created_success, model: Operation.model_name.human)
      redirect_to @account
    else
      render "new"
    end
  end

  def edit
    @operation = @account.operations.find(params[:id])
  end 
  
  def show
    @operation = @account.operations.find(params[:id])    
    report = OperationReport.new()        
    output = report.to_pdf(@operation)    
    respond_to do |format|
      format.pdf do
        send_data output, type: :pdf, disposition: "inline"
      end
    end
  end

  def update
    @operation = @account.operations.find(params[:id])
    if @operation.update_attributes(params[:operation])
      flash[:success] = t(:updated_success, model: Operation.model_name.human)
      redirect_to @account
    else
      render 'edit'
    end
  end

  def destroy
    @account.operations.find(params[:id]).destroy
    flash[:success] = t(:destroyed_success, model: Operation.model_name.human)
    redirect_to @account
  end


  private
  def find_account
    @account = Account.find(params[:account_id])
    @balance = @account.balance
  end
end
