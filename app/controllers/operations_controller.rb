class OperationsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :new, :edit, :update, :destroy]
  before_filter :find_client, except: :index
  
  def index
    #@operations = Operation.unscoped.select("client_id, sum(total) as total").group("client_id").paginate(page: params[:page])
    @operations = Operation.unscoped.includes(:client).order("clients.lastname").select("client_id, sum(total) as total").group("client_id").paginate(page: params[:page])
  end  
  
  def new
    @operation = @client.operations.new
  end
  
  def create
    @operation = @client.operations.new(params[:operation])    
    if @operation.save
      flash[:success] = "Operation created with success"
      redirect_to @client
    else
      render "new"
    end    
  end  
  
  def edit
    @operation = @client.operations.find(params[:id])
  end
  
  def show
    @operation = @client.operations.find(params[:id])
  end

  def update
    @operation = @client.operations.find(params[:id])
    if @operation.update_attributes(params[:operation])
      flash[:success] = "Operation updated"
      redirect_to @client
    else
      render 'edit'      
    end    
  end

  def destroy
    @client.operations.find(params[:id]).destroy
    flash[:success] = "Operation destroyed."
    redirect_to @client
  end
  
  
  private
  def find_client
    @client = Client.find(params[:client_id])
  end
end
