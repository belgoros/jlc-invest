class AdminsController < ApplicationController
  
  def index
    @admins = Admin.paginate(page: params[:page])    
  end
  
  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(params[:admin])
    if @admin.save
      sign_in @admin
      flash[:success] = "User created with success"
      redirect_to @admin
    else
      render "new"
    end
  end
  
  def show
    @admin = Admin.find(params[:id])
  end
  
  def edit
    @admin = Admin.find(params[:id])
  end
  
   def update
    @admin = Admin.find(params[:id])
    if @admin.update_attributes(params[:admin])
      flash[:success] = "Profile updated"
      sign_in @admin
      redirect_to @admin
    else
      render 'edit'
    end
  end
  
end
