class AdminsController < ApplicationController
  
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
  
end
