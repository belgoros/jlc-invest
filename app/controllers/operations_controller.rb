class OperationsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :new, :edit, :update, :destroy]
  before_filter :find_account, except: :index

  def index
    @operations = Account.joins(:client, :operations).select('clients.firstname, clients.lastname, sum(operations.total) as total').group('clients.id, clients.firstname, clients.lastname').order('clients.lastname').paginate(page: params[:page])
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
  end
end
