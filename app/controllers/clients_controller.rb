class ClientsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :new, :edit, :update, :destroy]
  
  def index
    @clients = Client.paginate(page: params[:page])
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def show
    @client = Client.find(params[:id])
  end
  
  def update    
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      flash[:success] = "Profile updated"      
      redirect_to @client
    else
      render 'edit'
    end
  end
  
  def destroy
    Client.find(params[:id]).destroy
    flash[:success] = "Client destroyed."
    redirect_to clients_url
  end
end
