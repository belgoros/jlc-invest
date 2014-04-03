class AccountsController < ApplicationController
  before_filter :signed_in_user
  before_filter :find_client, only: :create

  def create
    @client.accounts.create!
    redirect_to @client, notice: t(:created_success, model: Account.model_name.human)
  end

  def show
    @account = Account.find(params[:id])
    @operations = @account.operations.paginate(page: params[:page])
  end

  def destroy
    @account = Account.find(params[:id])
    @client  = @account.client
    @account.destroy
    redirect_to @client, notice: t(:destroyed_success, model: Account.model_name.human)
  end

  def report
    @account = Account.find(params[:id])
    report   = AccountReport.new
    output   = report.to_pdf(@account)
    respond_to do |format|
      format.pdf do
        send_data output, type: :pdf, disposition: "inline"
      end
    end
  end

  private
    def find_client
      @client = Client.find(params[:account][:client_id])
    end

    def account_params
      params.require(:account).permit(:acc_number, :client_id)
    end

end
