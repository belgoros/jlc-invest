class AccountsController < ApplicationController
  before_filter :signed_in_user

  def create
    @client = Client.find(params[:account][:client_id])
    @client.accounts.create!
    flash[:success] = t(:created_success, model: Account.model_name.human)
    redirect_to @client
  end

  def show
    @account = Account.find(params[:id])
    @operations = @account.operations.paginate(page: params[:page])
  end

  def destroy
    @client = Account.find(params[:id]).client
    @client.accounts.find(params[:id]).destroy
    flash[:success] = t(:destroyed_success, model: Account.model_name.human)
    redirect_to @client
  end

end
