class ClientsController < ApplicationController
  def index
    @clients = Client.paginate(page: params[:page])
  end

  def new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def show
  end
  
  def destroy
    Client.find(params[:id]).destroy
    flash[:success] = "Client destroyed."
    redirect_to clients_url
  end
end
