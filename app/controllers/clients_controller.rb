class ClientsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :new, :edit, :update, :destroy]

  def index
    @clients = Client.paginate(page: params[:page])
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      flash[:success] = t(:created_success, model: Client.model_name.human)
      redirect_to clients_path
    else
      render "new"
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def show
    @client   = Client.find(params[:id])
    @accounts = @client.accounts.paginate(page: params[:page])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      flash[:success] = t(:updated_success, model: Client.model_name.human)
      redirect_to clients_path
    else
      render 'edit'
    end
  end

  def destroy
    Client.find(params[:id]).destroy
    flash[:success] = t(:destroyed_success, model: Client.model_name.human)
    redirect_to clients_path
  end
end
